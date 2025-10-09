import 'package:flutter/material.dart';
import 'package:k3register/component/cart_card.dart';
import 'package:k3register/model/product.dart';
import 'package:k3register/model/cart_product.dart';

const List<Product> mock_products = [
  Product(id:1,name:"もも",price: 100,taste: Taste.amakuchi, quantity: 100,icon:Icons.kebab_dining),
  Product(id:2,name:"もも",price:100,taste: Taste.chukara,quantity: 100,icon:Icons.kebab_dining),
  Product(id:3,name:"もも",price:100,taste: Taste.karakuchi,quantity: 100,icon:Icons.kebab_dining),
  Product(id:4,name:"もも",price:100,taste: Taste.death,quantity: 100,icon: Icons.kebab_dining),
  Product(id:5,name:"皮",price:100,taste: Taste.amakuchi,quantity:100,icon:Icons.kebab_dining),
  Product(id:6,name:"皮",price:100,taste: Taste.chukara,quantity:100,icon:Icons.kebab_dining),
  Product(id:7,name:"皮",price:100,taste: Taste.karakuchi,quantity:100,icon:Icons.kebab_dining),
  Product(id:8,name:"皮",price:100,taste: Taste.death,quantity:100,icon:Icons.kebab_dining),
];

List<CartProduct> mock_cart = [
  CartProduct(product: mock_products[0], quantity: 1),
  CartProduct(product: mock_products[5], quantity: 2),
  CartProduct(product: mock_products[5], quantity: 2),
  CartProduct(product: mock_products[4], quantity: 2),
  CartProduct(product: mock_products[5], quantity: 2),
  CartProduct(product: mock_products[2], quantity: 10),
];


class CartList extends StatelessWidget {
  const CartList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: mock_cart.length,
        itemBuilder: (context, index) {
          return CartCard(cartProduct: mock_cart[index]);
        },
      );
  }
}