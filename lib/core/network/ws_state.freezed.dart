// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ws_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WsState()';
}


}

/// @nodoc
class $WsStateCopyWith<$Res>  {
$WsStateCopyWith(WsState _, $Res Function(WsState) __);
}


/// Adds pattern-matching-related methods to [WsState].
extension WsStatePatterns on WsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( WsConnecting value)?  connecting,TResult Function( WsConnected value)?  connected,TResult Function( WsReconnecting value)?  reconnecting,TResult Function( WsDisconnected value)?  disconnected,required TResult orElse(),}){
final _that = this;
switch (_that) {
case WsConnecting() when connecting != null:
return connecting(_that);case WsConnected() when connected != null:
return connected(_that);case WsReconnecting() when reconnecting != null:
return reconnecting(_that);case WsDisconnected() when disconnected != null:
return disconnected(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( WsConnecting value)  connecting,required TResult Function( WsConnected value)  connected,required TResult Function( WsReconnecting value)  reconnecting,required TResult Function( WsDisconnected value)  disconnected,}){
final _that = this;
switch (_that) {
case WsConnecting():
return connecting(_that);case WsConnected():
return connected(_that);case WsReconnecting():
return reconnecting(_that);case WsDisconnected():
return disconnected(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( WsConnecting value)?  connecting,TResult? Function( WsConnected value)?  connected,TResult? Function( WsReconnecting value)?  reconnecting,TResult? Function( WsDisconnected value)?  disconnected,}){
final _that = this;
switch (_that) {
case WsConnecting() when connecting != null:
return connecting(_that);case WsConnected() when connected != null:
return connected(_that);case WsReconnecting() when reconnecting != null:
return reconnecting(_that);case WsDisconnected() when disconnected != null:
return disconnected(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  connecting,TResult Function()?  connected,TResult Function( int attempt)?  reconnecting,TResult Function( String? reason)?  disconnected,required TResult orElse(),}) {final _that = this;
switch (_that) {
case WsConnecting() when connecting != null:
return connecting();case WsConnected() when connected != null:
return connected();case WsReconnecting() when reconnecting != null:
return reconnecting(_that.attempt);case WsDisconnected() when disconnected != null:
return disconnected(_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  connecting,required TResult Function()  connected,required TResult Function( int attempt)  reconnecting,required TResult Function( String? reason)  disconnected,}) {final _that = this;
switch (_that) {
case WsConnecting():
return connecting();case WsConnected():
return connected();case WsReconnecting():
return reconnecting(_that.attempt);case WsDisconnected():
return disconnected(_that.reason);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  connecting,TResult? Function()?  connected,TResult? Function( int attempt)?  reconnecting,TResult? Function( String? reason)?  disconnected,}) {final _that = this;
switch (_that) {
case WsConnecting() when connecting != null:
return connecting();case WsConnected() when connected != null:
return connected();case WsReconnecting() when reconnecting != null:
return reconnecting(_that.attempt);case WsDisconnected() when disconnected != null:
return disconnected(_that.reason);case _:
  return null;

}
}

}

/// @nodoc


class WsConnecting implements WsState {
  const WsConnecting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WsConnecting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WsState.connecting()';
}


}




/// @nodoc


class WsConnected implements WsState {
  const WsConnected();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WsConnected);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WsState.connected()';
}


}




/// @nodoc


class WsReconnecting implements WsState {
  const WsReconnecting({required this.attempt});
  

 final  int attempt;

/// Create a copy of WsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WsReconnectingCopyWith<WsReconnecting> get copyWith => _$WsReconnectingCopyWithImpl<WsReconnecting>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WsReconnecting&&(identical(other.attempt, attempt) || other.attempt == attempt));
}


@override
int get hashCode => Object.hash(runtimeType,attempt);

@override
String toString() {
  return 'WsState.reconnecting(attempt: $attempt)';
}


}

/// @nodoc
abstract mixin class $WsReconnectingCopyWith<$Res> implements $WsStateCopyWith<$Res> {
  factory $WsReconnectingCopyWith(WsReconnecting value, $Res Function(WsReconnecting) _then) = _$WsReconnectingCopyWithImpl;
@useResult
$Res call({
 int attempt
});




}
/// @nodoc
class _$WsReconnectingCopyWithImpl<$Res>
    implements $WsReconnectingCopyWith<$Res> {
  _$WsReconnectingCopyWithImpl(this._self, this._then);

  final WsReconnecting _self;
  final $Res Function(WsReconnecting) _then;

/// Create a copy of WsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? attempt = null,}) {
  return _then(WsReconnecting(
attempt: null == attempt ? _self.attempt : attempt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class WsDisconnected implements WsState {
  const WsDisconnected({this.reason});
  

 final  String? reason;

/// Create a copy of WsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WsDisconnectedCopyWith<WsDisconnected> get copyWith => _$WsDisconnectedCopyWithImpl<WsDisconnected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WsDisconnected&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,reason);

@override
String toString() {
  return 'WsState.disconnected(reason: $reason)';
}


}

/// @nodoc
abstract mixin class $WsDisconnectedCopyWith<$Res> implements $WsStateCopyWith<$Res> {
  factory $WsDisconnectedCopyWith(WsDisconnected value, $Res Function(WsDisconnected) _then) = _$WsDisconnectedCopyWithImpl;
@useResult
$Res call({
 String? reason
});




}
/// @nodoc
class _$WsDisconnectedCopyWithImpl<$Res>
    implements $WsDisconnectedCopyWith<$Res> {
  _$WsDisconnectedCopyWithImpl(this._self, this._then);

  final WsDisconnected _self;
  final $Res Function(WsDisconnected) _then;

/// Create a copy of WsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reason = freezed,}) {
  return _then(WsDisconnected(
reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
