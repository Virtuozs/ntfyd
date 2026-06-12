// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MessageFilter {

 Set<int> get priorities; Set<String> get tags;
/// Create a copy of MessageFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageFilterCopyWith<MessageFilter> get copyWith => _$MessageFilterCopyWithImpl<MessageFilter>(this as MessageFilter, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageFilter&&const DeepCollectionEquality().equals(other.priorities, priorities)&&const DeepCollectionEquality().equals(other.tags, tags));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(priorities),const DeepCollectionEquality().hash(tags));

@override
String toString() {
  return 'MessageFilter(priorities: $priorities, tags: $tags)';
}


}

/// @nodoc
abstract mixin class $MessageFilterCopyWith<$Res>  {
  factory $MessageFilterCopyWith(MessageFilter value, $Res Function(MessageFilter) _then) = _$MessageFilterCopyWithImpl;
@useResult
$Res call({
 Set<int> priorities, Set<String> tags
});




}
/// @nodoc
class _$MessageFilterCopyWithImpl<$Res>
    implements $MessageFilterCopyWith<$Res> {
  _$MessageFilterCopyWithImpl(this._self, this._then);

  final MessageFilter _self;
  final $Res Function(MessageFilter) _then;

/// Create a copy of MessageFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? priorities = null,Object? tags = null,}) {
  return _then(_self.copyWith(
priorities: null == priorities ? _self.priorities : priorities // ignore: cast_nullable_to_non_nullable
as Set<int>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [MessageFilter].
extension MessageFilterPatterns on MessageFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageFilter value)  $default,){
final _that = this;
switch (_that) {
case _MessageFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageFilter value)?  $default,){
final _that = this;
switch (_that) {
case _MessageFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Set<int> priorities,  Set<String> tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageFilter() when $default != null:
return $default(_that.priorities,_that.tags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Set<int> priorities,  Set<String> tags)  $default,) {final _that = this;
switch (_that) {
case _MessageFilter():
return $default(_that.priorities,_that.tags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Set<int> priorities,  Set<String> tags)?  $default,) {final _that = this;
switch (_that) {
case _MessageFilter() when $default != null:
return $default(_that.priorities,_that.tags);case _:
  return null;

}
}

}

/// @nodoc


class _MessageFilter implements MessageFilter {
  const _MessageFilter({final  Set<int> priorities = const {}, final  Set<String> tags = const {}}): _priorities = priorities,_tags = tags;
  

 final  Set<int> _priorities;
@override@JsonKey() Set<int> get priorities {
  if (_priorities is EqualUnmodifiableSetView) return _priorities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_priorities);
}

 final  Set<String> _tags;
@override@JsonKey() Set<String> get tags {
  if (_tags is EqualUnmodifiableSetView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_tags);
}


/// Create a copy of MessageFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageFilterCopyWith<_MessageFilter> get copyWith => __$MessageFilterCopyWithImpl<_MessageFilter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageFilter&&const DeepCollectionEquality().equals(other._priorities, _priorities)&&const DeepCollectionEquality().equals(other._tags, _tags));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_priorities),const DeepCollectionEquality().hash(_tags));

@override
String toString() {
  return 'MessageFilter(priorities: $priorities, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$MessageFilterCopyWith<$Res> implements $MessageFilterCopyWith<$Res> {
  factory _$MessageFilterCopyWith(_MessageFilter value, $Res Function(_MessageFilter) _then) = __$MessageFilterCopyWithImpl;
@override @useResult
$Res call({
 Set<int> priorities, Set<String> tags
});




}
/// @nodoc
class __$MessageFilterCopyWithImpl<$Res>
    implements _$MessageFilterCopyWith<$Res> {
  __$MessageFilterCopyWithImpl(this._self, this._then);

  final _MessageFilter _self;
  final $Res Function(_MessageFilter) _then;

/// Create a copy of MessageFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? priorities = null,Object? tags = null,}) {
  return _then(_MessageFilter(
priorities: null == priorities ? _self._priorities : priorities // ignore: cast_nullable_to_non_nullable
as Set<int>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}


}

// dart format on
