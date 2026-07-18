import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/network/api_endpoints.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';
import 'package:toy_village_app/features/day_off/data/model/close_day_model.dart';

final closeDayRepositoryProvider =
    Provider((ref) => CloseDayRepository(ref.read(dioProvider)));

class CloseDayRepository {
  final Dio _dio;

  CloseDayRepository(this._dio);

  Future<List<CloseDayModel>> loadCloseDays() async {
    final res = await _dio.get(ApiEndpoints.closeDay);
    final list = res.data as List;
    return list
        .map((e) => CloseDayModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
