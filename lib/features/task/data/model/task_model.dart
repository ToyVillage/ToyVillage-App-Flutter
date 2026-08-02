import 'package:toy_village_app/features/task/data/model/task_status.dart';

class TaskModel {
  final int id;
  final String title;
  final DateTime createdAt;
  final TaskStatus status;
  final DateTime? deadline;

  TaskModel({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.status,
    required this.deadline,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final deadline = json['deadline'] as String?;
    return TaskModel(
      id: json['id'] as int,
      title: json['title'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: TaskStatus.fromCode(json['status'] as String),
      deadline: deadline != null ? DateTime.parse(deadline) : null,
    );
  }
}
