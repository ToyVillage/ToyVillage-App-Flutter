import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/utils/time_util.dart';
import 'package:toy_village_app/core/utils/word_util.dart';
import 'package:toy_village_app/core/widgets/app_bar.dart';
import 'package:toy_village_app/core/widgets/attachment_section.dart';
import 'package:toy_village_app/core/widgets/custom_async_value.dart';
import 'package:toy_village_app/core/widgets/section_divider.dart';
import 'package:toy_village_app/core/widgets/tag_chip.dart';
import 'package:toy_village_app/features/task/data/model/task_detail_model.dart';
import 'package:toy_village_app/features/task/presentation/view_model/task_detail_view_model.dart';
import 'package:toy_village_app/features/task/presentation/widget/task_tag_style.dart';

class TaskDetailView extends ConsumerWidget {
  final int id;

  const TaskDetailView({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: ToyVillageAppBar(closeIcon: true),
      body: SafeArea(
        child: CustomAsyncValue(
          value: ref.watch(taskDetailViewModelProvider(id)),
          errorMessage: '업무를 불러오지 못했어요.',
          data: (task) => Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Header(task: task),
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
                                (f) => (fileName: f.fileName, fileKey: f.fileKey),
                              )
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: GestureDetector(
                  onTap: () {
                    context.push('task/report', extra: 1);
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ToyVillageColor.gray100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.5),
                      child: Center(
                        child: Text(
                          '업무 보고서 작성',
                          style: ToyVillageTextStyle.button3.copyWith(
                            color: ToyVillageColor.white,
                          ),
                        ),
                      ),
                    ),
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

class _Header extends StatelessWidget {
  final TaskDetailModel task;

  const _Header({required this.task});

  @override
  Widget build(BuildContext context) {
    final tags = <TagStyle>[taskPriorityTag(task.priority)];
    final statusTag = taskStatusTag(task.status, task.deadline);
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
              Icon(
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
