import 'dart:convert';

import 'package:amazon_bookstore/CartScreen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'cart_screen_test.mocks.dart';

final apiUrl = "http://13.233.204.99:8080/";

@GenerateMocks([http.Client])
void main() {
  group('Cart Screen', () {
    test("Remove from Cart test - Success", () async {
      final client = MockClient();
      Cart cart = new Cart(
          id: 1,
          productName: "productName",
          productPrice: 10.0,
          productImage: "productImage");
      when(client.get(Uri.parse(apiUrl + 'removeFromCart/1'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      })).thenAnswer((_) async => http.Response('true', 200));

      expect(await removeFromCart(cart, client), true);
    });

    test("Remove from Cart test - Failure", () async {
      final client = MockClient();
      Cart cart = new Cart(
          id: 1,
          productName: "productName",
          productPrice: 10.0,
          productImage: "productImage");
      when(client.get(Uri.parse(apiUrl + 'removeFromCart/1'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      })).thenAnswer((_) async => http.Response('false', 200));

      expect(await removeFromCart(cart, client), false);
    });

    test("Checkout from Cart test - Success", () async {
      final client = MockClient();
      List<Cart> listOfCart = [
        new Cart(
            id: 1,
            productName: "productName",
            productPrice: 10.0,
            productImage: "productImage"),
        new Cart(
            id: 2,
            productName: "productName",
            productPrice: 10.0,
            productImage: "productImage"),
      ];
      var httpData = {"cartIds": [1,2]};
      when(client.post(Uri.parse(apiUrl + 'checkoutCart'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      }, body: jsonEncode(httpData))).thenAnswer((_) async => http.Response('true', 200));

      expect(await checkoutCart(listOfCart, client), true);
    });

    test("Checkout from Cart test - Failure", () async {
      final client = MockClient();
      List<Cart> listOfCart = [
        new Cart(
            id: 1,
            productName: "productName",
            productPrice: 10.0,
            productImage: "productImage"),
        new Cart(
            id: 2,
            productName: "productName",
            productPrice: 10.0,
            productImage: "productImage"),
      ];
      var httpData = {"cartIds": [1,2]};
      when(client.post(Uri.parse(apiUrl + 'checkoutCart'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      }, body: jsonEncode(httpData))).thenAnswer((_) async => http.Response('false', 200));

      expect(await checkoutCart(listOfCart, client), false);
    });

  });
}
