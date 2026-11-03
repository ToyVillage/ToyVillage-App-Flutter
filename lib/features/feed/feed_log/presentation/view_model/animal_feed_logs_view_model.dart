import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/feed/feed_log/data/model/feed_log.dart';
import 'package:toy_village_app/features/feed/feed_log/data/model/fifth_floor_feed_log.dart';
import 'package:toy_village_app/features/feed/feed_log/data/repository/feed_log_repository.dart';
import 'package:toy_village_app/features/feed/feed_log/data/repository/fifth_floor_feed_log_repository.dart';

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
  Future<List<FeedLog>> build() async {
    final results = await Future.wait([
      ref.read(feedLogRepositoryProvider).loadAnimalFeedLogs(animalManageId),
      _loadFifthFloor(),
    ]);
    final normal = results[0] as List<FeedLog>;
    final fifth = (results[1] as List<FifthFloorFeedLog>)
        .map(FeedLog.fromFifthFloor);
    final merged = [...normal, ...fifth]
      ..sort((a, b) => b.feedDateTime.compareTo(a.feedDateTime));
    return merged;
  }

  Future<List<FifthFloorFeedLog>> _loadFifthFloor() async {
    try {
      return await ref
          .read(fifthFloorFeedLogRepositoryProvider)
          .loadAnimalFeedLogs(animalManageId);
    } catch (_) {
      return const [];
    }
  }
}
