import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/svg_assets.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

class RadioField extends StatefulWidget {
  final List<String> choices;
  final bool hasEtc;
  final ValueChanged<String?>? onChanged;

  const RadioField({
    super.key,
    required this.choices,
    this.hasEtc = false,
    this.onChanged,
  });

  @override
  State<RadioField> createState() => _RadioFieldState();
}

class _RadioFieldState extends State<RadioField> {
  int? _selected;
  final _etcController = TextEditingController();

  bool get _isEtcSelected =>
      widget.hasEtc && _selected == widget.choices.length;

  @override
  void dispose() {
    _etcController.dispose();
    super.dispose();
  }

  void _select(int index) {
    setState(() => _selected = index);
    _notify();
  }

  void _notify() {
    final onChanged = widget.onChanged;
    if (onChanged == null) return;
    if (_selected == null) {
      onChanged(null);
    } else if (_isEtcSelected) {
      onChanged(_etcController.text);
    } else {
      onChanged(widget.choices[_selected!]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ToyVillageColor.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < widget.choices.length; i++) ...[
              if (i > 0) const SizedBox(height: 16),
              _RadioRow(
                label: widget.choices[i],
                selected: _selected == i,
                onTap: () => _select(i),
              ),
            ],
            if (widget.hasEtc) ...[
              if (widget.choices.isNotEmpty) const SizedBox(height: 16),
              _RadioRow(
                label: _isEtcSelected ? '기타 :' : '기타',
                selected: _isEtcSelected,
                onTap: () => _select(widget.choices.length),
                trailing: _isEtcSelected
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: SizedBox(
                          width: 140,
                          height: 20,
                          child: TextField(
                            cursorHeight: 14,
                            controller: _etcController,
                            textAlignVertical: TextAlignVertical.top,
                            scrollPadding: const EdgeInsets.only(bottom: 100),
                            onChanged: (_) => _notify(),
                            style: ToyVillageTextStyle.button5.copyWith(
                              color: ToyVillageColor.gray100,
                            ),
                            cursorColor: ToyVillageColor.gray100,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: '입력하기',
                              hintStyle: ToyVillageTextStyle.button5.copyWith(
                                color: ToyVillageColor.gray60,
                              ),
                              contentPadding: EdgeInsets.zero,
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: ToyVillageColor.gray60,
                                ),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: ToyVillageColor.gray60,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RadioRow extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget? trailing;

  const _RadioRow({
    required this.label,
    required this.selected,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        height: 20,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            selected
                ? SvgPicture.asset(SvgAssets.radio, width: 18, height: 18)
                : Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ToyVillageColor.white,
                      border: Border.all(
                        color: ToyVillageColor.gray60,
                        width: 2,
                      ),
                    ),
                  ),
            const SizedBox(width: 8),
            Text(
              label,
              style: ToyVillageTextStyle.button5.copyWith(
                color: selected
                    ? ToyVillageColor.gray100
                    : ToyVillageColor.gray60,
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}
