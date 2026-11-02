import 'package:toy_village_app/features/task/data/model/task_status.dart';

class AssignmentRequest {
  final String title;
  final String content;
  final List<int> assigneeIds;
  final DateTime finishDate;
  final TaskPriority priority;
  final List<String>? files;

  const AssignmentRequest({
    required this.title,
    required this.content,
    required this.assigneeIds,
    required this.finishDate,
    required this.priority,
    this.files,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'assigneeIds': assigneeIds,
    'finishDate': _formatDate(finishDate),
    'priority': priority.code,
    'files': files,
  };

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
