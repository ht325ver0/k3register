import 'package:flutter/material.dart';
import 'package:k3register/component/product_grid_button.dart';

class CashRegisterPage extends StatelessWidget {
  const CashRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
          children: [
          const ProductGridButton(),
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.blueGrey,
              child: const Center(child: Text('右側のコンテンツ')),
            ),
          ),
        ],
      ));
  }
}