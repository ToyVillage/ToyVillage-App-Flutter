import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/widgets/title.dart';

class TaskListSkeleton extends StatelessWidget {
  const TaskListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: ToyVillageTitle(
            title: '오늘의 업무',
            subTitle: '오늘 자신의 업무를 조회합니다',
          ),
        ),
        Expanded(
          child: Skeletonizer.zone(
            effect: ShimmerEffect(
              baseColor: ToyVillageColor.gray20,
              highlightColor: ToyVillageColor.gray10,
            ),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) => const _SkeletonCard(),
            ),
          ),
        ),
      ],
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: ToyVillageColor.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Bone(
                width: 200,
                height: 24,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Spacer(),
                  Bone(
                    width: 48,
                    height: 14,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
