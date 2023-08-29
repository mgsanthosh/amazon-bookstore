import 'dart:convert';
import 'dart:html';

import 'package:amazon_bookstore/ProductListScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final apiUrl = "http://13.233.204.99:8080/";

Future<int> authenticate(
    String userName, String password, http.Client client) async {
  if (userName != "" && password != "") {
    final response = await client
        .get(Uri.parse(apiUrl + 'auth/' + userName + '/' + password), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    });
    if (response.statusCode == 200) {
      var userId = jsonDecode(response.body);
      if (userId != -1) {
        window.localStorage["userData"] = userId.toString();
        return userId;
      } else {
        return -1;
      }
    } else {
      return -1;
    }
  }
  return -1;
}

Future<bool> signUp(String userName, String password, http.Client client) async {
  var httpData = {
    "username": userName,
    "password": password
  };
  if(userName != "" && password != "") {
    final response = await client
        .post(Uri.parse(apiUrl + 'addUser'), body: jsonEncode(httpData), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    });
    if (response.statusCode == 200) {
      bool resp = jsonDecode(response.body) as bool;
      if(resp) {
        return true;
      }
    }
  }
  return false;
}

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Screen')),
      body: Center(
        child: Container(
          width: 500,
          height: 600,
          child: Card(
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "BookStore Login",
                    style: TextStyle(fontSize: 30),
                  ),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  SizedBox(height: 24),
                  Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      errorMessage = "";
                      int userId = await authenticate(
                          usernameController.text,
                          passwordController.text,
                          http.Client());
                      if (userId != -1) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductListScreen()));
                      } else {
                        setState(() {
                          errorMessage = "Please Enter Valid Credentials";
                        });
                      }
                    },
                    child: Text('Login'),
                  ),
                  SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      // Navigate to the sign-up screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                    },
                    child: Text('Sign Up'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Center(
        child: Container(
          width: 500,
          height: 600,
          child: Card(
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "BookStore Signup",
                    style: TextStyle(fontSize: 30),
                  ),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  SizedBox(height: 16),
                  Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      errorMessage = "";
                      if (usernameController.text != '' &&
                          passwordController.text != '') {
                        bool isSuccess = await signUp(
                            usernameController.text,
                            passwordController.text,
                            http.Client());
                        if (isSuccess) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        } else {
                          setState(() {
                            errorMessage = "Username is already taken";
                          });
                        }
                      } else {
                        setState(() {
                          errorMessage = "Enter all the required feilds";
                        });
                      }
                    },
                    child: Text('Sign Up'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
