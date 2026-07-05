// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessageDto {

 String get id; num get time; num? get expires; String get event; String get topic; String? get message; String? get title; List<String>? get tags; int? get priority; String? get click; String? get icon; List<Map<String, dynamic>>? get actions; Map<String, dynamic>? get attachment;
/// Create a copy of MessageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageDtoCopyWith<MessageDto> get copyWith => _$MessageDtoCopyWithImpl<MessageDto>(this as MessageDto, _$identity);

  /// Serializes this MessageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageDto&&(identical(other.id, id) || other.id == id)&&(identical(other.time, time) || other.time == time)&&(identical(other.expires, expires) || other.expires == expires)&&(identical(other.event, event) || other.event == event)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.message, message) || other.message == message)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.click, click) || other.click == click)&&(identical(other.icon, icon) || other.icon == icon)&&const DeepCollectionEquality().equals(other.actions, actions)&&const DeepCollectionEquality().equals(other.attachment, attachment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,time,expires,event,topic,message,title,const DeepCollectionEquality().hash(tags),priority,click,icon,const DeepCollectionEquality().hash(actions),const DeepCollectionEquality().hash(attachment));

@override
String toString() {
  return 'MessageDto(id: $id, time: $time, expires: $expires, event: $event, topic: $topic, message: $message, title: $title, tags: $tags, priority: $priority, click: $click, icon: $icon, actions: $actions, attachment: $attachment)';
}


}

/// @nodoc
abstract mixin class $MessageDtoCopyWith<$Res>  {
  factory $MessageDtoCopyWith(MessageDto value, $Res Function(MessageDto) _then) = _$MessageDtoCopyWithImpl;
@useResult
$Res call({
 String id, num time, num? expires, String event, String topic, String? message, String? title, List<String>? tags, int? priority, String? click, String? icon, List<Map<String, dynamic>>? actions, Map<String, dynamic>? attachment
});




}
/// @nodoc
class _$MessageDtoCopyWithImpl<$Res>
    implements $MessageDtoCopyWith<$Res> {
  _$MessageDtoCopyWithImpl(this._self, this._then);

  final MessageDto _self;
  final $Res Function(MessageDto) _then;

/// Create a copy of MessageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? time = null,Object? expires = freezed,Object? event = null,Object? topic = null,Object? message = freezed,Object? title = freezed,Object? tags = freezed,Object? priority = freezed,Object? click = freezed,Object? icon = freezed,Object? actions = freezed,Object? attachment = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as num,expires: freezed == expires ? _self.expires : expires // ignore: cast_nullable_to_non_nullable
as num?,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as String,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,tags: freezed == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int?,click: freezed == click ? _self.click : click // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,actions: freezed == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,attachment: freezed == attachment ? _self.attachment : attachment // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [MessageDto].
extension MessageDtoPatterns on MessageDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageDto value)  $default,){
final _that = this;
switch (_that) {
case _MessageDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageDto value)?  $default,){
final _that = this;
switch (_that) {
case _MessageDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  num time,  num? expires,  String event,  String topic,  String? message,  String? title,  List<String>? tags,  int? priority,  String? click,  String? icon,  List<Map<String, dynamic>>? actions,  Map<String, dynamic>? attachment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageDto() when $default != null:
return $default(_that.id,_that.time,_that.expires,_that.event,_that.topic,_that.message,_that.title,_that.tags,_that.priority,_that.click,_that.icon,_that.actions,_that.attachment);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  num time,  num? expires,  String event,  String topic,  String? message,  String? title,  List<String>? tags,  int? priority,  String? click,  String? icon,  List<Map<String, dynamic>>? actions,  Map<String, dynamic>? attachment)  $default,) {final _that = this;
switch (_that) {
case _MessageDto():
return $default(_that.id,_that.time,_that.expires,_that.event,_that.topic,_that.message,_that.title,_that.tags,_that.priority,_that.click,_that.icon,_that.actions,_that.attachment);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  num time,  num? expires,  String event,  String topic,  String? message,  String? title,  List<String>? tags,  int? priority,  String? click,  String? icon,  List<Map<String, dynamic>>? actions,  Map<String, dynamic>? attachment)?  $default,) {final _that = this;
switch (_that) {
case _MessageDto() when $default != null:
return $default(_that.id,_that.time,_that.expires,_that.event,_that.topic,_that.message,_that.title,_that.tags,_that.priority,_that.click,_that.icon,_that.actions,_that.attachment);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessageDto implements MessageDto {
  const _MessageDto({required this.id, required this.time, this.expires, required this.event, required this.topic, this.message, this.title, final  List<String>? tags, this.priority, this.click, this.icon, final  List<Map<String, dynamic>>? actions, final  Map<String, dynamic>? attachment}): _tags = tags,_actions = actions,_attachment = attachment;
  factory _MessageDto.fromJson(Map<String, dynamic> json) => _$MessageDtoFromJson(json);

@override final  String id;
@override final  num time;
@override final  num? expires;
@override final  String event;
@override final  String topic;
@override final  String? message;
@override final  String? title;
 final  List<String>? _tags;
@override List<String>? get tags {
  final value = _tags;
  if (value == null) return null;
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? priority;
@override final  String? click;
@override final  String? icon;
 final  List<Map<String, dynamic>>? _actions;
@override List<Map<String, dynamic>>? get actions {
  final value = _actions;
  if (value == null) return null;
  if (_actions is EqualUnmodifiableListView) return _actions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  Map<String, dynamic>? _attachment;
@override Map<String, dynamic>? get attachment {
  final value = _attachment;
  if (value == null) return null;
  if (_attachment is EqualUnmodifiableMapView) return _attachment;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of MessageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageDtoCopyWith<_MessageDto> get copyWith => __$MessageDtoCopyWithImpl<_MessageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageDto&&(identical(other.id, id) || other.id == id)&&(identical(other.time, time) || other.time == time)&&(identical(other.expires, expires) || other.expires == expires)&&(identical(other.event, event) || other.event == event)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.message, message) || other.message == message)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.click, click) || other.click == click)&&(identical(other.icon, icon) || other.icon == icon)&&const DeepCollectionEquality().equals(other._actions, _actions)&&const DeepCollectionEquality().equals(other._attachment, _attachment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,time,expires,event,topic,message,title,const DeepCollectionEquality().hash(_tags),priority,click,icon,const DeepCollectionEquality().hash(_actions),const DeepCollectionEquality().hash(_attachment));

@override
String toString() {
  return 'MessageDto(id: $id, time: $time, expires: $expires, event: $event, topic: $topic, message: $message, title: $title, tags: $tags, priority: $priority, click: $click, icon: $icon, actions: $actions, attachment: $attachment)';
}


}

/// @nodoc
abstract mixin class _$MessageDtoCopyWith<$Res> implements $MessageDtoCopyWith<$Res> {
  factory _$MessageDtoCopyWith(_MessageDto value, $Res Function(_MessageDto) _then) = __$MessageDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, num time, num? expires, String event, String topic, String? message, String? title, List<String>? tags, int? priority, String? click, String? icon, List<Map<String, dynamic>>? actions, Map<String, dynamic>? attachment
});




}
/// @nodoc
class __$MessageDtoCopyWithImpl<$Res>
    implements _$MessageDtoCopyWith<$Res> {
  __$MessageDtoCopyWithImpl(this._self, this._then);

  final _MessageDto _self;
  final $Res Function(_MessageDto) _then;

/// Create a copy of MessageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? time = null,Object? expires = freezed,Object? event = null,Object? topic = null,Object? message = freezed,Object? title = freezed,Object? tags = freezed,Object? priority = freezed,Object? click = freezed,Object? icon = freezed,Object? actions = freezed,Object? attachment = freezed,}) {
  return _then(_MessageDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as num,expires: freezed == expires ? _self.expires : expires // ignore: cast_nullable_to_non_nullable
as num?,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as String,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,tags: freezed == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>?,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int?,click: freezed == click ? _self.click : click // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,actions: freezed == actions ? _self._actions : actions // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,attachment: freezed == attachment ? _self._attachment : attachment // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
