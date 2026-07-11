import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';
import 'package:toy_village_app/features/day_off/data/model/close_day_model.dart';

final closeDayRepositoryProvider =
    Provider((ref) => CloseDayRepository(ref.read(dioProvider)));

class CloseDayRepository {
  // ignore: unused_field
  final Dio _dio;

  CloseDayRepository(this._dio);

  Future<List<CloseDayModel>> loadCloseDays() async {
    // final res = await _dio.get(ApiEndpoints.closeDay);
    // final list = res.data as List;
    // return list
    //     .map((e) => CloseDayModel.fromJson(e as Map<String, dynamic>))
    //     .toList();

    await Future.delayed(const Duration(milliseconds: 300));
    final dummy = <Map<String, dynamic>>[
      {
        'id': 1,
        'title': '정기 휴관',
        'startCloseTime': '2026-07-09',
        'endCloseTime': '2026-07-09',
      },
      {
        'id': 2,
        'title': '시설 점검',
        'startCloseTime': '2026-07-15',
        'endCloseTime': '2026-07-16',
      },
    ];
    return dummy.map(CloseDayModel.fromJson).toList();
  }
}
