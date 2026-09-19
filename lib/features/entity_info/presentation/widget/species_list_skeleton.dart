import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/widgets/skeleton/skeleton_zone.dart';

class SpeciesListSkeleton extends StatelessWidget {
  const SpeciesListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonZone(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 8,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) => Container(
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
                Bone(
                  width: 90,
                  height: 18,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(width: 8),
                Bone(
                  width: 40,
                  height: 12,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
