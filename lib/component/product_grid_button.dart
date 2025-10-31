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
          final partNames = groupedProducts.keys.toList()
            // parts_idに基づいて部位名をソートする
            ..sort((a, b) {
              // 各グループの最初の商品のparts_idを取得して比較する
              // parts_idが存在しない場合は大きな値を割り当てて末尾に配置
              final partsIdA = groupedProducts[a]?.first.id ?? 999;
              final partsIdB = groupedProducts[b]?.first.id ?? 999;
              return partsIdA.compareTo(partsIdB);
            });

          // ListViewを使って部位ごとにセクション分けして表示
          return ListView.builder(
            itemCount: partNames.length,
            itemBuilder: (context, index) {
              final partName = partNames[index];
              final productsByPart = groupedProducts[partName]!;
              // 味（Taste Enum）の定義順でソートする
              productsByPart.sort((a, b) {
                final tasteIndexA = a.taste?.index ?? 99; // tasteがない場合は末尾
                final tasteIndexB = b.taste?.index ?? 99;
                return tasteIndexA.compareTo(tasteIndexB);
              });
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 部位名のヘッダー
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
                    child: Text(
                      partName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  // 商品グリッド
                  GridView.builder(
                    shrinkWrap: true, // ListViewの中で使うため必須
                    physics: const NeverScrollableScrollPhysics(), // ListViewのスクロールと競合しないように
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5, // 1行に表示するカードの数を4に変更
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: 0.7, // カードの縦横比を調整
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