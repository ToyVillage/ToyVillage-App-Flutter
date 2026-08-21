import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/constants/svg_assets.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/features/menu/presentation/widget/menu_card.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ToyVillageAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: ToyVillageTitle(
                  title: '메뉴',
                  subTitle: '토이빌리지의 더 많은 기능들',
                ),
              ),
              MenuCard(
                icon: SvgAssets.check,
                title: '업무일지 작성하기',
                onTap: () {
                  context.push('/dailyLog');
                },
              ),
              MenuCard(
                icon: SvgAssets.bookFilled,
                title: '단체예약 확인하기',
                onTap: () {
                  context.push('/reservation');
                },
              ),
              MenuCard(
                icon: SvgAssets.pawPrint,
                title: '개체 관리하기',
                onTap: () {
                  // TODO: 개체 관리 페이지 연결
                },
              ),
              MenuCard(
                icon: SvgAssets.meat,
                title: '먹이 급여 작성하기',
                onTap: () {
                  // TODO: 먹이 급여 페이지 연결
                },
              ),
              MenuCard(
                icon: SvgAssets.lock,
                title: '비밀번호 변경하기',
                onTap: () {
                  // TODO: 비밀번호 페이지 변경
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
