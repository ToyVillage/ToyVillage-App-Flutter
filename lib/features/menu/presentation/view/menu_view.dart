import 'package:flutter/material.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ToyVillageAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Padding(
                padding: EdgeInsets.only(bottom: 22),
                child: ToyVillageTitle(
                  title: '메뉴',
                  subTitle: '토이빌리지의 여러 기능을 확인합니다',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
