import 'package:toy_village_app/features/task/data/model/task_detail_model.dart';
import 'package:toy_village_app/features/task/data/model/task_status.dart';

class WorkReportDetailModel {
  final int id;
  final int taskId;
  final String title;
  final String name;
  final String content;
  final String? note;
  final List<TaskFileModel> files;
  final ReportStatus status;
  final String? rejectionReason;
  final TaskPriority priority;
  final DateTime? finishDate;

  WorkReportDetailModel({
    required this.id,
    required this.taskId,
    required this.title,
    required this.name,
    required this.content,
    required this.note,
    required this.files,
    required this.status,
    required this.rejectionReason,
    required this.priority,
    required this.finishDate,
  });

  factory WorkReportDetailModel.fromJson(Map<String, dynamic> json) {
    final files = (json['files'] as List?) ?? const [];
    final finishDate = json['finishDate'] as String?;
    return WorkReportDetailModel(
      id: json['id'] as int,
      taskId: json['taskId'] as int,
      title: json['title'] as String? ?? '',
      name: json['name'] as String? ?? '',
      content: json['content'] as String? ?? '',
      note: json['note'] as String?,
      files: files
          .map((e) => TaskFileModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: ReportStatus.fromCode(json['status'] as String),
      rejectionReason: json['rejectionReason'] as String?,
      priority: TaskPriority.fromCode(json['priority'] as String),
      finishDate: finishDate != null ? DateTime.parse(finishDate) : null,
    );
  }
}
