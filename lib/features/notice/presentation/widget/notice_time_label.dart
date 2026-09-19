import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/utils/time_util.dart';

class NoticeTimeLabel extends StatelessWidget {
  final List<String> teams;
  final DateTime time;
  final bool clockIcon;

  const NoticeTimeLabel({
    super.key,
    required this.teams,
    required this.time,
    this.clockIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    final label = teams.isEmpty ? '전체' : teams.join(', ');

    return Row(
      children: [
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              color: ToyVillageColor.redBackground,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: ToyVillageTextStyle.button5.copyWith(
                  color: ToyVillageColor.red,
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
        if (clockIcon) ...[
          const Icon(
            MdiIcons.clockOutline,
            size: 16,
            color: ToyVillageColor.gray60,
          ),
          const SizedBox(width: 4),
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
