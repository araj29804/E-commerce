import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/services/ApiService.dart';
import 'package:untitled/services/AuthService.dart';
import 'package:untitled/view/ProductListPage.dart';
import 'package:untitled/view/SignInPage.dart';
import 'package:untitled/view/SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<ApiService>(create: (_) => ApiService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class HomePage extends StatelessWidget {
  final List<String> banners = [
    'assets/images/banner1.png', // Replace with your actual banner image paths
    'assets/images/banner2.png',
    'assets/images/banner3.png',
    'assets/images/banner4.png',
    'assets/images/banner5.png',
    'assets/images/banner6.png',
  ];


  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("E-Commerce"),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {

            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _logout(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Banners Section
          CarouselSlider(
            options: CarouselOptions(height: 200.0, autoPlay: true),
            items: banners.map((banner) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(banner),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(),
                  );
                },
              );
            }).toList(),
          ),
          SizedBox(height: 10),

          // Categories Section
          Expanded(
            child: FutureBuilder(
              future: apiService.fetchCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print('Error: ${snapshot.error}');
                  return Center(
                      child: Text('Error loading categories: ${snapshot.error}',
                          style: TextStyle(color: Colors.red, fontSize: 16)));
                } else if (!snapshot.hasData ||
                    (snapshot.data as List).isEmpty) {
                  return Center(
                      child: Text('No categories available',
                          style: TextStyle(fontSize: 18)));
                } else {
                  final categories = snapshot.data as List<dynamic>;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Two columns
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 3 / 2,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductListPage(
                                    category: categories[index]),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(
                                  colors: [Colors.tealAccent, Colors.teal],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  categories[index].toString().toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Sign out from Firebase
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => SignInPage()), // Navigate to SignInPage
      );
    } catch (e) {
      // Handle logout error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $e')),
      );
    }
  }
}
