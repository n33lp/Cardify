import 'package:flutter/material.dart';
import 'folder.dart'; // Import the Folder class you defined earlier
import 'document.dart'; // Import the Document class you defined earlier

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Document Manager',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Folder rootFolder = Folder(
    name: "Root",
    createDate: DateTime.now(),
    lastEditedDate: DateTime.now(),
    documents: [],
    subfolders: [],
    isStarred: false,
  );

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
                onTap: () {
                  // Future implementation for adding documents
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _addFolder(BuildContext context) {
    Navigator.pop(context); // Close the bottom sheet
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
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                setState(() {
                  rootFolder.subfolders.add(
                    Folder(
                      name: _folderNameController.text,
                      createDate: DateTime.now(),
                      lastEditedDate: DateTime.now(),
                      documents: [],
                      subfolders: [],
                      isStarred: false,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Notes'),
      ),
      body: ListView.builder(
        itemCount: rootFolder.subfolders.length + rootFolder.documents.length,
        itemBuilder: (context, index) {
          var items = [...rootFolder.subfolders, ...rootFolder.documents];
          var item = items[index];
          return ListTile(
            leading: Icon(item is Folder ? Icons.folder : Icons.description),
            // title: Text(item.name),
            // subtitle: Text("Last edited: ${item.lastEditedDate}"),
            title: Text("testing1"),
            subtitle: Text("testing2"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOptions(context),
        tooltip: 'Add Item',
        child: Icon(Icons.add),
      ),
    );
  }
}
