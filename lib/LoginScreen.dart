import 'dart:html';

import 'package:amazon_bookstore/ProductListScreen.dart';
import 'package:amazon_bookstore/Providers/LoginProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget
{
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

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
                  Text("BookStore Login", style: TextStyle(fontSize: 30),),
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
                  Text(errorMessage, style: TextStyle(color: Colors.red),),
                  ElevatedButton(
                    onPressed: () async {
                      errorMessage ="";
                      int userId = await loginProvider.authenticate(usernameController.text, passwordController.text, context);
                      if(userId != -1) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProductListScreen()));
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
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
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
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
                  Text("BookStore Signup", style: TextStyle(fontSize: 30),),
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
                  Text(errorMessage, style: TextStyle(color: Colors.red),),
                  ElevatedButton(
                    onPressed: () async {
                      errorMessage ="";
                      if(usernameController.text != '' && passwordController.text != '') {
                        bool isSuccess = await loginProvider.signUp(usernameController.text, passwordController.text, context);
                        if(isSuccess) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
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
