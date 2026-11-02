import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/svg_assets.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/features/menu/presentation/widget/logout_confirm_sheet.dart';
import 'package:toy_village_app/features/notification/presentation/fcm_token_sync.dart';
import 'package:toy_village_app/features/menu/presentation/widget/menu_card.dart';

class MenuView extends ConsumerWidget {
  const MenuView({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showLogoutConfirmSheet(context);
    if (!confirmed) return;
    await ref.read(fcmTokenSyncProvider).clear();
    await ref.read(tokenStoreProvider).clear();
    if (!context.mounted) return;
    context.go('/login');
  }

  String _roleLabel(String? role) {
    switch (role) {
      case 'EMPLOYEE':
        return '사원';
      case 'MIDDLE_ADMIN':
      case 'APP_ADMIN':
        return '관리자';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.read(tokenStoreProvider);
    final isMiddleAdmin = store.role == 'MIDDLE_ADMIN';
    final name = store.name ?? '';
    final displayName = [
      name,
      _roleLabel(store.role),
    ].where((part) => part.isNotEmpty).join(' ');
    return Scaffold(
      appBar: const ToyVillageAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: ToyVillageColor.gray20,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        name.isEmpty ? '' : name.characters.first,
                        style: ToyVillageTextStyle.subTitle3.copyWith(
                          color: ToyVillageColor.gray70,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(displayName, style: ToyVillageTextStyle.subTitle2),
                  ],
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
                      if (isMiddleAdmin)
                        MenuCard(
                          icon: SvgAssets.navTask,
                          title: '업무 관리',
                          onTap: () => context.push('/task-assignment'),
                        ),
                      MenuCard(
                        icon: SvgAssets.lock,
                        title: '비밀번호 변경하기',
                        onTap: () => context.push('/password'),
                      ),
                      MenuCard(
                        icon: SvgAssets.signOut,
                        title: '로그아웃',
                        titleColor: ToyVillageColor.red,
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
