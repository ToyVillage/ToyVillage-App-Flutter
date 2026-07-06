class NoticeDetailModel {
  final int id;
  final String title;
  final String kind;
  final String content;
  final DateTime createAt;

  NoticeDetailModel({
    required this.id,
    required this.title,
    required this.kind,
    required this.content,
    required this.createAt,
  });
}
