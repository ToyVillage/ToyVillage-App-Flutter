import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/button/toy_village_button.dart';
import 'package:toy_village_app/core/widgets/text_field/text_field.dart';
import 'package:toy_village_app/core/widgets/toast/top_toast.dart';
import 'package:toy_village_app/features/password/presentation/view_model/password_view_model.dart';

class PasswordView extends ConsumerStatefulWidget {
  const PasswordView({super.key});

  @override
  ConsumerState<PasswordView> createState() => _PasswordViewState();
}

class _PasswordViewState extends ConsumerState<PasswordView> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  bool get _mismatch =>
      _confirmController.text.isNotEmpty &&
      _newController.text != _confirmController.text;

  @override
  void initState() {
    super.initState();
    _newController.addListener(_onChanged);
    _confirmController.addListener(_onChanged);
  }

  void _onChanged() => setState(() {});

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final overlay = Overlay.of(context, rootOverlay: true);
    final error = await ref
        .read(passwordViewModelProvider.notifier)
        .changePassword(
          current: _currentController.text,
          newPassword: _newController.text,
          confirm: _confirmController.text,
        );
    if (!mounted) return;
    if (error == null) {
      showTopToast(overlay, '비밀번호가 변경되었습니다.');
      context.pop();
    } else {
      showTopToast(overlay, error, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(passwordViewModelProvider).isLoading;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const ToyVillageAppBar(closeIcon: true, title: '비밀번호 변경'),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    ToyVillageTextField(
                      label: '기존 비밀번호',
                      labelStyle: ToyVillageTextStyle.heading6,
                      hintText: '기존 비밀번호를 입력해주세요',
                      hasEyesIcon: true,
                      controller: _currentController,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: ToyVillageTextField(
                        label: '새 비밀번호',
                        labelStyle: ToyVillageTextStyle.heading6,
                        hintText: '비밀번호를 생성해주세요',
                        hasEyesIcon: true,
                        controller: _newController,
                      ),
                    ),
                    ToyVillageTextField(
                      label: '비밀번호 확인',
                      labelStyle: ToyVillageTextStyle.heading6,
                      hintText: '변경된 비밀번호를 입력해주세요',
                      hasEyesIcon: true,
                      controller: _confirmController,
                    ),
                    if (_mismatch) ...[
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '비밀번호가 일치하지 않습니다',
                          style: ToyVillageTextStyle.caption4.copyWith(
                            color: ToyVillageColor.red,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 16,
                child: ToyVillageButton(
                  label: loading ? '변경 중...' : '변경 완료하기',
                  onTap: loading ? () {} : _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
