import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k3register/component/order_list.dart';
import 'package:k3register/infrastructure/orders_repository.dart';
import 'package:k3register/model/order.dart';
import 'package:k3register/component/order_id_grid.dart';

class OrderDisplayPage extends StatefulWidget {
  const OrderDisplayPage({super.key});

  @override
  State<OrderDisplayPage> createState() => _OrderDisplayPageState();
}

class _OrderDisplayPageState extends State<OrderDisplayPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('オーダーディスプレイ'),  
      ),
      body:Row(
        children: [
          // 左側のカラムをExpandedで囲む
          Expanded(
            child: Column(
              children: [
                Text("調理中"),
                OrderIdGrid()
              ],
            ),
          ),
          // 右側のカラムをExpandedで囲む
          Expanded(
            child: Column(
              children: [
                Text("お渡し待ち"),
                OrderIdGrid()
              ],
            ),
          ),
        ],
      )
    );
  }
}

    
