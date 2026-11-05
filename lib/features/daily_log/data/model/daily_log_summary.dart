import 'package:toy_village_app/core/utils/time_util.dart';

class DailyLogSummary {
  final int workLogId;
  final DateTime writeAt;
  final String templateTitle;

  const DailyLogSummary({
    required this.workLogId,
    required this.writeAt,
    required this.templateTitle,
  });

  factory DailyLogSummary.fromJson(Map<String, dynamic> json) {
    return DailyLogSummary(
      workLogId: json['workLogId'] as int,
      writeAt: parseServerTime(json['writeAt'] as String),
      templateTitle: json['templateTitle'] as String,
    );
  }
}
