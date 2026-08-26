import 'package:flutter/material.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/features/entity_info/presentation/widget/info_label.dart';

class EntityInfoDetailView extends StatelessWidget {
  final int id;

  const EntityInfoDetailView({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ToyVillageAppBar(hasIcon: true,),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ToyVillageTitle(title: '동식이', subTitle: '카피바라  포유류',),
            SizedBox(height: 20),
            InfoLabel(label: '개체명', value: '카피바라'),
            InfoLabel(label: '학명', value: '카피바라'),
            InfoLabel(label: '분류군', value: '카피바라'),
            InfoLabel(label: '법정지정분류', value: '카피바라'),
            InfoLabel(label: '마리수', value: '카피바라'),
            InfoLabel(label: '나이', value: '카피바라'),
            InfoLabel(label: '성별', value: '카피바라'),
            InfoLabel(label: '출생년도', value: '카피바라'),
            InfoLabel(label: '기타정보', value: '카피바라'),
          ],
        ),
      ),
    );
  }
}
