import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/svg_assets.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/utils/time_util.dart';
import 'package:toy_village_app/core/widgets/app_bar.dart';
import 'package:toy_village_app/core/widgets/custom_async_value.dart';
import 'package:toy_village_app/core/widgets/title.dart';
import 'package:toy_village_app/features/reservation/presentation/view_model/reservation_detail_view_model.dart';
import 'package:toy_village_app/features/reservation/presentation/widget/reservation_text.dart';

class ReservationDetailView extends ConsumerWidget {
  final int id;

  const ReservationDetailView({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: ToyVillageAppBar(closeIcon: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomAsyncValue(
          value: ref.watch(reservationDetailViewModelProvider(id)),
          data: (detail) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ToyVillageTitle(
                  title: '대구 유치원', // TODO: 백엔드 수정되면 변경
                  subTitle: '예약인 : ${detail.reservationName}',
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 28),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ToyVillageColor.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('인원 정보', style: ToyVillageTextStyle.heading3),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: ReservationText(
                              icon: SvgPicture.asset(SvgAssets.book),
                              label: '대표자: ',
                              value: detail.reservationName,
                            ),
                          ),
                          ReservationText(
                            label: '인솔자 인원: ',
                            value: '${detail.leaderCount}명',
                            icon: SvgPicture.asset(SvgAssets.flag),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: ReservationText(
                              label: '사전 답사 인원: ',
                              value: '${detail.visitSiteCount}명',
                              icon: SvgPicture.asset(SvgAssets.people),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: ReservationText(
                              label: '전체 인원: ',
                              value: '${detail.reservationCount}명',
                              icon: SvgPicture.asset(SvgAssets.people),
                            ),
                          ),
                          ReservationText(
                            label: '위치: ',
                            value: detail.location,
                            icon: SvgPicture.asset(SvgAssets.location),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ToyVillageColor.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text('날짜', style: ToyVillageTextStyle.heading3),
                        ),
                        ReservationText(
                          label: '예약일: ',
                          value: '7월 12일',
                          icon: SvgPicture.asset(SvgAssets.dateToday),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: ReservationText(
                            label: '방문일: ',
                            value:
                                '${detail.visitDate.month}월 ${detail.visitDate.day}일',
                            icon: SvgPicture.asset(SvgAssets.dateToday),
                          ),
                        ),
                        ReservationText(
                          label: '사전 답사일: ',
                          value:
                              '${detail.visitSiteDate.month}월 ${detail.visitSiteDate.day}일',
                          icon: SvgPicture.asset(SvgAssets.dateToday),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: ReservationText(
                            label: '예약 시간: ',
                            value: '0 : 00', // TODO: 백엔드 수정되면 변경
                            icon: SvgPicture.asset(SvgAssets.clockCheck),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ReservationText(
                            label: '입장 시간: ',
                            value: '9 : 41', // TODO: 백엔드 수정되면 변경
                            icon: SvgPicture.asset(SvgAssets.clock),
                          ),
                        ),
                        ReservationText(
                          label: '퇴장 시간: ',
                          value: formatTime(detail.exitTime),
                          icon: SvgPicture.asset(SvgAssets.out),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ToyVillageColor.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('입장료', style: ToyVillageTextStyle.heading3),
                        SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: ToyVillageColor.gray10,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '200,000',
                                  style: ToyVillageTextStyle.heading3,
                                ),
                                SizedBox(width: 8),
                                Text('원', style: ToyVillageTextStyle.subTitle4),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
