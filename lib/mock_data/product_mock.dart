import 'package:k3register/model/product.dart';
import 'package:flutter/material.dart';

const List<Product> mock_products = [
  Product(id:1,name:"もも",price: 100,taste: Taste.amakuchi, quantity: 100,icon:Icons.kebab_dining),
  Product(id:2,name:"もも",price:100,taste: Taste.chukara,quantity: 100,icon:Icons.kebab_dining),
  Product(id:3,name:"もも",price:100,taste: Taste.karakuchi,quantity: 100,icon:Icons.kebab_dining),
  Product(id:4,name:"もも",price:100,taste: Taste.death,quantity: 100,icon: Icons.kebab_dining),
  Product(id:5,name:"皮",price:100,taste: Taste.amakuchi,quantity:100,icon:Icons.kebab_dining),
  Product(id:6,name:"皮",price:100,taste: Taste.chukara,quantity:100,icon:Icons.kebab_dining),
  Product(id:7,name:"皮",price:100,taste: Taste.karakuchi,quantity:100,icon:Icons.kebab_dining),
  Product(id:8,name:"皮",price:100,taste: Taste.death,quantity:100,icon:Icons.kebab_dining),
];
