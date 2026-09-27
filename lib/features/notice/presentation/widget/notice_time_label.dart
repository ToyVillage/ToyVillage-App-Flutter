import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/utils/time_util.dart';

const _teamPalette = <({Color text, Color background})>[
  (text: ToyVillageColor.red, background: ToyVillageColor.redBackground),
  (text: ToyVillageColor.yellow, background: ToyVillageColor.yellowBackground),
  (text: ToyVillageColor.green, background: ToyVillageColor.greenBackground),
  (text: ToyVillageColor.blue, background: ToyVillageColor.blueBackground),
];

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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              if (teams.isEmpty)
                const _TeamTag(
                  label: '전체',
                  text: ToyVillageColor.gray70,
                  background: ToyVillageColor.gray20,
                )
              else
                for (final team in teams)
                  _TeamTag(
                    label: team,
                    text: _colorOf(team).text,
                    background: _colorOf(team).background,
                  ),
            ],
          ),
        ),
        const SizedBox(width: 8),
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

  ({Color text, Color background}) _colorOf(String team) =>
      _teamPalette[team.hashCode.abs() % _teamPalette.length];
}

class _TeamTag extends StatelessWidget {
  final String label;
  final Color text;
  final Color background;

  const _TeamTag({
    required this.label,
    required this.text,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Text(
          label,
          style: ToyVillageTextStyle.button5.copyWith(color: text),
        ),
      ),
    );
  }
}
