// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_membership.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GroupMembership {

 String get serverId; String get topic;
/// Create a copy of GroupMembership
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupMembershipCopyWith<GroupMembership> get copyWith => _$GroupMembershipCopyWithImpl<GroupMembership>(this as GroupMembership, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupMembership&&(identical(other.serverId, serverId) || other.serverId == serverId)&&(identical(other.topic, topic) || other.topic == topic));
}


@override
int get hashCode => Object.hash(runtimeType,serverId,topic);

@override
String toString() {
  return 'GroupMembership(serverId: $serverId, topic: $topic)';
}


}

/// @nodoc
abstract mixin class $GroupMembershipCopyWith<$Res>  {
  factory $GroupMembershipCopyWith(GroupMembership value, $Res Function(GroupMembership) _then) = _$GroupMembershipCopyWithImpl;
@useResult
$Res call({
 String serverId, String topic
});




}
/// @nodoc
class _$GroupMembershipCopyWithImpl<$Res>
    implements $GroupMembershipCopyWith<$Res> {
  _$GroupMembershipCopyWithImpl(this._self, this._then);

  final GroupMembership _self;
  final $Res Function(GroupMembership) _then;

/// Create a copy of GroupMembership
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? serverId = null,Object? topic = null,}) {
  return _then(_self.copyWith(
serverId: null == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupMembership].
extension GroupMembershipPatterns on GroupMembership {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupMembership value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupMembership() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupMembership value)  $default,){
final _that = this;
switch (_that) {
case _GroupMembership():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupMembership value)?  $default,){
final _that = this;
switch (_that) {
case _GroupMembership() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String serverId,  String topic)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupMembership() when $default != null:
return $default(_that.serverId,_that.topic);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String serverId,  String topic)  $default,) {final _that = this;
switch (_that) {
case _GroupMembership():
return $default(_that.serverId,_that.topic);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String serverId,  String topic)?  $default,) {final _that = this;
switch (_that) {
case _GroupMembership() when $default != null:
return $default(_that.serverId,_that.topic);case _:
  return null;

}
}

}

/// @nodoc


class _GroupMembership implements GroupMembership {
  const _GroupMembership({required this.serverId, required this.topic});
  

@override final  String serverId;
@override final  String topic;

/// Create a copy of GroupMembership
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupMembershipCopyWith<_GroupMembership> get copyWith => __$GroupMembershipCopyWithImpl<_GroupMembership>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupMembership&&(identical(other.serverId, serverId) || other.serverId == serverId)&&(identical(other.topic, topic) || other.topic == topic));
}


@override
int get hashCode => Object.hash(runtimeType,serverId,topic);

@override
String toString() {
  return 'GroupMembership(serverId: $serverId, topic: $topic)';
}


}

/// @nodoc
abstract mixin class _$GroupMembershipCopyWith<$Res> implements $GroupMembershipCopyWith<$Res> {
  factory _$GroupMembershipCopyWith(_GroupMembership value, $Res Function(_GroupMembership) _then) = __$GroupMembershipCopyWithImpl;
@override @useResult
$Res call({
 String serverId, String topic
});




}
/// @nodoc
class __$GroupMembershipCopyWithImpl<$Res>
    implements _$GroupMembershipCopyWith<$Res> {
  __$GroupMembershipCopyWithImpl(this._self, this._then);

  final _GroupMembership _self;
  final $Res Function(_GroupMembership) _then;

/// Create a copy of GroupMembership
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? serverId = null,Object? topic = null,}) {
  return _then(_GroupMembership(
serverId: null == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
