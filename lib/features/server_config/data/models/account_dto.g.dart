// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountDto _$AccountDtoFromJson(Map<String, dynamic> json) => _AccountDto(
  username: json['username'] as String,
  role: json['role'] as String,
  syncTopic: json['sync_topic'] as String?,
  limits: json['limits'] as Map<String, dynamic>?,
  stats: json['stats'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$AccountDtoToJson(_AccountDto instance) =>
    <String, dynamic>{
      'username': instance.username,
      'role': instance.role,
      'sync_topic': instance.syncTopic,
      'limits': instance.limits,
      'stats': instance.stats,
    };
