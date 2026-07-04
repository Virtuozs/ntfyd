import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ntfyd/core/error/failures.dart';
import 'package:ntfyd/core/usecase/result.dart';
import 'package:ntfyd/features/server_config/data/datasources/health_data_source.dart';
import 'package:ntfyd/features/server_config/data/models/health_dto.dart';
import 'package:ntfyd/features/server_config/domain/usecases/validate_server_health.dart';

class MockHealthDataSource extends Mock implements HealthDataSource {}

void main() {
  late MockHealthDataSource mockDataSource;
  late ValidateServerHealth useCase;

  setUp(() {
    mockDataSource = MockHealthDataSource();
    useCase = ValidateServerHealth(mockDataSource);

    registerFallbackValue(const HealthDto(healthy: true));
  });

  const baseUrl = 'https://ntfy.sh';

  group('ValidateServerHealth', () {
    test(
      'returns Success(HealthDto) when datasource returns healthy:true',
      () async {
        when(
          () => mockDataSource.checkHealth(baseUrl),
        ).thenAnswer((_) async => const HealthDto(healthy: true));

        final result = await useCase.call(baseUrl);

        expect(result.isSuccess, isTrue);
        expect(result.valueOrThrow, const HealthDto(healthy: true));
        verify(() => mockDataSource.checkHealth(baseUrl)).called(1);
      },
    );

    test('returns NetworkFailure when datasource throws connection-refused '
        'DioException', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/v1/health'),
        type: DioExceptionType.connectionError,
        error: 'Connection refused',
      );
      when(() => mockDataSource.checkHealth(baseUrl)).thenThrow(dioException);

      final result = await useCase.call(baseUrl);

      expect(result.isSuccess, isFalse);
      expect(result.failureOrThrow, isA<NetworkFailure>());
    });

    test('returns ServerFailure when datasource throws DioException with '
        '500 response', () async {
      final requestOptions = RequestOptions(path: '/v1/health');
      final dioException = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 500,
          data: {'code': 50000, 'http': 500, 'error': 'internal error'},
        ),
      );
      when(() => mockDataSource.checkHealth(baseUrl)).thenThrow(dioException);

      final result = await useCase.call(baseUrl);

      expect(result.isSuccess, isFalse);
      final failure = result.failureOrThrow;
      expect(failure, isA<ServerFailure>());
      expect((failure as ServerFailure).statusCode, 500);
    });

    test('returns AuthFailure when datasource throws DioException with '
        '401 response', () async {
      final requestOptions = RequestOptions(path: '/v1/health');
      final dioException = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 401,
          data: {'code': 40101, 'http': 401, 'error': 'unauthorized'},
        ),
      );
      when(() => mockDataSource.checkHealth(baseUrl)).thenThrow(dioException);

      final result = await useCase.call(baseUrl);

      expect(result.isSuccess, isFalse);
      final failure = result.failureOrThrow;
      expect(failure, isA<AuthFailure>());
      expect((failure as AuthFailure).statusCode, 401);
    });
  });
}
