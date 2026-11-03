import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/utils/time_util.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/custom_async_value.dart';
import 'package:toy_village_app/core/widgets/file/attachment_section.dart';
import 'package:toy_village_app/core/widgets/section_divider.dart';
import 'package:toy_village_app/core/widgets/tag_chip.dart';
import 'package:toy_village_app/features/task/data/model/task_detail_model.dart';
import 'package:toy_village_app/features/task/presentation/widget/task_tag_style.dart';
import 'package:toy_village_app/features/task_assignment/presentation/view_model/assignment_detail_view_model.dart';
import 'package:toy_village_app/features/task_assignment/presentation/widget/assignment_tag_style.dart';

class AssignmentDetailView extends ConsumerWidget {
  final int id;

  const AssignmentDetailView({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const ToyVillageAppBar(hasIcon: true),
      body: SafeArea(
        child: CustomAsyncValue(
          value: ref.watch(assignmentDetailViewModelProvider(id)),
          onRetry: () =>
              ref.invalidate(assignmentDetailViewModelProvider(id)),
          data: (detail) => _content(context, ref, detail),
        ),
      ),
    );
  }

  Widget _content(BuildContext context, WidgetRef ref, TaskDetailModel detail) {
    final status = assignmentTaskStatusTag(detail.status);
    final priority = taskPriorityTag(detail.priority);
    final files = [
      for (final file in detail.files)
        (fileName: file.fileName, fileKey: file.fileKey),
    ];
    final reports = detail.reports;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(detail.title, style: ToyVillageTextStyle.heading2),
          const SizedBox(height: 12),
          Row(
            children: [
              TagChip(
                label: status.label,
                textColor: status.text,
                backgroundColor: status.background,
              ),
              const SizedBox(width: 6),
              TagChip(
                label: priority.label,
                textColor: priority.text,
                backgroundColor: priority.background,
              ),
              const SizedBox(width: 6),
              TagChip(
                label: assignmentFinishLabel(detail.finishDate),
                textColor: ToyVillageColor.gray70,
                backgroundColor: ToyVillageColor.gray20,
              ),
              const Spacer(),
              const Icon(
                Symbols.schedule_rounded,
                size: 16,
                color: ToyVillageColor.gray60,
              ),
              const SizedBox(width: 4),
              Text(
                timeCheck(detail.createdAt),
                style: ToyVillageTextStyle.caption4.copyWith(
                  color: ToyVillageColor.gray60,
                ),
              ),
            ],
          ),
          const SectionDivider(),
          Text(detail.content, style: ToyVillageTextStyle.body5),
          if (files.isNotEmpty) ...[
            const SectionDivider(),
            AttachmentSection(files: files),
          ],
          const SectionDivider(),
          Text('업무보고', style: ToyVillageTextStyle.subTitle4),
          const SizedBox(height: 12),
          if (reports.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: ToyVillageColor.white,
                borderRadius: BorderRadius.circular(8),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  for (var i = 0; i < reports.length; i++) ...[
                    if (i > 0)
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: ToyVillageColor.gray20,
                      ),
                    _reportRow(context, ref, reports[i]),
                  ],
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  '아직 등록된 업무보고가 없어요',
                  style: ToyVillageTextStyle.body5.copyWith(
                    color: ToyVillageColor.gray60,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _reportRow(
    BuildContext context,
    WidgetRef ref,
    TaskReportSummary report,
  ) {
    final tag = assignmentReportStatusTag(report.status);
    final workReportId = report.workReportId;
    final tappable = workReportId != null;

    return InkWell(
      onTap: tappable
          ? () async {
              await context.push(
                '/task-assignment/report',
                extra: workReportId,
              );
              ref.invalidate(assignmentDetailViewModelProvider(id));
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(child: Text(report.name, style: ToyVillageTextStyle.body5)),
            TagChip(
              label: tag.label,
              textColor: tag.text,
              backgroundColor: tag.background,
              borderColor: tag.border,
            ),
            if (tappable) ...[
              const SizedBox(width: 8),
              const Icon(
                Symbols.chevron_right_rounded,
                size: 18,
                color: ToyVillageColor.gray60,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
