import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k3register/component/product_button.dart';
import 'package:k3register/provider/cart_provider.dart';
import 'package:k3register/provider/product_provider.dart';
import 'package:k3register/model/product.dart';


class OrderIdGrid extends ConsumerWidget {
  final int column;

  const OrderIdGrid({super.key, required this.column});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Expanded(
      child: GridView.count(
          crossAxisCount: column, // 1行に表示する数
          crossAxisSpacing: 4.0, // 縦スペース
          mainAxisSpacing: 4.0, // 横スペース
          children: List.generate(120, (index) {
            return Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child:GridTile(
                child: Center(
                  child: Text(
                    '$index',
                    style: const TextStyle(color: Colors.white, fontSize: 60),
                  ),
                )
              )
            );
          }),
        ),
      );
  }
}