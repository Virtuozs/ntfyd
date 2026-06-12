enum Priority {
  min, // 1
  low, // 2
  defaultPriority, // 3
  high, // 4
  max, // 5
}

enum PriorityColorTier { red, blue, grey }

extension PriorityX on Priority {
  /// Maps to the 1–5 integer used in ntfy's wire format.
  int toInt() {
    return switch (this) {
      Priority.min => 1,
      Priority.low => 2,
      Priority.defaultPriority => 3,
      Priority.high => 4,
      Priority.max => 5,
    };
  }

  /// Maps to ntfy's canonical name string ('min', 'low', 'default',
  /// 'high', 'max'). Used for notification channel IDs and headers.
  String toName() {
    return switch (this) {
      Priority.min => 'min',
      Priority.low => 'low',
      Priority.defaultPriority => 'default',
      Priority.high => 'high',
      Priority.max => 'max',
    };
  }

  /// Notification channel ID for this priority, per P7-4:
  /// 'ntfyd_priority_<1-5>'.
  String channelId() => 'ntfyd_priority_${toInt()}';

  /// Color tier per D16.
  PriorityColorTier get colorTier {
    return switch (this) {
      Priority.max || Priority.high => PriorityColorTier.red,
      Priority.defaultPriority => PriorityColorTier.blue,
      Priority.low || Priority.min => PriorityColorTier.grey,
    };
  }
}

extension PriorityParsing on Priority {
  static Priority fromInt(int value) {
    return switch (value) {
      1 => Priority.min,
      2 => Priority.low,
      3 => Priority.defaultPriority,
      4 => Priority.high,
      5 => Priority.max,
      _ => throw ArgumentError.value(
        value,
        'value',
        'Priority must be in range 1-5',
      ),
    };
  }

  /// Parses ntfy priority name strings, including aliases:
  /// 'min'=1, 'low'=2, 'default'=3, 'high'=4, 'max'/'urgent'=5.
  static Priority fromString(String value) {
    return switch (value.toLowerCase()) {
      'min' => Priority.min,
      'low' => Priority.low,
      'default' => Priority.defaultPriority,
      'high' => Priority.high,
      'max' || 'urgent' => Priority.max,
      _ => throw ArgumentError.value(value, 'value', 'Unknown priority name'),
    };
  }
}
