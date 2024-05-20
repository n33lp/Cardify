/*
  this class is used to display the starred contents of the user.
*/

import 'package:flutter/material.dart';
import 'folder.dart';
import 'document.dart';
import 'folder_contents.dart';
import 'trashbin.dart';
import 'profile.dart';

class StarredContents extends StatefulWidget {
  final Folder folder;
  final Folder trashFolder;

  StarredContents({Key? key, required this.folder, required this.trashFolder})
      : super(key: key);

  @override
  _StarredContentsState createState() => _StarredContentsState();
}

class _StarredContentsState extends State<StarredContents> {
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
    List<dynamic> items = [
      ...currentFolder.subfolders,
      ...currentFolder.documents
    ];
    items = items.where((item) => item.isStarred).toList();
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
          return buildItemTile(item, index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOptions(context),
        child: Icon(Icons.add),
        tooltip: 'Add Item',
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

  Widget buildItemTile(dynamic item, int index) {
    return Dismissible(
      key: Key('item_$index'),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          moveToTrash(item);
        });
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: Icon(Icons.delete, color: Colors.white),
        padding: EdgeInsets.symmetric(horizontal: 20.0),
      ),
      child: ListTile(
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
                    builder: (context) => FolderContents(
                        folder: item, trashFolder: trashFolder)));
          }
        },
      ),
    );
  }

  void moveToTrash(dynamic item) {
    setState(() {
      if (item is Folder) {
        trashFolder.subfolders.add(item);
        currentFolder.subfolders.remove(item);
      } else if (item is Document) {
        trashFolder.documents.add(item);
        currentFolder.documents.remove(item);
      }
    });
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.folder),
                title: Text('Add Folder'),
                onTap: () => _addFolder(context),
              ),
              ListTile(
                leading: Icon(Icons.description),
                title: Text('Add Document'),
                onTap: () => _addDocument(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addFolder(BuildContext context) {
    Navigator.pop(context);
    TextEditingController _folderNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Folder Name'),
          content: TextField(
            controller: _folderNameController,
            decoration: InputDecoration(hintText: "Folder Name"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                setState(() {
                  currentFolder.subfolders.add(
                    Folder(
                      name: _folderNameController.text,
                      createDate: DateTime.now(),
                      lastEditedDate: DateTime.now(),
                      documents: [],
                      subfolders: [],
                      isStarred: true,
                    ),
                  );
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addDocument(BuildContext context) {
    Navigator.pop(context);
    TextEditingController _documentNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Document Name'),
          content: TextField(
            controller: _documentNameController,
            decoration: InputDecoration(hintText: "Document Name"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                setState(() {
                  currentFolder.documents.add(
                    Document(
                      name: _documentNameController.text,
                      createDate: DateTime.now(),
                      lastEditedDate: DateTime.now(),
                      content: "",
                      questions: [],
                      isStarred: true,
                    ),
                  );
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
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
