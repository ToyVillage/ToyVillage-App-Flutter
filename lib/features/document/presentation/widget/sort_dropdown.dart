import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

enum SortOrder {
  latest('최신순'),
  oldest('오래된순');

  final String label;

  const SortOrder(this.label);
}

class SortDropdown extends StatefulWidget {
  final SortOrder value;
  final ValueChanged<SortOrder> onChanged;

  const SortDropdown({super.key, required this.value, required this.onChanged});

  @override
  State<SortDropdown> createState() => _SortDropdownState();
}

class _SortDropdownState extends State<SortDropdown> {
  final LayerLink _link = LayerLink();
  OverlayEntry? _entry;

  bool get _isOpen => _entry != null;

  void _toggle() => _isOpen ? _close() : _open();

  void _open() {
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
            targetAnchor: Alignment.bottomRight,
            followerAnchor: Alignment.topRight,
            offset: const Offset(0, 8),
            child: _menu(),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_entry!);
  }

  void _close() {
    _entry?.remove();
    _entry = null;
  }

  @override
  void dispose() {
    _entry?.remove();
    super.dispose();
  }

  Widget _menu() {
    return Container(
      width: 80,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: ToyVillageColor.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            offset: Offset.zero,
            blurRadius: 10,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < SortOrder.values.length; i++) ...[
                if (i > 0) const SizedBox(height: 10),
                _item(SortOrder.values[i]),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(SortOrder order) {
    final selected = order == widget.value;
    return InkWell(
      onTap: () {
        widget.onChanged(order);
        _close();
      },
      child: Center(
        child: Text(
          order.label,
          style: ToyVillageTextStyle.caption3.copyWith(
            color: selected ? ToyVillageColor.gray100 : ToyVillageColor.gray60,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: GestureDetector(
        onTap: _toggle,
        child: const Icon(
          CupertinoIcons.slider_horizontal_3,
          color: ToyVillageColor.gray60,
        ),
      ),
    );
  }
}
