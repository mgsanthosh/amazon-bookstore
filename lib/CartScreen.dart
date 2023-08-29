import 'dart:convert';
import 'dart:html';

import 'package:amazon_bookstore/ProductListScreen.dart';
import 'package:amazon_bookstore/Widgets/CartCard.dart';
import 'package:amazon_bookstore/Widgets/checkoutStatusPopup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'LoginScreen.dart';
import 'Utils/Product.dart';
import 'package:http/http.dart' as http;

final apiUrl = "http://13.233.204.99:8080/";
final userLocalId = window.localStorage['userData'];

Future<List<Cart>> fetchProductsFromAPI(http.Client client, var userId) async {
  print("HEY");
  List<Cart> cartItems = [];
  var url = apiUrl + 'getUserCartData/' + userId;
  print("THE URL IS " + url.toString());

  final response = await client.get(Uri.parse(url));
  print('THE RESSSSSSSPONSEEEEEEE ' + response.toString());
  if (response.statusCode == 200) {
    final List responseData = json.decode(response.body);
    cartItems = responseData.map((cartData) {
      return Cart.fromJson(cartData);
    }).toList();
  } else {
    throw Exception('Failed to fetch userId');
  }
  print('THE RESSSSSSSPONSEEEEEEE CARTT' + cartItems.toString());
  return cartItems;
}

Future<void> addItem(Product product) async {
  // var userId = window.localStorage['userData'];
  final response = await http.get(
      Uri.parse(apiUrl + 'addToCart/' + product.id.toString() + '/' + userLocalId!),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      });
}

Future<bool> removeFromCart(Cart cart, http.Client client) async {
  final response = await client.get(
      Uri.parse(apiUrl + 'removeFromCart/' + cart.id.toString()),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      });
  if (response.statusCode == 200) {
    bool resp = jsonDecode(response.body) as bool;
    if(resp) {
      return true;
    }
  } else {
    return false;
  }
  return false;
}

Future<bool> checkoutCart(List<Cart> cartList, http.Client client) async {
  List<int> cartIds = [];
  for (var cart in cartList) {
    cartIds.add(cart.id);
  }
  var httpData = {"cartIds": cartIds};
  final response = await client.post(Uri.parse(apiUrl + 'checkoutCart'),
      body: jsonEncode(httpData),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      });
  if (response.statusCode == 200) {
    bool resp = jsonDecode(response.body) as bool;
    if(resp) {
      return true;
    }
  } else {
    return false;
  }
  return false;
}

getCartSum(List<Cart> listOfProducts) {
  double cartTotal = 0.0;
  for (Cart sumCart in listOfProducts) {
    cartTotal = cartTotal + sumCart.productPrice;
  }
  return cartTotal;
}

class Cart {
  final int id;
  final String productName;
  final double productPrice;
  final String productImage;

  Cart(
      {required this.id,
      required this.productName,
      required this.productPrice,
      required this.productImage});

  factory Cart.fromJson(Map<String, dynamic> cartData) {
    return Cart(
        id: cartData['id'],
        productName: cartData['product_name'],
        productImage: cartData['product_image'],
        productPrice: cartData['product_price']);
  }
}

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Cart> listOfProducts = [];
  double cartTotal = 0.0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getInitData();
    });
  }

  Future<void> getInitData() async {
    listOfProducts = await fetchProductsFromAPI(http.Client(), userLocalId);
    print("THE LOIST OF PRODUCTS " + listOfProducts.toString());
    cartTotal = getCartSum(listOfProducts);
    setState(() {});
  }

  handleRemoveFromCart(Cart cart) async {
    await removeFromCart(cart, http.Client());
    listOfProducts = await fetchProductsFromAPI(http.Client(), userLocalId);
    setState(() {});
  }

  handleCheckoutCart() async {
    print("CLIKED");
    bool checkoutStatus = await checkoutCart(listOfProducts, http.Client());
    listOfProducts = await fetchProductsFromAPI(http.Client(), userLocalId);
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return CheckoutStatusPopup(checkoutStatus);
        });
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Cart'), actions: [
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
        body: listOfProducts.length != 0
            ? Column(
                children: [
                  Container(
                    height: 600,
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    child: ListView.builder(
                      itemCount: listOfProducts.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final cartData = listOfProducts[index];
                        return CartCard(cartData, handleRemoveFromCart);
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.red,
                    padding: EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "TOTAL : " + cartTotal.toString(),
                          style: TextStyle(fontSize: 30),
                          textAlign: TextAlign.end,
                        ),
                        RaisedButton(
                          onPressed: () => {handleCheckoutCart()},
                          child: Text("CHECKOUT"),
                          color: Colors.lightGreenAccent,
                        )
                      ],
                    ),
                  )
                ],
              )
            : Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("There are no items in your cart"),
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                        onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductListScreen())),
                        child: Text('GO BACK TO PRODUCTS'),
                      )
                    ],
                  ),
                ),
              ));
  }
}
