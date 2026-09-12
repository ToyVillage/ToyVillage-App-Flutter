import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toy_village_app/core/constants/color.dart';

class TaskDetailSkeleton extends StatelessWidget {
  const TaskDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      effect: const ShimmerEffect(
        baseColor: ToyVillageColor.gray20,
        highlightColor: ToyVillageColor.gray10,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Bone(
              width: 220,
              height: 32,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Bone(
                  width: 44,
                  height: 24,
                  borderRadius: BorderRadius.circular(25),
                ),
                const SizedBox(width: 6),
                Bone(
                  width: 60,
                  height: 24,
                  borderRadius: BorderRadius.circular(25),
                ),
              ],
            ),
            const SizedBox(height: 32),
            for (var i = 0; i < 4; i++) ...[
              Bone(
                width: double.infinity,
                height: 14,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 12),
            ],
            Bone(
              width: 200,
              height: 14,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }
}
