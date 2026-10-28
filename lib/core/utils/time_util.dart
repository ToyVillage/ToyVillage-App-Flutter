final _zoneSuffix = RegExp(r'(Z|[+-]\d{2}:?\d{2})$');
final _fraction = RegExp(r'\.(\d+)');

DateTime parseServerTime(String value) {
  var normalized = value.trim();
  final timeIndex = normalized.indexOf('T');
  if (timeIndex >= 0) {
    final datePart = normalized.substring(0, timeIndex).replaceAll('.', '-');
    normalized = '$datePart${normalized.substring(timeIndex)}';
  } else {
    normalized = '${normalized.replaceAll('.', '-')}T00:00:00';
  }
  normalized = normalized.replaceAllMapped(_fraction, (match) {
    final digits = match.group(1)!;
    return '.${digits.length > 6 ? digits.substring(0, 6) : digits}';
  });
  if (_zoneSuffix.hasMatch(normalized)) {
    return DateTime.parse(normalized).toLocal();
  }
  return DateTime.parse(normalized);
}

String timeCheck(DateTime date) {
  final diff = DateTime.now().difference(date);

  if (diff.inMinutes < 1) return '방금 전';
  if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
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
