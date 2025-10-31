import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k3register/model/cart_product.dart';
import 'package:k3register/provider/cart_provider.dart';

class TotalCounter extends ConsumerWidget {
  // 1. 単一のCartProductではなく、List<CartProduct>を受け取るように変更
  final List<CartProduct> cartProducts;
  final VoidCallback onCheckout;

  const TotalCounter(
      {super.key,
      required this.cartProducts,
      required this.onCheckout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final totalQuantity = cartProducts.fold<int>(0, (sum, item) => sum + item.quantity);
    final regularPrice = ref.watch(regularCartTotalProvider);
    final totalAmount = ref.watch(cartTotalProvider(['もも', 'かわ', 'つくね']));

    // セット割引額を計算
    final int setDiscountAmount = regularPrice - totalAmount;
    
    // 適用されたセット数を計算
    final setCount = ref.read(cartProvider.notifier).calculateSetCount(['もも', 'かわ', 'つくね']);

    // スタイルを定義しておくと、一貫性のあるUIを保ちやすくなります。
    final labelStyle = Theme.of(context).textTheme.headlineSmall; // フォントサイズを大きく
    final valueStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold); // フォントサイズを大きく、太字に

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
                Text("合計本数", style: labelStyle),
                Text("$totalQuantity 本", style: valueStyle),
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
            // セット割引が適用されている場合のみ割引額を表示
            if (setDiscountAmount > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("セット割引 ($setCountセット分)", style: labelStyle?.copyWith(color: Colors.red)),
                  Text("-¥$setDiscountAmount",
                      style: valueStyle?.copyWith(color: Colors.red)),
                ],
              ),
            const Divider(height: 24, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("合計金額",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith( // フォントサイズを大きく
                        fontWeight: FontWeight.bold)),
                Text("¥$totalAmount",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith( // フォントサイズを大きく
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onCheckout,
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20)), 
              child: const Text("お会計", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}