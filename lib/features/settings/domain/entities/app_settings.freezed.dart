// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppSettings {

 AppThemeMode get themeMode; bool get quietHoursEnabled; String? get quietHoursStart;// "HH:mm" (24h)
 String? get quietHoursEnd; int get priorityThreshold;// 1 (Min) .. 5 (Urgent); floor for notification suppression
 int? get retentionMaxAgeDays;// null = unlimited ("Forever")
 int? get retentionMaxRows;// internal safety cap, not user-facing
 bool get hideLockScreenContent; bool get analyticsOptOut; bool get biometricLock;
/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<AppSettings> get copyWith => _$AppSettingsCopyWithImpl<AppSettings>(this as AppSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettings&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.quietHoursEnabled, quietHoursEnabled) || other.quietHoursEnabled == quietHoursEnabled)&&(identical(other.quietHoursStart, quietHoursStart) || other.quietHoursStart == quietHoursStart)&&(identical(other.quietHoursEnd, quietHoursEnd) || other.quietHoursEnd == quietHoursEnd)&&(identical(other.priorityThreshold, priorityThreshold) || other.priorityThreshold == priorityThreshold)&&(identical(other.retentionMaxAgeDays, retentionMaxAgeDays) || other.retentionMaxAgeDays == retentionMaxAgeDays)&&(identical(other.retentionMaxRows, retentionMaxRows) || other.retentionMaxRows == retentionMaxRows)&&(identical(other.hideLockScreenContent, hideLockScreenContent) || other.hideLockScreenContent == hideLockScreenContent)&&(identical(other.analyticsOptOut, analyticsOptOut) || other.analyticsOptOut == analyticsOptOut)&&(identical(other.biometricLock, biometricLock) || other.biometricLock == biometricLock));
}


@override
int get hashCode => Object.hash(runtimeType,themeMode,quietHoursEnabled,quietHoursStart,quietHoursEnd,priorityThreshold,retentionMaxAgeDays,retentionMaxRows,hideLockScreenContent,analyticsOptOut,biometricLock);

@override
String toString() {
  return 'AppSettings(themeMode: $themeMode, quietHoursEnabled: $quietHoursEnabled, quietHoursStart: $quietHoursStart, quietHoursEnd: $quietHoursEnd, priorityThreshold: $priorityThreshold, retentionMaxAgeDays: $retentionMaxAgeDays, retentionMaxRows: $retentionMaxRows, hideLockScreenContent: $hideLockScreenContent, analyticsOptOut: $analyticsOptOut, biometricLock: $biometricLock)';
}


}

/// @nodoc
abstract mixin class $AppSettingsCopyWith<$Res>  {
  factory $AppSettingsCopyWith(AppSettings value, $Res Function(AppSettings) _then) = _$AppSettingsCopyWithImpl;
@useResult
$Res call({
 AppThemeMode themeMode, bool quietHoursEnabled, String? quietHoursStart, String? quietHoursEnd, int priorityThreshold, int? retentionMaxAgeDays, int? retentionMaxRows, bool hideLockScreenContent, bool analyticsOptOut, bool biometricLock
});




}
/// @nodoc
class _$AppSettingsCopyWithImpl<$Res>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._self, this._then);

  final AppSettings _self;
  final $Res Function(AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? themeMode = null,Object? quietHoursEnabled = null,Object? quietHoursStart = freezed,Object? quietHoursEnd = freezed,Object? priorityThreshold = null,Object? retentionMaxAgeDays = freezed,Object? retentionMaxRows = freezed,Object? hideLockScreenContent = null,Object? analyticsOptOut = null,Object? biometricLock = null,}) {
  return _then(_self.copyWith(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as AppThemeMode,quietHoursEnabled: null == quietHoursEnabled ? _self.quietHoursEnabled : quietHoursEnabled // ignore: cast_nullable_to_non_nullable
as bool,quietHoursStart: freezed == quietHoursStart ? _self.quietHoursStart : quietHoursStart // ignore: cast_nullable_to_non_nullable
as String?,quietHoursEnd: freezed == quietHoursEnd ? _self.quietHoursEnd : quietHoursEnd // ignore: cast_nullable_to_non_nullable
as String?,priorityThreshold: null == priorityThreshold ? _self.priorityThreshold : priorityThreshold // ignore: cast_nullable_to_non_nullable
as int,retentionMaxAgeDays: freezed == retentionMaxAgeDays ? _self.retentionMaxAgeDays : retentionMaxAgeDays // ignore: cast_nullable_to_non_nullable
as int?,retentionMaxRows: freezed == retentionMaxRows ? _self.retentionMaxRows : retentionMaxRows // ignore: cast_nullable_to_non_nullable
as int?,hideLockScreenContent: null == hideLockScreenContent ? _self.hideLockScreenContent : hideLockScreenContent // ignore: cast_nullable_to_non_nullable
as bool,analyticsOptOut: null == analyticsOptOut ? _self.analyticsOptOut : analyticsOptOut // ignore: cast_nullable_to_non_nullable
as bool,biometricLock: null == biometricLock ? _self.biometricLock : biometricLock // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSettings].
extension AppSettingsPatterns on AppSettings {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettings value)  $default,){
final _that = this;
switch (_that) {
case _AppSettings():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppThemeMode themeMode,  bool quietHoursEnabled,  String? quietHoursStart,  String? quietHoursEnd,  int priorityThreshold,  int? retentionMaxAgeDays,  int? retentionMaxRows,  bool hideLockScreenContent,  bool analyticsOptOut,  bool biometricLock)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.themeMode,_that.quietHoursEnabled,_that.quietHoursStart,_that.quietHoursEnd,_that.priorityThreshold,_that.retentionMaxAgeDays,_that.retentionMaxRows,_that.hideLockScreenContent,_that.analyticsOptOut,_that.biometricLock);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppThemeMode themeMode,  bool quietHoursEnabled,  String? quietHoursStart,  String? quietHoursEnd,  int priorityThreshold,  int? retentionMaxAgeDays,  int? retentionMaxRows,  bool hideLockScreenContent,  bool analyticsOptOut,  bool biometricLock)  $default,) {final _that = this;
switch (_that) {
case _AppSettings():
return $default(_that.themeMode,_that.quietHoursEnabled,_that.quietHoursStart,_that.quietHoursEnd,_that.priorityThreshold,_that.retentionMaxAgeDays,_that.retentionMaxRows,_that.hideLockScreenContent,_that.analyticsOptOut,_that.biometricLock);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppThemeMode themeMode,  bool quietHoursEnabled,  String? quietHoursStart,  String? quietHoursEnd,  int priorityThreshold,  int? retentionMaxAgeDays,  int? retentionMaxRows,  bool hideLockScreenContent,  bool analyticsOptOut,  bool biometricLock)?  $default,) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.themeMode,_that.quietHoursEnabled,_that.quietHoursStart,_that.quietHoursEnd,_that.priorityThreshold,_that.retentionMaxAgeDays,_that.retentionMaxRows,_that.hideLockScreenContent,_that.analyticsOptOut,_that.biometricLock);case _:
  return null;

}
}

}

/// @nodoc


class _AppSettings implements AppSettings {
  const _AppSettings({this.themeMode = AppThemeMode.dark, this.quietHoursEnabled = false, this.quietHoursStart, this.quietHoursEnd, this.priorityThreshold = 1, this.retentionMaxAgeDays, this.retentionMaxRows, this.hideLockScreenContent = false, this.analyticsOptOut = false, this.biometricLock = false});
  

@override@JsonKey() final  AppThemeMode themeMode;
@override@JsonKey() final  bool quietHoursEnabled;
@override final  String? quietHoursStart;
// "HH:mm" (24h)
@override final  String? quietHoursEnd;
@override@JsonKey() final  int priorityThreshold;
// 1 (Min) .. 5 (Urgent); floor for notification suppression
@override final  int? retentionMaxAgeDays;
// null = unlimited ("Forever")
@override final  int? retentionMaxRows;
// internal safety cap, not user-facing
@override@JsonKey() final  bool hideLockScreenContent;
@override@JsonKey() final  bool analyticsOptOut;
@override@JsonKey() final  bool biometricLock;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsCopyWith<_AppSettings> get copyWith => __$AppSettingsCopyWithImpl<_AppSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettings&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.quietHoursEnabled, quietHoursEnabled) || other.quietHoursEnabled == quietHoursEnabled)&&(identical(other.quietHoursStart, quietHoursStart) || other.quietHoursStart == quietHoursStart)&&(identical(other.quietHoursEnd, quietHoursEnd) || other.quietHoursEnd == quietHoursEnd)&&(identical(other.priorityThreshold, priorityThreshold) || other.priorityThreshold == priorityThreshold)&&(identical(other.retentionMaxAgeDays, retentionMaxAgeDays) || other.retentionMaxAgeDays == retentionMaxAgeDays)&&(identical(other.retentionMaxRows, retentionMaxRows) || other.retentionMaxRows == retentionMaxRows)&&(identical(other.hideLockScreenContent, hideLockScreenContent) || other.hideLockScreenContent == hideLockScreenContent)&&(identical(other.analyticsOptOut, analyticsOptOut) || other.analyticsOptOut == analyticsOptOut)&&(identical(other.biometricLock, biometricLock) || other.biometricLock == biometricLock));
}


@override
int get hashCode => Object.hash(runtimeType,themeMode,quietHoursEnabled,quietHoursStart,quietHoursEnd,priorityThreshold,retentionMaxAgeDays,retentionMaxRows,hideLockScreenContent,analyticsOptOut,biometricLock);

@override
String toString() {
  return 'AppSettings(themeMode: $themeMode, quietHoursEnabled: $quietHoursEnabled, quietHoursStart: $quietHoursStart, quietHoursEnd: $quietHoursEnd, priorityThreshold: $priorityThreshold, retentionMaxAgeDays: $retentionMaxAgeDays, retentionMaxRows: $retentionMaxRows, hideLockScreenContent: $hideLockScreenContent, analyticsOptOut: $analyticsOptOut, biometricLock: $biometricLock)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsCopyWith<$Res> implements $AppSettingsCopyWith<$Res> {
  factory _$AppSettingsCopyWith(_AppSettings value, $Res Function(_AppSettings) _then) = __$AppSettingsCopyWithImpl;
@override @useResult
$Res call({
 AppThemeMode themeMode, bool quietHoursEnabled, String? quietHoursStart, String? quietHoursEnd, int priorityThreshold, int? retentionMaxAgeDays, int? retentionMaxRows, bool hideLockScreenContent, bool analyticsOptOut, bool biometricLock
});




}
/// @nodoc
class __$AppSettingsCopyWithImpl<$Res>
    implements _$AppSettingsCopyWith<$Res> {
  __$AppSettingsCopyWithImpl(this._self, this._then);

  final _AppSettings _self;
  final $Res Function(_AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? themeMode = null,Object? quietHoursEnabled = null,Object? quietHoursStart = freezed,Object? quietHoursEnd = freezed,Object? priorityThreshold = null,Object? retentionMaxAgeDays = freezed,Object? retentionMaxRows = freezed,Object? hideLockScreenContent = null,Object? analyticsOptOut = null,Object? biometricLock = null,}) {
  return _then(_AppSettings(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as AppThemeMode,quietHoursEnabled: null == quietHoursEnabled ? _self.quietHoursEnabled : quietHoursEnabled // ignore: cast_nullable_to_non_nullable
as bool,quietHoursStart: freezed == quietHoursStart ? _self.quietHoursStart : quietHoursStart // ignore: cast_nullable_to_non_nullable
as String?,quietHoursEnd: freezed == quietHoursEnd ? _self.quietHoursEnd : quietHoursEnd // ignore: cast_nullable_to_non_nullable
as String?,priorityThreshold: null == priorityThreshold ? _self.priorityThreshold : priorityThreshold // ignore: cast_nullable_to_non_nullable
as int,retentionMaxAgeDays: freezed == retentionMaxAgeDays ? _self.retentionMaxAgeDays : retentionMaxAgeDays // ignore: cast_nullable_to_non_nullable
as int?,retentionMaxRows: freezed == retentionMaxRows ? _self.retentionMaxRows : retentionMaxRows // ignore: cast_nullable_to_non_nullable
as int?,hideLockScreenContent: null == hideLockScreenContent ? _self.hideLockScreenContent : hideLockScreenContent // ignore: cast_nullable_to_non_nullable
as bool,analyticsOptOut: null == analyticsOptOut ? _self.analyticsOptOut : analyticsOptOut // ignore: cast_nullable_to_non_nullable
as bool,biometricLock: null == biometricLock ? _self.biometricLock : biometricLock // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
