import 'package:flutter/material.dart';
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
      scrolledUnderElevation: 0,
      leading: closeIcon == true ? IconButton(
        icon: const Icon(
          size: 28,
          Symbols.chevron_left_rounded,
          color: ToyVillageColor.gray100,
        ),
        onPressed: () => context.pop(),
      ) : null
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
