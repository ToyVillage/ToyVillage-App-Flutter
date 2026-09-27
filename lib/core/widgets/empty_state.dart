import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

class EmptyState extends StatelessWidget {
  final String message;

  const EmptyState({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, -0.1),
      child: Text(
        message,
        style: ToyVillageTextStyle.body3.copyWith(color: ToyVillageColor.gray60),
      ),
    );
  }
}
