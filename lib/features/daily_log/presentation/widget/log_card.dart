import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/utils/time_util.dart';
import 'package:toy_village_app/core/widgets/dialog/delete_confirm_dialog.dart';
import 'package:toy_village_app/core/widgets/dropdown/menu_dropdown.dart';
import 'package:toy_village_app/features/daily_log/data/model/daily_log.dart';
import 'package:toy_village_app/features/daily_log/presentation/view_model/daily_log_view_model.dart';

class LogCard extends ConsumerWidget {
  final DailyLog log;

  const LogCard({super.key, required this.log});

  void _edit(BuildContext context) =>
      context.push('/dailyLog/create', extra: log);

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDeleteConfirmDialog(context);
    if (!confirmed) return;
    ref.read(dailyLogViewModelProvider.notifier).remove(log.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${log.createdAt.month}월 ${log.createdAt.day}일 업무일지',
                    style: ToyVillageTextStyle.heading3,
                  ),
                  const Spacer(),
                  MenuDropdown(
                    iconSize: 20,
                    items: [
                      MenuDropdownItem(
                        label: '수정',
                        onTap: () => _edit(context),
                      ),
                      MenuDropdownItem(
                        label: '삭제',
                        color: ToyVillageColor.red,
                        onTap: () => _delete(context, ref),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8,),
              Row(
                children: [
                  Text(
                    log.templateName,
                    style: ToyVillageTextStyle.caption4.copyWith(
                      color: ToyVillageColor.gray60,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    timeCheck(log.createdAt),
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
    );
  }
}
