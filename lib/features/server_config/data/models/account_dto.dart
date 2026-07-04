import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_dto.freezed.dart';
part 'account_dto.g.dart';

/// Response shape for `GET /v1/account`.
///
/// `limits`/`stats` are passed through as raw JSON maps and their schema is sparsely documented (community ref)
@freezed
abstract class AccountDto with _$AccountDto {
  const factory AccountDto({
    required String username,
    required String role,
    @JsonKey(name: 'sync_topic') String? syncTopic,
    Map<String, dynamic>? limits,
    Map<String, dynamic>? stats,
  }) = _AccountDto;

  factory AccountDto.fromJson(Map<String, dynamic> json) =>
      _$AccountDtoFromJson(json);
}
