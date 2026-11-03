import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/notice/data/model/notice_model.dart';
import 'package:toy_village_app/features/notice/data/repository/notice_repository.dart';

final noticeViewModelProvider =
    AsyncNotifierProvider<NoticeViewModel, List<NoticeModel>>(
      () => NoticeViewModel(),
    );

class NoticeViewModel extends AsyncNotifier<List<NoticeModel>> {
  static const _size = 10;

  int _page = 0;
  int _totalPages = 1;
  bool _isLoadingMore = false;

  bool get hasMore => _page + 1 < _totalPages;

  @override
  Future<List<NoticeModel>> build() async {
    _page = 0;
    final first = await ref
        .read(noticeRepositoryProvider)
        .loadNotices(page: _page, size: _size);
    _totalPages = first.totalPages;
    return first.notices;
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !hasMore) return;
    final current = state.value;
    if (current == null) return;

    _isLoadingMore = true;
    try {
      final next = await ref
          .read(noticeRepositoryProvider)
          .loadNotices(page: _page + 1, size: _size);
      _page += 1;
      _totalPages = next.totalPages;

      final existingIds = {for (final notice in current) notice.id};
      final fresh = [
        for (final notice in next.notices)
          if (existingIds.add(notice.id)) notice,
      ];
      if (fresh.isEmpty) {
        state = AsyncData([...current]);
        return;
      }
      state = AsyncData([...current, ...fresh]);
    } catch (e, s) {
      debugPrint('loadMore failed: $e\n$s');
    } finally {
      _isLoadingMore = false;
    }
  }
}
