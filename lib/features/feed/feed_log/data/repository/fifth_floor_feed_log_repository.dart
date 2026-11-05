import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/network/api_endpoints.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';
import 'package:toy_village_app/features/feed/feed_log/data/model/fifth_floor_feed_log.dart';

final fifthFloorFeedLogRepositoryProvider = Provider(
  (ref) => FifthFloorFeedLogRepository(ref.read(dioProvider)),
);

class FifthFloorFeedLogRepository {
  final Dio _dio;

  FifthFloorFeedLogRepository(this._dio);

  static const _base = ApiEndpoints.feedLogFifthFloor;

  Future<List<FifthFloorFeedLogSummary>> loadMyFeedLogs() async {
    final response = await _dio.get('$_base/me');
    final data = response.data as Map<String, dynamic>;
    return (data['feedLogs'] as List? ?? const [])
        .map((e) => FifthFloorFeedLogSummary.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<FifthFloorFeedLog>> loadAnimalFeedLogs(int animalManageId) async {
    final response = await _dio.get('$_base/animal/$animalManageId');
    final data = response.data as Map<String, dynamic>;
    return (data['feedLogs'] as List? ?? const [])
        .map((e) => FifthFloorFeedLog.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<FifthFloorFeedLogDetail> loadFeedLogDetail(int feedLogId) async {
    final response = await _dio.get('$_base/$feedLogId');
    return FifthFloorFeedLogDetail.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<void> createFeedLog(
    int animalManageId,
    FifthFloorFeedLogRequest request,
  ) async {
    await _dio.post('$_base/$animalManageId', data: request.toJson());
  }

  Future<void> updateFeedLog(
    int feedLogId,
    FifthFloorFeedLogRequest request,
  ) async {
    await _dio.put('$_base/$feedLogId', data: request.toJson());
  }
}
