import 'dart:convert';
import 'package:amazon_bookstore/Providers/LoginProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:amazon_bookstore/Providers/CartProvider.dart'; // Import your CartProvider class

import 'package:amazon_bookstore/LoginScreen.dart'; // Import your LoginScreen class

class MockCartProvider extends Mock implements CartProvider {}
class MockLoginProvider extends Mock implements LoginProvider {}

class MockClient extends Mock implements http.Client {}

void main() {
  testWidgets('authenticate success', (WidgetTester tester) async {
    final mockClient = MockClient();
    final mockCartProvider = MockCartProvider();
    final mockLoginProvider = MockLoginProvider();

    when(mockCartProvider.getApiUrl()).thenReturn('https://example.com/api/'); // Adjust this

    final loginScreen = LoginScreen();
    await tester.pumpWidget(
      Provider<CartProvider>(
        create: (_) => mockCartProvider,
        child: MaterialApp(home: loginScreen),
      ),
    );

    when(mockClient.get(Uri.parse('https://example.com/api/auth/test_username/test_password'), headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('1', 200));

    final response = await mockLoginProvider.authenticate('test_username', 'test_password', tester.element(find.byType(LoginScreen)));

    expect(response, 1);
  });
}