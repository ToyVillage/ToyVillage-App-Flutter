import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/features/task/data/model/task_status.dart';
import 'package:toy_village_app/features/task/presentation/widget/task_tag_style.dart';

typedef ReportTagStyle = ({
  String label,
  Color text,
  Color background,
  Color? border,
});

TagStyle assignmentTaskStatusTag(TaskStatus status) {
  switch (status) {
    case TaskStatus.inProgress:
      return (
        label: '진행중',
        text: ToyVillageColor.gray70,
        background: ToyVillageColor.gray20,
      );
    case TaskStatus.expired:
      return (
        label: '지연',
        text: ToyVillageColor.yellow,
        background: ToyVillageColor.yellowBackground,
      );
    case TaskStatus.completed:
      return (
        label: '완료',
        text: ToyVillageColor.blue,
        background: ToyVillageColor.blueBackground,
      );
  }
}

String assignmentFinishLabel(DateTime? date) {
  if (date == null) return '';
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$month.$day 까지';
}

ReportTagStyle assignmentReportStatusTag(ReportStatus status) {
  switch (status) {
    case ReportStatus.missing:
      return (
        label: '미제출',
        text: ToyVillageColor.gray60,
        background: ToyVillageColor.white,
        border: ToyVillageColor.gray30,
      );
    case ReportStatus.pending:
      return (
        label: '심사대기',
        text: ToyVillageColor.gray70,
        background: ToyVillageColor.gray20,
        border: null,
      );
    case ReportStatus.rejected:
      return (
        label: '반려',
        text: ToyVillageColor.yellow,
        background: ToyVillageColor.yellowBackground,
        border: null,
      );
    case ReportStatus.resubmit:
      return (
        label: '재심사대기',
        text: ToyVillageColor.purple,
        background: ToyVillageColor.purpleBackground,
        border: null,
      );
    case ReportStatus.approved:
      return (
        label: '완료',
        text: ToyVillageColor.blue,
        background: ToyVillageColor.blueBackground,
        border: null,
      );
  }
}