import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k3register/model/order.dart'; // Orderモデルをインポート
import 'dart:async'; // Timerを使用するため


class OrderIdGrid extends ConsumerWidget {
  final int column;
  final List<Order> orders; // 注文リストを受け取る
  final Set<int> highlightedIds; // ハイライト対象のIDセット

  const OrderIdGrid({super.key, required this.column, required this.orders, this.highlightedIds = const {}});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Expanded(
      child: GridView.count(
          crossAxisCount: column, // 1行に表示する数 (指定されたcolumnを使用)
          crossAxisSpacing: 4.0, // グリッドアイテム間の横スペース
          mainAxisSpacing: 4.0, // グリッドアイテム間の縦スペース
          children: orders.map((order) { // ordersリストをマップしてGridTileを生成
            return Container(
              // order.idがnullでないことを確認
              child: order.id == null
                  ? const SizedBox.shrink()
                  : AnimatedContainer( // AnimatedContainerを使用
                duration: const Duration(milliseconds: 500), // アニメーション時間
                curve: Curves.bounceInOut, // アニメーションカーブ
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: highlightedIds.contains(order.id)
                      ? Colors.yellow[600] // ハイライト色
                      : (order.hasProvided == 'waiting' ? Colors.blue : Colors.orange), // 通常色
                  borderRadius: BorderRadius.circular(8.0), // 角を丸くする
                ),
                child: Text( // 注文IDを表示
                  '${order.id}',
                  style: const TextStyle(color: Colors.white, fontSize: 60, fontWeight: FontWeight.bold),
                ),
              )
            );
          }).toList(), // Mapの結果をListに変換
        ),
      );
  }
}