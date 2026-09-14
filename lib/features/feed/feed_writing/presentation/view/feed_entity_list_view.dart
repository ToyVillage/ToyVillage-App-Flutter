import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/features/entity_info/presentation/widget/entity_name_card.dart';

class FeedEntityListView extends StatelessWidget {
  final String speciesName;
  final String category;

  const FeedEntityListView({
    super.key,
    required this.speciesName,
    required this.category,
  });

  List<String> get _entities => ['동식 행님', '동석이', '우현이'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ToyVillageAppBar(hasIcon: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ToyVillageTitle(title: speciesName),
              const SizedBox(height: 28),
              Expanded(
                child: ListView.separated(
                  itemCount: _entities.length,
                  itemBuilder: (context, index) {
                    final entityName = _entities[index];
                    return EntityNameCard(
                      name: entityName,
                      onTap: () => context.push(
                        '/feed-writing/write',
                        extra: (
                          speciesName: speciesName,
                          category: category,
                          entityName: entityName,
                          isEdit: false,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
