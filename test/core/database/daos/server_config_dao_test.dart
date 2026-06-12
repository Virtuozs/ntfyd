import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ntfyd/core/database/app_database.dart';

AppDatabase _openDb() => AppDatabase(
  NativeDatabase.memory(setup: (db) => db.execute('PRAGMA foreign_keys = ON;')),
);

int _now() => DateTime.now().millisecondsSinceEpoch ~/ 1000;

ServerConfigsCompanion _server(String id, {bool isDefault = false}) =>
    ServerConfigsCompanion.insert(
      id: id,
      baseUrl: 'https://$id.example.com',
      displayName: id,
      authType: 'none',
      isDefault: Value(isDefault ? 1 : 0),
      createdAt: _now(),
    );

void main() {
  late AppDatabase db;

  setUp(() {
    db = _openDb();
  });

  tearDown(() async {
    await db.close();
  });

  group('watchAll', () {
    test('emits all server configs', () async {
      await db.serverConfigDao.upsert(_server('srv-1'));
      await db.serverConfigDao.upsert(_server('srv-2'));

      final result = await db.serverConfigDao.watchAll().first;

      expect(result.length, equals(2));
      expect(result.map((e) => e.id), containsAll(['srv-1', 'srv-2']));
    });

    test('emits updated list when a new server is inserted', () async {
      final stream = db.serverConfigDao.watchAll();
      final emissions = <int>[];
      final sub = stream.listen((rows) => emissions.add(rows.length));

      await Future<void>.delayed(Duration.zero);
      await db.serverConfigDao.upsert(_server('srv-1'));
      await Future<void>.delayed(Duration.zero);
      await db.serverConfigDao.upsert(_server('srv-2'));
      await Future<void>.delayed(Duration.zero);
      await db.serverConfigDao.upsert(_server('srv-3'));
      await Future<void>.delayed(Duration.zero);

      expect(emissions, containsAllInOrder([0, 1, 2, 3]));
      await sub.cancel();
    });
  });

  group('findById', () {
    test('returns the matching row', () async {
      await db.serverConfigDao.upsert(_server('srv-1'));

      final result = await db.serverConfigDao.findById('srv-1');

      expect(result, isNot(equals(null)));
      expect(result!.id, equals('srv-1'));
    });

    test('returns null when id does not exist', () async {
      final result = await db.serverConfigDao.findById('ghost');

      expect(result, equals(null));
    });
  });

  group('upsert', () {
    test('inserts a new row', () async {
      await db.serverConfigDao.upsert(_server('srv-1'));

      final result = await db.serverConfigDao.findById('srv-1');
      expect(result, isNot(equals(null)));
    });

    test('updates an existing row with same id', () async {
      await db.serverConfigDao.upsert(_server('srv-1'));

      await db.serverConfigDao.upsert(
        ServerConfigsCompanion.insert(
          id: 'srv-1',
          baseUrl: 'https://srv-1.example.com',
          displayName: 'Updated Name',
          authType: 'none',
          createdAt: _now(),
        ),
      );

      final result = await db.serverConfigDao.findById('srv-1');
      expect(result!.displayName, equals('Updated Name'));

      final all = await db.serverConfigDao.watchAll().first;
      expect(all.length, equals(1));
    });
  });

  group('deleteById', () {
    test('removes the row', () async {
      await db.serverConfigDao.upsert(_server('srv-1'));

      await db.serverConfigDao.deleteById('srv-1');

      final result = await db.serverConfigDao.findById('srv-1');
      expect(result, equals(null));
    });
  });

  group('setDefault', () {
    test('clears isDefault on all other rows first', () async {
      await db.serverConfigDao.upsert(_server('srv-1', isDefault: true));
      await db.serverConfigDao.upsert(_server('srv-2'));
      await db.serverConfigDao.upsert(_server('srv-3'));

      await db.serverConfigDao.setDefault('srv-3');

      final all = await db.serverConfigDao.watchAll().first;
      final defaults = all.where((r) => r.isDefault == 1).toList();
      expect(defaults.length, equals(1));
      expect(defaults.first.id, equals('srv-3'));
    });

    test('sets isDefault=1 on the target row', () async {
      await db.serverConfigDao.upsert(_server('srv-1'));

      await db.serverConfigDao.setDefault('srv-1');

      final result = await db.serverConfigDao.findById('srv-1');
      expect(result!.isDefault, equals(1));
    });
  });
}
