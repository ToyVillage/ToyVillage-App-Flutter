class NoticeModel {
  final int id;
  final String title;
  final String kind;
  final DateTime createAt;

  NoticeModel({
    required this.id,
    required this.title,
    required this.kind,
    required this.createAt
  });
}