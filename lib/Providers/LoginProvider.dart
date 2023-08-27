import 'dart:convert';
import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'Cart.dart';


class LoginProvider with ChangeNotifier {

  Future<int> authenticate(String userName, String password, BuildContext context) async {
    final cartProvider = Provider.of<Cart>(context, listen: false);
    print(userName);
    print(password);
    if(userName != "" && password != "") {
      final response = await http
          .get(Uri.parse(cartProvider.getApiUrl() + 'auth/' + userName + '/' + password), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      });
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        if(json != -1) {
          window.localStorage["userData"] = json.toString();
          return json;
        }
      } else {
        throw Exception('Failed to fetch userId');
      }
    }

    return -1;
  }

  Future<bool> signUp(String userName, String password, BuildContext context) async {
    final cartProvider = Provider.of<Cart>(context, listen: false);
    print(userName);
    print(password);
    var httpData = {
      "username": userName,
      "password": password
    };
    if(userName != "" && password != "") {
      final response = await http
          .post(Uri.parse(cartProvider.getApiUrl() + 'addUser'), body: jsonEncode(httpData), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      });
      if (response.statusCode == 200) {
        bool resp = jsonDecode(response.body) as bool;
          return resp;
      } else {
        throw Exception('Failed to fetch userId');
        return false;
      }
    }
    return false;
  }
}