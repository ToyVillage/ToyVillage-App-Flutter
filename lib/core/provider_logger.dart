import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class ProviderLogger extends ProviderObserver {
  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    debugPrint(
      '[Provider Error] ${context.provider.name ?? context.provider.runtimeType}: $error',
    );
    debugPrint('$stackTrace');
  }
}
