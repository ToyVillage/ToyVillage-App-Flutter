import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/entity_info/data/model/observation.dart';
import 'package:toy_village_app/features/entity_info/data/repository/animal_manage_repository.dart';

typedef ObservationKey = ({int animalManageId, int observationId});

final observationDetailViewModelProvider =
    AsyncNotifierProvider.family<
      ObservationDetailViewModel,
      ObservationDetail,
      ObservationKey
    >(ObservationDetailViewModel.new);

class ObservationDetailViewModel extends AsyncNotifier<ObservationDetail> {
  final ObservationKey key;

  ObservationDetailViewModel(this.key);

  @override
  FutureOr<ObservationDetail> build() {
    return ref
        .read(animalManageRepositoryProvider)
        .loadObservationDetail(key.animalManageId, key.observationId);
  }
}
