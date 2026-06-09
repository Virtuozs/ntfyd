import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ntfyd/core/error/failures.dart';


part 'result.freezed.dart';

/// The single return type for every use case and repository method.
@freezed
sealed class Result<T> with _$Result<T> {
  const factory Result.success(T value) = Success<T>;
  const factory Result.err(Failure failure) = Err<T>;
}

/// Convenience extensions so callers can write:
///   if (result.isSuccess) { ... }
///   final value = result.valueOrThrow;
extension ResultX<T> on Result<T> {
  /// Returns true if this is a [Success].
  bool get isSuccess => this is Success<T>;

  /// Returns the value if [Success], otherwise throws [StateError].
  ///
  /// Only call this after confirming [isSuccess] is true, or inside
  /// a when() success branch. Calling it on [Err] is a programming mistake.
  T get valueOrThrow {
    if (this is Success<T>) return (this as Success<T>).value;
    throw StateError(
      'Called valueOrThrow on an Err result. '
      'Check isSuccess before accessing the value.',
    );
  }

  /// Returns the [Failure] if [Err], otherwise throws [StateError].
  ///
  /// Only call this after confirming [isSuccess] is false, or inside
  /// a when() err branch.
  Failure get failureOrThrow {
    if (this is Err<T>) return (this as Err<T>).failure;
    throw StateError(
      'Called failureOrThrow on a Success result. '
      'Check isSuccess before accessing the failure.',
    );
  }
}