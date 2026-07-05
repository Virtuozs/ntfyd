// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_topic_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeTopicSummary {

 Subscription get subscription; NotificationMessage? get latestMessage; int get unreadCount;
/// Create a copy of HomeTopicSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeTopicSummaryCopyWith<HomeTopicSummary> get copyWith => _$HomeTopicSummaryCopyWithImpl<HomeTopicSummary>(this as HomeTopicSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeTopicSummary&&(identical(other.subscription, subscription) || other.subscription == subscription)&&(identical(other.latestMessage, latestMessage) || other.latestMessage == latestMessage)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount));
}


@override
int get hashCode => Object.hash(runtimeType,subscription,latestMessage,unreadCount);

@override
String toString() {
  return 'HomeTopicSummary(subscription: $subscription, latestMessage: $latestMessage, unreadCount: $unreadCount)';
}


}

/// @nodoc
abstract mixin class $HomeTopicSummaryCopyWith<$Res>  {
  factory $HomeTopicSummaryCopyWith(HomeTopicSummary value, $Res Function(HomeTopicSummary) _then) = _$HomeTopicSummaryCopyWithImpl;
@useResult
$Res call({
 Subscription subscription, NotificationMessage? latestMessage, int unreadCount
});


$SubscriptionCopyWith<$Res> get subscription;$NotificationMessageCopyWith<$Res>? get latestMessage;

}
/// @nodoc
class _$HomeTopicSummaryCopyWithImpl<$Res>
    implements $HomeTopicSummaryCopyWith<$Res> {
  _$HomeTopicSummaryCopyWithImpl(this._self, this._then);

  final HomeTopicSummary _self;
  final $Res Function(HomeTopicSummary) _then;

/// Create a copy of HomeTopicSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subscription = null,Object? latestMessage = freezed,Object? unreadCount = null,}) {
  return _then(_self.copyWith(
subscription: null == subscription ? _self.subscription : subscription // ignore: cast_nullable_to_non_nullable
as Subscription,latestMessage: freezed == latestMessage ? _self.latestMessage : latestMessage // ignore: cast_nullable_to_non_nullable
as NotificationMessage?,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of HomeTopicSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubscriptionCopyWith<$Res> get subscription {
  
  return $SubscriptionCopyWith<$Res>(_self.subscription, (value) {
    return _then(_self.copyWith(subscription: value));
  });
}/// Create a copy of HomeTopicSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationMessageCopyWith<$Res>? get latestMessage {
    if (_self.latestMessage == null) {
    return null;
  }

  return $NotificationMessageCopyWith<$Res>(_self.latestMessage!, (value) {
    return _then(_self.copyWith(latestMessage: value));
  });
}
}


/// Adds pattern-matching-related methods to [HomeTopicSummary].
extension HomeTopicSummaryPatterns on HomeTopicSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeTopicSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeTopicSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeTopicSummary value)  $default,){
final _that = this;
switch (_that) {
case _HomeTopicSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeTopicSummary value)?  $default,){
final _that = this;
switch (_that) {
case _HomeTopicSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Subscription subscription,  NotificationMessage? latestMessage,  int unreadCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeTopicSummary() when $default != null:
return $default(_that.subscription,_that.latestMessage,_that.unreadCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Subscription subscription,  NotificationMessage? latestMessage,  int unreadCount)  $default,) {final _that = this;
switch (_that) {
case _HomeTopicSummary():
return $default(_that.subscription,_that.latestMessage,_that.unreadCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Subscription subscription,  NotificationMessage? latestMessage,  int unreadCount)?  $default,) {final _that = this;
switch (_that) {
case _HomeTopicSummary() when $default != null:
return $default(_that.subscription,_that.latestMessage,_that.unreadCount);case _:
  return null;

}
}

}

/// @nodoc


class _HomeTopicSummary implements HomeTopicSummary {
  const _HomeTopicSummary({required this.subscription, this.latestMessage, required this.unreadCount});
  

@override final  Subscription subscription;
@override final  NotificationMessage? latestMessage;
@override final  int unreadCount;

/// Create a copy of HomeTopicSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeTopicSummaryCopyWith<_HomeTopicSummary> get copyWith => __$HomeTopicSummaryCopyWithImpl<_HomeTopicSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeTopicSummary&&(identical(other.subscription, subscription) || other.subscription == subscription)&&(identical(other.latestMessage, latestMessage) || other.latestMessage == latestMessage)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount));
}


@override
int get hashCode => Object.hash(runtimeType,subscription,latestMessage,unreadCount);

@override
String toString() {
  return 'HomeTopicSummary(subscription: $subscription, latestMessage: $latestMessage, unreadCount: $unreadCount)';
}


}

/// @nodoc
abstract mixin class _$HomeTopicSummaryCopyWith<$Res> implements $HomeTopicSummaryCopyWith<$Res> {
  factory _$HomeTopicSummaryCopyWith(_HomeTopicSummary value, $Res Function(_HomeTopicSummary) _then) = __$HomeTopicSummaryCopyWithImpl;
@override @useResult
$Res call({
 Subscription subscription, NotificationMessage? latestMessage, int unreadCount
});


@override $SubscriptionCopyWith<$Res> get subscription;@override $NotificationMessageCopyWith<$Res>? get latestMessage;

}
/// @nodoc
class __$HomeTopicSummaryCopyWithImpl<$Res>
    implements _$HomeTopicSummaryCopyWith<$Res> {
  __$HomeTopicSummaryCopyWithImpl(this._self, this._then);

  final _HomeTopicSummary _self;
  final $Res Function(_HomeTopicSummary) _then;

/// Create a copy of HomeTopicSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subscription = null,Object? latestMessage = freezed,Object? unreadCount = null,}) {
  return _then(_HomeTopicSummary(
subscription: null == subscription ? _self.subscription : subscription // ignore: cast_nullable_to_non_nullable
as Subscription,latestMessage: freezed == latestMessage ? _self.latestMessage : latestMessage // ignore: cast_nullable_to_non_nullable
as NotificationMessage?,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of HomeTopicSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubscriptionCopyWith<$Res> get subscription {
  
  return $SubscriptionCopyWith<$Res>(_self.subscription, (value) {
    return _then(_self.copyWith(subscription: value));
  });
}/// Create a copy of HomeTopicSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationMessageCopyWith<$Res>? get latestMessage {
    if (_self.latestMessage == null) {
    return null;
  }

  return $NotificationMessageCopyWith<$Res>(_self.latestMessage!, (value) {
    return _then(_self.copyWith(latestMessage: value));
  });
}
}

// dart format on
