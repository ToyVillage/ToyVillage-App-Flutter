import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/network/api_endpoints.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';
import 'package:toy_village_app/features/day_off/data/model/open_time_model.dart';

final openTimeRepositoryProvider =
    Provider((ref) => OpenTimeRepository(ref.read(dioProvider)));

class OpenTimeRepository {
  final Dio _dio;

  OpenTimeRepository(this._dio);

  Future<List<OpenTimeModel>> loadOpenTimes() async {
    final res = await _dio.get(ApiEndpoints.openTime);
    final list = res.data as List;
    return list
        .map((e) => OpenTimeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
