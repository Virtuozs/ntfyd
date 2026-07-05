// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'publish_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PublishDraft {

 String get topic; String get body; String? get title; int get priority; List<String> get tags; String? get attachmentPath; bool get markdown; String? get delay;
/// Create a copy of PublishDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PublishDraftCopyWith<PublishDraft> get copyWith => _$PublishDraftCopyWithImpl<PublishDraft>(this as PublishDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PublishDraft&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.body, body) || other.body == body)&&(identical(other.title, title) || other.title == title)&&(identical(other.priority, priority) || other.priority == priority)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.attachmentPath, attachmentPath) || other.attachmentPath == attachmentPath)&&(identical(other.markdown, markdown) || other.markdown == markdown)&&(identical(other.delay, delay) || other.delay == delay));
}


@override
int get hashCode => Object.hash(runtimeType,topic,body,title,priority,const DeepCollectionEquality().hash(tags),attachmentPath,markdown,delay);

@override
String toString() {
  return 'PublishDraft(topic: $topic, body: $body, title: $title, priority: $priority, tags: $tags, attachmentPath: $attachmentPath, markdown: $markdown, delay: $delay)';
}


}

/// @nodoc
abstract mixin class $PublishDraftCopyWith<$Res>  {
  factory $PublishDraftCopyWith(PublishDraft value, $Res Function(PublishDraft) _then) = _$PublishDraftCopyWithImpl;
@useResult
$Res call({
 String topic, String body, String? title, int priority, List<String> tags, String? attachmentPath, bool markdown, String? delay
});




}
/// @nodoc
class _$PublishDraftCopyWithImpl<$Res>
    implements $PublishDraftCopyWith<$Res> {
  _$PublishDraftCopyWithImpl(this._self, this._then);

  final PublishDraft _self;
  final $Res Function(PublishDraft) _then;

/// Create a copy of PublishDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? topic = null,Object? body = null,Object? title = freezed,Object? priority = null,Object? tags = null,Object? attachmentPath = freezed,Object? markdown = null,Object? delay = freezed,}) {
  return _then(_self.copyWith(
topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,attachmentPath: freezed == attachmentPath ? _self.attachmentPath : attachmentPath // ignore: cast_nullable_to_non_nullable
as String?,markdown: null == markdown ? _self.markdown : markdown // ignore: cast_nullable_to_non_nullable
as bool,delay: freezed == delay ? _self.delay : delay // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PublishDraft].
extension PublishDraftPatterns on PublishDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PublishDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PublishDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PublishDraft value)  $default,){
final _that = this;
switch (_that) {
case _PublishDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PublishDraft value)?  $default,){
final _that = this;
switch (_that) {
case _PublishDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String topic,  String body,  String? title,  int priority,  List<String> tags,  String? attachmentPath,  bool markdown,  String? delay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PublishDraft() when $default != null:
return $default(_that.topic,_that.body,_that.title,_that.priority,_that.tags,_that.attachmentPath,_that.markdown,_that.delay);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String topic,  String body,  String? title,  int priority,  List<String> tags,  String? attachmentPath,  bool markdown,  String? delay)  $default,) {final _that = this;
switch (_that) {
case _PublishDraft():
return $default(_that.topic,_that.body,_that.title,_that.priority,_that.tags,_that.attachmentPath,_that.markdown,_that.delay);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String topic,  String body,  String? title,  int priority,  List<String> tags,  String? attachmentPath,  bool markdown,  String? delay)?  $default,) {final _that = this;
switch (_that) {
case _PublishDraft() when $default != null:
return $default(_that.topic,_that.body,_that.title,_that.priority,_that.tags,_that.attachmentPath,_that.markdown,_that.delay);case _:
  return null;

}
}

}

/// @nodoc


class _PublishDraft extends PublishDraft {
  const _PublishDraft({required this.topic, required this.body, this.title, this.priority = 3, final  List<String> tags = const [], this.attachmentPath, this.markdown = false, this.delay}): _tags = tags,super._();
  

@override final  String topic;
@override final  String body;
@override final  String? title;
@override@JsonKey() final  int priority;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  String? attachmentPath;
@override@JsonKey() final  bool markdown;
@override final  String? delay;

/// Create a copy of PublishDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PublishDraftCopyWith<_PublishDraft> get copyWith => __$PublishDraftCopyWithImpl<_PublishDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PublishDraft&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.body, body) || other.body == body)&&(identical(other.title, title) || other.title == title)&&(identical(other.priority, priority) || other.priority == priority)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.attachmentPath, attachmentPath) || other.attachmentPath == attachmentPath)&&(identical(other.markdown, markdown) || other.markdown == markdown)&&(identical(other.delay, delay) || other.delay == delay));
}


@override
int get hashCode => Object.hash(runtimeType,topic,body,title,priority,const DeepCollectionEquality().hash(_tags),attachmentPath,markdown,delay);

@override
String toString() {
  return 'PublishDraft(topic: $topic, body: $body, title: $title, priority: $priority, tags: $tags, attachmentPath: $attachmentPath, markdown: $markdown, delay: $delay)';
}


}

/// @nodoc
abstract mixin class _$PublishDraftCopyWith<$Res> implements $PublishDraftCopyWith<$Res> {
  factory _$PublishDraftCopyWith(_PublishDraft value, $Res Function(_PublishDraft) _then) = __$PublishDraftCopyWithImpl;
@override @useResult
$Res call({
 String topic, String body, String? title, int priority, List<String> tags, String? attachmentPath, bool markdown, String? delay
});




}
/// @nodoc
class __$PublishDraftCopyWithImpl<$Res>
    implements _$PublishDraftCopyWith<$Res> {
  __$PublishDraftCopyWithImpl(this._self, this._then);

  final _PublishDraft _self;
  final $Res Function(_PublishDraft) _then;

/// Create a copy of PublishDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? topic = null,Object? body = null,Object? title = freezed,Object? priority = null,Object? tags = null,Object? attachmentPath = freezed,Object? markdown = null,Object? delay = freezed,}) {
  return _then(_PublishDraft(
topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,attachmentPath: freezed == attachmentPath ? _self.attachmentPath : attachmentPath // ignore: cast_nullable_to_non_nullable
as String?,markdown: null == markdown ? _self.markdown : markdown // ignore: cast_nullable_to_non_nullable
as bool,delay: freezed == delay ? _self.delay : delay // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
