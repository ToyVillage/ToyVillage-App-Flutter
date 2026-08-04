import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';

class ReservationListSkeleton extends StatelessWidget {
  const ReservationListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: ToyVillageTitle(
            title: '단체예약 확인',
            subTitle: '토이빌리지 단체예약 확인 및 관리',
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
              itemCount: 3,
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
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
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
              Bone(width: 140, height: 29, borderRadius: BorderRadius.circular(4)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Bone(
                  width: 120,
                  height: 20,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Bone(width: 150, height: 20, borderRadius: BorderRadius.circular(4)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Bone(
                      width: 130,
                      height: 20,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(width: 12),
                    Bone(
                      width: 130,
                      height: 20,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ),
              Bone(
                width: double.infinity,
                height: 46,
                borderRadius: BorderRadius.circular(8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
