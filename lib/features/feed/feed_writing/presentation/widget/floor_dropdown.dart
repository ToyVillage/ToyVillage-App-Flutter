import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

const feedFloors = ['4층', '5층'];

class FloorDropdown extends StatefulWidget {
  final List<String> floors;
  final String value;
  final ValueChanged<String> onChanged;

  const FloorDropdown({
    super.key,
    required this.floors,
    required this.value,
    required this.onChanged,
  });

  @override
  State<FloorDropdown> createState() => _FloorDropdownState();
}

class _FloorDropdownState extends State<FloorDropdown> {
  final LayerLink _link = LayerLink();
  OverlayEntry? _entry;

  void _toggle() {
    FocusScope.of(context).unfocus();
    _entry != null ? _close() : _open();
  }

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
              width: 96,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: ToyVillageColor.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final floor in widget.floors)
                      InkWell(
                        onTap: () {
                          widget.onChanged(floor);
                          _close();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              floor,
                              style: ToyVillageTextStyle.caption3.copyWith(
                                color: floor == widget.value
                                    ? ToyVillageColor.gray100
                                    : ToyVillageColor.gray60,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_entry!);
    setState(() {});
  }

  void _close() {
    _entry?.remove();
    _entry = null;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _entry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: Semantics(
        button: true,
        label: '층 선택',
        value: widget.value,
        onTap: _toggle,
        child: InkWell(
          onTap: _toggle,
          borderRadius: BorderRadius.circular(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.value,
                style: ToyVillageTextStyle.subTitle4.copyWith(
                  color: ToyVillageColor.gray100,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                _entry != null
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 20,
                color: ToyVillageColor.gray60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
