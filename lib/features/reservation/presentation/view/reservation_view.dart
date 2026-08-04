import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/custom_async_value.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/features/reservation/presentation/view_model/reservation_view_model.dart';
import 'package:toy_village_app/features/reservation/presentation/widget/reservation_card.dart';
import 'package:toy_village_app/features/reservation/presentation/widget/reservation_list_skeleton.dart';

class ReservationView extends ConsumerWidget {
  const ReservationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ToyVillageAppBar(),
              Expanded(
                child: CustomAsyncValue(
                  value: ref.watch(reservationViewModelProvider),
                  loading: const ReservationListSkeleton(),
                  onRetry: () => ref.invalidate(reservationViewModelProvider),
                  data: (reservations) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: ToyVillageTitle(
                          title: '단체예약 확인',
                          subTitle: '토이빌리지 단체예약 확인 및 관리',
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: reservations.length,
                          itemBuilder: (context, index) {
                            final reservation = reservations[index];
                            return ReservationCard(
                              onTap: () {
                                context.push(
                                  '/reservation/detail',
                                  extra: (
                                    id: reservation.id,
                                    title: reservation.title,
                                  ),
                                );
                              },
                              title: reservation.title,
                              reservationName: reservation.reservationName,
                              visitDate: reservation.visitDate,
                              reservationCount: reservation.reservationCount,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
