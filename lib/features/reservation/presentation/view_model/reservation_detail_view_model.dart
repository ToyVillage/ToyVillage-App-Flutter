import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/reservation/data/model/reservation_detail_model.dart';
import 'package:toy_village_app/features/reservation/data/repository/reservation_detail_repository.dart';

final reservationDetailViewModelProvider =
    AsyncNotifierProvider.family<
      ReservationDetailViewModel,
      ReservationDetailModel,
      int
    >(ReservationDetailViewModel.new);

class ReservationDetailViewModel
    extends AsyncNotifier<ReservationDetailModel> {
  final int id;

  ReservationDetailViewModel(this.id);

  @override
  FutureOr<ReservationDetailModel> build() {
    return ref
        .read(reservationDetailRepositoryProvider)
        .loadReservationDetail(id: id);
  }
}
