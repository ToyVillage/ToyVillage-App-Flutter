import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toy_village_app/core/widgets/skeleton/skeleton_zone.dart';

class FeedDetailSkeleton extends StatelessWidget {
  const FeedDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonZone(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Bone(width: 160, height: 30, borderRadius: BorderRadius.circular(4)),
            const SizedBox(height: 28),
            const _LabeledBox(),
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(child: _LabeledBox()),
                SizedBox(width: 12),
                Expanded(child: _LabeledBox()),
              ],
            ),
            const SizedBox(height: 16),
            const _LabeledBox(height: 52),
            const SizedBox(height: 16),
            const _LabeledBox(height: 52),
          ],
        ),
      ),
    );
  }
}

class _LabeledBox extends StatelessWidget {
  final double height;

  const _LabeledBox({this.height = 52});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Bone(width: 60, height: 14, borderRadius: BorderRadius.circular(4)),
        const SizedBox(height: 12),
        Bone(
          width: double.infinity,
          height: height,
          borderRadius: BorderRadius.circular(8),
        ),
      ],
    );
  }
}
