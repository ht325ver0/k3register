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
}

/// 注文データに関するデータアクセス層
class OrderRepository implements IOrderRepository {
  final _client = Supabase.instance.client;

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