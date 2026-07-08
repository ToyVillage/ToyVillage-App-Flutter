import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/utils/time_util.dart';
import 'package:toy_village_app/features/notice/data/model/notice_kind.dart';

class NoticeTimeLabel extends StatelessWidget {
  final String kind;
  final DateTime time;
  final bool clockIcon;

  const NoticeTimeLabel({
    super.key,
    required this.kind,
    required this.time,
    this.clockIcon = false
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: ToyVillageColor.redBackground,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Text(
              NoticeKind.labelOf(kind),
              style: ToyVillageTextStyle.button5.copyWith(
                color: ToyVillageColor.red,
              ),
            ),
          ),
        ),
        Spacer(),
        if (clockIcon) ...[
          Icon(MdiIcons.clockOutline, size: 16, color: ToyVillageColor.gray60),
          SizedBox(width: 4),
        ],
        Text(
          timeCheck(time),
          style: ToyVillageTextStyle.caption4.copyWith(
            color: ToyVillageColor.gray60,
          ),
        ),
      ],
    );
  }
}
