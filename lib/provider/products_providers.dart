import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:untitled/model/product_model.dart';
import 'package:http/http.dart' as http;
import '../database.dart';

class ProductsProvider extends ChangeNotifier {

  int _currentPage = 0;
  int _totalProducts = 0;

  List<Product> get products => _products;
  int get currentPage => _currentPage;
  int get totalProducts => _totalProducts;
  List<Product> _products = [];

  Future<void> toggleFavoriteStatus(int productId) async {
    final isFavorite = _products.firstWhere((product) => product.id == productId).isFavorite;
    _products.firstWhere((product) => product.id == productId).isFavorite = !isFavorite;

    final db = DatabaseHelper();
    if (isFavorite) {
      await db.removeFromFavorites(productId);
    } else {
      await db.addToFavorites(productId);
    }

    notifyListeners();
  }

  Future<void> fetchProducts({bool loadMore = false}) async {
    try {
      final response = await http.get(Uri.parse('https://dummyjson.com/products?skip=$_currentPage'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final productsData = jsonData['products'] as List<dynamic>;
        final products = productsData.map((productJson) => Product.fromJson(productJson)).toList();

        if (loadMore) {
          _products.addAll(products);
        } else {
          _products = products;
        }
        notifyListeners();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      print('Error fetching products: $error');
      throw error;
    }
    if (loadMore) {
      _currentPage++;
    } else {
      _currentPage = 0;
    }
  }
}




