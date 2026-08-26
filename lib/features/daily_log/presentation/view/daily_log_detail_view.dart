import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/dialog/delete_confirm_dialog.dart';
import 'package:toy_village_app/core/widgets/dropdown/menu_dropdown.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/core/widgets/text_field/readonly_field.dart';
import 'package:toy_village_app/features/daily_log/presentation/view_model/daily_log_view_model.dart';

class DailyLogDetailView extends ConsumerWidget {
  final int id;

  const DailyLogDetailView({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final log = ref.watch(dailyLogViewModelProvider.select((logs) {
      for (final e in logs) {
        if (e.id == id) return e;
      }
      return null;
    }));

    if (log == null) {
      return const Scaffold(
        appBar: ToyVillageAppBar(hasIcon: true),
        body: SafeArea(child: SizedBox.shrink()),
      );
    }

    final title = '${log.createdAt.month}월 ${log.createdAt.day}일 업무일지';

    return Scaffold(
      appBar: const ToyVillageAppBar(hasIcon: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 28),
                child: Row(
                  children: [
                    ToyVillageTitle(title: title),
                    const Spacer(),
                    MenuDropdown(
                      items: [
                        MenuDropdownItem(
                          label: '수정',
                          onTap: () =>
                              context.push('/daily-log/create', extra: log),
                        ),
                        MenuDropdownItem(
                          label: '삭제',
                          color: ToyVillageColor.red,
                          onTap: () async {
                            final container = ProviderScope.containerOf(
                              context,
                              listen: false,
                            );
                            final confirmed = await showDeleteConfirmDialog(
                              context,
                            );
                            if (!confirmed) return;
                            container
                                .read(dailyLogViewModelProvider.notifier)
                                .remove(id);
                            if (!context.mounted) return;
                            context.go('/daily-log');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ToyVillageReadonlyField(
                        label: '양식',
                        value: log.templateName,
                      ),
                      const SizedBox(height: 20),
                      ToyVillageReadonlyField(
                        label: '내용',
                        value: log.content,
                        minLines: 14,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
