import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_dio/sentry_dio.dart';
import 'package:toy_village_app/core/config/app_env.dart';
import 'package:toy_village_app/core/network/token_store.dart';

const _sensitiveKeys = {
  'password',
  'currentPassword',
  'newPassword',
  'token',
  'refresh_token',
  'refreshToken',
  'access_token',
  'accessToken',
};

Object? _maskSensitive(Object? data) {
  if (data is Map) {
    return data.map(
      (key, value) => _sensitiveKeys.contains(key)
          ? MapEntry(key, '***')
          : MapEntry(key, _maskSensitive(value)),
    );
  }
  if (data is List) return data.map(_maskSensitive).toList();
  return data;
}

final tokenStoreProvider = Provider((ref) => TokenStore());

final dioProvider = Provider<Dio>((ref) {
  final store = ref.read(tokenStoreProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: AppEnv.current.baseUrl,
      headers: {'Origin': 'https://toyvillage.kr'},
      connectTimeout: const Duration(seconds: 5),
      sendTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  Future<bool>? refreshing;

  Future<bool> reissue() async {
    final refreshToken = store.refreshToken;
    if (refreshToken == null) return false;
    try {
      final res = await dio.post(
        '/app/auth/reissue',
        data: {'refresh_token': refreshToken},
      );
      final data = res.data as Map<String, dynamic>;
      await store.setTokens(
        accessToken: data['access_token'] as String,
        refreshToken: data['refresh_token'] as String,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  bool isNoAuthCall(String path) =>
      path.contains('/app/auth/login') || path.contains('/app/auth/reissue');

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final isAuthCall = isNoAuthCall(options.path);
        final token = store.accessToken;
        if (token != null && !isAuthCall) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        final status = error.response?.statusCode;
        final path = error.requestOptions.path;
        final isAuthCall = isNoAuthCall(path);
        final alreadyRetried = error.requestOptions.extra['__retried'] == true;

        if (status == 401 &&
            !isAuthCall &&
            !alreadyRetried &&
            store.refreshToken != null) {
          final refreshed = await (refreshing ??= reissue());
          refreshing = null;

          if (!refreshed) {
            await store.clear();
            return handler.next(error);
          }

          try {
            final options = error.requestOptions
              ..headers['Authorization'] = 'Bearer ${store.accessToken}'
              ..extra['__retried'] = true;
            final response = await dio.fetch(options);
            return handler.resolve(response);
          } on DioException catch (e) {
            return handler.next(e);
          }
        }

        handler.next(error);
      },
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('[API] → ${options.method} ${options.uri}');
          if (options.data != null) {
            debugPrint('[API]   body: ${_maskSensitive(options.data)}');
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint(
            '[API] ← ${response.statusCode} '
            '${response.requestOptions.method} '
            '${response.requestOptions.uri}',
          );
          debugPrint('[API]   data: ${_maskSensitive(response.data)}');
          handler.next(response);
        },
        onError: (error, handler) {
          debugPrint(
            '[API] ✕ ${error.response?.statusCode} '
            '${error.requestOptions.method} '
            '${error.requestOptions.uri}',
          );
          debugPrint('[API]   data: ${_maskSensitive(error.response?.data)}');
          handler.next(error);
        },
      ),
    );
  }

  if (AppEnv.current.sentryDsn.isNotEmpty) {
    dio.addSentry();
  }

  return dio;
});
