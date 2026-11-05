import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

class TagChip extends StatelessWidget {
  final String label;
  final Color textColor;
  final Color backgroundColor;
  final Color? borderColor;

  const TagChip({
    super.key,
    required this.label,
    required this.textColor,
    required this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(25),
        border: borderColor == null ? null : Border.all(color: borderColor!),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        child: Text(
          label,
          style: ToyVillageTextStyle.button5.copyWith(color: textColor),
        ),
      ),
    );
  }
}
