import 'package:flutter/material.dart';

class CookTab extends StatelessWidget {
  const CookTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0, // 最初に表示するタブ
      length: 2, // タブの数
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ホーム'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: '調理待ち'),
              Tab(text: '呼び出し中'),
            ],
          ),
        ),
      ),
    );
  }

}