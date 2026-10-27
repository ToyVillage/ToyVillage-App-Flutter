import 'package:dio/dio.dart';

sealed class AppException implements Exception {
  final String? message;

  const AppException([this.message]);

  factory AppException.from(DioException e) {
    final status = e.response?.statusCode;
    final message = _serverMessage(e.response?.data);
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError => const NetworkException(),
      _ when status == 401 || status == 403 => UnauthorizedException(message),
      _ when status == 404 => NotFoundException(message),
      _ => ServerException(message, statusCode: status),
    };
  }

  static String messageOf(Object error, String fallback) {
    if (error is AppException) return error.message ?? fallback;
    return fallback;
  }

  static String? _serverMessage(Object? data) {
    if (data is! Map) return null;
    for (final key in const ['description', 'message']) {
      final value = data[key];
      if (value is String && value.isNotEmpty) return value;
    }
    return null;
  }
}

class NetworkException extends AppException {
  const NetworkException();
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message]);
}

class NotFoundException extends AppException {
  const NotFoundException([super.message]);
}

class ServerException extends AppException {
  final int? statusCode;

  const ServerException(super.message, {this.statusCode});
}
