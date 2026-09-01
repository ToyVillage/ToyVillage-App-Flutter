import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/daily_log/data/model/daily_log_template.dart';
import 'package:toy_village_app/features/daily_log/data/model/question_type.dart';

final dailyLogTemplateViewModelProvider =
    AsyncNotifierProvider.family<
      DailyLogTemplateViewModel,
      DailyLogTemplate,
      int
    >(DailyLogTemplateViewModel.new);

class DailyLogTemplateViewModel extends AsyncNotifier<DailyLogTemplate> {
  final int id;

  DailyLogTemplateViewModel(this.id);

  @override
  FutureOr<DailyLogTemplate> build() {
    return DailyLogTemplate(
      templateId: id,
      templateTitle: '먹이급여일지',
      sections: const [
        TemplateSection(sectionId: 1, sectionName: 'A1'),
        TemplateSection(sectionId: 2, sectionName: 'A2'),
        TemplateSection(sectionId: 3, sectionName: 'A3'),
        TemplateSection(sectionId: 4, sectionName: 'A4'),
        TemplateSection(sectionId: 5, sectionName: 'B1'),
        TemplateSection(sectionId: 6, sectionName: 'B2'),
        TemplateSection(sectionId: 7, sectionName: 'B3'),
        TemplateSection(sectionId: 8, sectionName: 'B4'),
      ],
      questions: const [
        TemplateQuestion(
          questionId: 10,
          question: '오늘 급여한 사료 종류는?',
          questionType: QuestionType.multipleChoice,
          required: true,
          options: [
            QuestionOption(
              choiceId: 100,
              number: 0,
              content: '건초',
              etcOption: false,
            ),
            QuestionOption(
              choiceId: 101,
              number: 1,
              content: '기타',
              etcOption: true,
            ),
          ],
        ),
        TemplateQuestion(
          questionId: 11,
          question: '급여 시 확인한 항목을 모두 선택해주세요.',
          questionType: QuestionType.checkBox,
          required: false,
          options: [
            QuestionOption(
              choiceId: 200,
              number: 0,
              content: '수분 상태',
              etcOption: false,
            ),
            QuestionOption(
              choiceId: 201,
              number: 1,
              content: '섭취량',
              etcOption: false,
            ),
            QuestionOption(
              choiceId: 202,
              number: 2,
              content: '기타',
              etcOption: true,
            ),
          ],
        ),
        TemplateQuestion(
          questionId: 12,
          question: '급여 시간대를 선택해주세요.',
          questionType: QuestionType.dropDown,
          required: true,
          options: [
            QuestionOption(
              choiceId: 300,
              number: 0,
              content: '오전',
              etcOption: false,
            ),
            QuestionOption(
              choiceId: 301,
              number: 1,
              content: '오후',
              etcOption: false,
            ),
            QuestionOption(
              choiceId: 302,
              number: 2,
              content: '저녁',
              etcOption: false,
            ),
          ],
        ),
        TemplateQuestion(
          questionId: 13,
          question: '급여 담당자 이름',
          questionType: QuestionType.shortText,
          required: true,
          options: [],
        ),
        TemplateQuestion(
          questionId: 14,
          question: '특이사항을 작성해주세요.',
          questionType: QuestionType.longText,
          required: false,
          options: [],
        ),
        TemplateQuestion(
          questionId: 15,
          question: '급여 사진을 첨부해주세요.',
          questionType: QuestionType.fileUpload,
          required: false,
          options: [],
        ),
      ],
    );
  }
}
