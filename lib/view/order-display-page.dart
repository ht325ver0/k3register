import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k3register/component/order_list.dart';
import 'package:k3register/infrastructure/orders_repository.dart';
import 'package:k3register/model/order.dart';
import 'package:k3register/component/order_id_grid.dart';

class OrderDisplayPage extends ConsumerStatefulWidget { // StatefulWidget -> ConsumerStatefulWidget
  const OrderDisplayPage({super.key});

  @override
  ConsumerState<OrderDisplayPage> createState() => _OrderDisplayPageState(); // State -> ConsumerState
}

class _OrderDisplayPageState extends ConsumerState<OrderDisplayPage> { // ConsumerStateを継承
  @override
  Widget build(BuildContext context) {
    // buildメソッド内でref.watchを呼び出す
    final ordersStream = ref.watch(ordersStreamProvider);

    return ordersStream.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('エラー: $err')),
      data: (orders) {
        // hasProvidedプロパティ（String型を想定）の値に基づいて注文を振り分ける
        final cookingOrders = orders.where((o) => o.hasProvided == 'waiting').toList();
        final callingOrders = orders.where((o) => o.hasProvided == 'calling').toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('オーダーディスプレイ'),
          ),
          body: Row(
            children: [
              // 左側のカラムをExpandedで囲む
              Expanded(
                flex: 20,
                child: Column(
                  // 左側のカラムの比率を2に設定
                  children: [
                    const Text("調理中", style: TextStyle(fontSize: 50)),
                    // cookingOrdersをOrderIdGridに渡す
                    OrderIdGrid(column: 5, orders: cookingOrders),
                  ],
                ),
              ),
          Spacer(flex: 1),
          // 右側のカラムをExpandedで囲む
          Expanded(
            flex: 10,
            child: Column( // 右側のカラムの比率を1に設定
              children: [
                const Text("お渡し待ち", style: TextStyle(fontSize: 50)),
                // callingOrdersをOrderIdGridに渡す
                OrderIdGrid(column: 2, orders: callingOrders), // ref: を削除
              ],
            ),
          ),
        ]),
        );

      },
    );
  } // buildメソッドの閉じ括弧
}