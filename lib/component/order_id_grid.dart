import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k3register/component/product_button.dart';
import 'package:k3register/provider/cart_provider.dart';
import 'package:k3register/provider/product_provider.dart';
import 'package:k3register/model/product.dart';
import 'package:k3register/model/order.dart'; // Orderモデルをインポート


class OrderIdGrid extends ConsumerWidget {
  final int column;
  final List<Order> orders; // 注文リストを受け取る

  const OrderIdGrid({super.key, required this.column, required this.orders});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Expanded(
      child: GridView.count(
          crossAxisCount: column, // 1行に表示する数 (指定されたcolumnを使用)
          crossAxisSpacing: 4.0, // グリッドアイテム間の横スペース
          mainAxisSpacing: 4.0, // グリッドアイテム間の縦スペース
          children: orders.map((order) { // ordersリストをマップしてGridTileを生成
            return Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: order.hasProvided == 'waiting' ? Colors.blue : Colors.orange, // 状態によって色を変える例
                borderRadius: BorderRadius.circular(8.0), // 角を丸くする
              ),
              child:GridTile(
                child: Center(
                  child: Text( // 注文IDを表示
                    '${order.id}',
                    style: const TextStyle(color: Colors.white, fontSize: 60),
                  ),
                )
              )
            );
          }).toList(), // Mapの結果をListに変換
        ),
      );
  }
}