import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/provider_logger.dart';
import 'package:toy_village_app/core/router/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarContrastEnforced: false,
    ),
  );
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
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: ToyVillageColor.gray30,
          selectionHandleColor: ToyVillageColor.gray100,
          cursorColor: ToyVillageColor.gray100
        ),
        scaffoldBackgroundColor: ToyVillageColor.gray10,
        splashColor: ToyVillageColor.gray30,
        highlightColor: ToyVillageColor.gray30,
      ),
      routerConfig: appRouter,
    );
  }
}
