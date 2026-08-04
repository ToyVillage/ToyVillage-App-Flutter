import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/daily_log/data/model/daily_log.dart';

final dailyLogRepositoryProvider = Provider((ref) => DailyLogRepository());

class DailyLogRepository {
  List<DailyLog> seed() {
    final now = DateTime.now();
    return [
      DailyLog(
        id: 1,
        templateName: '먹이급여일지',
        content: '오전 급여 완료. 잔량 없음.',
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      DailyLog(
        id: 2,
        templateName: '사육장점검일지',
        content: '온도 및 습도 정상 범위 확인.',
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
      DailyLog(
        id: 3,
        templateName: '마감일지',
        content: '출입문 잠금 및 소등 완료.',
        createdAt: now.subtract(const Duration(hours: 8)),
      ),
    ];
  }
}
