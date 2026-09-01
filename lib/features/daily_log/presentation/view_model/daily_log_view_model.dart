import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/daily_log/data/model/daily_log.dart';
import 'package:toy_village_app/features/daily_log/data/repository/daily_log_repository.dart';

final dailyLogViewModelProvider =
    NotifierProvider<DailyLogViewModel, List<DailyLog>>(DailyLogViewModel.new);

class DailyLogViewModel extends Notifier<List<DailyLog>> {
  @override
  List<DailyLog> build() => ref.read(dailyLogRepositoryProvider).seed();

  int get _nextId => state.isEmpty
      ? 1
      : state.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;

  void add({required String templateName, required String content}) {
    state = [
      DailyLog(
        id: _nextId,
        templateName: templateName,
        content: content,
        createdAt: DateTime.now(),
      ),
      ...state,
    ];
  }

  void update(int id, {required String templateName, required String content}) {
    state = [
      for (final log in state)
        if (log.id == id)
          log.copyWith(templateName: templateName, content: content)
        else
          log,
    ];
  }

  void remove(int id) {
    state = [
      for (final log in state)
        if (log.id != id) log,
    ];
  }

  DailyLog? byId(int id) {
    for (final log in state) {
      if (log.id == id) return log;
    }
    return null;
  }
}
