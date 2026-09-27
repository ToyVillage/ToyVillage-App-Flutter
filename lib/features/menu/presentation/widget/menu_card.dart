import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

class MenuCard extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;
  final Color? titleColor;

  const MenuCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: ToyVillageColor.white,
            borderRadius: BorderRadius.circular(8),
          ),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(icon),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: titleColor == null
                      ? ToyVillageTextStyle.body4
                      : ToyVillageTextStyle.body4.copyWith(color: titleColor),
                ),
                const Spacer(),
                Transform.flip(
                  flipX: true,
                  child: const Icon(
                    Symbols.chevron_left_rounded,
                    size: 28,
                    color: ToyVillageColor.gray100,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
