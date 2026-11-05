import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/feed/feed_log/data/model/fifth_floor_feed_log.dart';
import 'package:toy_village_app/features/feed/feed_log/data/repository/fifth_floor_feed_log_repository.dart';

final fifthFloorFeedLogWriteViewModelProvider =
    AsyncNotifierProvider<FifthFloorFeedLogWriteViewModel, void>(
      FifthFloorFeedLogWriteViewModel.new,
    );

class FifthFloorFeedLogWriteViewModel extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> create(
    int animalManageId,
    FifthFloorFeedLogRequest request,
  ) async {
    return _run(
      () => ref
          .read(fifthFloorFeedLogRepositoryProvider)
          .createFeedLog(animalManageId, request),
    );
  }

  Future<bool> edit(int feedLogId, FifthFloorFeedLogRequest request) async {
    return _run(
      () => ref
          .read(fifthFloorFeedLogRepositoryProvider)
          .updateFeedLog(feedLogId, request),
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
