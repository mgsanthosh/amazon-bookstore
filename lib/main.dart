
import 'package:amazon_bookstore/LoginScreen.dart';
import 'package:amazon_bookstore/Providers/LoginProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ProductListScreen.dart';
import 'Providers/CartProvider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Amazon Book Store'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int? userId = null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getInitData();
    });
    setState(() {
      // userData = window.localStorage.containsValue("userData");;
    });
  }

  Future<void> getInitData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userData');
  }



  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        // Provide the cart to the app
      ],
      child: MaterialApp(
              title: 'Amazon Bookstore',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: (userId == null ? LoginScreen() : ProductListScreen()),
            )
    );
  }
}
