import 'package:k3register/model/cart_product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:k3register/model/product.dart';


part 'cart_provider.g.dart';

@riverpod
class Cart extends _$Cart {
  @override
  List<CartProduct> build() => [];

  /// 商品をカートに追加する（すでにあれば数量を増やし、なければ新規追加）
  void addProduct(Product product) {
    // state（現在のカートリスト）から、同じ商品（idとtasteが一致）を探す
    final index = state.indexWhere((item) => item.product.id == product.id && item.product.taste == product.taste);

    // ▼▼▼ ここが「もし押した商品がカートの中にあるなら」のif文です ▼▼▼
    if (index != -1) {
      // カートに同じ商品があった場合：数量を1増やす
      final existingItem = state[index];
      increment(existingItem);
    } else {
      // カートに同じ商品がなかった場合：新しい商品として追加する
      state = [...state, CartProduct(product: product, quantity: 1)];
    }
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