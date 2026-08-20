import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/custom_async_value.dart';
import 'package:toy_village_app/core/widgets/empty_state.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/features/document/presentation/view_model/document_view_model.dart';
import 'package:toy_village_app/features/document/presentation/widget/document_card.dart';
import 'package:toy_village_app/features/document/presentation/widget/document_list_skeleton.dart';
import 'package:toy_village_app/features/document/presentation/widget/sort_dropdown.dart';

class DocumentView extends ConsumerStatefulWidget {
  const DocumentView({super.key});

  @override
  ConsumerState<DocumentView> createState() => _DocumentViewState();
}

class _DocumentViewState extends ConsumerState<DocumentView> {
  SortOrder _sort = SortOrder.latest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ToyVillageAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ToyVillageTitle(
                title: '자료실',
                subTitle: '토이빌리지의 모든 자료가 모인 곳',
              ),
              Row(
                children: [
                  const Spacer(),
                  SortDropdown(
                    value: _sort,
                    onChanged: (order) {
                      setState(() => _sort = order);
                      ref
                          .read(documentViewModelProvider.notifier)
                          .changeOrder(order);
                    },
                  ),
                ],
              ),
              Expanded(
                child: CustomAsyncValue(
                  value: ref.watch(documentViewModelProvider),
                  loading: const DocumentListSkeleton(),
                  data: (documents) {
                    if (documents.isEmpty) {
                      return const EmptyState(message: '등록된 자료가 없습니다');
                    }
                    return CustomScrollView(
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      slivers: [
                        CupertinoSliverRefreshControl(
                          onRefresh: () =>
                              ref.refresh(documentViewModelProvider.future),
                        ),
                        SliverList.builder(
                          itemCount: documents.length,
                          itemBuilder: (BuildContext context, int index) {
                            final document = documents[index];
                            return DocumentCard(
                              id: document.id,
                              title: document.title,
                              type: document.type,
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
