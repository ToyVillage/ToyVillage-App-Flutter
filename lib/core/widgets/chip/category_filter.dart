import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

const animalCategories = <String>['포유류', '어류', '파충류', '조류'];

class CategoryFilter extends StatelessWidget {
  final List<String> items;
  final String? selected;
  final ValueChanged<String> onSelected;
  final double spacing;

  const CategoryFilter({
    super.key,
    this.items = animalCategories,
    required this.selected,
    required this.onSelected,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: [
        for (final item in items)
          _CategoryChip(
            label: item,
            selected: item == selected,
            onTap: () => onSelected(item),
          ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? ToyVillageColor.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(27),
          border: selected
              ? null
              : Border.all(color: ToyVillageColor.gray40),
        ),
        child: Text(
          label,
          style: ToyVillageTextStyle.button5.copyWith(
            color: selected ? ToyVillageColor.white : ToyVillageColor.gray100,
          ),
        ),
      ),
    );
  }
}
