import 'package:flutter/material.dart';
import 'package:toy_village_app/core/widgets/skeleton/skeleton_zone.dart';

class WorkReportDetailSkeleton extends StatelessWidget {
  const WorkReportDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SkeletonZone(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonField(height: 160),
            SizedBox(height: 20),
            SkeletonField(height: 100),
          ],
        ),
      ),
    );
  }
}
