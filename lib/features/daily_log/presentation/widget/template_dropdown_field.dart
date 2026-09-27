import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/widgets/text/label.dart';

class TemplateDropdownField extends StatefulWidget {
  final String label;
  final String hintText;
  final int? selectedIndex;
  final List<String> items;
  final ValueChanged<int> onSelected;

  const TemplateDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.onSelected,
    this.hintText = '',
    this.selectedIndex,
  });

  @override
  State<TemplateDropdownField> createState() => _TemplateDropdownFieldState();
}

class _TemplateDropdownFieldState extends State<TemplateDropdownField> {
  static const _itemHeight = 52.0;

  final GlobalKey _menuKey = GlobalKey();
  bool _open = false;

  void _toggle() {
    FocusScope.of(context).unfocus();
    setState(() => _open = !_open);
    if (!_open) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _menuKey.currentContext;
      if (context == null) return;
      Scrollable.ensureVisible(
        context,
        alignment: 0.5,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  void _select(int index) {
    widget.onSelected(index);
    setState(() => _open = false);
  }

  Widget _item(int index, String item) {
    return InkWell(
      onTap: () => _select(index),
      child: Container(
        height: _itemHeight,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(item, style: ToyVillageTextStyle.body5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final index = widget.selectedIndex;
    final hasValue = index != null && index >= 0 && index < widget.items.length;
    final valueText = hasValue ? widget.items[index] : widget.hintText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ToyVillageLabel(label: widget.label),
        const SizedBox(height: 8),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _toggle,
          child: Container(
            decoration: BoxDecoration(
              color: ToyVillageColor.white,
              borderRadius: _open
                  ? const BorderRadius.vertical(top: Radius.circular(8))
                  : BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      valueText,
                      style: hasValue
                          ? ToyVillageTextStyle.body5
                          : ToyVillageTextStyle.caption4.copyWith(
                              color: ToyVillageColor.gray60,
                            ),
                    ),
                  ),
                  Icon(
                    _open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 20,
                    color: ToyVillageColor.gray60,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_open)
          Container(
            key: _menuKey,
            clipBehavior: Clip.antiAlias,
            constraints: const BoxConstraints(maxHeight: _itemHeight * 3.5),
            decoration: const BoxDecoration(
              color: ToyVillageColor.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < widget.items.length; i++)
                    _item(i, widget.items[i]),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
