import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/file/attachment_section.dart';
import 'package:toy_village_app/core/widgets/section_divider.dart';
import 'package:toy_village_app/core/widgets/tag_chip.dart';
import 'package:toy_village_app/features/task/presentation/widget/task_tag_style.dart';
import 'package:toy_village_app/features/task_assignment/data/model/assignment.dart';
import 'package:toy_village_app/features/task_assignment/presentation/widget/assignment_tag_style.dart';

class AssignmentDetailView extends StatelessWidget {
  final int id;

  const AssignmentDetailView({super.key, required this.id});

  static const _files = <({String fileName, String fileKey})>[
    (fileName: '당일 지침.pdf', fileKey: 'sample-pdf'),
    (fileName: '휴관안내.jpg', fileKey: 'sample-jpg'),
    (fileName: '휴관안내.png', fileKey: 'sample-png'),
  ];

  static const _reporters = ['이승현 사원', '이승현 사원', '이승현 사원'];

  Assignment get _assignment => sampleAssignments.firstWhere(
    (a) => a.id == id,
    orElse: () => sampleAssignments.first,
  );

  @override
  Widget build(BuildContext context) {
    final assignment = _assignment;
    final status = assignmentStatusTag(assignment.status);
    final priority = taskPriorityTag(assignment.priority);

    return Scaffold(
      appBar: const ToyVillageAppBar(hasIcon: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(assignment.title, style: ToyVillageTextStyle.heading2),
              const SizedBox(height: 16),
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
                    label: assignmentDueLabel(assignment.dueDate),
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
                    '3시간 전',
                    style: ToyVillageTextStyle.caption4.copyWith(
                      color: ToyVillageColor.gray60,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                '배고픈 우현이에게 복숭아 500g을 주세요',
                style: ToyVillageTextStyle.body5,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: SectionDivider(),
              ),
              const AttachmentSection(files: _files),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: SectionDivider(),
              ),
              Text('업무보고', style: ToyVillageTextStyle.subTitle4),
              const SizedBox(height: 8),
              for (final reporter in _reporters) _reportRow(context, reporter),
            ],
          ),
        ),
      ),
    );
  }

  Widget _reportRow(BuildContext context, String name) {
    return InkWell(
      onTap: () => context.push('/task-assignment/report'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Expanded(child: Text(name, style: ToyVillageTextStyle.body5)),
            const Icon(
              Symbols.chevron_right_rounded,
              size: 18,
              color: ToyVillageColor.gray60,
            ),
          ],
        ),
      ),
    );
  }
}
