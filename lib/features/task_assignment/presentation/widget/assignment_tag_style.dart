import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/features/task/data/model/task_status.dart';
import 'package:toy_village_app/features/task/presentation/widget/task_tag_style.dart';

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

TagStyle assignmentReportStatusTag(ReportStatus status) {
  switch (status) {
    case ReportStatus.approved:
      return (
        label: '완료',
        text: ToyVillageColor.green,
        background: ToyVillageColor.greenBackground,
      );
    case ReportStatus.rejected:
      return (
        label: '반려',
        text: ToyVillageColor.red,
        background: ToyVillageColor.redBackground,
      );
    case ReportStatus.pending:
      return (
        label: '심사대기',
        text: ToyVillageColor.yellow,
        background: ToyVillageColor.yellowBackground,
      );
    case ReportStatus.resubmit:
      return (
        label: '재심사대기',
        text: ToyVillageColor.yellow,
        background: ToyVillageColor.yellowBackground,
      );
    case ReportStatus.missing:
      return (
        label: '미제출',
        text: ToyVillageColor.gray70,
        background: ToyVillageColor.gray20,
      );
  }
}