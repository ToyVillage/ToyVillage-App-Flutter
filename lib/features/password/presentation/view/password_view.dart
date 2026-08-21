import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/button/toy_village_button.dart';
import 'package:toy_village_app/core/widgets/text_field/text_field.dart';
import 'package:toy_village_app/core/widgets/toast/top_toast.dart';
import 'package:toy_village_app/features/auth/data/repository/auth_repository.dart';

class PasswordView extends ConsumerStatefulWidget {
  const PasswordView({super.key});

  @override
  ConsumerState<PasswordView> createState() => _PasswordViewState();
}

class _PasswordViewState extends ConsumerState<PasswordView> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final overlay = Overlay.of(context, rootOverlay: true);
    final current = _currentController.text;
    final newPw = _newController.text;
    final confirm = _confirmController.text;

    if (current.isEmpty || newPw.isEmpty || confirm.isEmpty) {
      showTopToast(overlay, '모든 항목을 입력해주세요.', isError: true);
      return;
    }
    if (newPw == current) {
      showTopToast(overlay, '기존 비밀번호와 다르게 설정해주세요.', isError: true);
      return;
    }
    if (newPw != confirm) {
      showTopToast(overlay, '새 비밀번호가 일치하지 않습니다.', isError: true);
      return;
    }

    setState(() => _loading = true);
    try {
      await ref
          .read(authRepositoryProvider)
          .changePassword(currentPassword: current, newPassword: newPw);
      if (!mounted) return;
      showTopToast(overlay, '비밀번호가 변경되었습니다.');
      context.pop();
    } on DioException catch (e) {
      if (!mounted) return;
      showTopToast(overlay, _errorMessage(e), isError: true);
    } catch (_) {
      if (!mounted) return;
      showTopToast(overlay, '비밀번호 변경에 실패했습니다.', isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _errorMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      final description = data['description'];
      if (description is String && description.isNotEmpty) return description;
      final message = data['message'];
      if (message is String && message.isNotEmpty) return message;
    }
    return '비밀번호 변경에 실패했습니다.';
  }

  @override
  Widget build(BuildContext context) {
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
                  ],
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 16,
                child: ToyVillageButton(
                  label: _loading ? '변경 중...' : '변경 완료하기',
                  onTap: _loading ? () {} : _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
