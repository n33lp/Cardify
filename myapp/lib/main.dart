/*
 main.dart is the entry point of the application.
*/
import 'package:flutter/material.dart';
import 'loginpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Document Manager',
      home: LoginPage(),
    );
  }
}
