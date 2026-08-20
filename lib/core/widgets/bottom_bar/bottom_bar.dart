import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/svg_assets.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

const double kBottomBarHeight = 70;

class _NavItem {
  final String label;
  final String icon;

  const _NavItem(this.label, this.icon);
}

const _items = <_NavItem>[
  _NavItem('공지사항', SvgAssets.navMegaphone),
  _NavItem('휴관일정', SvgAssets.navCalendar),
  _NavItem('업무확인', SvgAssets.navTask),
  _NavItem('자료실', SvgAssets.navFolder),
  _NavItem('메뉴', SvgAssets.navMenu),
];

class ToyVillageBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const ToyVillageBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final cellWidth = constraints.maxWidth / _items.length;
                    final boxWidth = cellWidth < 68 ? cellWidth : 68.0;
                    return Stack(
                      children: [
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          top: 0,
                          bottom: 0,
                          left:
                              currentIndex * cellWidth +
                              (cellWidth - boxWidth) / 2,
                          width: boxWidth,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: ToyVillageColor.gray20.withValues(
                                alpha: 0.8,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            for (var i = 0; i < _items.length; i++)
                              Expanded(
                                child: _Item(
                                  item: _items[i],
                                  onTap: () => onTap(i),
                                ),
                              ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final _NavItem item;
  final VoidCallback onTap;

  const _Item({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
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
      ),
    );
  }
}
