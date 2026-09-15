class WorkLogAnswerRequest {
  final int sectionId;
  final int questionId;
  final String? answerText;
  final int? fileId;

  const WorkLogAnswerRequest({
    required this.sectionId,
    required this.questionId,
    this.answerText,
    this.fileId,
  });

  Map<String, dynamic> toJson() => {
    'sectionId': sectionId,
    'questionId': questionId,
    'answerText': answerText,
    'fileId': fileId,
  };
}
