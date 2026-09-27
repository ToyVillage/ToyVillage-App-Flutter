import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/day_off/data/model/open_time_model.dart';
import 'package:toy_village_app/features/day_off/data/repository/open_time_repository.dart';

final openTimeViewModelProvider =
    AsyncNotifierProvider<OpenTimeViewModel, List<OpenTimeModel>>(
      () => OpenTimeViewModel(),
    );

class OpenTimeViewModel extends AsyncNotifier<List<OpenTimeModel>> {
  @override
  FutureOr<List<OpenTimeModel>> build() {
    return ref.read(openTimeRepositoryProvider).loadOpenTimes();
  }
}
