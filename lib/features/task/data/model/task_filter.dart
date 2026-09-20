import 'package:toy_village_app/features/task/data/model/task_model.dart';
import 'package:toy_village_app/features/task/data/model/task_status.dart';

enum TaskFilter {
  all('전체', null),
  inProgress('진행중', ReportStatus.missing),
  pending('제출됨', ReportStatus.pending),
  approved('승인됨', ReportStatus.approved),
  rejected('반려됨', ReportStatus.rejected);

  final String label;
  final ReportStatus? status;

  const TaskFilter(this.label, this.status);

  String? get code => status?.code;

  bool matches(TaskModel task) {
    final status = this.status;
    if (status == null) return true;
    return task.myReportStatus == status;
  }
}
