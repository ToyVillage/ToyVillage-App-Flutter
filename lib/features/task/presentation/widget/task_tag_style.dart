import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/features/task/data/model/task_status.dart';

typedef TagStyle = ({String label, Color text, Color background});

bool _isExpired(DateTime? deadline) =>
    deadline != null && DateTime.now().isAfter(deadline);

String _deadlineDate(DateTime deadline) => '${deadline.month}월 ${deadline.day}일';

({String label, Color color}) taskCardStatus(
  TaskStatus status,
  DateTime? deadline,
) {
  switch (status) {
    case TaskStatus.completed:
      return (label: '완료됨', color: ToyVillageColor.green);
    case TaskStatus.rejected:
      return (label: '반려됨', color: ToyVillageColor.yellow);
    case TaskStatus.submitted:
      return (label: '제출됨', color: ToyVillageColor.gray60);
    case TaskStatus.notSubmitted:
      if (_isExpired(deadline)) {
        return (label: '기한만료', color: ToyVillageColor.red);
      }
      if (deadline != null) {
        return (label: '${_deadlineDate(deadline)}까지', color: ToyVillageColor.gray60);
      }
      return (label: '미제출', color: ToyVillageColor.gray60);
  }
}

TagStyle taskPriorityTag(TaskPriority priority) {
  switch (priority) {
    case TaskPriority.high:
      return (
        label: priority.label,
        text: ToyVillageColor.red,
        background: ToyVillageColor.redBackground,
      );
    case TaskPriority.medium:
      return (
        label: priority.label,
        text: ToyVillageColor.yellow,
        background: ToyVillageColor.yellowBackground,
      );
    case TaskPriority.low:
      return (
        label: priority.label,
        text: ToyVillageColor.green,
        background: ToyVillageColor.greenBackground,
      );
  }
}

TagStyle? taskStatusTag(TaskStatus status, DateTime? deadline) {
  switch (status) {
    case TaskStatus.completed:
      return (
        label: '완료됨',
        text: ToyVillageColor.green,
        background: ToyVillageColor.greenBackground,
      );
    case TaskStatus.rejected:
      return (
        label: '반려됨',
        text: ToyVillageColor.yellow,
        background: ToyVillageColor.yellowBackground,
      );
    case TaskStatus.submitted:
      return (
        label: '제출됨',
        text: ToyVillageColor.gray60,
        background: ToyVillageColor.gray20,
      );
    case TaskStatus.notSubmitted:
      if (_isExpired(deadline)) {
        return (
          label: '누락됨',
          text: ToyVillageColor.red,
          background: ToyVillageColor.redBackground,
        );
      }
      return null;
  }
}

TagStyle? taskDeadlineTag(DateTime? deadline) {
  if (deadline == null) return null;
  return (
    label: '${_deadlineDate(deadline)} 전까지',
    text: ToyVillageColor.gray60,
    background: ToyVillageColor.gray20,
  );
}
