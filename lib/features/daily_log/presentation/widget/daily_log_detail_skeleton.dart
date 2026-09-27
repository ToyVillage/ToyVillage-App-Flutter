import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toy_village_app/core/widgets/skeleton/skeleton_zone.dart';

class DailyLogDetailSkeleton extends StatelessWidget {
  const DailyLogDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonZone(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Bone(
              width: 180,
              height: 30,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 24),
            const SkeletonField(height: 60),
            const SizedBox(height: 16),
            const SkeletonField(height: 120),
          ],
        ),
      ),
    );
  }
}
