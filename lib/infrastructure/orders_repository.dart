import 'package:flutter/foundation.dart';
import 'package:k3register/model/order.dart';
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

  @override
  Stream<List<Order>> fetchOrdersStream() {
    try {
      // 1. Supabaseのリアルタイムストリームを構築
      return _client
          .from('orders')
          .stream(primaryKey: ['id']) // 'id'を主キーとして変更を監視
          // .select() を削除。Supabaseがリレーションを元に自動でネストしてくれます。
          .eq('has_provided', false) // 3. 'has_provided'がfalseの注文のみに絞り込む
          .order('created_at', ascending: true) // 4. 作成日時が古い順に並び替え
          .map((listOfMaps) { // 5. 受け取ったデータを変換
        // Supabaseから返ってきたList<Map<String, dynamic>>を
        // List<Order>に変換する
        return listOfMaps.map((map) => Order.fromJson(map)).toList();
      });
    } catch (e) {
      debugPrint('Error fetching orders: $e');
      rethrow;
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