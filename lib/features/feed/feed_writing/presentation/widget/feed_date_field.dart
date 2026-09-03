import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/svg_assets.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

class FeedDateField extends StatefulWidget {
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;

  const FeedDateField({super.key, this.value, required this.onChanged});

  @override
  State<FeedDateField> createState() => _FeedDateFieldState();
}

class _FeedDateFieldState extends State<FeedDateField> {
  static const _weekdays = ['일', '월', '화', '수', '목', '금', '토'];

  bool _open = false;
  late DateTime _focusedDay = widget.value ?? DateTime.now();
  late DateTime? _tempSelected = widget.value;

  void _toggle() {
    FocusScope.of(context).unfocus();
    setState(() {
      _open = !_open;
      if (_open) {
        _tempSelected = widget.value;
        _focusedDay = widget.value ?? DateTime.now();
      }
    });
  }

  Widget _dayCell(String text, Color color) {
    return Center(
      child: Text(
        text,
        style: ToyVillageTextStyle.caption3.copyWith(color: color),
      ),
    );
  }

  String _format(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}.$month.$day';
  }

  @override
  Widget build(BuildContext context) {
    final value = widget.value;
    final hasValue = value != null;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ToyVillageColor.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  SvgPicture.asset(SvgAssets.dateToday),
                  const SizedBox(width: 8),
                  Text(
                    hasValue ? _format(value) : '날짜 선택',
                    style: ToyVillageTextStyle.body5.copyWith(
                      color: hasValue
                          ? ToyVillageColor.gray100
                          : ToyVillageColor.gray60,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_open) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${_focusedDay.month}월 ${_focusedDay.year}',
                      style: ToyVillageTextStyle.body3,
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => setState(() {
                      _focusedDay = DateTime(
                        _focusedDay.year,
                        _focusedDay.month - 1,
                      );
                    }),
                    child: const Icon(
                      Symbols.chevron_left_rounded,
                      weight: 700,
                      color: ToyVillageColor.gray100,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => setState(() {
                      _focusedDay = DateTime(
                        _focusedDay.year,
                        _focusedDay.month + 1,
                      );
                    }),
                    child: const Icon(
                      Symbols.chevron_right_rounded,
                      weight: 700,
                      color: ToyVillageColor.gray100,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2100, 12, 31),
                focusedDay: _focusedDay,
                headerVisible: false,
                pageAnimationEnabled: false,
                calendarStyle: const CalendarStyle(outsideDaysVisible: true),
                calendarBuilders: CalendarBuilders(
                  dowBuilder: (context, day) => Center(
                    child: Text(
                      _weekdays[day.weekday % 7],
                      style: ToyVillageTextStyle.caption4.copyWith(
                        color: ToyVillageColor.gray100,
                      ),
                    ),
                  ),
                  defaultBuilder: (context, day, focusedDay) =>
                      _dayCell('${day.day}', ToyVillageColor.gray100),
                  todayBuilder: (context, day, focusedDay) =>
                      _dayCell('${day.day}', ToyVillageColor.gray100),
                  outsideBuilder: (context, day, focusedDay) =>
                      _dayCell('${day.day}', ToyVillageColor.gray40),
                  disabledBuilder: (context, day, focusedDay) =>
                      _dayCell('${day.day}', ToyVillageColor.gray40),
                  selectedBuilder: (context, day, focusedDay) => Center(
                    child: Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: ToyVillageColor.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${day.day}',
                        style: ToyVillageTextStyle.caption3.copyWith(
                          color: ToyVillageColor.white,
                        ),
                      ),
                    ),
                  ),
                ),
                selectedDayPredicate: (day) =>
                    _tempSelected != null && isSameDay(day, _tempSelected),
                onDaySelected: (selectedDay, focusedDay) => setState(() {
                  _tempSelected = selectedDay;
                  _focusedDay = focusedDay;
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _DialogButton(
                      label: '취소',
                      background: ToyVillageColor.gray40,
                      onTap: () => setState(() => _open = false),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DialogButton(
                      label: '확인',
                      background: ToyVillageColor.blue,
                      onTap: () {
                        final selected = _tempSelected;
                        if (selected != null) widget.onChanged(selected);
                        setState(() => _open = false);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  final String label;
  final Color background;
  final VoidCallback onTap;

  const _DialogButton({
    required this.label,
    required this.background,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(27),
        ),
        child: Text(
          label,
          style: ToyVillageTextStyle.button4.copyWith(
            color: ToyVillageColor.white,
          ),
        ),
      ),
    );
  }
}
