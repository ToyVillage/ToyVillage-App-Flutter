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

  Future<DailyLogDetail> loadDetail(int id) async {
    final response = await _dio.get('${ApiEndpoints.workLog}/$id');
    return DailyLogDetail.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> updateWorkLog(int id, List<WorkLogAnswerRequest> answers) async {
    await _dio.patch(
      '${ApiEndpoints.workLogEmployee}/$id',
      data: {'answers': answers.map((e) => e.toJson()).toList()},
    );
  }

  Future<void> deleteWorkLog(int id) async {
    await _dio.delete('${ApiEndpoints.workLogEmployee}/$id');
  }
}
