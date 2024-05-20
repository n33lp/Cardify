/*
this is the trashbin page where the user can see the deleted files and folders
*/

import 'package:flutter/material.dart';
import 'folder.dart';
import 'starred_content.dart';
import 'folder_contents.dart';
import 'profile.dart';

class TrashContents extends StatefulWidget {
  final Folder folder;
  final Folder trashFolder;

  TrashContents({Key? key, required this.folder, required this.trashFolder})
      : super(key: key);

  @override
  _TrashContentsState createState() => _TrashContentsState();
}

class _TrashContentsState extends State<TrashContents> {
  late Folder currentFolder;
  late Folder trashFolder;

  String searchText = "";
  @override
  void initState() {
    super.initState();
    currentFolder = widget.folder;
    trashFolder = widget.trashFolder;
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> items = [...trashFolder.subfolders, ...trashFolder.documents];
    if (searchText.isNotEmpty) {
      items = items.where((item) {
        return item.name.toLowerCase().contains(searchText.toLowerCase());
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) {
            setState(() {
              searchText = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Search...',
            icon: Icon(Icons.search),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          var item = items[index];
          return buildItemTile(item);
        },
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

  Widget buildItemTile(dynamic item) {
    return ListTile(
      leading: Icon(item is Folder ? Icons.folder : Icons.description),
      title: Text(item.name),
      subtitle: Text("Last edited: ${item.lastEditedDate}"),
      trailing: IconButton(
        icon: Icon(item.isStarred ? Icons.star : Icons.star_border),
        color: Colors.yellow[700],
        onPressed: () {
          setState(() {
            item.isStarred = !item.isStarred;
          });
        },
      ),
      onTap: () {
        if (item is Folder) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      FolderContents(folder: item, trashFolder: trashFolder)));
        }
      },
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
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProfilePage(folder: currentFolder, trashFolder: trashFolder)),
        );
        break;
    }
  }
}
