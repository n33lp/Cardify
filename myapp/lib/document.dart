import 'questionanswer.dart'; // Import the QuestionAnswer class if it's in a separate file.

/// A class representing a document with related data.
class Document {
  /// The name of the document.
  String name;

  /// The date the document was created.
  DateTime createDate;

  /// The date the document was last edited.
  DateTime lastEditedDate;

  /// The main content of the document.
  String content;

  /// A list of QuestionAnswer objects associated with the document.
  List<QuestionAnswer> questions;

  /// Indicates whether the document is starred (marked as important).
  bool isStarred;

  /// Constructs a new [Document] instance.
  ///
  /// Requires [name], [createDate], [lastEditedDate], [content], [questions], and an optional [isStarred] to be provided.
  Document({
    required this.name,
    required this.createDate,
    required this.lastEditedDate,
    required this.content,
    required this.questions,
    this.isStarred = false, // Default is not starred
  });

  /// Creates a new [Document] from a JSON object.
  ///
  /// Useful for serialization and deserialization with APIs.
  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      name: json['name'],
      createDate: DateTime.parse(json['createDate']),
      lastEditedDate: DateTime.parse(json['lastEditedDate']),
      content: json['content'],
      questions: List<QuestionAnswer>.from(
          json['questions'].map((x) => QuestionAnswer.fromJson(x))),
      isStarred:
          json['isStarred'] ?? false, // Default to false if not specified
    );
  }

  /// Converts a [Document] instance to a JSON object.
  ///
  /// Useful for sending data to APIs or storing in databases.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'createDate': createDate.toIso8601String(),
      'lastEditedDate': lastEditedDate.toIso8601String(),
      'content': content,
      'questions': questions.map((x) => x.toJson()).toList(),
      'isStarred': isStarred,
    };
  }

  /// A utility method for displaying a formatted document details.
  @override
  String toString() {
    return 'Name: $name\nCreated: $createDate\nLast Edited: $lastEditedDate\nContent: $content\nStarred: $isStarred\nQuestions: ${questions.map((q) => q.toString()).join('\n')}';
  }
}

// var myDocument = Document(
//   name: "My Important Document",
//   createDate: DateTime.now(),
//   lastEditedDate: DateTime.now(),
//   content: "Here is some example content for the document.",
//   questions: [],
//   isStarred: true  // This document is marked as important
// );
