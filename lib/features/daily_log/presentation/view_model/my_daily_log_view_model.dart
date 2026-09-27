import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/daily_log/data/model/daily_log_summary.dart';
import 'package:toy_village_app/features/daily_log/data/repository/daily_log_summary_repository.dart';

final myDailyLogViewModelProvider =
    AsyncNotifierProvider<MyDailyLogViewModel, List<DailyLogSummary>>(
      MyDailyLogViewModel.new,
    );

class MyDailyLogViewModel extends AsyncNotifier<List<DailyLogSummary>> {
  @override
  FutureOr<List<DailyLogSummary>> build() {
    return ref.read(dailyLogSummaryRepositoryProvider).loadMyWorkLogs();
  }
}
