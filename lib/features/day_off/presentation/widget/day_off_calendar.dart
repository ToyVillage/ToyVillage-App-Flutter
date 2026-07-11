import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

class DayOffCalendar extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Set<DateTime> dayOffs;
  final void Function(DateTime selected, DateTime focused) onDaySelected;
  final void Function(DateTime focused) onPageChanged;

  const DayOffCalendar({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.dayOffs,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  static const List<String> _weekdays = ['일', '월', '화', '수', '목', '금', '토'];

  bool _isDayOff(DateTime day) => dayOffs.any((d) => isSameDay(d, day));

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ToyVillageColor.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: TableCalendar(
        focusedDay: focusedDay,
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        headerVisible: false,
        rowHeight: 64,
        daysOfWeekHeight: 32,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        availableGestures: AvailableGestures.horizontalSwipe,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        onDaySelected: onDaySelected,
        onPageChanged: onPageChanged,
        calendarBuilders: CalendarBuilders(
          dowBuilder: (context, day) => Center(
            child: Text(
              _weekdays[day.weekday % 7],
              style: ToyVillageTextStyle.calendarWeek.copyWith(
                color: ToyVillageColor.gray60,
              ),
            ),
          ),
          prioritizedBuilder: (context, day, focused) => _DayCell(
            day: day.day,
            isOutside: day.month != focused.month,
            isToday: isSameDay(day, DateTime.now()),
            isSelected: isSameDay(selectedDay, day),
            isDayOff: _isDayOff(day),
          ),
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final bool isOutside;
  final bool isToday;
  final bool isSelected;
  final bool isDayOff;

  const _DayCell({
    required this.day,
    required this.isOutside,
    required this.isToday,
    required this.isSelected,
    required this.isDayOff,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = isOutside ? ToyVillageTextStyle.calendarDisable : ToyVillageTextStyle.calendarEnable;

    final textColor = isToday
        ? ToyVillageColor.white
        : (isOutside ? ToyVillageColor.gray60 : ToyVillageColor.gray100);

    return SizedBox(
      height: 60,
      child: Stack(
      alignment: Alignment.topCenter,
      children: [
        if (isSelected)
          Container(
            width: 42,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: ToyVillageColor.gray60),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: isToday
              ? const BoxDecoration(
                  color: ToyVillageColor.blue,
                  shape: BoxShape.circle,
                )
              : null,
          child: Text(
            '$day',
            style: textStyle.copyWith(color: textColor),
          ),
        ),
        if (isDayOff)
          const Padding(
            padding: EdgeInsets.only(top: 35),
            child: _Dot(),
          ),
      ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15,
      height: 15,
      decoration: const BoxDecoration(
        color: ToyVillageColor.red,
        shape: BoxShape.circle,
      ),
    );
  }
}
