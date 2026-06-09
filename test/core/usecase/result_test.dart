import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';

void main() {
  group('Result — construction and field access', () {
    test('Success holds the correct value', () {
      // ARRANGE + ACT
      const result = Result<String>.success('hello');

      // ASSERT
      expect((result as Success<String>).value, 'hello');
    });

    test('Err holds the correct Failure', () {
      const failure = Failure.network(message: 'no connection');
      const result = Result<String>.err(failure);

      expect((result as Err<String>).failure, failure);
    });
  });

  group('Result — Freezed equality', () {
    test('two Success with the same value are equal', () {
      const a = Result<String>.success('hello');
      const b = Result<String>.success('hello');
      expect(a, equals(b));
    });

    test('two Success with different values are NOT equal', () {
      const a = Result<String>.success('hello');
      const b = Result<String>.success('world');
      expect(a, isNot(equals(b)));
    });

    test('two Err with the same Failure are equal', () {
      const failure = Failure.network(message: 'err');
      const a = Result<String>.err(failure);
      const b = Result<String>.err(failure);
      expect(a, equals(b));
    });

    test('Success and Err are never equal even if somehow constructed alike', () {
      const a = Result<String>.success('hello');
      const b = Result<String>.err(Failure.unknown(message: 'hello'));
      expect(a, isNot(equals(b)));
    });
  });

  group('Result — when() pattern matching', () {
    test('when() routes Success to the success branch', () {
      const Result<int> result = Result.success(42);

      final output = result.when(
        success: (value) => 'got $value',
        err: (failure) => 'got failure',
      );

      expect(output, 'got 42');
    });

    test('when() routes Err to the err branch', () {
      const Result<int> result = Result.err(
        Failure.auth(statusCode: 401),
      );

      final output = result.when(
        success: (value) => 'got $value',
        err: (failure) => 'got failure',
      );

      expect(output, 'got failure');
    });
  });

  group('Result — extension methods', () {
    test('isSuccess returns true for Success', () {
      const result = Result<String>.success('ok');
      expect(result.isSuccess, isTrue);
    });

    test('isSuccess returns false for Err', () {
      const result = Result<String>.err(Failure.notFound());
      expect(result.isSuccess, isFalse);
    });

    test('valueOrThrow returns the value on Success', () {
      const result = Result<String>.success('ok');
      expect(result.valueOrThrow, 'ok');
    });

    test('valueOrThrow throws StateError on Err', () {
      const result = Result<String>.err(Failure.notFound());
      
      expect(() => result.valueOrThrow, throwsStateError);
    });

    test('failureOrThrow returns the Failure on Err', () {
      const failure = Failure.auth(statusCode: 401);
      const result = Result<String>.err(failure);
      expect(result.failureOrThrow, failure);
    });

    test('failureOrThrow throws StateError on Success', () {
      const result = Result<String>.success('ok');
      expect(() => result.failureOrThrow, throwsStateError);
    });
  });
}