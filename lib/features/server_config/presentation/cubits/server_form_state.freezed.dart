// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ServerFormState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerFormState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ServerFormState()';
}


}

/// @nodoc
class $ServerFormStateCopyWith<$Res>  {
$ServerFormStateCopyWith(ServerFormState _, $Res Function(ServerFormState) __);
}


/// Adds pattern-matching-related methods to [ServerFormState].
extension ServerFormStatePatterns on ServerFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ServerFormIdle value)?  idle,TResult Function( ServerFormValidating value)?  validating,TResult Function( ServerFormSuccess value)?  success,TResult Function( ServerFormError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ServerFormIdle() when idle != null:
return idle(_that);case ServerFormValidating() when validating != null:
return validating(_that);case ServerFormSuccess() when success != null:
return success(_that);case ServerFormError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ServerFormIdle value)  idle,required TResult Function( ServerFormValidating value)  validating,required TResult Function( ServerFormSuccess value)  success,required TResult Function( ServerFormError value)  error,}){
final _that = this;
switch (_that) {
case ServerFormIdle():
return idle(_that);case ServerFormValidating():
return validating(_that);case ServerFormSuccess():
return success(_that);case ServerFormError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ServerFormIdle value)?  idle,TResult? Function( ServerFormValidating value)?  validating,TResult? Function( ServerFormSuccess value)?  success,TResult? Function( ServerFormError value)?  error,}){
final _that = this;
switch (_that) {
case ServerFormIdle() when idle != null:
return idle(_that);case ServerFormValidating() when validating != null:
return validating(_that);case ServerFormSuccess() when success != null:
return success(_that);case ServerFormError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  validating,TResult Function( String baseUrl)?  success,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ServerFormIdle() when idle != null:
return idle();case ServerFormValidating() when validating != null:
return validating();case ServerFormSuccess() when success != null:
return success(_that.baseUrl);case ServerFormError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  validating,required TResult Function( String baseUrl)  success,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case ServerFormIdle():
return idle();case ServerFormValidating():
return validating();case ServerFormSuccess():
return success(_that.baseUrl);case ServerFormError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  validating,TResult? Function( String baseUrl)?  success,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case ServerFormIdle() when idle != null:
return idle();case ServerFormValidating() when validating != null:
return validating();case ServerFormSuccess() when success != null:
return success(_that.baseUrl);case ServerFormError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class ServerFormIdle implements ServerFormState {
  const ServerFormIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerFormIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ServerFormState.idle()';
}


}




/// @nodoc


class ServerFormValidating implements ServerFormState {
  const ServerFormValidating();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerFormValidating);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ServerFormState.validating()';
}


}




/// @nodoc


class ServerFormSuccess implements ServerFormState {
  const ServerFormSuccess({required this.baseUrl});
  

 final  String baseUrl;

/// Create a copy of ServerFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerFormSuccessCopyWith<ServerFormSuccess> get copyWith => _$ServerFormSuccessCopyWithImpl<ServerFormSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerFormSuccess&&(identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl));
}


@override
int get hashCode => Object.hash(runtimeType,baseUrl);

@override
String toString() {
  return 'ServerFormState.success(baseUrl: $baseUrl)';
}


}

/// @nodoc
abstract mixin class $ServerFormSuccessCopyWith<$Res> implements $ServerFormStateCopyWith<$Res> {
  factory $ServerFormSuccessCopyWith(ServerFormSuccess value, $Res Function(ServerFormSuccess) _then) = _$ServerFormSuccessCopyWithImpl;
@useResult
$Res call({
 String baseUrl
});




}
/// @nodoc
class _$ServerFormSuccessCopyWithImpl<$Res>
    implements $ServerFormSuccessCopyWith<$Res> {
  _$ServerFormSuccessCopyWithImpl(this._self, this._then);

  final ServerFormSuccess _self;
  final $Res Function(ServerFormSuccess) _then;

/// Create a copy of ServerFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? baseUrl = null,}) {
  return _then(ServerFormSuccess(
baseUrl: null == baseUrl ? _self.baseUrl : baseUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ServerFormError implements ServerFormState {
  const ServerFormError({required this.failure});
  

 final  Failure failure;

/// Create a copy of ServerFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerFormErrorCopyWith<ServerFormError> get copyWith => _$ServerFormErrorCopyWithImpl<ServerFormError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerFormError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'ServerFormState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ServerFormErrorCopyWith<$Res> implements $ServerFormStateCopyWith<$Res> {
  factory $ServerFormErrorCopyWith(ServerFormError value, $Res Function(ServerFormError) _then) = _$ServerFormErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$ServerFormErrorCopyWithImpl<$Res>
    implements $ServerFormErrorCopyWith<$Res> {
  _$ServerFormErrorCopyWithImpl(this._self, this._then);

  final ServerFormError _self;
  final $Res Function(ServerFormError) _then;

/// Create a copy of ServerFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(ServerFormError(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of ServerFormState
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
