import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/chip/category_filter.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/features/feed/feed_info/presentation/view_model/feed_species_view_model.dart';
import 'package:toy_village_app/features/feed/feed_writing/presentation/widget/feed_animal_card.dart';

class FeedInfoView extends ConsumerStatefulWidget {
  const FeedInfoView({super.key});

  @override
  ConsumerState<FeedInfoView> createState() => _FeedInfoViewState();
}

class _FeedInfoViewState extends ConsumerState<FeedInfoView> {
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
              title: '먹이 급여 정보',
              subTitle: '동물 종을 선택해 급여 기록을 확인합니다',
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
                      '/feed-info/detail',
                      extra: (
                        speciesName: animal.speciesName,
                        category: animal.category,
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
