import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toy_village_app/core/widgets/skeleton/skeleton_zone.dart';

class NoticeDetailSkeleton extends StatelessWidget {
  const NoticeDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonZone(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Bone(
              width: 240,
              height: 30,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Bone(
                  width: 44,
                  height: 24,
                  borderRadius: BorderRadius.circular(25),
                ),
                const Spacer(),
                Bone(
                  width: 90,
                  height: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Bone(width: double.infinity, height: 1),
            ),
            const SkeletonLines(count: 6, lastWidth: 160),
          ],
        ),
      ),
    );
  }
}
