// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessageDto _$MessageDtoFromJson(Map<String, dynamic> json) => _MessageDto(
  id: json['id'] as String,
  time: json['time'] as num,
  expires: json['expires'] as num?,
  event: json['event'] as String,
  topic: json['topic'] as String,
  message: json['message'] as String?,
  title: json['title'] as String?,
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
  priority: (json['priority'] as num?)?.toInt(),
  click: json['click'] as String?,
  icon: json['icon'] as String?,
  actions: (json['actions'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList(),
  attachment: json['attachment'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$MessageDtoToJson(_MessageDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'time': instance.time,
      'expires': instance.expires,
      'event': instance.event,
      'topic': instance.topic,
      'message': instance.message,
      'title': instance.title,
      'tags': instance.tags,
      'priority': instance.priority,
      'click': instance.click,
      'icon': instance.icon,
      'actions': instance.actions,
      'attachment': instance.attachment,
    };
