import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/constants/svg_assets.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/features/menu/presentation/widget/logout_confirm_sheet.dart';
import 'package:toy_village_app/features/menu/presentation/widget/menu_card.dart';

class MenuView extends ConsumerWidget {
  const MenuView({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showLogoutConfirmSheet(context);
    if (!confirmed || !context.mounted) return;
    ref.read(tokenStoreProvider).accessToken = null;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    children: [
                      MenuCard(
                        icon: SvgAssets.check,
                        title: '업무일지 작성하기',
                        onTap: () => context.push('/daily-log'),
                      ),
                      MenuCard(
                        icon: SvgAssets.bookFilled,
                        title: '단체예약 확인하기',
                        onTap: () => context.push('/reservation'),
                      ),
                      MenuCard(
                        icon: SvgAssets.pawPrint,
                        title: '동물 확인하기',
                        onTap: () => context.push('/entity-info'),
                      ),
                      MenuCard(
                        icon: SvgAssets.meat,
                        title: '먹이 급여 작성하기',
                        onTap: () => context.push('/feed-writing'),
                      ),
                      MenuCard(
                        icon: SvgAssets.meatBook,
                        title: '먹이 급여 기록 확인하기',
                        onTap: () => context.push('/feed-info'),
                      ),
                      MenuCard(
                        icon: SvgAssets.lock,
                        title: '비밀번호 변경하기',
                        onTap: () => context.push('/password'),
                      ),
                      MenuCard(
                        icon: SvgAssets.signOut,
                        title: '로그아웃',
                        onTap: () => _logout(context, ref),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
