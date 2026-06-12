import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const factory Failure.network({
    required String message,
    int? statusCode,
  }) = NetworkFailure;

  const factory Failure.auth({
    required int statusCode,
  }) = AuthFailure;

  const factory Failure.notFound() = NotFoundFailure;

  const factory Failure.rateLimit({
    Duration? retryAfter,
  }) = RateLimitFailure;

  const factory Failure.server({
    required int statusCode,
    required String message,
  }) = ServerFailure;

  const factory Failure.cache({
    required String message,
  }) = CacheFailure;

  const factory Failure.validation({
    required String field,
    required String message,
  }) = ValidationFailure;

  const factory Failure.biometric({
    required String reason,
  }) = BiometricFailure;

  const factory Failure.unknown({
    required String message,
  }) = UnknownFailure;
}