/*
this is the profile page where the user can see their profile details and logout
*/
import 'package:flutter/material.dart';
import 'folder.dart';
import 'folder_contents.dart';
import 'trashbin.dart';
import 'starred_content.dart';
import 'UserManager.dart';
import 'loginpage.dart';
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  final Folder folder;
  final Folder trashFolder;

  ProfilePage({Key? key, required this.folder, required this.trashFolder})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Folder currentFolder;
  late Folder trashFolder;

  String userName = "John Doe";
  String userEmail = "johndoe@example.com";
  String userProfilePicUrl = "https://via.placeholder.com/150";

  @override
  void initState() {
    super.initState();
    currentFolder = widget.folder;
    trashFolder = widget.trashFolder;
  }

  @override
  Widget build(BuildContext context) {
    String userName = UserManager().userName ?? "Default Name";
    String userEmail = UserManager().userEmail ?? "default@example.com";
    final decodedBytes = base64Decode(UserManager().userProfilePicUrl);
    final image = MemoryImage(decodedBytes);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              print("Edit profile tapped");
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 60,
              backgroundImage: image,
              backgroundColor: Colors.red,
            ),
            SizedBox(height: 30),
            Text(
              userName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              userEmail,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => logoutUser(),
              child: Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) => _navigate(index),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.black), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.star, color: Colors.black), label: 'Starred'),
          BottomNavigationBarItem(
            icon: Icon(Icons.delete, color: Colors.black),
            label: 'Trash',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle, color: Colors.black),
              label: 'Profile'),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        showSelectedLabels: true,
      ),
    );
  }

  void logoutUser() {
    UserManager().clearUser();
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _navigate(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                FolderContents(folder: currentFolder, trashFolder: trashFolder),
            transitionDuration: Duration(seconds: 1),
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => StarredContents(
                folder: currentFolder, trashFolder: trashFolder),
            transitionDuration: Duration(seconds: 1),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => TrashContents(
                  folder: currentFolder, trashFolder: trashFolder)),
        );

        break;
      case 3:
        break;
    }
  }
}
