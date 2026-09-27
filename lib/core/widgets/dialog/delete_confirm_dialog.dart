import 'package:flutter/material.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

Future<bool> showDeleteConfirmDialog(BuildContext context) async {
  final confirmed = await showDialog<bool>(
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
            Text.rich(
              const TextSpan(
                children: [
                  TextSpan(text: '정말 '),
                  TextSpan(
                    text: '삭제',
                    style: TextStyle(color: ToyVillageColor.red),
                  ),
                  TextSpan(text: '하시겠습니까?'),
                ],
              ),
              style: ToyVillageTextStyle.heading6,
              textAlign: TextAlign.center,
            ),
            Text(
              '삭제한 후에는\n다시 복구할 수 없습니다.',
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
                    label: '취소',
                    background: ToyVillageColor.gray60,
                    textColor: ToyVillageColor.white,
                    onTap: () => Navigator.pop(ctx, false),
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: _button(
                    label: '삭제',
                    background: ToyVillageColor.white,
                    textColor: ToyVillageColor.red,
                    border: Border.all(color: ToyVillageColor.red),
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
  required Color textColor,
  required VoidCallback onTap,
  Border? border,
}) {
  return Material(
    color: background,
    borderRadius: BorderRadius.circular(8),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: border,
        ),
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
    ),
  );
}
