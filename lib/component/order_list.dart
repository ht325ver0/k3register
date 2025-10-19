import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k3register/component/order_product_card.dart';
import 'package:k3register/model/order.dart';


class OrderList extends ConsumerWidget {
  final List<Order> orders;

  const OrderList({super.key, required this.orders});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (orders.isEmpty) {
      return const Center(
        child: Text('注文はありません'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return OrderProductCard(order: orders[index]);
      },
    );
  }
}