import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/notice/data/model/notice_detail_model.dart';

final noticeDetailViewModelProvider =
    AsyncNotifierProvider.family<NoticeDetailViewModel, NoticeDetailModel, int>(
      NoticeDetailViewModel.new,
    );

class NoticeDetailViewModel extends AsyncNotifier<NoticeDetailModel> {
  final int id;

  NoticeDetailViewModel(this.id);

  @override
  FutureOr<NoticeDetailModel> build() {
    return _dummyList.firstWhere((e) => e.id == id);
  }
}

final _dummyList = [
  NoticeDetailModel(
    id: 1,
    title: '1월 23일 휴관 공지사항',
    kind: '전체',
    content:
        '안녕하십니까. 직원 여러분께 공지합니다 0월 00일 토이빌리지 대구점은 몇몇 동물들의 건강상 악화로 휴관 합니다. 동물관리팀은 금일(0월 00일)까지 건강상태 체크 원활하게 이어질 수 있도록 해주시고 모든 직원분들은 일정표에 휴관일 변경 완료 하였으니 확인 부탁드립니다 안녕하십니까. 직원 여러분께 공지합니다 0월 00일 토이빌리지 대구점은 몇몇 동물들의 건강상 악화로 휴관 합니다. 동물관리팀은 금일(0월 00일)까지 건강상태 체크 원활하게 이어질 수 있도록 해주시고 모든 직원분들은 일정표에 휴관일 변경 완료 하였으니 확인 부탁드립니다 안녕하십니까. 직원 여러분께 공지합니다 0월 00일 토이빌리지 대구점은 몇몇 동물들의 건강상 악화로 휴관 합니다. 동물관리팀은 금일(0월 00일)까지 건강상태 체크 원활하게 이어질 수 있도록 해주시고 모든 직원분들은 일정표에 휴관일 변경 완료 하였으니 확인 부탁드립니다',
    createAt: DateTime.parse('2026-07-02'),
  ),
  NoticeDetailModel(
    id: 2,
    title: '3월 45일 휴관 공지사항',
    kind: '전체',
    content:
        '안녕하십니까. 직원 여러분께 공지합니다 0월 00일 토이빌리지 대구점은 몇몇 동물들의 건강상 악화로 휴관 합니다. 동물관리팀은 금일(0월 00일)까지 건강상태 체크 원활하게 이어질 수 있도록 해주시고 모든 직원분들은 일정표에 휴관일 변경 완료 하였으니 확인 부탁드립니다 안녕하십니까. 직원 여러분께 공지합니다 0월 00일 토이빌리지 대구점은 몇몇 동물들의 건강상 악화로 휴관 합니다. 동물관리팀은 금일(0월 00일)까지 건강상태 체크 원활하게 이어질 수 있도록 해주시고 모든 직원분들은 일정표에 휴관일 변경 완료 하였으니 확인 부탁드립니다 안녕하십니까. 직원 여러분께 공지합니다 0월 00일 토이빌리지 대구점은 몇몇 동물들의 건강상 악화로 휴관 합니다. 동물관리팀은 금일(0월 00일)까지 건강상태 체크 원활하게 이어질 수 있도록 해주시고 모든 직원분들은 일정표에 휴관일 변경 완료 하였으니 확인 부탁드립니다',
    createAt: DateTime.parse('2026-07-02'),
  ),
  NoticeDetailModel(
    id: 3,
    title: '5월 67일 휴관 공지사항',
    kind: '전체',
    content:
        '안녕하십니까. 직원 여러분께 공지합니다 0월 00일 토이빌리지 대구점은 몇몇 동물들의 건강상 악화로 휴관 합니다. 동물관리팀은 금일(0월 00일)까지 건강상태 체크 원활하게 이어질 수 있도록 해주시고 모든 직원분들은 일정표에 휴관일 변경 완료 하였으니 확인 부탁드립니다 안녕하십니까. 직원 여러분께 공지합니다 0월 00일 토이빌리지 대구점은 몇몇 동물들의 건강상 악화로 휴관 합니다. 동물관리팀은 금일(0월 00일)까지 건강상태 체크 원활하게 이어질 수 있도록 해주시고 모든 직원분들은 일정표에 휴관일 변경 완료 하였으니 확인 부탁드립니다 안녕하십니까. 직원 여러분께 공지합니다 0월 00일 토이빌리지 대구점은 몇몇 동물들의 건강상 악화로 휴관 합니다. 동물관리팀은 금일(0월 00일)까지 건강상태 체크 원활하게 이어질 수 있도록 해주시고 모든 직원분들은 일정표에 휴관일 변경 완료 하였으니 확인 부탁드립니다',
    createAt: DateTime.parse('2026-07-02'),
  ),
];
