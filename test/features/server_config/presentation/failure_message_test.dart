import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/features/server_config/presentation/failure_message.dart';

void main() {
  group('friendlyFailureMessage', () {
    test('network -> connection message', () {
      expect(
        friendlyFailureMessage(
          const Failure.network(message: 'connection refused'),
        ),
        "Couldn't reach the server. Check the URL and your connection.",
      );
    });

    test('auth -> invalid credentials message', () {
      expect(
        friendlyFailureMessage(const Failure.auth(statusCode: 401)),
        'Invalid credentials for this server.',
      );
    });

    test('notFound -> server not found message', () {
      expect(
        friendlyFailureMessage(const Failure.notFound()),
        'Server not found at this URL.',
      );
    });

    test('rateLimit -> too many requests message', () {
      expect(
        friendlyFailureMessage(const Failure.rateLimit()),
        'Too many requests. Please try again later.',
      );
    });

    test('server -> server error message with status code', () {
      expect(
        friendlyFailureMessage(
          const Failure.server(statusCode: 500, message: 'boom'),
        ),
        'Server error (500). Please try again.',
      );
    });

    test('cache -> local error message', () {
      expect(
        friendlyFailureMessage(const Failure.cache(message: 'db error')),
        'A local error occurred. Please try again.',
      );
    });

    test('validation -> passes through the failure message', () {
      expect(
        friendlyFailureMessage(
          const Failure.validation(field: 'baseUrl', message: 'bad url'),
        ),
        'bad url',
      );
    });

    test('biometric -> passes through the reason', () {
      expect(
        friendlyFailureMessage(const Failure.biometric(reason: 'locked out')),
        'locked out',
      );
    });

    test('unknown -> generic message', () {
      expect(
        friendlyFailureMessage(const Failure.unknown(message: 'huh')),
        'Something went wrong. Please try again.',
      );
    });
  });
}
