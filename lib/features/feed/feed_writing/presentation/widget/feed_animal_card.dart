import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

class FeedAnimalCard extends StatelessWidget {
  final String speciesName;
  final String category;
  final VoidCallback onTap;

  const FeedAnimalCard({
    super.key,
    required this.speciesName,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: ToyVillageColor.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(speciesName, style: ToyVillageTextStyle.body3),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  category,
                  style: ToyVillageTextStyle.caption4.copyWith(
                    color: ToyVillageColor.gray60,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
