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
  // 一時的にハイライトする注文IDのセット
  Set<int> _highlightedIds = {};

  @override
  void initState() {
    super.initState();

    // Streamをリッスンして、新しく 'calling' になった注文を検出する
    ref.listenManual(ordersStreamProvider, (previous, next) {
      if (previous?.hasValue == true && next.hasValue) {
        final prevOrders = previous!.value!;
        final nextOrders = next.value!;

        final prevCallingIds = prevOrders.where((o) => o.hasProvided == 'calling').map((o) => o.id!).toSet();
        final nextCallingIds = nextOrders.where((o) => o.hasProvided == 'calling').map((o) => o.id!).toSet();

        // 新しく 'calling' になったIDを特定
        final newHighlights = nextCallingIds.difference(prevCallingIds);

        if (newHighlights.isNotEmpty && mounted) {
          setState(() {
            _highlightedIds.addAll(newHighlights); // 新しいハイライトを追加
          });
          // 数秒後にハイライトを解除するタイマーを設定
          for (final id in newHighlights) {
            Timer(const Duration(seconds: 3), () { // 3秒間ハイライト
              if (mounted) {
                setState(() => _highlightedIds.remove(id));
              }
            });
          }
        }
      }
    });
  }

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
        // お渡し待ちの注文をIDの降順でソート
        final callingOrders = orders.where((o) => o.hasProvided == 'calling').toList()
          ..sort((a, b) => b.id!.compareTo(a.id!)); // IDが大きい順にソート

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
                const Text("お渡し待ち", style: TextStyle(fontSize: 50)), // ref: を削除
                // callingOrdersとhighlightedIdsをOrderIdGridに渡す
                OrderIdGrid(column: 2, orders: callingOrders, highlightedIds: _highlightedIds),
              ],
            ),
          ),
        ]),
        );

      },
    );
  } // buildメソッドの閉じ括弧
}