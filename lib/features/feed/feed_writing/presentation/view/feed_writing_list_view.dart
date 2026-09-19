import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/chip/category_filter.dart';
import 'package:toy_village_app/core/widgets/custom_async_value.dart';
import 'package:toy_village_app/core/widgets/paged_list_view.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/features/entity_info/data/model/animal_taxonomic.dart';
import 'package:toy_village_app/features/entity_info/presentation/view_model/animal_kind_list_view_model.dart';
import 'package:toy_village_app/features/feed/feed_writing/presentation/widget/feed_animal_card.dart';

class FeedWritingListView extends ConsumerStatefulWidget {
  const FeedWritingListView({super.key});

  @override
  ConsumerState<FeedWritingListView> createState() =>
      _FeedWritingListViewState();
}

class _FeedWritingListViewState extends ConsumerState<FeedWritingListView> {
  String _category = animalCategories.first;

  @override
  Widget build(BuildContext context) {
    final filter = (
      taxonomic: AnimalTaxonomic.fromLabel(_category),
      keyword: '',
    );

    return Scaffold(
      appBar: const ToyVillageAppBar(hasIcon: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ToyVillageTitle(
              title: '먹이 급여 관리',
              subTitle: '동물원 내 동물의 먹이 급여를 관리합니다',
            ),
            const SizedBox(height: 28),
            CategoryFilter(
              selected: _category,
              onSelected: (value) => setState(() => _category = value),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: CustomAsyncValue(
                value: ref.watch(animalKindListViewModelProvider(filter)),
                onRetry: () =>
                    ref.invalidate(animalKindListViewModelProvider(filter)),
                data: (page) => PagedListView(
                  items: page.items,
                  hasMore: page.hasMore,
                  isLoadingMore: page.isLoadingMore,
                  onRefresh: () async => ref.refresh(
                    animalKindListViewModelProvider(filter).future,
                  ),
                  onLoadMore: () => ref
                      .read(animalKindListViewModelProvider(filter).notifier)
                      .loadMore(),
                  itemBuilder: (context, kind) => FeedAnimalCard(
                    speciesName: kind.kindName,
                    category: kind.animalTaxonomic.label,
                    onTap: () => context.push(
                      '/feed-writing/entity',
                      extra: (
                        animalKindId: kind.animalKindId,
                        kindName: kind.kindName,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
