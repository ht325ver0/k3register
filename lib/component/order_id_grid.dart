import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k3register/model/order.dart'; // Orderモデルをインポート
import 'dart:async'; // Timerを使用するため (order-display-page.dartで使うが、念のため)


class OrderIdGrid extends ConsumerWidget {
  final int column;
  final List<Order> orders; // 注文リストを受け取る
  final Set<int> highlightedIds; // ハイライト対象のIDセット
  final double aspect;

  const OrderIdGrid({super.key, required this.column, required this.orders, this.highlightedIds = const {}, this.aspect = 1});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Expanded(
      child: GridView.count(
          crossAxisCount: column, // 1行に表示する数 (指定されたcolumnを使用)
          crossAxisSpacing: 4.0, // グリッドアイテム間の横スペース
          mainAxisSpacing: 4.0, // グリッドアイテム間の縦スペース
          childAspectRatio: aspect, // アイテムの縦横比を調整（例：少し縦長に）
          children: orders.map((order) { // ordersリストをマップしてGridTileを生成
            // order.idがnullでないことを確認
            if (order.id == null) return const SizedBox.shrink();
            final isHighlighted = highlightedIds.contains(order.id);
            return AnimatedContainer( // AnimatedContainerを使用
              duration: const Duration(milliseconds: 500), // アニメーション時間
              curve: Curves.easeInOut, // アニメーションカーブ
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isHighlighted
                    ? Colors.limeAccent // ハイライト色（非常に明るい）
                    : (order.hasProvided == 'waiting' ? Colors.blue.shade700 : Colors.deepOrange), // 通常色
                borderRadius: BorderRadius.circular(8.0), // 角を丸くする
              ),
              child: Text( // 注文IDを表示
                '${order.id}',
                style: TextStyle(
                  color: isHighlighted ? Colors.black87 : Colors.white, // ハイライト時は黒文字、通常は白文字
                  fontSize: 120,
                  fontWeight: FontWeight.bold
                ),
              )
            );
          }).toList(), // Mapの結果をListに変換
        ),
      );
  }
}