// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FeedEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FeedEvent()';
}


}

/// @nodoc
class $FeedEventCopyWith<$Res>  {
$FeedEventCopyWith(FeedEvent _, $Res Function(FeedEvent) __);
}


/// Adds pattern-matching-related methods to [FeedEvent].
extension FeedEventPatterns on FeedEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FeedLoad value)?  load,TResult Function( FeedRefresh value)?  refresh,TResult Function( FeedToggleRead value)?  toggleRead,TResult Function( FeedTogglePin value)?  togglePin,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FeedLoad() when load != null:
return load(_that);case FeedRefresh() when refresh != null:
return refresh(_that);case FeedToggleRead() when toggleRead != null:
return toggleRead(_that);case FeedTogglePin() when togglePin != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FeedLoad value)  load,required TResult Function( FeedRefresh value)  refresh,required TResult Function( FeedToggleRead value)  toggleRead,required TResult Function( FeedTogglePin value)  togglePin,}){
final _that = this;
switch (_that) {
case FeedLoad():
return load(_that);case FeedRefresh():
return refresh(_that);case FeedToggleRead():
return toggleRead(_that);case FeedTogglePin():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FeedLoad value)?  load,TResult? Function( FeedRefresh value)?  refresh,TResult? Function( FeedToggleRead value)?  toggleRead,TResult? Function( FeedTogglePin value)?  togglePin,}){
final _that = this;
switch (_that) {
case FeedLoad() when load != null:
return load(_that);case FeedRefresh() when refresh != null:
return refresh(_that);case FeedToggleRead() when toggleRead != null:
return toggleRead(_that);case FeedTogglePin() when togglePin != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String serverId,  String topic)?  load,TResult Function()?  refresh,TResult Function( String id)?  toggleRead,TResult Function( String id)?  togglePin,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FeedLoad() when load != null:
return load(_that.serverId,_that.topic);case FeedRefresh() when refresh != null:
return refresh();case FeedToggleRead() when toggleRead != null:
return toggleRead(_that.id);case FeedTogglePin() when togglePin != null:
return togglePin(_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String serverId,  String topic)  load,required TResult Function()  refresh,required TResult Function( String id)  toggleRead,required TResult Function( String id)  togglePin,}) {final _that = this;
switch (_that) {
case FeedLoad():
return load(_that.serverId,_that.topic);case FeedRefresh():
return refresh();case FeedToggleRead():
return toggleRead(_that.id);case FeedTogglePin():
return togglePin(_that.id);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String serverId,  String topic)?  load,TResult? Function()?  refresh,TResult? Function( String id)?  toggleRead,TResult? Function( String id)?  togglePin,}) {final _that = this;
switch (_that) {
case FeedLoad() when load != null:
return load(_that.serverId,_that.topic);case FeedRefresh() when refresh != null:
return refresh();case FeedToggleRead() when toggleRead != null:
return toggleRead(_that.id);case FeedTogglePin() when togglePin != null:
return togglePin(_that.id);case _:
  return null;

}
}

}

/// @nodoc


class FeedLoad implements FeedEvent {
  const FeedLoad({required this.serverId, required this.topic});
  

 final  String serverId;
 final  String topic;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedLoadCopyWith<FeedLoad> get copyWith => _$FeedLoadCopyWithImpl<FeedLoad>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedLoad&&(identical(other.serverId, serverId) || other.serverId == serverId)&&(identical(other.topic, topic) || other.topic == topic));
}


@override
int get hashCode => Object.hash(runtimeType,serverId,topic);

@override
String toString() {
  return 'FeedEvent.load(serverId: $serverId, topic: $topic)';
}


}

/// @nodoc
abstract mixin class $FeedLoadCopyWith<$Res> implements $FeedEventCopyWith<$Res> {
  factory $FeedLoadCopyWith(FeedLoad value, $Res Function(FeedLoad) _then) = _$FeedLoadCopyWithImpl;
@useResult
$Res call({
 String serverId, String topic
});




}
/// @nodoc
class _$FeedLoadCopyWithImpl<$Res>
    implements $FeedLoadCopyWith<$Res> {
  _$FeedLoadCopyWithImpl(this._self, this._then);

  final FeedLoad _self;
  final $Res Function(FeedLoad) _then;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? serverId = null,Object? topic = null,}) {
  return _then(FeedLoad(
serverId: null == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class FeedRefresh implements FeedEvent {
  const FeedRefresh();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedRefresh);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FeedEvent.refresh()';
}


}




/// @nodoc


class FeedToggleRead implements FeedEvent {
  const FeedToggleRead({required this.id});
  

 final  String id;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedToggleReadCopyWith<FeedToggleRead> get copyWith => _$FeedToggleReadCopyWithImpl<FeedToggleRead>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedToggleRead&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'FeedEvent.toggleRead(id: $id)';
}


}

/// @nodoc
abstract mixin class $FeedToggleReadCopyWith<$Res> implements $FeedEventCopyWith<$Res> {
  factory $FeedToggleReadCopyWith(FeedToggleRead value, $Res Function(FeedToggleRead) _then) = _$FeedToggleReadCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$FeedToggleReadCopyWithImpl<$Res>
    implements $FeedToggleReadCopyWith<$Res> {
  _$FeedToggleReadCopyWithImpl(this._self, this._then);

  final FeedToggleRead _self;
  final $Res Function(FeedToggleRead) _then;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(FeedToggleRead(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class FeedTogglePin implements FeedEvent {
  const FeedTogglePin({required this.id});
  

 final  String id;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedTogglePinCopyWith<FeedTogglePin> get copyWith => _$FeedTogglePinCopyWithImpl<FeedTogglePin>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedTogglePin&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'FeedEvent.togglePin(id: $id)';
}


}

/// @nodoc
abstract mixin class $FeedTogglePinCopyWith<$Res> implements $FeedEventCopyWith<$Res> {
  factory $FeedTogglePinCopyWith(FeedTogglePin value, $Res Function(FeedTogglePin) _then) = _$FeedTogglePinCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$FeedTogglePinCopyWithImpl<$Res>
    implements $FeedTogglePinCopyWith<$Res> {
  _$FeedTogglePinCopyWithImpl(this._self, this._then);

  final FeedTogglePin _self;
  final $Res Function(FeedTogglePin) _then;

/// Create a copy of FeedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(FeedTogglePin(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
