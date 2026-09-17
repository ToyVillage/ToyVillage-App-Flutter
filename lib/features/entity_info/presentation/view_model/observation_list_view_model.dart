import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/entity_info/data/model/observation.dart';
import 'package:toy_village_app/features/entity_info/data/model/paged_list.dart';
import 'package:toy_village_app/features/entity_info/data/repository/animal_manage_repository.dart';

final observationListViewModelProvider =
    AsyncNotifierProvider.family<
      ObservationListViewModel,
      PagedList<Observation>,
      int
    >(ObservationListViewModel.new);

class ObservationListViewModel extends AsyncNotifier<PagedList<Observation>> {
  final int animalManageId;

  ObservationListViewModel(this.animalManageId);

  @override
  Future<PagedList<Observation>> build() async {
    final page = await ref
        .read(animalManageRepositoryProvider)
        .loadObservations(animalManageId);
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
          .loadObservations(animalManageId, page: current.nextPage);
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
