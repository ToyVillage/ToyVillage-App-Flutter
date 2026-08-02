import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final seenTaskProvider = AsyncNotifierProvider<SeenTaskViewModel, Set<int>>(
  SeenTaskViewModel.new,
);

class SeenTaskViewModel extends AsyncNotifier<Set<int>> {
  static const _key = 'seen_task_ids';

  @override
  Future<Set<int>> build() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_key) ?? [];
    return saved.map(int.parse).toSet();
  }

  Future<void> markAsSeen(int id) async {
    final current = state.value ?? <int>{};
    if (current.contains(id)) return;

    final updated = {...current, id};
    state = AsyncData(updated);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, updated.map((e) => e.toString()).toList());
  }
}
