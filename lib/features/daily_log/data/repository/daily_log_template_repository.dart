import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/network/api_endpoints.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';
import 'package:toy_village_app/features/daily_log/data/model/daily_log_template.dart';

final dailyLogTemplateRepositoryProvider = Provider(
  (ref) => DailyLogTemplateRepository(ref.read(dioProvider)),
);

class DailyLogTemplateRepository {
  final Dio _dio;

  DailyLogTemplateRepository(this._dio);

  Future<DailyLogTemplate> loadTemplate(int id) async {
    final response = await _dio.get('${ApiEndpoints.workLogTemplate}/$id');
    return DailyLogTemplate.fromJson(response.data as Map<String, dynamic>);
  }
}
