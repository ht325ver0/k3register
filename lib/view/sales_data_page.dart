import 'package:flutter/material.dart';

class SalesDataPage extends StatelessWidget {
  const SalesDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('売上データ'),
      ),
      body: const Center(
        child: Text('売上データが表示されます'),
      ),
    );
  }

}