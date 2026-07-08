// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_selector_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GroupSelectorState {

 List<Group> get groups; String? get selectedGroupId;
/// Create a copy of GroupSelectorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupSelectorStateCopyWith<GroupSelectorState> get copyWith => _$GroupSelectorStateCopyWithImpl<GroupSelectorState>(this as GroupSelectorState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupSelectorState&&const DeepCollectionEquality().equals(other.groups, groups)&&(identical(other.selectedGroupId, selectedGroupId) || other.selectedGroupId == selectedGroupId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(groups),selectedGroupId);

@override
String toString() {
  return 'GroupSelectorState(groups: $groups, selectedGroupId: $selectedGroupId)';
}


}

/// @nodoc
abstract mixin class $GroupSelectorStateCopyWith<$Res>  {
  factory $GroupSelectorStateCopyWith(GroupSelectorState value, $Res Function(GroupSelectorState) _then) = _$GroupSelectorStateCopyWithImpl;
@useResult
$Res call({
 List<Group> groups, String? selectedGroupId
});




}
/// @nodoc
class _$GroupSelectorStateCopyWithImpl<$Res>
    implements $GroupSelectorStateCopyWith<$Res> {
  _$GroupSelectorStateCopyWithImpl(this._self, this._then);

  final GroupSelectorState _self;
  final $Res Function(GroupSelectorState) _then;

/// Create a copy of GroupSelectorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groups = null,Object? selectedGroupId = freezed,}) {
  return _then(_self.copyWith(
groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<Group>,selectedGroupId: freezed == selectedGroupId ? _self.selectedGroupId : selectedGroupId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupSelectorState].
extension GroupSelectorStatePatterns on GroupSelectorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupSelectorState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupSelectorState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupSelectorState value)  $default,){
final _that = this;
switch (_that) {
case _GroupSelectorState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupSelectorState value)?  $default,){
final _that = this;
switch (_that) {
case _GroupSelectorState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Group> groups,  String? selectedGroupId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupSelectorState() when $default != null:
return $default(_that.groups,_that.selectedGroupId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Group> groups,  String? selectedGroupId)  $default,) {final _that = this;
switch (_that) {
case _GroupSelectorState():
return $default(_that.groups,_that.selectedGroupId);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Group> groups,  String? selectedGroupId)?  $default,) {final _that = this;
switch (_that) {
case _GroupSelectorState() when $default != null:
return $default(_that.groups,_that.selectedGroupId);case _:
  return null;

}
}

}

/// @nodoc


class _GroupSelectorState implements GroupSelectorState {
  const _GroupSelectorState({final  List<Group> groups = const [], this.selectedGroupId}): _groups = groups;
  

 final  List<Group> _groups;
@override@JsonKey() List<Group> get groups {
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groups);
}

@override final  String? selectedGroupId;

/// Create a copy of GroupSelectorState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupSelectorStateCopyWith<_GroupSelectorState> get copyWith => __$GroupSelectorStateCopyWithImpl<_GroupSelectorState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupSelectorState&&const DeepCollectionEquality().equals(other._groups, _groups)&&(identical(other.selectedGroupId, selectedGroupId) || other.selectedGroupId == selectedGroupId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_groups),selectedGroupId);

@override
String toString() {
  return 'GroupSelectorState(groups: $groups, selectedGroupId: $selectedGroupId)';
}


}

/// @nodoc
abstract mixin class _$GroupSelectorStateCopyWith<$Res> implements $GroupSelectorStateCopyWith<$Res> {
  factory _$GroupSelectorStateCopyWith(_GroupSelectorState value, $Res Function(_GroupSelectorState) _then) = __$GroupSelectorStateCopyWithImpl;
@override @useResult
$Res call({
 List<Group> groups, String? selectedGroupId
});




}
/// @nodoc
class __$GroupSelectorStateCopyWithImpl<$Res>
    implements _$GroupSelectorStateCopyWith<$Res> {
  __$GroupSelectorStateCopyWithImpl(this._self, this._then);

  final _GroupSelectorState _self;
  final $Res Function(_GroupSelectorState) _then;

/// Create a copy of GroupSelectorState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groups = null,Object? selectedGroupId = freezed,}) {
  return _then(_GroupSelectorState(
groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<Group>,selectedGroupId: freezed == selectedGroupId ? _self.selectedGroupId : selectedGroupId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
