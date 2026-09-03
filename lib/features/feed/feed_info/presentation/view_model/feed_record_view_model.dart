import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/feed/feed_info/data/model/feed_record.dart';

final feedRecordViewModelProvider =
    NotifierProvider<FeedRecordViewModel, List<FeedRecord>>(
      FeedRecordViewModel.new,
    );

class FeedRecordViewModel extends Notifier<List<FeedRecord>> {
  @override
  List<FeedRecord> build() {
    return const [
      FeedRecord(
        speciesName: '카피바라',
        category: '포유류',
        feedType: '소고기',
        amount: '500 g/ml',
        timeRange: '12:00 ~ 13:00',
        note: '특이사항 칸인데 특이사항이 없습니다.',
      ),
      FeedRecord(
        speciesName: '카피바라',
        category: '포유류',
        feedType: '건초',
        amount: '1.2 kg/L',
        timeRange: '09:00 ~ 09:30',
        note: '평소보다 잘 먹었습니다.',
      ),
      FeedRecord(
        speciesName: '카피바라',
        category: '포유류',
        feedType: '사과',
        amount: '200 g/ml',
        timeRange: '15:00 ~ 15:20',
        note: '특이사항이 없습니다.',
      ),
      FeedRecord(
        speciesName: '카피바라',
        category: '포유류',
        feedType: '당근',
        amount: '300 g/ml',
        timeRange: '18:00 ~ 18:40',
        note: '식욕이 다소 떨어졌습니다.',
      ),
    ];
  }
}
