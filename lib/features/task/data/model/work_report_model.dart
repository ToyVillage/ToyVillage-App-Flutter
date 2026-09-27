import 'package:toy_village_app/features/task/data/model/task_detail_model.dart';
import 'package:toy_village_app/features/task/data/model/task_status.dart';

class WorkReportModel {
  final int id;
  final int taskId;
  final String content;
  final String? note;
  final List<TaskFileModel> files;
  final ReportStatus status;
  final String? rejectionReason;

  WorkReportModel({
    required this.id,
    required this.taskId,
    required this.content,
    required this.note,
    required this.files,
    required this.status,
    required this.rejectionReason,
  });

  factory WorkReportModel.fromJson(Map<String, dynamic> json) {
    final files = (json['files'] as List?) ?? const [];
    return WorkReportModel(
      id: json['id'] as int,
      taskId: json['taskId'] as int,
      content: json['content'] as String? ?? '',
      note: json['note'] as String?,
      files: files
          .map((e) => TaskFileModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: ReportStatus.fromCode(json['status'] as String),
      rejectionReason: json['rejectionReason'] as String?,
    );
  }
}
