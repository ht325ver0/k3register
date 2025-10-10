import 'package:k3register/model/cart_product.dart';
import 'package:k3register/mock_data/product_mock.dart';


List<CartProduct> mock_cart = [
  CartProduct(product: mock_products[0], quantity: 1),
  CartProduct(product: mock_products[5], quantity: 6), // 重複をまとめて数量を合算 (2 + 2 + 2)
  CartProduct(product: mock_products[4], quantity: 2), 
  CartProduct(product: mock_products[2], quantity: 10),
  CartProduct(product: mock_products[1], quantity: 3)
];