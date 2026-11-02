import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/task/data/model/task_detail_model.dart';
import 'package:toy_village_app/features/task/data/repository/task_detail_repository.dart';

final assignmentDetailViewModelProvider =
    AsyncNotifierProvider.family<
      AssignmentDetailViewModel,
      TaskDetailModel,
      int
    >(AssignmentDetailViewModel.new);

class AssignmentDetailViewModel extends AsyncNotifier<TaskDetailModel> {
  final int id;

  AssignmentDetailViewModel(this.id);

  @override
  FutureOr<TaskDetailModel> build() {
    return ref.read(taskDetailRepositoryProvider).loadTaskDetail(id: id);
  }
}
