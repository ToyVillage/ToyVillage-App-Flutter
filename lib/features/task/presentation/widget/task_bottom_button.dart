import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

class TaskBottomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const TaskBottomButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: enabled ? ToyVillageColor.gray100 : ToyVillageColor.gray40,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: ToyVillageTextStyle.button2.copyWith(
            color: ToyVillageColor.white,
          ),
        ),
      ),
    );
  }
}
