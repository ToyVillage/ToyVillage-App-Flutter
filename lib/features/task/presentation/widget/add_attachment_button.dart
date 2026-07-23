import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

class AddAttachmentButton extends StatelessWidget {
  final VoidCallback onTap;

  const AddAttachmentButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: ToyVillageColor.gray60),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Symbols.add,
                size: 20,
                color: ToyVillageColor.gray100,
              ),
              const SizedBox(width: 8),
              Text(
                '추가하기',
                style: ToyVillageTextStyle.button4.copyWith(
                  color: ToyVillageColor.gray100,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
