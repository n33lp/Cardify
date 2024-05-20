/*
  LoginPage class
  This class is the login page of the application.
  It contains a form with two text fields for username and password.
  The user can enter their credentials and click the login button to login.
  The login button calls the login function which sends a POST request to the server with the entered credentials.
  If the credentials are correct, the server responds with the user's data and the user is logged in.
  If the credentials are incorrect, the server responds with an error message and the user is not logged in.
  The user can also click the register button to navigate to the register page.

*/

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'folder.dart';
import 'folder_contents.dart';
import 'package:flutter/services.dart';
import 'register_page.dart';
import 'UserManager.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late Map<String, dynamic> apiData;

  @override
  void initState() {
    super.initState();
    loadApiData();
  }

  Future<void> login() async {
    var url = apiData['LOGIN_URL'];

    var response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': _usernameController.text,
        'password': _passwordController.text,
      }),
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      UserManager().setUser(
          name: responseData['firstname'] + " " + responseData['lastname'],
          email: responseData['email'],
          picUrl: responseData['profilepic'],
          token: responseData['token'],
          id: _usernameController.text);
      Folder rootFolder = Folder(
        name: "Root",
        createDate: DateTime.now(),
        lastEditedDate: DateTime.now(),
        documents: [],
        subfolders: [],
        isStarred: false,
      );
      Folder trashFolder = Folder(
        name: "Trash",
        createDate: DateTime.now(),
        lastEditedDate: DateTime.now(),
        documents: [],
        subfolders: [],
        isStarred: false,
      );

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => FolderContents(
                  folder: rootFolder, trashFolder: trashFolder)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid username or password')),
      );
    }
  }

  Future<Map<String, dynamic>> readJson() async {
    final String response =
        await rootBundle.loadString('creds/USER_CREDS.json');
    final data = await json.decode(response);
    return data;
  }

  Future<void> loadApiData() async {
    apiData = await readJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: null),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          width: MediaQuery.of(context).size.width * 0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Cardify Login!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                ),
                obscureText: true,
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: login,
                      child: Text('Login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RegisterPage(apiData: apiData),
                          ),
                        );
                      },
                      child: Text('Register'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
