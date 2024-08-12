import 'package:flutter/material.dart';

import '../services/ApiService.dart';

class ProductDetailPage extends StatelessWidget {
  final int productId;

  ProductDetailPage({required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product Details')
       , backgroundColor: Colors.teal,),
      body: FutureBuilder<Map<String, dynamic>>(
        future: ApiService().fetchProductDetail(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No product data available'));
          } else {
            final product = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['title'] ?? 'No Title',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      product['description'] ?? 'No Description',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Price: \$${product['price']?.toStringAsFixed(2) ?? 'N/A'}',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    SizedBox(height: 15),
                    // Display the product image if available
                    product['image'] != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        product['image'],
                        fit: BoxFit.cover,
                        height: 200,
                        width: double.infinity,
                      ),
                    )
                        : Container(),
                    SizedBox(height: 15),
                    // Additional product details
                    Text(
                      'Category: ${product['category'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    // Add more details if available
                    Text(
                      'Rating: ${product['rating']?['rate']?.toString() ?? 'N/A'}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Number of Reviews: ${product['rating']?['count']?.toString() ?? 'N/A'}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Add to cart functionality
                        // This is just a placeholder for functionality
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
            );
          }
        },
      ),
    );
  }
}
