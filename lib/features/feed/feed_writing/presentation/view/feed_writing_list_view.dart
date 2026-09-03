import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/chip/category_filter.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/features/feed/feed_info/presentation/view_model/feed_species_view_model.dart';
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
    final species = ref
        .watch(feedSpeciesViewModelProvider)
        .where((e) => e.category == _category)
        .toList();

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
              child: ListView.separated(
                itemCount: species.length,
                itemBuilder: (context, index) {
                  final animal = species[index];
                  return FeedAnimalCard(
                    speciesName: animal.speciesName,
                    category: animal.category,
                    onTap: () => context.push(
                      '/feed-writing/write',
                      extra: (
                        speciesName: animal.speciesName,
                        category: animal.category,
                        isEdit: false,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
