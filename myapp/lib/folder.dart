import 'document.dart'; // Import the Document class if it's in a separate file.

/// A class representing a folder that can contain multiple documents and subfolders.
class Folder {
  /// The name of the folder.
  String name;

  /// The date the folder was created.
  DateTime createDate;

  /// The date the folder was last edited.
  DateTime lastEditedDate;

  /// A list of Document objects contained within the folder.
  List<Document> documents;

  /// A list of Folder objects contained within the folder (subfolders).
  List<Folder> subfolders;

  /// Indicates whether the folder is starred (marked as important).
  bool isStarred;

  /// Constructs a new [Folder] instance.
  ///
  /// Requires [name], [createDate], [lastEditedDate], [documents], [subfolders], and an optional [isStarred] to be provided.
  Folder({
    required this.name,
    required this.createDate,
    required this.lastEditedDate,
    required this.documents,
    required this.subfolders,
    this.isStarred = false, // Default is not starred
  });

  /// Creates a new [Folder] from a JSON object.
  ///
  /// Useful for serialization and deserialization with APIs.
  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(
      name: json['name'],
      createDate: DateTime.parse(json['createDate']),
      lastEditedDate: DateTime.parse(json['lastEditedDate']),
      documents: List<Document>.from(
          json['documents'].map((x) => Document.fromJson(x))),
      subfolders:
          List<Folder>.from(json['subfolders'].map((x) => Folder.fromJson(x))),
      isStarred:
          json['isStarred'] ?? false, // Default to false if not specified
    );
  }

  /// Converts a [Folder] instance to a JSON object.
  ///
  /// Useful for sending data to APIs or storing in databases.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'createDate': createDate.toIso8601String(),
      'lastEditedDate': lastEditedDate.toIso8601String(),
      'documents': documents.map((x) => x.toJson()).toList(),
      'subfolders': subfolders.map((x) => x.toJson()).toList(),
      'isStarred': isStarred,
    };
  }

  /// A utility method for displaying a formatted folder details.
  @override
  String toString() {
    return 'Name: $name\nCreated: $createDate\nLast Edited: $lastEditedDate\nStarred: $isStarred\nDocuments: ${documents.length}\nSubfolders: ${subfolders.length}';
  }
}

// var childFolder = Folder(
//     name: "Work Documents",
//     createDate: DateTime.now(),
//     lastEditedDate: DateTime.now(),
//     documents: [],
//     subfolders: [],
//     isStarred: false
// );

// var myFolder = Folder(
//     name: "Work Documents",
//     createDate: DateTime.now(),
//     lastEditedDate: DateTime.now(),
//     documents: [],
//     subfolders: [childFolder],
//     isStarred: true
// );
