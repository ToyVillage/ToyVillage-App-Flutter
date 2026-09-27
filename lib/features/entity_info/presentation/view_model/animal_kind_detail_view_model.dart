import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/entity_info/data/model/animal_kind_detail.dart';
import 'package:toy_village_app/features/entity_info/data/repository/animal_manage_repository.dart';

final animalKindDetailViewModelProvider =
    AsyncNotifierProvider.family<
      AnimalKindDetailViewModel,
      AnimalKindDetail,
      int
    >(AnimalKindDetailViewModel.new);

class AnimalKindDetailViewModel extends AsyncNotifier<AnimalKindDetail> {
  final int animalKindId;

  AnimalKindDetailViewModel(this.animalKindId);

  @override
  FutureOr<AnimalKindDetail> build() {
    return ref
        .read(animalManageRepositoryProvider)
        .loadKindDetail(animalKindId);
  }
}
