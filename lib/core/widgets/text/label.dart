import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

class ToyVillageLabel extends StatelessWidget {
  final String label;
  final TextStyle? labelStyle;
  final bool isOptional;

  const ToyVillageLabel({
    super.key,
    required this.label,
    this.labelStyle,
    this.isOptional = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: labelStyle ?? ToyVillageTextStyle.caption2),
        if (isOptional)
          Text(
            ' (선택)',
            style: ToyVillageTextStyle.caption4.copyWith(
              color: ToyVillageColor.gray60,
            ),
          ),
      ],
    );
  }
}
