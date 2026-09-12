import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/features/task/data/model/task_status.dart';
import 'package:toy_village_app/features/task/presentation/widget/task_tag_style.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final TaskStatus status;
  final DateTime? finishDate;
  final bool isNew;
  final VoidCallback onTap;

  const TaskCard({
    super.key,
    required this.title,
    required this.status,
    required this.finishDate,
    required this.isNew,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusInfo = taskCardStatus(status, finishDate);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ToyVillageColor.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(title, style: ToyVillageTextStyle.heading3),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      statusInfo.label,
                      style: ToyVillageTextStyle.caption4.copyWith(
                        color: statusInfo.color,
                      ),
                    ),
                  ],
                ),
              ),
              if (isNew)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: const BoxDecoration(
                      color: ToyVillageColor.red,
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
