import 'package:dio/dio.dart';

class NtfyInterceptor extends Interceptor {
  NtfyInterceptor({void Function(String)? onLog})
    : _log = onLog ?? _defaultLog;

  final void Function(String) _log;

  static void _defaultLog(String message) {
    // make sure to implement with logging package later
    // ignore: avoid_print
    print('[ntfy] $message');
  }
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final hasAuth = options.headers.containsKey('Authorization');
    _log(
      'REQUEST ${options.method} ${options.path} '
      '${hasAuth ? '[auth: present]' : '[auth: none]'}',
    );
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _log(
      'ERROR ${err.response?.statusCode ?? 'no-status'} '
      '${err.requestOptions.path} — ${err.type}',
    );
    handler.next(err);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    _log('RESPONSE ${response.statusCode} ${response.requestOptions.path}');
    handler.next(response);
  }
}