import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/svg_assets.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/dropdown/menu_dropdown.dart';
import 'package:toy_village_app/core/widgets/text/label.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/core/widgets/text_field/readonly_field.dart';

class FeedView extends StatelessWidget {
  final String speciesName;
  final String category;

  const FeedView({
    super.key,
    required this.speciesName,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ToyVillageAppBar(hasIcon: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      const Expanded(child: ToyVillageTitle(title: '먹이 급여 정보')),
                      MenuDropdown(
                        items: [
                          MenuDropdownItem(
                            label: '수정',
                            onTap: () => context.push(
                              '/feed-writing/write',
                              extra: (
                                speciesName: speciesName,
                                category: category,
                                isEdit: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _section('급여 날짜', _dateBox('2026.08.27')),
                _section(
                  '급여 시간',
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _timeBox('시작 시각', '10 : 00 AM')),
                      const SizedBox(width: 12),
                      Expanded(child: _timeBox('종료 시각', '11 : 00 AM')),
                    ],
                  ),
                ),
                ToyVillageReadonlyField(
                  label: '대상 개체',
                  value: '${speciesName}1',
                ),
                const ToyVillageReadonlyField(label: '먹이 종류', value: '건초'),
                _section('먹이 급여량', _amountBox('120', 'g / ml')),
                const ToyVillageReadonlyField(label: '특이사항', value: '잘 먹었음'),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ToyVillageLabel(label: label),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _box({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ToyVillageColor.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }

  Widget _dateBox(String value) {
    return _box(
      child: Row(
        children: [
          SvgPicture.asset(SvgAssets.dateToday),
          const SizedBox(width: 8),
          Text(
            value,
            style: ToyVillageTextStyle.body5.copyWith(
              color: ToyVillageColor.gray100,
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeBox(String label, String value) {
    return _box(
      child: Row(
        children: [
          SvgPicture.asset(SvgAssets.clock),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: ToyVillageTextStyle.caption5.copyWith(
                  color: ToyVillageColor.gray60,
                ),
              ),
              Text(
                value,
                style: ToyVillageTextStyle.body5.copyWith(
                  color: ToyVillageColor.gray100,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _amountBox(String amount, String unit) {
    return _box(
      child: Row(
        children: [
          Expanded(
            child: Text(
              amount,
              style: ToyVillageTextStyle.body5.copyWith(
                color: ToyVillageColor.gray100,
              ),
            ),
          ),
          Text(
            unit,
            style: ToyVillageTextStyle.body5.copyWith(
              color: ToyVillageColor.gray60,
            ),
          ),
        ],
      ),
    );
  }
}
