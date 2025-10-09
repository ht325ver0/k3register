import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k3register/model/product.dart';
import 'package:k3register/model/cart_product.dart';


final cartProvider = StateProvider<List<CartProduct>>((ref) {
  return [];
});