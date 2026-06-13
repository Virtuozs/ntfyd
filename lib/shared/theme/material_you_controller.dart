import 'package:flutter/foundation.dart';

/// Controls whether the app uses Material You (dynamic color) theming.
///
/// TODO: Replace this with a value derived from
/// `AppSettings.dynamicColor` via `SettingsCubit`/`SettingsDao`. Keep the
/// `ValueListenable<bool>` contract so [DynamicColorWrapper] doesn't need to change
/// `SettingsCubit` can be bridged to this via `BlocSelector`/a small adapter `ValueNotifier`.
class MaterialYouController extends ValueNotifier<bool> {
  MaterialYouController({bool initial = false}) : super(initial);
}
