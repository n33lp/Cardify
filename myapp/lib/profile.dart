import 'package:flutter/material.dart';
import 'folder.dart';
import 'folder_contents.dart';
import 'trashbin.dart';
import 'starred_content.dart';

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
  // Sample user data - you can fetch these details from a user model or API
  String userName = "John Doe";
  String userEmail = "johndoe@example.com";
  String userProfilePicUrl =
      "https://via.placeholder.com/150"; // Placeholder image URL

  @override
  void initState() {
    super.initState();
    currentFolder = widget.folder;
    trashFolder = widget.trashFolder; // Initialize trashFolder from the widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Handle profile edit
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
              backgroundImage: AssetImage('images/stock_profilepic.png'),
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
              onPressed: () {
                // Handle user logout
                print("Logout tapped");
              },
              child: Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red, // For the background color of the button
                foregroundColor: Colors
                    .white, // Updated from 'onPrimary' to 'foregroundColor' for the text color
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Update this based on current view
        onTap: (index) {
          switch (index) {
            case 0:
              // NavigationManager.navigateTo(context, "StarredContents");
              print("Home");
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) =>
              //           FolderContents(folder: currentFolder)),
              // // );
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      FolderContents(
                          folder: currentFolder, trashFolder: trashFolder),
                  transitionDuration: Duration(seconds: 1),
                ),
              );
              break;
            case 1:
              // NavigationManager.navigateTo(context, "Starred");
              print("Starred");
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      StarredContents(
                          folder: currentFolder, trashFolder: trashFolder),
                  transitionDuration: Duration(seconds: 1),
                ),
              );
              break;
            case 2:
              // NavigationManager.navigateTo(context, "Trash");
              print("Trash");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => TrashContents(
                        folder: currentFolder, trashFolder: trashFolder)),
              );
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => TrashContents(
              //           folder: currentFolder, trashFolder: trashFolder)),
              // );
              break;
            case 3:
              // NavigationManager.navigateTo(context, "Profile");
              // print("Profile");
              break;
          }
        },
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
        selectedItemColor: Colors.black, // Keeps selected item label black
        unselectedItemColor: Colors.grey, // Keeps unselected item label black
        showUnselectedLabels:
            true, // Explicitly ensure unselected labels are shown
        showSelectedLabels: true, // Explicitly ensure selected labels are shown
      ),
    );
  }
}
