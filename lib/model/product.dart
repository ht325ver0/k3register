import 'package:flutter/material.dart';

class Product {
  final int id;
  final String name;
  final int price;
  final String taste;
  final int quantity;
  final IconData? icon;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.taste,
    required this.quantity,
    this.icon,
  });
}