import 'package:flutter/material.dart';
import 'loginpage.dart'; // Import the FolderContents widget you defined earlier

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Document Manager',
      home: LoginPage(), // Start with the Login Page
    );
  }
}
