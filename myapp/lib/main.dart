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
      home: FolderContents(
          folder: rootFolder,
          trashFolder: trashFolder), // Start with the root folder
    );
  }
}
