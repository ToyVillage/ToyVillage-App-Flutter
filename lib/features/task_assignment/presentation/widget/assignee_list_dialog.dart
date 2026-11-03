import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/features/task/data/model/assignee.dart';

Future<void> showAssigneeListDialog(
  BuildContext context,
  List<Assignee> assignees,
) {
  return showDialog<void>(
    context: context,
    builder: (_) => _AssigneeListDialog(assignees: assignees),
  );
}

class _AssigneeListDialog extends StatelessWidget {
  final List<Assignee> assignees;

  const _AssigneeListDialog({required this.assignees});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ToyVillageColor.gray10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text('업무 할당 목록', style: ToyVillageTextStyle.subTitle3),
            ),
            Flexible(
              child: Scrollbar(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: assignees.length,
                  itemBuilder: (context, index) => _row(assignees[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(Assignee assignee) {
    final name = assignee.name;
    final label = [
      name,
      assignee.position,
    ].where((part) => part.isNotEmpty).join(' ');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: ToyVillageColor.gray20,
              shape: BoxShape.circle,
            ),
            child: Text(
              name.isEmpty ? '' : name.characters.first,
              style: ToyVillageTextStyle.button4.copyWith(
                color: ToyVillageColor.gray70,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: ToyVillageTextStyle.body5),
          ),
        ],
      ),
    );
  }
}
