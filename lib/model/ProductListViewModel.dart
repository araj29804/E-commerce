import 'package:flutter/material.dart';
import '../services/ApiService.dart';

class ProductListViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<dynamic> _products = [];

  List<dynamic> get products => _products;

  Future<void> fetchProducts(String category) async {
    _products = await _apiService.fetchProductsByCategory(category);
    notifyListeners();
  }
}
