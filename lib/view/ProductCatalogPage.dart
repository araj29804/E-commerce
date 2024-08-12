import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'ProductDetailPage.dart';

class ProductCatalogPage extends StatefulWidget {
  final String category;

  ProductCatalogPage({required this.category});

  @override
  _ProductCatalogPageState createState() => _ProductCatalogPageState();
}

class _ProductCatalogPageState extends State<ProductCatalogPage> {
  List<dynamic> _products = [];
  bool _isLoading = true;
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  bool _hasMoreProducts = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    if (!_hasMoreProducts) return;

    final url =
        'https://fakestoreapi.com/products/category/${widget.category}?page=$_currentPage&limit=$_itemsPerPage';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> newProducts = json.decode(response.body);

      setState(() {
        _isLoading = false;
        _currentPage++;
        _hasMoreProducts = newProducts.length == _itemsPerPage;
        _products.addAll(newProducts);
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)
        ,backgroundColor: Colors.teal,),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (!_isLoading &&
              _hasMoreProducts &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _fetchProducts();
          }
          return false;
        },
        child: _isLoading && _products.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _products.length + (_hasMoreProducts ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _products.length) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final product = _products[index];
                  return ListTile(
                    title: Text(product['title']),
                    subtitle: Text('\$${product['price']}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailPage(productId: product),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
