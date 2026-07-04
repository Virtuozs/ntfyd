import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/core/utils/priority_utils.dart';

void main() {
  group('toInt / fromInt', () {
    test('Priority.fromInt(4) == Priority.high', () {
      expect(PriorityParsing.fromInt(4), equals(Priority.high));
    });

    test('toInt round-trips for all variants', () {
      expect(Priority.min.toInt(), equals(1));
      expect(Priority.low.toInt(), equals(2));
      expect(Priority.defaultPriority.toInt(), equals(3));
      expect(Priority.high.toInt(), equals(4));
      expect(Priority.max.toInt(), equals(5));
    });

    test('fromInt round-trips for all values 1-5', () {
      for (var i = 1; i <= 5; i++) {
        expect(PriorityParsing.fromInt(i).toInt(), equals(i));
      }
    });

    test('fromInt throws for out-of-range values', () {
      expect(() => PriorityParsing.fromInt(0), throwsArgumentError);
      expect(() => PriorityParsing.fromInt(6), throwsArgumentError);
    });
  });

  group('toName / fromString', () {
    test("Priority.fromString('max') == Priority.max", () {
      expect(PriorityParsing.fromString('max'), equals(Priority.max));
    });

    test("Priority.fromString('urgent') == Priority.max (alias)", () {
      expect(PriorityParsing.fromString('urgent'), equals(Priority.max));
    });

    test('toName returns canonical ntfy names', () {
      expect(Priority.min.toName(), equals('min'));
      expect(Priority.low.toName(), equals('low'));
      expect(Priority.defaultPriority.toName(), equals('default'));
      expect(Priority.high.toName(), equals('high'));
      expect(Priority.max.toName(), equals('max'));
    });

    test('fromString round-trips toName for all variants', () {
      for (final p in Priority.values) {
        expect(PriorityParsing.fromString(p.toName()), equals(p));
      }
    });

    test('fromString throws for unknown names', () {
      expect(
        () => PriorityParsing.fromString('not-a-priority'),
        throwsArgumentError,
      );
    });
  });

  group('channelId', () {
    test('returns ntfyd_priority_<n> for each priority', () {
      expect(Priority.min.channelId(), equals('ntfyd_priority_1'));
      expect(Priority.low.channelId(), equals('ntfyd_priority_2'));
      expect(Priority.defaultPriority.channelId(), equals('ntfyd_priority_3'));
      expect(Priority.high.channelId(), equals('ntfyd_priority_4'));
      expect(Priority.max.channelId(), equals('ntfyd_priority_5'));
    });
  });

  group('colorTier (D16)', () {
    test('priority 5 and 4 -> red', () {
      expect(Priority.max.colorTier, equals(PriorityColorTier.red));
      expect(Priority.high.colorTier, equals(PriorityColorTier.red));
    });

    test('priority 3 -> blue', () {
      expect(
        Priority.defaultPriority.colorTier,
        equals(PriorityColorTier.blue),
      );
    });

    test('priority 1 and 2 -> grey', () {
      expect(Priority.min.colorTier, equals(PriorityColorTier.grey));
      expect(Priority.low.colorTier, equals(PriorityColorTier.grey));
    });
  });
}
