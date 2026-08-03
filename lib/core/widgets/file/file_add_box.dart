import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/svg_assets.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

class FileAddBox extends StatelessWidget {
  final VoidCallback onTap;

  const FileAddBox({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        options: const RoundedRectDottedBorderOptions(
          radius: Radius.circular(8),
          padding: EdgeInsets.symmetric(horizontal: 1),
          dashPattern: [6, 2],
          color: ToyVillageColor.gray60,
          strokeWidth: 2,
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: ToyVillageColor.gray20,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              children: [
                SvgPicture.asset(SvgAssets.upload),
                const SizedBox(height: 8),
                Text('클릭하여 파일 업로드', style: ToyVillageTextStyle.caption3.copyWith(color: ToyVillageColor.gray60),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
