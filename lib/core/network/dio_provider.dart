import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/config/app_env.dart';
import 'package:toy_village_app/core/network/auth_service.dart';
import 'package:toy_village_app/core/network/token_store.dart';

final tokenStoreProvider = Provider((ref) => TokenStore());
final authServiceProvider = Provider((ref) => AuthService());

final dioProvider = Provider<Dio>((ref) {
  final store = ref.read(tokenStoreProvider);
  final auth = ref.read(authServiceProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: AppEnv.current.baseUrl,
      headers: {'Origin': 'https://toyvillage.kr'},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        store.accessToken ??= await auth.login();
        options.headers['Authorization'] = 'Bearer ${store.accessToken}';
        handler.next(options);
      },
      onError: (error, handler) async {
        final status = error.response?.statusCode;
        final retried = error.requestOptions.extra['retried'] == true;

        if ((status == 401 || status == 403) && !retried) {
          try {
            store.accessToken = await auth.login();
            final request = error.requestOptions..extra['retried'] = true;
            request.headers['Authorization'] = 'Bearer ${store.accessToken}';
            return handler.resolve(await dio.fetch(request));
          } catch (_) {}
        }
        handler.next(error);
      },
    ),
  );

  return dio;
});
