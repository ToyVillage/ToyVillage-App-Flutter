import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/notification/fcm_service.dart';
import 'package:toy_village_app/features/notification/data/repository/fcm_token_repository.dart';

final fcmTokenSyncProvider = Provider((ref) => FcmTokenSync(ref));

class FcmTokenSync {
  FcmTokenSync(this._ref);

  final Ref _ref;

  String? _current;
  final Set<String> _pendingRemovals = {};
  final Set<String> _uncertain = {};
  StreamSubscription<String>? _subscription;
  bool _loggedOut = false;
  Future<void> _lock = Future<void>.value();

  FcmTokenRepository get _repo => _ref.read(fcmTokenRepositoryProvider);

  Future<void> start() => _synchronized(() async {
    _loggedOut = false;
    try {
      _subscription ??= FcmService.instance.onTokenRefresh.listen(_applyToken);
      final token = await FcmService.instance.token();
      if (token != null) await _setCurrent(token);
    } catch (_) {}
    await _flushRemovals();
  });

  Future<void> clear() => _synchronized(() async {
    _loggedOut = true;
    await _subscription?.cancel();
    _subscription = null;
    final current = _current;
    if (current != null) _pendingRemovals.add(current);
    _pendingRemovals.addAll(_uncertain);
    _uncertain.clear();
    _current = null;
    await _flushRemovals();
  });

  Future<void> _applyToken(String token) => _synchronized(() async {
    if (_loggedOut) return;
    await _setCurrent(token);
    await _flushRemovals();
  });

  Future<void> _setCurrent(String token) async {
    if (_current == token) return;
    final previous = _current;
    try {
      await _repo.register(token);
      _current = token;
      _uncertain.remove(token);
      if (previous != null && previous != token) {
        _pendingRemovals.add(previous);
      }
    } catch (_) {
      _uncertain.add(token);
    }
  }

  Future<void> _flushRemovals() async {
    final targets = List<String>.from(_pendingRemovals);
    for (final token in targets) {
      if (token == _current) {
        _pendingRemovals.remove(token);
        continue;
      }
      try {
        await _repo.remove(token);
        _pendingRemovals.remove(token);
      } catch (_) {}
    }
  }

  Future<void> _synchronized(Future<void> Function() action) {
    final completer = Completer<void>();
    final previous = _lock;
    _lock = completer.future;
    return previous.then((_) => action()).whenComplete(completer.complete);
  }
}
