import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/entity_info/data/model/animal_detail.dart';
import 'package:toy_village_app/features/entity_info/data/repository/animal_manage_repository.dart';

final animalDetailViewModelProvider =
    AsyncNotifierProvider.family<AnimalDetailViewModel, AnimalDetail, int>(
      AnimalDetailViewModel.new,
    );

class AnimalDetailViewModel extends AsyncNotifier<AnimalDetail> {
  final int animalManageId;

  AnimalDetailViewModel(this.animalManageId);

  @override
  FutureOr<AnimalDetail> build() {
    return ref
        .read(animalManageRepositoryProvider)
        .loadAnimalDetail(animalManageId);
  }
}
