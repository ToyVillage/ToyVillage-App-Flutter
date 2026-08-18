import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/button/toy_village_button.dart';
import 'package:toy_village_app/core/widgets/text/title.dart';
import 'package:toy_village_app/core/widgets/text_field/text_field.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

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
                    ),
                    const SizedBox(height: 20),
                    ToyVillageTextField(
                      label: '비밀번호',
                      labelStyle: ToyVillageTextStyle.heading6,
                      hintText: '비밀번호를 입력해주세요',
                      hasEyesIcon: true,
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 16,
                child: ToyVillageButton(
                  label: '로그인',
                  onTap: () => context.push('/notice'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
