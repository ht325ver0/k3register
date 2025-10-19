import 'package:flutter/foundation.dart';
import 'package:k3register/model/order.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'orders_repository.g.dart';

/// 注文リポジトリのインターフェース
abstract class IOrderRepository {
  /// 注文を保存する
  Future<void> saveOrder(Order order);
}

/// 注文データに関するデータアクセス層
class OrderRepository implements IOrderRepository {
  final _client = Supabase.instance.client;

  @override
  Future<void> saveOrder(Order order) async {
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
      await _client.rpc('create_order', params: params);
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