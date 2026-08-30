import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/toast/top_toast.dart';
import 'package:toy_village_app/core/widgets/button/toy_village_button.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/features/daily_log/data/model/daily_log.dart';
import 'package:toy_village_app/features/daily_log/data/repository/daily_log_draft_repository.dart';
import 'package:toy_village_app/features/daily_log/presentation/widget/template_dropdown_field.dart';

class DailyLogCreateView extends ConsumerStatefulWidget {
  final DailyLog? log;

  const DailyLogCreateView({super.key, this.log});

  @override
  ConsumerState<DailyLogCreateView> createState() => _DailyLogCreateViewState();
}

class _DailyLogCreateViewState extends ConsumerState<DailyLogCreateView> {
  String? _template;

  DailyLogDraftRepository get _repo =>
      ref.read(dailyLogDraftRepositoryProvider);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = widget.log?.id;
    final draft = await _repo.load(id);
    if (!mounted) return;
    if (draft?.templateName != null) {
      setState(() => _template = draft!.templateName);
      return;
    }
    final log = widget.log;
    if (log != null) {
      setState(() => _template = log.templateName);
    }
  }

  String get _title {
    final log = widget.log;
    if (log != null) {
      return '${log.createdAt.month}월 ${log.createdAt.day}일 업무일지';
    }
    return '업무일지 작성';
  }

  void _next() {
    final template = _template;
    if (template == null) {
      showTopToast(
        Overlay.of(context, rootOverlay: true),
        '양식을 선택해주세요.',
        isError: true,
      );
      return;
    }
    context.push('/daily-log/create/content', extra: template);
  }

  @override
  Widget build(BuildContext context) {
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 28),
                    child: ToyVillageTitle(title: _title),
                  ),
                  TemplateDropdownField(
                    label: '양식 선택',
                    hintText: '업무일지 양식을 선택해주세요',
                    value: _template,
                    items: dailyLogTemplates,
                    onChanged: (value) => setState(() => _template = value),
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
}
