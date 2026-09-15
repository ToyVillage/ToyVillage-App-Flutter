import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/network/api_endpoints.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';
import 'package:toy_village_app/features/daily_log/data/model/daily_log_template.dart';
import 'package:toy_village_app/features/daily_log/data/model/daily_log_template_summary.dart';

final dailyLogTemplateRepositoryProvider = Provider(
  (ref) => DailyLogTemplateRepository(ref.read(dioProvider)),
);

class DailyLogTemplateRepository {
  final Dio _dio;

  DailyLogTemplateRepository(this._dio);

  Future<List<DailyLogTemplateSummary>> loadTemplates({
    int page = 0,
    int size = 100,
    String sort = 'id,desc',
  }) async {
    final response = await _dio.get(
      ApiEndpoints.workLogTemplate,
      queryParameters: {'page': page, 'size': size, 'sort': sort},
    );
    final data = response.data;
    final list =
        (data is Map<String, dynamic> ? data['content'] : data) as List;
    return list
        .map((e) => DailyLogTemplateSummary.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<DailyLogTemplate> loadTemplate(int templateId) async {
    final response = await _dio.get(
      '${ApiEndpoints.workLogTemplate}/$templateId',
    );
    return DailyLogTemplate.fromJson(response.data as Map<String, dynamic>);
  }
}
