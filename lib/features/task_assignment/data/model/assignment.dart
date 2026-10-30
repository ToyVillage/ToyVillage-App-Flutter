import 'package:toy_village_app/features/task/data/model/task_status.dart';

enum AssignmentStatus {
  notStarted('시작 전'),
  inProgress('진행중'),
  completed('완료');

  const AssignmentStatus(this.label);

  final String label;
}

class Assignment {
  final int id;
  final String title;
  final String description;
  final AssignmentStatus status;
  final TaskPriority priority;
  final DateTime dueDate;

  const Assignment({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.dueDate,
  });
}

final sampleAssignments = <Assignment>[
  Assignment(
    id: 1,
    title: '우현이 밥주기',
    description: '배고픈 우현이에게 고기 100g, 야채 500g을 주세요',
    status: AssignmentStatus.inProgress,
    priority: TaskPriority.low,
    dueDate: DateTime(2026, 11, 1),
  ),
  Assignment(
    id: 2,
    title: '우현이 밥주기',
    description: '배고픈 우현이에게 고기 100g, 야채 500g을 주세요',
    status: AssignmentStatus.notStarted,
    priority: TaskPriority.low,
    dueDate: DateTime(2026, 11, 1),
  ),
  Assignment(
    id: 3,
    title: '우현이 밥주기',
    description: '배고픈 우현이에게 고기 100g, 야채 500g을 주세요',
    status: AssignmentStatus.completed,
    priority: TaskPriority.low,
    dueDate: DateTime(2026, 11, 1),
  ),
];

String assignmentDueLabel(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$month.$day 까지';
}
