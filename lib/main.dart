import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/provider_logger.dart';
import 'package:toy_village_app/core/router/app_router.dart';

void main() {
  runApp(
    ProviderScope(
      observers: [ProviderLogger()],
      child: const ToyVillageApp(),
    ),
  );
}

class ToyVillageApp extends StatelessWidget {
  const ToyVillageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ToyVillage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: ToyVillageColor.gray10,
      ),
      routerConfig: appRouter,
    );
  }
}
