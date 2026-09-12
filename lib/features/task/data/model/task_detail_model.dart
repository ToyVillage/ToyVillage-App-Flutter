import 'package:toy_village_app/features/task/data/model/assignee.dart';
import 'package:toy_village_app/features/task/data/model/task_status.dart';

class TaskFileModel {
  final String fileName;
  final String fileKey;

  TaskFileModel({required this.fileName, required this.fileKey});

  factory TaskFileModel.fromJson(Map<String, dynamic> json) {
    return TaskFileModel(
      fileName: json['fileName'] as String,
      fileKey: json['fileKey'] as String,
    );
  }
}

class TaskReportSummary {
  final int? workReportId;
  final int appAdminId;
  final String name;
  final ReportStatus status;

  TaskReportSummary({
    required this.workReportId,
    required this.appAdminId,
    required this.name,
    required this.status,
  });

  factory TaskReportSummary.fromJson(Map<String, dynamic> json) {
    return TaskReportSummary(
      workReportId: json['workReportId'] as int?,
      appAdminId: json['appAdminId'] as int,
      name: json['name'] as String,
      status: ReportStatus.fromCode(json['status'] as String),
    );
  }
}

class TaskProgress {
  final int total;
  final int approved;
  final int rejected;
  final int pending;
  final int missing;

  TaskProgress({
    required this.total,
    required this.approved,
    required this.rejected,
    required this.pending,
    required this.missing,
  });

  factory TaskProgress.fromJson(Map<String, dynamic> json) {
    return TaskProgress(
      total: json['total'] as int? ?? 0,
      approved: json['approved'] as int? ?? 0,
      rejected: json['rejected'] as int? ?? 0,
      pending: json['pending'] as int? ?? 0,
      missing: json['missing'] as int? ?? 0,
    );
  }
}

class TaskDetailModel {
  final int id;
  final String title;
  final String content;
  final List<Assignee> assignees;
  final int assigneeCount;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime? finishDate;
  final DateTime createdAt;
  final List<TaskFileModel> files;
  final List<TaskReportSummary> reports;
  final TaskProgress? progress;

  TaskDetailModel({
    required this.id,
    required this.title,
    required this.content,
    required this.assignees,
    required this.assigneeCount,
    required this.priority,
    required this.status,
    required this.finishDate,
    required this.createdAt,
    required this.files,
    required this.reports,
    required this.progress,
  });

  factory TaskDetailModel.fromJson(Map<String, dynamic> json) {
    final finishDate = json['finishDate'] as String?;
    final assignees = (json['assignees'] as List?) ?? const [];
    final files = (json['files'] as List?) ?? const [];
    final reports = (json['reports'] as List?) ?? const [];
    final progress = json['progress'] as Map<String, dynamic>?;
    return TaskDetailModel(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      assignees: assignees
          .map((e) => Assignee.fromJson(e as Map<String, dynamic>))
          .toList(),
      assigneeCount: json['assigneeCount'] as int? ?? assignees.length,
      priority: TaskPriority.fromCode(json['priority'] as String),
      status: TaskStatus.fromCode(json['status'] as String),
      finishDate: finishDate != null ? DateTime.parse(finishDate) : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      files: files
          .map((e) => TaskFileModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      reports: reports
          .map((e) => TaskReportSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      progress: progress != null ? TaskProgress.fromJson(progress) : null,
    );
  }
}
