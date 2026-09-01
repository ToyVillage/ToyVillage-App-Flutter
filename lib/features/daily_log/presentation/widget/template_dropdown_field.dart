import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/widgets/text/label.dart';

class TemplateDropdownField extends StatefulWidget {
  final String label;
  final String hintText;
  final String? value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const TemplateDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.hintText = '',
    this.value,
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

  void _select(String item) {
    widget.onChanged(item);
    setState(() => _open = false);
  }

  Widget _item(String item) {
    return InkWell(
      onTap: () => _select(item),
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
    final hasValue = widget.value != null && widget.value!.isNotEmpty;

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
                      hasValue ? widget.value! : widget.hintText,
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
                children: [for (final item in widget.items) _item(item)],
              ),
            ),
          ),
      ],
    );
  }
}
