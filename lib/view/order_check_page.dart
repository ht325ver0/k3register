import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k3register/component/cook_tab.dart';

class OrderCheckPage extends StatefulWidget {
  const OrderCheckPage({super.key});

  @override
  State<OrderCheckPage> createState() => _OrderCheckPageState();
}

class _OrderCheckPageState extends State<OrderCheckPage> {

  late StreamSubscription<Object> subscription;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // CookTabが利用可能なスペース全体を占めるようにExpandedで囲む
          const Expanded(child: CookTab()),
          
        ],
      )
    );
  }

}