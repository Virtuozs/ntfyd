// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_credential.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ServerCredential {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerCredential);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ServerCredential()';
}


}

/// @nodoc
class $ServerCredentialCopyWith<$Res>  {
$ServerCredentialCopyWith(ServerCredential _, $Res Function(ServerCredential) __);
}


/// Adds pattern-matching-related methods to [ServerCredential].
extension ServerCredentialPatterns on ServerCredential {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NoAuth value)?  noAuth,TResult Function( BasicAuth value)?  basicAuth,TResult Function( BearerToken value)?  bearerToken,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NoAuth() when noAuth != null:
return noAuth(_that);case BasicAuth() when basicAuth != null:
return basicAuth(_that);case BearerToken() when bearerToken != null:
return bearerToken(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NoAuth value)  noAuth,required TResult Function( BasicAuth value)  basicAuth,required TResult Function( BearerToken value)  bearerToken,}){
final _that = this;
switch (_that) {
case NoAuth():
return noAuth(_that);case BasicAuth():
return basicAuth(_that);case BearerToken():
return bearerToken(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NoAuth value)?  noAuth,TResult? Function( BasicAuth value)?  basicAuth,TResult? Function( BearerToken value)?  bearerToken,}){
final _that = this;
switch (_that) {
case NoAuth() when noAuth != null:
return noAuth(_that);case BasicAuth() when basicAuth != null:
return basicAuth(_that);case BearerToken() when bearerToken != null:
return bearerToken(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  noAuth,TResult Function( String username,  String password)?  basicAuth,TResult Function( String token)?  bearerToken,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NoAuth() when noAuth != null:
return noAuth();case BasicAuth() when basicAuth != null:
return basicAuth(_that.username,_that.password);case BearerToken() when bearerToken != null:
return bearerToken(_that.token);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  noAuth,required TResult Function( String username,  String password)  basicAuth,required TResult Function( String token)  bearerToken,}) {final _that = this;
switch (_that) {
case NoAuth():
return noAuth();case BasicAuth():
return basicAuth(_that.username,_that.password);case BearerToken():
return bearerToken(_that.token);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  noAuth,TResult? Function( String username,  String password)?  basicAuth,TResult? Function( String token)?  bearerToken,}) {final _that = this;
switch (_that) {
case NoAuth() when noAuth != null:
return noAuth();case BasicAuth() when basicAuth != null:
return basicAuth(_that.username,_that.password);case BearerToken() when bearerToken != null:
return bearerToken(_that.token);case _:
  return null;

}
}

}

/// @nodoc


class NoAuth implements ServerCredential {
  const NoAuth();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoAuth);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ServerCredential.noAuth()';
}


}




/// @nodoc


class BasicAuth implements ServerCredential {
  const BasicAuth({required this.username, required this.password});
  

 final  String username;
 final  String password;

/// Create a copy of ServerCredential
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BasicAuthCopyWith<BasicAuth> get copyWith => _$BasicAuthCopyWithImpl<BasicAuth>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BasicAuth&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,username,password);

@override
String toString() {
  return 'ServerCredential.basicAuth(username: $username, password: $password)';
}


}

/// @nodoc
abstract mixin class $BasicAuthCopyWith<$Res> implements $ServerCredentialCopyWith<$Res> {
  factory $BasicAuthCopyWith(BasicAuth value, $Res Function(BasicAuth) _then) = _$BasicAuthCopyWithImpl;
@useResult
$Res call({
 String username, String password
});




}
/// @nodoc
class _$BasicAuthCopyWithImpl<$Res>
    implements $BasicAuthCopyWith<$Res> {
  _$BasicAuthCopyWithImpl(this._self, this._then);

  final BasicAuth _self;
  final $Res Function(BasicAuth) _then;

/// Create a copy of ServerCredential
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? username = null,Object? password = null,}) {
  return _then(BasicAuth(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class BearerToken implements ServerCredential {
  const BearerToken({required this.token});
  

 final  String token;

/// Create a copy of ServerCredential
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BearerTokenCopyWith<BearerToken> get copyWith => _$BearerTokenCopyWithImpl<BearerToken>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BearerToken&&(identical(other.token, token) || other.token == token));
}


@override
int get hashCode => Object.hash(runtimeType,token);

@override
String toString() {
  return 'ServerCredential.bearerToken(token: $token)';
}


}

/// @nodoc
abstract mixin class $BearerTokenCopyWith<$Res> implements $ServerCredentialCopyWith<$Res> {
  factory $BearerTokenCopyWith(BearerToken value, $Res Function(BearerToken) _then) = _$BearerTokenCopyWithImpl;
@useResult
$Res call({
 String token
});




}
/// @nodoc
class _$BearerTokenCopyWithImpl<$Res>
    implements $BearerTokenCopyWith<$Res> {
  _$BearerTokenCopyWithImpl(this._self, this._then);

  final BearerToken _self;
  final $Res Function(BearerToken) _then;

/// Create a copy of ServerCredential
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? token = null,}) {
  return _then(BearerToken(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
