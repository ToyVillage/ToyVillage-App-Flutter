import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/task/data/model/work_report_model.dart';
import 'package:toy_village_app/features/task/data/repository/work_report_repository.dart';

final workReportProvider =
    AsyncNotifierProvider.family<WorkReportViewModel, WorkReportModel?, int>(
      WorkReportViewModel.new,
    );

class WorkReportViewModel extends AsyncNotifier<WorkReportModel?> {
  final int taskId;

  WorkReportViewModel(this.taskId);

  @override
  FutureOr<WorkReportModel?> build() {
    return ref.read(workReportRepositoryProvider).loadMyReport(taskId);
  }
}
