import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/network/api_endpoints.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';
import 'package:toy_village_app/features/reservation/data/model/reservation_detail_model.dart';

final reservationDetailRepositoryProvider = Provider(
  (ref) => ReservationDetailRepository(ref.read(dioProvider)),
);

class ReservationDetailRepository {
  final Dio _dio;

  ReservationDetailRepository(this._dio);

  Future<ReservationDetailModel> loadReservationDetail({
    required int id,
  }) async {
    final response = await _dio.get('${ApiEndpoints.reservation}/$id');
    return ReservationDetailModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
