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

  Future<void> start() async {
    _subscription ??= FcmService.instance.onTokenRefresh.listen(_onRefresh);
    try {
      final token = await FcmService.instance.token();
      if (token == null) return;
      await _ref.read(fcmTokenRepositoryProvider).register(token);
      _current = token;
    } catch (_) {}
  }

  Future<void> clear() async {
    final token = _current;
    _current = null;
    if (token == null) return;
    try {
      await _ref.read(fcmTokenRepositoryProvider).remove(token);
    } catch (_) {}
  }

  Future<void> _onRefresh(String next) async {
    final previous = _current;
    _current = next;
    try {
      await _ref.read(fcmTokenRepositoryProvider).register(next);
      if (previous != null && previous != next) {
        await _ref.read(fcmTokenRepositoryProvider).remove(previous);
      }
    } catch (_) {}
  }
}
