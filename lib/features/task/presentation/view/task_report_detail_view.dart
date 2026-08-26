import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/dialog/delete_confirm_dialog.dart';
import 'package:toy_village_app/core/widgets/dropdown/menu_dropdown.dart';
import 'package:toy_village_app/core/widgets/empty_state.dart';
import 'package:toy_village_app/core/widgets/file/attachment_section.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/core/widgets/text_field/readonly_field.dart';
import 'package:toy_village_app/features/task/data/model/task_status.dart';
import 'package:toy_village_app/features/task/data/repository/task_report_draft_repository.dart';
import 'package:toy_village_app/features/task/presentation/view_model/task_detail_view_model.dart';
import 'package:toy_village_app/features/task/presentation/view_model/task_report_view_model.dart';

class TaskReportDetailView extends ConsumerWidget {
  final int id;

  const TaskReportDetailView({super.key, required this.id});

  Future<void> _edit(BuildContext context, WidgetRef ref) async {
    await context.push('/task/report/edit', extra: id);
    if (!context.mounted) return;
    ref.invalidate(taskReportProvider(id));
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final container = ProviderScope.containerOf(context, listen: false);
    final repo = ref.read(taskReportDraftRepositoryProvider);
    final confirmed = await showDeleteConfirmDialog(context);
    if (!confirmed) return;
    await repo.clearReport(id);
    await repo.clear(id);
    container.invalidate(taskReportProvider(id));
    if (!context.mounted) return;
    context.go('/task');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(taskReportProvider(id)).value;
    final status = ref.watch(taskDetailViewModelProvider(id)).value?.status;
    final canEdit = status != null && status != TaskStatus.completed;

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
                    const ToyVillageTitle(title: '업무 보고서'),
                    if (canEdit) ...[
                      const Spacer(),
                      MenuDropdown(
                        items: [
                          MenuDropdownItem(
                            label: '수정',
                            onTap: () => _edit(context, ref),
                          ),
                          MenuDropdownItem(
                            label: '삭제',
                            color: ToyVillageColor.red,
                            onTap: () => _delete(context, ref),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: report == null
                    ? const EmptyState(message: '제출된 보고서가 없습니다')
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ToyVillageReadonlyField(
                              label: '내용',
                              value: report.content,
                              minLines: 7,
                            ),
                            if (report.note.isNotEmpty) ...[
                              const SizedBox(height: 20),
                              ToyVillageReadonlyField(
                                label: '특이사항',
                                value: report.note,
                                minLines: 4,
                              ),
                            ],
                            if (report.files.isNotEmpty) ...[
                              const SizedBox(height: 20),
                              AttachmentSection(
                                files: report.files
                                    .map(
                                      (f) => (
                                        fileName: f.fileName,
                                        fileKey: f.fileKey,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
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
