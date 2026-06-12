/// Minimal stub Full implementation will use @freezed + json_serializable
class HealthDto {
  const HealthDto({required this.healthy});

  final bool healthy;

  @override
  bool operator ==(Object other) =>
      other is HealthDto && other.healthy == healthy;

  @override
  int get hashCode => healthy.hashCode;
}
