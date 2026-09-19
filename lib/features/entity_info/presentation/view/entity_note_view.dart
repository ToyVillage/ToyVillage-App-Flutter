import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/pull_to_refresh.dart';
import 'package:toy_village_app/core/widgets/custom_async_value.dart';
import 'package:toy_village_app/features/entity_info/presentation/widget/observation_detail_skeleton.dart';
import 'package:toy_village_app/core/widgets/file/attachment_section.dart';
import 'package:toy_village_app/core/widgets/text_field/readonly_field.dart';
import 'package:toy_village_app/features/entity_info/presentation/view_model/observation_detail_view_model.dart';

class EntityNoteView extends ConsumerWidget {
  final int animalManageId;
  final int observationId;

  const EntityNoteView({
    super.key,
    required this.animalManageId,
    required this.observationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = (
      animalManageId: animalManageId,
      observationId: observationId,
    );

    return Scaffold(
      appBar: const ToyVillageAppBar(hasIcon: true),
      body: SafeArea(
        child: CustomAsyncValue(
          value: ref.watch(observationDetailViewModelProvider(key)),
          loading: const ObservationDetailSkeleton(),
          onRetry: () =>
              ref.invalidate(observationDetailViewModelProvider(key)),
          data: (detail) => PullToRefresh.child(
            onRefresh: () async =>
                ref.refresh(observationDetailViewModelProvider(key).future),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 28),
                  ToyVillageReadonlyField(label: '제목', value: detail.title),
                  const SizedBox(height: 20),
                  ToyVillageReadonlyField(
                    label: '내용',
                    value: detail.content,
                    minLines: 8,
                  ),
                  const SizedBox(height: 20),
                  AttachmentSection(
                    files: [
                      for (final file in detail.files)
                        (fileName: file.fileName, fileKey: file.fileKey),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
      ),
    );
  }
}
