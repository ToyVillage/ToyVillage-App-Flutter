import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:toy_village_app/core/constants/color.dart';

class DayOffSkeleton extends StatelessWidget {
  const DayOffSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      effect: const ShimmerEffect(
        baseColor: ToyVillageColor.gray20,
        highlightColor: ToyVillageColor.gray10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Bone(
                  width: 56,
                  height: 18,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 10),
                Bone(
                  width: 44,
                  height: 30,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _calendarCard(),
          const SizedBox(height: 20),
          _scheduleCard(),
          const SizedBox(height: 20),
          _hoursCard(),
        ],
      ),
    );
  }

  Widget _calendarCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ToyVillageColor.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        children: [
          SizedBox(
            height: 32,
            child: Row(
              children: List.generate(
                7,
                (_) => Expanded(
                  child: Center(
                    child: Bone(
                      width: 16,
                      height: 14,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 384),
        ],
      ),
    );
  }

  Widget _scheduleCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ToyVillageColor.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Bone(width: 90, height: 22, borderRadius: BorderRadius.circular(4)),
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 7),
            child: Bone(
              width: 200,
              height: 19,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _hoursCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ToyVillageColor.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Bone(width: 70, height: 22, borderRadius: BorderRadius.circular(4)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Bone(
              width: 140,
              height: 24,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
