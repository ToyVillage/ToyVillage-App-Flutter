import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/utils/time_util.dart';

class NoticeTitle extends StatelessWidget {
  final String title;
  final String kind;
  final DateTime time;

  const NoticeTitle({
    super.key,
    required this.title,
    required this.kind,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: ToyVillageTextStyle.heading2,),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: ToyVillageColor.redBackground,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Text(
                      kind,
                      style: ToyVillageTextStyle.button5.copyWith(
                        color: ToyVillageColor.red,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Icon(MdiIcons.clockOutline, size: 16, color: ToyVillageColor.gray60),
                SizedBox(width: 4),
                Text(timeCheck(time), style: ToyVillageTextStyle.caption4.copyWith(color: ToyVillageColor.gray60),)
              ],
            ),
          )
        ]
    );
  }
}
