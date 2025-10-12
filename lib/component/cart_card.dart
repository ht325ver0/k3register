import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k3register/model/product.dart';
import 'package:k3register/model/cart_product.dart';
import 'package:k3register/provider/cart_provider.dart';

/// 商品データを表現するクラス
class CartCard extends ConsumerWidget {
    
  // final VoidCallback onTap; // onTapはまだ使われていないので一旦コメントアウト
  final CartProduct cartProduct;


  const CartCard({super.key, required this.cartProduct});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return SizedBox(
      height: 100, // カードの高さを適切な値に調整
      child: Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          clipBehavior: Clip.antiAlias, // 子ウィジェットがカードの角をはみ出さないように設定
          elevation: 2.0, // カードの影の濃さ
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // カードの角を丸くする
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                // 商品名を左側に表示し、残りのスペースを埋める
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(cartProduct.product.name,
                        style: const TextStyle(fontSize: 16)),
                    if (cartProduct.product.taste != null &&
                        cartProduct.product.taste != Taste.none)
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Chip(
                          label: Text(
                            cartProduct.product.taste!.displayName,
                            style: TextStyle(
                                fontSize: 10,
                                color: cartProduct.product.taste!.textColor),
                          ),
                          backgroundColor:
                              cartProduct.product.taste!.backgroundColor,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                      )
                  ],
                )),
                // 数量を減らすボタン
                IconButton(
                  icon: const Icon(Icons.remove),
                  color: Colors.blue,
                  onPressed: () {
                    ref.read(cartProvider.notifier).decrement(cartProduct);
                  },
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[400], // colorをdecorationの中に移動
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('${cartProduct.quantity}',
                      style: const TextStyle(fontSize: 16)),
                ),
                // 数量を増やすボタン
                IconButton(
                  icon: const Icon(Icons.add),
                  color: Colors.pink,
                  // onPressedに空の関数を設定してボタンを有効化
                  onPressed: () {
                    ref.read(cartProvider.notifier).increment(cartProduct);
                  },
                ),
                const SizedBox(width: 16), // ボタン間のスペース
                // 削除ボタン
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.grey[600],
                  // onPressedに空の関数を設定してボタンを有効化
                  onPressed: () {
                    ref.read(cartProvider.notifier).remove(cartProduct);
                  },
                )
              ],
            ),
          )),
    );
  }
}