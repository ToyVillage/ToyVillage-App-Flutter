final _zoneSuffix = RegExp(r'(Z|[+-]\d{2}:?\d{2})$');

DateTime parseServerTime(String value) {
  final parsed = DateTime.parse(value);
  if (_zoneSuffix.hasMatch(value)) return parsed.toLocal();
  return DateTime.utc(
    parsed.year,
    parsed.month,
    parsed.day,
    parsed.hour,
    parsed.minute,
    parsed.second,
    parsed.millisecond,
    parsed.microsecond,
  ).toLocal();
}

String timeCheck(DateTime date) {
  final diff = DateTime.now().difference(date);

  if (diff.inHours < 1) return '방금 전';
  if (diff.inHours < 24) return '${diff.inHours}시간 전';

  final days = diff.inDays;
  if (days < 7) return '$days일 전';
  if (days < 30) return '${days ~/ 7}주 전';
  if (days < 365) return '${days ~/ 30}개월 전';
  return '${days ~/ 365}년 전';
}

String formatTime(String time) {
  final parts = time.split(':');
  if (parts.length < 2) return time;
  final hour = int.parse(parts[0]);
  return '$hour : ${parts[1]}';
}

String formatTimeOf(DateTime date) =>
    formatTime('${date.hour}:${date.minute.toString().padLeft(2, '0')}');
