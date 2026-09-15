import 'package:toy_village_app/features/daily_log/data/model/daily_log_template.dart';
import 'package:toy_village_app/features/daily_log/data/model/question_type.dart';
import 'package:toy_village_app/features/daily_log/data/model/work_log_answer_request.dart';

typedef RadioSelection = ({int? index, String etcText});
typedef CheckboxSelection = ({Set<int> indices, String etcText});

WorkLogAnswerOption? _optionAt(
  TemplateQuestion question,
  int index,
  String etcText,
) {
  final normal = [
    for (final option in question.options)
      if (!option.etcOption) option,
  ];
  if (index >= 0 && index < normal.length) {
    return WorkLogAnswerOption(optionId: normal[index].optionId);
  }
  for (final option in question.options) {
    if (option.etcOption) {
      return WorkLogAnswerOption(optionId: option.optionId, etcText: etcText);
    }
  }
  return null;
}

List<WorkLogAnswerRequest> buildWorkLogAnswers({
  required int sectionId,
  required List<TemplateQuestion> questions,
  required Map<int, String> textValues,
  required Map<int, RadioSelection> radioSelections,
  required Map<int, CheckboxSelection> checkboxSelections,
  Map<int, String?> fileKeys = const {},
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
        final selection = radioSelections[id];
        final index = selection?.index;
        final option = index == null
            ? null
            : _optionAt(question, index, selection!.etcText);
        answers.add(
          WorkLogAnswerRequest(
            sectionId: sectionId,
            questionId: id,
            options: option == null ? const [] : [option],
          ),
        );
      case QuestionType.checkBox:
        final selection = checkboxSelections[id];
        final options = <WorkLogAnswerOption>[];
        if (selection != null) {
          for (final index in selection.indices) {
            final option = _optionAt(question, index, selection.etcText);
            if (option != null) options.add(option);
          }
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
            fileKey: fileKeys[id],
          ),
        );
    }
  }
  return answers;
}
