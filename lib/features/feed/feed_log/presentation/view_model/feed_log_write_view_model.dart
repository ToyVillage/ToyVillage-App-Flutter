import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/feed/feed_log/data/model/feed_log.dart';
import 'package:toy_village_app/features/feed/feed_log/data/repository/feed_log_repository.dart';

final feedLogWriteViewModelProvider =
    AsyncNotifierProvider<FeedLogWriteViewModel, void>(
      FeedLogWriteViewModel.new,
    );

class FeedLogWriteViewModel extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> create(int animalManageId, FeedLogRequest request) async {
    return _run(
      () => ref
          .read(feedLogRepositoryProvider)
          .createFeedLog(animalManageId, request),
    );
  }

  Future<bool> edit(int feedLogId, FeedLogRequest request) async {
    return _run(
      () =>
          ref.read(feedLogRepositoryProvider).updateFeedLog(feedLogId, request),
    );
  }

  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
      state = const AsyncData(null);
      return true;
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return false;
    }
  }
}
