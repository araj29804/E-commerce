import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ApiService {

  Future<List<dynamic>> fetchCategories() async {
    final response = await http.get(Uri.parse('https://fakestoreapi.in/api/products/category'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['categories'];  // Adjust this based on actual API response
    } else {
      throw Exception('Failed to load categories');
    }
  }


  Future<List<dynamic>> fetchProductsByCategory(String category) async {
    final response = await http.get(Uri.parse('https://fakestoreapi.in/api/products/category?type=$category'));
    debugPrint("https://fakestoreapi.in/api/products/category?type=$category");
    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
      if (data is List) {
        return data;
      } else if (data is Map) {
        return data['products'] ?? [];  // Adjust based on the actual key
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Map<String, dynamic>> fetchProductDetail(int productId) async {
    try {
      final response = await http.get(Uri.parse('https://fakestoreapi.in/api/products/$productId'));

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Decode the response body
        final Map<String, dynamic> data = json.decode(response.body);

        // Check if the data contains the expected fields
        if (data.isNotEmpty) {
          debugPrint("$data");
          return data; // Return the product data as a Map
        } else {
          throw Exception('Unexpected response format: data is empty');
        }
      } else {
        throw Exception('Failed to load product details: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occur during the request
      throw Exception('Failed to load product details: $e');
    }
  }
}
