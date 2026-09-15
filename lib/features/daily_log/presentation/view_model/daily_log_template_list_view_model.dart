import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/daily_log/data/model/daily_log_template_summary.dart';
import 'package:toy_village_app/features/daily_log/data/repository/daily_log_template_repository.dart';

final dailyLogTemplateListViewModelProvider =
    AsyncNotifierProvider<
      DailyLogTemplateListViewModel,
      List<DailyLogTemplateSummary>
    >(DailyLogTemplateListViewModel.new);

class DailyLogTemplateListViewModel
    extends AsyncNotifier<List<DailyLogTemplateSummary>> {
  @override
  FutureOr<List<DailyLogTemplateSummary>> build() {
    return ref.read(dailyLogTemplateRepositoryProvider).loadTemplates();
  }
}
