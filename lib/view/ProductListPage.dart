import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/ApiService.dart';
import 'ProductDetailPage.dart';

class ProductListPage extends StatefulWidget {
  final String category;

  ProductListPage({required this.category});

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ScrollController _scrollController = ScrollController();
  final List<dynamic> _products = [];
  bool _isLoading = false;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _fetchProducts();
      }
    });
  }

  Future<void> _fetchProducts() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    final apiService = Provider.of<ApiService>(context, listen: false);
    final newProducts = await apiService.fetchProductsByCategory(widget.category);
    setState(() {
      _products.addAll(newProducts);
      _page++;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _products.length + (_isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _products.length) {
              return Center(child: CircularProgressIndicator());
            }
            final product = _products[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailPage(
                      productId: product['id'],
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      // Product Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          product['image'],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 10),
                      // Product Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['title'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5),
                            Text(
                              "\$${product['price']}",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              product['description'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
