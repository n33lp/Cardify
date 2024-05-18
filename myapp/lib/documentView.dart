import 'package:dart_quill_delta/src/delta/delta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'document.dart' as myDoc; // Your Document model
import 'dart:convert';

class DocumentView extends StatefulWidget {
  final myDoc.Document document;
  final Function(myDoc.Document)
      onUpdate; // Callback to update the document in the parent

  DocumentView({Key? key, required this.document, required this.onUpdate})
      : super(key: key);

  @override
  _DocumentViewState createState() => _DocumentViewState();
}

class _DocumentViewState extends State<DocumentView> {
  late TextEditingController nameController;
  late QuillController _quillController;

  @override
  void initState() {
    super.initState();
    // print("Document name is: ${widget.document.name}");
    nameController = TextEditingController(text: widget.document.name);
    // print("nameController name is: ${nameController.text}");
    _quillController = QuillController(
        document: Document()..insert(0, widget.document.content),
        selection: TextSelection.collapsed(offset: 0));
    initDocument(
        widget.document); // This will load and potentially update the document.
    // initDocument2();
  }

  void initDocument(myDoc.Document currentDoc) async {
    myDoc.Document loadedDoc = await myDoc.Document.load();
    setState(() {
      nameController.text = currentDoc.name;
      // print("myDoc name is: ${currentDoc.name}");
      // print("nameController.text in initDocument is: ${nameController.text}");
      // Convert the JSON string back to a Delta
      List<dynamic> jsonDelta =
          jsonDecode(currentDoc.content); // This should be a List

      Delta delta = Delta.fromJson(jsonDelta);
      // Use the delta to create a new document for the QuillController
      _quillController = QuillController(
          document: Document.fromDelta(delta),
          selection: TextSelection.collapsed(offset: 0));
    });
  }

  void initDocument2() async {
    myDoc.Document loadedDoc = await myDoc.Document.load();
    setState(() {
      nameController.text = loadedDoc.name;
      // print("myDoc name is: ${loadedDoc.name}");
      // print("nameController.text in initDocument is: ${nameController.text}");
      // Convert the JSON string back to a Delta
      List<dynamic> jsonDelta =
          jsonDecode(loadedDoc.content); // This should be a List
      // print('jsonDelta: ${jsonDelta}');
      // print("loadedDoc.content: ${loadedDoc.content}");
      Delta delta = Delta.fromJson(jsonDelta);
      // print('delta: ${delta}');
      // Use the delta to create a new document for the QuillController
      _quillController = QuillController(
          document: Document.fromDelta(delta),
          selection: TextSelection.collapsed(offset: 0));
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    _quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: nameController,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: 'Document Name',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.black),
          ),
          onSubmitted: (newName) {
            setState(() {
              widget.document.name = newName; // Update document name
            });
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveDocument(),
          ),
        ],
      ),
      backgroundColor:
          Colors.grey[200], // Set the background color to light grey
      body: Column(
        children: [
          QuillToolbar.simple(
            configurations: QuillSimpleToolbarConfigurations(
              controller: _quillController,
              sharedConfigurations: const QuillSharedConfigurations(
                locale: Locale('de'),
              ),
            ),
          ),
          Expanded(
            child: Center(
              // Center the 'page' in the view
              child: Container(
                width: MediaQuery.of(context).size.width *
                    0.9, // Adjust width as needed
                height: MediaQuery.of(context).size.height *
                    0.85, // Adjust height as needed
                color: Colors.white, // Set the 'page' color to white
                child: QuillEditor.basic(
                  configurations: QuillEditorConfigurations(
                    controller: _quillController,
                    sharedConfigurations: const QuillSharedConfigurations(
                      locale: Locale('de'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveDocument() async {
    setState(() {
      widget.document.name = nameController.text;
      // print('_quillController.document ${_quillController.document}');
      // print(
      //     '_quillController.document.toDelta() ${_quillController.document.toDelta()}');
      // print(
      //     '_quillController.document.toDelta().toJson() ${_quillController.document.toDelta().toJson()}');
      widget.document.content = jsonEncode(_quillController.document
          .toDelta()
          .toJson()); // Save the full delta as JSON
    });
    // print("saving as widget.document.content ${widget.document.content}");
    await widget.document
        .save(); // Make sure your save method handles this JSON appropriately
    widget.onUpdate(
        widget.document); // Call the callback with the updated document
    Navigator.pop(context);
    // print("widget.document.name ${widget.document.name}");

    // dispose();
  }
}
