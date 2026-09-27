import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/task/data/model/task_detail_model.dart';
import 'package:toy_village_app/features/task/data/repository/task_detail_repository.dart';

final taskDetailViewModelProvider =
    AsyncNotifierProvider.family<TaskDetailViewModel, TaskDetailModel, int>(
      TaskDetailViewModel.new,
    );

class TaskDetailViewModel extends AsyncNotifier<TaskDetailModel> {
  final int id;

  TaskDetailViewModel(this.id);

  @override
  FutureOr<TaskDetailModel> build() {
    return ref.read(taskDetailRepositoryProvider).loadTaskDetail(id: id);
  }
}
