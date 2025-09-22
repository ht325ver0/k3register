import 'package:flutter/material.dart';
import 'package:k3register/component/product_button.dart';
import 'package:k3register/model/product.dart';

const List<Product> mock_products = [
  Product(id:1,name:"もも",price: 100,taste: "甘口", quantity: 100,icon:Icons.kebab_dining),
  Product(id:2,name:"もも",price:100,taste:"中辛",quantity: 100,icon:Icons.kebab_dining),
  Product(id:3,name:"もも",price:100,taste:"辛口",quantity: 100,icon:Icons.kebab_dining),
  Product(id:4,name:"もも",price:100,taste:"デス",quantity: 100,icon: Icons.kebab_dining),
  Product(id:5,name:"皮",price:100,taste:"甘口",quantity:100,icon:Icons.kebab_dining),
  Product(id:6,name:"皮",price:100,taste:"中辛",quantity:100,icon:Icons.kebab_dining),
  Product(id:7,name:"皮",price:100,taste:"辛口",quantity:100,icon:Icons.kebab_dining),
  Product(id:8,name:"皮",price:100,taste:"デス",quantity:100,icon:Icons.kebab_dining),

];

class ProductGridButton extends StatelessWidget {
  const ProductGridButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 6, // 左側の領域の比率を6に設定
      child: GridView.count(
        crossAxisCount: 4,
        children: 
          mock_products.map((product){
            return ProductCard(product: product, onTap:()=>{});
          }).toList(),
      ),
    );
  }
}