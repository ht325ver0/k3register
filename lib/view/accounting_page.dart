import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k3register/component/amount_card.dart';
import 'package:k3register/component/cart_list.dart';
import 'package:k3register/provider/cart_provider.dart';
import 'package:k3register/component/keypad.dart';
import 'package:k3register/infrastructure/orders_repository.dart';
import 'package:k3register/model/order_item.dart';
import 'package:k3register/model/order.dart';
import 'package:k3register/component/auto_closing_success_dialog.dart';

class AccountingPage extends ConsumerStatefulWidget {
  const AccountingPage({super.key});

  @override
  ConsumerState<AccountingPage> createState() => _AccountingPageState();
}

class _AccountingPageState extends ConsumerState<AccountingPage> {
  String _displayValue = '';

  void onKeyPressed(String value,int totalAmount) {
    const shortcuts = ['1000', '500', '100', '50'];
    setState(() {
      if (value == 'C') {
        _displayValue = '';
      } else if (value == '⌫') {
        if (_displayValue.isNotEmpty) {
          _displayValue = _displayValue.substring(0, _displayValue.length - 1);
        }
      } else if (value == 'OK') {
        // 確定処理を呼び出す
        _handleCheckout();
      } else if (value == 'ピッタリ') {
        _displayValue = totalAmount.toString();
      } else if (shortcuts.contains(value)) {
        _displayValue = value;
      } else {
        if (_displayValue.length < 9) {
          _displayValue += value;
        }
      }
    });
  }

  Future<int?> submitOrder() async {
    final cart = ref.read(cartProvider);
    final totalAmount = ref.read(cartTotalProvider);

    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('カートが空です')));
      return null;
    }

    // Orderオブジェクトを作成
    final order = Order(
      totalPrice: totalAmount,
      items: cart
          .map((cartProduct) => OrderItem( // CartProductからOrderItemに変換
                productId: cartProduct.product.id,
                quantity: cartProduct.quantity,
                price: cartProduct.product.price, // 販売時点の単価を記録
              ))
          .toList(),
    );

    try {
      // Repositoryを呼び出して注文を保存
      final orderId = await ref.read(orderRepositoryProvider).saveOrder(order);
      return orderId;
    } catch (e) {
      // エラー処理
      // エラーの詳細はリポジトリ層でデバッグ出力されている
      return null;
    }
  }

  /// 会計確定処理
  Future<void> _handleCheckout() async {
    // UIの操作を無効にするなど、ローディング表示をここに入れるとより親切
    final orderId = await submitOrder();

    if (!mounted) return;

    if (orderId != null) {
      // 成功ダイアログ
      // ダイアログが閉じられた後に後続処理を実行
      await showDialog(
        context: context,
        barrierDismissible: false, // ダイアログの外側をタップしても閉じない
        builder: (context) => AutoClosingSuccessDialog(orderId: orderId),
      );
      // ダイアログが閉じた後にカートをクリアし、最初の画面に戻る
      ref.read(cartProvider.notifier).clearCart();
      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      // 失敗ダイアログ
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('エラー'),
          content: const Text('注文の処理に失敗しました。ネットワーク接続を確認して再度お試しください。'),
          actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK'))],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final totalAmount = ref.watch(cartTotalProvider);
    final receivedAmount = int.tryParse(_displayValue) ?? 0;
    final change = receivedAmount - totalAmount;



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
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [ // 金額表示のフォントサイズを大きく
                  AmountCard(amount: totalAmount, title: '合計金額', color: Colors.white),
                  const Divider(height: 10),
                  // お預かり金額カード
                  AmountCard(amount: receivedAmount, title: 'お預かり', color: Colors.blue[50] ?? Colors.blue.shade50),
                  AmountCard(amount: change, title: 'お釣り', color: Colors.green[50] ?? Colors.green.shade50),
                  const Spacer(flex: 3),
                  Keypad(onKeyPressed: (value) => onKeyPressed(value, totalAmount)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}