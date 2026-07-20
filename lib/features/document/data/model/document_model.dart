class DocumentModel {
  final int id;
  final String title;
  final String type;
  final DateTime createdAt;

  DocumentModel({
    required this.id,
    required this.title,
    required this.type,
    required this.createdAt,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] as int,
      title: json['title'] as String,
      type: json['type'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
