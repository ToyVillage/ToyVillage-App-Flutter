import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';

abstract final class ToyVillageTextStyle {
  /// Heading
  static TextStyle heading1 = defaultTextStyle.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w600,
  );

  static TextStyle heading2 = defaultTextStyle.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w600,
  );

  static TextStyle heading3 = defaultTextStyle.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static TextStyle heading4 = defaultTextStyle.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  static TextStyle heading5 = defaultTextStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static TextStyle heading6 = defaultTextStyle.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  /// SubTitle
  static TextStyle subTitle1 = defaultTextStyle.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );

  static TextStyle subTitle2 = defaultTextStyle.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w500,
  );

  static TextStyle subTitle3 = defaultTextStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static TextStyle subTitle4 = defaultTextStyle.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  /// Body
  static TextStyle body1 = defaultTextStyle.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );

  static TextStyle body2 = defaultTextStyle.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w500,
  );

  static TextStyle body3 = defaultTextStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static TextStyle body4 = defaultTextStyle.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static TextStyle body5 = defaultTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  /// Button
  static TextStyle button1 = defaultTextStyle.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w500,
  );

  static TextStyle button2 = defaultTextStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static TextStyle button3 = defaultTextStyle.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static TextStyle button4 = defaultTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static TextStyle button5 = defaultTextStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  /// Caption
  static TextStyle caption1 = defaultTextStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static TextStyle caption2 = defaultTextStyle.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static TextStyle caption3 = defaultTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static TextStyle caption4 = defaultTextStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  /// Calendar
  static TextStyle calendarWeek = defaultTextStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle calendarEnable = defaultTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static TextStyle calendarDisable = defaultTextStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
}

const TextStyle defaultTextStyle = TextStyle(
  fontFamily: 'WantedSans',
  color: ToyVillageColor.gray100,
);
