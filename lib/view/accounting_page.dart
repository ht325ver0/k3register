import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k3register/component/cart_list.dart';
import 'package:k3register/provider/cart_provider.dart';
import 'package:k3register/component/keypad.dart';

class AccountingPage extends ConsumerStatefulWidget {
  const AccountingPage({super.key});

  @override
  ConsumerState<AccountingPage> createState() => _AccountingPageState();
}

class _AccountingPageState extends ConsumerState<AccountingPage> {
  String _displayValue = '';

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final totalAmount = cart.fold<int>(0, (sum, item) => sum + item.product.price * item.quantity);
    final receivedAmount = int.tryParse(_displayValue) ?? 0;
    final change = receivedAmount - totalAmount;

    void onKeyPressed(String value) {
      setState(() {
        if (value == 'C') {
          _displayValue = '';
        } else if (value == '⌫') {
          if (_displayValue.isNotEmpty) {
            _displayValue = _displayValue.substring(0, _displayValue.length - 1);
          }
        } else if (value == 'OK') {
          // TODO: 確定処理
          print('確定: $_displayValue');
        } else {
          if (_displayValue.length < 9) {
            _displayValue += value;
          }
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('お会計'),
      ),
      body: Row(
        children: [
          // 左側: カートの中身
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Expanded(child: CartList(cartProducts: cart)),
                // TODO: ここに合計金額表示ウィジェットを配置
              ],
            ),
          ),
          // 右側: キーパッドと金額表示
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text('合計: ¥$totalAmount', style: Theme.of(context).textTheme.headlineSmall),
                  const Divider(height: 32),
                  Text('お預かり: ¥$receivedAmount', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.blue)),
                  Text('お釣り: ¥${change > 0 ? change : 0}', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.green)),
                  const Spacer(),
                  Keypad(onKeyPressed: onKeyPressed),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}