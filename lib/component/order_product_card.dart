import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k3register/model/order.dart';
import 'package:k3register/model/order_item.dart';
import 'package:k3register/provider/product_provider.dart';
import 'package:k3register/model/product.dart';
import 'package:k3register/infrastructure/orders_repository.dart';
import 'package:collection/collection.dart';

/// 1つの注文内容全体を表示するカード
class OrderProductCard extends ConsumerWidget {
  final Order order; // 表示する注文データ

  const OrderProductCard({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isWaiting = order.hasProvided == 'waiting';

    void changeOrderState(Order order){
          // order.idがnullでないことを確認
      final orderId = order.id;
      if (orderId != null) {
        // 現在の状態に応じて、次の状態を決定する
        final newState = order.hasProvided == 'waiting' ? 'calling' : 'completed';
        // Repositoryのメソッドを呼び出して状態を更新
        ref.read(orderRepositoryProvider).updateOrderState(orderId, newState);
      }
    }

    return Card(
      // Card自体の角を丸くする
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      clipBehavior: Clip.antiAlias, // 子ウィジェットがはみ出さないようにする
      child: InkWell(
        onTap: () {
          // 全商品リストを取得して、データが利用可能な場合にダイアログを表示
          ref.read(productsProvider).when(
                data: (products) {
                  // 注文商品リストから表示用のウィジェットリストを作成
                  final itemWidgets = order.items.map((orderItem) {
                    // 商品IDに一致する商品情報を探す
                    // `firstWhere` は商品が見つからない場合に例外を投げるため、`collection` パッケージの `firstWhereOrNull` を使用して安全に処理します。
                    // `collection` パッケージのインポートが必要になる場合があります: `import 'package:collection/collection.dart';`
                    final product = products.firstWhereOrNull((p) => p.id == orderItem.productId);
                    // 商品が見つからなかった場合の表示
                    if (product == null) {
                      return Text('・不明な商品 (ID: ${orderItem.productId}) x ${orderItem.quantity}', style: const TextStyle(color: Colors.red));
                    }
                    final taste = product.taste != null && product.taste != Taste.none
                        ? ' (${product.taste!.displayName})'
                        : '';
                    // 商品名、味、数量を表示するTextウィジェットを返す
                    return Text('・${product.name}$taste x ${orderItem.quantity}', style: const TextStyle(fontWeight: FontWeight.bold,));
                  }).toList();

                  // 注文の現在の状態に応じて、ダイアログのテキストを決定する
                  
                  final dialogTitle = isWaiting ? "呼び出し確認" : "完了確認";
                  final dialogQuestion = isWaiting
                      ? "この注文を「呼び出し中」にしますか？"
                      : "この注文を「完了」しますか？\n(表示が消えます)";

                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text(dialogTitle),
                        content: Column(
                          mainAxisSize: MainAxisSize.min, // Columnの高さをコンテンツに合わせる
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("注文番号: ${order.id ?? 'N/A'}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            const Divider(height: 24),
                            // ここで生成した商品リストのウィジェットを展開
                            ...itemWidgets,
                            const SizedBox(height: 24),
                            Text(dialogQuestion),
                          ],
                        ),
                        actions: <Widget>[
                          // ボタン領域
                          ElevatedButton(
                            child: const Text("Cancel"),
                            onPressed: () => Navigator.pop(context),
                          ),
                          ElevatedButton(
                              child: const Text("OK"),
                              onPressed: () {
                                changeOrderState(order);
                                Navigator.pop(context);
                              }),
                        ],
                      );
                    },
                  );
                },
                // 商品データ取得中はローディングを表示（通常は一瞬）
                loading: () {
                  // 簡易的なローディング表示
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(child: CircularProgressIndicator()),
                  );
                  // すぐにダイアログを閉じることで、フリーズしたように見えないようにする
                  Future.delayed(const Duration(milliseconds: 500), () => Navigator.pop(context));
                },
                // エラー時
                error: (err, stack) => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('商品情報の取得に失敗しました: $err')),
                ),
              );
        },
        child: Column(
          children: [
            // --- 上部：注文番号ヘッダー ---
            // こちらはCardの丸みに沿う
            Container(
              color: (isWaiting ?Colors.blueGrey[50]: const Color.fromARGB(255, 255, 224, 224)) ,// ヘッダーの背景色
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Text("注文番号", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    order.id.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            // --- 下部：商品リスト ---
            // こちらは四角いまま
            ListView.builder(
              shrinkWrap: true, // Columnの中で使うため必須
              physics: const NeverScrollableScrollPhysics(), // 親のスクロールと競合させない
              itemCount: order.items.length,
              itemBuilder: (context, index) {
                final orderItem = order.items[index];
                return _OrderItemTile(orderItem: orderItem);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// 注文内の各商品を表示するための内部ウィジェット
class _OrderItemTile extends ConsumerWidget {
  final OrderItem orderItem;

  const _OrderItemTile({required this.orderItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsyncValue = ref.watch(productsProvider);
    return productsAsyncValue.when(
      data: (products) {
        final product = products.firstWhereOrNull(
          (p) => p.id == orderItem.productId,
        );

        if (product == null) {
          return ListTile(title: Text('商品ID: ${orderItem.productId} 不明'));
        }

        return Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey[200]!)),
          ),
          child: ListTile(
            visualDensity: VisualDensity.compact, // ListTileの縦の余白を詰める
            leading: const Icon(Icons.fastfood_outlined),
            title: Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: product.taste != null && product.taste != Taste.none
                // 味の表示をChipウィジェットに変更
                ? Align(
                    alignment: Alignment.centerLeft,
                    
                    child: Chip(
                      label: Text(
                        product.taste!.displayName,
                        style: TextStyle(fontSize: 12, color: product.taste!.textColor),
                      ),
                      backgroundColor: product.taste!.backgroundColor,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      // Chipに枠線を追加
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: const Color.fromARGB(255, 0, 0, 0), // 枠線の色
                          width: 1.5, // 枠線の太さ
                        ),
                      ),
                    ),
                  )
                : null, // tasteがnoneの場合は何も表示しない
            trailing: Text(
              'x ${orderItem.quantity}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        );
      },
      loading: () => const ListTile(title: Center(child: LinearProgressIndicator())),
      error: (e, st) => ListTile(title: Text('エラー: $e')),
    );
  }
}