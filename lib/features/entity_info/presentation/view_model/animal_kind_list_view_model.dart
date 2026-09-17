import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/entity_info/data/model/animal_kind.dart';
import 'package:toy_village_app/features/entity_info/data/model/animal_taxonomic.dart';
import 'package:toy_village_app/features/entity_info/data/repository/animal_manage_repository.dart';

typedef AnimalKindFilter = ({AnimalTaxonomic? taxonomic, String keyword});

final animalKindListViewModelProvider =
    AsyncNotifierProvider.family<
      AnimalKindListViewModel,
      AnimalKindPage,
      AnimalKindFilter
    >(AnimalKindListViewModel.new);

class AnimalKindListViewModel extends AsyncNotifier<AnimalKindPage> {
  final AnimalKindFilter filter;

  AnimalKindListViewModel(this.filter);

  @override
  FutureOr<AnimalKindPage> build() {
    return ref
        .read(animalManageRepositoryProvider)
        .loadKinds(
          animalTaxonomic: filter.taxonomic,
          keyword: filter.keyword,
        );
  }
}
