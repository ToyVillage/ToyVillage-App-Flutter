import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final seenTaskProvider = AsyncNotifierProvider<SeenTaskViewModel, Set<int>>(
  SeenTaskViewModel.new,
);

class SeenTaskViewModel extends AsyncNotifier<Set<int>> {
  static const _key = 'seen_task_ids';

  Future<void> _writeQueue = Future.value();

  @override
  Future<Set<int>> build() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_key) ?? [];
    return saved.map(int.parse).toSet();
  }

  Future<void> markAsSeen(int id) async {
    final current = state.value ?? <int>{};
    if (current.contains(id)) return;

    state = AsyncData({...current, id});

    _writeQueue = _writeQueue.then((_) async {
      final prefs = await SharedPreferences.getInstance();
      final latest = state.value ?? <int>{};
      await prefs.setStringList(_key, latest.map((e) => e.toString()).toList());
    });
    await _writeQueue;
  }
}
