import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/svg_assets.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/features/reservation/presentation/widget/reservation_text.dart';

class ReservationCard extends StatelessWidget {
  final String title;
  final String reservationName;
  final DateTime visitDate;
  final int reservationCount;
  final VoidCallback onTap;

  const ReservationCard({
    super.key,
    required this.title,
    required this.reservationName,
    required this.visitDate,
    required this.reservationCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: ToyVillageColor.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: ToyVillageTextStyle.heading3),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ReservationText(label: '예약인:   ', value: reservationName),
              ),
              ReservationText(
                label: '방문 시간:   ',
                value: '${visitDate.hour} : ${visitDate.minute}',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    ReservationText(
                      icon: SvgPicture.asset(SvgAssets.dateToday),
                      label: '방문일: ',
                      value: '${visitDate.month}월 ${visitDate.day}일',
                    ),
                    SizedBox(width: 12),
                    ReservationText(
                      icon: SvgPicture.asset(SvgAssets.people),
                      label: '전체인원: ',
                      value: '$reservationCount명',
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: ToyVillageColor.gray60)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.5),
                      child: Center(child: Text('더보기', style: ToyVillageTextStyle.button4.copyWith(color: ToyVillageColor.gray60),)),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
