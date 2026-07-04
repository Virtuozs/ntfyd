import 'package:injectable/injectable.dart';
import 'package:ntfyd/features/server_config/data/datasources/account_data_source.dart';
import 'package:ntfyd/features/server_config/data/datasources/account_data_source_impl.dart';

@module
abstract class ServerConfigModule {
  /// Registers [AccountDataSourceImpl] via a factory method rather than a
  /// class-level `@LazySingleton` annotation: `injectable` cannot resolve
  /// the bare `NtfyAuthHttpClientFactory` (`Function`-typed) constructor
  /// param, even though it's optional. Using the no-arg constructor here
  /// falls back to [AccountDataSourceImpl]'s built-in production factory.
  @LazySingleton(as: AccountDataSource)
  AccountDataSourceImpl accountDataSource() => AccountDataSourceImpl();
}