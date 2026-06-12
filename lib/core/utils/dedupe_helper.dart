abstract class Deduplicable {
  String get serverId;
  String get id;
  DateTime get receivedAt;
}

List<T> dedupeMessages<T extends Deduplicable>(List<T> rows) {
  final latestByKey = <String, T>{};

  for (final row in rows) {
    final key = '${row.serverId}:${row.id}';
    final existing = latestByKey[key];

    if (existing == null || row.receivedAt.isAfter(existing.receivedAt)) {
      latestByKey[key] = row;
    }
  }

  return latestByKey.values.toList();
}
