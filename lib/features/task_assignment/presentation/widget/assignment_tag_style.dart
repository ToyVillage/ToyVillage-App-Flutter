import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/features/task/presentation/widget/task_tag_style.dart';
import 'package:toy_village_app/features/task_assignment/data/model/assignment.dart';

TagStyle assignmentStatusTag(AssignmentStatus status) {
  switch (status) {
    case AssignmentStatus.notStarted:
      return (
        label: status.label,
        text: ToyVillageColor.gray70,
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
