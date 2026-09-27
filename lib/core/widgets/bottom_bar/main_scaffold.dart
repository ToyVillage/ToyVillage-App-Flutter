import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/widgets/bottom_bar/bottom_bar.dart';
import 'package:toy_village_app/features/onboarding/presentation/onboarding.dart';

class MainScaffold extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({super.key, required this.navigationShell});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) runOnboarding(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigationShell = widget.navigationShell;
    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: ToyVillageBottomBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}
