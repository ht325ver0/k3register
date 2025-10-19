import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k3register/model/order_item.dart';
import 'package:k3register/provider/product_provider.dart';

/// 商品データを表現するクラス
class OrderProductCard extends ConsumerWidget {
    
  // final VoidCallback onTap; // onTapはまだ使われていないので一旦コメントアウト
  final OrderItem orderItem;

  const OrderProductCard({super.key, required this.orderItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // productsProviderから全ての商品リストを取得
    final productsAsyncValue = ref.watch(productsProvider);

    return Card(
      // Cardの角を丸くする
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: productsAsyncValue.when(
        data: (products) {
          // orderItemのproductIdに一致する商品を探す
          final product = products.firstWhere(
            (p) => p.id == orderItem.productId,
            // 見つからなかった場合の代替表示
            orElse: () => null,
          );

          if (product == null) {
            return ListTile(title: Text('商品ID: ${orderItem.productId} 不明'));
          }

          return ListTile(
            leading: const Icon(Icons.fastfood_outlined, size: 40),
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
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => ListTile(title: Text('エラー: $e')),
      ),
    );
  }
}