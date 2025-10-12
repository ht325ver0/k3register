import 'package:k3register/model/cart_product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'cart_provider.g.dart';

@riverpod
class Cart extends _$Cart {
  @override
  List<CartProduct> build() => [];

  void addCart(CartProduct product) {
    state = [...state, product];
  }


}