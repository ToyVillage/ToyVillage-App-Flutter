import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

class InfoLabel extends StatelessWidget {
  final String label;
  final String value;

  const InfoLabel({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            label,
            style: ToyVillageTextStyle.caption3.copyWith(
              color: ToyVillageColor.gray60,
            ),
          ),
          const SizedBox(width: 12,),
          Text(value, style: ToyVillageTextStyle.caption2)
        ],
      ),
    );
  }
}
