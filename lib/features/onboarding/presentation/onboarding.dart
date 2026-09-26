import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/svg_assets.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

Future<void> runOnboarding(BuildContext context) async {
  final start = await _showIntroSheet(context);
  if (start == true && context.mounted) {
    await _showCoach(context);
  }
}

Future<bool?> _showIntroSheet(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    useRootNavigator: true,
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
              '시작하기전 잠깐!',
              style: ToyVillageTextStyle.heading5,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              '시작하기전 잠깐 여러분의 서비스 적응을 돕기위한\n튜토리얼이 준비되어있어요',
              style: ToyVillageTextStyle.body5,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
            Row(
              children: [
                Expanded(
                  child: _sheetButton(
                    label: '건너뛰기',
                    background: ToyVillageColor.gray60,
                    onTap: () => Navigator.pop(ctx, false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _sheetButton(
                    label: '시작하기',
                    background: ToyVillageColor.blue,
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
}

Widget _sheetButton({
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

Future<void> _showCoach(BuildContext context) {
  return showGeneralDialog(
    context: context,
    useRootNavigator: true,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    pageBuilder: (_, _, _) => const _OnboardingCoach(),
  );
}

class _CoachStep {
  final String text;
  final TextAlign align;

  const _CoachStep(this.text, this.align);
}

const _steps = <_CoachStep>[
  _CoachStep(
    '공지사항에서는 토이빌리지 관리자가 등록한 \n공지사항을 확인할 수 있어요',
    TextAlign.left,
  ),
  _CoachStep(
    '휴무일정에서는 토이빌리지의 휴관 날짜와 \n영업시간을 확인 가능해요',
    TextAlign.left,
  ),
  _CoachStep(
    '업무확인에서 현재 자신이 받은 업무 목록을 조회하고 \n업무 보고서 작성이 가능해요',
    TextAlign.center,
  ),
  _CoachStep(
    '자료실에는 여러 토이빌리지 관련 자료들이 모여있어요',
    TextAlign.center,
  ),
  _CoachStep(
    '동물 확인, 업무일지 작성 등 더 많은 옵션은 \n메뉴에서 찾으실 수 있습니다',
    TextAlign.right,
  ),
];

class _OnboardingCoach extends StatefulWidget {
  const _OnboardingCoach();

  @override
  State<_OnboardingCoach> createState() => _OnboardingCoachState();
}

class _OnboardingCoachState extends State<_OnboardingCoach> {
  int _step = 0;

  void _next() {
    if (_step < _steps.length - 1) {
      setState(() => _step++);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_step];

    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _next,
        child: Stack(
          children: [
            const Positioned.fill(
              child: ColoredBox(color: Color(0xB3000000)),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: step.align == TextAlign.left ? 0 : 24,
                        right: step.align == TextAlign.right ? 0 : 24,
                      ),
                      child: Text(
                        step.text,
                        textAlign: step.align,
                        style: ToyVillageTextStyle.body5.copyWith(
                          color: ToyVillageColor.white,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _CoachBottomBar(currentIndex: _step),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoachNavItem {
  final String label;
  final String icon;

  const _CoachNavItem(this.label, this.icon);
}

const _coachItems = <_CoachNavItem>[
  _CoachNavItem('공지사항', SvgAssets.navMegaphone),
  _CoachNavItem('휴무일정', SvgAssets.navCalendar),
  _CoachNavItem('업무확인', SvgAssets.navTask),
  _CoachNavItem('자료실', SvgAssets.navFolder),
  _CoachNavItem('메뉴', SvgAssets.navMenu),
];

class _CoachBottomBar extends StatelessWidget {
  final int currentIndex;

  const _CoachBottomBar({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cellWidth = constraints.maxWidth / _coachItems.length;
            final boxWidth = cellWidth < 68 ? cellWidth : 68.0;
            return Stack(
              children: [
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: currentIndex * cellWidth + (cellWidth - boxWidth) / 2,
                  width: boxWidth,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: ToyVillageColor.gray20,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Row(
                  children: [
                    for (var i = 0; i < _coachItems.length; i++)
                      Expanded(
                        child: Opacity(
                          opacity: i == currentIndex ? 1 : 0.3,
                          child: _cell(_coachItems[i]),
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _cell(_CoachNavItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(item.icon, width: 24, height: 24),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: ToyVillageTextStyle.body5.copyWith(fontSize: 12),
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
