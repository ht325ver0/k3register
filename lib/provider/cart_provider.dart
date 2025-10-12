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

  void increment(CartProduct cartProduct) {
    state = [
      for (final item in state)
        if (item == cartProduct)
          item.copyWith(quantity: item.quantity + 1)
        else
          item,
    ];
  }

  void decrement(CartProduct cartProduct) {
    if (cartProduct.quantity > 1) {
      state = [
        for (final item in state)
          if (item == cartProduct)
            item.copyWith(quantity: item.quantity - 1)
          else
            item,
      ];
    } else {
      // 数量が1の時にdecrementしたら削除
      state = state.where((item) => item != cartProduct).toList();
    }
  }

  void remove(CartProduct cartProduct) {
    state = state.where((item) => item != cartProduct).toList();
  }


}