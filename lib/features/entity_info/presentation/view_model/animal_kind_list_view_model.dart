import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/entity_info/data/model/animal_kind.dart';
import 'package:toy_village_app/features/entity_info/data/model/animal_taxonomic.dart';
import 'package:toy_village_app/features/entity_info/data/model/paged_list.dart';
import 'package:toy_village_app/features/entity_info/data/repository/animal_manage_repository.dart';

typedef AnimalKindFilter = ({AnimalTaxonomic? taxonomic, String keyword});

final animalKindListViewModelProvider =
    AsyncNotifierProvider.family<
      AnimalKindListViewModel,
      PagedList<AnimalKind>,
      AnimalKindFilter
    >(AnimalKindListViewModel.new);

class AnimalKindListViewModel extends AsyncNotifier<PagedList<AnimalKind>> {
  final AnimalKindFilter filter;

  AnimalKindListViewModel(this.filter);

  @override
  Future<PagedList<AnimalKind>> build() async {
    final page = await ref
        .read(animalManageRepositoryProvider)
        .loadKinds(
          animalTaxonomic: filter.taxonomic,
          keyword: filter.keyword,
        );
    return PagedList(
      items: page.animalKinds,
      nextPage: 1,
      hasMore: page.totalPageSize > 1,
    );
  }

  Future<void> loadMore() async {
    final current = state.asData?.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));
    try {
      final page = await ref
          .read(animalManageRepositoryProvider)
          .loadKinds(
            animalTaxonomic: filter.taxonomic,
            keyword: filter.keyword,
            page: current.nextPage,
          );
      state = AsyncData(
        PagedList(
          items: [...current.items, ...page.animalKinds],
          nextPage: current.nextPage + 1,
          hasMore: current.nextPage + 1 < page.totalPageSize,
        ),
      );
    } catch (_) {
      state = AsyncData(current.copyWith(isLoadingMore: false));
    }
  }
}
