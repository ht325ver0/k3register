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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 商品名と味の表示エリア。Flexibleにして必要な高さだけ使うようにする
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // Columnが必要な高さだけを占めるようにする
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 商品名が長すぎる場合に改行されるようにする
                          Text(
                            product.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            maxLines: 2, // 最大2行まで表示
                            overflow: TextOverflow.ellipsis, // はみ出す場合は...で省略
                          ),
                          if (product.taste != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Chip(
                                label: Text(
                                  product.taste!.displayName,
                                  style: TextStyle(fontSize: 12, color: product.taste!.textColor),
                                ),
                                backgroundColor: product.taste!.backgroundColor,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
                                labelPadding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                        ],
                      ),
                    ),
                    // 価格表示。常に一番下に表示される
                    Text(
                      '¥${product.price}',
                      style: const TextStyle(
                        fontSize: 18, // 価格を大きく
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