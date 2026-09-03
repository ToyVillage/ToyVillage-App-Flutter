import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/chip/category_filter.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/features/feed/feed_writing/presentation/widget/feed_animal_card.dart';

class _AnimalSpecies {
  final String speciesName;
  final String category;

  const _AnimalSpecies({required this.speciesName, required this.category});
}

const _species = <_AnimalSpecies>[
  _AnimalSpecies(speciesName: '카피바라', category: '포유류'),
  _AnimalSpecies(speciesName: '원숭이', category: '포유류'),
  _AnimalSpecies(speciesName: '사막여우', category: '포유류'),
  _AnimalSpecies(speciesName: '흰동가리', category: '어류'),
  _AnimalSpecies(speciesName: '금붕어', category: '어류'),
  _AnimalSpecies(speciesName: '거북', category: '파충류'),
  _AnimalSpecies(speciesName: '이구아나', category: '파충류'),
  _AnimalSpecies(speciesName: '비둘기', category: '조류'),
  _AnimalSpecies(speciesName: '앵무', category: '조류'),
];

class FeedInfoView extends StatefulWidget {
  const FeedInfoView({super.key});

  @override
  State<FeedInfoView> createState() => _FeedInfoViewState();
}

class _FeedInfoViewState extends State<FeedInfoView> {
  String _category = animalCategories.first;

  @override
  Widget build(BuildContext context) {
    final species = _species.where((e) => e.category == _category).toList();

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
