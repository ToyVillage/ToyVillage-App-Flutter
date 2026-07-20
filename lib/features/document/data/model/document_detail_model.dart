class DocumentFileModel {
  final String fileName;
  final String fileKey;

  DocumentFileModel({required this.fileName, required this.fileKey});

  factory DocumentFileModel.fromJson(Map<String, dynamic> json) {
    return DocumentFileModel(
      fileName: json['fileName'] as String,
      fileKey: json['fileKey'] as String,
    );
  }
}

class DocumentDetailModel {
  final int id;
  final String title;
  final String type;
  final DateTime createdAt;
  final List<DocumentFileModel> files;

  DocumentDetailModel({
    required this.id,
    required this.title,
    required this.type,
    required this.createdAt,
    required this.files,
  });

  factory DocumentDetailModel.fromJson(Map<String, dynamic> json) {
    final files = (json['files'] as List?) ?? const [];

    return DocumentDetailModel(
      id: json['id'] as int,
      title: json['title'] as String,
      type: json['type'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      files: files
          .map((e) => DocumentFileModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
