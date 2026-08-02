import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';

class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Divider(thickness: 1, color: ToyVillageColor.gray60),
    );
  }
}
