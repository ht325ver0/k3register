import 'package:flutter/material.dart';
import 'package:k3register/component/cart_card.dart';
import 'package:k3register/model/cart_product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k3register/provider/cart_provider.dart';



class CartList extends ConsumerWidget {
  final List<CartProduct> cartProducts;
  const CartList({super.key, required this.cartProducts});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartProducts = ref.watch(cartProvider);
    
    return ListView.builder(
        itemCount: cartProducts.length,
        itemBuilder: (context, index) {
          return CartCard(cartProduct: cartProducts[index]);
        },
      );
  }
}