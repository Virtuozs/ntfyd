
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ntfyd/core/network/ntfy_interceptor.dart';
import 'package:ntfyd/core/secure_storage/server_credential.dart';

class NtfyHttpClient {
  NtfyHttpClient({
    required String baseUrl,
    ServerCredential credential = const ServerCredential.noAuth(),
    Dio? dio,
    void Function(String)? onLog,
  }) {
    _dio = dio ?? Dio();

    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      validateStatus:  (status) => status != null && status < 400
    );

    _dio.interceptors.add(NtfyInterceptor(onLog: onLog));

    final authHeader = _buildAuthHeader(credential);
    if(authHeader != null) {
      _dio.options.headers['Authorization'] = authHeader;
    }
  }

  late final Dio _dio;

  Future<Response<T>> get<T> (
    String path, {
      Map<String, dynamic>? queryParameters,
      Options? options,
  }) =>
    _dio.get(
      path,
      queryParameters: queryParameters,
      options: options 
    );
  

  Future<Response<T>> post<T> (
    String path, {
      dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options
  })  => 
    _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options
    );

  Future<Response<T>> put<T> (
    String path, {
      dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options
  }) => 
    _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options
    );

  Future<Response<T>> delete<T> (
    String path, {
      dynamic data,
      Options? options
  }) => 
    _dio.delete(
      path,
      data: data,
      options: options
    );
  
  Future<Response<T>> patch<T> (
    String path, {
      dynamic data,
      Options? options
  }) => 
    _dio.patch(
      path,
      data: data,
      options: options
    );
  
  String? _buildAuthHeader(ServerCredential credential) {
    return credential.when(
      noAuth:() => null,
      basicAuth: (username, password) {
        final encoded = base64Encode(utf8.encode('$username:$password'));
        return 'Basic $encoded';
      } , 
      bearerToken: (token) => 'Bearer $token');
  }
}