import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k3register/component/product_button.dart';
import 'package:k3register/provider/cart_provider.dart';
import 'package:k3register/provider/product_provider.dart';
import 'package:k3register/model/product.dart';


class ProductGridButton extends ConsumerWidget {
  final AsyncValue<List<Product>> products;

  const ProductGridButton({super.key, required this.products});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Expanded(
      flex: 6, // 左側の領域の比率を6に設定
      // AsyncValueの状態に応じてUIを切り替える
      child: products.when(
        // データ取得中のUI
        loading: () => const Center(child: CircularProgressIndicator()),
        // エラー発生時のUI
        error: (err, stack) => Center(child: Text('エラーが発生しました: $err')),
        // データ取得成功時のUI
        data: (products) => GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            childAspectRatio: 0.8,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(product: product, onTap: () => ref.read(cartProvider.notifier).addProduct(product));
          },
        ),
      ),
    );
  }
}