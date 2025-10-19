import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k3register/model/order.dart';
import 'package:k3register/model/order_item.dart';
import 'package:k3register/provider/product_provider.dart';
import 'package:k3register/model/product.dart';

/// 1つの注文内容全体を表示するカード
class OrderProductCard extends ConsumerWidget {
  final Order order; // 表示する注文データ

  const OrderProductCard({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      // Card自体の角を丸くする
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      clipBehavior: Clip.antiAlias, // 子ウィジェットがはみ出さないようにする
      child: Column(
        children: [
          // --- 上部：注文番号ヘッダー ---
          // こちらはCardの丸みに沿う
          Container(
            color: Colors.blueGrey[50], // ヘッダーの背景色
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Text("注文番号", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(width: 8),
                Text(
                  order.id.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const Spacer(),
              ],
            ),
          ),
          // --- 下部：商品リスト ---
          // こちらは四角いまま
          ListView.builder(
            shrinkWrap: true, // Columnの中で使うため必須
            physics: const NeverScrollableScrollPhysics(), // 親のスクロールと競合させない
            itemCount: order.items.length,
            itemBuilder: (context, index) {
              final orderItem = order.items[index];
              return _OrderItemTile(orderItem: orderItem);
            },
          ),
        ],
      ),
    );
  }
}

/// 注文内の各商品を表示するための内部ウィジェット
class _OrderItemTile extends ConsumerWidget {
  final OrderItem orderItem;

  const _OrderItemTile({required this.orderItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsyncValue = ref.watch(productsProvider);
    return productsAsyncValue.when(
      data: (products) {
        final product = products.firstWhere(
          (p) => p.id == orderItem.productId,
        );

        if (product == null) {
          return ListTile(title: Text('商品ID: ${orderItem.productId} 不明'));
        }

        return Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey[200]!)),
          ),
          child: ListTile(
            leading: const Icon(Icons.fastfood_outlined),
            title: Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: product.taste != null && product.taste != Taste.none
                ? Text(product.taste!.displayName)
                : null,
            trailing: Text(
              'x ${orderItem.quantity}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        );
      },
      loading: () => const ListTile(title: Center(child: LinearProgressIndicator())),
      error: (e, st) => ListTile(title: Text('エラー: $e')),
    );
  }
}