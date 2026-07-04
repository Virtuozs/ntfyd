import 'package:flutter/material.dart';

/// Used on: MessageCard left-edge accent bar, Priority chips.
abstract final class PriorityColors {
  /// Priority 5 (max/urgent) and 4 (high) → red
  static const Color high = Color(0xFFB71C1C); // red.shade900

  /// Priority 3 (default) → blue
  static const Color medium = Color(0xFF1565C0); // blue.shade800

  /// Priority 2 (low) and 1 (min) → grey
  static const Color low = Color(0xFF757575); // grey.shade600

  /// Returns the accent color for a given priority level [1–5].
  static Color forPriority(int priority) {
    return switch (priority) {
      5 || 4 => high,
      3 => medium,
      _ => low,
    };
  }
}

/// App-wide spacing constants.
abstract final class Spacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
}

/// Priority accent bar width in MessageCard.
abstract final class AppDimensions {
  static const double priorityBarWidth = 4.0;
  static const double cardBorderRadius = 12.0;
  static const double avatarSize = 40.0;
}

abstract final class DefaultPalette {
  /// App background (Scaffold background).
  static const Color background = Color(0xFF0D0F12);

  /// Card / input field surface (e.g. Server URL, Username, Password fields).
  static const Color cardSurface = Color(0xFF161A20);

  /// Primary accent — used for the "Connect" button background.
  static const Color primary = Color(0xFF6EA8FE);

  /// Text/icon color on top of [primary] (e.g. "Connect" button label).
  static const Color onPrimary = Color(0xFF0D0F12);

  /// Primary text color (titles, e.g. "ntfyd").
  static const Color onSurface = Color(0xFFF3F5F7);

  /// Secondary/muted text color (subtitles, footer text, placeholders).
  static const Color onSurfaceVariant = Color(0xFF9CA3AF);
}
