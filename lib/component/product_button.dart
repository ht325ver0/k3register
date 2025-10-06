import 'package:flutter/material.dart';
import 'package:k3register/model/product.dart';

/// 商品データを表現するクラス
class ProductCard extends StatelessWidget {
    
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {

    return Card(
        clipBehavior: Clip.antiAlias, // 子ウィジェットがカードの角をはみ出さないように設定
        elevation: 4.0, // カードの影の濃さ
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // カードの角を丸くする
        ),
        child: InkWell(
          // タップされたときの処理
          onTap: onTap, // 親ウィジェットから渡されたonTapコールバックを呼び出す
          // Columnでウィジェットを縦に並べます
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // 子を水平方向に引き伸ばす
            children: [
              // 1. アイコン表示エリア
              Expanded(
                flex: 2, // アイコンエリアの高さの比率を2に設定
                child: Container(
                  color: Colors.blueGrey[50], // アイコンの背景色
                  child: const Icon(
                    Icons.kebab_dining, // product.icon を使用することも可能
                    size: 50,
                    color: Colors.blueGrey, // アイコンの色
                  ),
                ),
              ),
              
              // 2. 商品名と価格の表示エリア
              Expanded( // このエリアをExpandedでラップ
                flex: 3, // テキストエリアの高さの比率を3に設定
                child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // テキストを左揃えに
                  children: [
                    // 部位（商品名）の表示
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis, // 文字がはみ出た場合に...で省略
                    ),
                    const SizedBox(height: 4), // 少し隙間を空ける

                    product.taste != null
                        ? Chip(
                            label: Text(
                              product.taste!.displayName,
                              style: TextStyle(fontSize: 12, color: product.taste!.textColor),
                            ),
                            backgroundColor: product.taste!.backgroundColor,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
                            labelPadding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                          )
                        : const SizedBox.shrink(),
                    const Spacer(), 

          
                    Text(
                      '¥${product.price}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 118, 77, 77),
                      ),
                    ),
                  ],
                ),
              ),
              ),
            ],
          ), // Column
        ), // InkWell
      ); // Card
  }
}