import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/network/app_exception.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';

typedef JsonMap = Map<String, dynamic>;
typedef FromJson<T> = T Function(JsonMap json);

final apiClientProvider = Provider((ref) => ApiClient(ref.read(dioProvider)));

List<T> parseList<T>(Object? raw, FromJson<T> fromJson) => [
  for (final e in (raw as List? ?? const [])) fromJson(e as JsonMap),
];

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  Future<dynamic> get(String path, {JsonMap? query}) =>
      _send(() => _dio.get(path, queryParameters: query));

  Future<dynamic> post(String path, {Object? data}) =>
      _send(() => _dio.post(path, data: data));

  Future<dynamic> put(String path, {Object? data}) =>
      _send(() => _dio.put(path, data: data));

  Future<dynamic> patch(String path, {Object? data}) =>
      _send(() => _dio.patch(path, data: data));

  Future<dynamic> delete(String path) => _send(() => _dio.delete(path));

  Future<T> getObject<T>(
    String path,
    FromJson<T> fromJson, {
    JsonMap? query,
  }) async => fromJson(await get(path, query: query) as JsonMap);

  Future<List<T>> getList<T>(
    String path,
    FromJson<T> fromJson, {
    JsonMap? query,
    String? key,
  }) async {
    final data = await get(path, query: query);
    final raw = key != null && data is JsonMap ? data[key] : data;
    return parseList(raw, fromJson);
  }

  Future<dynamic> _send(Future<Response<dynamic>> Function() request) async {
    try {
      return (await request()).data;
    } on DioException catch (e) {
      throw AppException.from(e);
    }
  }
}
