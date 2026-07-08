import 'package:dio/dio.dart';
import 'package:toy_village_app/core/config/app_env.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppEnv.current.baseUrl,
      headers: {'Origin': 'https://toyvillage.kr'},
    ),
  );

  Future<String> login() async {
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
