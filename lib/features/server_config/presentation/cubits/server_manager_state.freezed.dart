// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_manager_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ServerManagerState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerManagerState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ServerManagerState()';
}


}

/// @nodoc
class $ServerManagerStateCopyWith<$Res>  {
$ServerManagerStateCopyWith(ServerManagerState _, $Res Function(ServerManagerState) __);
}


/// Adds pattern-matching-related methods to [ServerManagerState].
extension ServerManagerStatePatterns on ServerManagerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ServerManagerLoading value)?  loading,TResult Function( ServerManagerLoaded value)?  loaded,TResult Function( ServerManagerError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ServerManagerLoading() when loading != null:
return loading(_that);case ServerManagerLoaded() when loaded != null:
return loaded(_that);case ServerManagerError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ServerManagerLoading value)  loading,required TResult Function( ServerManagerLoaded value)  loaded,required TResult Function( ServerManagerError value)  error,}){
final _that = this;
switch (_that) {
case ServerManagerLoading():
return loading(_that);case ServerManagerLoaded():
return loaded(_that);case ServerManagerError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ServerManagerLoading value)?  loading,TResult? Function( ServerManagerLoaded value)?  loaded,TResult? Function( ServerManagerError value)?  error,}){
final _that = this;
switch (_that) {
case ServerManagerLoading() when loading != null:
return loading(_that);case ServerManagerLoaded() when loaded != null:
return loaded(_that);case ServerManagerError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( List<ServerConfig> servers)?  loaded,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ServerManagerLoading() when loading != null:
return loading();case ServerManagerLoaded() when loaded != null:
return loaded(_that.servers);case ServerManagerError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( List<ServerConfig> servers)  loaded,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case ServerManagerLoading():
return loading();case ServerManagerLoaded():
return loaded(_that.servers);case ServerManagerError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( List<ServerConfig> servers)?  loaded,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case ServerManagerLoading() when loading != null:
return loading();case ServerManagerLoaded() when loaded != null:
return loaded(_that.servers);case ServerManagerError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class ServerManagerLoading implements ServerManagerState {
  const ServerManagerLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerManagerLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ServerManagerState.loading()';
}


}




/// @nodoc


class ServerManagerLoaded implements ServerManagerState {
  const ServerManagerLoaded(final  List<ServerConfig> servers): _servers = servers;
  

 final  List<ServerConfig> _servers;
 List<ServerConfig> get servers {
  if (_servers is EqualUnmodifiableListView) return _servers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_servers);
}


/// Create a copy of ServerManagerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerManagerLoadedCopyWith<ServerManagerLoaded> get copyWith => _$ServerManagerLoadedCopyWithImpl<ServerManagerLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerManagerLoaded&&const DeepCollectionEquality().equals(other._servers, _servers));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_servers));

@override
String toString() {
  return 'ServerManagerState.loaded(servers: $servers)';
}


}

/// @nodoc
abstract mixin class $ServerManagerLoadedCopyWith<$Res> implements $ServerManagerStateCopyWith<$Res> {
  factory $ServerManagerLoadedCopyWith(ServerManagerLoaded value, $Res Function(ServerManagerLoaded) _then) = _$ServerManagerLoadedCopyWithImpl;
@useResult
$Res call({
 List<ServerConfig> servers
});




}
/// @nodoc
class _$ServerManagerLoadedCopyWithImpl<$Res>
    implements $ServerManagerLoadedCopyWith<$Res> {
  _$ServerManagerLoadedCopyWithImpl(this._self, this._then);

  final ServerManagerLoaded _self;
  final $Res Function(ServerManagerLoaded) _then;

/// Create a copy of ServerManagerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? servers = null,}) {
  return _then(ServerManagerLoaded(
null == servers ? _self._servers : servers // ignore: cast_nullable_to_non_nullable
as List<ServerConfig>,
  ));
}


}

/// @nodoc


class ServerManagerError implements ServerManagerState {
  const ServerManagerError({required this.failure});
  

 final  Failure failure;

/// Create a copy of ServerManagerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerManagerErrorCopyWith<ServerManagerError> get copyWith => _$ServerManagerErrorCopyWithImpl<ServerManagerError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerManagerError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'ServerManagerState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ServerManagerErrorCopyWith<$Res> implements $ServerManagerStateCopyWith<$Res> {
  factory $ServerManagerErrorCopyWith(ServerManagerError value, $Res Function(ServerManagerError) _then) = _$ServerManagerErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$ServerManagerErrorCopyWithImpl<$Res>
    implements $ServerManagerErrorCopyWith<$Res> {
  _$ServerManagerErrorCopyWithImpl(this._self, this._then);

  final ServerManagerError _self;
  final $Res Function(ServerManagerError) _then;

/// Create a copy of ServerManagerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(ServerManagerError(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of ServerManagerState
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
