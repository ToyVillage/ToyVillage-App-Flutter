import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/entity_info/data/model/animal_summary.dart';
import 'package:toy_village_app/features/entity_info/data/model/paged_list.dart';
import 'package:toy_village_app/features/entity_info/data/repository/animal_manage_repository.dart';

typedef AnimalListFilter = ({int animalKindId, String keyword});

final animalListViewModelProvider =
    AsyncNotifierProvider.family<
      AnimalListViewModel,
      PagedList<AnimalSummary>,
      AnimalListFilter
    >(AnimalListViewModel.new);

class AnimalListViewModel extends AsyncNotifier<PagedList<AnimalSummary>> {
  final AnimalListFilter filter;

  AnimalListViewModel(this.filter);

  @override
  Future<PagedList<AnimalSummary>> build() async {
    final page = await ref
        .read(animalManageRepositoryProvider)
        .loadAnimals(filter.animalKindId, keyword: filter.keyword);
    return PagedList(
      items: page.content,
      nextPage: 1,
      hasMore: !page.last,
    );
  }

  Future<void> loadMore() async {
    final current = state.asData?.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));
    try {
      final page = await ref
          .read(animalManageRepositoryProvider)
          .loadAnimals(
            filter.animalKindId,
            keyword: filter.keyword,
            page: current.nextPage,
          );
      state = AsyncData(
        PagedList(
          items: [...current.items, ...page.content],
          nextPage: current.nextPage + 1,
          hasMore: !page.last,
        ),
      );
    } catch (_) {
      state = AsyncData(current.copyWith(isLoadingMore: false));
    }
  }
}
