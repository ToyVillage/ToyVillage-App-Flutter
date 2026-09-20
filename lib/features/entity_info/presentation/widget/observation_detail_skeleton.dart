import 'package:flutter/material.dart';
import 'package:toy_village_app/core/widgets/skeleton/skeleton_zone.dart';

class ObservationDetailSkeleton extends StatelessWidget {
  const ObservationDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SkeletonZone(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 28),
            SkeletonField(height: 48),
            SizedBox(height: 20),
            SkeletonField(height: 180),
          ],
        ),
      ),
    );
  }
}
