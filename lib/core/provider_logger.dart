import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:toy_village_app/core/network/app_exception.dart';

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
    if (error is DioException) {
      final status = error.response?.statusCode;
      return status != null && status >= 400 && status < 500;
    }
    if (error is UnauthorizedException || error is NotFoundException) {
      return true;
    }
    if (error is ServerException) {
      final status = error.statusCode;
      return status != null && status >= 400 && status < 500;
    }
    return false;
  }
}
