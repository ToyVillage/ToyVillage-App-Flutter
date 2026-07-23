import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/task/data/model/task_model.dart';
import 'package:toy_village_app/features/task/data/model/task_status.dart';

final taskViewModelProvider =
    AsyncNotifierProvider<TaskViewModel, List<TaskModel>>(
      () => TaskViewModel(),
    );

class TaskViewModel extends AsyncNotifier<List<TaskModel>> {
  @override
  Future<List<TaskModel>> build() async {
    // TODO: 서버 연동 시 아래 더미데이터를 실제 호출로 교체
    // return ref.read(taskRepositoryProvider).loadTodayTasks();
    final now = DateTime.now();
    final threeHoursAgo = now.subtract(const Duration(hours: 3));

    return [
      TaskModel(
        id: 1,
        title: '카피바라 사육장 청소',
        createdAt: threeHoursAgo,
        status: TaskStatus.pending,
        isReported: false,
      ),
      TaskModel(
        id: 2,
        title: '카피바라 사육장 청소',
        createdAt: threeHoursAgo,
        status: TaskStatus.inProgress,
        isReported: true,
      ),
      TaskModel(
        id: 3,
        title: '카피바라 사육장 청소',
        createdAt: threeHoursAgo,
        status: TaskStatus.inProgress,
        isReported: true,
      ),
      TaskModel(
        id: 4,
        title: '카피바라 사육장 청소',
        createdAt: threeHoursAgo,
        status: TaskStatus.completed,
        isReported: true,
      ),
    ];
  }
}
