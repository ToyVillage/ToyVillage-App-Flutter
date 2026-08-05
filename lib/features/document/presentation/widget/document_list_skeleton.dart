import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';

class DocumentListSkeleton extends StatelessWidget {
  const DocumentListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: ToyVillageTitle(
            title: '자료실',
            subTitle: '토이빌리지의 모든 자료가 모인 곳',
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
              itemCount: 6,
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
        decoration: BoxDecoration(color: ToyVillageColor.white),
        decoration: const BoxDecoration(color: ToyVillageColor.white),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Bone(width: 36, height: 36, borderRadius: BorderRadius.circular(4)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 35),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Bone(
                      width: 170,
                      height: 50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              Bone(width: 64, height: 29, borderRadius: BorderRadius.circular(4)),
            ],
          ),
        ),
      ),
    );
  }
}
