import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'document.dart';
import 'questionanswer.dart';
import 'folder_contents.dart'; // Import the FolderContents widget you defined earlier
import 'folder.dart'; // Import the Folder class

class FlipCardPage extends StatefulWidget {
  final Document document;
  final Folder folder;
  final Folder trashFolder;

  FlipCardPage(
      {Key? key,
      required this.document,
      required this.folder,
      required this.trashFolder})
      : super(key: key);

  @override
  _FlipCardPageState createState() => _FlipCardPageState();
}

class _FlipCardPageState extends State<FlipCardPage> {
  late Folder currentFolder;
  late Folder trashFolder;
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
        title: Text('Q Cards'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            print("Back button pressed");
            Navigator.of(context)
                .pop(); // Ensures returning to the previous screen
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    FolderContents(
                        folder: currentFolder, trashFolder: trashFolder),
                transitionDuration: Duration(seconds: 1),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchQuestions,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: widget.document.questions.length,
        itemBuilder: (context, index) {
          QuestionAnswer qa = widget.document.questions[index];
          return Card(
            child: FlipCard(
              direction: FlipDirection.HORIZONTAL,
              front: Container(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(qa.question),
                ),
              ),
              back: Container(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(qa.answer),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void fetchQuestions() async {
    // Function to fetch or regenerate the document's questions
    Document newDocument =
        await Document.load(); // Assuming Document.load() fetches new data
    setState(() {
      widget.document.questions = newDocument.questions;
    });
  }
}
