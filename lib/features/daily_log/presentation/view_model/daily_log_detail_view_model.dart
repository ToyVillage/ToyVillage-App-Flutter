import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/daily_log/data/model/daily_log_detail.dart';
import 'package:toy_village_app/features/daily_log/data/model/question_type.dart';
import 'package:toy_village_app/features/task/data/model/report_attachment.dart';

final dailyLogDetailViewModelProvider =
    AsyncNotifierProvider.family<DailyLogDetailViewModel, DailyLogDetail, int>(
      DailyLogDetailViewModel.new,
    );

class DailyLogDetailViewModel extends AsyncNotifier<DailyLogDetail> {
  final int id;

  DailyLogDetailViewModel(this.id);

  @override
  FutureOr<DailyLogDetail> build() {
    return DailyLogDetail(
      workLogId: id,
      templateId: 1,
      templateTitle: '먹이급여일지',
      writerName: '이승현',
      writeAt: DateTime(2026, 8, 8, 12),
      sections: [
        AnswerSection(
          sectionId: 1,
          sectionName: 'A1',
          answers: [
            const Answer(
              questionId: 10,
              question: '오늘 급여한 사료 종류는?',
              questionType: QuestionType.multipleChoice,
              answerText: '건초',
            ),
            const Answer(
              questionId: 11,
              question: '특이사항을 작성해주세요.',
              questionType: QuestionType.longText,
              answerText: '식욕이 왕성했고 특이사항 없음.',
            ),
            Answer(
              questionId: 12,
              question: '급여 사진을 첨부해주세요.',
              questionType: QuestionType.fileUpload,
              file: ReportAttachment(
                fileName: 'feed.png',
                fileKey: 'work-log/feed.png',
              ),
            ),
          ],
        ),
        const AnswerSection(sectionId: 2, sectionName: 'A2', answers: []),
      ],
    );
  }
}
