import 'dart:html';

import 'package:amazon_bookstore/ProductListScreen.dart';
import 'package:amazon_bookstore/Utils/Cart.dart';
import 'package:amazon_bookstore/Widgets/CartCard.dart';
import 'package:amazon_bookstore/Widgets/checkoutStatusPopup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'LoginScreen.dart';
import 'Providers/CartProvider.dart';
import 'Utils/Product.dart';
import 'package:http/http.dart' as http;

import 'Widgets/ProductCart.dart';

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
    fetchProductsFromAPI();
  }

  Future<List<Cart>> fetchProductsFromAPI() async {
    print("HEY");

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    listOfProducts = await cartProvider.getCartItems();
    getCartSum();
    print("LIST OF PRODYC " + listOfProducts.toString());
    setState(() {});
    return listOfProducts;
  }

  removeFromCart(Cart cart) async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    await cartProvider.removeFromCart(cart);
    fetchProductsFromAPI();
  }

  getCartSum() {
    cartTotal = 0.0;
    for (Cart sumCart in listOfProducts) {
      cartTotal = cartTotal + sumCart.productPrice;
    }
    setState(() {});
  }

  checkoutCart() async {
    print("CLIKED");
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    bool checkoutStatus = await cartProvider.checkoutCart(listOfProducts);
    await fetchProductsFromAPI();
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return CheckoutStatusPopup(checkoutStatus);
        });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

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
                        return CartCard(cartData, removeFromCart);
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
                          onPressed: () => {checkoutCart()},
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
                      SizedBox(height: 20,),
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
