import 'package:toy_village_app/features/notice/data/model/notice_kind.dart';

class NoticeModel {
  final int id;
  final String title;
  final List<String> teams;
  final DateTime createdAt;

  NoticeModel({
    required this.id,
    required this.title,
    required this.teams,
    required this.createdAt,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      id: json['id'] as int,
      title: json['title'] as String,
      teams: parseTeamNames(json['teams']),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
