class DailyLogTemplateSummary {
  final int templateId;
  final String templateTitle;
  final DateTime createdAt;

  const DailyLogTemplateSummary({
    required this.templateId,
    required this.templateTitle,
    required this.createdAt,
  });

  factory DailyLogTemplateSummary.fromJson(Map<String, dynamic> json) {
    return DailyLogTemplateSummary(
      templateId: json['templateId'] as int,
      templateTitle: json['templateTitle'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
