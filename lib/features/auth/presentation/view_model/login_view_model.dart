import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';
import 'package:toy_village_app/features/auth/data/repository/auth_repository.dart';
import 'package:toy_village_app/features/notification/presentation/fcm_token_sync.dart';

final loginViewModelProvider =
    AsyncNotifierProvider<LoginViewModel, void>(LoginViewModel.new);

class LoginViewModel extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    state = const AsyncLoading();
    try {
      final result = await ref
          .read(authRepositoryProvider)
          .login(username: username, password: password);
      final store = ref.read(tokenStoreProvider);
      await store.setTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );
      await store.setProfile(role: result.role, name: result.name);
      await ref.read(fcmTokenSyncProvider).start();
      state = const AsyncData(null);
      return true;
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return false;
    }
  }
}
