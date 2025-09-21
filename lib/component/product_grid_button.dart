import 'package:flutter/material.dart';

class ProductGridButton extends StatelessWidget {
  const ProductGridButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
            flex: 6, // 左側の領域の比率を6に設定
            child: GridView.count(
              crossAxisCount: 4,
              children: [
                Container(child: const Center(child: Text("1")), color: const Color.fromARGB(255, 222, 0, 0)),
                Container(child: const Center(child: Text("2")), color: const Color.fromARGB(255, 222, 0, 0)),
                Container(child: const Center(child: Text("3")), color: const Color.fromARGB(255, 222, 0, 0)),
                Container(child: const Center(child: Text("4")), color: const Color.fromARGB(255, 222, 0, 0)),
                Container(child: const Center(child: Text("5")), color: const Color.fromARGB(255, 222, 0, 0)),
                Container(child: const Center(child: Text("6")), color: const Color.fromARGB(255, 222, 0, 0)),

              ],
            ),
          );
  }
}