import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/network/api_endpoints.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';
import 'package:toy_village_app/features/task_assignment/data/model/work_report_detail_model.dart';

final assignmentReportRepositoryProvider = Provider(
  (ref) => AssignmentReportRepository(ref.read(dioProvider)),
);

class AssignmentReportRepository {
  final Dio _dio;

  AssignmentReportRepository(this._dio);

  Future<WorkReportDetailModel> loadReportDetail(int workReportId) async {
    final response = await _dio.get(
      '${ApiEndpoints.workReport}/detail/$workReportId',
    );
    return WorkReportDetailModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<void> approve(int workReportId) async {
    await _dio.patch('${ApiEndpoints.workReport}/approve/$workReportId');
  }

  Future<void> reject(int workReportId, String rejectionReason) async {
    await _dio.patch(
      '${ApiEndpoints.workReport}/reject/$workReportId',
      data: {'rejectionReason': rejectionReason},
    );
  }
}
