import 'package:flutter/material.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/chip/category_filter.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';

class EntityInfoView extends StatefulWidget {
  const EntityInfoView({super.key});

  @override
  State<EntityInfoView> createState() => _EntityInfoViewState();
}

class _EntityInfoViewState extends State<EntityInfoView> {
  String _category = animalCategories.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ToyVillageAppBar(closeIcon: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ToyVillageTitle(
              title: '개체 정보',
              subTitle: '동물원 내 동물을 확인합니다',
            ),
            const SizedBox(height: 28),
            CategoryFilter(
              selected: _category,
              onSelected: (value) => setState(() => _category = value),
            ),
          ],
        ),
      ),
    );
  }
}
