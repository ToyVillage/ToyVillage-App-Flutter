enum NoticeKind {
  all('ALL', '전체'),
  event('EVENT', '이벤트');

  final String code;
  final String label;

  const NoticeKind(this.code, this.label);

  /// 서버 kind 코드(ALL 등)를 한글 라벨로 변환한다. 모르는 코드는 그대로 반환.
  static String labelOf(String code) {
    for (final kind in NoticeKind.values) {
      if (kind.code == code) return kind.label;
    }
    return code;
  }
}
