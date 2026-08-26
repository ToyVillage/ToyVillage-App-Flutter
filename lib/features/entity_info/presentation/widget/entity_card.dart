import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

class EntityCard extends StatelessWidget {
  final String entityName;
  final String animalCategory;
  final String animalName;
  final VoidCallback onTap;

  const EntityCard({
    super.key,
    required this.entityName,
    required this.animalName,
    required this.animalCategory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: ToyVillageColor.white,
          borderRadius: BorderRadius.circular(8),
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(entityName, style: ToyVillageTextStyle.body3),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  animalName,
                  style: ToyVillageTextStyle.caption4.copyWith(
                    color: ToyVillageColor.gray60,
                  ),
                ),
              ),
              Text(
                animalCategory,
                style: ToyVillageTextStyle.caption4.copyWith(
                  color: ToyVillageColor.gray60,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
