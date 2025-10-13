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
      flex: 7, // 左側の領域の比率を6に設定
      // AsyncValueの状態に応じてUIを切り替える
      child: products.when(
        // データ取得中のUI
        loading: () => const Center(child: CircularProgressIndicator()),
        // エラー発生時のUI
        error: (err, stack) => Center(child: Text('エラーが発生しました: $err')),
        // データ取得成功時のUI
        data: (products){
          final groupedProducts = <String, List<Product>>{};
          for (var product in products) {
            (groupedProducts[product.name] ??= []).add(product);
          }
          final partNames = groupedProducts.keys.toList();

          // ListViewを使って部位ごとにセクション分けして表示
          return ListView.builder(
            itemCount: partNames.length,
            itemBuilder: (context, index) {
              final partName = partNames[index];
              final productsByPart = groupedProducts[partName]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 部位名のヘッダー
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Text(
                      partName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  // 商品グリッド
                  GridView.builder(
                    shrinkWrap: true, // ListViewの中で使うため必須
                    physics: const NeverScrollableScrollPhysics(), // ListViewのスクロールと競合しないように
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5, // 画面に合わせて調整
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: productsByPart.length,
                    itemBuilder: (context, gridIndex) {
                      final product = productsByPart[gridIndex];
                      return ProductCard(product: product, onTap: () => ref.read(cartProvider.notifier).addProduct(product));
                    },
                  ),
                  const Divider(height: 24),
                ],
              );
            },
          );
        }
      ),
    );
  }
}