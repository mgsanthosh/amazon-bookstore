import 'dart:convert';

import 'package:amazon_bookstore/LoginScreen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_screen_test.mocks.dart';
final apiUrl = "http://13.233.204.99:8080/";

@GenerateMocks([http.Client])
void main() {
  group('Login Screen ', () {
    test("Authentication - Success", () async {
      final client = MockClient();
      when(client.get(Uri.parse(apiUrl + 'auth/' + 'santosh' + '/' + 'xcvb'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      })).thenAnswer((_) async => http.Response('100', 200));

      expect(await authenticate('santosh', 'xcvb', client), 100);
    });

    test("Authentication - Failure", () async {
      final client = MockClient();
      when(client.get(Uri.parse(apiUrl + 'auth/' + 'santosh' + '/' + 'xcvb'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      })).thenAnswer((_) async => http.Response('-1', 200));

      expect(await authenticate('santosh', 'xcvb', client), -1);
    });
  });
}
