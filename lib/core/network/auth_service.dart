import 'package:dio/dio.dart';
import 'package:toy_village_app/core/config/app_env.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppEnv.current.baseUrl,
      headers: {'Origin': 'https://toyvillage.kr'},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<String>? _inFlight;

  Future<String> login() {
    return _inFlight ??= _login().whenComplete(() => _inFlight = null);
  }

  Future<String> _login() async {
    final res = await _dio.post(
      '/auth/login',
      data: {
        'email': AppEnv.current.adminEmail,
        'password': AppEnv.current.adminPassword,
      },
    );
    return res.data['access_token'] as String;
  }
}
