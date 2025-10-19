import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k3register/component/cook_tab.dart';
import 'package:k3register/component/order_product_card.dart';
import 'package:k3register/model/order_item.dart';
import 'package:k3register/model/order.dart';

class OrderCheckPage extends StatefulWidget {
  const OrderCheckPage({super.key});

  @override
  State<OrderCheckPage> createState() => _OrderCheckPageState();
}

class _OrderCheckPageState extends State<OrderCheckPage> {

  // late StreamSubscription<Object> subscription;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // CookTabが利用可能なスペース全体を占めるようにExpandedで囲む
          const Expanded(child: CookTab()),
          // OrderProductCardに渡すためのモックデータを作成
          const OrderProductCard(
            order: Order(
              id: 99, // 仮の注文ID
              totalPrice: 1500,
              items: [
                // 注文に含まれる商品リスト
                OrderItem(productId: 1, quantity: 2, price: 500),
                OrderItem(productId: 3, quantity: 1, price: 500),
              ],
            ),
          )
        ],
      )
    );
  }

}