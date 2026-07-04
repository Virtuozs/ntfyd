// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SubscriptionEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SubscriptionEvent()';
}


}

/// @nodoc
class $SubscriptionEventCopyWith<$Res>  {
$SubscriptionEventCopyWith(SubscriptionEvent _, $Res Function(SubscriptionEvent) __);
}


/// Adds pattern-matching-related methods to [SubscriptionEvent].
extension SubscriptionEventPatterns on SubscriptionEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SubscriptionLoad value)?  load,TResult Function( SubscriptionSubscribe value)?  subscribe,TResult Function( SubscriptionUnsubscribe value)?  unsubscribe,TResult Function( SubscriptionTogglePin value)?  togglePin,TResult Function( SubscriptionToggleMute value)?  toggleMute,TResult Function( SubscriptionUpdateThreshold value)?  updateThreshold,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SubscriptionLoad() when load != null:
return load(_that);case SubscriptionSubscribe() when subscribe != null:
return subscribe(_that);case SubscriptionUnsubscribe() when unsubscribe != null:
return unsubscribe(_that);case SubscriptionTogglePin() when togglePin != null:
return togglePin(_that);case SubscriptionToggleMute() when toggleMute != null:
return toggleMute(_that);case SubscriptionUpdateThreshold() when updateThreshold != null:
return updateThreshold(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SubscriptionLoad value)  load,required TResult Function( SubscriptionSubscribe value)  subscribe,required TResult Function( SubscriptionUnsubscribe value)  unsubscribe,required TResult Function( SubscriptionTogglePin value)  togglePin,required TResult Function( SubscriptionToggleMute value)  toggleMute,required TResult Function( SubscriptionUpdateThreshold value)  updateThreshold,}){
final _that = this;
switch (_that) {
case SubscriptionLoad():
return load(_that);case SubscriptionSubscribe():
return subscribe(_that);case SubscriptionUnsubscribe():
return unsubscribe(_that);case SubscriptionTogglePin():
return togglePin(_that);case SubscriptionToggleMute():
return toggleMute(_that);case SubscriptionUpdateThreshold():
return updateThreshold(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SubscriptionLoad value)?  load,TResult? Function( SubscriptionSubscribe value)?  subscribe,TResult? Function( SubscriptionUnsubscribe value)?  unsubscribe,TResult? Function( SubscriptionTogglePin value)?  togglePin,TResult? Function( SubscriptionToggleMute value)?  toggleMute,TResult? Function( SubscriptionUpdateThreshold value)?  updateThreshold,}){
final _that = this;
switch (_that) {
case SubscriptionLoad() when load != null:
return load(_that);case SubscriptionSubscribe() when subscribe != null:
return subscribe(_that);case SubscriptionUnsubscribe() when unsubscribe != null:
return unsubscribe(_that);case SubscriptionTogglePin() when togglePin != null:
return togglePin(_that);case SubscriptionToggleMute() when toggleMute != null:
return toggleMute(_that);case SubscriptionUpdateThreshold() when updateThreshold != null:
return updateThreshold(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String serverId)?  load,TResult Function( String serverId,  String topic,  String? displayName)?  subscribe,TResult Function( String serverId,  String topic)?  unsubscribe,TResult Function( String id)?  togglePin,TResult Function( String id)?  toggleMute,TResult Function( String id,  int threshold)?  updateThreshold,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SubscriptionLoad() when load != null:
return load(_that.serverId);case SubscriptionSubscribe() when subscribe != null:
return subscribe(_that.serverId,_that.topic,_that.displayName);case SubscriptionUnsubscribe() when unsubscribe != null:
return unsubscribe(_that.serverId,_that.topic);case SubscriptionTogglePin() when togglePin != null:
return togglePin(_that.id);case SubscriptionToggleMute() when toggleMute != null:
return toggleMute(_that.id);case SubscriptionUpdateThreshold() when updateThreshold != null:
return updateThreshold(_that.id,_that.threshold);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String serverId)  load,required TResult Function( String serverId,  String topic,  String? displayName)  subscribe,required TResult Function( String serverId,  String topic)  unsubscribe,required TResult Function( String id)  togglePin,required TResult Function( String id)  toggleMute,required TResult Function( String id,  int threshold)  updateThreshold,}) {final _that = this;
switch (_that) {
case SubscriptionLoad():
return load(_that.serverId);case SubscriptionSubscribe():
return subscribe(_that.serverId,_that.topic,_that.displayName);case SubscriptionUnsubscribe():
return unsubscribe(_that.serverId,_that.topic);case SubscriptionTogglePin():
return togglePin(_that.id);case SubscriptionToggleMute():
return toggleMute(_that.id);case SubscriptionUpdateThreshold():
return updateThreshold(_that.id,_that.threshold);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String serverId)?  load,TResult? Function( String serverId,  String topic,  String? displayName)?  subscribe,TResult? Function( String serverId,  String topic)?  unsubscribe,TResult? Function( String id)?  togglePin,TResult? Function( String id)?  toggleMute,TResult? Function( String id,  int threshold)?  updateThreshold,}) {final _that = this;
switch (_that) {
case SubscriptionLoad() when load != null:
return load(_that.serverId);case SubscriptionSubscribe() when subscribe != null:
return subscribe(_that.serverId,_that.topic,_that.displayName);case SubscriptionUnsubscribe() when unsubscribe != null:
return unsubscribe(_that.serverId,_that.topic);case SubscriptionTogglePin() when togglePin != null:
return togglePin(_that.id);case SubscriptionToggleMute() when toggleMute != null:
return toggleMute(_that.id);case SubscriptionUpdateThreshold() when updateThreshold != null:
return updateThreshold(_that.id,_that.threshold);case _:
  return null;

}
}

}

/// @nodoc


class SubscriptionLoad implements SubscriptionEvent {
  const SubscriptionLoad({required this.serverId});
  

 final  String serverId;

/// Create a copy of SubscriptionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionLoadCopyWith<SubscriptionLoad> get copyWith => _$SubscriptionLoadCopyWithImpl<SubscriptionLoad>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionLoad&&(identical(other.serverId, serverId) || other.serverId == serverId));
}


@override
int get hashCode => Object.hash(runtimeType,serverId);

@override
String toString() {
  return 'SubscriptionEvent.load(serverId: $serverId)';
}


}

/// @nodoc
abstract mixin class $SubscriptionLoadCopyWith<$Res> implements $SubscriptionEventCopyWith<$Res> {
  factory $SubscriptionLoadCopyWith(SubscriptionLoad value, $Res Function(SubscriptionLoad) _then) = _$SubscriptionLoadCopyWithImpl;
@useResult
$Res call({
 String serverId
});




}
/// @nodoc
class _$SubscriptionLoadCopyWithImpl<$Res>
    implements $SubscriptionLoadCopyWith<$Res> {
  _$SubscriptionLoadCopyWithImpl(this._self, this._then);

  final SubscriptionLoad _self;
  final $Res Function(SubscriptionLoad) _then;

/// Create a copy of SubscriptionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? serverId = null,}) {
  return _then(SubscriptionLoad(
serverId: null == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SubscriptionSubscribe implements SubscriptionEvent {
  const SubscriptionSubscribe({required this.serverId, required this.topic, this.displayName});
  

 final  String serverId;
 final  String topic;
 final  String? displayName;

/// Create a copy of SubscriptionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionSubscribeCopyWith<SubscriptionSubscribe> get copyWith => _$SubscriptionSubscribeCopyWithImpl<SubscriptionSubscribe>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionSubscribe&&(identical(other.serverId, serverId) || other.serverId == serverId)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.displayName, displayName) || other.displayName == displayName));
}


@override
int get hashCode => Object.hash(runtimeType,serverId,topic,displayName);

@override
String toString() {
  return 'SubscriptionEvent.subscribe(serverId: $serverId, topic: $topic, displayName: $displayName)';
}


}

/// @nodoc
abstract mixin class $SubscriptionSubscribeCopyWith<$Res> implements $SubscriptionEventCopyWith<$Res> {
  factory $SubscriptionSubscribeCopyWith(SubscriptionSubscribe value, $Res Function(SubscriptionSubscribe) _then) = _$SubscriptionSubscribeCopyWithImpl;
@useResult
$Res call({
 String serverId, String topic, String? displayName
});




}
/// @nodoc
class _$SubscriptionSubscribeCopyWithImpl<$Res>
    implements $SubscriptionSubscribeCopyWith<$Res> {
  _$SubscriptionSubscribeCopyWithImpl(this._self, this._then);

  final SubscriptionSubscribe _self;
  final $Res Function(SubscriptionSubscribe) _then;

/// Create a copy of SubscriptionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? serverId = null,Object? topic = null,Object? displayName = freezed,}) {
  return _then(SubscriptionSubscribe(
serverId: null == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class SubscriptionUnsubscribe implements SubscriptionEvent {
  const SubscriptionUnsubscribe({required this.serverId, required this.topic});
  

 final  String serverId;
 final  String topic;

/// Create a copy of SubscriptionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionUnsubscribeCopyWith<SubscriptionUnsubscribe> get copyWith => _$SubscriptionUnsubscribeCopyWithImpl<SubscriptionUnsubscribe>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionUnsubscribe&&(identical(other.serverId, serverId) || other.serverId == serverId)&&(identical(other.topic, topic) || other.topic == topic));
}


@override
int get hashCode => Object.hash(runtimeType,serverId,topic);

@override
String toString() {
  return 'SubscriptionEvent.unsubscribe(serverId: $serverId, topic: $topic)';
}


}

/// @nodoc
abstract mixin class $SubscriptionUnsubscribeCopyWith<$Res> implements $SubscriptionEventCopyWith<$Res> {
  factory $SubscriptionUnsubscribeCopyWith(SubscriptionUnsubscribe value, $Res Function(SubscriptionUnsubscribe) _then) = _$SubscriptionUnsubscribeCopyWithImpl;
@useResult
$Res call({
 String serverId, String topic
});




}
/// @nodoc
class _$SubscriptionUnsubscribeCopyWithImpl<$Res>
    implements $SubscriptionUnsubscribeCopyWith<$Res> {
  _$SubscriptionUnsubscribeCopyWithImpl(this._self, this._then);

  final SubscriptionUnsubscribe _self;
  final $Res Function(SubscriptionUnsubscribe) _then;

/// Create a copy of SubscriptionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? serverId = null,Object? topic = null,}) {
  return _then(SubscriptionUnsubscribe(
serverId: null == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SubscriptionTogglePin implements SubscriptionEvent {
  const SubscriptionTogglePin({required this.id});
  

 final  String id;

/// Create a copy of SubscriptionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionTogglePinCopyWith<SubscriptionTogglePin> get copyWith => _$SubscriptionTogglePinCopyWithImpl<SubscriptionTogglePin>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionTogglePin&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'SubscriptionEvent.togglePin(id: $id)';
}


}

/// @nodoc
abstract mixin class $SubscriptionTogglePinCopyWith<$Res> implements $SubscriptionEventCopyWith<$Res> {
  factory $SubscriptionTogglePinCopyWith(SubscriptionTogglePin value, $Res Function(SubscriptionTogglePin) _then) = _$SubscriptionTogglePinCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$SubscriptionTogglePinCopyWithImpl<$Res>
    implements $SubscriptionTogglePinCopyWith<$Res> {
  _$SubscriptionTogglePinCopyWithImpl(this._self, this._then);

  final SubscriptionTogglePin _self;
  final $Res Function(SubscriptionTogglePin) _then;

/// Create a copy of SubscriptionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(SubscriptionTogglePin(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SubscriptionToggleMute implements SubscriptionEvent {
  const SubscriptionToggleMute({required this.id});
  

 final  String id;

/// Create a copy of SubscriptionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionToggleMuteCopyWith<SubscriptionToggleMute> get copyWith => _$SubscriptionToggleMuteCopyWithImpl<SubscriptionToggleMute>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionToggleMute&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'SubscriptionEvent.toggleMute(id: $id)';
}


}

/// @nodoc
abstract mixin class $SubscriptionToggleMuteCopyWith<$Res> implements $SubscriptionEventCopyWith<$Res> {
  factory $SubscriptionToggleMuteCopyWith(SubscriptionToggleMute value, $Res Function(SubscriptionToggleMute) _then) = _$SubscriptionToggleMuteCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$SubscriptionToggleMuteCopyWithImpl<$Res>
    implements $SubscriptionToggleMuteCopyWith<$Res> {
  _$SubscriptionToggleMuteCopyWithImpl(this._self, this._then);

  final SubscriptionToggleMute _self;
  final $Res Function(SubscriptionToggleMute) _then;

/// Create a copy of SubscriptionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(SubscriptionToggleMute(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SubscriptionUpdateThreshold implements SubscriptionEvent {
  const SubscriptionUpdateThreshold({required this.id, required this.threshold});
  

 final  String id;
 final  int threshold;

/// Create a copy of SubscriptionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionUpdateThresholdCopyWith<SubscriptionUpdateThreshold> get copyWith => _$SubscriptionUpdateThresholdCopyWithImpl<SubscriptionUpdateThreshold>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionUpdateThreshold&&(identical(other.id, id) || other.id == id)&&(identical(other.threshold, threshold) || other.threshold == threshold));
}


@override
int get hashCode => Object.hash(runtimeType,id,threshold);

@override
String toString() {
  return 'SubscriptionEvent.updateThreshold(id: $id, threshold: $threshold)';
}


}

/// @nodoc
abstract mixin class $SubscriptionUpdateThresholdCopyWith<$Res> implements $SubscriptionEventCopyWith<$Res> {
  factory $SubscriptionUpdateThresholdCopyWith(SubscriptionUpdateThreshold value, $Res Function(SubscriptionUpdateThreshold) _then) = _$SubscriptionUpdateThresholdCopyWithImpl;
@useResult
$Res call({
 String id, int threshold
});




}
/// @nodoc
class _$SubscriptionUpdateThresholdCopyWithImpl<$Res>
    implements $SubscriptionUpdateThresholdCopyWith<$Res> {
  _$SubscriptionUpdateThresholdCopyWithImpl(this._self, this._then);

  final SubscriptionUpdateThreshold _self;
  final $Res Function(SubscriptionUpdateThreshold) _then;

/// Create a copy of SubscriptionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? threshold = null,}) {
  return _then(SubscriptionUpdateThreshold(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,threshold: null == threshold ? _self.threshold : threshold // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
