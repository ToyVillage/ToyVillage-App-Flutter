import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/feed/feed_log/data/model/feed_log.dart';
import 'package:toy_village_app/features/feed/feed_log/data/repository/feed_log_repository.dart';

final myFeedLogsViewModelProvider =
    AsyncNotifierProvider<MyFeedLogsViewModel, List<FeedLogSummary>>(
      MyFeedLogsViewModel.new,
    );

class MyFeedLogsViewModel extends AsyncNotifier<List<FeedLogSummary>> {
  @override
  FutureOr<List<FeedLogSummary>> build() {
    return ref.read(feedLogRepositoryProvider).loadMyFeedLogs();
  }
}
