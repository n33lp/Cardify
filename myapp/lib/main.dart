import 'package:flutter/material.dart';
import 'folder.dart'; // Import the Folder class you defined earlier
import 'document.dart'; // Import the Document class you defined earlier
import 'folder_contents.dart'; // Import the FolderContents widget you defined earlier

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
    return MaterialApp(
      title: 'Document Manager',
      home: FolderContents(folder: rootFolder), // Start with the root folder
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

  String searchText = "";

  @override
  Widget build(BuildContext context) {
    List<dynamic> items = [...rootFolder.subfolders, ...rootFolder.documents];
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
            icon: Icon(Icons.search, color: Color.fromARGB(255, 59, 59, 59)),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          var item = items[index];
          bool isStarred =
              (item is Folder) ? item.isStarred : (item as Document).isStarred;
          return ListTile(
            leading: Icon(item is Folder ? Icons.folder : Icons.description),
            title: Text(item.name),
            subtitle: Text("Last edited: ${item.lastEditedDate}"),
            trailing: IconButton(
              icon: Icon(isStarred ? Icons.star : Icons.star_border),
              onPressed: () {
                setState(() {
                  if (item is Folder) {
                    item.isStarred = !item.isStarred;
                  } else if (item is Document) {
                    item.isStarred = !item.isStarred;
                  }
                });
              },
              color: Colors.yellow[700],
            ),
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

  void _addDocument(BuildContext context) {
    Navigator.pop(context); // Close the bottom sheet
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
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                setState(() {
                  rootFolder.documents.add(
                    Document(
                      name: _documentNameController.text,
                      createDate: DateTime.now(),
                      lastEditedDate: DateTime.now(),
                      content: "",
                      questions: [],
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
}
