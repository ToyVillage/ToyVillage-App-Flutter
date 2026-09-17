import 'package:toy_village_app/features/task/data/model/report_attachment.dart';

class Observation {
  final int animalObservationId;
  final String title;
  final DateTime createdAt;
  final String authorName;
  final List<ReportAttachment> files;

  const Observation({
    required this.animalObservationId,
    required this.title,
    required this.createdAt,
    required this.authorName,
    required this.files,
  });

  factory Observation.fromJson(Map<String, dynamic> json) {
    return Observation(
      animalObservationId: json['animalObservationId'] as int,
      title: json['title'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      authorName: json['authorName'] as String,
      files: (json['files'] as List? ?? const [])
          .map((e) => ReportAttachment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ObservationDetail {
  final int animalObservationId;
  final String title;
  final String content;
  final DateTime createdAt;
  final String authorName;
  final List<ReportAttachment> files;

  const ObservationDetail({
    required this.animalObservationId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.authorName,
    required this.files,
  });

  factory ObservationDetail.fromJson(Map<String, dynamic> json) {
    return ObservationDetail(
      animalObservationId: json['animalObservationId'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      authorName: json['authorName'] as String,
      files: (json['files'] as List? ?? const [])
          .map((e) => ReportAttachment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ObservationRequest {
  final String title;
  final String content;
  final List<String> fileKeys;

  const ObservationRequest({
    required this.title,
    required this.content,
    this.fileKeys = const [],
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'fileKeys': fileKeys,
  };
}
