import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_dto.freezed.dart';
part 'message_dto.g.dart';

/// Raw ntfy wire-format message object — one JSON object per WS text frame
/// or NDJSON line (`GET /{topic}/json`), per api_spec.md §3.3. Represents
/// every event type (`message`, `open`, `keepalive`, `message_delete`,
/// `message_clear`); [FeedMapper.fromDto] is what filters to `message` only.
@freezed
abstract class MessageDto with _$MessageDto {
  const factory MessageDto({
    required String id,
    required num time,
    num? expires,
    required String event,
    required String topic,
    String? message,
    String? title,
    List<String>? tags,
    int? priority,
    String? click,
    String? icon,
    List<Map<String, dynamic>>? actions,
    Map<String, dynamic>? attachment,
  }) = _MessageDto;

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);
}
