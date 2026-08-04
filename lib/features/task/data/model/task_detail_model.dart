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

class TaskDetailModel {
  final int id;
  final String title;
  final String content;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime? deadline;
  final DateTime createdAt;
  final List<TaskFileModel> files;
  final String? rejectionReason;

  TaskDetailModel({
    required this.id,
    required this.title,
    required this.content,
    required this.priority,
    required this.status,
    required this.deadline,
    required this.createdAt,
    required this.files,
    required this.rejectionReason,
  });

  factory TaskDetailModel.fromJson(Map<String, dynamic> json) {
    final deadline = json['deadline'] as String?;
    final files = (json['files'] as List?) ?? const [];
    return TaskDetailModel(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      priority: TaskPriority.fromCode(json['priority'] as String),
      status: TaskStatus.fromCode(json['status'] as String),
      deadline: deadline != null ? DateTime.parse(deadline) : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      files: files
          .map((e) => TaskFileModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      rejectionReason: json['rejectionReason'] as String?,
    );
  }
}
