import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/network/api_endpoints.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';
import 'package:toy_village_app/features/daily_log/data/model/daily_log_detail.dart';
import 'package:toy_village_app/features/daily_log/data/model/work_log_answer_request.dart';

final dailyLogDetailRepositoryProvider = Provider(
  (ref) => DailyLogDetailRepository(ref.read(dioProvider)),
);

class DailyLogDetailRepository {
  final Dio _dio;

  DailyLogDetailRepository(this._dio);

  Future<DailyLogDetail> loadDetail(int workLogId) async {
    final response = await _dio.get('${ApiEndpoints.workLog}/$workLogId');
    return DailyLogDetail.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> createWorkLog(
    int templateId,
    List<WorkLogAnswerRequest> answers,
  ) async {
    await _dio.post(
      '${ApiEndpoints.workLog}/$templateId',
      data: {'answers': answers.map((e) => e.toJson()).toList()},
    );
  }

  Future<void> updateWorkLog(
    int workLogId,
    List<WorkLogAnswerRequest> answers,
  ) async {
    await _dio.patch(
      '${ApiEndpoints.workLog}/$workLogId',
      data: {'answers': answers.map((e) => e.toJson()).toList()},
    );
  }

  Future<void> deleteWorkLog(int workLogId) async {
    await _dio.delete('${ApiEndpoints.workLog}/$workLogId');
  }
}
