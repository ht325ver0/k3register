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

  int calculateSetCount(List<String> requiredParts) {
    // カート内の商品を部位名でグループ化し、それぞれの合計数量を計算
    final Map<String, int> cartPartCounts = {};
    for (final item in state) {
      cartPartCounts.update(
        item.product.name,
        (value) => value + item.quantity,
        ifAbsent: () => item.quantity,
      );
    }

    // 必要な部位が1つでもカートにない場合、セットは作れないので0を返す
    for (final part in requiredParts) {
      if (!cartPartCounts.containsKey(part)) {
        return 0;
      }
    }

    // セットを構成する部位の数量リストを作成
    final quantitiesForSet = requiredParts.map((part) => cartPartCounts[part]!).toList();

    // 数量リストの中で最も小さい値が、作れるセットの最大数になる
    // 例: もも(2), かわ(3), つくね(1) => 1セット
    // 例: もも(2), かわ(3), つくね(5) => 2セット
    return quantitiesForSet.fold(quantitiesForSet.first, (min, current) => min < current ? min : current);
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
    // 数量が1より大きい場合のみ、1減らす
    if (cartProduct.quantity > 1) {
      state = [
        for (final item in state)
          if (item == cartProduct)
            item.copyWith(quantity: item.quantity - 1)
          else
            item,
      ];
    }
  }

  void remove(CartProduct cartProduct) {
    state = state.where((item) => item != cartProduct).toList();
  }

  /// カートを空にする
  void clearCart() {
    state = [];
  }


}

/// カート内の商品の合計金額を計算するProvider
/// cartProviderの状態が変更されると、このProviderも自動的に再計算される
@riverpod
int cartTotal(CartTotalRef ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold<int>(0, (sum, item) => sum + item.product.price * item.quantity);
}