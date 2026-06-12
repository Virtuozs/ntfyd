// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HealthDto {

 bool get healthy;
/// Create a copy of HealthDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthDtoCopyWith<HealthDto> get copyWith => _$HealthDtoCopyWithImpl<HealthDto>(this as HealthDto, _$identity);

  /// Serializes this HealthDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthDto&&(identical(other.healthy, healthy) || other.healthy == healthy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,healthy);

@override
String toString() {
  return 'HealthDto(healthy: $healthy)';
}


}

/// @nodoc
abstract mixin class $HealthDtoCopyWith<$Res>  {
  factory $HealthDtoCopyWith(HealthDto value, $Res Function(HealthDto) _then) = _$HealthDtoCopyWithImpl;
@useResult
$Res call({
 bool healthy
});




}
/// @nodoc
class _$HealthDtoCopyWithImpl<$Res>
    implements $HealthDtoCopyWith<$Res> {
  _$HealthDtoCopyWithImpl(this._self, this._then);

  final HealthDto _self;
  final $Res Function(HealthDto) _then;

/// Create a copy of HealthDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? healthy = null,}) {
  return _then(_self.copyWith(
healthy: null == healthy ? _self.healthy : healthy // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthDto].
extension HealthDtoPatterns on HealthDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthDto value)  $default,){
final _that = this;
switch (_that) {
case _HealthDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthDto value)?  $default,){
final _that = this;
switch (_that) {
case _HealthDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool healthy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthDto() when $default != null:
return $default(_that.healthy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool healthy)  $default,) {final _that = this;
switch (_that) {
case _HealthDto():
return $default(_that.healthy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool healthy)?  $default,) {final _that = this;
switch (_that) {
case _HealthDto() when $default != null:
return $default(_that.healthy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HealthDto implements HealthDto {
  const _HealthDto({required this.healthy});
  factory _HealthDto.fromJson(Map<String, dynamic> json) => _$HealthDtoFromJson(json);

@override final  bool healthy;

/// Create a copy of HealthDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthDtoCopyWith<_HealthDto> get copyWith => __$HealthDtoCopyWithImpl<_HealthDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HealthDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthDto&&(identical(other.healthy, healthy) || other.healthy == healthy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,healthy);

@override
String toString() {
  return 'HealthDto(healthy: $healthy)';
}


}

/// @nodoc
abstract mixin class _$HealthDtoCopyWith<$Res> implements $HealthDtoCopyWith<$Res> {
  factory _$HealthDtoCopyWith(_HealthDto value, $Res Function(_HealthDto) _then) = __$HealthDtoCopyWithImpl;
@override @useResult
$Res call({
 bool healthy
});




}
/// @nodoc
class __$HealthDtoCopyWithImpl<$Res>
    implements _$HealthDtoCopyWith<$Res> {
  __$HealthDtoCopyWithImpl(this._self, this._then);

  final _HealthDto _self;
  final $Res Function(_HealthDto) _then;

/// Create a copy of HealthDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? healthy = null,}) {
  return _then(_HealthDto(
healthy: null == healthy ? _self.healthy : healthy // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
