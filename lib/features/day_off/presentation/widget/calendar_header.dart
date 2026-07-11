import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;

  const CalendarHeader({super.key, required this.focusedDay});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${focusedDay.year}년', style: ToyVillageTextStyle.body3),
        Text('${focusedDay.month}월', style: ToyVillageTextStyle.heading1),
      ],
    );
  }
}
