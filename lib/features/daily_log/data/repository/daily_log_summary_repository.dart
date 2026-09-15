import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/network/api_endpoints.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';
import 'package:toy_village_app/features/daily_log/data/model/daily_log_summary.dart';

final dailyLogSummaryRepositoryProvider = Provider(
  (ref) => DailyLogSummaryRepository(ref.read(dioProvider)),
);

class DailyLogSummaryRepository {
  final Dio _dio;

  DailyLogSummaryRepository(this._dio);

  Future<List<DailyLogSummary>> loadMyWorkLogs({
    int page = 0,
    int size = 10,
    String sort = 'id,desc',
  }) async {
    final response = await _dio.get(
      ApiEndpoints.workLogEmployee,
      queryParameters: {'page': page, 'size': size, 'sort': sort},
    );
    final data = response.data;
    final list =
        (data is Map<String, dynamic> ? data['content'] : data) as List;
    return list
        .map((e) => DailyLogSummary.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
