import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:k3register/model/product.dart';
import 'package:k3register/infrastructure/product_repository.dart';

part 'product_provider.g.dart';

@riverpod
Future<List<Product>> products(ProductsRef ref) async {

  final productRepository = ref.watch(productRepositoryProvider);

  return productRepository.fetchProducts();
}
