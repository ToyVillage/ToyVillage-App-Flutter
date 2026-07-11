import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

class CustomAsyncValue<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T) data;
  final Widget? loading;
  final String errorMessage;

  const CustomAsyncValue({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.errorMessage = '문제가 발생했어요.\n잠시 후 다시 시도해주세요.',
  });

  @override
  Widget build(BuildContext context) {
    return switch (value) {
      AsyncData(:final value) => data(value),
      AsyncLoading() =>
        loading ??
            const Align(
              alignment: Alignment(0, -0.1),
              child: CircularProgressIndicator(color: ToyVillageColor.gray60),
            ),
      AsyncError() => Align(
        alignment: const Alignment(0, -0.1),
        child: Text(
          errorMessage,
          textAlign: TextAlign.center,
          style: ToyVillageTextStyle.body2.copyWith(
            color: ToyVillageColor.gray60,
          ),
        ),
      ),
    };
  }
}
