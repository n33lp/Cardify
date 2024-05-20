/*
 This class is to view all ther questions for that document.
*/

import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'document.dart';
import 'questionanswer.dart';
import 'folder_contents.dart';
import 'folder.dart';

class FlipCardPage extends StatefulWidget {
  final Document document;
  final Folder folder;
  final Folder trashFolder;

  FlipCardPage({
    Key? key,
    required this.document,
    required this.folder,
    required this.trashFolder,
  }) : super(key: key);

  @override
  _FlipCardPageState createState() => _FlipCardPageState();
}

class _FlipCardPageState extends State<FlipCardPage> {
  late Folder currentFolder;
  late Folder trashFolder;
  late PageController _pageController;
  late int currentPage;

  @override
  void initState() {
    super.initState();
    currentFolder = widget.folder;
    trashFolder = widget.trashFolder;
    _pageController = PageController(viewportFraction: 0.8);
    currentPage = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questions'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => FolderContents(
                  folder: currentFolder, trashFolder: trashFolder),
              transitionDuration: Duration(seconds: 1),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchQuestions,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.document.questions.length,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                QuestionAnswer qa = widget.document.questions[index];
                return Card(
                  child: FlipCard(
                    direction: FlipDirection.HORIZONTAL,
                    front: Container(
                      padding: EdgeInsets.all(30),
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Question",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                Text(qa.question,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black54)),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => editQuestionAnswer(qa, index),
                            ),
                          ),
                        ],
                      ),
                    ),
                    back: Container(
                      padding: EdgeInsets.all(30),
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Answer",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                Text(qa.answer,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black54)),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => editQuestionAnswer(qa, index),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.document.questions.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeIn,
                    );
                  },
                  child: Container(
                    width: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: currentPage == index ? Colors.blue : Colors.grey,
                    ),
                    child: Text("${index + 1}"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void fetchQuestions() async {
    Document newDocument = await Document.load();
    setState(() {
      widget.document.questions = newDocument.questions;
    });
  }

  void editQuestionAnswer(QuestionAnswer qa, int index) async {
    TextEditingController questionController =
        TextEditingController(text: qa.question);
    TextEditingController answerController =
        TextEditingController(text: qa.answer);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Question and Answer"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: questionController,
                decoration: InputDecoration(labelText: "Question"),
              ),
              TextField(
                controller: answerController,
                decoration: InputDecoration(labelText: "Answer"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Save"),
              onPressed: () {
                setState(() {
                  qa.question = questionController.text;
                  qa.answer = answerController.text;
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
