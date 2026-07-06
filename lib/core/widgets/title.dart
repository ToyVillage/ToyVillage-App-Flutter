import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

class ToyVillageTitle extends StatelessWidget {
  final String title;
  final String subTitle;

  const ToyVillageTitle({super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(title, style: ToyVillageTextStyle.heading1),
        ),
        Text(subTitle, style: ToyVillageTextStyle.caption2.copyWith(color: ToyVillageColor.gray60)),
      ],
    );
  }
}
