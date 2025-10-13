import 'package:k3register/model/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'product_repository.g.dart';

/// 商品データに関するデータアクセス層
class ProductRepository {
  final _client = Supabase.instance.client;

  /// Supabaseから商品リストを取得する
  Future<List<Product>> fetchProducts() async {
    try {
      // 'products'テーブルを基準に、'parts'と'taste'テーブルをJOINしてデータを取得
      // is_availableがtrueのものだけを取得
      final response = await _client
          .from('products')
          .select('id, price, parts(name, quantity), taste(name)')
          .eq('is_available', true);

      // 取得した階層的なJSONデータをProductモデルのリストに変換
      final products = response.map((json) {
        final tasteData = json['taste'];
        final tasteName = tasteData != null ? tasteData['name'] as String : null;

        // tasteName（表示名）からTaste enumのメンバーを検索する
        Taste? foundTaste;
        if (tasteName != null) {
          // firstWhereOrNullを使うために、collectionパッケージのインポートが必要です
          // pubspec.yamlに `collection: ^1.18.0` を追加してください
          foundTaste = Taste.values.firstWhere((e) => e.displayName == tasteName, orElse: () => Taste.none);
        }

        return Product(
          id: json['id'],
          name: json['parts']['name'],
          price: json['price'],
          quantity: json['parts']['quantity'],
          // 見つかったTaste enumを代入
          taste: foundTaste,
        );
      }).toList();

      return products;
    } catch (e) {
      print('Error fetching products: $e');
      rethrow;
    }
  }
}

// ProductRepositoryのインスタンスをDI（依存性注入）するためのProvider
@riverpod
ProductRepository productRepository(ProductRepositoryRef ref) {
  return ProductRepository();
}