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
import 'package:k3register/model/product.dart';


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
        // ショートカットキーが押された場合、現在の値に加算する
        final currentAmount = int.tryParse(_displayValue) ?? 0;
        final shortcutAmount = int.tryParse(value) ?? 0;
        final newAmount = currentAmount + shortcutAmount;
        _displayValue = newAmount.toString();
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
    final cart = ref.read(cartProvider);
    final totalAmount = ref.read(cartTotalProvider);
    final receivedAmount = int.tryParse(_displayValue) ?? 0;
    final change = receivedAmount - totalAmount;

    // お預かり金額が足りない場合はエラーダイアログを表示
    if (receivedAmount < totalAmount) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('エラー'),
          content: const Text('お預かり金額が合計金額に足りていません。'),
          actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK'))],
        ),
      );
      return; // 処理を中断
    }

    // 確認ダイアログを表示し、ユーザーの選択を待つ
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // ダイアログの外側をタップしても閉じない
      builder: (context) => AlertDialog(
        titleTextStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('会計内容の確認'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('【注文内容】', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            // 注文リスト
            ...cart.map((item) {
              // 味の情報を取得
              final tasteInfo = item.product.taste != null && item.product.taste != Taste.none
                  ? ' (${item.product.taste!.displayName})'
                  : '';
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                // 味の情報を表示に追加し、フォントサイズを調整
                child: Text('・${item.product.name}$tasteInfo x ${item.quantity}', style: Theme.of(context).textTheme.titleMedium),
              );
            }),
            const Divider(height: 24),
            Text('【会計】', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            // 金額表示
            _buildAmountRow('合計金額', '¥$totalAmount', context),
            _buildAmountRow('お預かり', '¥$receivedAmount', context),
            _buildAmountRow('お釣り', '¥$change', context, isEmphasized: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('戻る'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('会計確定'),
          ),
        ],
      ),
    );

    if (confirmed != true) return; // 確定されなかった場合は処理を中断

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
      if (mounted) {
        // 現在の会計ページを閉じて、前のレジ画面に戻る
        Navigator.of(context).pop();
      }
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

  /// ダイアログ内の金額表示用の行を構築するヘルパーウィジェット
  Widget _buildAmountRow(String label, String value, BuildContext context, {bool isEmphasized = false}) {
    final valueStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: isEmphasized ? FontWeight.bold : FontWeight.normal,
          fontSize: isEmphasized ? 20 : 18,
        );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          Text(
            value,
            style: isEmphasized
                ? valueStyle?.copyWith(color: Theme.of(context).primaryColor)
                : valueStyle,
          ),
        ],
      ),
    );
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