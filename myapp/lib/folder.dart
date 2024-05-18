import 'document.dart';

class Folder {
  String name;

  DateTime createDate;

  DateTime lastEditedDate;

  List<Document> documents;

  List<Folder> subfolders;

  bool isStarred;

  Folder({
    required this.name,
    required this.createDate,
    required this.lastEditedDate,
    required this.documents,
    required this.subfolders,
    this.isStarred = false,
  });

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

  @override
  String toString() {
    return 'Name: $name\nCreated: $createDate\nLast Edited: $lastEditedDate\nStarred: $isStarred\nDocuments: ${documents.length}\nSubfolders: ${subfolders.length}';
  }
}
