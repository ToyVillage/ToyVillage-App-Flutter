import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

class CheckboxField extends StatefulWidget {
  final List<String> choices;
  final bool hasEtc;
  final List<String> initialValues;
  final ValueChanged<List<String>>? onChanged;

  const CheckboxField({
    super.key,
    required this.choices,
    this.hasEtc = false,
    this.initialValues = const [],
    this.onChanged,
  });

  @override
  State<CheckboxField> createState() => _CheckboxFieldState();
}

class _CheckboxFieldState extends State<CheckboxField> {
  final Set<int> _selected = {};
  final _etcController = TextEditingController();

  bool get _isEtcChecked =>
      widget.hasEtc && _selected.contains(widget.choices.length);

  @override
  void initState() {
    super.initState();
    for (final value in widget.initialValues) {
      final index = widget.choices.indexOf(value);
      if (index >= 0) {
        _selected.add(index);
      } else if (widget.hasEtc) {
        _selected.add(widget.choices.length);
        _etcController.text = value;
      }
    }
  }

  @override
  void dispose() {
    _etcController.dispose();
    super.dispose();
  }

  void _toggle(int index) {
    setState(() {
      if (_selected.contains(index)) {
        _selected.remove(index);
      } else {
        _selected.add(index);
      }
    });
    _notify();
  }

  void _notify() {
    final onChanged = widget.onChanged;
    if (onChanged == null) return;
    final values = <String>[];
    for (final index in _selected) {
      if (widget.hasEtc && index == widget.choices.length) {
        values.add(_etcController.text);
      } else {
        values.add(widget.choices[index]);
      }
    }
    onChanged(values);
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
              _CheckRow(
                label: widget.choices[i],
                selected: _selected.contains(i),
                onTap: () => _toggle(i),
              ),
            ],
            if (widget.hasEtc) ...[
              if (widget.choices.isNotEmpty) const SizedBox(height: 16),
              _CheckRow(
                label: _isEtcChecked ? '기타 :' : '기타',
                selected: _isEtcChecked,
                onTap: () => _toggle(widget.choices.length),
                trailing: _isEtcChecked
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

class _CheckRow extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget? trailing;

  const _CheckRow({
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
            Container(
              width: 18,
              height: 18,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? ToyVillageColor.blue : ToyVillageColor.white,
                borderRadius: BorderRadius.circular(2),
                border: selected
                    ? null
                    : Border.all(color: ToyVillageColor.gray60, width: 1),
              ),
              child: selected
                  ? const Icon(
                      Symbols.check_rounded,
                      weight: 800,
                      size: 14,
                      color: ToyVillageColor.white,
                    )
                  : null,
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
