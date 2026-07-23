import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/utils/time_util.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final DateTime time;
  final bool isCompleted;
  final bool showDot;
  final VoidCallback onTap;

  const TaskCard({
    super.key,
    required this.title,
    required this.time,
    required this.isCompleted,
    required this.showDot,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isCompleted ? null : onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: ToyVillageColor.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: ToyVillageTextStyle.heading6.copyWith(
                        color: isCompleted
                            ? ToyVillageColor.gray40
                            : ToyVillageColor.gray100,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        if (isCompleted)
                          Text(
                            '완료됨',
                            style: ToyVillageTextStyle.caption4.copyWith(
                              color: ToyVillageColor.green,
                            ),
                          ),
                        const Spacer(),
                        Text(
                          timeCheck(time),
                          style: ToyVillageTextStyle.caption4.copyWith(
                            color: isCompleted
                                ? ToyVillageColor.gray40
                                : ToyVillageColor.gray60,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (showDot && !isCompleted)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: ToyVillageColor.yellow,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
