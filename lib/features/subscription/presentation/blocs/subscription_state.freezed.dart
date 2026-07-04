// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SubscriptionState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SubscriptionState()';
}


}

/// @nodoc
class $SubscriptionStateCopyWith<$Res>  {
$SubscriptionStateCopyWith(SubscriptionState _, $Res Function(SubscriptionState) __);
}


/// Adds pattern-matching-related methods to [SubscriptionState].
extension SubscriptionStatePatterns on SubscriptionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SubscriptionLoading value)?  loading,TResult Function( SubscriptionLoaded value)?  loaded,TResult Function( SubscriptionAuthError value)?  authError,TResult Function( SubscriptionError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SubscriptionLoading() when loading != null:
return loading(_that);case SubscriptionLoaded() when loaded != null:
return loaded(_that);case SubscriptionAuthError() when authError != null:
return authError(_that);case SubscriptionError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SubscriptionLoading value)  loading,required TResult Function( SubscriptionLoaded value)  loaded,required TResult Function( SubscriptionAuthError value)  authError,required TResult Function( SubscriptionError value)  error,}){
final _that = this;
switch (_that) {
case SubscriptionLoading():
return loading(_that);case SubscriptionLoaded():
return loaded(_that);case SubscriptionAuthError():
return authError(_that);case SubscriptionError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SubscriptionLoading value)?  loading,TResult? Function( SubscriptionLoaded value)?  loaded,TResult? Function( SubscriptionAuthError value)?  authError,TResult? Function( SubscriptionError value)?  error,}){
final _that = this;
switch (_that) {
case SubscriptionLoading() when loading != null:
return loading(_that);case SubscriptionLoaded() when loaded != null:
return loaded(_that);case SubscriptionAuthError() when authError != null:
return authError(_that);case SubscriptionError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( List<Subscription> subscriptions)?  loaded,TResult Function( Failure failure)?  authError,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SubscriptionLoading() when loading != null:
return loading();case SubscriptionLoaded() when loaded != null:
return loaded(_that.subscriptions);case SubscriptionAuthError() when authError != null:
return authError(_that.failure);case SubscriptionError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( List<Subscription> subscriptions)  loaded,required TResult Function( Failure failure)  authError,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case SubscriptionLoading():
return loading();case SubscriptionLoaded():
return loaded(_that.subscriptions);case SubscriptionAuthError():
return authError(_that.failure);case SubscriptionError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( List<Subscription> subscriptions)?  loaded,TResult? Function( Failure failure)?  authError,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case SubscriptionLoading() when loading != null:
return loading();case SubscriptionLoaded() when loaded != null:
return loaded(_that.subscriptions);case SubscriptionAuthError() when authError != null:
return authError(_that.failure);case SubscriptionError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class SubscriptionLoading implements SubscriptionState {
  const SubscriptionLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SubscriptionState.loading()';
}


}




/// @nodoc


class SubscriptionLoaded implements SubscriptionState {
  const SubscriptionLoaded({required final  List<Subscription> subscriptions}): _subscriptions = subscriptions;
  

 final  List<Subscription> _subscriptions;
 List<Subscription> get subscriptions {
  if (_subscriptions is EqualUnmodifiableListView) return _subscriptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subscriptions);
}


/// Create a copy of SubscriptionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionLoadedCopyWith<SubscriptionLoaded> get copyWith => _$SubscriptionLoadedCopyWithImpl<SubscriptionLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionLoaded&&const DeepCollectionEquality().equals(other._subscriptions, _subscriptions));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_subscriptions));

@override
String toString() {
  return 'SubscriptionState.loaded(subscriptions: $subscriptions)';
}


}

/// @nodoc
abstract mixin class $SubscriptionLoadedCopyWith<$Res> implements $SubscriptionStateCopyWith<$Res> {
  factory $SubscriptionLoadedCopyWith(SubscriptionLoaded value, $Res Function(SubscriptionLoaded) _then) = _$SubscriptionLoadedCopyWithImpl;
@useResult
$Res call({
 List<Subscription> subscriptions
});




}
/// @nodoc
class _$SubscriptionLoadedCopyWithImpl<$Res>
    implements $SubscriptionLoadedCopyWith<$Res> {
  _$SubscriptionLoadedCopyWithImpl(this._self, this._then);

  final SubscriptionLoaded _self;
  final $Res Function(SubscriptionLoaded) _then;

/// Create a copy of SubscriptionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? subscriptions = null,}) {
  return _then(SubscriptionLoaded(
subscriptions: null == subscriptions ? _self._subscriptions : subscriptions // ignore: cast_nullable_to_non_nullable
as List<Subscription>,
  ));
}


}

/// @nodoc


class SubscriptionAuthError implements SubscriptionState {
  const SubscriptionAuthError({required this.failure});
  

 final  Failure failure;

/// Create a copy of SubscriptionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionAuthErrorCopyWith<SubscriptionAuthError> get copyWith => _$SubscriptionAuthErrorCopyWithImpl<SubscriptionAuthError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionAuthError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'SubscriptionState.authError(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $SubscriptionAuthErrorCopyWith<$Res> implements $SubscriptionStateCopyWith<$Res> {
  factory $SubscriptionAuthErrorCopyWith(SubscriptionAuthError value, $Res Function(SubscriptionAuthError) _then) = _$SubscriptionAuthErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$SubscriptionAuthErrorCopyWithImpl<$Res>
    implements $SubscriptionAuthErrorCopyWith<$Res> {
  _$SubscriptionAuthErrorCopyWithImpl(this._self, this._then);

  final SubscriptionAuthError _self;
  final $Res Function(SubscriptionAuthError) _then;

/// Create a copy of SubscriptionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(SubscriptionAuthError(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of SubscriptionState
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


class SubscriptionError implements SubscriptionState {
  const SubscriptionError({required this.failure});
  

 final  Failure failure;

/// Create a copy of SubscriptionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionErrorCopyWith<SubscriptionError> get copyWith => _$SubscriptionErrorCopyWithImpl<SubscriptionError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'SubscriptionState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $SubscriptionErrorCopyWith<$Res> implements $SubscriptionStateCopyWith<$Res> {
  factory $SubscriptionErrorCopyWith(SubscriptionError value, $Res Function(SubscriptionError) _then) = _$SubscriptionErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$SubscriptionErrorCopyWithImpl<$Res>
    implements $SubscriptionErrorCopyWith<$Res> {
  _$SubscriptionErrorCopyWithImpl(this._self, this._then);

  final SubscriptionError _self;
  final $Res Function(SubscriptionError) _then;

/// Create a copy of SubscriptionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(SubscriptionError(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of SubscriptionState
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
