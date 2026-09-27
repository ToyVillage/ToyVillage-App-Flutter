import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/task/data/model/task_model.dart';
import 'package:toy_village_app/features/task/data/repository/task_repository.dart';

final taskViewModelProvider =
    AsyncNotifierProvider.autoDispose<TaskViewModel, List<TaskModel>>(
      () => TaskViewModel(),
    );

class TaskViewModel extends AsyncNotifier<List<TaskModel>> {
  @override
  Future<List<TaskModel>> build() {
    return ref.read(taskRepositoryProvider).loadMyTasks();
  }
}
