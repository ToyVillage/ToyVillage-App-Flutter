import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/auth/data/repository/auth_repository.dart';

final passwordViewModelProvider =
    AsyncNotifierProvider<PasswordViewModel, void>(PasswordViewModel.new);

class PasswordViewModel extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<String?> changePassword({
    required String current,
    required String newPassword,
    required String confirm,
  }) async {
    if (current.isEmpty || newPassword.isEmpty || confirm.isEmpty) {
      return '모든 항목을 입력해주세요.';
    }
    if (newPassword == current) {
      return '기존 비밀번호와 다르게 설정해주세요.';
    }
    if (newPassword != confirm) {
      return '새 비밀번호가 일치하지 않습니다.';
    }

    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).changePassword(
            currentPassword: current,
            newPassword: newPassword,
          );
      state = const AsyncData(null);
      return null;
    } on DioException catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return _errorMessage(e);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return '비밀번호 변경에 실패했습니다.';
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
}
