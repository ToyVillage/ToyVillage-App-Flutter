import 'package:toy_village_app/features/task/data/model/task_model.dart';
import 'package:toy_village_app/features/task/data/model/task_status.dart';

enum TaskFilter {
  all('전체'),
  expired('기한만료'),
  rejected('반려됨'),
  inProgress('진행중'),
  pending('제출됨');

  final String label;

  const TaskFilter(this.label);

  bool matches(TaskModel task) {
    switch (this) {
      case TaskFilter.all:
        return true;
      case TaskFilter.expired:
        return task.myReportStatus == ReportStatus.missing &&
            task.status == TaskStatus.expired;
      case TaskFilter.rejected:
        return task.myReportStatus == ReportStatus.rejected;
      case TaskFilter.inProgress:
        return task.myReportStatus == ReportStatus.missing &&
            task.status == TaskStatus.inProgress;
      case TaskFilter.pending:
        return task.myReportStatus == ReportStatus.pending;
    }
  }
}
