import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toy_village_app/core/widgets/skeleton/skeleton_zone.dart';

class DocumentPreviewSkeleton extends StatelessWidget {
  const DocumentPreviewSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonZone(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Bone(
              width: 200,
              height: 26,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 20),
            Bone(
              width: double.infinity,
              height: 260,
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
      ),
    );
  }
}
