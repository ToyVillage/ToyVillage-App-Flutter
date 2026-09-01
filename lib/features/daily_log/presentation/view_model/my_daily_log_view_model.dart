import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/daily_log/data/model/daily_log_summary.dart';

final myDailyLogViewModelProvider =
    AsyncNotifierProvider<MyDailyLogViewModel, List<DailyLogSummary>>(
      MyDailyLogViewModel.new,
    );

class MyDailyLogViewModel extends AsyncNotifier<List<DailyLogSummary>> {
  @override
  FutureOr<List<DailyLogSummary>> build() {
    return [
      DailyLogSummary(
        workLogId: 1,
        writeAt: DateTime(2026, 8, 8, 12),
        templateTitle: '먹이급여일지',
      ),
      DailyLogSummary(
        workLogId: 2,
        writeAt: DateTime(2026, 8, 7, 18, 30),
        templateTitle: '건강관리일지',
      ),
      DailyLogSummary(
        workLogId: 3,
        writeAt: DateTime(2026, 8, 6, 9, 15),
        templateTitle: '사육장점검일지',
      ),
      DailyLogSummary(
        workLogId: 4,
        writeAt: DateTime(2026, 8, 5, 20),
        templateTitle: '마감일지',
      ),
    ];
  }
}
