import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/chip/category_filter.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/features/entity_info/presentation/widget/entity_card.dart';

class EntityInfoView extends StatefulWidget {
  const EntityInfoView({super.key});

  @override
  State<EntityInfoView> createState() => _EntityInfoViewState();
}

class _EntityDummy {
  final int id;
  final String entityName;
  final String animalName;
  final String category;

  const _EntityDummy({
    required this.id,
    required this.entityName,
    required this.animalName,
    required this.category,
  });
}

const _entities = <_EntityDummy>[
  _EntityDummy(id: 1, entityName: '하나숭이', animalName: '원숭이', category: '포유류'),
  _EntityDummy(id: 2, entityName: '두나숭이', animalName: '원숭이', category: '포유류'),
  _EntityDummy(id: 3, entityName: '니모', animalName: '흰동가리', category: '어류'),
  _EntityDummy(id: 4, entityName: '뽀글이', animalName: '금붕어', category: '어류'),
  _EntityDummy(id: 5, entityName: '거부기', animalName: '거북', category: '파충류'),
  _EntityDummy(id: 6, entityName: '구구', animalName: '비둘기', category: '조류'),
];

class _EntityInfoViewState extends State<EntityInfoView> {
  String _category = animalCategories.first;

  @override
  Widget build(BuildContext context) {
    final entities =
        _entities.where((e) => e.category == _category).toList();

    return Scaffold(
      appBar: const ToyVillageAppBar(hasIcon: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ToyVillageTitle(title: '개체 정보', subTitle: '동물원 내 동물을 확인합니다'),
            const SizedBox(height: 28),
            CategoryFilter(
              selected: _category,
              onSelected: (value) => setState(() => _category = value),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: ListView.separated(
                itemCount: entities.length,
                itemBuilder: (context, index) {
                  final entity = entities[index];
                  return EntityCard(
                    entityName: entity.entityName,
                    animalName: entity.animalName,
                    animalCategory: entity.category,
                    onTap: () {
                      context.push('/entity-info/detail', extra: entity.id);
                    },
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
