import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/product.dart';

class ProductRepository {
  ProductRepository._();

  static Future<List<Product>> loadProducts() async {
    final raw = await rootBundle.loadString('assets/data/products.json');
    final decoded = jsonDecode(raw) as List<dynamic>;
    final products = decoded
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
    if (products.isNotEmpty) {
      debugPrint(
        'ProductRepository: loaded ${products.length} products, '
        'first entry: ${jsonEncode(products.first.toJson())}',
      );
    }
    return products;
  }
}
