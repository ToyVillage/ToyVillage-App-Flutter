import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/network/api_endpoints.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';
import 'package:toy_village_app/features/reservation/data/model/reservation_model.dart';

final reservationRepositoryProvider = Provider(
  (ref) => ReservationRepository(ref.read(dioProvider)),
);

class ReservationRepository {
  final Dio _dio;

  ReservationRepository(this._dio);

  Future<List<ReservationModel>> loadReservations() async {
    final response = await _dio.get(ApiEndpoints.reservation);
    final list = response.data as List;
    return list
        .map((e) => ReservationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
