class WorkLogAnswerRequest {
  final int sectionId;
  final int questionId;
  final String? answerText;
  final int? fileId;
  final List<WorkLogAnswerOption> options;

  const WorkLogAnswerRequest({
    required this.sectionId,
    required this.questionId,
    this.answerText,
    this.fileId,
    this.options = const [],
  });

  Map<String, dynamic> toJson() => {
    'sectionId': sectionId,
    'questionId': questionId,
    'answerText': answerText,
    'fileId': fileId,
    'options': options.map((e) => e.toJson()).toList(),
  };
}

class WorkLogAnswerOption {
  final int optionId;
  final String? etcText;

  const WorkLogAnswerOption({required this.optionId, this.etcText});

  Map<String, dynamic> toJson() => {'optionId': optionId, 'etcText': etcText};
}
