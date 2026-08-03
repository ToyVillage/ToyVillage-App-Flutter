import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/task/data/model/task_detail_model.dart';

final taskDetailRepositoryProvider =
    Provider((ref) => TaskDetailRepository());

class TaskDetailRepository {
  Future<TaskDetailModel> loadTaskDetail({required int id}) async {
    final now = DateTime.now();

    final dummies = <int, Map<String, dynamic>>{
      1: {
        'id': 1,
        'title': '카피바라 사육장 청소',
        'content': '오전 중으로 카피바라 사육장 바닥 청소와 배수구 점검을 완료해 주세요.오전 중으로 카피바라 사육장 바닥 청소와 배수구 점검을 완료해 주세요.오전 중으로 카피바라 사육장 바닥 청소와 배수구 점검을 완료해 주세요.',
        'priority': 'HIGH',
        'status': 'NOT_SUBMITTED',
        'deadline': now.add(const Duration(days: 3)).toIso8601String(),
        'createdAt': now.subtract(const Duration(hours: 3)).toIso8601String(),
        'files': const [],
      },
      2: {
        'id': 2,
        'title': '기린 먹이 주기',
        'content': '기린 방사장 사료 급여 후 잔량을 기록하고 사진을 첨부해 보고합니다.기린 방사장 사료 급여 후 잔량을 기록하고 사진을 첨부해 보고합니다.기린 방사장 사료 급여 후 잔량을 기록하고 사진을 첨부해 보고합니다.기린 방사장 사료 급여 후 잔량을 기록하고 사진을 첨부해 보고합니다.기린 방사장 사료 급여 후 잔량을 기록하고 사진을 첨부해 보고합니다.기린 방사장 사료 급여 후 잔량을 기록하고 사진을 첨부해 보고합니다.기린 방사장 사료 급여 후 잔량을 기록하고 사진을 첨부해 보고합니다.기린 방사장 사료 급여 후 잔량을 기록하고 사진을 첨부해 보고합니다.기린 방사장 사료 급여 후 잔량을 기록하고 사진을 첨부해 보고합니다.기린 방사장 사료 급여 후 잔량을 기록하고 사진을 첨부해 보고합니다.기린 방사장 사료 급여 후 잔량을 기록하고 사진을 첨부해 보고합니다.기린 방사장 사료 급여 후 잔량을 기록하고 사진을 첨부해 보고합니다.',
        'priority': 'MEDIUM',
        'status': 'NOT_SUBMITTED',
        'deadline': now.subtract(const Duration(hours: 1)).toIso8601String(),
        'createdAt': now.subtract(const Duration(hours: 5)).toIso8601String(),
        'files': [
          {
            'fileName': 'Screenshot_2019-07-07-10-30-092.jpg',
            'fileKey':
                'f9ebdba3-996d-4800-907f-7865ac7186a9_Screenshot_2019-07-07-10-30-092.jpg',
          },
          {
            'fileName': '26.07.27 4차 답변.pdf',
            'fileKey':
                '5efd5194-8947-45ba-9168-97804f3cfbd7_26.07.27 4차 답변.pdf',
          },
        ],
      },
      3: {
        'id': 3,
        'title': '펭귄관 온도 점검',
        'content': '펭귄관 수조 온도를 점검하고 이상 시 즉시 보고해 주세요.펭귄관 수조 온도를 점검하고 이상 시 즉시 보고해 주세요.펭귄관 수조 온도를 점검하고 이상 시 즉시 보고해 주세요.펭귄관 수조 온도를 점검하고 이상 시 즉시 보고해 주세요.펭귄관 수조 온도를 점검하고 이상 시 즉시 보고해 주세요.펭귄관 수조 온도를 점검하고 이상 시 즉시 보고해 주세요.',
        'priority': 'LOW',
        'status': 'REJECTED',
        'deadline': now.add(const Duration(days: 1)).toIso8601String(),
        'createdAt': now.subtract(const Duration(days: 1)).toIso8601String(),
        'files': const [],
      },
      4: {
        'id': 4,
        'title': '수달 먹이 준비',
        'content': '수달 먹이 손질 후 급여를 완료했습니다.수달 먹이 손질 후 급여를 완료했습니다.수달 먹이 손질 후 급여를 완료했습니다.수달 먹이 손질 후 급여를 완료했습니다.',
        'priority': 'HIGH',
        'status': 'COMPLETED',
        'deadline': now.subtract(const Duration(days: 1)).toIso8601String(),
        'createdAt': now.subtract(const Duration(days: 2)).toIso8601String(),
        'files': [
          {
            'fileName': '26.07.27 4차 답변.pdf',
            'fileKey':
                '5efd5194-8947-45ba-9168-97804f3cfbd7_26.07.27 4차 답변.pdf',
          },
        ],
      },
    };

    final data = dummies[id] ?? dummies[1]!;
    return TaskDetailModel.fromJson(data);
  }
}
