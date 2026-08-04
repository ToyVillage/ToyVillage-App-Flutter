import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

class MenuDropdownItem {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const MenuDropdownItem({
    required this.label,
    required this.onTap,
    this.color = ToyVillageColor.gray100,
  });
}

class MenuDropdown extends StatefulWidget {
  final List<MenuDropdownItem> items;
  final double iconSize;
  final Color iconColor;

  const MenuDropdown({
    super.key,
    required this.items,
    this.iconSize = 24,
    this.iconColor = ToyVillageColor.gray100,
  });

  @override
  State<MenuDropdown> createState() => _MenuDropdownState();
}

class _MenuDropdownState extends State<MenuDropdown> {
  final LayerLink _link = LayerLink();
  OverlayEntry? _entry;

  void _toggle() => _entry != null ? _close() : _open();

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
            child: Container(
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
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < widget.items.length; i++) ...[
                        if (i > 0) const SizedBox(height: 16),
                        _item(widget.items[i]),
                      ],
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

  Widget _item(MenuDropdownItem item) {
    return InkWell(
      onTap: () {
        _close();
        item.onTap();
      },
      child: Center(
        child: Text(
          item.label,
          style: ToyVillageTextStyle.caption3.copyWith(color: item.color),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _toggle,
        child: Icon(
          Icons.more_vert,
          size: widget.iconSize,
          color: widget.iconColor,
        ),
      ),
    );
  }
}
