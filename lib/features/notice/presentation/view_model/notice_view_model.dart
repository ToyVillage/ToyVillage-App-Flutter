import 'dart:async';
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
  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;

  @override
  Future<List<NoticeModel>> build() async {
    _page = 0;
    final first = await ref
        .read(noticeRepositoryProvider)
        .loadNotices(page: _page, size: _size);
    _hasMore = first.length == _size;
    return first;
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    final current = state.value;
    if (current == null) return;

    _isLoadingMore = true;
    try {
      final next = await ref
          .read(noticeRepositoryProvider)
          .loadNotices(page: _page + 1, size: _size);
      _page += 1;
      _hasMore = next.length == _size;
      state = AsyncData([...current, ...next]);
    } finally {
      _isLoadingMore = false;
    }
  }
}
