// lib/di/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'package:ntfyd/di/injection_container.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async => getIt.init();