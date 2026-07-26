String timeCheck(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final target = DateTime(date.year, date.month, date.day);
  final days = today.difference(target).inDays;

  if (days <= 0) return '오늘';
  if (days == 1) return '어제';
  if (days < 7) return '$days일 전';
  if (days < 30) return '${(days / 7).floor()}주 전';
  return '${(days / 30).floor()}개월 전';
}

String formatTime(String time) {
  final parts = time.split(':');
  if (parts.length < 2) return time;
  final hour = int.parse(parts[0]);
  return '$hour : ${parts[1]}';
}

String formatTimeOf(DateTime date) =>
    formatTime('${date.hour}:${date.minute.toString().padLeft(2, '0')}');
