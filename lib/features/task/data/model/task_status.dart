enum TaskStatus {
  inProgress('IN_PROGRESS'),
  completed('COMPLETED');

  final String code;

  const TaskStatus(this.code);

  static TaskStatus fromCode(String code) {
    for (final status in TaskStatus.values) {
      if (status.code == code) return status;
    }
    return TaskStatus.inProgress;
  }
}

enum TaskPriority {
  high('HIGH', '상'),
  medium('MEDIUM', '중'),
  low('LOW', '하');

  final String code;
  final String label;

  const TaskPriority(this.code, this.label);

  static TaskPriority fromCode(String code) {
    for (final priority in TaskPriority.values) {
      if (priority.code == code) return priority;
    }
    return TaskPriority.medium;
  }
}

enum ReportStatus {
  missing('MISSING'),
  pending('PENDING'),
  approved('APPROVED'),
  rejected('REJECTED');

  final String code;

  const ReportStatus(this.code);

  static ReportStatus fromCode(String code) {
    for (final status in ReportStatus.values) {
      if (status.code == code) return status;
    }
    return ReportStatus.pending;
  }
}
