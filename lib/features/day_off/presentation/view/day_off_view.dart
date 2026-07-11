import 'package:flutter/material.dart';
import 'package:toy_village_app/core/widgets/app_bar.dart';
import 'package:toy_village_app/features/day_off/presentation/widget/calendar_header.dart';
import 'package:toy_village_app/features/day_off/presentation/widget/date_info.dart';
import 'package:toy_village_app/features/day_off/presentation/widget/day_off_calendar.dart';

class DayOffView extends StatefulWidget {
  const DayOffView({super.key});

  @override
  State<DayOffView> createState() => _DayOffViewState();
}

class _DayOffViewState extends State<DayOffView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // TODO: 서버 연동 시 휴관일 목록으로 교체
  final Map<DateTime, String> _dayOffs = {
    DateTime.utc(2026, 6, 17): '동물 정기검진으로 인한 휴관',
  };

  String? _reasonFor(DateTime day) {
    for (final entry in _dayOffs.entries) {
      final d = entry.key;
      if (d.year == day.year && d.month == day.month && d.day == day.day) {
        return entry.value;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final infoDay = _selectedDay ?? DateTime.now();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ToyVillageAppBar(),
                Center(child: CalendarHeader(focusedDay: _focusedDay)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: DayOffCalendar(
                    focusedDay: _focusedDay,
                    selectedDay: _selectedDay,
                    dayOffs: _dayOffs.keys.toSet(),
                    onDaySelected: (selected, focused) {
                      setState(() {
                        _selectedDay = selected;
                        _focusedDay = focused;
                      });
                    },
                    onPageChanged: (focused) {
                      setState(() => _focusedDay = focused);
                    },
                  ),
                ),
                DateInfo(
                  title: '${infoDay.month}월 ${infoDay.day}일',
                  content: _reasonFor(infoDay),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: DateInfo(
                    title: '운영시간',
                    operatingHours: '10:00 ~ 20:00',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
