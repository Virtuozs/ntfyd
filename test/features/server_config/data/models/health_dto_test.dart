import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/features/server_config/data/models/health_dto.dart';

void main() {
  group('HealthDto', () {
    test('fromJson parses {"healthy": true} correctly', () {
      final json = {'healthy': true};

      final dto = HealthDto.fromJson(json);

      expect(dto.healthy, isTrue);
    });

    test('fromJson parses {"healthy": false} correctly', () {
      final json = {'healthy': false};

      final dto = HealthDto.fromJson(json);

      expect(dto.healthy, isFalse);
    });

    test('toJson serializes correctly', () {
      const dto = HealthDto(healthy: true);

      final json = dto.toJson();

      expect(json, {'healthy': true});
    });

    test('fromJson -> toJson round-trips correctly', () {
      final original = {'healthy': true};

      final dto = HealthDto.fromJson(original);
      final result = dto.toJson();

      expect(result, original);
    });

    test('two HealthDto instances with the same healthy value are equal', () {
      const a = HealthDto(healthy: true);
      const b = HealthDto(healthy: true);

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('copyWith produces a new instance with the field changed', () {
      const original = HealthDto(healthy: true);

      final updated = original.copyWith(healthy: false);

      expect(updated.healthy, isFalse);
      expect(original.healthy, isTrue);
    });
  });
}
