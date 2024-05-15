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
    _pageController = PageController(
        viewportFraction:
            0.8); // Adjust viewport fraction for better swiping experience
    currentPage = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questions'),
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
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize
                              .min, // Use 'min' to reduce excess space and center the column itself
                          children: [
                            Text(
                              "Question",
                              textAlign: TextAlign
                                  .center, // Center the text "Question" horizontally
                              style: TextStyle(
                                fontSize:
                                    20, // Set the font size for the header
                                fontWeight:
                                    FontWeight.bold, // Make the header bold
                              ),
                            ),
                            SizedBox(
                                height:
                                    8), // Provide some spacing between the texts
                            Text(
                              qa.question,
                              textAlign: TextAlign
                                  .center, // Center the actual question horizontally
                              style: TextStyle(
                                fontSize:
                                    16, // Set the font size for the question
                                color: Colors
                                    .black54, // Set the text color, assuming a light background
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    back: Container(
                      padding: EdgeInsets.all(30),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize
                              .min, // Use 'min' to reduce excess space and center the column itself
                          children: [
                            Text(
                              "Answer",
                              textAlign: TextAlign
                                  .center, // Center the text "Question" horizontally
                              style: TextStyle(
                                fontSize:
                                    20, // Set the font size for the header
                                fontWeight:
                                    FontWeight.bold, // Make the header bold
                              ),
                            ),
                            SizedBox(
                                height:
                                    8), // Provide some spacing between the texts
                            Text(
                              qa.answer,
                              textAlign: TextAlign
                                  .center, // Center the actual question horizontally
                              style: TextStyle(
                                fontSize:
                                    16, // Set the font size for the question
                                color: Colors
                                    .black54, // Set the text color, assuming a light background
                              ),
                            ),
                          ],
                        ),
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
    Document newDocument =
        await Document.load(); // Assuming Document.load() fetches new data
    setState(() {
      widget.document.questions = newDocument.questions;
    });
  }
}
