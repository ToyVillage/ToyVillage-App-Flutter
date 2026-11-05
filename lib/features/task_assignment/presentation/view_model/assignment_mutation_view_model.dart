import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/task_assignment/data/model/assignment_request.dart';
import 'package:toy_village_app/features/task_assignment/data/repository/assignment_repository.dart';

const _defaultErrorMessage = '문제가 발생했어요. 다시 시도해주세요.';

final assignmentMutationViewModelProvider =
    AsyncNotifierProvider<AssignmentMutationViewModel, void>(
      AssignmentMutationViewModel.new,
    );

class AssignmentMutationViewModel extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<String?> create(AssignmentRequest request) {
    return _run(
      () => ref.read(assignmentRepositoryProvider).createAssignment(request),
    );
  }

  Future<String?> edit(int id, AssignmentRequest request) {
    return _run(
      () => ref.read(assignmentRepositoryProvider).updateAssignment(id, request),
    );
  }

  Future<String?> delete(int id) {
    return _run(
      () => ref.read(assignmentRepositoryProvider).deleteAssignment(id),
    );
  }

  Future<String?> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
      state = const AsyncData(null);
      return null;
    } on DioException catch (e, stackTrace) {
      debugPrint('[Assignment Mutation Error] $e');
      state = AsyncError(e, stackTrace);
      return _errorMessage(e);
    } catch (e, stackTrace) {
      debugPrint('[Assignment Mutation Error] $e');
      state = AsyncError(e, stackTrace);
      return _defaultErrorMessage;
    }
  }

  String _errorMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) return message;
    }
    return _defaultErrorMessage;
  }
}
