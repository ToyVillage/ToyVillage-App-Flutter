import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/features/task/data/model/task_status.dart';
import 'package:toy_village_app/features/task/presentation/widget/task_tag_style.dart';
import 'package:toy_village_app/features/task_assignment/data/model/assignment.dart';

TagStyle assignmentTaskStatusTag(TaskStatus status) {
  switch (status) {
    case TaskStatus.inProgress:
      return (
        label: '진행 중',
        text: ToyVillageColor.yellow,
        background: ToyVillageColor.yellowBackground,
      );
    case TaskStatus.completed:
      return (
        label: '완료',
        text: ToyVillageColor.green,
        background: ToyVillageColor.greenBackground,
      );
    case TaskStatus.expired:
      return (
        label: '기한만료',
        text: ToyVillageColor.red,
        background: ToyVillageColor.redBackground,
      );
  }
}

String assignmentFinishLabel(DateTime? date) {
  if (date == null) return '';
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$month.$day 까지';
}

TagStyle assignmentStatusTag(AssignmentStatus status) {
  switch (status) {
    case AssignmentStatus.notStarted:
      return (
        label: status.label,
        text: ToyVillageColor.gray90,
        background: ToyVillageColor.gray20,
      );
    case AssignmentStatus.inProgress:
      return (
        label: status.label,
        text: ToyVillageColor.yellow,
        background: ToyVillageColor.yellowBackground,
      );
    case AssignmentStatus.completed:
      return (
        label: status.label,
        text: ToyVillageColor.green,
        background: ToyVillageColor.greenBackground,
      );
  }
}
