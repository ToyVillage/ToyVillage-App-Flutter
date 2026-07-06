import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/features/notice/presentation/widget/notice_time_label.dart';

class NoticeCard extends StatelessWidget {
  final String kind;
  final String title;
  final DateTime time;
  final VoidCallback onTap;

  const NoticeCard({
    super.key,
    required this.kind,
    required this.title,
    required this.time,
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NoticeTimeLabel(kind: kind, time: time),
                SizedBox(height: 8,),
                Text(title, style: ToyVillageTextStyle.heading3,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
