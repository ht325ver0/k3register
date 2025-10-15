import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

enum Taste {
  solt('塩', Color.fromARGB(223, 92, 239, 255)),
  amakuchi('甘口', Color.fromARGB(225, 255, 224, 130)), // ! を追加
  chukara('中辛', Color.fromARGB(225, 255, 183, 77)),
  karakuchi('辛口', Color.fromARGB(225, 229, 115, 115)),
  death('デス', Colors.black),
  none('', Color.fromARGB(224, 255, 249, 232)); // tasteがない場合

  const Taste(this.displayName, this.backgroundColor);
  final String displayName;
  final Color backgroundColor;

  Color get textColor => this == Taste.death ? Colors.white : Colors.black87;
}

@freezed
class Product with _$Product {
  const factory Product({
    required int id,
    required String name,
    required int price,
    Taste? taste,
    required int quantity,
    // IconDataはJSONにシリアライズできないため、変換対象から除外します
    @JsonKey(includeFromJson: false, includeToJson: false) IconData? icon,
  }) = _Product;

  // Productクラスが他のfreezedクラスから参照されるため、
  // privateなコンストラクタを追加してfreezedが正しく動作するようにします。
  const Product._();

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}