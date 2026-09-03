import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/svg_assets.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

typedef FeedTime = ({int hour, int minute, bool isPm});

class FeedTimeField extends StatefulWidget {
  final String hintText;
  final FeedTime? value;
  final ValueChanged<FeedTime> onChanged;

  const FeedTimeField({
    super.key,
    required this.hintText,
    this.value,
    required this.onChanged,
  });

  @override
  State<FeedTimeField> createState() => _FeedTimeFieldState();
}

class _FeedTimeFieldState extends State<FeedTimeField> {
  final LayerLink _link = LayerLink();
  final GlobalKey _fieldKey = GlobalKey();
  OverlayEntry? _entry;
  FixedExtentScrollController? _hourController;
  FixedExtentScrollController? _minuteController;
  FeedTime? _selected;

  bool get _open => _entry != null;

  @override
  void initState() {
    super.initState();
    _selected = widget.value;
  }

  FeedTime get _now {
    final now = TimeOfDay.now();
    final isPm = now.hour >= 12;
    var hour = now.hour % 12;
    if (hour == 0) hour = 12;
    return (hour: hour, minute: now.minute, isPm: isPm);
  }

  FeedTime get _current => _selected ?? _now;

  void _toggle() {
    FocusScope.of(context).unfocus();
    if (_open) {
      _close();
      return;
    }
    final time = _selected ?? _now;
    if (_selected == null) {
      setState(() => _selected = time);
      widget.onChanged(time);
    }
    _openMenu(time);
  }

  void _update({int? hour, int? minute, bool? isPm}) {
    final updated = (
      hour: hour ?? _current.hour,
      minute: minute ?? _current.minute,
      isPm: isPm ?? _current.isPm,
    );
    setState(() => _selected = updated);
    widget.onChanged(updated);
    _entry?.markNeedsBuild();
  }

  void _openMenu(FeedTime time) {
    final box = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final width = box.size.width;
    _hourController = FixedExtentScrollController(initialItem: time.hour - 1);
    _minuteController = FixedExtentScrollController(initialItem: time.minute);

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
                child: ClipRect(
                  clipper: _BottomSideShadowClipper(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ToyVillageColor.white,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(8),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ToyVillageColor.gray100.withValues(
                            alpha: 0.12,
                          ),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: SizedBox(height: 180, child: _picker()),
                    ),
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

  Widget _picker() {
    return Row(
      children: [
        Expanded(
          child: _Wheel(
            controller: _hourController!,
            count: 12,
            labelBuilder: (index) => '${index + 1}',
            onChanged: (index) => _update(hour: index + 1),
          ),
        ),
        Expanded(
          child: _Wheel(
            controller: _minuteController!,
            count: 60,
            labelBuilder: (index) => index.toString().padLeft(2, '0'),
            onChanged: (index) => _update(minute: index),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _MeridiemButton(
              label: 'AM',
              selected: !_current.isPm,
              onTap: () => _update(isPm: false),
            ),
            const SizedBox(height: 8),
            _MeridiemButton(
              label: 'PM',
              selected: _current.isPm,
              onTap: () => _update(isPm: true),
            ),
          ],
        ),
      ],
    );
  }

  void _close() {
    _entry?.remove();
    _entry = null;
    _hourController?.dispose();
    _minuteController?.dispose();
    _hourController = null;
    _minuteController = null;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _entry?.remove();
    _hourController?.dispose();
    _minuteController?.dispose();
    super.dispose();
  }

  String _format(FeedTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour : $minute ${time.isPm ? 'PM' : 'AM'}';
  }

  @override
  Widget build(BuildContext context) {
    final value = _selected;
    final hasValue = value != null;

    return CompositedTransformTarget(
      link: _link,
      child: Container(
        key: _fieldKey,
        decoration: BoxDecoration(
          color: ToyVillageColor.white,
          borderRadius: _open
              ? const BorderRadius.vertical(top: Radius.circular(8))
              : BorderRadius.circular(8),
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _toggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            child: Row(
              children: [
                SvgPicture.asset(SvgAssets.clock),
                const SizedBox(width: 8),
                Expanded(
                  child: hasValue
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.hintText,
                              style: ToyVillageTextStyle.caption5.copyWith(
                                color: ToyVillageColor.gray60,
                              ),
                            ),
                            Text(
                              _format(value),
                              style: ToyVillageTextStyle.body5.copyWith(
                                color: ToyVillageColor.gray100,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          widget.hintText,
                          style: ToyVillageTextStyle.body5.copyWith(
                            color: ToyVillageColor.gray60,
                          ),
                        ),
                ),
                if (_open)
                  const Icon(
                    Icons.keyboard_arrow_up,
                    size: 20,
                    color: ToyVillageColor.gray100,
                  )
                else if (hasValue)
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: ToyVillageColor.gray100,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomSideShadowClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(-24, 0, size.width + 24, size.height + 24);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => false;
}

class _Wheel extends StatelessWidget {
  final FixedExtentScrollController controller;
  final int count;
  final String Function(int) labelBuilder;
  final ValueChanged<int> onChanged;

  const _Wheel({
    required this.controller,
    required this.count,
    required this.labelBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: 44,
      diameterRatio: 100,
      perspective: 0.001,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: onChanged,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: count,
        builder: (context, index) => Center(
          child: Text(labelBuilder(index), style: ToyVillageTextStyle.body3),
        ),
      ),
    );
  }
}

class _MeridiemButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _MeridiemButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? ToyVillageColor.gray100 : ToyVillageColor.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: ToyVillageColor.gray60),
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
