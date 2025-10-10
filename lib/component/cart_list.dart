import 'package:flutter/material.dart';
import 'package:k3register/component/cart_card.dart';
import 'package:k3register/model/product.dart';
import 'package:k3register/model/cart_product.dart';
import 'package:k3register/mock_data/product_mock.dart';
import 'package:k3register/mock_data/cart_mock.dart';


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