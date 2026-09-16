import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

void showTopToast(OverlayState overlay, String message, {bool isError = false}) {
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

class _BalancedText extends StatelessWidget {
  final String message;
  final TextStyle style;

  const _BalancedText({required this.message, required this.style});

  String _balanced(double maxWidth) {
    if (message.contains('\n')) return message;
    final painter = TextPainter(
      text: TextSpan(text: message, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    if (painter.width <= maxWidth) return message;

    final mid = message.length / 2;
    var best = -1;
    for (var i = 0; i < message.length; i++) {
      if (message[i] != ' ') continue;
      if (best == -1 || (i - mid).abs() < (best - mid).abs()) best = i;
    }
    if (best == -1) return message;
    return '${message.substring(0, best)}\n${message.substring(best + 1)}';
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Text(
        _balanced(constraints.maxWidth),
        textAlign: TextAlign.center,
        style: style,
      ),
    );
  }
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

class _TopToastState extends State<_TopToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
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
    _controller.forward();
    Future.delayed(const Duration(milliseconds: 2000), () async {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.sizeOf(context).width - 40,
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: ToyVillageColor.gray100,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            widget.isError ? Symbols.close : Symbols.check,
                            color: widget.isError
                                ? ToyVillageColor.red
                                : ToyVillageColor.green,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: _BalancedText(
                              message: widget.message,
                              style: ToyVillageTextStyle.body5.copyWith(
                                color: ToyVillageColor.white,
                                height: 1.35,
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
      ),
    );
  }
}
