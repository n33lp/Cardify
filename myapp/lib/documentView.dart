import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'document.dart' as myDoc; // Your Document model

class DocumentView extends StatefulWidget {
  final myDoc.Document document;

  DocumentView({Key? key, required this.document}) : super(key: key);

  @override
  _DocumentViewState createState() => _DocumentViewState();
}

class _DocumentViewState extends State<DocumentView> {
  late TextEditingController _nameController;
  late QuillController _quillController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.document.name);
    _quillController = QuillController(
        document: Document()..insert(0, widget.document.content),
        selection: TextSelection.collapsed(offset: 0));
    initDocument(); // This will load and potentially update the document.
  }

  void initDocument() async {
    myDoc.Document loadedDoc = await myDoc.Document.load();
    setState(() {
      _nameController.text =
          loadedDoc.name; // Update the controller with loaded name
      _quillController = QuillController(
          document: Document()..insert(0, loadedDoc.content),
          selection: TextSelection.collapsed(offset: 0));
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _nameController,
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
      widget.document.name =
          _nameController.text; // Update the in-memory object
      widget.document.content = _quillController.document
          .toPlainText(); // Update the in-memory object
    });
    await widget.document.save(); // Persist changes
    Navigator.pop(context); // Optionally pop or confirm save to the user
  }
}
