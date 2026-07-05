// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FeedState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FeedState()';
}


}

/// @nodoc
class $FeedStateCopyWith<$Res>  {
$FeedStateCopyWith(FeedState _, $Res Function(FeedState) __);
}


/// Adds pattern-matching-related methods to [FeedState].
extension FeedStatePatterns on FeedState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FeedLoading value)?  loading,TResult Function( FeedLoaded value)?  loaded,TResult Function( FeedError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FeedLoading() when loading != null:
return loading(_that);case FeedLoaded() when loaded != null:
return loaded(_that);case FeedError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FeedLoading value)  loading,required TResult Function( FeedLoaded value)  loaded,required TResult Function( FeedError value)  error,}){
final _that = this;
switch (_that) {
case FeedLoading():
return loading(_that);case FeedLoaded():
return loaded(_that);case FeedError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FeedLoading value)?  loading,TResult? Function( FeedLoaded value)?  loaded,TResult? Function( FeedError value)?  error,}){
final _that = this;
switch (_that) {
case FeedLoading() when loading != null:
return loading(_that);case FeedLoaded() when loaded != null:
return loaded(_that);case FeedError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( List<NotificationMessage> messages,  FeedConnectionState connectionState)?  loaded,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FeedLoading() when loading != null:
return loading();case FeedLoaded() when loaded != null:
return loaded(_that.messages,_that.connectionState);case FeedError() when error != null:
return error(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( List<NotificationMessage> messages,  FeedConnectionState connectionState)  loaded,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case FeedLoading():
return loading();case FeedLoaded():
return loaded(_that.messages,_that.connectionState);case FeedError():
return error(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( List<NotificationMessage> messages,  FeedConnectionState connectionState)?  loaded,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case FeedLoading() when loading != null:
return loading();case FeedLoaded() when loaded != null:
return loaded(_that.messages,_that.connectionState);case FeedError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class FeedLoading implements FeedState {
  const FeedLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FeedState.loading()';
}


}




/// @nodoc


class FeedLoaded implements FeedState {
  const FeedLoaded({required final  List<NotificationMessage> messages, required this.connectionState}): _messages = messages;
  

 final  List<NotificationMessage> _messages;
 List<NotificationMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

 final  FeedConnectionState connectionState;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedLoadedCopyWith<FeedLoaded> get copyWith => _$FeedLoadedCopyWithImpl<FeedLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedLoaded&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.connectionState, connectionState) || other.connectionState == connectionState));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_messages),connectionState);

@override
String toString() {
  return 'FeedState.loaded(messages: $messages, connectionState: $connectionState)';
}


}

/// @nodoc
abstract mixin class $FeedLoadedCopyWith<$Res> implements $FeedStateCopyWith<$Res> {
  factory $FeedLoadedCopyWith(FeedLoaded value, $Res Function(FeedLoaded) _then) = _$FeedLoadedCopyWithImpl;
@useResult
$Res call({
 List<NotificationMessage> messages, FeedConnectionState connectionState
});




}
/// @nodoc
class _$FeedLoadedCopyWithImpl<$Res>
    implements $FeedLoadedCopyWith<$Res> {
  _$FeedLoadedCopyWithImpl(this._self, this._then);

  final FeedLoaded _self;
  final $Res Function(FeedLoaded) _then;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? messages = null,Object? connectionState = null,}) {
  return _then(FeedLoaded(
messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<NotificationMessage>,connectionState: null == connectionState ? _self.connectionState : connectionState // ignore: cast_nullable_to_non_nullable
as FeedConnectionState,
  ));
}


}

/// @nodoc


class FeedError implements FeedState {
  const FeedError({required this.failure});
  

 final  Failure failure;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedErrorCopyWith<FeedError> get copyWith => _$FeedErrorCopyWithImpl<FeedError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'FeedState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $FeedErrorCopyWith<$Res> implements $FeedStateCopyWith<$Res> {
  factory $FeedErrorCopyWith(FeedError value, $Res Function(FeedError) _then) = _$FeedErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$FeedErrorCopyWithImpl<$Res>
    implements $FeedErrorCopyWith<$Res> {
  _$FeedErrorCopyWithImpl(this._self, this._then);

  final FeedError _self;
  final $Res Function(FeedError) _then;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(FeedError(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res> get failure {
  
  return $FailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
