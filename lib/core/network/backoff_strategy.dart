import 'dart:math';

class BackoffStrategy {
  final Duration initial;
  final Duration max;
  final double jitter;

  const BackoffStrategy({
    required this.initial,
    required this.max,
    this.jitter = 0.2,
  });

  Duration next(int attempt) {
    final base = initial.inMilliseconds * pow(2, attempt).toInt();

    final capped = min(base, max.inMilliseconds);

    final jitterMs = (capped * jitter * (Random().nextDouble() * 2 - 1))
        .round();

    final result = capped + jitterMs;

    return Duration(milliseconds: result.clamp(0, max.inMilliseconds));
  }

  BackoffStrategy copyWith({Duration? initial, Duration? max, double? jitter}) {
    return BackoffStrategy(
      initial: initial ?? this.initial,
      max: max ?? this.max,
      jitter: jitter ?? this.jitter,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BackoffStrategy &&
        other.initial == initial &&
        other.max == max &&
        other.jitter == jitter;
  }

  @override
  int get hashCode => Object.hash(initial, max, jitter);
}
