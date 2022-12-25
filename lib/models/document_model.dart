import 'dart:convert';

class DocumentModel {
  final String id, uid, title;
  final List content;
  final DateTime createdAt;

  const DocumentModel({
    required this.id,
    required this.uid,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'uid': uid,
      'title': title,
      'content': content,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      id: map['_id'] ?? '',
      uid: map['uid'] ?? '',
      title: map['title'] ?? '',
      content: List.from(map['content'] ?? []),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentModel.fromJson(String source) =>
      DocumentModel.fromMap(json.decode(source));
}
