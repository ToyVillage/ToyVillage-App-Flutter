import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/feed/feed_log/data/model/feed_log.dart';
import 'package:toy_village_app/features/feed/feed_log/data/repository/feed_log_repository.dart';

final animalFeedLogsViewModelProvider =
    AsyncNotifierProvider.family<
      AnimalFeedLogsViewModel,
      List<FeedLog>,
      int
    >(AnimalFeedLogsViewModel.new);

class AnimalFeedLogsViewModel extends AsyncNotifier<List<FeedLog>> {
  final int animalManageId;

  AnimalFeedLogsViewModel(this.animalManageId);

  @override
  FutureOr<List<FeedLog>> build() {
    return ref.read(feedLogRepositoryProvider).loadAnimalFeedLogs(animalManageId);
  }
}
