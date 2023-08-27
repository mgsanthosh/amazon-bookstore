
import 'package:amazon_bookstore/Providers/LoginProvider.dart';
import 'package:amazon_bookstore/Widgets/ProductCart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'CartScreen.dart';
import 'LoginScreen.dart';
import 'Providers/CartProvider.dart';
import 'Utils/Product.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> listOfProducts = [];

  Future<List<Product>> fetchProductsFromAPI() async {
    if (listOfProducts.length == 0) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final response = await http.get(
          Uri.parse(cartProvider.getApiUrl() + 'getAllProducts'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          });

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        listOfProducts = responseData.map((productData) {
          return Product(
            id: productData['id'],
            name: productData['productName'],
            price: productData['productPrice'].toDouble(),
            productImage: productData['productImage'],
          );
        }).toList();
        // return listOfProducts;
      } else {
        throw Exception('Failed to fetch products');
      }
    }
    return listOfProducts;
  }

  addToCart(Product product) {
    final cart = Provider.of<CartProvider>(context,
        listen: false);
    cart.addItem(product);
  }

  @override
  Widget build(BuildContext context) {
    var loginProvider = Provider.of<LoginProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Product List'), actions: [
        RaisedButton(
            onPressed: () => {
                  loginProvider.logOut(),
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()))
                },
            color: Colors.amber,
            child: Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ))
      ]),
      body: FutureBuilder<List<Product>>(
        future: fetchProductsFromAPI(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final products = snapshot.data!;
            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              child: ListView.builder(
                itemCount: products.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(product, addToCart);
                },
              ),
            );
          } else {
            return Center(child: Text('No products available.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartScreen()),
          );
        },
        label: Text('View Cart'),
        icon: Icon(Icons.shopping_cart),
      ),
    );
  }
}
