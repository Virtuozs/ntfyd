// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GroupFormState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupFormState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GroupFormState()';
}


}

/// @nodoc
class $GroupFormStateCopyWith<$Res>  {
$GroupFormStateCopyWith(GroupFormState _, $Res Function(GroupFormState) __);
}


/// Adds pattern-matching-related methods to [GroupFormState].
extension GroupFormStatePatterns on GroupFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( GroupFormIdle value)?  idle,TResult Function( GroupFormSubmitting value)?  submitting,TResult Function( GroupFormSuccess value)?  success,TResult Function( GroupFormError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case GroupFormIdle() when idle != null:
return idle(_that);case GroupFormSubmitting() when submitting != null:
return submitting(_that);case GroupFormSuccess() when success != null:
return success(_that);case GroupFormError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( GroupFormIdle value)  idle,required TResult Function( GroupFormSubmitting value)  submitting,required TResult Function( GroupFormSuccess value)  success,required TResult Function( GroupFormError value)  error,}){
final _that = this;
switch (_that) {
case GroupFormIdle():
return idle(_that);case GroupFormSubmitting():
return submitting(_that);case GroupFormSuccess():
return success(_that);case GroupFormError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( GroupFormIdle value)?  idle,TResult? Function( GroupFormSubmitting value)?  submitting,TResult? Function( GroupFormSuccess value)?  success,TResult? Function( GroupFormError value)?  error,}){
final _that = this;
switch (_that) {
case GroupFormIdle() when idle != null:
return idle(_that);case GroupFormSubmitting() when submitting != null:
return submitting(_that);case GroupFormSuccess() when success != null:
return success(_that);case GroupFormError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  submitting,TResult Function( Group group)?  success,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case GroupFormIdle() when idle != null:
return idle();case GroupFormSubmitting() when submitting != null:
return submitting();case GroupFormSuccess() when success != null:
return success(_that.group);case GroupFormError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  submitting,required TResult Function( Group group)  success,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case GroupFormIdle():
return idle();case GroupFormSubmitting():
return submitting();case GroupFormSuccess():
return success(_that.group);case GroupFormError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  submitting,TResult? Function( Group group)?  success,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case GroupFormIdle() when idle != null:
return idle();case GroupFormSubmitting() when submitting != null:
return submitting();case GroupFormSuccess() when success != null:
return success(_that.group);case GroupFormError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class GroupFormIdle implements GroupFormState {
  const GroupFormIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupFormIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GroupFormState.idle()';
}


}




/// @nodoc


class GroupFormSubmitting implements GroupFormState {
  const GroupFormSubmitting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupFormSubmitting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GroupFormState.submitting()';
}


}




/// @nodoc


class GroupFormSuccess implements GroupFormState {
  const GroupFormSuccess({required this.group});
  

 final  Group group;

/// Create a copy of GroupFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupFormSuccessCopyWith<GroupFormSuccess> get copyWith => _$GroupFormSuccessCopyWithImpl<GroupFormSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupFormSuccess&&(identical(other.group, group) || other.group == group));
}


@override
int get hashCode => Object.hash(runtimeType,group);

@override
String toString() {
  return 'GroupFormState.success(group: $group)';
}


}

/// @nodoc
abstract mixin class $GroupFormSuccessCopyWith<$Res> implements $GroupFormStateCopyWith<$Res> {
  factory $GroupFormSuccessCopyWith(GroupFormSuccess value, $Res Function(GroupFormSuccess) _then) = _$GroupFormSuccessCopyWithImpl;
@useResult
$Res call({
 Group group
});


$GroupCopyWith<$Res> get group;

}
/// @nodoc
class _$GroupFormSuccessCopyWithImpl<$Res>
    implements $GroupFormSuccessCopyWith<$Res> {
  _$GroupFormSuccessCopyWithImpl(this._self, this._then);

  final GroupFormSuccess _self;
  final $Res Function(GroupFormSuccess) _then;

/// Create a copy of GroupFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? group = null,}) {
  return _then(GroupFormSuccess(
group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as Group,
  ));
}

/// Create a copy of GroupFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GroupCopyWith<$Res> get group {
  
  return $GroupCopyWith<$Res>(_self.group, (value) {
    return _then(_self.copyWith(group: value));
  });
}
}

/// @nodoc


class GroupFormError implements GroupFormState {
  const GroupFormError({required this.failure});
  

 final  Failure failure;

/// Create a copy of GroupFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupFormErrorCopyWith<GroupFormError> get copyWith => _$GroupFormErrorCopyWithImpl<GroupFormError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupFormError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'GroupFormState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $GroupFormErrorCopyWith<$Res> implements $GroupFormStateCopyWith<$Res> {
  factory $GroupFormErrorCopyWith(GroupFormError value, $Res Function(GroupFormError) _then) = _$GroupFormErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$GroupFormErrorCopyWithImpl<$Res>
    implements $GroupFormErrorCopyWith<$Res> {
  _$GroupFormErrorCopyWithImpl(this._self, this._then);

  final GroupFormError _self;
  final $Res Function(GroupFormError) _then;

/// Create a copy of GroupFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(GroupFormError(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of GroupFormState
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
