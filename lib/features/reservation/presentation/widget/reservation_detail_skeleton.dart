import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/widgets/skeleton/skeleton_zone.dart';

class ReservationDetailSkeleton extends StatelessWidget {
  const ReservationDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonZone(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Bone(
              width: 200,
              height: 30,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Bone(
              width: 140,
              height: 16,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 28),
            const _Card(rowCount: 5),
            const SizedBox(height: 16),
            const _Card(rowCount: 3),
            const SizedBox(height: 16),
            const _Card(rowCount: 5),
            const SizedBox(height: 16),
            const _MoneyCard(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final int rowCount;

  const _Card({required this.rowCount});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Bone(
                width: 80,
                height: 24,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            for (var i = 0; i < rowCount; i++)
              Padding(
                padding: EdgeInsets.only(bottom: i == rowCount - 1 ? 0 : 16),
                child: Row(
                  children: [
                    Bone(
                      width: 18,
                      height: 18,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(width: 8),
                    Bone(
                      width: 150,
                      height: 14,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MoneyCard extends StatelessWidget {
  const _MoneyCard();

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Bone(
                width: 60,
                height: 24,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Bone(
              width: double.infinity,
              height: 52,
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
      ),
    );
  }
}
