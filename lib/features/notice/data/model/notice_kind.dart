enum NoticeKind {
  all('ALL', '전체'),
  event('EVENT', '이벤트');

  final String code;
  final String label;

  const NoticeKind(this.code, this.label);

  static String labelOf(String code) {
    for (final kind in NoticeKind.values) {
      if (kind.code == code) return kind.label;
    }
    return code;
  }
}
