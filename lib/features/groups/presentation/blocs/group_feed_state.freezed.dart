// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_feed_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GroupFeedState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupFeedState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GroupFeedState()';
}


}

/// @nodoc
class $GroupFeedStateCopyWith<$Res>  {
$GroupFeedStateCopyWith(GroupFeedState _, $Res Function(GroupFeedState) __);
}


/// Adds pattern-matching-related methods to [GroupFeedState].
extension GroupFeedStatePatterns on GroupFeedState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( GroupFeedLoading value)?  loading,TResult Function( GroupFeedError value)?  error,TResult Function( GroupFeedLoaded value)?  loaded,required TResult orElse(),}){
final _that = this;
switch (_that) {
case GroupFeedLoading() when loading != null:
return loading(_that);case GroupFeedError() when error != null:
return error(_that);case GroupFeedLoaded() when loaded != null:
return loaded(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( GroupFeedLoading value)  loading,required TResult Function( GroupFeedError value)  error,required TResult Function( GroupFeedLoaded value)  loaded,}){
final _that = this;
switch (_that) {
case GroupFeedLoading():
return loading(_that);case GroupFeedError():
return error(_that);case GroupFeedLoaded():
return loaded(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( GroupFeedLoading value)?  loading,TResult? Function( GroupFeedError value)?  error,TResult? Function( GroupFeedLoaded value)?  loaded,}){
final _that = this;
switch (_that) {
case GroupFeedLoading() when loading != null:
return loading(_that);case GroupFeedError() when error != null:
return error(_that);case GroupFeedLoaded() when loaded != null:
return loaded(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( Failure failure)?  error,TResult Function( List<NotificationMessage> messages)?  loaded,required TResult orElse(),}) {final _that = this;
switch (_that) {
case GroupFeedLoading() when loading != null:
return loading();case GroupFeedError() when error != null:
return error(_that.failure);case GroupFeedLoaded() when loaded != null:
return loaded(_that.messages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( Failure failure)  error,required TResult Function( List<NotificationMessage> messages)  loaded,}) {final _that = this;
switch (_that) {
case GroupFeedLoading():
return loading();case GroupFeedError():
return error(_that.failure);case GroupFeedLoaded():
return loaded(_that.messages);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( Failure failure)?  error,TResult? Function( List<NotificationMessage> messages)?  loaded,}) {final _that = this;
switch (_that) {
case GroupFeedLoading() when loading != null:
return loading();case GroupFeedError() when error != null:
return error(_that.failure);case GroupFeedLoaded() when loaded != null:
return loaded(_that.messages);case _:
  return null;

}
}

}

/// @nodoc


class GroupFeedLoading implements GroupFeedState {
  const GroupFeedLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupFeedLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GroupFeedState.loading()';
}


}




/// @nodoc


class GroupFeedError implements GroupFeedState {
  const GroupFeedError({required this.failure});
  

 final  Failure failure;

/// Create a copy of GroupFeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupFeedErrorCopyWith<GroupFeedError> get copyWith => _$GroupFeedErrorCopyWithImpl<GroupFeedError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupFeedError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'GroupFeedState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $GroupFeedErrorCopyWith<$Res> implements $GroupFeedStateCopyWith<$Res> {
  factory $GroupFeedErrorCopyWith(GroupFeedError value, $Res Function(GroupFeedError) _then) = _$GroupFeedErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$GroupFeedErrorCopyWithImpl<$Res>
    implements $GroupFeedErrorCopyWith<$Res> {
  _$GroupFeedErrorCopyWithImpl(this._self, this._then);

  final GroupFeedError _self;
  final $Res Function(GroupFeedError) _then;

/// Create a copy of GroupFeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(GroupFeedError(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of GroupFeedState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res> get failure {
  
  return $FailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

/// @nodoc


class GroupFeedLoaded implements GroupFeedState {
  const GroupFeedLoaded({required final  List<NotificationMessage> messages}): _messages = messages;
  

 final  List<NotificationMessage> _messages;
 List<NotificationMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}


/// Create a copy of GroupFeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupFeedLoadedCopyWith<GroupFeedLoaded> get copyWith => _$GroupFeedLoadedCopyWithImpl<GroupFeedLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupFeedLoaded&&const DeepCollectionEquality().equals(other._messages, _messages));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_messages));

@override
String toString() {
  return 'GroupFeedState.loaded(messages: $messages)';
}


}

/// @nodoc
abstract mixin class $GroupFeedLoadedCopyWith<$Res> implements $GroupFeedStateCopyWith<$Res> {
  factory $GroupFeedLoadedCopyWith(GroupFeedLoaded value, $Res Function(GroupFeedLoaded) _then) = _$GroupFeedLoadedCopyWithImpl;
@useResult
$Res call({
 List<NotificationMessage> messages
});




}
/// @nodoc
class _$GroupFeedLoadedCopyWithImpl<$Res>
    implements $GroupFeedLoadedCopyWith<$Res> {
  _$GroupFeedLoadedCopyWithImpl(this._self, this._then);

  final GroupFeedLoaded _self;
  final $Res Function(GroupFeedLoaded) _then;

/// Create a copy of GroupFeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? messages = null,}) {
  return _then(GroupFeedLoaded(
messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<NotificationMessage>,
  ));
}


}

// dart format on
