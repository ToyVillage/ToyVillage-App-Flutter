import 'package:toy_village_app/features/daily_log/data/model/question_type.dart';

class DailyLogTemplate {
  final int templateId;
  final String templateTitle;
  final List<TemplateSection> sections;
  final List<TemplateQuestion> questions;

  const DailyLogTemplate({
    required this.templateId,
    required this.templateTitle,
    required this.sections,
    required this.questions,
  });

  factory DailyLogTemplate.fromJson(Map<String, dynamic> json) {
    return DailyLogTemplate(
      templateId: json['templateId'] as int,
      templateTitle: json['templateTitle'] as String,
      sections: (json['sections'] as List)
          .map((e) => TemplateSection.fromJson(e as Map<String, dynamic>))
          .toList(),
      questions: (json['questions'] as List)
          .map((e) => TemplateQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class TemplateSection {
  final int sectionId;
  final String sectionName;

  const TemplateSection({required this.sectionId, required this.sectionName});

  factory TemplateSection.fromJson(Map<String, dynamic> json) {
    return TemplateSection(
      sectionId: json['sectionId'] as int,
      sectionName: json['sectionName'] as String,
    );
  }
}

class TemplateQuestion {
  final int questionId;
  final String question;
  final QuestionType questionType;
  final bool required;
  final List<QuestionOption> options;

  const TemplateQuestion({
    required this.questionId,
    required this.question,
    required this.questionType,
    required this.required,
    required this.options,
  });

  factory TemplateQuestion.fromJson(Map<String, dynamic> json) {
    return TemplateQuestion(
      questionId: json['questionId'] as int,
      question: json['question'] as String,
      questionType: QuestionType.fromCode(json['questionType'] as String),
      required: json['required'] as bool,
      options: (json['options'] as List)
          .map((e) => QuestionOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class QuestionOption {
  final int choiceId;
  final int number;
  final String content;
  final bool etcOption;

  const QuestionOption({
    required this.choiceId,
    required this.number,
    required this.content,
    required this.etcOption,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      choiceId: json['choiceId'] as int,
      number: json['number'] as int,
      content: json['content'] as String,
      etcOption: json['etcOption'] as bool,
    );
  }
}
