import 'package:k3register/model/product.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_product.freezed.dart';
part 'cart_product.g.dart';

@freezed
class CartProduct with _$CartProduct {

  const factory CartProduct({
    required Product product,
    required int quantity,
  }) = _CartProduct;

  // JSONからインスタンスを生成するためのfactoryコンストラクタ
  factory CartProduct.fromJson(Map<String, dynamic> json) => 
    _$CartProductFromJson(json);
}