import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

class ToyVillageButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color background;
  final Color textColor;
  final Border? border;

  const ToyVillageButton({
    super.key,
    required this.label,
    required this.onTap,
    this.background = ToyVillageColor.gray100,
    this.textColor = ToyVillageColor.white,
    this.border,
  });

  const ToyVillageButton.outlined({
    super.key,
    required this.label,
    required this.onTap,
  }) : background = ToyVillageColor.gray10,
       textColor = ToyVillageColor.gray100,
       border = const Border.fromBorderSide(
         BorderSide(color: ToyVillageColor.gray100),
       );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(8),
          border: border,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.5),
          child: Center(
            child: Text(
              label,
              style: ToyVillageTextStyle.button3.copyWith(color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}
