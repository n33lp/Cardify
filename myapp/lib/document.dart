import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'questionanswer.dart'; // Import the QuestionAnswer class if it's in a separate file.

// Ensure you have the QuestionAnswer class imported or defined as needed.

class Document {
  String name;
  DateTime createDate;
  DateTime lastEditedDate;
  String content;
  List<QuestionAnswer> questions;
  bool isStarred;

  Document({
    required this.name,
    required this.createDate,
    required this.lastEditedDate,
    required this.content,
    required this.questions,
    this.isStarred = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': this.name,
      'createDate': this.createDate.toIso8601String(),
      'lastEditedDate': this.lastEditedDate.toIso8601String(),
      'content': this.content,
      'questions': this.questions.map((x) => x.toJson()).toList(),
      'isStarred': this.isStarred,
    };
  }

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      name: json['name'],
      createDate: DateTime.parse(json['createDate']),
      lastEditedDate: DateTime.parse(json['lastEditedDate']),
      content: json['content'],
      questions: List<QuestionAnswer>.from(
          json['questions'].map((x) => QuestionAnswer.fromJson(x))),
      isStarred: json['isStarred'] ?? false,
    );
  }

  static Future<Document> load() async {
    final prefs = await SharedPreferences.getInstance();
    String? docJson = prefs.getString('document');
    if (docJson != null) {
      return Document.fromJson(jsonDecode(docJson));
    } else {
      // Return a default document if nothing is saved
      return Document(
        name: 'New Document',
        createDate: DateTime.now(),
        lastEditedDate: DateTime.now(),
        content: '',
        questions: [],
        isStarred: false,
      );
    }
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('document', jsonEncode(this.toJson()));
  }

  @override
  String toString() {
    return 'Name: $name\nCreated: $createDate\nLast Edited: $lastEditedDate\nContent: $content\nStarred: $isStarred\nQuestions: ${questions.map((q) => q.toString()).join('\n')}';
  }
}
