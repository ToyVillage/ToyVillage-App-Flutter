import 'package:flutter/cupertino.dart';
import 'package:toy_village_app/core/constants/color.dart';

/// 데이터 조회 시 사용하는 공통 로딩 스피너(iOS 스타일).
class AppLoadingIndicator extends StatelessWidget {
  final double radius;

  const AppLoadingIndicator({super.key, this.radius = 14});

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(
      radius: radius,
      color: ToyVillageColor.gray60,
    );
  }
}
