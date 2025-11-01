

import 'package:flutter/material.dart';

class AmountCard extends StatelessWidget{
  final int amount;
  final String title;
  final Color? color;

  const AmountCard({
    super.key,
    required this.amount,
    required this.title,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0, // 少し影を強調
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // 角を丸く
        side: BorderSide(color: Colors.blueGrey.shade200, width: 1.0), // 枠線を追加
      ),
      color: color ?? Colors.white, // nullなら白をデフォルトとして使用
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 20.0), // 内部パディングを少し詰める
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 左右に配置
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.normal, // ラベルは通常ウェイト
                color: Colors.black87,
              ),
            ),
            Text(
              '¥$amount',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold, // 太字
                color: amount < 0 ? Colors.red : Theme.of(context).primaryColor, 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
