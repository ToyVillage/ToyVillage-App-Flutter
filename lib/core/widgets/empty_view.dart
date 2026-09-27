import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

class EmptyView extends StatelessWidget {
  final String message;

  const EmptyView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, -0.1),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: ToyVillageTextStyle.body2.copyWith(
          color: ToyVillageColor.gray60,
        ),
      ),
    );
  }
}
