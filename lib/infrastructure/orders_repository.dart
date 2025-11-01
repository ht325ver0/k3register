import 'package:flutter/foundation.dart';
import 'package:k3register/model/order.dart';
import 'package:k3register/model/sales_summary.dart';
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

  /// 注文の状態を更新する
  Future<void> updateOrderState(int id, String newState);

  /// 指定した日付の売上サマリーを取得する
  Future<SalesSummary> fetchSalesSummaryByDate(DateTime date);
}

/// 注文データに関するデータアクセス層
class OrderRepository implements IOrderRepository {
  final _client = Supabase.instance.client;

  @override
  Future<void> updateOrderState(int id, String newState) async {
    try {
      // newStateには 'calling' や 'completed' などの文字列が入る
      await _client.from('orders').update({'has_provided': newState}).eq('id', id);
    } catch (e) {
      debugPrint('Error updating order state: $e');
      rethrow;
    }
  }

  /// has_providedがfalseの注文リスト（関連アイテム付き）を一度だけ取得する内部メソッド
  Future<List<Order>> _fetchCurrentOrders() async {
    // .selectで関連テーブルのデータを一緒に取得
    final response = await _client
        .from('orders')
        .select('*, order_items(*)')
        .filter('has_provided', 'in', ['waiting', 'calling']) // 'in_' の代わりに 'filter' を使用
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
  Future<SalesSummary> fetchSalesSummaryByDate(DateTime date) async {
    try {
      // DateTimeを 'YYYY-MM-DD' 形式の文字列に変換
      final dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      debugPrint(dateString);

      final result = await _client.rpc(
        'get_sales_summary_by_date',
        params: {'target_date': dateString},
      );

      debugPrint('--- fetch sales summary by date---');
      debugPrint(result.toString());

      if (result is List && result.isNotEmpty) {
        // データベースから返されたJSONをSalesSummaryオブジェクトに変換
        final json = result.first as Map<String, dynamic>;
        // RPCの結果には日付が含まれないため、ここで追加する
        json['date'] = date.toIso8601String();
        return SalesSummary.fromJson(json);
      }
      // 結果が空の場合は、ゼロのサマリーを返す
      return SalesSummary(date: date);
    } catch (e) {
      debugPrint('Error fetching sales summary by date: $e');
      rethrow;
    }
  }

  @override
  Stream<List<Order>> fetchOrdersStream() {
    // 1. Streamのコントローラーを作成
    final controller = StreamController<List<Order>>.broadcast();

    // 現在の注文リストを保持する変数
    List<Order> currentOrders = [];

    // 2. まず最初に現在の注文リストを取得してStreamに流す
    _fetchCurrentOrders().then((orders) {
      if (!controller.isClosed) {
        currentOrders = orders..sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
        controller.add(currentOrders);
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
          callback: (payload) async {
            debugPrint('Order table changed: ${payload.toString()}');

            final eventType = payload.eventType;
            Map<String, dynamic>? record;

            if (eventType == PostgresChangeEvent.insert || eventType == PostgresChangeEvent.update) {
              record = payload.newRecord;
            } else if (eventType == PostgresChangeEvent.delete) {
              record = payload.oldRecord;
            }

            if (record == null || record['id'] == null) return;

            final orderId = record['id'] as int;
            var updatedOrders = List<Order>.from(currentOrders);

            if (eventType == PostgresChangeEvent.insert) {
              // 新規注文の場合、その注文だけを再取得してリストに追加
              final newOrder = await _fetchOrderById(orderId);
              if (newOrder != null) {
                updatedOrders.add(newOrder);
              }
            } else if (eventType == PostgresChangeEvent.update) {
              // 注文更新の場合、その注文だけを再取得
              final updatedOrder = await _fetchOrderById(orderId);
              final index = updatedOrders.indexWhere((o) => o.id == orderId);

              if (updatedOrder != null && ['waiting', 'calling'].contains(updatedOrder.hasProvided)) {
                // 'waiting' or 'calling' ならリストを更新
                if (index != -1) {
                  updatedOrders[index] = updatedOrder;
                } else {
                  updatedOrders.add(updatedOrder);
                }
              } else if (index != -1) {
                // 'completed' などになった場合はリストから削除
                updatedOrders.removeAt(index);
              }
            } else if (eventType == PostgresChangeEvent.delete) {
              // 削除された場合はリストから削除
              updatedOrders.removeWhere((o) => o.id == orderId);
            }

            // ソートしてStreamに流し、現在のリストを更新する
            updatedOrders.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
            currentOrders = updatedOrders;
            controller.add(updatedOrders);
          },
        ).subscribe();

    // 4. このStreamの監視が終了したら、Supabaseのチャンネルも閉じる
    controller.onCancel = () {
      _client.removeChannel(channel);
    };

    return controller.stream;
  }

  /// IDを指定して単一の注文（関連アイテム付き）を取得する内部メソッド
  Future<Order?> _fetchOrderById(int id) async {
    try {
      final response = await _client
          .from('orders')
          .select('*, order_items(*)')
          .eq('id', id)
          .single();
      return Order.fromJson(response);
    } catch (e) {
      debugPrint('Error fetching order by ID $id: $e');
      return null;
    }
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