import 'dart:convert';
import 'package:flutter/material.dart';
import '../model/cart_model.dart';
import 'package:http/http.dart' as http;

class CartsProvider extends ChangeNotifier {

  int _currentPage = 0;
  int _totalCarts = 0;

  List<Cart> get carts => _carts;
  int get currentPage => _currentPage;
  int get totalCarts => _totalCarts;

  List<Cart> _carts = [];

  Future<void> fetchCarts({bool loadMore = false}) async {
    try {
      final response = await http.get(Uri.parse('https://dummyjson.com/carts?skip=$_currentPage'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final cartsData = jsonData['carts'] as List<dynamic>;
        final carts = cartsData.map((cartJson) => Cart.fromJson(cartJson)).toList();

        if (loadMore) {
          _carts.addAll(carts);
        } else {
          _carts = carts;
        }
        _carts.addAll(carts);
        notifyListeners();
      } else {
        throw Exception('Failed to load carts');
      }
    } catch (error) {
      print('Error fetching carts: $error');
      throw error;
    }
    if (loadMore) {
      _currentPage++;
    } else {
      _currentPage = 0;
    }
  }
}
