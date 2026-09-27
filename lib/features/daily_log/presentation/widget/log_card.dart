import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/utils/time_util.dart';
import 'package:toy_village_app/features/daily_log/data/model/daily_log_summary.dart';

class LogCard extends StatelessWidget {
  final DailyLogSummary log;

  const LogCard({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: () => context.push('/daily-log/detail', extra: log.workLogId),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ToyVillageColor.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${log.writeAt.month}월 ${log.writeAt.day}일 업무일지',
                  style: ToyVillageTextStyle.heading3,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      log.templateTitle,
                      style: ToyVillageTextStyle.caption4.copyWith(
                        color: ToyVillageColor.gray60,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      timeCheck(log.writeAt),
                      style: ToyVillageTextStyle.caption4.copyWith(
                        color: ToyVillageColor.gray60,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
