import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

class DateInfo extends StatelessWidget {
  final String title;
  final String? content;
  final String? operatingHours;
  final String? errorMessage;
  final String emptyMessage;

  const DateInfo({
    super.key,
    required this.title,
    this.content,
    this.operatingHours,
    this.errorMessage,
    this.emptyMessage = '일정이 없습니다.',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ToyVillageColor.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: ToyVillageTextStyle.body4.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    errorMessage!,
                    style: ToyVillageTextStyle.caption4.copyWith(
                      color: ToyVillageColor.gray60,
                    ),
                  ),
                ),
              )
            else if (content != null)
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 7),
                child: Text(content!, style: ToyVillageTextStyle.body5),
              )
            else if (content == null && operatingHours == null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(child: Text(emptyMessage, style: ToyVillageTextStyle.caption4.copyWith(color: ToyVillageColor.gray60),),),
              ),
            if (operatingHours != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(operatingHours!, style: ToyVillageTextStyle.body3),
              ),
          ],
        ),
      ),
    );
  }
}
