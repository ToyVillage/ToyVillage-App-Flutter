enum TaskStatus {
  pending('PENDING', '진행 전'),
  inProgress('IN_PROGRESS', '진행 중'),
  completed('COMPLETED', '완료됨');

  final String code;
  final String label;

  const TaskStatus(this.code, this.label);

  /// 서버 status 코드를 TaskStatus로 변환한다. 모르는 코드는 pending으로 취급.
  static TaskStatus fromCode(String code) {
    for (final status in TaskStatus.values) {
      if (status.code == code) return status;
    }
    return TaskStatus.pending;
  }
}
