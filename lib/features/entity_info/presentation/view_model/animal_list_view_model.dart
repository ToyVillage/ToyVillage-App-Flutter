import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/entity_info/data/model/animal_summary.dart';
import 'package:toy_village_app/features/entity_info/data/model/page_result.dart';
import 'package:toy_village_app/features/entity_info/data/repository/animal_manage_repository.dart';

typedef AnimalListFilter = ({int animalKindId, String keyword});

final animalListViewModelProvider =
    AsyncNotifierProvider.family<
      AnimalListViewModel,
      PageResult<AnimalSummary>,
      AnimalListFilter
    >(AnimalListViewModel.new);

class AnimalListViewModel extends AsyncNotifier<PageResult<AnimalSummary>> {
  final AnimalListFilter filter;

  AnimalListViewModel(this.filter);

  @override
  FutureOr<PageResult<AnimalSummary>> build() {
    return ref
        .read(animalManageRepositoryProvider)
        .loadAnimals(filter.animalKindId, keyword: filter.keyword);
  }
}
