import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_dto.freezed.dart';
part 'health_dto.g.dart';

@freezed
abstract class HealthDto with _$HealthDto {
  const factory HealthDto({required bool healthy}) = _HealthDto;

  factory HealthDto.fromJson(Map<String, dynamic> json) =>
      _$HealthDtoFromJson(json);
}
