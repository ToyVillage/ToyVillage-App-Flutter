import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/task_assignment/data/model/work_report_detail_model.dart';
import 'package:toy_village_app/features/task_assignment/data/repository/assignment_report_repository.dart';

const _defaultErrorMessage = '문제가 발생했어요. 다시 시도해주세요.';

final assignmentReportViewModelProvider =
    AsyncNotifierProvider.autoDispose.family<
      AssignmentReportViewModel,
      WorkReportDetailModel,
      int
    >(AssignmentReportViewModel.new);

class AssignmentReportViewModel extends AsyncNotifier<WorkReportDetailModel> {
  final int workReportId;

  AssignmentReportViewModel(this.workReportId);

  @override
  Future<WorkReportDetailModel> build() {
    return ref
        .read(assignmentReportRepositoryProvider)
        .loadReportDetail(workReportId);
  }
}

final reportReviewViewModelProvider =
    AsyncNotifierProvider<ReportReviewViewModel, void>(
      ReportReviewViewModel.new,
    );

class ReportReviewViewModel extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<String?> approve(int workReportId) {
    return _run(
      () => ref.read(assignmentReportRepositoryProvider).approve(workReportId),
    );
  }

  Future<String?> reject(int workReportId, String rejectionReason) {
    return _run(
      () => ref
          .read(assignmentReportRepositoryProvider)
          .reject(workReportId, rejectionReason),
    );
  }

  Future<String?> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
      state = const AsyncData(null);
      return null;
    } on DioException catch (e, stackTrace) {
      debugPrint('[Report Review Error] $e');
      state = AsyncError(e, stackTrace);
      return _errorMessage(e);
    } catch (e, stackTrace) {
      debugPrint('[Report Review Error] $e');
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
