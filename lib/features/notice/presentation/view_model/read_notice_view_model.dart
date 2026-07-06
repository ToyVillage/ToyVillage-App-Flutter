import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final readNoticeProvider =
    AsyncNotifierProvider<ReadNoticeViewModel, Set<int>>(
      ReadNoticeViewModel.new,
    );

/// 읽은 공지 ID 집합을 SharedPreferences에 저장/관리한다.
class ReadNoticeViewModel extends AsyncNotifier<Set<int>> {
  static const _key = 'read_notice_ids';

  @override
  Future<Set<int>> build() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_key) ?? [];
    return saved.map(int.parse).toSet();
  }

  /// 공지를 읽음으로 표시한다.
  Future<void> markAsRead(int id) async {
    final current = state.value ?? <int>{};
    if (current.contains(id)) return;

    final updated = {...current, id};
    state = AsyncData(updated);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      updated.map((e) => e.toString()).toList(),
    );
  }
}
