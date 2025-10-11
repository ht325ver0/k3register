import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k3register/model/product.dart';
import 'package:k3register/model/cart_product.dart';


class NoteNotifer extends Notifier<List<CartProduct>>{
  @override
  List<CartProduct> build() {
    return [];
  }

  void add2Cart(Product product,int quantity) {
    state = [
      ...state,
      CartProduct(product: product, quantity: quantity),
    ];
  }

}
