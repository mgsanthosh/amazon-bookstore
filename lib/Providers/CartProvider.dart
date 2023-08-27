import 'dart:convert';
import 'dart:html';

import 'package:flutter/foundation.dart';

import '../Utils/Cart.dart';
import '../Utils/Product.dart';
import 'package:http/http.dart' as http;

class CartProvider with ChangeNotifier {
  Map<Product, int> _items = {};

  Map<Product, int> get items => {..._items};

  int get itemCount => _items.length;

  List<Cart> cartItems = [];

  Future<List<Cart>> getCartItems() async {
    var userId = window.localStorage['userData'];

    final response = await http
        .get(Uri.parse(getApiUrl() + 'getUserCartData/' + userId), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    });
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      cartItems = responseData.map((cartData) {
        return Cart(
          id: cartData['id'],
          productName: cartData['product_name'],
          productImage: cartData['product_image'],
          productPrice: cartData['product_price']
        );
      }).toList();
    } else {
      throw Exception('Failed to fetch userId');
    }
    return cartItems;

  }

  Future<void> addItem(Product product) async {
    var userId = window.localStorage['userData'];
    final response = await http
        .get(Uri.parse(getApiUrl() + 'addToCart/' + product.id.toString() + '/' + userId), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    });
    notifyListeners();
  }

  Future<bool> removeFromCart(Cart cart) async {
    final response = await http
        .get(Uri.parse(getApiUrl() + 'removeFromCart/' + cart.id.toString()), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    });
    if (response.statusCode == 200) {
      bool resp = jsonDecode(response.body) as bool;
      return resp;
    } else {
      throw Exception('Failed to fetch userId');
    }
  }

  Future<bool> checkoutCart(List<Cart> cartList) async {
    List<int> cartIds = [];
    for(var cart in cartList) {
      cartIds.add(cart.id);
    }
    var httpData = {
      "cartIds": cartIds
    };
    final response = await http
        .post(Uri.parse(getApiUrl() + 'checkoutCart'),body: jsonEncode(httpData), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    });
    if (response.statusCode == 200) {
      bool resp = jsonDecode(response.body) as bool;
      return resp;
    } else {
      throw Exception('Failed to fetch userId');
    }
    return true;
  }

  getApiUrl() {
    return "http://13.233.204.99:8080/";
    // return "http://localhost:8080/";
  }


}
