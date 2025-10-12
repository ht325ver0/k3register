import 'package:flutter/material.dart';

/// より柔軟で高機能なキーパッドウィジェット
class Keypad extends StatelessWidget {
  final void Function(String) onKeyPressed;

  const Keypad({super.key, required this.onKeyPressed});

  @override
  Widget build(BuildContext context) {
    // POSレジで一般的な4列レイアウトに変更
    const keys = [
      '7', '8', '9', 'C',
      '4', '5', '6', '⌫', // Backspace
      '1', '2', '3', 'OK',
      '0', '00',
    ];

    return GridView.builder(
      // 親ウィジェットのサイズに合わせて描画する
      shrinkWrap: true,
      // スクロールを無効化
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // 4列のグリッド
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 1.5, // ボタンの縦横比を調整
      ),
      // 'OK'ボタンが縦に2スロット分、'0'と'00'の間に空きを作るため、アイテム数を調整
      itemCount: keys.length + 2,
      itemBuilder: (context, index) {
        // 'OK'ボタンの縦長表示のためのレイアウト調整
        if (index == 11) return const SizedBox.shrink(); // 'OK'ボタンの下半分
        if (index == 14) return const SizedBox.shrink(); // '00'の隣の空きスペース

        // インデックスの補正
        int keyIndex = index;
        if (keyIndex > 10) keyIndex--;
        if (keyIndex > 12) keyIndex--;

        final key = keys[keyIndex];

        // 'OK'ボタンは縦に長く表示
        if (key == 'OK') {
          return GridTile(
            child: _KeypadButton(
              label: '確定',
              onTap: () => onKeyPressed('OK'),
              backgroundColor: Colors.green,
              isLarge: true,
            ),
          );
        }

        // その他のボタン
        return _KeypadButton(
          label: key,
          onTap: () => onKeyPressed(key),
          // 機能キーは色を変えて分かりやすくする
          backgroundColor: (key == 'C' || key == '⌫')
              ? Colors.blueGrey[200]
              : Colors.white,
          textColor: Colors.black87,
        );
      },
    );
  }
}

/// キーパッドの各ボタンを表現する内部ウィジェット
class _KeypadButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isLarge;

  const _KeypadButton({
    required this.label,
    required this.onTap,
    this.backgroundColor,
    this.textColor,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
        foregroundColor: textColor ?? Theme.of(context).colorScheme.onSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.zero,
        // isLargeがtrueの場合、縦に2スロット分の高さを確保
        // GridTileと組み合わせることで実現
        minimumSize: isLarge ? const Size(double.infinity, 120) : null,
      ).copyWith(
        // 影を調整してフラットなデザインに近づける
        elevation: MaterialStateProperty.all(2.0),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
