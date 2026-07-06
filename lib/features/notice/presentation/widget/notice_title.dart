import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/features/notice/presentation/widget/notice_time_label.dart';

class NoticeTitle extends StatelessWidget {
  final String title;
  final String kind;
  final DateTime time;

  const NoticeTitle({
    super.key,
    required this.title,
    required this.kind,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: ToyVillageTextStyle.heading2,),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: NoticeTimeLabel(kind: kind, time: time, clockIcon: true)
          )
        ]
    );
  }
}
