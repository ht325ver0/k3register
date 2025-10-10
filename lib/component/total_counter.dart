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
    int regularPrice = 0;
    int totalQuantity = 0;

    for (final cartProduct in cartProducts) {
      regularPrice += cartProduct.product.price * cartProduct.quantity;
      totalQuantity += cartProduct.quantity;
    }

    final int discountAmount =
        discountRatio > 0 ? discountMoney * (totalQuantity ~/ discountRatio) : 0;

    final int finalPrice = regularPrice - discountAmount;

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("割引条件: ${discountRatio}個ごとに${discountMoney}円引き"),
          const SizedBox(height: 8),
          Text("商品点数: $totalQuantity 点"),
          Text("定価合計: ¥$regularPrice"),
          Text("割引額: -¥$discountAmount", style: const TextStyle(color: Colors.red)),
          const Divider(),
          Text("合計金額: ¥$finalPrice",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}