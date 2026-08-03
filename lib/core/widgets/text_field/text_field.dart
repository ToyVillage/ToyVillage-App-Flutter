import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/widgets/text/label.dart';

class ToyVillageTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final int minLines;
  final int? maxLines;
  final TextEditingController? controller;
  final bool isOptional;

  const ToyVillageTextField({
    super.key,
    required this.label,
    this.hintText = '',
    this.minLines = 1,
    this.maxLines,
    this.controller,
    this.isOptional = false
  });

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.transparent),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ToyVillageLabel(label: label, isOptional: isOptional,),
        const SizedBox(height: 8),
        TextFormField(
          style: ToyVillageTextStyle.caption3,
          controller: controller,
          minLines: minLines,
          maxLines: maxLines,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(16),
            hintText: hintText,
            hintStyle: ToyVillageTextStyle.caption4.copyWith(
              color: ToyVillageColor.gray60,
            ),
            filled: true,
            fillColor: ToyVillageColor.white,
            enabledBorder: outlineInputBorder,
            focusedBorder: outlineInputBorder,
          ),
        ),
      ],
    );
  }
}
