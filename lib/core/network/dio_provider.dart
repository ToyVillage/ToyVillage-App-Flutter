import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/config/app_env.dart';
import 'package:toy_village_app/core/network/token_store.dart';

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

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = store.accessToken;
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        final status = error.response?.statusCode;
        final path = error.requestOptions.path;
        final isAuthCall = path.contains('/app/auth/');
        final alreadyRetried = error.requestOptions.extra['__retried'] == true;

        if (status == 401 &&
            !isAuthCall &&
            !alreadyRetried &&
            store.refreshToken != null) {
          try {
            final res = await dio.post(
              '/app/auth/reissue',
              data: {'refresh_token': store.refreshToken},
            );
            final data = res.data as Map<String, dynamic>;
            await store.setTokens(
              accessToken: data['access_token'] as String,
              refreshToken: data['refresh_token'] as String,
            );
            final options = error.requestOptions
              ..headers['Authorization'] = 'Bearer ${store.accessToken}'
              ..extra['__retried'] = true;
            final response = await dio.fetch(options);
            return handler.resolve(response);
          } catch (_) {
            await store.clear();
            return handler.next(error);
          }
        }

        if (status == 401 || status == 403) {
          store.accessToken = null;
        }
        handler.next(error);
      },
    ),
  );

  return dio;
});
