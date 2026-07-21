import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/reservation/data/model/reservation_model.dart';
import 'package:toy_village_app/features/reservation/data/repository/reservation_repository.dart';

final reservationViewModelProvider =
    AsyncNotifierProvider<ReservationViewModel, List<ReservationModel>>(
      () => ReservationViewModel(),
    );

class ReservationViewModel extends AsyncNotifier<List<ReservationModel>> {
  @override
  FutureOr<List<ReservationModel>> build() {
    return ref.read(reservationRepositoryProvider).loadReservations();
  }
}
