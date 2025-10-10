import 'package:flutter/material.dart';
import 'package:k3register/model/cart_product.dart';

class TotalCounter extends StatelessWidget {
  // 1. 単一のCartProductではなく、List<CartProduct>を受け取るように変更
  final List<CartProduct> cartProducts;
  final int discountMoney;
  final int discountRatio;

  const TotalCounter(
      {super.key,
      required this.cartProducts,
      required this.discountMoney,
      required this.discountRatio});

  @override
  Widget build(BuildContext context) {

    final totalQuantity = cartProducts.fold<int>(0, (sum, item) => sum + item.quantity);
    final regularPrice = cartProducts.fold<int>(0, (sum, item) => sum + item.product.price * item.quantity);

    final int discountAmount =
        discountRatio > 0 ? discountMoney * (totalQuantity ~/ discountRatio) : 0;

    final int finalPrice = regularPrice - discountAmount;

    // スタイルを定義しておくと、一貫性のあるUIを保ちやすくなります。
    final labelStyle = Theme.of(context).textTheme.titleMedium;
    final valueStyle = Theme.of(context).textTheme.titleMedium;

    return Material(
      elevation: 8.0, // カートリストとの区別を明確にするための影
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("商品点数", style: labelStyle),
                Text("$totalQuantity 点", style: valueStyle),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("定価合計", style: labelStyle),
                Text("¥$regularPrice", style: valueStyle),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("割引額", style: labelStyle?.copyWith(color: Colors.red)),
                Text("-¥$discountAmount",
                    style: valueStyle?.copyWith(color: Colors.red)),
              ],
            ),
            const Divider(height: 24, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("合計金額",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold)),
                Text("¥$finalPrice",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: 会計処理のダイアログなどを表示
              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text("お会計", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}