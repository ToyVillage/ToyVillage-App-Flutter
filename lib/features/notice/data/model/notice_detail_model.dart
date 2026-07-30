class NoticeFileModel {
  final String fileName;
  final String fileKey;

  NoticeFileModel({required this.fileName, required this.fileKey});

  factory NoticeFileModel.fromJson(Map<String, dynamic> json) {
    return NoticeFileModel(
      fileName: json['fileName'] as String,
      fileKey: json['fileKey'] as String,
    );
  }
}

class NoticeDetailModel {
  final int id;
  final String title;
  final String kind;
  final String content;
  final DateTime createdAt;
  final List<NoticeFileModel> files;

  NoticeDetailModel({
    required this.id,
    required this.title,
    required this.kind,
    required this.content,
    required this.createdAt,
    required this.files,
  });

  factory NoticeDetailModel.fromJson(Map<String, dynamic> json) {
    final files = (json['files'] as List?) ?? const [];

    return NoticeDetailModel(
        id: json['id'] as int,
        title: json['title'] as String,
        kind: json['kind'] as String,
        content: json['content'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        files: files
            .map((e) => NoticeFileModel.fromJson(e as Map<String, dynamic>))
            .toList(),
    );
  }
}
