import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/widgets/app_bar.dart';
import 'package:toy_village_app/features/day_off/data/model/close_day_model.dart';
import 'package:toy_village_app/features/day_off/presentation/view_model/close_day_view_model.dart';
import 'package:toy_village_app/features/day_off/presentation/widget/calendar_header.dart';
import 'package:toy_village_app/features/day_off/presentation/widget/date_info.dart';
import 'package:toy_village_app/features/day_off/presentation/widget/day_off_calendar.dart';
import 'package:toy_village_app/features/day_off/presentation/widget/day_off_skeleton.dart';

class DayOffView extends ConsumerStatefulWidget {
  const DayOffView({super.key});

  @override
  ConsumerState<DayOffView> createState() => _DayOffViewState();
}

class _DayOffViewState extends ConsumerState<DayOffView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Set<DateTime> _closeDates(List<CloseDayModel> closeDays) {
    final dates = <DateTime>{};
    for (final c in closeDays) {
      var d = _dateOnly(c.startCloseTime);
      final end = _dateOnly(c.endCloseTime);
      while (!d.isAfter(end)) {
        dates.add(d);
        d = d.add(const Duration(days: 1));
      }
    }
    return dates;
  }

  String? _reasonFor(List<CloseDayModel> closeDays, DateTime day) {
    final target = _dateOnly(day);
    for (final c in closeDays) {
      final start = _dateOnly(c.startCloseTime);
      final end = _dateOnly(c.endCloseTime);
      if (!target.isBefore(start) && !target.isAfter(end)) return c.title;
    }
    return null;
  }

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(closeDayViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ToyVillageAppBar(),
              Expanded(child: _content(async)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _content(AsyncValue<List<CloseDayModel>> async) {
    if (async.isLoading) {
      return const SingleChildScrollView(child: DayOffSkeleton());
    }

    if (async.hasError) {
      return Align(
        alignment: const Alignment(0, -0.1),
        child: Text(
          '휴관 정보를 불러오지 못했어요.',
          style: ToyVillageTextStyle.body5.copyWith(
            color: ToyVillageColor.gray60,
          ),
        ),
      );
    }

    final closeDays = async.value ?? const <CloseDayModel>[];
    final infoDay = _selectedDay ?? DateTime.now();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: CalendarHeader(focusedDay: _focusedDay)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: DayOffCalendar(
              focusedDay: _focusedDay,
              selectedDay: _selectedDay,
              dayOffs: _closeDates(closeDays),
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
            content: _reasonFor(closeDays, infoDay),
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
    );
  }
}
