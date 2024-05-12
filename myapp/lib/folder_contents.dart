import 'package:flutter/material.dart';
import 'folder.dart'; // Make sure to have your Folder class defined in folder.dart
import 'document.dart'; // And Document class in document.dart

class FolderContents extends StatefulWidget {
  final Folder folder;

  FolderContents({Key? key, required this.folder}) : super(key: key);

  @override
  _FolderContentsState createState() => _FolderContentsState();
}

class _FolderContentsState extends State<FolderContents> {
  late Folder currentFolder;

  @override
  void initState() {
    super.initState();
    currentFolder = widget.folder;
  }

  void updateFolder(Folder folder) {
    setState(() {
      currentFolder = folder;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> items = [
      ...currentFolder.subfolders,
      ...currentFolder.documents
    ];

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search...',
            icon: Icon(Icons.search),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white),
          onChanged: (value) {
            // Implement search filtering logic
          },
        ),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          var item = items[index];
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
                        builder: (context) => FolderContents(folder: item)));
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOptions(context),
        child: Icon(Icons.add),
        tooltip: 'Add Item',
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
                  currentFolder.subfolders.add(
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
                  currentFolder.documents.add(
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
