import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/task/data/model/task_model.dart';
import 'package:toy_village_app/features/task_assignment/data/repository/assignment_repository.dart';

final assignmentListViewModelProvider =
    AsyncNotifierProvider.autoDispose<AssignmentListViewModel, List<TaskModel>>(
      () => AssignmentListViewModel(),
    );

class AssignmentListViewModel extends AsyncNotifier<List<TaskModel>> {
  @override
  Future<List<TaskModel>> build() {
    return ref.read(assignmentRepositoryProvider).loadAssignments();
  }
}
