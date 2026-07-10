// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_add_edit_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ServerAddEditState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerAddEditState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ServerAddEditState()';
}


}

/// @nodoc
class $ServerAddEditStateCopyWith<$Res>  {
$ServerAddEditStateCopyWith(ServerAddEditState _, $Res Function(ServerAddEditState) __);
}


/// Adds pattern-matching-related methods to [ServerAddEditState].
extension ServerAddEditStatePatterns on ServerAddEditState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ServerAddEditIdle value)?  idle,TResult Function( ServerAddEditValidating value)?  validating,TResult Function( ServerAddEditSuccess value)?  success,TResult Function( ServerAddEditError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ServerAddEditIdle() when idle != null:
return idle(_that);case ServerAddEditValidating() when validating != null:
return validating(_that);case ServerAddEditSuccess() when success != null:
return success(_that);case ServerAddEditError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ServerAddEditIdle value)  idle,required TResult Function( ServerAddEditValidating value)  validating,required TResult Function( ServerAddEditSuccess value)  success,required TResult Function( ServerAddEditError value)  error,}){
final _that = this;
switch (_that) {
case ServerAddEditIdle():
return idle(_that);case ServerAddEditValidating():
return validating(_that);case ServerAddEditSuccess():
return success(_that);case ServerAddEditError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ServerAddEditIdle value)?  idle,TResult? Function( ServerAddEditValidating value)?  validating,TResult? Function( ServerAddEditSuccess value)?  success,TResult? Function( ServerAddEditError value)?  error,}){
final _that = this;
switch (_that) {
case ServerAddEditIdle() when idle != null:
return idle(_that);case ServerAddEditValidating() when validating != null:
return validating(_that);case ServerAddEditSuccess() when success != null:
return success(_that);case ServerAddEditError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  validating,TResult Function()?  success,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ServerAddEditIdle() when idle != null:
return idle();case ServerAddEditValidating() when validating != null:
return validating();case ServerAddEditSuccess() when success != null:
return success();case ServerAddEditError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  validating,required TResult Function()  success,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case ServerAddEditIdle():
return idle();case ServerAddEditValidating():
return validating();case ServerAddEditSuccess():
return success();case ServerAddEditError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  validating,TResult? Function()?  success,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case ServerAddEditIdle() when idle != null:
return idle();case ServerAddEditValidating() when validating != null:
return validating();case ServerAddEditSuccess() when success != null:
return success();case ServerAddEditError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class ServerAddEditIdle implements ServerAddEditState {
  const ServerAddEditIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerAddEditIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ServerAddEditState.idle()';
}


}




/// @nodoc


class ServerAddEditValidating implements ServerAddEditState {
  const ServerAddEditValidating();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerAddEditValidating);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ServerAddEditState.validating()';
}


}




/// @nodoc


class ServerAddEditSuccess implements ServerAddEditState {
  const ServerAddEditSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerAddEditSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ServerAddEditState.success()';
}


}




/// @nodoc


class ServerAddEditError implements ServerAddEditState {
  const ServerAddEditError({required this.failure});
  

 final  Failure failure;

/// Create a copy of ServerAddEditState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerAddEditErrorCopyWith<ServerAddEditError> get copyWith => _$ServerAddEditErrorCopyWithImpl<ServerAddEditError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerAddEditError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'ServerAddEditState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ServerAddEditErrorCopyWith<$Res> implements $ServerAddEditStateCopyWith<$Res> {
  factory $ServerAddEditErrorCopyWith(ServerAddEditError value, $Res Function(ServerAddEditError) _then) = _$ServerAddEditErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$ServerAddEditErrorCopyWithImpl<$Res>
    implements $ServerAddEditErrorCopyWith<$Res> {
  _$ServerAddEditErrorCopyWithImpl(this._self, this._then);

  final ServerAddEditError _self;
  final $Res Function(ServerAddEditError) _then;

/// Create a copy of ServerAddEditState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(ServerAddEditError(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of ServerAddEditState
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
