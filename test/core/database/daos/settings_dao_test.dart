import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/core/database/app_database.dart';

AppDatabase _openDb() => AppDatabase(
  NativeDatabase.memory(setup: (db) => db.execute('PRAGMA foreign_keys = ON;')),
);

void main() {
  late AppDatabase db;

  setUp(() {
    db = _openDb();
  });

  tearDown(() async {
    await db.close();
  });

  group('watch', () {
    test('emits default settings row even before explicit insert', () async {
      // Act
      final result = await db.settingDao.watch().first;

      // Assert
      expect(result.id, equals(1));
      expect(result.themeMode, equals('dark'));
      expect(result.retentionMaxRows, equals(10000));
      expect(result.biometricLock, equals(0));
    });

    test('emits updated row after update() call', () async {
      // Arrange
      final stream = db.settingDao.watch();
      final emissions = <String>[];
      final sub = stream.listen((row) => emissions.add(row.themeMode));
      await Future<void>.delayed(Duration.zero);

      await db.settingDao.updateAppSetting(
        const AppSettingsCompanion(themeMode: Value('white')),
      );
      await Future<void>.delayed(Duration.zero);

      expect(emissions, containsAllInOrder(['dark', 'white']));
      await sub.cancel();
    });
  });

  group('update', () {
    test('persists themeMode change', () async {
      await db.settingDao.updateAppSetting(
        const AppSettingsCompanion(themeMode: Value('materialYou')),
      );

      // Assert
      final result = await db.settingDao.watch().first;
      expect(result.themeMode, equals('materialYou'));
    });

    test(
      'persists biometricLock change without affecting other fields',
      () async {
        await db.settingDao.updateAppSetting(
          const AppSettingsCompanion(themeMode: Value('white')),
        );

        await db.settingDao.updateAppSetting(
          const AppSettingsCompanion(biometricLock: Value(1)),
        );

        final result = await db.settingDao.watch().first;
        expect(result.biometricLock, equals(1));
        expect(result.themeMode, equals('white')); // unchanged
      },
    );

    test('does not create a second row', () async {
      await db.settingDao.updateAppSetting(
        const AppSettingsCompanion(themeMode: Value('white')),
      );
      await db.settingDao.updateAppSetting(
        const AppSettingsCompanion(quietHoursEnabled: Value(1)),
      );

      final all = await db.select(db.appSettings).get();
      expect(all.length, equals(1));
    });
  });
}
