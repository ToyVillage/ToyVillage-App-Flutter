import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

const feedAmountUnits = ['g / ml', 'kg / L'];

class FeedAmountField extends StatefulWidget {
  final TextEditingController controller;
  final String unit;
  final ValueChanged<String> onUnitChanged;

  const FeedAmountField({
    super.key,
    required this.controller,
    required this.unit,
    required this.onUnitChanged,
  });

  @override
  State<FeedAmountField> createState() => _FeedAmountFieldState();
}

class _FeedAmountFieldState extends State<FeedAmountField> {
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
            offset: const Offset(0, -8),
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
                      for (var i = 0; i < feedAmountUnits.length; i++) ...[
                        if (i > 0) const SizedBox(height: 16),
                        InkWell(
                          onTap: () {
                            widget.onUnitChanged(feedAmountUnits[i]);
                            _close();
                          },
                          child: Center(
                            child: Text(
                              feedAmountUnits[i],
                              style: ToyVillageTextStyle.caption3,
                            ),
                          ),
                        ),
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
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: ToyVillageColor.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  scrollPadding: const EdgeInsets.only(bottom: 100),
                  style: ToyVillageTextStyle.body5.copyWith(
                    color: ToyVillageColor.gray100,
                  ),
                  cursorColor: ToyVillageColor.gray100,
                  decoration: InputDecoration(
                    isDense: true,
                    isCollapsed: true,
                    hintText: '먹이 급여량 입력',
                    hintStyle: ToyVillageTextStyle.body5.copyWith(
                      color: ToyVillageColor.gray60,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _toggle,
                child: Row(
                  children: [
                    Text(
                      widget.unit,
                      style: ToyVillageTextStyle.body5.copyWith(
                        color: ToyVillageColor.gray60,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: ToyVillageColor.gray60,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
