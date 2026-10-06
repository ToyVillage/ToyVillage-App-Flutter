class FeedLogSummary {
  final int feedLogId;
  final String animalKind;
  final String animalName;

  const FeedLogSummary({
    required this.feedLogId,
    required this.animalKind,
    required this.animalName,
  });

  factory FeedLogSummary.fromJson(Map<String, dynamic> json) {
    return FeedLogSummary(
      feedLogId: (json['feedLogId'] ?? json['feedId']) as int,
      animalKind: json['animalKind'] as String,
      animalName: json['animalName'] as String,
    );
  }
}

class FeedLog {
  final int feedLogId;
  final int animalId;
  final String feedType;
  final double feedAmount;
  final String feedUnit;
  final DateTime feedDateTime;
  final String significant;

  const FeedLog({
    required this.feedLogId,
    required this.animalId,
    required this.feedType,
    required this.feedAmount,
    required this.feedUnit,
    required this.feedDateTime,
    required this.significant,
  });

  factory FeedLog.fromJson(Map<String, dynamic> json) {
    return FeedLog(
      feedLogId: json['feedLogId'] as int,
      animalId: json['animalId'] as int,
      feedType: json['feedType'] as String,
      feedAmount: (json['feedAmount'] as num).toDouble(),
      feedUnit: json['feedUnit'] as String? ?? 'GML',
      feedDateTime: DateTime.parse(json['feedDateTime'] as String),
      significant: json['significant'] as String? ?? '',
    );
  }
}

class FeedLogDetail {
  final int feedLogId;
  final String feedType;
  final double feedAmount;
  final double remainingAmount;
  final String feedUnit;
  final DateTime feedDateTime;
  final String significant;

  const FeedLogDetail({
    required this.feedLogId,
    required this.feedType,
    required this.feedAmount,
    required this.remainingAmount,
    required this.feedUnit,
    required this.feedDateTime,
    required this.significant,
  });

  factory FeedLogDetail.fromJson(Map<String, dynamic> json) {
    return FeedLogDetail(
      feedLogId: json['feedLogId'] as int,
      feedType: json['feedType'] as String,
      feedAmount: (json['feedAmount'] as num).toDouble(),
      remainingAmount: json['remainingAmount'] is num
          ? (json['remainingAmount'] as num).toDouble()
          : 0,
      feedUnit: json['feedUnit'] as String? ?? 'GML',
      feedDateTime: DateTime.parse(json['feedDateTime'] as String),
      significant: json['significant'] as String? ?? '',
    );
  }
}

class FeedLogRequest {
  final DateTime feedDateTime;
  final String feedType;
  final double feedAmount;
  final double remainingAmount;
  final String feedUnit;
  final String significant;

  const FeedLogRequest({
    required this.feedDateTime,
    required this.feedType,
    required this.feedAmount,
    required this.remainingAmount,
    required this.feedUnit,
    required this.significant,
  });

  Map<String, dynamic> toJson() => {
    'feedDateTime': feedDateTime.toIso8601String(),
    'feedType': feedType,
    'feedAmount': feedAmount,
    'remainingAmount': remainingAmount,
    'feedUnit': feedUnit,
    'significant': significant,
  };
}
