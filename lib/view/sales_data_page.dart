import 'package:flutter/material.dart';
import 'package:k3register/component/data_card.dart';

class SalesDataPage extends StatelessWidget {
  const SalesDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('売上データ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // 2列で表示
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1.5, // カードの縦横比
          children: const [
            DataCard(
              title: '売上総数',
              value: '100本',
              icon: Icons.kebab_dining,
              color: Colors.green,
            ),
            DataCard(
              title: '客数総数',
              value: '152人',
              icon: Icons.people,
              color: Colors.blue,
            ),
            DataCard(
              title: '平均客単価',
              value: '¥842',
              icon: Icons.monetization_on,
              color: Colors.orange,
            ),
            DataCard(
              title: '未提供の注文',
              value: '5件',
              icon: Icons.kitchen,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

}