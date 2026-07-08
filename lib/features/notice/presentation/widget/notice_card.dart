import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/features/notice/presentation/widget/notice_time_label.dart';

class NoticeCard extends StatelessWidget {
  final String kind;
  final String title;
  final DateTime time;
  final bool isRead;
  final VoidCallback onTap;

  const NoticeCard({
    super.key,
    required this.kind,
    required this.title,
    required this.time,
    required this.isRead,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            color: ToyVillageColor.white,
            borderRadius: BorderRadius.circular(8)
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NoticeTimeLabel(kind: kind, time: time),
                    SizedBox(height: 8,),
                    Text(title, style: ToyVillageTextStyle.heading3.copyWith(fontSize: 20),)
                  ],
                ),
              ),
              if (!isRead)
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
