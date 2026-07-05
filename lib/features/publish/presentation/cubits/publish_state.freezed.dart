// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'publish_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PublishState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PublishState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PublishState()';
}


}

/// @nodoc
class $PublishStateCopyWith<$Res>  {
$PublishStateCopyWith(PublishState _, $Res Function(PublishState) __);
}


/// Adds pattern-matching-related methods to [PublishState].
extension PublishStatePatterns on PublishState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PublishIdle value)?  idle,TResult Function( PublishSubmitting value)?  submitting,TResult Function( PublishSuccess value)?  success,TResult Function( PublishError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PublishIdle() when idle != null:
return idle(_that);case PublishSubmitting() when submitting != null:
return submitting(_that);case PublishSuccess() when success != null:
return success(_that);case PublishError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PublishIdle value)  idle,required TResult Function( PublishSubmitting value)  submitting,required TResult Function( PublishSuccess value)  success,required TResult Function( PublishError value)  error,}){
final _that = this;
switch (_that) {
case PublishIdle():
return idle(_that);case PublishSubmitting():
return submitting(_that);case PublishSuccess():
return success(_that);case PublishError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PublishIdle value)?  idle,TResult? Function( PublishSubmitting value)?  submitting,TResult? Function( PublishSuccess value)?  success,TResult? Function( PublishError value)?  error,}){
final _that = this;
switch (_that) {
case PublishIdle() when idle != null:
return idle(_that);case PublishSubmitting() when submitting != null:
return submitting(_that);case PublishSuccess() when success != null:
return success(_that);case PublishError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  submitting,TResult Function()?  success,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PublishIdle() when idle != null:
return idle();case PublishSubmitting() when submitting != null:
return submitting();case PublishSuccess() when success != null:
return success();case PublishError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  submitting,required TResult Function()  success,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case PublishIdle():
return idle();case PublishSubmitting():
return submitting();case PublishSuccess():
return success();case PublishError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  submitting,TResult? Function()?  success,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case PublishIdle() when idle != null:
return idle();case PublishSubmitting() when submitting != null:
return submitting();case PublishSuccess() when success != null:
return success();case PublishError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class PublishIdle implements PublishState {
  const PublishIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PublishIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PublishState.idle()';
}


}




/// @nodoc


class PublishSubmitting implements PublishState {
  const PublishSubmitting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PublishSubmitting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PublishState.submitting()';
}


}




/// @nodoc


class PublishSuccess implements PublishState {
  const PublishSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PublishSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PublishState.success()';
}


}




/// @nodoc


class PublishError implements PublishState {
  const PublishError({required this.failure});
  

 final  Failure failure;

/// Create a copy of PublishState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PublishErrorCopyWith<PublishError> get copyWith => _$PublishErrorCopyWithImpl<PublishError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PublishError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'PublishState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $PublishErrorCopyWith<$Res> implements $PublishStateCopyWith<$Res> {
  factory $PublishErrorCopyWith(PublishError value, $Res Function(PublishError) _then) = _$PublishErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$PublishErrorCopyWithImpl<$Res>
    implements $PublishErrorCopyWith<$Res> {
  _$PublishErrorCopyWithImpl(this._self, this._then);

  final PublishError _self;
  final $Res Function(PublishError) _then;

/// Create a copy of PublishState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(PublishError(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of PublishState
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
