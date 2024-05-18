import 'package:dart_quill_delta/src/delta/delta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'document.dart' as myDoc;
import 'dart:convert';

class DocumentView extends StatefulWidget {
  final myDoc.Document document;
  final Function(myDoc.Document) onUpdate;

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
    nameController = TextEditingController(text: widget.document.name);
    _quillController = QuillController(
        document: Document()..insert(0, widget.document.content),
        selection: TextSelection.collapsed(offset: 0));
    initDocument(widget.document);
  }

  void initDocument(myDoc.Document currentDoc) async {
    myDoc.Document loadedDoc = await myDoc.Document.load();
    setState(() {
      nameController.text = currentDoc.name;
      List<dynamic> jsonDelta = jsonDecode(currentDoc.content);

      Delta delta = Delta.fromJson(jsonDelta);
      _quillController = QuillController(
          document: Document.fromDelta(delta),
          selection: TextSelection.collapsed(offset: 0));
    });
  }

  void initDocument2() async {
    myDoc.Document loadedDoc = await myDoc.Document.load();
    setState(() {
      nameController.text = loadedDoc.name;

      List<dynamic> jsonDelta = jsonDecode(loadedDoc.content);

      Delta delta = Delta.fromJson(jsonDelta);
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
              widget.document.name = newName;
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
      backgroundColor: Colors.grey[200],
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
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.85,
                color: Colors.white,
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
      widget.document.content =
          jsonEncode(_quillController.document.toDelta().toJson());
    });

    await widget.document.save();
    widget.onUpdate(widget.document);
    Navigator.pop(context);
  }
}
