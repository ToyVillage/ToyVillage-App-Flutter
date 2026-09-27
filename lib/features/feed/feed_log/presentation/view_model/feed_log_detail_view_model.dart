import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/feed/feed_log/data/model/feed_log.dart';
import 'package:toy_village_app/features/feed/feed_log/data/repository/feed_log_repository.dart';

final feedLogDetailViewModelProvider =
    AsyncNotifierProvider.family<
      FeedLogDetailViewModel,
      FeedLogDetail,
      int
    >(FeedLogDetailViewModel.new);

class FeedLogDetailViewModel extends AsyncNotifier<FeedLogDetail> {
  final int feedLogId;

  FeedLogDetailViewModel(this.feedLogId);

  @override
  FutureOr<FeedLogDetail> build() {
    return ref.read(feedLogRepositoryProvider).loadFeedLogDetail(feedLogId);
  }
}
