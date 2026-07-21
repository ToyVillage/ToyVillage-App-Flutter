import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

class ReservationText extends StatelessWidget {
  final Widget? icon;
  final String label;
  final String value;

  const ReservationText({
    super.key,
    this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null)
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: icon!,
          ),
        Text(
          label,
          style: ToyVillageTextStyle.body5.copyWith(
            color: ToyVillageColor.gray60,
          ),
        ),
        Text(value, style: ToyVillageTextStyle.body4),
      ],
    );
  }
}
