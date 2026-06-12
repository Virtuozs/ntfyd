import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ntfyd/core/error/failures.dart';

class ExceptionMapper {
  static Failure map(Object exception) {
    if (exception is DioException) {
      return _mapDio(exception);
    }
    if (exception is SocketException) {
      return Failure.network(message: exception.message);
    }
    if (exception is FormatException) {
      return Failure.unknown(message: exception.message);
    }
    return Failure.unknown(message: exception.toString());
  }

  static Failure _mapDio(DioException e) {
    final statusCode = e.response?.statusCode;

    switch (statusCode) {
      case 401:
        return const Failure.auth(statusCode: 401);
      case 403:
        return const Failure.auth(statusCode: 403);
      case 404:
        return const Failure.notFound();
      case 429:
        return const Failure.rateLimit();
      default:
        if (statusCode != null && statusCode >= 500) {
          return Failure.server(
            statusCode: statusCode,
            message: e.message ?? 'Server error',
          );
        }
        if (e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.connectionTimeout) {
          return Failure.network(
            message: e.message ?? 'Connection error',
            statusCode: statusCode,
          );
        }
        return Failure.unknown(message: e.message ?? 'Unknown error');
    }
  }
}