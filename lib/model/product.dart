import 'package:flutter/material.dart';

enum Taste {
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

class Product {
  final int id;
  final String name;
  final int price;
  final Taste? taste;
  final int quantity;
  final IconData? icon;

  const Product({ // コンストラクタに const を追加
    required this.id,
    required this.name,
    required this.price,
    this.taste,
    required this.quantity,
    this.icon,
  });
}