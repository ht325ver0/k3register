import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k3register/component/product_grid_button.dart';
import 'package:k3register/component/cart_list.dart';
import 'package:k3register/component/total_counter.dart';
import 'package:k3register/provider/cart_provider.dart';
import 'package:k3register/provider/product_provider.dart';
import 'package:k3register/view/accounting_page.dart';


class CashRegisterPage extends ConsumerWidget {
  const CashRegisterPage({super.key});

  static const int mockDiscountMoney = 50;
  static const int mockDiscountRatio = 3;


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartProducts = ref.watch(cartProvider);
    final cartProductsAsync = ref.watch(productsProvider);


    return Scaffold(
      appBar: AppBar(
        title: const Text('レジ画面'),
      ),
      body: Row(
        children: [
          ProductGridButton(products: cartProductsAsync),
          // ColumnをExpandedでラップして、利用可能な領域を確定させる
          Expanded(
            flex: 4, // 右側の領域の比率を4に設定
            child: Column(children: [
              // CartListを表示する領域をExpandedで確保
              Expanded(
                child: Container(
                  color: Colors.blueGrey[50], // 背景色を少し薄く調整
                  child: CartList(cartProducts: cartProducts),
                ),
              ),
              // 合計金額表示エリア
              TotalCounter(
                  cartProducts: cartProducts,
                  discountMoney: mockDiscountMoney,
                  discountRatio: mockDiscountRatio,
                  onCheckout: () {
                    if(cartProducts.isEmpty){
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("警告"),
                            content: const Text("商品がカートに入っていません"),
                            actions: [
                              TextButton(
                                child: const Text("OK"),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          );
                        },
                      );
                    }else{
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AccountingPage(),
                      ));
                    }
                  })
            ]),
          ),
        ],
      ));
  }
}