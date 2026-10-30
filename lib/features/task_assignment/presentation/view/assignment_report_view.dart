import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/button/toy_village_button.dart';
import 'package:toy_village_app/core/widgets/text_field/readonly_field.dart';

class AssignmentReportView extends StatelessWidget {
  const AssignmentReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ToyVillageAppBar(hasIcon: true),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            const SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 92),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ToyVillageReadonlyField(
                    label: '내용',
                    value: '배고픈 우현이에게 복숭아 500g을 줬어요',
                    minLines: 4,
                  ),
                  SizedBox(height: 24),
                  ToyVillageReadonlyField(
                    label: '특이사항',
                    value: '알러지가 올라왔어요',
                    minLines: 4,
                  ),
                ],
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 16,
              child: Row(
                children: [
                  Expanded(
                    child: ToyVillageButton.outlined(
                      label: '반려하기',
                      onTap: () => _showRejectDialog(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ToyVillageButton(
                      label: '승인하기',
                      onTap: () => context.pop(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRejectDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: ToyVillageColor.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '반려 사유를 입력해주세요',
                style: ToyVillageTextStyle.subTitle3,
              ),
              const SizedBox(height: 20),
              Container(
                height: 140,
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ToyVillageColor.gray10,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: ToyVillageTextStyle.body5,
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: '반려 사유 입력',
                    hintStyle: ToyVillageTextStyle.body5.copyWith(
                      color: ToyVillageColor.gray60,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(dialogContext).pop(),
                      child: Container(
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: ToyVillageColor.gray20,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '취소',
                          style: ToyVillageTextStyle.button4.copyWith(
                            color: ToyVillageColor.gray70,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(dialogContext).pop();
                        context.pop();
                      },
                      child: Container(
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: ToyVillageColor.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: ToyVillageColor.red),
                        ),
                        child: Text(
                          '반려',
                          style: ToyVillageTextStyle.button4.copyWith(
                            color: ToyVillageColor.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
