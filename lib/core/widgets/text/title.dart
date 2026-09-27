import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

class ToyVillageTitle extends StatelessWidget {
  final String title;
  final String? subTitle;

  const ToyVillageTitle({super.key, required this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: ToyVillageTextStyle.heading1),

        if(subTitle != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(subTitle!, style: ToyVillageTextStyle.caption2.copyWith(color: ToyVillageColor.gray60)),
          ),
      ],
    );
  }
}
