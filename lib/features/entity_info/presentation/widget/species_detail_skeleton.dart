import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/widgets/skeleton/skeleton_zone.dart';

class SpeciesDetailSkeleton extends StatelessWidget {
  const SpeciesDetailSkeleton({super.key});

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
            Bone(
              width: double.infinity,
              height: 180,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 20),
            for (var i = 0; i < 4; i++) ...[
              const _InfoRowBone(),
              const SizedBox(height: 16),
            ],
            const SizedBox(height: 12),
            Bone(width: 80, height: 14, borderRadius: BorderRadius.circular(4)),
            const SizedBox(height: 12),
            for (var i = 0; i < 3; i++) ...[
              if (i > 0) const SizedBox(height: 8),
              const _NameCardBone(),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRowBone extends StatelessWidget {
  const _InfoRowBone();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Bone(width: 50, height: 14, borderRadius: BorderRadius.circular(4)),
        const SizedBox(width: 12),
        Bone(width: 120, height: 14, borderRadius: BorderRadius.circular(4)),
      ],
    );
  }
}

class _NameCardBone extends StatelessWidget {
  const _NameCardBone();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ToyVillageColor.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Bone(
          width: 100,
          height: 18,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
