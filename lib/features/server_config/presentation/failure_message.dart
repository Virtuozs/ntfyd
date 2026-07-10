import 'package:ntfyd/core/error/failures.dart';

String friendlyFailureMessage(Failure failure) {
  return failure.when(
    network: (message, statusCode) =>
        "Couldn't reach the server. Check the URL and your connection.",
    auth: (statusCode) => 'Invalid credentials for this server.',
    notFound: () => 'Server not found at this URL.',
    rateLimit: (retryAfter) => 'Too many requests. Please try again later.',
    server: (statusCode, message) =>
        'Server error ($statusCode). Please try again.',
    cache: (message) => 'A local error occurred. Please try again.',
    validation: (field, message) => message,
    biometric: (reason) => reason,
    unknown: (message) => 'Something went wrong. Please try again.',
  );
}
