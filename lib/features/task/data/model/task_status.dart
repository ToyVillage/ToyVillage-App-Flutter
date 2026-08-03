enum TaskStatus {
  notSubmitted('NOT_SUBMITTED'),
  submitted('SUBMITTED'),
  rejected('REJECTED'),
  completed('COMPLETED');

  final String code;

  const TaskStatus(this.code);

  static TaskStatus fromCode(String code) {
    for (final status in TaskStatus.values) {
      if (status.code == code) return status;
    }
    return TaskStatus.notSubmitted;
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
