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
    final now = DateTime.now();
    final threeHoursAgo = now.subtract(const Duration(hours: 3));

    final tasks = [
      TaskModel(
        id: 1,
        title: '카피바라 사육장 청소',
        createdAt: threeHoursAgo,
        status: TaskStatus.notSubmitted,
        deadline: now.add(const Duration(days: 3)),
      ),
      TaskModel(
        id: 2,
        title: '기린 먹이 주기',
        createdAt: threeHoursAgo,
        status: TaskStatus.notSubmitted,
        deadline: now.subtract(const Duration(hours: 1)),
      ),
      TaskModel(
        id: 3,
        title: '펭귄관 온도 점검',
        createdAt: threeHoursAgo,
        status: TaskStatus.rejected,
        deadline: now.add(const Duration(days: 1)),
      ),
      TaskModel(
        id: 4,
        title: '수달 먹이 준비',
        createdAt: threeHoursAgo,
        status: TaskStatus.completed,
        deadline: now.subtract(const Duration(days: 1)),
      ),
    ];

    final completedCutoff = now.subtract(const Duration(days: 3));
    return tasks.where((task) {
      if (task.status != TaskStatus.completed) return true;
      final deadline = task.deadline;
      return deadline == null || deadline.isAfter(completedCutoff);
    }).toList();
  }
}
