import 'package:flutter/material.dart';
import 'package:k3register/component/order_list.dart';
import 'package:k3register/model/order.dart';

class CookTab extends StatelessWidget {
  final List<Order> cookingOrders;
  final List<Order> callingOrders;

  const CookTab({
    super.key,
    required this.cookingOrders,
    required this.callingOrders,
  });

  @override
  Widget build(BuildContext context) {
    // Scaffoldを削除し、TabBarViewを返す
    return TabBarView(
      children: <Widget>[
        // 「調理待ち」タブの中身
        OrderList(orders: cookingOrders),
        // 「呼び出し中」タブの中身
        OrderList(orders: callingOrders),
      ],
    );
  }
}