import 'package:flutter/material.dart';
import 'package:k3register/component/product_grid_button.dart';
import 'package:k3register/component/cart_list.dart';
import 'package:k3register/component/total_counter.dart';
import 'package:k3register/mock_data/cart_mock.dart';

class CashRegisterPage extends StatelessWidget {
  const CashRegisterPage({super.key});

  static int mockDiscountMoney = 50;
  static int mockDiscountRatio = 3;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const ProductGridButton(),
          // ColumnをExpandedでラップして、利用可能な領域を確定させる
          Expanded(
            flex: 4, // 右側の領域の比率を4に設定
            child: Column(children: [
              // CartListを表示する領域をExpandedで確保
              Expanded(
                child: Container(
                  color: Colors.blueGrey[50], // 背景色を少し薄く調整
                  child: const CartList(),
                ),
              ),
              // 合計金額表示エリア
              TotalCounter(
                  cartProducts: mock_cart,
                  discountMoney: mockDiscountMoney,
                  discountRatio: mockDiscountRatio)
            ]),
          ),
        ],
      ));
  }
}