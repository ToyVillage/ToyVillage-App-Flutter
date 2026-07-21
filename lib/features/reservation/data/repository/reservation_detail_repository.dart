import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/reservation/data/model/reservation_detail_model.dart';

final reservationDetailRepositoryProvider =
    Provider((ref) => ReservationDetailRepository());

class ReservationDetailRepository {
  Future<ReservationDetailModel> loadReservationDetail({required int id}) async {
    return ReservationDetailModel.fromJson({
      'id': id,
      'reservationName': '예약인 성함',
      'leaderCount': 5,
      'reservationCount': 20,
      'location': '위치',
      'visitDate': '2026-07-12T09:41:00.123',
      'exitTime': '09:14:14',
      'visitSiteDate': '2026-07-12T09:41:00.123',
      'visitSiteExitTime': '09:14:14',
      'visitSiteCount': 3,
    });
  }
}
