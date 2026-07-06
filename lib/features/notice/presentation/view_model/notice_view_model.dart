import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/notice/data/model/notice_model.dart';

final noticeViewModelProvider =
    AsyncNotifierProvider<NoticeViewModel, List<NoticeModel>>(
      () => NoticeViewModel(),
    );

class NoticeViewModel extends AsyncNotifier<List<NoticeModel>> {
  @override
  FutureOr<List<NoticeModel>> build() {
    return [
      NoticeModel(
        id: 1,
        title: '0월 00일 휴관 안내사항',
        kind: '전체',
        createAt: DateTime.parse('2025-07-02'),
      ),
      NoticeModel(
        id: 2,
        title: '0월 00일 휴관 안내사항',
        kind: '전체',
        createAt: DateTime.parse('2025-07-02'),
      ),
      NoticeModel(
        id: 3,
        title: '0월 00일 휴관 안내사항',
        kind: '전체',
        createAt: DateTime.parse('2025-07-02'),
      ),
    ];
  }
}
