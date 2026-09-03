import 'package:toy_village_app/features/feed/feed_writing/presentation/widget/feed_time_field.dart';

class FeedDetail {
  final String date;
  final FeedTime startTime;
  final FeedTime endTime;
  final String target;
  final String feedType;
  final String amount;
  final String unit;
  final String note;

  const FeedDetail({
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.target,
    required this.feedType,
    required this.amount,
    required this.unit,
    required this.note,
  });
}
