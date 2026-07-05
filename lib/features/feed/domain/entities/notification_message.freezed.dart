// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationMessage {

 String get id; String get serverId; String get topic; DateTime get time; DateTime? get expires; String get event; String? get title; String? get body; int get priority; List<String> get tags; String? get click; String? get icon; Attachment? get attachment; List<NtfyAction> get actions; bool get isMarkdown; bool get read; bool get pinned; DateTime get receivedAt;
/// Create a copy of NotificationMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationMessageCopyWith<NotificationMessage> get copyWith => _$NotificationMessageCopyWithImpl<NotificationMessage>(this as NotificationMessage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.serverId, serverId) || other.serverId == serverId)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.time, time) || other.time == time)&&(identical(other.expires, expires) || other.expires == expires)&&(identical(other.event, event) || other.event == event)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.priority, priority) || other.priority == priority)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.click, click) || other.click == click)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.attachment, attachment) || other.attachment == attachment)&&const DeepCollectionEquality().equals(other.actions, actions)&&(identical(other.isMarkdown, isMarkdown) || other.isMarkdown == isMarkdown)&&(identical(other.read, read) || other.read == read)&&(identical(other.pinned, pinned) || other.pinned == pinned)&&(identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,serverId,topic,time,expires,event,title,body,priority,const DeepCollectionEquality().hash(tags),click,icon,attachment,const DeepCollectionEquality().hash(actions),isMarkdown,read,pinned,receivedAt);

@override
String toString() {
  return 'NotificationMessage(id: $id, serverId: $serverId, topic: $topic, time: $time, expires: $expires, event: $event, title: $title, body: $body, priority: $priority, tags: $tags, click: $click, icon: $icon, attachment: $attachment, actions: $actions, isMarkdown: $isMarkdown, read: $read, pinned: $pinned, receivedAt: $receivedAt)';
}


}

/// @nodoc
abstract mixin class $NotificationMessageCopyWith<$Res>  {
  factory $NotificationMessageCopyWith(NotificationMessage value, $Res Function(NotificationMessage) _then) = _$NotificationMessageCopyWithImpl;
@useResult
$Res call({
 String id, String serverId, String topic, DateTime time, DateTime? expires, String event, String? title, String? body, int priority, List<String> tags, String? click, String? icon, Attachment? attachment, List<NtfyAction> actions, bool isMarkdown, bool read, bool pinned, DateTime receivedAt
});


$AttachmentCopyWith<$Res>? get attachment;

}
/// @nodoc
class _$NotificationMessageCopyWithImpl<$Res>
    implements $NotificationMessageCopyWith<$Res> {
  _$NotificationMessageCopyWithImpl(this._self, this._then);

  final NotificationMessage _self;
  final $Res Function(NotificationMessage) _then;

/// Create a copy of NotificationMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? serverId = null,Object? topic = null,Object? time = null,Object? expires = freezed,Object? event = null,Object? title = freezed,Object? body = freezed,Object? priority = null,Object? tags = null,Object? click = freezed,Object? icon = freezed,Object? attachment = freezed,Object? actions = null,Object? isMarkdown = null,Object? read = null,Object? pinned = null,Object? receivedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,serverId: null == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,expires: freezed == expires ? _self.expires : expires // ignore: cast_nullable_to_non_nullable
as DateTime?,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,click: freezed == click ? _self.click : click // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,attachment: freezed == attachment ? _self.attachment : attachment // ignore: cast_nullable_to_non_nullable
as Attachment?,actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<NtfyAction>,isMarkdown: null == isMarkdown ? _self.isMarkdown : isMarkdown // ignore: cast_nullable_to_non_nullable
as bool,read: null == read ? _self.read : read // ignore: cast_nullable_to_non_nullable
as bool,pinned: null == pinned ? _self.pinned : pinned // ignore: cast_nullable_to_non_nullable
as bool,receivedAt: null == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of NotificationMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttachmentCopyWith<$Res>? get attachment {
    if (_self.attachment == null) {
    return null;
  }

  return $AttachmentCopyWith<$Res>(_self.attachment!, (value) {
    return _then(_self.copyWith(attachment: value));
  });
}
}


/// Adds pattern-matching-related methods to [NotificationMessage].
extension NotificationMessagePatterns on NotificationMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationMessage value)  $default,){
final _that = this;
switch (_that) {
case _NotificationMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationMessage value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String serverId,  String topic,  DateTime time,  DateTime? expires,  String event,  String? title,  String? body,  int priority,  List<String> tags,  String? click,  String? icon,  Attachment? attachment,  List<NtfyAction> actions,  bool isMarkdown,  bool read,  bool pinned,  DateTime receivedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationMessage() when $default != null:
return $default(_that.id,_that.serverId,_that.topic,_that.time,_that.expires,_that.event,_that.title,_that.body,_that.priority,_that.tags,_that.click,_that.icon,_that.attachment,_that.actions,_that.isMarkdown,_that.read,_that.pinned,_that.receivedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String serverId,  String topic,  DateTime time,  DateTime? expires,  String event,  String? title,  String? body,  int priority,  List<String> tags,  String? click,  String? icon,  Attachment? attachment,  List<NtfyAction> actions,  bool isMarkdown,  bool read,  bool pinned,  DateTime receivedAt)  $default,) {final _that = this;
switch (_that) {
case _NotificationMessage():
return $default(_that.id,_that.serverId,_that.topic,_that.time,_that.expires,_that.event,_that.title,_that.body,_that.priority,_that.tags,_that.click,_that.icon,_that.attachment,_that.actions,_that.isMarkdown,_that.read,_that.pinned,_that.receivedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String serverId,  String topic,  DateTime time,  DateTime? expires,  String event,  String? title,  String? body,  int priority,  List<String> tags,  String? click,  String? icon,  Attachment? attachment,  List<NtfyAction> actions,  bool isMarkdown,  bool read,  bool pinned,  DateTime receivedAt)?  $default,) {final _that = this;
switch (_that) {
case _NotificationMessage() when $default != null:
return $default(_that.id,_that.serverId,_that.topic,_that.time,_that.expires,_that.event,_that.title,_that.body,_that.priority,_that.tags,_that.click,_that.icon,_that.attachment,_that.actions,_that.isMarkdown,_that.read,_that.pinned,_that.receivedAt);case _:
  return null;

}
}

}

/// @nodoc


class _NotificationMessage implements NotificationMessage {
  const _NotificationMessage({required this.id, required this.serverId, required this.topic, required this.time, this.expires, required this.event, this.title, this.body, this.priority = 3, final  List<String> tags = const [], this.click, this.icon, this.attachment, final  List<NtfyAction> actions = const [], this.isMarkdown = true, this.read = false, this.pinned = false, required this.receivedAt}): _tags = tags,_actions = actions;
  

@override final  String id;
@override final  String serverId;
@override final  String topic;
@override final  DateTime time;
@override final  DateTime? expires;
@override final  String event;
@override final  String? title;
@override final  String? body;
@override@JsonKey() final  int priority;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  String? click;
@override final  String? icon;
@override final  Attachment? attachment;
 final  List<NtfyAction> _actions;
@override@JsonKey() List<NtfyAction> get actions {
  if (_actions is EqualUnmodifiableListView) return _actions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actions);
}

@override@JsonKey() final  bool isMarkdown;
@override@JsonKey() final  bool read;
@override@JsonKey() final  bool pinned;
@override final  DateTime receivedAt;

/// Create a copy of NotificationMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationMessageCopyWith<_NotificationMessage> get copyWith => __$NotificationMessageCopyWithImpl<_NotificationMessage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.serverId, serverId) || other.serverId == serverId)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.time, time) || other.time == time)&&(identical(other.expires, expires) || other.expires == expires)&&(identical(other.event, event) || other.event == event)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.priority, priority) || other.priority == priority)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.click, click) || other.click == click)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.attachment, attachment) || other.attachment == attachment)&&const DeepCollectionEquality().equals(other._actions, _actions)&&(identical(other.isMarkdown, isMarkdown) || other.isMarkdown == isMarkdown)&&(identical(other.read, read) || other.read == read)&&(identical(other.pinned, pinned) || other.pinned == pinned)&&(identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,serverId,topic,time,expires,event,title,body,priority,const DeepCollectionEquality().hash(_tags),click,icon,attachment,const DeepCollectionEquality().hash(_actions),isMarkdown,read,pinned,receivedAt);

@override
String toString() {
  return 'NotificationMessage(id: $id, serverId: $serverId, topic: $topic, time: $time, expires: $expires, event: $event, title: $title, body: $body, priority: $priority, tags: $tags, click: $click, icon: $icon, attachment: $attachment, actions: $actions, isMarkdown: $isMarkdown, read: $read, pinned: $pinned, receivedAt: $receivedAt)';
}


}

/// @nodoc
abstract mixin class _$NotificationMessageCopyWith<$Res> implements $NotificationMessageCopyWith<$Res> {
  factory _$NotificationMessageCopyWith(_NotificationMessage value, $Res Function(_NotificationMessage) _then) = __$NotificationMessageCopyWithImpl;
@override @useResult
$Res call({
 String id, String serverId, String topic, DateTime time, DateTime? expires, String event, String? title, String? body, int priority, List<String> tags, String? click, String? icon, Attachment? attachment, List<NtfyAction> actions, bool isMarkdown, bool read, bool pinned, DateTime receivedAt
});


@override $AttachmentCopyWith<$Res>? get attachment;

}
/// @nodoc
class __$NotificationMessageCopyWithImpl<$Res>
    implements _$NotificationMessageCopyWith<$Res> {
  __$NotificationMessageCopyWithImpl(this._self, this._then);

  final _NotificationMessage _self;
  final $Res Function(_NotificationMessage) _then;

/// Create a copy of NotificationMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? serverId = null,Object? topic = null,Object? time = null,Object? expires = freezed,Object? event = null,Object? title = freezed,Object? body = freezed,Object? priority = null,Object? tags = null,Object? click = freezed,Object? icon = freezed,Object? attachment = freezed,Object? actions = null,Object? isMarkdown = null,Object? read = null,Object? pinned = null,Object? receivedAt = null,}) {
  return _then(_NotificationMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,serverId: null == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,expires: freezed == expires ? _self.expires : expires // ignore: cast_nullable_to_non_nullable
as DateTime?,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,click: freezed == click ? _self.click : click // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,attachment: freezed == attachment ? _self.attachment : attachment // ignore: cast_nullable_to_non_nullable
as Attachment?,actions: null == actions ? _self._actions : actions // ignore: cast_nullable_to_non_nullable
as List<NtfyAction>,isMarkdown: null == isMarkdown ? _self.isMarkdown : isMarkdown // ignore: cast_nullable_to_non_nullable
as bool,read: null == read ? _self.read : read // ignore: cast_nullable_to_non_nullable
as bool,pinned: null == pinned ? _self.pinned : pinned // ignore: cast_nullable_to_non_nullable
as bool,receivedAt: null == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of NotificationMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttachmentCopyWith<$Res>? get attachment {
    if (_self.attachment == null) {
    return null;
  }

  return $AttachmentCopyWith<$Res>(_self.attachment!, (value) {
    return _then(_self.copyWith(attachment: value));
  });
}
}

// dart format on
