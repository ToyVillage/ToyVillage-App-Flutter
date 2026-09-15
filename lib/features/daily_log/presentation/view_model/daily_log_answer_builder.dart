import 'package:toy_village_app/features/daily_log/data/model/daily_log_template.dart';
import 'package:toy_village_app/features/daily_log/data/model/question_type.dart';
import 'package:toy_village_app/features/daily_log/data/model/work_log_answer_request.dart';

WorkLogAnswerOption? _mapOption(TemplateQuestion question, String value) {
  for (final option in question.options) {
    if (!option.etcOption && option.content == value) {
      return WorkLogAnswerOption(optionId: option.optionId);
    }
  }
  for (final option in question.options) {
    if (option.etcOption) {
      return WorkLogAnswerOption(optionId: option.optionId, etcText: value);
    }
  }
  return null;
}

List<WorkLogAnswerRequest> buildWorkLogAnswers({
  required int sectionId,
  required List<TemplateQuestion> questions,
  required Map<int, String> textValues,
  required Map<int, String?> radioValues,
  required Map<int, List<String>> checkboxValues,
  Map<int, int?> fileIds = const {},
}) {
  final answers = <WorkLogAnswerRequest>[];
  for (final question in questions) {
    final id = question.questionId;
    switch (question.questionType) {
      case QuestionType.text:
        final text = (textValues[id] ?? '').trim();
        answers.add(
          WorkLogAnswerRequest(
            sectionId: sectionId,
            questionId: id,
            answerText: text.isEmpty ? null : text,
          ),
        );
      case QuestionType.multipleChoice:
        final value = radioValues[id];
        final option = value == null ? null : _mapOption(question, value);
        answers.add(
          WorkLogAnswerRequest(
            sectionId: sectionId,
            questionId: id,
            options: option == null ? const [] : [option],
          ),
        );
      case QuestionType.checkBox:
        final values = checkboxValues[id] ?? const [];
        final options = <WorkLogAnswerOption>[];
        for (final value in values) {
          final option = _mapOption(question, value);
          if (option != null) options.add(option);
        }
        answers.add(
          WorkLogAnswerRequest(
            sectionId: sectionId,
            questionId: id,
            options: options,
          ),
        );
      case QuestionType.fileUpload:
        answers.add(
          WorkLogAnswerRequest(
            sectionId: sectionId,
            questionId: id,
            fileId: fileIds[id],
          ),
        );
    }
  }
  return answers;
}
