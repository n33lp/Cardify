import 'dart:convert';

import 'questionanswer.dart';
import 'package:flutter/material.dart';
import 'folder.dart';
import 'document.dart';
import 'navigation.dart'; // Import the navigation manager
import 'starred_content.dart'; // Import the StarredContents widget you defined earlier
import 'trashbin.dart'; // Import the TrashContents widget you defined earlier
import 'profile.dart'; // Import the ProfilePage widget you defined earlier
import 'documentView.dart'; // Import the DocumentView widget you defined earlier
import 'flip_card.dart'; // Import the FlipCardPage widget you defined earlier
import 'package:http/http.dart' as http;
import 'UserManager.dart';
import 'package:flutter/services.dart';

class FolderContents extends StatefulWidget {
  final Folder folder;
  final Folder trashFolder;

  FolderContents({Key? key, required this.folder, required this.trashFolder})
      : super(key: key);

  @override
  _FolderContentsState createState() => _FolderContentsState();
}

class _FolderContentsState extends State<FolderContents> {
  late Folder currentFolder;
  late Folder trashFolder;
  late Map<String, dynamic> apiData;
  List<dynamic> newQuestions = [];

  String searchText = "";
  @override
  void initState() {
    super.initState();
    loadApiData();
    currentFolder = widget.folder;
    trashFolder = widget.trashFolder; // Initialize trashFolder from the widget
  }

  Future<bool> getQuestions(String content) async {
    var questionsUrl = apiData['TEST_LLM_URL'];

    try {
      var response = await http.post(
        Uri.parse(questionsUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user': UserManager().userID,
          'usertoken': UserManager().usertoken,
          'content': content,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        newQuestions = responseData['questions'] as List;
        return true;
      } else {
        print("Failed to fetch questions: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error fetching questions: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>> readJson() async {
    final String response = await rootBundle.loadString('creds/LLM_CREDS.json');
    final data = await json.decode(response);
    return data;
  }

  Future<void> loadApiData() async {
    apiData = await readJson();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> items = [
      ...currentFolder.subfolders,
      ...currentFolder.documents
    ];
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
        currentIndex: 0, // Update this based on current view
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              // NavigationManager.navigateTo(context, "Starred");

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

              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      TrashContents(
                          folder: currentFolder, trashFolder: trashFolder),
                  transitionDuration: Duration(seconds: 1),
                ),
              );
              break;
            case 3:
              // NavigationManager.navigateTo(context, "Profile");

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfilePage(
                        folder: currentFolder, trashFolder: trashFolder)),
              );

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

  Widget buildItemTile(dynamic item, int index) {
    return Dismissible(
      key: Key('item_$index'), // Using index as part of the key

      direction:
          DismissDirection.horizontal, // Allow swiping in both directions
      onDismissed: (direction) async {
        if (direction == DismissDirection.endToStart) {
          moveToTrash(item);
        } else if (direction == DismissDirection.startToEnd) {
          if (item is Document) {
            if (item.questions.isEmpty) {
              showLoadingDialog(context); // Show the loading dialog
              var success = await getQuestions(item.plaintext());
              Navigator.pop(context); // Dismiss the loading dialog
              if (success) {
                _addNewQuestion(item, newQuestions);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlipCardPage(
                        document: item,
                        folder: currentFolder,
                        trashFolder: trashFolder),
                  ),
                );
              } else {
                print("Failed to fetch questions, not navigating.");
              }
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlipCardPage(
                      document: item,
                      folder: currentFolder,
                      trashFolder: trashFolder),
                ),
              );
            }
          }
        }
      },

      background: Container(
        color: Colors.blue, // Color for FlipCard action
        alignment: Alignment.centerLeft,
        child: Icon(Icons.flip, color: Colors.white),
        padding: EdgeInsets.symmetric(horizontal: 20.0),
      ),
      secondaryBackground: Container(
        color: Colors.red, // Color for delete action
        alignment: Alignment.centerRight,
        child: Icon(Icons.delete, color: Colors.white),
        padding: EdgeInsets.symmetric(horizontal: 20.0),
      ),
      // background: Container(
      //   color: Colors.red,
      //   alignment: Alignment.centerRight,
      //   child: Icon(Icons.delete, color: Colors.white),
      //   padding: EdgeInsets.symmetric(horizontal: 20.0),
      // ),
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
          } else if (item is Document) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DocumentView(
                  document: item,
                  onUpdate: (updatedDocument) {
                    setState(() {
                      int index = currentFolder.documents.indexOf(item);
                      if (index != -1) {
                        currentFolder.documents[index] = updatedDocument;
                      }
                    });
                  },
                ),
              ),
            );
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
                  // testing
                  var qa1 = QuestionAnswer(
                      question: "What is the capital of France?",
                      answer: "Paris");
                  var qa2 = QuestionAnswer(
                      question: "What is the capital of Canada?",
                      answer: "Ottawa");
                  // keep
                  var addingDocument = Document(
                    name: _documentNameController.text,
                    createDate: DateTime.now(),
                    lastEditedDate: DateTime.now(),
                    content: jsonEncode([
                      {"insert": "\n"}
                    ]),
                    // questions: [qa1, qa2],
                    questions: [],
                    isStarred: false,
                  );
                  currentFolder.documents.add(addingDocument);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addNewQuestion(Document document, List<dynamic> Questions) {
    for (List pair in Questions) {
      var qa = QuestionAnswer(question: pair[0], answer: pair[1]);
      document.questions.add(qa);
    }
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // User must not close the dialog by tapping outside of it.
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 24),
              Text("Loading, please wait..."),
            ],
          ),
        );
      },
    );
  }
}
