import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/network/api_endpoints.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';
import 'package:toy_village_app/features/feed/feed_log/data/model/feed_log.dart';

final feedLogRepositoryProvider = Provider(
  (ref) => FeedLogRepository(ref.read(dioProvider)),
);

class FeedLogRepository {
  final Dio _dio;

  FeedLogRepository(this._dio);

  Future<List<FeedLogSummary>> loadMyFeedLogs() async {
    final response = await _dio.get('${ApiEndpoints.feedLog}/me');
    final data = response.data as Map<String, dynamic>;
    return (data['feedLogs'] as List? ?? const [])
        .map((e) => FeedLogSummary.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<FeedLog>> loadAnimalFeedLogs(int animalManageId) async {
    final response = await _dio.get(
      '${ApiEndpoints.feedLog}/animal/$animalManageId',
    );
    final data = response.data as Map<String, dynamic>;
    return (data['feedLogs'] as List? ?? const [])
        .map((e) => FeedLog.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<FeedLogDetail> loadFeedLogDetail(int feedLogId) async {
    final response = await _dio.get('${ApiEndpoints.feedLog}/$feedLogId');
    return FeedLogDetail.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> createFeedLog(
    int animalManageId,
    FeedLogRequest request,
  ) async {
    await _dio.post(
      '${ApiEndpoints.feedLog}/$animalManageId',
      data: request.toJson(),
    );
  }

  Future<void> updateFeedLog(int feedLogId, FeedLogRequest request) async {
    await _dio.put(
      '${ApiEndpoints.feedLog}/$feedLogId',
      data: request.toJson(),
    );
  }
}
