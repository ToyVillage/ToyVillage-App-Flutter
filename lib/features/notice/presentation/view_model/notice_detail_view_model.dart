import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/notice/data/model/notice_detail_model.dart';
import 'package:toy_village_app/features/notice/data/repository/notice_detail_repository.dart';

final noticeDetailViewModelProvider =
    AsyncNotifierProvider.family<NoticeDetailViewModel, NoticeDetailModel, int>(
      NoticeDetailViewModel.new,
    );

class NoticeDetailViewModel extends AsyncNotifier<NoticeDetailModel> {
  final int id;

  NoticeDetailViewModel(this.id);

  @override
  FutureOr<NoticeDetailModel> build() {
    return ref.read(noticeDetailRepositoryProvider).loadDetailNotice(id: id);
  }
}
