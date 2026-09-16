import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/daily_log/data/model/daily_log_template.dart';
import 'package:toy_village_app/features/daily_log/data/repository/daily_log_template_repository.dart';

final dailyLogTemplateViewModelProvider =
    AsyncNotifierProvider.family<
      DailyLogTemplateViewModel,
      DailyLogTemplate,
      int
    >(DailyLogTemplateViewModel.new);

class DailyLogTemplateViewModel extends AsyncNotifier<DailyLogTemplate> {
  final int id;

  DailyLogTemplateViewModel(this.id);

  @override
  FutureOr<DailyLogTemplate> build() {
    return ref.read(dailyLogTemplateRepositoryProvider).loadTemplate(id);
  }
}
