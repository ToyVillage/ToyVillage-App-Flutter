import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/feed/feed_log/data/model/feed_log.dart';
import 'package:toy_village_app/features/feed/feed_log/data/repository/fifth_floor_feed_log_repository.dart';

final fifthFloorFeedLogDetailViewModelProvider =
    AsyncNotifierProvider.autoDispose.family<
      FifthFloorFeedLogDetailViewModel,
      FeedLogDetail,
      int
    >(FifthFloorFeedLogDetailViewModel.new);

class FifthFloorFeedLogDetailViewModel extends AsyncNotifier<FeedLogDetail> {
  final int feedLogId;

  FifthFloorFeedLogDetailViewModel(this.feedLogId);

  @override
  Future<FeedLogDetail> build() async {
    final detail = await ref
        .read(fifthFloorFeedLogRepositoryProvider)
        .loadFeedLogDetail(feedLogId);
    return FeedLogDetail.fromFifthFloor(detail);
  }
}
