import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';

final authRepositoryProvider =
    Provider((ref) => AuthRepository(ref.read(dioProvider)));

typedef AuthTokens = ({String accessToken, String refreshToken});

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  Future<AuthTokens> login({
    required String username,
    required String password,
  }) async {
    final res = await _dio.post(
      '/app/auth/login',
      data: {'username': username, 'password': password},
    );
    return _tokens(res.data as Map<String, dynamic>);
  }

  Future<AuthTokens> reissue(String refreshToken) async {
    final res = await _dio.post(
      '/app/auth/reissue',
      data: {'refresh_token': refreshToken},
    );
    return _tokens(res.data as Map<String, dynamic>);
  }

  AuthTokens _tokens(Map<String, dynamic> data) => (
    accessToken: data['access_token'] as String,
    refreshToken: data['refresh_token'] as String,
  );

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _dio.patch(
      '/app/auth/password',
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );
  }
}
