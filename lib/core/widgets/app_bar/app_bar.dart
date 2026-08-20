import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:toy_village_app/core/constants/color.dart';

class ToyVillageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool? closeIcon;

  const ToyVillageAppBar({super.key, this.closeIcon = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ToyVillageColor.gray10,
      elevation: 0,
      automaticallyImplyLeading: false,
      scrolledUnderElevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarContrastEnforced: false,
      ),
      leading: closeIcon == true ? IconButton(
        tooltip: '뒤로가기',
        icon: const Icon(
          Symbols.chevron_left_rounded,
          size: 28,
          color: ToyVillageColor.gray100,
          semanticLabel: '뒤로가기',
        ),
        onPressed: () => context.pop(),
      ) : null
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
