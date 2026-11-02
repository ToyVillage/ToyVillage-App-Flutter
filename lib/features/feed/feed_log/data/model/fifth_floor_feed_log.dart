import 'package:toy_village_app/core/utils/time_util.dart';

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
  final DateTime feedDateTime;

  const FifthFloorFeedLog({
    required this.feedLogId,
    required this.animalId,
    required this.feedType,
    required this.feedAmount,
    required this.feedUnit,
    required this.feedDateTime,
  });

  factory FifthFloorFeedLog.fromJson(Map<String, dynamic> json) {
    return FifthFloorFeedLog(
      feedLogId: json['feedLogId'] as int,
      animalId: json['animalId'] as int,
      feedType: json['feedType'] as String? ?? '',
      feedAmount: (json['feedAmount'] as num).toDouble(),
      feedUnit: json['feedUnit'] as String? ?? 'GML',
      feedDateTime: parseServerTime(json['feedDateTime'] as String),
    );
  }
}

class FifthFloorFeedLogDetail {
  final int feedLogId;
  final String feedType;
  final double feedAmount;
  final String feedUnit;
  final DateTime feedDateTime;

  const FifthFloorFeedLogDetail({
    required this.feedLogId,
    required this.feedType,
    required this.feedAmount,
    required this.feedUnit,
    required this.feedDateTime,
  });

  factory FifthFloorFeedLogDetail.fromJson(Map<String, dynamic> json) {
    return FifthFloorFeedLogDetail(
      feedLogId: json['feedLogId'] as int,
      feedType: json['feedType'] as String? ?? '',
      feedAmount: (json['feedAmount'] as num).toDouble(),
      feedUnit: json['feedUnit'] as String? ?? 'GML',
      feedDateTime: parseServerTime(json['feedDateTime'] as String),
    );
  }
}

class FifthFloorFeedLogRequest {
  final DateTime feedDateTime;
  final String feedType;
  final double feedAmount;
  final String feedUnit;

  const FifthFloorFeedLogRequest({
    required this.feedDateTime,
    required this.feedType,
    required this.feedAmount,
    required this.feedUnit,
  });

  Map<String, dynamic> toJson() => {
    'feedDateTime': feedDateTime.toIso8601String(),
    'feedType': feedType,
    'feedAmount': feedAmount,
    'feedUnit': feedUnit,
  };
}
