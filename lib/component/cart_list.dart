import 'package:flutter/material.dart';
import 'package:k3register/component/cart_card.dart';
import 'package:k3register/model/cart_product.dart';




class CartList extends StatelessWidget {
  final List<CartProduct> cartProducts;
  const CartList({super.key, required this.cartProducts});

  @override
  Widget build(BuildContext context) {
    
    return ListView.builder(
        itemCount: cartProducts.length,
        itemBuilder: (context, index) {
          return CartCard(cartProduct: cartProducts[index]);
        },
      );
  }
}