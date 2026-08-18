import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/button/toy_village_button.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/core/widgets/text_field/text_field.dart';
import 'package:toy_village_app/core/widgets/toast/top_toast.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _idController = TextEditingController();
  final _pwController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final overlay = Overlay.of(context, rootOverlay: true);
    final username = _idController.text.trim();
    final password = _pwController.text;
    if (username.isEmpty || password.isEmpty) {
      showTopToast(overlay, '아이디와 비밀번호를 입력해주세요.', isError: true);
      return;
    }
    setState(() => _loading = true);
    try {
      final token = await ref
          .read(authServiceProvider)
          .loginWith(username: username, password: password);
      ref.read(tokenStoreProvider).accessToken = token;
      if (!mounted) return;
      context.go('/notice');
    } catch (_) {
      if (!mounted) return;
      showTopToast(overlay, '로그인에 실패했어요.\n아이디와 비밀번호를 확인해주세요.', isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const ToyVillageAppBar(),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ToyVillageTitle(title: '로그인'),
                    const SizedBox(height: 28),
                    ToyVillageTextField(
                      label: '아이디',
                      labelStyle: ToyVillageTextStyle.heading6,
                      hintText: '아이디를 입력해주세요',
                      controller: _idController,
                    ),
                    const SizedBox(height: 20),
                    ToyVillageTextField(
                      label: '비밀번호',
                      labelStyle: ToyVillageTextStyle.heading6,
                      hintText: '비밀번호를 입력해주세요',
                      hasEyesIcon: true,
                      controller: _pwController,
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 16,
                child: ToyVillageButton(
                  label: _loading ? '로그인 중...' : '로그인',
                  background: _loading
                      ? ToyVillageColor.gray60
                      : ToyVillageColor.gray100,
                  onTap: _loading ? () {} : _login,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
