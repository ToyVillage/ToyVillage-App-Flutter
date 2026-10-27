String _formatFeedDate(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}

class FifthFloorFeedLogSummary {
  final int feedId;
  final String animalKind;
  final String animalName;
  final bool animalDeleted;

  const FifthFloorFeedLogSummary({
    required this.feedId,
    required this.animalKind,
    required this.animalName,
    required this.animalDeleted,
  });

  factory FifthFloorFeedLogSummary.fromJson(Map<String, dynamic> json) {
    return FifthFloorFeedLogSummary(
      feedId: json['feedId'] as int,
      animalKind: json['animalKind'] as String? ?? '',
      animalName: json['animalName'] as String? ?? '',
      animalDeleted: json['animalDeleted'] as bool? ?? false,
    );
  }
}

class FifthFloorFeedLog {
  final int feedLogId;
  final int animalId;
  final String feedType;
  final double feedAmount;
  final String feedUnit;
  final DateTime feedDate;

  const FifthFloorFeedLog({
    required this.feedLogId,
    required this.animalId,
    required this.feedType,
    required this.feedAmount,
    required this.feedUnit,
    required this.feedDate,
  });

  factory FifthFloorFeedLog.fromJson(Map<String, dynamic> json) {
    return FifthFloorFeedLog(
      feedLogId: json['feedLogId'] as int,
      animalId: json['animalId'] as int,
      feedType: json['feedType'] as String? ?? '',
      feedAmount: (json['feedAmount'] as num).toDouble(),
      feedUnit: json['feedUnit'] as String? ?? 'GML',
      feedDate: DateTime.parse(json['feedDate'] as String),
    );
  }
}

class FifthFloorFeedLogDetail {
  final int feedLogId;
  final String feedType;
  final double feedAmount;
  final String feedUnit;
  final DateTime feedDate;

  const FifthFloorFeedLogDetail({
    required this.feedLogId,
    required this.feedType,
    required this.feedAmount,
    required this.feedUnit,
    required this.feedDate,
  });

  factory FifthFloorFeedLogDetail.fromJson(Map<String, dynamic> json) {
    return FifthFloorFeedLogDetail(
      feedLogId: json['feedLogId'] as int,
      feedType: json['feedType'] as String? ?? '',
      feedAmount: (json['feedAmount'] as num).toDouble(),
      feedUnit: json['feedUnit'] as String? ?? 'GML',
      feedDate: DateTime.parse(json['feedDate'] as String),
    );
  }
}

class FifthFloorFeedLogRequest {
  final DateTime feedDate;
  final String feedType;
  final double feedAmount;
  final String feedUnit;

  const FifthFloorFeedLogRequest({
    required this.feedDate,
    required this.feedType,
    required this.feedAmount,
    required this.feedUnit,
  });

  Map<String, dynamic> toJson() => {
    'feedDate': _formatFeedDate(feedDate),
    'feedType': feedType,
    'feedAmount': feedAmount,
    'feedUnit': feedUnit,
  };
}
