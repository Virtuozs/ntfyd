import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';

part 'subscription.freezed.dart';

@freezed
abstract class Subscription with _$Subscription {
  const factory Subscription({
    required String id,
    required String serverId,
    required String topic,
    required String displayName,
    @Default(1) int priorityThreshold,
    @Default(false) bool muted,
    @Default(false) bool pinned,
    required DateTime createdAt,
  }) = _Subscription;

  const Subscription._();

  /// Validates a candidate [Subscription], returning a [Result] containing
  /// either a valid [Subscription] or a [Failure.validation].
  ///
  /// Blank/null [displayName] falls back to [topic] (mirrors
  /// [ServerConfig.validate]'s host-fallback behavior).
  static Result<Subscription> validate({
    required String id,
    required String serverId,
    required String topic,
    String? displayName,
    int priorityThreshold = 1,
    bool muted = false,
    bool pinned = false,
    required DateTime createdAt,
  }) {
    if (topic.trim().isEmpty) {
      return const Result.err(
        Failure.validation(field: 'topic', message: 'topic must not be empty'),
      );
    }

    if (priorityThreshold < 1 || priorityThreshold > 5) {
      return const Result.err(
        Failure.validation(
          field: 'priorityThreshold',
          message: 'priorityThreshold must be between 1 and 5',
        ),
      );
    }

    final resolvedDisplayName = (displayName == null || displayName.trim().isEmpty)
        ? topic
        : displayName;

    return Result.success(
      Subscription(
        id: id,
        serverId: serverId,
        topic: topic,
        displayName: resolvedDisplayName,
        priorityThreshold: priorityThreshold,
        muted: muted,
        pinned: pinned,
        createdAt: createdAt,
      ),
    );
  }
}
