import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toy_village_app/core/constants/color.dart';

class SkeletonZone extends StatelessWidget {
  final Widget child;

  const SkeletonZone({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      effect: const ShimmerEffect(
        baseColor: ToyVillageColor.gray20,
        highlightColor: ToyVillageColor.gray10,
      ),
      child: child,
    );
  }
}

class SkeletonLines extends StatelessWidget {
  final int count;
  final double lastWidth;

  const SkeletonLines({super.key, this.count = 4, this.lastWidth = 200});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          Bone(
            width: i == count - 1 ? lastWidth : double.infinity,
            height: 14,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ],
    );
  }
}

class SkeletonField extends StatelessWidget {
  final double height;

  const SkeletonField({super.key, this.height = 120});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Bone(width: 60, height: 16, borderRadius: BorderRadius.circular(4)),
        const SizedBox(height: 8),
        Bone(
          width: double.infinity,
          height: height,
          borderRadius: BorderRadius.circular(8),
        ),
      ],
    );
  }
}
