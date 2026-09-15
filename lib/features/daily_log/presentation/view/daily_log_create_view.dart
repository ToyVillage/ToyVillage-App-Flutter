import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/custom_async_value.dart';
import 'package:toy_village_app/core/widgets/toast/top_toast.dart';
import 'package:toy_village_app/core/widgets/button/toy_village_button.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/features/daily_log/data/model/daily_log_template_summary.dart';
import 'package:toy_village_app/features/daily_log/presentation/view_model/daily_log_template_list_view_model.dart';
import 'package:toy_village_app/features/daily_log/presentation/widget/template_dropdown_field.dart';

class DailyLogCreateView extends ConsumerStatefulWidget {
  const DailyLogCreateView({super.key});

  @override
  ConsumerState<DailyLogCreateView> createState() => _DailyLogCreateViewState();
}

class _DailyLogCreateViewState extends ConsumerState<DailyLogCreateView> {
  int? _templateId;

  void _next() {
    final templateId = _templateId;
    if (templateId == null) {
      showTopToast(
        Overlay.of(context, rootOverlay: true),
        '양식을 선택해주세요.',
        isError: true,
      );
      return;
    }
    context.push('/daily-log/create/content', extra: templateId);
  }

  @override
  Widget build(BuildContext context) {
    final templates = ref.watch(dailyLogTemplateListViewModelProvider);

    return Scaffold(
      appBar: const ToyVillageAppBar(hasIcon: true),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 28),
                    child: ToyVillageTitle(title: '업무일지 작성'),
                  ),
                  Expanded(
                    child: CustomAsyncValue(
                      value: templates,
                      onRetry: () =>
                          ref.invalidate(dailyLogTemplateListViewModelProvider),
                      errorMessage: '양식을 불러오지 못했어요.',
                      data: (list) => _dropdown(list),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 16,
              child: ToyVillageButton(label: '다음', onTap: _next),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dropdown(List<DailyLogTemplateSummary> list) {
    final titles = list.map((e) => e.templateTitle).toList();
    String? selectedTitle;
    for (final e in list) {
      if (e.templateId == _templateId) {
        selectedTitle = e.templateTitle;
        break;
      }
    }

    return TemplateDropdownField(
      label: '양식 선택',
      hintText: '업무일지 양식을 선택해주세요',
      value: selectedTitle,
      items: titles,
      onChanged: (value) {
        int? id;
        for (final e in list) {
          if (e.templateTitle == value) {
            id = e.templateId;
            break;
          }
        }
        setState(() => _templateId = id);
      },
    );
  }
}
