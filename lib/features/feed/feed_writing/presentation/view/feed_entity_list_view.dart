import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/custom_async_value.dart';
import 'package:toy_village_app/features/entity_info/presentation/widget/entity_name_list_skeleton.dart';
import 'package:toy_village_app/core/widgets/empty_view.dart';
import 'package:toy_village_app/core/widgets/paged_list_view.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/features/entity_info/presentation/view_model/animal_list_view_model.dart';
import 'package:toy_village_app/features/entity_info/presentation/widget/entity_name_card.dart';

class FeedEntityListView extends ConsumerWidget {
  final int animalKindId;
  final String kindName;

  const FeedEntityListView({
    super.key,
    required this.animalKindId,
    required this.kindName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = (animalKindId: animalKindId, keyword: '');

    return Scaffold(
      appBar: const ToyVillageAppBar(hasIcon: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ToyVillageTitle(title: kindName),
              const SizedBox(height: 28),
              Expanded(
                child: CustomAsyncValue(
                  value: ref.watch(animalListViewModelProvider(filter)),
                  loading: const EntityNameListSkeleton(),
                  onRetry: () =>
                      ref.invalidate(animalListViewModelProvider(filter)),
                  data: (page) {
                    if (page.items.isEmpty) {
                      return const EmptyView(message: '등록된 개체가 없어요.');
                    }
                    return PagedListView(
                      items: page.items,
                      hasMore: page.hasMore,
                      isLoadingMore: page.isLoadingMore,
                      onRefresh: () async => ref.refresh(
                        animalListViewModelProvider(filter).future,
                      ),
                      onLoadMore: () => ref
                          .read(animalListViewModelProvider(filter).notifier)
                          .loadMore(),
                      itemBuilder: (context, animal) => EntityNameCard(
                        name: animal.animalName,
                        onTap: () => context.push(
                          '/feed-writing/write',
                          extra: (
                            animalManageId: animal.animalManageId,
                            feedLogId: null,
                            animalName: animal.animalName,
                            initial: null,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
