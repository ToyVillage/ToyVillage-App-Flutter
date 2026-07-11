import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/day_off/data/model/close_day_model.dart';
import 'package:toy_village_app/features/day_off/data/repository/close_day_repository.dart';

final closeDayViewModelProvider =
    AsyncNotifierProvider<CloseDayViewModel, List<CloseDayModel>>(
      () => CloseDayViewModel(),
    );

class CloseDayViewModel extends AsyncNotifier<List<CloseDayModel>> {
  @override
  FutureOr<List<CloseDayModel>> build() {
    return ref.read(closeDayRepositoryProvider).loadCloseDays();
  }
}
