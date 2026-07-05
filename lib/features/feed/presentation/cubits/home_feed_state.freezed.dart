// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_feed_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeFeedState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeFeedState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeFeedState()';
}


}

/// @nodoc
class $HomeFeedStateCopyWith<$Res>  {
$HomeFeedStateCopyWith(HomeFeedState _, $Res Function(HomeFeedState) __);
}


/// Adds pattern-matching-related methods to [HomeFeedState].
extension HomeFeedStatePatterns on HomeFeedState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( HomeFeedLoading value)?  loading,TResult Function( HomeFeedLoaded value)?  loaded,TResult Function( HomeFeedError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case HomeFeedLoading() when loading != null:
return loading(_that);case HomeFeedLoaded() when loaded != null:
return loaded(_that);case HomeFeedError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( HomeFeedLoading value)  loading,required TResult Function( HomeFeedLoaded value)  loaded,required TResult Function( HomeFeedError value)  error,}){
final _that = this;
switch (_that) {
case HomeFeedLoading():
return loading(_that);case HomeFeedLoaded():
return loaded(_that);case HomeFeedError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( HomeFeedLoading value)?  loading,TResult? Function( HomeFeedLoaded value)?  loaded,TResult? Function( HomeFeedError value)?  error,}){
final _that = this;
switch (_that) {
case HomeFeedLoading() when loading != null:
return loading(_that);case HomeFeedLoaded() when loaded != null:
return loaded(_that);case HomeFeedError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( List<HomeTopicSummary> items)?  loaded,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case HomeFeedLoading() when loading != null:
return loading();case HomeFeedLoaded() when loaded != null:
return loaded(_that.items);case HomeFeedError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( List<HomeTopicSummary> items)  loaded,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case HomeFeedLoading():
return loading();case HomeFeedLoaded():
return loaded(_that.items);case HomeFeedError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( List<HomeTopicSummary> items)?  loaded,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case HomeFeedLoading() when loading != null:
return loading();case HomeFeedLoaded() when loaded != null:
return loaded(_that.items);case HomeFeedError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class HomeFeedLoading implements HomeFeedState {
  const HomeFeedLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeFeedLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeFeedState.loading()';
}


}




/// @nodoc


class HomeFeedLoaded implements HomeFeedState {
  const HomeFeedLoaded({required final  List<HomeTopicSummary> items}): _items = items;
  

 final  List<HomeTopicSummary> _items;
 List<HomeTopicSummary> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of HomeFeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeFeedLoadedCopyWith<HomeFeedLoaded> get copyWith => _$HomeFeedLoadedCopyWithImpl<HomeFeedLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeFeedLoaded&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'HomeFeedState.loaded(items: $items)';
}


}

/// @nodoc
abstract mixin class $HomeFeedLoadedCopyWith<$Res> implements $HomeFeedStateCopyWith<$Res> {
  factory $HomeFeedLoadedCopyWith(HomeFeedLoaded value, $Res Function(HomeFeedLoaded) _then) = _$HomeFeedLoadedCopyWithImpl;
@useResult
$Res call({
 List<HomeTopicSummary> items
});




}
/// @nodoc
class _$HomeFeedLoadedCopyWithImpl<$Res>
    implements $HomeFeedLoadedCopyWith<$Res> {
  _$HomeFeedLoadedCopyWithImpl(this._self, this._then);

  final HomeFeedLoaded _self;
  final $Res Function(HomeFeedLoaded) _then;

/// Create a copy of HomeFeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(HomeFeedLoaded(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<HomeTopicSummary>,
  ));
}


}

/// @nodoc


class HomeFeedError implements HomeFeedState {
  const HomeFeedError({required this.failure});
  

 final  Failure failure;

/// Create a copy of HomeFeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeFeedErrorCopyWith<HomeFeedError> get copyWith => _$HomeFeedErrorCopyWithImpl<HomeFeedError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeFeedError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'HomeFeedState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $HomeFeedErrorCopyWith<$Res> implements $HomeFeedStateCopyWith<$Res> {
  factory $HomeFeedErrorCopyWith(HomeFeedError value, $Res Function(HomeFeedError) _then) = _$HomeFeedErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$HomeFeedErrorCopyWithImpl<$Res>
    implements $HomeFeedErrorCopyWith<$Res> {
  _$HomeFeedErrorCopyWithImpl(this._self, this._then);

  final HomeFeedError _self;
  final $Res Function(HomeFeedError) _then;

/// Create a copy of HomeFeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(HomeFeedError(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of HomeFeedState
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
