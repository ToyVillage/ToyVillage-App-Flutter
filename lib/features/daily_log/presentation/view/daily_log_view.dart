import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/button/toy_village_button.dart';
import 'package:toy_village_app/core/widgets/empty_state.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/features/daily_log/presentation/view_model/daily_log_view_model.dart';
import 'package:toy_village_app/features/daily_log/presentation/widget/log_card.dart';

class DailyLogView extends ConsumerWidget {
  const DailyLogView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(dailyLogViewModelProvider);

    return Scaffold(
      appBar: const ToyVillageAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 22),
                    child: ToyVillageTitle(
                      title: '업무일지 작성',
                      subTitle: '오늘 자신의 업무일지를 작성합니다',
                    ),
                  ),
                  Expanded(
                    child: logs.isEmpty
                        ? const EmptyState(message: '최근 작성한 업무일지가 없습니다')
                        : ListView.builder(
                            padding: const EdgeInsets.only(bottom: 80),
                            itemCount: logs.length,
                            itemBuilder: (context, index) =>
                                LogCard(log: logs[index]),
                          ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 16,
              child: ToyVillageButton(
                label: '업무일지 작성',
                onTap: () => context.push('/dailyLog/create'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
