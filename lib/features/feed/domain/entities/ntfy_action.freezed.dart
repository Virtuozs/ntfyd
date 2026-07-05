// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ntfy_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NtfyAction {

 String get label; bool get clear;
/// Create a copy of NtfyAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NtfyActionCopyWith<NtfyAction> get copyWith => _$NtfyActionCopyWithImpl<NtfyAction>(this as NtfyAction, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NtfyAction&&(identical(other.label, label) || other.label == label)&&(identical(other.clear, clear) || other.clear == clear));
}


@override
int get hashCode => Object.hash(runtimeType,label,clear);

@override
String toString() {
  return 'NtfyAction(label: $label, clear: $clear)';
}


}

/// @nodoc
abstract mixin class $NtfyActionCopyWith<$Res>  {
  factory $NtfyActionCopyWith(NtfyAction value, $Res Function(NtfyAction) _then) = _$NtfyActionCopyWithImpl;
@useResult
$Res call({
 String label, bool clear
});




}
/// @nodoc
class _$NtfyActionCopyWithImpl<$Res>
    implements $NtfyActionCopyWith<$Res> {
  _$NtfyActionCopyWithImpl(this._self, this._then);

  final NtfyAction _self;
  final $Res Function(NtfyAction) _then;

/// Create a copy of NtfyAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? clear = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,clear: null == clear ? _self.clear : clear // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NtfyAction].
extension NtfyActionPatterns on NtfyAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ViewAction value)?  view,TResult Function( HttpAction value)?  http,TResult Function( BroadcastAction value)?  broadcast,TResult Function( CopyAction value)?  copy,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ViewAction() when view != null:
return view(_that);case HttpAction() when http != null:
return http(_that);case BroadcastAction() when broadcast != null:
return broadcast(_that);case CopyAction() when copy != null:
return copy(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ViewAction value)  view,required TResult Function( HttpAction value)  http,required TResult Function( BroadcastAction value)  broadcast,required TResult Function( CopyAction value)  copy,}){
final _that = this;
switch (_that) {
case ViewAction():
return view(_that);case HttpAction():
return http(_that);case BroadcastAction():
return broadcast(_that);case CopyAction():
return copy(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ViewAction value)?  view,TResult? Function( HttpAction value)?  http,TResult? Function( BroadcastAction value)?  broadcast,TResult? Function( CopyAction value)?  copy,}){
final _that = this;
switch (_that) {
case ViewAction() when view != null:
return view(_that);case HttpAction() when http != null:
return http(_that);case BroadcastAction() when broadcast != null:
return broadcast(_that);case CopyAction() when copy != null:
return copy(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String label,  String url,  bool clear)?  view,TResult Function( String label,  String url,  String method,  Map<String, String> headers,  String? body,  bool clear)?  http,TResult Function( String label,  String intent,  Map<String, String> extras,  bool clear)?  broadcast,TResult Function( String label,  String value,  bool clear)?  copy,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ViewAction() when view != null:
return view(_that.label,_that.url,_that.clear);case HttpAction() when http != null:
return http(_that.label,_that.url,_that.method,_that.headers,_that.body,_that.clear);case BroadcastAction() when broadcast != null:
return broadcast(_that.label,_that.intent,_that.extras,_that.clear);case CopyAction() when copy != null:
return copy(_that.label,_that.value,_that.clear);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String label,  String url,  bool clear)  view,required TResult Function( String label,  String url,  String method,  Map<String, String> headers,  String? body,  bool clear)  http,required TResult Function( String label,  String intent,  Map<String, String> extras,  bool clear)  broadcast,required TResult Function( String label,  String value,  bool clear)  copy,}) {final _that = this;
switch (_that) {
case ViewAction():
return view(_that.label,_that.url,_that.clear);case HttpAction():
return http(_that.label,_that.url,_that.method,_that.headers,_that.body,_that.clear);case BroadcastAction():
return broadcast(_that.label,_that.intent,_that.extras,_that.clear);case CopyAction():
return copy(_that.label,_that.value,_that.clear);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String label,  String url,  bool clear)?  view,TResult? Function( String label,  String url,  String method,  Map<String, String> headers,  String? body,  bool clear)?  http,TResult? Function( String label,  String intent,  Map<String, String> extras,  bool clear)?  broadcast,TResult? Function( String label,  String value,  bool clear)?  copy,}) {final _that = this;
switch (_that) {
case ViewAction() when view != null:
return view(_that.label,_that.url,_that.clear);case HttpAction() when http != null:
return http(_that.label,_that.url,_that.method,_that.headers,_that.body,_that.clear);case BroadcastAction() when broadcast != null:
return broadcast(_that.label,_that.intent,_that.extras,_that.clear);case CopyAction() when copy != null:
return copy(_that.label,_that.value,_that.clear);case _:
  return null;

}
}

}

/// @nodoc


class ViewAction implements NtfyAction {
  const ViewAction({required this.label, required this.url, this.clear = false});
  

@override final  String label;
 final  String url;
@override@JsonKey() final  bool clear;

/// Create a copy of NtfyAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ViewActionCopyWith<ViewAction> get copyWith => _$ViewActionCopyWithImpl<ViewAction>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ViewAction&&(identical(other.label, label) || other.label == label)&&(identical(other.url, url) || other.url == url)&&(identical(other.clear, clear) || other.clear == clear));
}


@override
int get hashCode => Object.hash(runtimeType,label,url,clear);

@override
String toString() {
  return 'NtfyAction.view(label: $label, url: $url, clear: $clear)';
}


}

/// @nodoc
abstract mixin class $ViewActionCopyWith<$Res> implements $NtfyActionCopyWith<$Res> {
  factory $ViewActionCopyWith(ViewAction value, $Res Function(ViewAction) _then) = _$ViewActionCopyWithImpl;
@override @useResult
$Res call({
 String label, String url, bool clear
});




}
/// @nodoc
class _$ViewActionCopyWithImpl<$Res>
    implements $ViewActionCopyWith<$Res> {
  _$ViewActionCopyWithImpl(this._self, this._then);

  final ViewAction _self;
  final $Res Function(ViewAction) _then;

/// Create a copy of NtfyAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? url = null,Object? clear = null,}) {
  return _then(ViewAction(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,clear: null == clear ? _self.clear : clear // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class HttpAction implements NtfyAction {
  const HttpAction({required this.label, required this.url, this.method = 'POST', final  Map<String, String> headers = const {}, this.body, this.clear = false}): _headers = headers;
  

@override final  String label;
 final  String url;
@JsonKey() final  String method;
 final  Map<String, String> _headers;
@JsonKey() Map<String, String> get headers {
  if (_headers is EqualUnmodifiableMapView) return _headers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_headers);
}

 final  String? body;
@override@JsonKey() final  bool clear;

/// Create a copy of NtfyAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HttpActionCopyWith<HttpAction> get copyWith => _$HttpActionCopyWithImpl<HttpAction>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HttpAction&&(identical(other.label, label) || other.label == label)&&(identical(other.url, url) || other.url == url)&&(identical(other.method, method) || other.method == method)&&const DeepCollectionEquality().equals(other._headers, _headers)&&(identical(other.body, body) || other.body == body)&&(identical(other.clear, clear) || other.clear == clear));
}


@override
int get hashCode => Object.hash(runtimeType,label,url,method,const DeepCollectionEquality().hash(_headers),body,clear);

@override
String toString() {
  return 'NtfyAction.http(label: $label, url: $url, method: $method, headers: $headers, body: $body, clear: $clear)';
}


}

/// @nodoc
abstract mixin class $HttpActionCopyWith<$Res> implements $NtfyActionCopyWith<$Res> {
  factory $HttpActionCopyWith(HttpAction value, $Res Function(HttpAction) _then) = _$HttpActionCopyWithImpl;
@override @useResult
$Res call({
 String label, String url, String method, Map<String, String> headers, String? body, bool clear
});




}
/// @nodoc
class _$HttpActionCopyWithImpl<$Res>
    implements $HttpActionCopyWith<$Res> {
  _$HttpActionCopyWithImpl(this._self, this._then);

  final HttpAction _self;
  final $Res Function(HttpAction) _then;

/// Create a copy of NtfyAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? url = null,Object? method = null,Object? headers = null,Object? body = freezed,Object? clear = null,}) {
  return _then(HttpAction(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,headers: null == headers ? _self._headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,clear: null == clear ? _self.clear : clear // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class BroadcastAction implements NtfyAction {
  const BroadcastAction({required this.label, this.intent = 'io.heckel.ntfy.USER_ACTION', final  Map<String, String> extras = const {}, this.clear = false}): _extras = extras;
  

@override final  String label;
@JsonKey() final  String intent;
 final  Map<String, String> _extras;
@JsonKey() Map<String, String> get extras {
  if (_extras is EqualUnmodifiableMapView) return _extras;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_extras);
}

@override@JsonKey() final  bool clear;

/// Create a copy of NtfyAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BroadcastActionCopyWith<BroadcastAction> get copyWith => _$BroadcastActionCopyWithImpl<BroadcastAction>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BroadcastAction&&(identical(other.label, label) || other.label == label)&&(identical(other.intent, intent) || other.intent == intent)&&const DeepCollectionEquality().equals(other._extras, _extras)&&(identical(other.clear, clear) || other.clear == clear));
}


@override
int get hashCode => Object.hash(runtimeType,label,intent,const DeepCollectionEquality().hash(_extras),clear);

@override
String toString() {
  return 'NtfyAction.broadcast(label: $label, intent: $intent, extras: $extras, clear: $clear)';
}


}

/// @nodoc
abstract mixin class $BroadcastActionCopyWith<$Res> implements $NtfyActionCopyWith<$Res> {
  factory $BroadcastActionCopyWith(BroadcastAction value, $Res Function(BroadcastAction) _then) = _$BroadcastActionCopyWithImpl;
@override @useResult
$Res call({
 String label, String intent, Map<String, String> extras, bool clear
});




}
/// @nodoc
class _$BroadcastActionCopyWithImpl<$Res>
    implements $BroadcastActionCopyWith<$Res> {
  _$BroadcastActionCopyWithImpl(this._self, this._then);

  final BroadcastAction _self;
  final $Res Function(BroadcastAction) _then;

/// Create a copy of NtfyAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? intent = null,Object? extras = null,Object? clear = null,}) {
  return _then(BroadcastAction(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,intent: null == intent ? _self.intent : intent // ignore: cast_nullable_to_non_nullable
as String,extras: null == extras ? _self._extras : extras // ignore: cast_nullable_to_non_nullable
as Map<String, String>,clear: null == clear ? _self.clear : clear // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class CopyAction implements NtfyAction {
  const CopyAction({required this.label, required this.value, this.clear = false});
  

@override final  String label;
 final  String value;
@override@JsonKey() final  bool clear;

/// Create a copy of NtfyAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CopyActionCopyWith<CopyAction> get copyWith => _$CopyActionCopyWithImpl<CopyAction>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CopyAction&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.clear, clear) || other.clear == clear));
}


@override
int get hashCode => Object.hash(runtimeType,label,value,clear);

@override
String toString() {
  return 'NtfyAction.copy(label: $label, value: $value, clear: $clear)';
}


}

/// @nodoc
abstract mixin class $CopyActionCopyWith<$Res> implements $NtfyActionCopyWith<$Res> {
  factory $CopyActionCopyWith(CopyAction value, $Res Function(CopyAction) _then) = _$CopyActionCopyWithImpl;
@override @useResult
$Res call({
 String label, String value, bool clear
});




}
/// @nodoc
class _$CopyActionCopyWithImpl<$Res>
    implements $CopyActionCopyWith<$Res> {
  _$CopyActionCopyWithImpl(this._self, this._then);

  final CopyAction _self;
  final $Res Function(CopyAction) _then;

/// Create a copy of NtfyAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? value = null,Object? clear = null,}) {
  return _then(CopyAction(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,clear: null == clear ? _self.clear : clear // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
