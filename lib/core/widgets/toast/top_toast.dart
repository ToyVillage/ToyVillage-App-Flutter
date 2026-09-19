import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

void showTopToast(
  OverlayState overlay,
  String message, {
  bool isError = false,
}) {
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (context) => _TopToast(
      message: message,
      isError: isError,
      onDismiss: () => entry.remove(),
    ),
  );
  overlay.insert(entry);
}

class _TopToast extends StatefulWidget {
  final String message;
  final bool isError;
  final VoidCallback onDismiss;

  const _TopToast({
    required this.message,
    required this.isError,
    required this.onDismiss,
  });

  @override
  State<_TopToast> createState() => _TopToastState();
}

class _TopToastState extends State<_TopToast> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _progressController;
  late final Animation<double> _anim;
  final _dismissKey = UniqueKey();
  bool _removed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _anim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _controller.forward();
    _progressController.forward().whenComplete(() async {
      if (!mounted || _removed) return;
      await _controller.reverse();
      _dismiss();
    });
  }

  void _dismiss() {
    if (_removed) return;
    _removed = true;
    widget.onDismiss();
  }

  @override
  void dispose() {
    _controller.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.isError ? ToyVillageColor.red : ToyVillageColor.green;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: FadeTransition(
          opacity: _anim,
          child: SlideTransition(
            position: Tween(
              begin: const Offset(0, -0.4),
              end: Offset.zero,
            ).animate(_anim),
            child: Align(
              alignment: Alignment.topCenter,
              child: Dismissible(
                key: _dismissKey,
                direction: DismissDirection.up,
                onDismissed: (_) => _dismiss(),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: ToyVillageColor.gray100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 17),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                widget.isError ? Symbols.close : Symbols.check,
                                color: accent,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  widget.message,
                                  style: ToyVillageTextStyle.body5.copyWith(
                                    color: ToyVillageColor.white,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: AnimatedBuilder(
                            animation: _progressController,
                            builder: (context, _) => Container(
                              height: 4,
                              alignment: Alignment.centerLeft,
                              color: accent.withValues(alpha: 0.25),
                              child: FractionallySizedBox(
                                widthFactor: _progressController.value,
                                heightFactor: 1,
                                child: ColoredBox(color: accent),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
