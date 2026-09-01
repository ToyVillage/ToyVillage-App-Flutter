class DailyLog {
  final int id;
  final String templateName;
  final String content;
  final DateTime createdAt;

  const DailyLog({
    required this.id,
    required this.templateName,
    required this.content,
    required this.createdAt,
  });

  DailyLog copyWith({String? templateName, String? content}) => DailyLog(
    id: id,
    templateName: templateName ?? this.templateName,
    content: content ?? this.content,
    createdAt: createdAt,
  );
}

const dailyLogTemplates = <String>['먹이급여일지', '건강관리일지', '사육장점검일지', '마감일지'];
