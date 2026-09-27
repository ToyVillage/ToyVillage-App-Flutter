import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/network/api_endpoints.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';
import 'package:toy_village_app/features/task/data/model/work_report_model.dart';
import 'package:toy_village_app/features/task/data/model/work_report_request.dart';

final workReportRepositoryProvider = Provider(
  (ref) => WorkReportRepository(ref.read(dioProvider)),
);

class WorkReportRepository {
  final Dio _dio;

  WorkReportRepository(this._dio);

  Future<WorkReportModel?> loadMyReport(int taskId) async {
    try {
      final response = await _dio.get('${ApiEndpoints.workReport}/$taskId');
      return WorkReportModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<void> createReport(int taskId, WorkReportRequest request) async {
    await _dio.post(
      '${ApiEndpoints.workReport}/$taskId',
      data: request.toJson(),
    );
  }

  Future<void> updateReport(int workReportId, WorkReportRequest request) async {
    await _dio.put(
      '${ApiEndpoints.workReport}/$workReportId',
      data: request.toJson(),
    );
  }

  Future<void> deleteReport(int workReportId) async {
    await _dio.delete('${ApiEndpoints.workReport}/$workReportId');
  }
}
