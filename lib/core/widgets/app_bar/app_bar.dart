import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

class ToyVillageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool? hasIcon;
  final String title;

  const ToyVillageAppBar({super.key, this.hasIcon = false, this.title = ''});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: ToyVillageTextStyle.caption2),
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
      leading: hasIcon == true
          ? IconButton(
              tooltip: '뒤로가기',
              icon: const Icon(
                Symbols.chevron_left_rounded,
                size: 28,
                color: ToyVillageColor.gray100,
                semanticLabel: '뒤로가기',
              ),
              onPressed: () => context.pop(),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
