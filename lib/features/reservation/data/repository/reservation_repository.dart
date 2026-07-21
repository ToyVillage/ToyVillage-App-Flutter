import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/reservation/data/model/reservation_model.dart';

final reservationRepositoryProvider = Provider((ref) => ReservationRepository());

class ReservationRepository {
  Future<List<ReservationModel>> loadReservations() async {
    return [
      {
        'id': 1,
        'title': '예약 제목',
        'reservationName': '예약인 성함',
        'visitDate': '2026-07-12T09:41:00.123',
        'reservationCount': 20,
      },
      {
        'id': 2,
        'title': '예약 제목',
        'reservationName': '예약인 성함',
        'visitDate': '2026-04-04T10:00:00.000',
        'reservationCount': 15,
      },
    ].map(ReservationModel.fromJson).toList();
  }
}
