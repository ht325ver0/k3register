import 'package:flutter/material.dart';

/// 2秒後に自動で閉じる成功ダイアログ
class AutoClosingSuccessDialog extends StatefulWidget {
  final int orderId;

  const AutoClosingSuccessDialog({super.key, required this.orderId});

  @override
  State<AutoClosingSuccessDialog> createState() => _AutoClosingSuccessDialogState();
}

class _AutoClosingSuccessDialogState extends State<AutoClosingSuccessDialog> {
  @override
  Widget build(BuildContext context) {
    // AlertDialogのコンテンツをSizedBoxで囲み、サイズを指定する
    return AlertDialog(
      // shapeで角を丸くすると、よりモダンな見た目になります
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      // titleとcontentを一つのColumnにまとめる
      content: SizedBox(
        width: 300, // ダイアログの幅を指定
        child: Column(
          mainAxisSize: MainAxisSize.min, // Columnの高さをコンテンツに合わせる
          children: [
            const SizedBox(height: 16),
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 16),
            Text('会計完了', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text('会計が完了しました。'),
            const SizedBox(height: 24),
            const Text('待ち番号', style: TextStyle(color: Colors.grey)),
            // 受け取った注文IDを表示する
            Text(widget.orderId.toString(), style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('この番号の番号札を渡してください', style: TextStyle(color: Colors.grey))
            
          ],
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('OK'),
          ),
      ],
    );
  }
}