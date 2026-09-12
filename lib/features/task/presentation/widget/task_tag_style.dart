import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/features/task/data/model/task_status.dart';

typedef TagStyle = ({String label, Color text, Color background});

bool _isExpired(DateTime? finishDate) =>
    finishDate != null && DateTime.now().isAfter(finishDate);

String _finishDateLabel(DateTime finishDate) =>
    '${finishDate.month}월 ${finishDate.day}일';

({String label, Color color}) taskCardStatus(
  TaskStatus status,
  DateTime? finishDate,
) {
  switch (status) {
    case TaskStatus.completed:
      return (label: '완료됨', color: ToyVillageColor.green);
    case TaskStatus.inProgress:
      if (_isExpired(finishDate)) {
        return (label: '기한만료', color: ToyVillageColor.red);
      }
      if (finishDate != null) {
        return (
          label: '${_finishDateLabel(finishDate)}까지',
          color: ToyVillageColor.gray60,
        );
      }
      return (label: '진행중', color: ToyVillageColor.gray60);
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

TagStyle? reportStatusTag(ReportStatus status) {
  switch (status) {
    case ReportStatus.approved:
      return (
        label: '승인됨',
        text: ToyVillageColor.green,
        background: ToyVillageColor.greenBackground,
      );
    case ReportStatus.rejected:
      return (
        label: '반려됨',
        text: ToyVillageColor.yellow,
        background: ToyVillageColor.yellowBackground,
      );
    case ReportStatus.pending:
      return (
        label: '검토중',
        text: ToyVillageColor.gray60,
        background: ToyVillageColor.gray20,
      );
    case ReportStatus.missing:
      return null;
  }
}

TagStyle? taskDeadlineTag(DateTime? finishDate) {
  if (finishDate == null) return null;
  return (
    label: '${_finishDateLabel(finishDate)} 전까지',
    text: ToyVillageColor.gray60,
    background: ToyVillageColor.gray20,
  );
}
