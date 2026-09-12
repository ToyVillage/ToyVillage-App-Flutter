import 'package:toy_village_app/features/task/data/model/assignee.dart';
import 'package:toy_village_app/features/task/data/model/task_status.dart';

class TaskModel {
  final int id;
  final String title;
  final List<Assignee> assignees;
  final int assigneeCount;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime? finishDate;

  TaskModel({
    required this.id,
    required this.title,
    required this.assignees,
    required this.assigneeCount,
    required this.status,
    required this.priority,
    required this.finishDate,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final finishDate = json['finishDate'] as String?;
    final assignees = (json['assignees'] as List?) ?? const [];
    return TaskModel(
      id: json['id'] as int,
      title: json['title'] as String,
      assignees: assignees
          .map((e) => Assignee.fromJson(e as Map<String, dynamic>))
          .toList(),
      assigneeCount: json['assigneeCount'] as int? ?? assignees.length,
      status: TaskStatus.fromCode(json['status'] as String),
      priority: TaskPriority.fromCode(json['priority'] as String),
      finishDate: finishDate != null ? DateTime.parse(finishDate) : null,
    );
  }
}
