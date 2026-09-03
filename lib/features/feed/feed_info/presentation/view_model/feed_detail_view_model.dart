import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/feed/feed_info/data/model/feed_detail.dart';

final feedDetailViewModelProvider =
    NotifierProvider.family<FeedDetailViewModel, FeedDetail, String>(
      FeedDetailViewModel.new,
    );

class FeedDetailViewModel extends Notifier<FeedDetail> {
  final String speciesName;

  FeedDetailViewModel(this.speciesName);

  @override
  FeedDetail build() {
    return FeedDetail(
      date: '2026.08.27',
      startTime: (hour: 10, minute: 0, isPm: false),
      endTime: (hour: 11, minute: 0, isPm: false),
      target: '${speciesName}1',
      feedType: '건초',
      amount: '120',
      unit: 'g / ml',
      note: '잘 먹었음',
    );
  }
}
