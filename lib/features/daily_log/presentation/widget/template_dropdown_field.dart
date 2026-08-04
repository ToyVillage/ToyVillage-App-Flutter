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
  final LayerLink _link = LayerLink();
  OverlayEntry? _entry;
  bool _open = false;

  void _toggle() => _entry != null ? _close() : _openMenu();

  void _openMenu() {
    final width = context.size?.width ?? 0;
    _entry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _close,
            ),
          ),
          CompositedTransformFollower(
            link: _link,
            showWhenUnlinked: false,
            targetAnchor: Alignment.bottomLeft,
            followerAnchor: Alignment.topLeft,
            child: SizedBox(
              width: width,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    color: ToyVillageColor.white,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(8),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final item in widget.items) _item(item),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_entry!);
    setState(() => _open = true);
  }

  void _close() {
    _entry?.remove();
    _entry = null;
    if (mounted) setState(() => _open = false);
  }

  @override
  void dispose() {
    _entry?.remove();
    super.dispose();
  }

  Widget _item(String item) {
    return InkWell(
      onTap: () {
        widget.onChanged(item);
        _close();
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(
              item,
              style: ToyVillageTextStyle.body5
            ),
          ],
        ),
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
        CompositedTransformTarget(
          link: _link,
          child: GestureDetector(
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
                        style: hasValue ? ToyVillageTextStyle.body5 : ToyVillageTextStyle.caption4.copyWith(
                          color: hasValue ? ToyVillageColor.gray100 : ToyVillageColor.gray60
                        ),
                      ),
                    ),
                    Icon(
                      _open
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 20,
                      color: ToyVillageColor.gray60,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
