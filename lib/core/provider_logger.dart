import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

final class ProviderLogger extends ProviderObserver {
  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    final providerName =
        context.provider.name ?? context.provider.runtimeType.toString();
    debugPrint('[Provider Error] $providerName: $error');
    debugPrint('$stackTrace');

    if (_isClientError(error)) return;

    Sentry.captureException(
      error,
      stackTrace: stackTrace,
      withScope: (scope) => scope.setTag('provider', providerName),
    );
  }

  bool _isClientError(Object error) {
    if (error is! DioException) return false;
    final status = error.response?.statusCode;
    return status != null && status >= 400 && status < 500;
  }
}
