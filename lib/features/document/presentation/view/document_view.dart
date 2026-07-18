import 'package:flutter/material.dart';
import 'package:toy_village_app/core/widgets/app_bar.dart';
import 'package:toy_village_app/core/widgets/title.dart';
import 'package:toy_village_app/features/document/presentation/widget/document_card.dart';
import 'package:toy_village_app/features/document/presentation/widget/sort_dropdown.dart';

class DocumentView extends StatefulWidget {
  const DocumentView({super.key});

  @override
  State<DocumentView> createState() => _DocumentViewState();
}

class _DocumentViewState extends State<DocumentView> {
  SortOrder _sort = SortOrder.latest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ToyVillageAppBar(),
              ToyVillageTitle(
                title: '자료실',
                subTitle: '토이빌리지의 모든 자료가 모인 곳',
              ),
              Row(
                children: [
                  const Spacer(),
                  SortDropdown(
                    value: _sort,
                    onChanged: (order) => setState(() => _sort = order),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int index) {
                    return DocumentCard(
                      title: '토이빌리지 동물관리 안내사항',
                      type: 'JPG',
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
