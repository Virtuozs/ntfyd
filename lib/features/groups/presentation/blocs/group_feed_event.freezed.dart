// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_feed_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GroupFeedEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupFeedEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GroupFeedEvent()';
}


}

/// @nodoc
class $GroupFeedEventCopyWith<$Res>  {
$GroupFeedEventCopyWith(GroupFeedEvent _, $Res Function(GroupFeedEvent) __);
}


/// Adds pattern-matching-related methods to [GroupFeedEvent].
extension GroupFeedEventPatterns on GroupFeedEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( GroupFeedLoad value)?  load,TResult Function( GroupFeedToggleRead value)?  toggleRead,TResult Function( GroupFeedTogglePin value)?  togglePin,required TResult orElse(),}){
final _that = this;
switch (_that) {
case GroupFeedLoad() when load != null:
return load(_that);case GroupFeedToggleRead() when toggleRead != null:
return toggleRead(_that);case GroupFeedTogglePin() when togglePin != null:
return togglePin(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( GroupFeedLoad value)  load,required TResult Function( GroupFeedToggleRead value)  toggleRead,required TResult Function( GroupFeedTogglePin value)  togglePin,}){
final _that = this;
switch (_that) {
case GroupFeedLoad():
return load(_that);case GroupFeedToggleRead():
return toggleRead(_that);case GroupFeedTogglePin():
return togglePin(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( GroupFeedLoad value)?  load,TResult? Function( GroupFeedToggleRead value)?  toggleRead,TResult? Function( GroupFeedTogglePin value)?  togglePin,}){
final _that = this;
switch (_that) {
case GroupFeedLoad() when load != null:
return load(_that);case GroupFeedToggleRead() when toggleRead != null:
return toggleRead(_that);case GroupFeedTogglePin() when togglePin != null:
return togglePin(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String? groupId)?  load,TResult Function( String serverId,  String id)?  toggleRead,TResult Function( String serverId,  String id)?  togglePin,required TResult orElse(),}) {final _that = this;
switch (_that) {
case GroupFeedLoad() when load != null:
return load(_that.groupId);case GroupFeedToggleRead() when toggleRead != null:
return toggleRead(_that.serverId,_that.id);case GroupFeedTogglePin() when togglePin != null:
return togglePin(_that.serverId,_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String? groupId)  load,required TResult Function( String serverId,  String id)  toggleRead,required TResult Function( String serverId,  String id)  togglePin,}) {final _that = this;
switch (_that) {
case GroupFeedLoad():
return load(_that.groupId);case GroupFeedToggleRead():
return toggleRead(_that.serverId,_that.id);case GroupFeedTogglePin():
return togglePin(_that.serverId,_that.id);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String? groupId)?  load,TResult? Function( String serverId,  String id)?  toggleRead,TResult? Function( String serverId,  String id)?  togglePin,}) {final _that = this;
switch (_that) {
case GroupFeedLoad() when load != null:
return load(_that.groupId);case GroupFeedToggleRead() when toggleRead != null:
return toggleRead(_that.serverId,_that.id);case GroupFeedTogglePin() when togglePin != null:
return togglePin(_that.serverId,_that.id);case _:
  return null;

}
}

}

/// @nodoc


class GroupFeedLoad implements GroupFeedEvent {
  const GroupFeedLoad({this.groupId});
  

 final  String? groupId;

/// Create a copy of GroupFeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupFeedLoadCopyWith<GroupFeedLoad> get copyWith => _$GroupFeedLoadCopyWithImpl<GroupFeedLoad>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupFeedLoad&&(identical(other.groupId, groupId) || other.groupId == groupId));
}


@override
int get hashCode => Object.hash(runtimeType,groupId);

@override
String toString() {
  return 'GroupFeedEvent.load(groupId: $groupId)';
}


}

/// @nodoc
abstract mixin class $GroupFeedLoadCopyWith<$Res> implements $GroupFeedEventCopyWith<$Res> {
  factory $GroupFeedLoadCopyWith(GroupFeedLoad value, $Res Function(GroupFeedLoad) _then) = _$GroupFeedLoadCopyWithImpl;
@useResult
$Res call({
 String? groupId
});




}
/// @nodoc
class _$GroupFeedLoadCopyWithImpl<$Res>
    implements $GroupFeedLoadCopyWith<$Res> {
  _$GroupFeedLoadCopyWithImpl(this._self, this._then);

  final GroupFeedLoad _self;
  final $Res Function(GroupFeedLoad) _then;

/// Create a copy of GroupFeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? groupId = freezed,}) {
  return _then(GroupFeedLoad(
groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class GroupFeedToggleRead implements GroupFeedEvent {
  const GroupFeedToggleRead({required this.serverId, required this.id});
  

 final  String serverId;
 final  String id;

/// Create a copy of GroupFeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupFeedToggleReadCopyWith<GroupFeedToggleRead> get copyWith => _$GroupFeedToggleReadCopyWithImpl<GroupFeedToggleRead>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupFeedToggleRead&&(identical(other.serverId, serverId) || other.serverId == serverId)&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,serverId,id);

@override
String toString() {
  return 'GroupFeedEvent.toggleRead(serverId: $serverId, id: $id)';
}


}

/// @nodoc
abstract mixin class $GroupFeedToggleReadCopyWith<$Res> implements $GroupFeedEventCopyWith<$Res> {
  factory $GroupFeedToggleReadCopyWith(GroupFeedToggleRead value, $Res Function(GroupFeedToggleRead) _then) = _$GroupFeedToggleReadCopyWithImpl;
@useResult
$Res call({
 String serverId, String id
});




}
/// @nodoc
class _$GroupFeedToggleReadCopyWithImpl<$Res>
    implements $GroupFeedToggleReadCopyWith<$Res> {
  _$GroupFeedToggleReadCopyWithImpl(this._self, this._then);

  final GroupFeedToggleRead _self;
  final $Res Function(GroupFeedToggleRead) _then;

/// Create a copy of GroupFeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? serverId = null,Object? id = null,}) {
  return _then(GroupFeedToggleRead(
serverId: null == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class GroupFeedTogglePin implements GroupFeedEvent {
  const GroupFeedTogglePin({required this.serverId, required this.id});
  

 final  String serverId;
 final  String id;

/// Create a copy of GroupFeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupFeedTogglePinCopyWith<GroupFeedTogglePin> get copyWith => _$GroupFeedTogglePinCopyWithImpl<GroupFeedTogglePin>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupFeedTogglePin&&(identical(other.serverId, serverId) || other.serverId == serverId)&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,serverId,id);

@override
String toString() {
  return 'GroupFeedEvent.togglePin(serverId: $serverId, id: $id)';
}


}

/// @nodoc
abstract mixin class $GroupFeedTogglePinCopyWith<$Res> implements $GroupFeedEventCopyWith<$Res> {
  factory $GroupFeedTogglePinCopyWith(GroupFeedTogglePin value, $Res Function(GroupFeedTogglePin) _then) = _$GroupFeedTogglePinCopyWithImpl;
@useResult
$Res call({
 String serverId, String id
});




}
/// @nodoc
class _$GroupFeedTogglePinCopyWithImpl<$Res>
    implements $GroupFeedTogglePinCopyWith<$Res> {
  _$GroupFeedTogglePinCopyWithImpl(this._self, this._then);

  final GroupFeedTogglePin _self;
  final $Res Function(GroupFeedTogglePin) _then;

/// Create a copy of GroupFeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? serverId = null,Object? id = null,}) {
  return _then(GroupFeedTogglePin(
serverId: null == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
