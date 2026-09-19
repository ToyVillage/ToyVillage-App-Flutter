import 'package:flutter/cupertino.dart';
import 'package:toy_village_app/core/constants/color.dart';

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
