import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';

final authRepositoryProvider =
    Provider((ref) => AuthRepository(ref.read(dioProvider)));

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  Future<String> login({
    required String username,
    required String password,
  }) async {
    final res = await _dio.post(
      '/app/auth/login',
      data: {'username': username, 'password': password},
    );
    return res.data['access_token'] as String;
  }
}
