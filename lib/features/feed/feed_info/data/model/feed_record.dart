class FeedRecord {
  final String speciesName;
  final String category;
  final String feedType;
  final String amount;
  final String timeRange;
  final String note;

  const FeedRecord({
    required this.speciesName,
    required this.category,
    required this.feedType,
    required this.amount,
    required this.timeRange,
    required this.note,
  });
}
