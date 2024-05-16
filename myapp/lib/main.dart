import 'package:flutter/material.dart';
import 'folder.dart'; // Import the Folder class you defined earlier
import 'document.dart'; // Import the Document class you defined earlier
import 'folder_contents.dart';
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
