import 'package:flutter/material.dart';

/// 2秒後に自動で閉じる成功ダイアログ
class AutoClosingSuccessDialog extends StatefulWidget {
  const AutoClosingSuccessDialog({super.key});

  @override
  State<AutoClosingSuccessDialog> createState() => _AutoClosingSuccessDialogState();
}

class _AutoClosingSuccessDialogState extends State<AutoClosingSuccessDialog> {
  @override
  void initState() {
    super.initState();
    // 2秒後にダイアログを閉じる
    Future.delayed(const Duration(seconds: 2), () {
      // ウィジェットがまだ画面に存在する場合のみpopを実行
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: Column(
        children: [
          Text('会計完了'),
          Icon(Icons.check_circle, color: Colors.green, size:50),
          SizedBox(width: 8),
        ],
      ),
      content: 
      Column(
        children: [
          Text('待ち番号'),
          Text('会計が完了しました。'),
        ],
      ),
    );
  }
}