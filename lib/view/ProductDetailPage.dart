import 'package:flutter/material.dart';

import '../services/ApiService.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;

  ProductDetailPage({required this.productId});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Map<String, dynamic>? product;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
  }

  Future<void> _fetchProductDetails() async {
    try {
      final apiService = ApiService();
      final fetchedProduct = await apiService.fetchProductDetail(widget.productId);
      setState(() {
        product = fetchedProduct;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString(); // Store the error message
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text('Error: $errorMessage'))
          : product != null
          ? SingleChildScrollView( // Wrap the Column with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product!['title'] ?? 'No Title',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                product!['description'] ?? 'No Description',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 15),
              Text(
                'Price: \$${product!['price']?.toStringAsFixed(2) ?? 'N/A'}',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              SizedBox(height: 15),
              if (product!['image'] != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    product!['image'],
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                  ),
                ),
              SizedBox(height: 15),
              Text('Category: ${product!['category'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              // Additional fields you want to show
              Text('Brand: ${product!['brand'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Model: ${product!['model'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Color: ${product!['color'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              Text('Discount: ${product!['discount'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add to cart functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added to cart')),
                  );
                },
                child: Text('Add to Cart'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      )
          : Center(child: Text('No product data available')),
    );
  }
}
