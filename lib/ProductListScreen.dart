import 'dart:html';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'CartScreen.dart';
import 'LoginScreen.dart';
import 'Providers/Cart.dart';
import 'Utils/Product.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> listOfProducts = [];

  Future<List<Product>> fetchProductsFromAPI() async {
    if (listOfProducts.length == 0) {
      final cartProvider = Provider.of<Cart>(context, listen: false);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product List 1'), actions: [
        RaisedButton(
            onPressed: () => {
                  window.localStorage.remove("userData"),
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
              height: 400,
              width: double.infinity,
              padding: EdgeInsets.all(20),
              child: ListView.builder(
                itemCount: products.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final product = products[index];
                  // return Card(
                  //   elevation: 4,
                  //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  //   child: ListTile(
                  //     contentPadding: EdgeInsets.all(16),
                  //     title: Text(
                  //       product.name,
                  //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  //     ),
                  //     subtitle: Text(
                  //       '\$${product.price.toStringAsFixed(2)}',
                  //       style: TextStyle(fontSize: 14, color: Colors.grey),
                  //     ),
                  //     leading: Hero(
                  //       tag: 'productImage_${product.id}',
                  //       child: Container(
                  //         width: 60,
                  //         height: 60,
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(10),
                  //           image: DecorationImage(
                  //             image: NetworkImage(product.productImage),
                  //             fit: BoxFit.cover,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     trailing: IconButton(
                  //       icon: Icon(Icons.add_shopping_cart),
                  //       onPressed: () {
                  //         final cart = Provider.of<Cart>(context, listen: false);
                  //         cart.addItem(product);
                  //       },
                  //     ),
                  //   ),
                  // );
                  return SizedBox(
                    width: 400,
                    height: 300, // Set a specific height for the card
                    child: Card(
                      elevation: 4,
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              width: 250,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(product.productImage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              child: Text(
                                product.name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Text(
                                '\Rs: ${product.price.toStringAsFixed(2)}',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ),
                            Center(
                              child: Container(
                                width: 200,
                                padding: EdgeInsets.only(top: 20),
                                child: RaisedButton(
                                  onPressed: () {
                                    final cart = Provider.of<Cart>(context,
                                        listen: false);
                                    cart.addItem(product);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: Icon(Icons.add_shopping_cart),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Container(
                                          child: Text("Add to Cart"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
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
