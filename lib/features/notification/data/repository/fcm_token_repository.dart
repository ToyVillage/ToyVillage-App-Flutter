import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/network/api_endpoints.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';

final fcmTokenRepositoryProvider = Provider(
  (ref) => FcmTokenRepository(ref.read(dioProvider)),
);

class FcmTokenRepository {
  final Dio _dio;

  FcmTokenRepository(this._dio);

  Future<void> register(String token) =>
      _dio.post(ApiEndpoints.fcmToken, data: {'token': token});

  Future<void> remove(String token) =>
      _dio.delete(ApiEndpoints.fcmToken, data: {'token': token});
}
