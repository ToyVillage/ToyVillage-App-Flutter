import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/widgets/dropdown/menu_dropdown.dart';
import 'package:toy_village_app/core/widgets/tag_chip.dart';
import 'package:toy_village_app/features/task/data/model/task_model.dart';
import 'package:toy_village_app/features/task/presentation/widget/task_tag_style.dart';
import 'package:toy_village_app/features/task_assignment/presentation/widget/assignment_tag_style.dart';

class AssignmentCard extends StatelessWidget {
  final TaskModel assignment;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  const AssignmentCard({
    super.key,
    required this.assignment,
    required this.onTap,
    required this.onDelete,
    required this.onUpdate
  });

  @override
  Widget build(BuildContext context) {
    final status = assignmentTaskStatusTag(assignment.status);
    final priority = taskPriorityTag(assignment.priority);
    final assigneeNames = assignment.assignees.map((a) => a.name).join(', ');

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ToyVillageColor.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        assignment.title,
                        style: ToyVillageTextStyle.button2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    MenuDropdown(
                      iconSize: 20,
                      items: [
                        MenuDropdownItem(
                          label: '수정',
                          color: ToyVillageColor.gray100,
                          onTap: onUpdate,
                        ),
                        MenuDropdownItem(
                          label: '삭제',
                          color: ToyVillageColor.red,
                          onTap: onDelete,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  assigneeNames.isEmpty ? '담당자 없음' : assigneeNames,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ToyVillageTextStyle.caption3.copyWith(
                    color: ToyVillageColor.gray60,
                  ),
                ),
                const SizedBox(height: 20),
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
                      label: assignmentFinishLabel(assignment.finishDate),
                      textColor: ToyVillageColor.gray90,
                      backgroundColor: ToyVillageColor.gray20,
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
