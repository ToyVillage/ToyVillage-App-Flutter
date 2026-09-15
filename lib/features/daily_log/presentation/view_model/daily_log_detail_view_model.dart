import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/daily_log/data/model/daily_log_detail.dart';
import 'package:toy_village_app/features/daily_log/data/repository/daily_log_detail_repository.dart';

final dailyLogDetailViewModelProvider =
    AsyncNotifierProvider.family<DailyLogDetailViewModel, DailyLogDetail, int>(
      DailyLogDetailViewModel.new,
    );

class DailyLogDetailViewModel extends AsyncNotifier<DailyLogDetail> {
  final int id;

  DailyLogDetailViewModel(this.id);

  @override
  FutureOr<DailyLogDetail> build() {
    return ref.read(dailyLogDetailRepositoryProvider).loadDetail(id);
  }
}
