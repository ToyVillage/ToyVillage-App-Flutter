import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

Future<bool> showPasswordChangeDialog(BuildContext context) async {
  final goChange = await showDialog<bool>(
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: ToyVillageColor.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 31),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '비밀번호를 변경해주세요',
              style: ToyVillageTextStyle.heading6,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '계정을 안전하게 지키기 위해\n비밀번호를 다시 설정해주세요',
              style: ToyVillageTextStyle.body5.copyWith(
                color: ToyVillageColor.gray60,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _button(
                    label: '다음에 할게요',
                    background: ToyVillageColor.gray60,
                    textColor: ToyVillageColor.white,
                    onTap: () => Navigator.pop(ctx, false),
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: _button(
                    label: '변경하러 가기',
                    background: ToyVillageColor.blue,
                    textColor: ToyVillageColor.white,
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
  return goChange == true;
}

Widget _button({
  required String label,
  required Color background,
  required Color textColor,
  required VoidCallback onTap,
}) {
  return Material(
    color: background,
    borderRadius: BorderRadius.circular(8),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.5),
        child: Center(
          child: Text(
            label,
            style: ToyVillageTextStyle.button4.copyWith(color: textColor),
          ),
        ),
      ),
    ),
  );
}
