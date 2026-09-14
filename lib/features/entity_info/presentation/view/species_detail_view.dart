import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/features/entity_info/presentation/widget/entity_name_card.dart';
import 'package:toy_village_app/features/entity_info/presentation/widget/info_label.dart';

class SpeciesDetailView extends StatelessWidget {
  final String speciesName;
  final String category;

  const SpeciesDetailView({
    super.key,
    required this.speciesName,
    required this.category,
  });

  List<String> get _entities => [
    '$speciesName 1호',
    '$speciesName 2호',
    '$speciesName 3호',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ToyVillageAppBar(hasIcon: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ToyVillageTitle(title: speciesName),
                const SizedBox(height: 28),
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: ToyVillageColor.gray20,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 20),
                const InfoLabel(
                  label: '학명',
                  value: 'Hydrochoerus hydrochaeris',
                ),
                InfoLabel(label: '분류군', value: category),
                const InfoLabel(label: '법정지정분류', value: '일반종'),
                const SizedBox(height: 28),
                Text(
                  '개체 리스트',
                  style: ToyVillageTextStyle.caption4.copyWith(
                    color: ToyVillageColor.gray60,
                  ),
                ),
                const SizedBox(height: 12),
                for (var i = 0; i < _entities.length; i++) ...[
                  if (i > 0) const SizedBox(height: 8),
                  EntityNameCard(
                    name: _entities[i],
                    onTap: () => context.push(
                      '/entity-info/entity',
                      extra: (entityName: _entities[i], category: category),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
