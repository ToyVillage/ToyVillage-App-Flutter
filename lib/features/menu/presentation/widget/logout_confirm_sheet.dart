import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

Future<bool> showLogoutConfirmSheet(BuildContext context) async {
  final confirmed = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: ToyVillageColor.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                color: ToyVillageColor.gray100,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              '정말 로그아웃하시겠습니까?',
              style: ToyVillageTextStyle.heading6,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              '로그아웃하게 되면 다시 로그인 하기 전까지\n토이빌리지를 이용할 수 없어요',
              style: ToyVillageTextStyle.body5.copyWith(
                color: ToyVillageColor.gray60,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: _button(
                    label: '취소',
                    background: ToyVillageColor.gray60,
                    onTap: () => Navigator.pop(ctx, false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _button(
                    label: '로그아웃',
                    background: ToyVillageColor.red,
                    onTap: () => Navigator.pop(ctx, true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
  return confirmed == true;
}

Widget _button({
  required String label,
  required Color background,
  required VoidCallback onTap,
}) {
  return Material(
    color: background,
    borderRadius: BorderRadius.circular(8),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Center(
          child: Text(
            label,
            style: ToyVillageTextStyle.button4.copyWith(
              color: ToyVillageColor.white,
            ),
          ),
        ),
      ),
    ),
  );
}
