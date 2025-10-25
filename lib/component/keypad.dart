import 'package:flutter/material.dart';

/// より柔軟で高機能なキーパッドウィジェット
class Keypad extends StatelessWidget {
  final void Function(String) onKeyPressed;

  const Keypad({super.key, required this.onKeyPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 左側: 数字キーパッド
        Expanded(flex: 3, child: _buildNumberKeypad()),
        const SizedBox(width: 10),
        // 右側: 金額ショートカットキー
        Expanded(flex: 2, child: _buildShortcutKeypad()),
      ],
    );
  }

  /// 数字キーパッド部分を構築する
  Widget _buildNumberKeypad() {
    const keys = [
      '7', '8', '9',
      '4', '5', '6',
      '1', '2', '3',
      '0', '00', '⌫',
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 1.5,
      ),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final key = keys[index];
        return _KeypadButton(
          label: key,
          onTap: () => onKeyPressed(key),
          backgroundColor: (key == '⌫') ? Colors.blueGrey[200] : Colors.white,
          textColor: Colors.black87,
        );
      },
    );
  }

  /// 金額ショートカットキー部分を構築する
  Widget _buildShortcutKeypad() {
    const shortcuts = ['C', 'ピッタリ', '1000', '500', '100', '50'];
    return Column (
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 1.5,
          ),
          itemCount: shortcuts.length,
          itemBuilder: (context, index) {
            final key = shortcuts[index];
            return _KeypadButton(
              label: key,
              onTap: () => onKeyPressed(key),
              backgroundColor: _getShortcutButtonColor(key),
              textColor: Colors.white,
            );
          },
        ),
        _KeypadButton( // isLargeフラグを追加して縦長のボタンにする
          label: 'OK',
          onTap: () => onKeyPressed('OK'),
          backgroundColor: _getShortcutButtonColor('OK'),
          textColor: Colors.white,
        ),
      ],
    );
  }

  /// ショートカットキーの色を決定するヘルパー関数
  Color? _getShortcutButtonColor(String key) {
    switch (key) {
      case 'OK':
        return Colors.green;
      case 'C':
        return Colors.redAccent;
      case 'ピッタリ':
        return const Color.fromARGB(255, 255, 151, 15);
      default:
        return Colors.blue;
    }
  }
}

/// キーパッドの各ボタンを表現する内部ウィジェット
class _KeypadButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? textColor;

  const _KeypadButton({
    required this.label,
    required this.onTap,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(100), // isLargeに応じて高さを変更
        backgroundColor:
            backgroundColor ?? Theme.of(context).colorScheme.surface,
        foregroundColor:
            textColor ?? Theme.of(context).colorScheme.onSurface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
      ).copyWith(
        // 影を調整してフラットなデザインに近づける
        elevation: MaterialStateProperty.all(2.0),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
