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
        Expanded(flex: 1, child: _buildShortcutKeypad()),
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
        mainAxisSpacing: 10.0,
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
    const shortcuts = ['C', '1000', '500', '100', '50', 'ピッタリ', 'OK'];
    return Column(
      children: shortcuts.map((key) {
        // OKボタンだけ縦に長くする
        // Expandedの代わりにSizedBoxで高さを指定する
        return SizedBox(
          height: 60, // ボタンの高さを固定値で指定
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: SizedBox.expand( // 親のサイズいっぱいに広がる
              child: _KeypadButton(
                label: key,
                onTap: () => onKeyPressed(key),
                backgroundColor: _getShortcutButtonColor(key),
                textColor: Colors.white,
              ),
            ),
          ),
        );
      }).toList(),
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
        return Colors.orange;
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
        minimumSize: const Size.fromHeight(50), // ボタンの最小高さを設定
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
        foregroundColor: textColor ?? Theme.of(context).colorScheme.onSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.zero,
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
