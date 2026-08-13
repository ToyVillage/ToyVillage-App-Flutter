import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/utils/time_util.dart';
import 'package:toy_village_app/core/utils/word_util.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/button/toy_village_button.dart';
import 'package:toy_village_app/core/widgets/file/attachment_section.dart';
import 'package:toy_village_app/core/widgets/custom_async_value.dart';
import 'package:toy_village_app/core/widgets/section_divider.dart';
import 'package:toy_village_app/core/widgets/tag_chip.dart';
import 'package:toy_village_app/features/task/data/model/task_detail_model.dart';
import 'package:toy_village_app/features/task/data/model/task_status.dart';
import 'package:toy_village_app/features/task/presentation/view_model/task_detail_view_model.dart';
import 'package:toy_village_app/features/task/presentation/view_model/task_report_view_model.dart';
import 'package:toy_village_app/features/task/presentation/widget/task_tag_style.dart';

class TaskDetailView extends ConsumerWidget {
  final int id;

  const TaskDetailView({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasReport = ref.watch(taskReportProvider(id)).value != null;

    return Scaffold(
      appBar: const ToyVillageAppBar(closeIcon: true),
      body: SafeArea(
        child: CustomAsyncValue(
          value: ref.watch(taskDetailViewModelProvider(id)),
          errorMessage: '업무를 불러오지 못했어요.',
          data: (task) {
            final status = hasReport && task.status == TaskStatus.notSubmitted
                ? TaskStatus.submitted
                : task.status;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Header(task: task, status: status),
                        const SectionDivider(),
                        Text(
                          breakByWord(task.content),
                          style: ToyVillageTextStyle.body5,
                        ),
                        if (task.files.isNotEmpty) ...[
                          const SectionDivider(),
                          AttachmentSection(
                            files: task.files
                                .map(
                                  (f) =>
                                      (fileName: f.fileName, fileKey: f.fileKey),
                                )
                                .toList(),
                          ),
                        ],
                        if (status == TaskStatus.rejected &&
                            task.rejectionReason != null) ...[
                          const SectionDivider(),
                          Text('반려 사유', style: ToyVillageTextStyle.caption4.copyWith(color: ToyVillageColor.gray60)),
                          const SizedBox(height: 12),
                          Text(
                            breakByWord(task.rejectionReason!),
                            style: ToyVillageTextStyle.body5,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: ToyVillageButton(
                    label: (hasReport || status != TaskStatus.notSubmitted)
                        ? '조회하기'
                        : '업무 보고서 작성하기',
                    onTap: () async {
                      final route =
                          (hasReport || status != TaskStatus.notSubmitted)
                          ? '/task/report/detail'
                          : '/task/report/create';
                      await context.push(route, extra: task.id);
                      if (!context.mounted) return;
                      ref.invalidate(taskReportProvider(id));
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final TaskDetailModel task;
  final TaskStatus status;

  const _Header({required this.task, required this.status});

  @override
  Widget build(BuildContext context) {
    final tags = <TagStyle>[taskPriorityTag(task.priority)];
    final statusTag = taskStatusTag(status, task.deadline);
    if (statusTag != null) tags.add(statusTag);
    final deadlineTag = taskDeadlineTag(task.deadline);
    if (deadlineTag != null) tags.add(deadlineTag);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(task.title, style: ToyVillageTextStyle.heading2),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              for (var i = 0; i < tags.length; i++) ...[
                if (i > 0) const SizedBox(width: 6),
                TagChip(
                  label: tags[i].label,
                  textColor: tags[i].text,
                  backgroundColor: tags[i].background,
                ),
              ],
              const Spacer(),
              const Icon(
                MdiIcons.clockOutline,
                size: 16,
                color: ToyVillageColor.gray60,
              ),
              const SizedBox(width: 4),
              Text(
                timeCheck(task.createdAt),
                style: ToyVillageTextStyle.caption4.copyWith(
                  color: ToyVillageColor.gray60,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
