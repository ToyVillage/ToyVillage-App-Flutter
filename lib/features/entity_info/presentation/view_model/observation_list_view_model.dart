import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/entity_info/data/model/observation.dart';
import 'package:toy_village_app/features/entity_info/data/model/page_result.dart';
import 'package:toy_village_app/features/entity_info/data/repository/animal_manage_repository.dart';

final observationListViewModelProvider =
    AsyncNotifierProvider.family<
      ObservationListViewModel,
      PageResult<Observation>,
      int
    >(ObservationListViewModel.new);

class ObservationListViewModel extends AsyncNotifier<PageResult<Observation>> {
  final int animalManageId;

  ObservationListViewModel(this.animalManageId);

  @override
  FutureOr<PageResult<Observation>> build() {
    return ref
        .read(animalManageRepositoryProvider)
        .loadObservations(animalManageId);
  }
}
