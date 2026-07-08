class NoticeModel {
  final int id;
  final String title;
  final String kind;
  final DateTime createdAt;

  NoticeModel({
    required this.id,
    required this.title,
    required this.kind,
    required this.createdAt
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      id: json['id'] as int,
      title: json['title'] as String,
      kind: json['kind'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}