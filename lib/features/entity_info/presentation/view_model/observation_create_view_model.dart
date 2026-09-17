import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/entity_info/data/model/observation.dart';
import 'package:toy_village_app/features/entity_info/data/repository/animal_manage_repository.dart';

final observationCreateViewModelProvider =
    AsyncNotifierProvider<ObservationCreateViewModel, void>(
      ObservationCreateViewModel.new,
    );

class ObservationCreateViewModel extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> create(int animalManageId, ObservationRequest request) async {
    state = const AsyncLoading();
    try {
      await ref
          .read(animalManageRepositoryProvider)
          .createObservation(animalManageId, request);
      state = const AsyncData(null);
      return true;
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return false;
    }
  }
}
