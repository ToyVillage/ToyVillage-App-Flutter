import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/features/task/data/model/task_filter.dart';

class TaskFilterMenu extends StatelessWidget {
  final TaskFilter selected;
  final ValueChanged<TaskFilter> onSelected;

  const TaskFilterMenu({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<TaskFilter>(
      initialValue: selected,
      onSelected: onSelected,
      offset: const Offset(0, 32),
      color: ToyVillageColor.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      icon: const Icon(
        Icons.more_vert,
        color: ToyVillageColor.gray100,
        size: 24,
      ),
      itemBuilder: (context) => [
        for (final filter in TaskFilter.values)
          PopupMenuItem<TaskFilter>(
            value: filter,
            child: Center(
              child: Text(
                filter.label,
                style: ToyVillageTextStyle.caption3.copyWith(
                  color: filter == selected
                      ? ToyVillageColor.gray100
                      : ToyVillageColor.gray70,
                  fontWeight:
                      filter == selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
