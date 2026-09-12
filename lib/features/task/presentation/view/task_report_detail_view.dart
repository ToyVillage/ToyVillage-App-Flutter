import 'package:flutter/material.dart';
import 'package:toy_village_app/features/task/presentation/widget/work_report_detail_skeleton.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/custom_async_value.dart';
import 'package:toy_village_app/core/widgets/dialog/delete_confirm_dialog.dart';
import 'package:toy_village_app/core/widgets/dropdown/menu_dropdown.dart';
import 'package:toy_village_app/core/widgets/empty_state.dart';
import 'package:toy_village_app/core/widgets/file/attachment_section.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/core/widgets/text_field/readonly_field.dart';
import 'package:toy_village_app/core/widgets/toast/top_toast.dart';
import 'package:toy_village_app/features/task/data/model/task_status.dart';
import 'package:toy_village_app/features/task/data/model/work_report_model.dart';
import 'package:toy_village_app/features/task/data/repository/work_report_repository.dart';
import 'package:toy_village_app/features/task/presentation/view_model/work_report_view_model.dart';

class TaskReportDetailView extends ConsumerWidget {
  final int id;

  const TaskReportDetailView({super.key, required this.id});

  Future<void> _edit(BuildContext context, WidgetRef ref) async {
    await context.push('/task/report/edit', extra: id);
    if (!context.mounted) return;
    ref.invalidate(workReportProvider(id));
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    int workReportId,
  ) async {
    final overlay = Overlay.of(context, rootOverlay: true);
    final confirmed = await showDeleteConfirmDialog(context);
    if (!confirmed) return;
    try {
      await ref.read(workReportRepositoryProvider).deleteReport(workReportId);
      ref.invalidate(workReportProvider(id));
      if (!context.mounted) return;
      context.go('/task');
    } catch (_) {
      if (!context.mounted) return;
      showTopToast(overlay, '삭제에 실패했어요. 다시 시도해주세요.', isError: true);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const ToyVillageAppBar(hasIcon: true),
      body: SafeArea(
        child: CustomAsyncValue(
          value: ref.watch(workReportProvider(id)),
          loading: const WorkReportDetailSkeleton(),
          onRetry: () => ref.invalidate(workReportProvider(id)),
          data: (report) => _content(context, ref, report),
        ),
      ),
    );
  }

  Widget _content(
    BuildContext context,
    WidgetRef ref,
    WorkReportModel? report,
  ) {
    final canEdit = report != null && report.status != ReportStatus.approved;

    return Padding(
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
                        onTap: () => _delete(context, ref, report.id),
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
                        if ((report.note ?? '').isNotEmpty) ...[
                          const SizedBox(height: 20),
                          ToyVillageReadonlyField(
                            label: '특이사항',
                            value: report.note!,
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
    );
  }
}
