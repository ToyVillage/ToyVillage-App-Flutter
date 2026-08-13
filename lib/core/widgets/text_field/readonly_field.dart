import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/widgets/text/label.dart';

class ToyVillageReadonlyField extends StatelessWidget {
  final String label;
  final String value;
  final int minLines;

  const ToyVillageReadonlyField({
    super.key,
    required this.label,
    required this.value,
    this.minLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.transparent),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ToyVillageLabel(label: label),
        const SizedBox(height: 8),
        TextFormField(
          key: ValueKey(value),
          initialValue: value,
          readOnly: true,
          minLines: minLines,
          maxLines: null,
          style: ToyVillageTextStyle.caption3,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(16),
            filled: true,
            fillColor: ToyVillageColor.white,
            enabledBorder: border,
            focusedBorder: border,
          ),
        ),
      ],
    );
  }
}
