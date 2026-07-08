class NoticeDetailModel {
  final int id;
  final String title;
  final String kind;
  final String content;
  final DateTime createdAt;

  NoticeDetailModel({
    required this.id,
    required this.title,
    required this.kind,
    required this.content,
    required this.createdAt,
  });

  factory NoticeDetailModel.fromJson(Map<String, dynamic> json) {
    return NoticeDetailModel(
        id: json['id'] as int,
        title: json['title'] as String,
        kind: json['kind'] as String,
        content: json['content'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
