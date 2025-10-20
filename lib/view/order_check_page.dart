import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k3register/component/order_list.dart';
import 'package:k3register/infrastructure/orders_repository.dart';
import 'package:k3register/model/order.dart';

class OrderCheckPage extends StatefulWidget {
  const OrderCheckPage({super.key});

  @override
  State<OrderCheckPage> createState() => _OrderCheckPageState();
}

class _OrderCheckPageState extends State<OrderCheckPage> {

  @override
  Widget build(BuildContext context) {
    // このページ全体をDefaultTabControllerで囲む
    return DefaultTabController(
      length: 2, // タブの数
      child: Scaffold(
        appBar: AppBar(
          title: const Text('注文確認'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: '調理待ち'),
              Tab(text: '呼び出し中'),
            ],
          ),
        ),
        body: const _OrderCheckBody(),
      ),
    );
  }
}

class _OrderCheckBody extends ConsumerWidget {
  const _OrderCheckBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ordersStreamProviderを監視してリアルタイムにデータを取得
    final ordersStream = ref.watch(ordersStreamProvider);

    return ordersStream.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('エラー: $err')),
      data: (orders) {
        // hasProvidedプロパティ（String型を想定）の値に基づいて注文を振り分ける
        final cookingOrders = orders.where((o) => o.hasProvided == 'waiting').toList();
        final callingOrders = orders.where((o) => o.hasProvided == 'calling').toList();

        // TabBarViewで各リストを表示
        return TabBarView(
          children: [
            OrderList(orders: cookingOrders),
            OrderList(orders: callingOrders),
          ],
        );
      },
    );
  }
}