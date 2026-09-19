import 'package:flutter/material.dart';
import 'package:toy_village_app/core/widgets/pull_to_refresh.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/utils/file_url.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/app_loading_indicator.dart';
import 'package:toy_village_app/features/entity_info/presentation/widget/species_detail_skeleton.dart';
import 'package:toy_village_app/core/widgets/custom_async_value.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/features/entity_info/data/model/animal_kind_detail.dart';
import 'package:toy_village_app/features/entity_info/data/model/animal_summary.dart';
import 'package:toy_village_app/features/entity_info/data/model/paged_list.dart';
import 'package:toy_village_app/features/entity_info/presentation/view_model/animal_kind_detail_view_model.dart';
import 'package:toy_village_app/features/entity_info/presentation/view_model/animal_list_view_model.dart';
import 'package:toy_village_app/features/entity_info/presentation/widget/entity_name_card.dart';
import 'package:toy_village_app/features/entity_info/presentation/widget/info_label.dart';

class SpeciesDetailView extends ConsumerWidget {
  final int animalKindId;
  final String kindName;

  const SpeciesDetailView({
    super.key,
    required this.animalKindId,
    required this.kindName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const ToyVillageAppBar(hasIcon: true),
      body: SafeArea(
        child: CustomAsyncValue(
          value: ref.watch(animalKindDetailViewModelProvider(animalKindId)),
          loading: const SpeciesDetailSkeleton(),
          onRetry: () =>
              ref.invalidate(animalKindDetailViewModelProvider(animalKindId)),
          data: (detail) => _content(context, ref, detail),
        ),
      ),
    );
  }

  Widget _content(
    BuildContext context,
    WidgetRef ref,
    AnimalKindDetail detail,
  ) {
    final legalStatuses = detail.legalStatuses.isEmpty
        ? '-'
        : detail.legalStatuses.map((e) => e.kind).join(', ');
    final filter = (animalKindId: animalKindId, keyword: '');

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels >=
            notification.metrics.maxScrollExtent - 200) {
          ref.read(animalListViewModelProvider(filter).notifier).loadMore();
        }
        return false;
      },
      child: PullToRefresh.child(
        onRefresh: () async {
          ref.invalidate(animalListViewModelProvider(filter));
          ref.invalidate(animalKindDetailViewModelProvider(animalKindId));
          await ref.read(
            animalKindDetailViewModelProvider(animalKindId).future,
          );
        },
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ToyVillageTitle(title: detail.kindName),
              const SizedBox(height: 28),
              _KindImage(fileKey: detail.kindImage?.fileKey),
              const SizedBox(height: 20),
              InfoLabel(label: '학명', value: detail.scientificName),
              InfoLabel(label: '분류군', value: detail.animalTaxonomic.label),
              if (detail.detailKind != null)
                InfoLabel(label: '세부 분류', value: detail.detailKind!),
              InfoLabel(label: '법정지정분류', value: legalStatuses),
              InfoLabel(label: '개체 수', value: '${detail.animalCount}마리'),
              const SizedBox(height: 28),
              Text(
                '개체 리스트',
                style: ToyVillageTextStyle.caption4.copyWith(
                  color: ToyVillageColor.gray60,
                ),
              ),
              const SizedBox(height: 12),
              CustomAsyncValue(
                value: ref.watch(animalListViewModelProvider(filter)),
                onRetry: () =>
                    ref.invalidate(animalListViewModelProvider(filter)),
                data: (page) => _entityList(context, page),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
    );
  }

  Widget _entityList(BuildContext context, PagedList<AnimalSummary> page) {
    final animals = page.items;
    if (animals.isEmpty) {
      return Text(
        '등록된 개체가 없어요.',
        style: ToyVillageTextStyle.body5.copyWith(color: ToyVillageColor.gray60),
      );
    }
    return Column(
      children: [
        for (var i = 0; i < animals.length; i++) ...[
          if (i > 0) const SizedBox(height: 8),
          EntityNameCard(
            name: animals[i].animalName,
            onTap: () => context.push(
              '/entity-info/entity',
              extra: (animalManageId: animals[i].animalManageId),
            ),
          ),
        ],
        if (page.isLoadingMore)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: AppLoadingIndicator(radius: 10)),
          ),
      ],
    );
  }
}

class _KindImage extends StatelessWidget {
  final String? fileKey;

  const _KindImage({required this.fileKey});

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
