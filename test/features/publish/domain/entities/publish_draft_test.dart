import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/publish/domain/entities/publish_draft.dart';

void main() {
  group('PublishDraft.validate', () {
    test('returns ValidationFailure when topic is empty', () {
      final result = PublishDraft.validate(topic: '', body: 'hello');

      expect(result.isSuccess, isFalse);
      expect((result.failureOrThrow as ValidationFailure).field, 'topic');
    });

    test(
      'returns ValidationFailure when body is empty and no attachment is set',
      () {
        final result = PublishDraft.validate(topic: 'alerts', body: '');

        expect(result.isSuccess, isFalse);
        expect((result.failureOrThrow as ValidationFailure).field, 'body');
      },
    );

    test('allows an empty body when an attachment is set', () {
      final result = PublishDraft.validate(
        topic: 'alerts',
        body: '',
        attachmentPath: '/tmp/log.txt',
      );

      expect(result.isSuccess, isTrue);
    });

    test('returns ValidationFailure when priority is out of range', () {
      final result = PublishDraft.validate(
        topic: 'alerts',
        body: 'hello',
        priority: 6,
      );

      expect(result.isSuccess, isFalse);
      expect((result.failureOrThrow as ValidationFailure).field, 'priority');
    });

    test('defaults priority to 3, tags to empty, markdown to false', () {
      final result = PublishDraft.validate(topic: 'alerts', body: 'hello');

      final draft = result.valueOrThrow;
      expect(draft.priority, 3);
      expect(draft.tags, isEmpty);
      expect(draft.markdown, isFalse);
      expect(draft.title, isNull);
      expect(draft.attachmentPath, isNull);
      expect(draft.delay, isNull);
    });

    test('two identical drafts are equal (Freezed equality)', () {
      final a = PublishDraft.validate(
        topic: 'alerts',
        body: 'hello',
      ).valueOrThrow;
      final b = PublishDraft.validate(
        topic: 'alerts',
        body: 'hello',
      ).valueOrThrow;

      expect(a, equals(b));
    });
  });
}
