import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/task/data/repository/task_report_draft_repository.dart';

final taskReportProvider =
    AsyncNotifierProvider.family<TaskReportViewModel, TaskReportDraft?, int>(
      TaskReportViewModel.new,
    );

class TaskReportViewModel extends AsyncNotifier<TaskReportDraft?> {
  final int id;

  TaskReportViewModel(this.id);

  @override
  FutureOr<TaskReportDraft?> build() {
    return ref.read(taskReportDraftRepositoryProvider).loadReport(id);
  }
}
