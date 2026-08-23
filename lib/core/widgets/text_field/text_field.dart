import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/svg_assets.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/widgets/text/label.dart';

class ToyVillageTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final int minLines;
  final int? maxLines;
  final TextEditingController? controller;
  final bool isOptional;
  final TextStyle? labelStyle;
  final bool hasEyesIcon;

  const ToyVillageTextField({
    super.key,
    required this.label,
    this.hintText = '',
    this.minLines = 1,
    this.maxLines,
    this.controller,
    this.isOptional = false,
    this.labelStyle,
    this.hasEyesIcon = false,
  });

  @override
  State<ToyVillageTextField> createState() => _ToyVillageTextFieldState();
}

class _ToyVillageTextFieldState extends State<ToyVillageTextField> {
  late bool _obscure = widget.hasEyesIcon;

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.transparent),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ToyVillageLabel(
          label: widget.label,
          isOptional: widget.isOptional,
          labelStyle: widget.labelStyle,
        ),
        const SizedBox(height: 8),
        TextFormField(
          style: ToyVillageTextStyle.caption3,
          controller: widget.controller,
          obscureText: widget.hasEyesIcon && _obscure,
          autocorrect: !widget.hasEyesIcon,
          enableSuggestions: !widget.hasEyesIcon,
          minLines: widget.hasEyesIcon ? 1 : widget.minLines,
          maxLines: widget.hasEyesIcon ? 1 : widget.maxLines,
          keyboardType: widget.hasEyesIcon
              ? TextInputType.visiblePassword
              : TextInputType.multiline,
          decoration: InputDecoration(
            suffixIcon: widget.hasEyesIcon
                ? Semantics(
                    button: true,
                    label: _obscure ? '비밀번호 표시' : '비밀번호 숨기기',
                    child: GestureDetector(
                      excludeFromSemantics: true,
                      onTap: () => setState(() => _obscure = !_obscure),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: SvgPicture.asset(
                          _obscure ? SvgAssets.invisible : SvgAssets.visible,
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                  )
                : null,
            suffixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            contentPadding: const EdgeInsets.all(16),
            hintText: widget.hintText,
            hintStyle: ToyVillageTextStyle.caption4.copyWith(
              color: ToyVillageColor.gray60,
            ),
            filled: true,
            fillColor: ToyVillageColor.white,
            enabledBorder: outlineInputBorder,
            focusedBorder: outlineInputBorder,
          ),
        ),
      ],
    );
  }
}
