import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/utils/file_url.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/button/toy_village_button.dart';
import 'package:toy_village_app/core/widgets/custom_async_value.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/features/entity_info/data/model/animal_detail.dart';
import 'package:toy_village_app/features/entity_info/data/model/observation.dart';
import 'package:toy_village_app/features/entity_info/data/model/paged_list.dart';
import 'package:toy_village_app/features/entity_info/presentation/view_model/animal_detail_view_model.dart';
import 'package:toy_village_app/features/entity_info/presentation/view_model/observation_list_view_model.dart';
import 'package:toy_village_app/features/entity_info/presentation/widget/info_label.dart';

class EntityDetailView extends ConsumerWidget {
  final int animalManageId;

  const EntityDetailView({super.key, required this.animalManageId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const ToyVillageAppBar(hasIcon: true),
      body: SafeArea(
        child: CustomAsyncValue(
          value: ref.watch(animalDetailViewModelProvider(animalManageId)),
          onRetry: () =>
              ref.invalidate(animalDetailViewModelProvider(animalManageId)),
          data: (detail) => _content(context, ref, detail),
        ),
      ),
    );
  }

  Widget _content(BuildContext context, WidgetRef ref, AnimalDetail detail) {
    final legalStatuses = detail.legalStatuses.isEmpty
        ? '-'
        : detail.legalStatuses.join(', ');

    return Stack(
      fit: StackFit.expand,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: RefreshIndicator(
            color: ToyVillageColor.gray100,
            onRefresh: () async {
              ref.invalidate(observationListViewModelProvider(animalManageId));
              ref.invalidate(animalDetailViewModelProvider(animalManageId));
              await ref.read(
                animalDetailViewModelProvider(animalManageId).future,
              );
            },
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.pixels >=
                    notification.metrics.maxScrollExtent - 200) {
                  ref
                      .read(
                        observationListViewModelProvider(
                          animalManageId,
                        ).notifier,
                      )
                      .loadMore();
                }
                return false;
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                ToyVillageTitle(title: detail.animalName),
                const SizedBox(height: 28),
                _AnimalImage(fileKey: detail.animalImage?.fileKey),
                const SizedBox(height: 20),
                InfoLabel(label: '종', value: detail.kindName),
                InfoLabel(label: '성별', value: detail.animalGender.label),
                InfoLabel(label: '출생년도', value: '${detail.birthYear}년'),
                InfoLabel(label: '법정지정분류', value: legalStatuses),
                if (detail.otherInfo != null && detail.otherInfo!.isNotEmpty)
                  InfoLabel(label: '기타정보', value: detail.otherInfo!),
                const SizedBox(height: 28),
                Text(
                  '관찰 및 특이사항',
                  style: ToyVillageTextStyle.caption4.copyWith(
                    color: ToyVillageColor.gray60,
                  ),
                ),
                const SizedBox(height: 12),
                CustomAsyncValue(
                  value: ref.watch(
                    observationListViewModelProvider(animalManageId),
                  ),
                  onRetry: () => ref.invalidate(
                    observationListViewModelProvider(animalManageId),
                  ),
                  data: (page) => _observations(context, page),
                ),
                const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: 16,
          child: ToyVillageButton(
            label: '특이사항 작성하기',
            onTap: () async {
              await context.push(
                '/entity-info/note-write',
                extra: (animalManageId: animalManageId),
              );
              ref.invalidate(observationListViewModelProvider(animalManageId));
            },
          ),
        ),
      ],
    );
  }

  Widget _observations(BuildContext context, PagedList<Observation> page) {
    final observations = page.items;
    if (observations.isEmpty) {
      return Text(
        '등록된 관찰 및 특이사항이 없어요.',
        style: ToyVillageTextStyle.body5.copyWith(color: ToyVillageColor.gray60),
      );
    }
    return Column(
      children: [
        for (var i = 0; i < observations.length; i++) ...[
          if (i > 0) const SizedBox(height: 8),
          _NoteCard(
            title: observations[i].title,
            onTap: () => context.push(
              '/entity-info/note',
              extra: (
                animalManageId: animalManageId,
                observationId: observations[i].animalObservationId,
              ),
            ),
          ),
        ],
        if (page.isLoadingMore)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: ToyVillageColor.gray60,
              ),
            ),
          ),
      ],
    );
  }
}

class _AnimalImage extends StatelessWidget {
  final String? fileKey;

  const _AnimalImage({required this.fileKey});

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: ToyVillageColor.gray20,
        borderRadius: BorderRadius.circular(8),
      ),
    );
    if (fileKey == null) return placeholder;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        documentFileUrl(fileKey!),
        width: double.infinity,
        height: 180,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _NoteCard({required this.title, required this.onTap});

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
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: ToyVillageTextStyle.body5,
          ),
        ),
      ),
    );
  }
}
