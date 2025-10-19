import 'package:flutter/foundation.dart';
import 'package:k3register/model/order.dart';
import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


part 'orders_repository.g.dart';

/// 注文リポジトリのインターフェース
abstract class IOrderRepository {
  /// 注文を保存する
  /// 成功した場合、注文IDを返す
  Future<int> saveOrder(Order order);

  /// 未提供の注文リストをストリームで取得する
  Stream<List<Order>> fetchOrdersStream();
}

/// 注文データに関するデータアクセス層
class OrderRepository implements IOrderRepository {
  final _client = Supabase.instance.client;

  /// has_providedがfalseの注文リスト（関連アイテム付き）を一度だけ取得する内部メソッド
  Future<List<Order>> _fetchCurrentOrders() async {
    // .selectで関連テーブルのデータを一緒に取得
    final response = await _client
        .from('orders')
        .select('*, order_items(*)')
        .eq('has_provided', false)
        .order('created_at', ascending: true);

    // 取得した生データを出力して確認
    debugPrint('--- Fetched data from Supabase ---');
    debugPrint(response.toString());

    final List<Order> orders = [];
    for (final map in response) {
      try {
        orders.add(Order.fromJson(map as Map<String, dynamic>));
      } catch (e, stackTrace) {
        // エラーが発生したデータと詳細なエラー内容を出力
        debugPrint('==== JSON-to-Order Conversion Error ====');
        debugPrint('Failed to parse the following map:');
        debugPrint(map.toString());
        debugPrint('Error: $e');
        debugPrint('StackTrace: $stackTrace');
        // エラーがあっても処理を続行させたい場合はこのまま、
        // エラーで処理を中断させたい場合は rethrow; をアンコメントする
        // rethrow;
      }
    }
    return orders;
  }

  @override
  Stream<List<Order>> fetchOrdersStream() {
    // 1. Streamのコントローラーを作成
    final controller = StreamController<List<Order>>();

    // 2. まず最初に現在の注文リストを取得してStreamに流す
    _fetchCurrentOrders().then((orders) {
      if (!controller.isClosed) {
        controller.add(orders);
      }
    }).catchError((e, st) {
      if (!controller.isClosed) {
        controller.addError(e, st);
      }
    });

    // 3. 'orders'テーブルの変更を監視するチャンネルを購読
    final channel = _client
        .channel('public:orders')
        .onPostgresChanges(
          event: PostgresChangeEvent.all, // すべての変更（INSERT, UPDATE, DELETE）を監視
          schema: 'public',
          table: 'orders',
          callback: (payload) {
            debugPrint('Order table changed: ${payload.toString()}');
            // 変更があったら、再度全件取得してStreamに流す
            _fetchCurrentOrders().then((orders) => controller.add(orders));
          },
        ).subscribe();

    // 4. このStreamの監視が終了したら、Supabaseのチャンネルも閉じる
    controller.onCancel = () {
      _client.removeChannel(channel);
    };

    return controller.stream;
  }


  @override
  Future<int> saveOrder(Order order) async {
    try {
      // OrderItemのリストを、Supabaseの関数が受け取れるJSON形式のリストに変換
      // OrderItem.toJson() はfreezedによって自動生成される
      final itemsJson = order.items.map((item) => item.toJson()).toList();

      final params = {
        'client_total': order.totalPrice,
        'order_items_data': itemsJson,
      };

      // 送信するデータをコンソールに出力して確認
      debugPrint('--- Sending data to Supabase ---');
      debugPrint(params.toString());

       // SupabaseのRPC（データベース関数）を呼び出す
      final result = await _client.rpc('create_order', params: params);

      // rpcの戻り値がintであることを確認してから返す
      if (result is int) {
        return result;
      } else {
        // 予期しない型が返ってきた場合は、より詳細な情報を含む例外をスローする
        throw Exception(
            'create_order RPC returned an unexpected type. Expected int, but got ${result.runtimeType}. Value: $result');
      }

    } catch (e) {
      debugPrint('Error saving order: $e');
      // エラーを呼び出し元に伝えるために再スローする
      rethrow;
    }
  }
}

// OrderRepositoryのインスタンスをDIするためのProvider
@riverpod
IOrderRepository orderRepository(OrderRepositoryRef ref) {
  return OrderRepository();
}

/// 未提供の注文リストをストリームで提供するProvider
@riverpod
Stream<List<Order>> ordersStream(OrdersStreamRef ref) {
  return ref.read(orderRepositoryProvider).fetchOrdersStream();
}