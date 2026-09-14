import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/button/toy_village_button.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/features/entity_info/presentation/widget/info_label.dart';

class EntityDetailView extends StatelessWidget {
  final String entityName;

  const EntityDetailView({super.key, required this.entityName});

  @override
  Widget build(BuildContext context) {
    const noteContent = '식욕이 평소보다 줄어 사육사가 경과를 지켜보고 있습니다.';

    return Scaffold(
      appBar: const ToyVillageAppBar(hasIcon: true),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ToyVillageTitle(title: entityName),
                    const SizedBox(height: 28),
                    Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        color: ToyVillageColor.gray20,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const InfoLabel(label: '나이', value: '3살'),
                    const InfoLabel(label: '성별', value: '수컷'),
                    const InfoLabel(label: '출생년도', value: '2009년'),
                    const InfoLabel(label: '기타정보', value: '생각보다 크고 우리 애는 물어요'),
                    const SizedBox(height: 28),
                    Text(
                      '최근 특이사항',
                      style: ToyVillageTextStyle.caption4.copyWith(
                        color: ToyVillageColor.gray60,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _NoteCard(
                      content: noteContent,
                      onTap: () => context.push(
                        '/entity-info/note',
                        extra: (entityName: entityName, content: noteContent),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 16,
              child: ToyVillageButton(
                label: '특이사항 작성하기',
                onTap: () => context.push(
                  '/entity-info/note-write',
                  extra: (entityName: entityName),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final String content;
  final VoidCallback onTap;

  const _NoteCard({required this.content, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: ToyVillageColor.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                content,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: ToyVillageTextStyle.body5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
