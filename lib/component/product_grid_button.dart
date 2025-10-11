import 'package:flutter/material.dart';
import 'package:k3register/component/product_button.dart';
import 'package:k3register/model/product.dart';

final List<Product> mock_products = [
  Product(id:1,name:"もも",price: 100,taste: Taste.amakuchi, quantity: 100,icon:Icons.kebab_dining),
  Product(id:2,name:"もも",price:100,taste: Taste.chukara,quantity: 100,icon:Icons.kebab_dining),
  Product(id:3,name:"もも",price:100,taste: Taste.karakuchi,quantity: 100,icon:Icons.kebab_dining),
  Product(id:4,name:"もも",price:100,taste: Taste.death,quantity: 100,icon: Icons.kebab_dining),
  Product(id:5,name:"皮",price:100,taste: Taste.amakuchi,quantity:100,icon:Icons.kebab_dining),
  Product(id:6,name:"皮",price:100,taste: Taste.chukara,quantity:100,icon:Icons.kebab_dining),
  Product(id:7,name:"皮",price:100,taste: Taste.karakuchi,quantity:100,icon:Icons.kebab_dining),
  Product(id:8,name:"皮",price:100,taste: Taste.death,quantity:100,icon:Icons.kebab_dining),

];

class ProductGridButton extends StatelessWidget {
  const ProductGridButton({super.key});

  @override
  Widget build(BuildContext context) {
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
            return ProductCard(product: product, onTap:()=>{});
          }).toList(),
      ),
    );
  }
}