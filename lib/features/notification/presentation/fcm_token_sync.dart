import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/notification/fcm_service.dart';
import 'package:toy_village_app/features/notification/data/repository/fcm_token_repository.dart';

final fcmTokenSyncProvider = Provider((ref) => FcmTokenSync(ref));

class FcmTokenSync {
  FcmTokenSync(this._ref);

  final Ref _ref;

  String? _current;
  StreamSubscription<String>? _subscription;
  bool _loggedOut = false;

  Future<void> start() async {
    _loggedOut = false;
    try {
      _subscription ??= FcmService.instance.onTokenRefresh.listen(_onRefresh);
      final token = await FcmService.instance.token();
      if (token == null) return;
      await _ref.read(fcmTokenRepositoryProvider).register(token);
      if (_loggedOut) {
        await _ref.read(fcmTokenRepositoryProvider).remove(token);
        return;
      }
      if (_current != null && _current != token) {
        await _ref.read(fcmTokenRepositoryProvider).remove(token);
      } else {
        _current = token;
      }
    } catch (_) {}
  }

  Future<void> clear() async {
    _loggedOut = true;
    await _subscription?.cancel();
    _subscription = null;
    final token = _current;
    if (token == null) return;
    try {
      await _ref.read(fcmTokenRepositoryProvider).remove(token);
      _current = null;
    } catch (_) {}
  }

  Future<void> _onRefresh(String next) async {
    final previous = _current;
    _current = next;
    try {
      await _ref.read(fcmTokenRepositoryProvider).register(next);
      if (_loggedOut) {
        await _ref.read(fcmTokenRepositoryProvider).remove(next);
        return;
      }
      if (previous != null && previous != next) {
        await _ref.read(fcmTokenRepositoryProvider).remove(previous);
      }
    } catch (_) {}
  }
}
