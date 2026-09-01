import 'package:toy_village_app/features/daily_log/data/model/question_type.dart';
import 'package:toy_village_app/features/task/data/model/report_attachment.dart';

class DailyLogDetail {
  final int workLogId;
  final int templateId;
  final String templateTitle;
  final String writerName;
  final DateTime writeAt;
  final List<AnswerSection> sections;

  const DailyLogDetail({
    required this.workLogId,
    required this.templateId,
    required this.templateTitle,
    required this.writerName,
    required this.writeAt,
    required this.sections,
  });

  factory DailyLogDetail.fromJson(Map<String, dynamic> json) {
    return DailyLogDetail(
      workLogId: json['workLogId'] as int,
      templateId: json['templateId'] as int,
      templateTitle: json['templateTitle'] as String,
      writerName: json['writerName'] as String,
      writeAt: DateTime.parse(json['writeAt'] as String),
      sections: (json['sections'] as List)
          .map((e) => AnswerSection.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class AnswerSection {
  final int sectionId;
  final String sectionName;
  final List<Answer> answers;

  const AnswerSection({
    required this.sectionId,
    required this.sectionName,
    required this.answers,
  });

  factory AnswerSection.fromJson(Map<String, dynamic> json) {
    return AnswerSection(
      sectionId: json['sectionId'] as int,
      sectionName: json['sectionName'] as String,
      answers: (json['answers'] as List)
          .map((e) => Answer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Answer {
  final int questionId;
  final String question;
  final QuestionType questionType;
  final String? answerText;
  final ReportAttachment? file;

  const Answer({
    required this.questionId,
    required this.question,
    required this.questionType,
    this.answerText,
    this.file,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    final file = json['file'];
    return Answer(
      questionId: json['questionId'] as int,
      question: json['question'] as String,
      questionType: QuestionType.fromCode(json['questionType'] as String),
      answerText: json['answerText'] as String?,
      file: file == null
          ? null
          : ReportAttachment.fromJson(file as Map<String, dynamic>),
    );
  }
}
