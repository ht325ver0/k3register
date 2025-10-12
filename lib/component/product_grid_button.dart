import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k3register/component/product_button.dart';
import 'package:k3register/mock_data/product_mock.dart';
import 'package:k3register/provider/cart_provider.dart';


class ProductGridButton extends ConsumerWidget {
  const ProductGridButton({super.key});

  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      flex: 6, // 左側の領域の比率を6に設定
      child: GridView.count(
        padding: const EdgeInsets.all(8.0), // グリッド全体に余白を追加
        crossAxisCount: 4, // 横方向のアイテム数
        mainAxisSpacing: 8.0, // 縦方向のアイテム間のスペース
        crossAxisSpacing: 8.0, // 横方向のアイテム間のスペース
        childAspectRatio: 0.8, // アイテムの縦横比 (幅1に対して高さ0.8)
        children:
          mock_products.map((product){
            return ProductCard(
              product: product, 
              onTap:()=> ref.read(cartProvider.notifier).addProduct(product)
            );
          }).toList(),
      ),
    );
  }
}