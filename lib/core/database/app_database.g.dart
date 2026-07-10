// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ServerConfigsTable extends ServerConfigs
    with TableInfo<$ServerConfigsTable, ServerConfig> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServerConfigsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseUrlMeta = const VerificationMeta(
    'baseUrl',
  );
  @override
  late final GeneratedColumn<String> baseUrl = GeneratedColumn<String>(
    'base_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authTypeMeta = const VerificationMeta(
    'authType',
  );
  @override
  late final GeneratedColumn<String> authType = GeneratedColumn<String>(
    'auth_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _credentialRefMeta = const VerificationMeta(
    'credentialRef',
  );
  @override
  late final GeneratedColumn<String> credentialRef = GeneratedColumn<String>(
    'credential_ref',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<int> isDefault = GeneratedColumn<int>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    baseUrl,
    displayName,
    authType,
    credentialRef,
    isDefault,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'server_configs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ServerConfig> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('base_url')) {
      context.handle(
        _baseUrlMeta,
        baseUrl.isAcceptableOrUnknown(data['base_url']!, _baseUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_baseUrlMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('auth_type')) {
      context.handle(
        _authTypeMeta,
        authType.isAcceptableOrUnknown(data['auth_type']!, _authTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_authTypeMeta);
    }
    if (data.containsKey('credential_ref')) {
      context.handle(
        _credentialRefMeta,
        credentialRef.isAcceptableOrUnknown(
          data['credential_ref']!,
          _credentialRefMeta,
        ),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServerConfig map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServerConfig(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      baseUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_url'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      authType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}auth_type'],
      )!,
      credentialRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}credential_ref'],
      ),
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_default'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ServerConfigsTable createAlias(String alias) {
    return $ServerConfigsTable(attachedDatabase, alias);
  }
}

class ServerConfig extends DataClass implements Insertable<ServerConfig> {
  final String id;
  final String baseUrl;
  final String displayName;
  final String authType;
  final String? credentialRef;
  final int isDefault;
  final int createdAt;
  const ServerConfig({
    required this.id,
    required this.baseUrl,
    required this.displayName,
    required this.authType,
    this.credentialRef,
    required this.isDefault,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['base_url'] = Variable<String>(baseUrl);
    map['display_name'] = Variable<String>(displayName);
    map['auth_type'] = Variable<String>(authType);
    if (!nullToAbsent || credentialRef != null) {
      map['credential_ref'] = Variable<String>(credentialRef);
    }
    map['is_default'] = Variable<int>(isDefault);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  ServerConfigsCompanion toCompanion(bool nullToAbsent) {
    return ServerConfigsCompanion(
      id: Value(id),
      baseUrl: Value(baseUrl),
      displayName: Value(displayName),
      authType: Value(authType),
      credentialRef: credentialRef == null && nullToAbsent
          ? const Value.absent()
          : Value(credentialRef),
      isDefault: Value(isDefault),
      createdAt: Value(createdAt),
    );
  }

  factory ServerConfig.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServerConfig(
      id: serializer.fromJson<String>(json['id']),
      baseUrl: serializer.fromJson<String>(json['baseUrl']),
      displayName: serializer.fromJson<String>(json['displayName']),
      authType: serializer.fromJson<String>(json['authType']),
      credentialRef: serializer.fromJson<String?>(json['credentialRef']),
      isDefault: serializer.fromJson<int>(json['isDefault']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'baseUrl': serializer.toJson<String>(baseUrl),
      'displayName': serializer.toJson<String>(displayName),
      'authType': serializer.toJson<String>(authType),
      'credentialRef': serializer.toJson<String?>(credentialRef),
      'isDefault': serializer.toJson<int>(isDefault),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  ServerConfig copyWith({
    String? id,
    String? baseUrl,
    String? displayName,
    String? authType,
    Value<String?> credentialRef = const Value.absent(),
    int? isDefault,
    int? createdAt,
  }) => ServerConfig(
    id: id ?? this.id,
    baseUrl: baseUrl ?? this.baseUrl,
    displayName: displayName ?? this.displayName,
    authType: authType ?? this.authType,
    credentialRef: credentialRef.present
        ? credentialRef.value
        : this.credentialRef,
    isDefault: isDefault ?? this.isDefault,
    createdAt: createdAt ?? this.createdAt,
  );
  ServerConfig copyWithCompanion(ServerConfigsCompanion data) {
    return ServerConfig(
      id: data.id.present ? data.id.value : this.id,
      baseUrl: data.baseUrl.present ? data.baseUrl.value : this.baseUrl,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      authType: data.authType.present ? data.authType.value : this.authType,
      credentialRef: data.credentialRef.present
          ? data.credentialRef.value
          : this.credentialRef,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServerConfig(')
          ..write('id: $id, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('displayName: $displayName, ')
          ..write('authType: $authType, ')
          ..write('credentialRef: $credentialRef, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    baseUrl,
    displayName,
    authType,
    credentialRef,
    isDefault,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServerConfig &&
          other.id == this.id &&
          other.baseUrl == this.baseUrl &&
          other.displayName == this.displayName &&
          other.authType == this.authType &&
          other.credentialRef == this.credentialRef &&
          other.isDefault == this.isDefault &&
          other.createdAt == this.createdAt);
}

class ServerConfigsCompanion extends UpdateCompanion<ServerConfig> {
  final Value<String> id;
  final Value<String> baseUrl;
  final Value<String> displayName;
  final Value<String> authType;
  final Value<String?> credentialRef;
  final Value<int> isDefault;
  final Value<int> createdAt;
  final Value<int> rowid;
  const ServerConfigsCompanion({
    this.id = const Value.absent(),
    this.baseUrl = const Value.absent(),
    this.displayName = const Value.absent(),
    this.authType = const Value.absent(),
    this.credentialRef = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ServerConfigsCompanion.insert({
    required String id,
    required String baseUrl,
    required String displayName,
    required String authType,
    this.credentialRef = const Value.absent(),
    this.isDefault = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       baseUrl = Value(baseUrl),
       displayName = Value(displayName),
       authType = Value(authType),
       createdAt = Value(createdAt);
  static Insertable<ServerConfig> custom({
    Expression<String>? id,
    Expression<String>? baseUrl,
    Expression<String>? displayName,
    Expression<String>? authType,
    Expression<String>? credentialRef,
    Expression<int>? isDefault,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (baseUrl != null) 'base_url': baseUrl,
      if (displayName != null) 'display_name': displayName,
      if (authType != null) 'auth_type': authType,
      if (credentialRef != null) 'credential_ref': credentialRef,
      if (isDefault != null) 'is_default': isDefault,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ServerConfigsCompanion copyWith({
    Value<String>? id,
    Value<String>? baseUrl,
    Value<String>? displayName,
    Value<String>? authType,
    Value<String?>? credentialRef,
    Value<int>? isDefault,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return ServerConfigsCompanion(
      id: id ?? this.id,
      baseUrl: baseUrl ?? this.baseUrl,
      displayName: displayName ?? this.displayName,
      authType: authType ?? this.authType,
      credentialRef: credentialRef ?? this.credentialRef,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (baseUrl.present) {
      map['base_url'] = Variable<String>(baseUrl.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (authType.present) {
      map['auth_type'] = Variable<String>(authType.value);
    }
    if (credentialRef.present) {
      map['credential_ref'] = Variable<String>(credentialRef.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<int>(isDefault.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServerConfigsCompanion(')
          ..write('id: $id, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('displayName: $displayName, ')
          ..write('authType: $authType, ')
          ..write('credentialRef: $credentialRef, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubscriptionsTable extends Subscriptions
    with TableInfo<$SubscriptionsTable, Subscription> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubscriptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES server_configs (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _topicMeta = const VerificationMeta('topic');
  @override
  late final GeneratedColumn<String> topic = GeneratedColumn<String>(
    'topic',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priorityThresholdMeta = const VerificationMeta(
    'priorityThreshold',
  );
  @override
  late final GeneratedColumn<int> priorityThreshold = GeneratedColumn<int>(
    'priority_threshold',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _mutedMeta = const VerificationMeta('muted');
  @override
  late final GeneratedColumn<int> muted = GeneratedColumn<int>(
    'muted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _pinnedMeta = const VerificationMeta('pinned');
  @override
  late final GeneratedColumn<int> pinned = GeneratedColumn<int>(
    'pinned',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    topic,
    displayName,
    priorityThreshold,
    muted,
    pinned,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subscriptions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Subscription> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('topic')) {
      context.handle(
        _topicMeta,
        topic.isAcceptableOrUnknown(data['topic']!, _topicMeta),
      );
    } else if (isInserting) {
      context.missing(_topicMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('priority_threshold')) {
      context.handle(
        _priorityThresholdMeta,
        priorityThreshold.isAcceptableOrUnknown(
          data['priority_threshold']!,
          _priorityThresholdMeta,
        ),
      );
    }
    if (data.containsKey('muted')) {
      context.handle(
        _mutedMeta,
        muted.isAcceptableOrUnknown(data['muted']!, _mutedMeta),
      );
    }
    if (data.containsKey('pinned')) {
      context.handle(
        _pinnedMeta,
        pinned.isAcceptableOrUnknown(data['pinned']!, _pinnedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {serverId, topic},
  ];
  @override
  Subscription map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subscription(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      )!,
      topic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      priorityThreshold: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority_threshold'],
      )!,
      muted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}muted'],
      )!,
      pinned: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pinned'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SubscriptionsTable createAlias(String alias) {
    return $SubscriptionsTable(attachedDatabase, alias);
  }
}

class Subscription extends DataClass implements Insertable<Subscription> {
  final String id;
  final String serverId;
  final String topic;
  final String displayName;
  final int priorityThreshold;
  final int muted;
  final int pinned;
  final int createdAt;
  const Subscription({
    required this.id,
    required this.serverId,
    required this.topic,
    required this.displayName,
    required this.priorityThreshold,
    required this.muted,
    required this.pinned,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['server_id'] = Variable<String>(serverId);
    map['topic'] = Variable<String>(topic);
    map['display_name'] = Variable<String>(displayName);
    map['priority_threshold'] = Variable<int>(priorityThreshold);
    map['muted'] = Variable<int>(muted);
    map['pinned'] = Variable<int>(pinned);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  SubscriptionsCompanion toCompanion(bool nullToAbsent) {
    return SubscriptionsCompanion(
      id: Value(id),
      serverId: Value(serverId),
      topic: Value(topic),
      displayName: Value(displayName),
      priorityThreshold: Value(priorityThreshold),
      muted: Value(muted),
      pinned: Value(pinned),
      createdAt: Value(createdAt),
    );
  }

  factory Subscription.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subscription(
      id: serializer.fromJson<String>(json['id']),
      serverId: serializer.fromJson<String>(json['serverId']),
      topic: serializer.fromJson<String>(json['topic']),
      displayName: serializer.fromJson<String>(json['displayName']),
      priorityThreshold: serializer.fromJson<int>(json['priorityThreshold']),
      muted: serializer.fromJson<int>(json['muted']),
      pinned: serializer.fromJson<int>(json['pinned']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serverId': serializer.toJson<String>(serverId),
      'topic': serializer.toJson<String>(topic),
      'displayName': serializer.toJson<String>(displayName),
      'priorityThreshold': serializer.toJson<int>(priorityThreshold),
      'muted': serializer.toJson<int>(muted),
      'pinned': serializer.toJson<int>(pinned),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  Subscription copyWith({
    String? id,
    String? serverId,
    String? topic,
    String? displayName,
    int? priorityThreshold,
    int? muted,
    int? pinned,
    int? createdAt,
  }) => Subscription(
    id: id ?? this.id,
    serverId: serverId ?? this.serverId,
    topic: topic ?? this.topic,
    displayName: displayName ?? this.displayName,
    priorityThreshold: priorityThreshold ?? this.priorityThreshold,
    muted: muted ?? this.muted,
    pinned: pinned ?? this.pinned,
    createdAt: createdAt ?? this.createdAt,
  );
  Subscription copyWithCompanion(SubscriptionsCompanion data) {
    return Subscription(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      topic: data.topic.present ? data.topic.value : this.topic,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      priorityThreshold: data.priorityThreshold.present
          ? data.priorityThreshold.value
          : this.priorityThreshold,
      muted: data.muted.present ? data.muted.value : this.muted,
      pinned: data.pinned.present ? data.pinned.value : this.pinned,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Subscription(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('topic: $topic, ')
          ..write('displayName: $displayName, ')
          ..write('priorityThreshold: $priorityThreshold, ')
          ..write('muted: $muted, ')
          ..write('pinned: $pinned, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverId,
    topic,
    displayName,
    priorityThreshold,
    muted,
    pinned,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subscription &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.topic == this.topic &&
          other.displayName == this.displayName &&
          other.priorityThreshold == this.priorityThreshold &&
          other.muted == this.muted &&
          other.pinned == this.pinned &&
          other.createdAt == this.createdAt);
}

class SubscriptionsCompanion extends UpdateCompanion<Subscription> {
  final Value<String> id;
  final Value<String> serverId;
  final Value<String> topic;
  final Value<String> displayName;
  final Value<int> priorityThreshold;
  final Value<int> muted;
  final Value<int> pinned;
  final Value<int> createdAt;
  final Value<int> rowid;
  const SubscriptionsCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.topic = const Value.absent(),
    this.displayName = const Value.absent(),
    this.priorityThreshold = const Value.absent(),
    this.muted = const Value.absent(),
    this.pinned = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubscriptionsCompanion.insert({
    required String id,
    required String serverId,
    required String topic,
    required String displayName,
    this.priorityThreshold = const Value.absent(),
    this.muted = const Value.absent(),
    this.pinned = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       serverId = Value(serverId),
       topic = Value(topic),
       displayName = Value(displayName),
       createdAt = Value(createdAt);
  static Insertable<Subscription> custom({
    Expression<String>? id,
    Expression<String>? serverId,
    Expression<String>? topic,
    Expression<String>? displayName,
    Expression<int>? priorityThreshold,
    Expression<int>? muted,
    Expression<int>? pinned,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (topic != null) 'topic': topic,
      if (displayName != null) 'display_name': displayName,
      if (priorityThreshold != null) 'priority_threshold': priorityThreshold,
      if (muted != null) 'muted': muted,
      if (pinned != null) 'pinned': pinned,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubscriptionsCompanion copyWith({
    Value<String>? id,
    Value<String>? serverId,
    Value<String>? topic,
    Value<String>? displayName,
    Value<int>? priorityThreshold,
    Value<int>? muted,
    Value<int>? pinned,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return SubscriptionsCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      topic: topic ?? this.topic,
      displayName: displayName ?? this.displayName,
      priorityThreshold: priorityThreshold ?? this.priorityThreshold,
      muted: muted ?? this.muted,
      pinned: pinned ?? this.pinned,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (topic.present) {
      map['topic'] = Variable<String>(topic.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (priorityThreshold.present) {
      map['priority_threshold'] = Variable<int>(priorityThreshold.value);
    }
    if (muted.present) {
      map['muted'] = Variable<int>(muted.value);
    }
    if (pinned.present) {
      map['pinned'] = Variable<int>(pinned.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionsCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('topic: $topic, ')
          ..write('displayName: $displayName, ')
          ..write('priorityThreshold: $priorityThreshold, ')
          ..write('muted: $muted, ')
          ..write('pinned: $pinned, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotificationMessagesTable extends NotificationMessages
    with TableInfo<$NotificationMessagesTable, NotificationMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topicMeta = const VerificationMeta('topic');
  @override
  late final GeneratedColumn<String> topic = GeneratedColumn<String>(
    'topic',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<int> time = GeneratedColumn<int>(
    'time',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiresMeta = const VerificationMeta(
    'expires',
  );
  @override
  late final GeneratedColumn<int> expires = GeneratedColumn<int>(
    'expires',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _eventMeta = const VerificationMeta('event');
  @override
  late final GeneratedColumn<String> event = GeneratedColumn<String>(
    'event',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clickMeta = const VerificationMeta('click');
  @override
  late final GeneratedColumn<String> click = GeneratedColumn<String>(
    'click',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _attachmentMeta = const VerificationMeta(
    'attachment',
  );
  @override
  late final GeneratedColumn<String> attachment = GeneratedColumn<String>(
    'attachment',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actionsMeta = const VerificationMeta(
    'actions',
  );
  @override
  late final GeneratedColumn<String> actions = GeneratedColumn<String>(
    'actions',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isMarkdownMeta = const VerificationMeta(
    'isMarkdown',
  );
  @override
  late final GeneratedColumn<int> isMarkdown = GeneratedColumn<int>(
    'is_markdown',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<int> isRead = GeneratedColumn<int>(
    'is_read',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isPinnedMeta = const VerificationMeta(
    'isPinned',
  );
  @override
  late final GeneratedColumn<int> isPinned = GeneratedColumn<int>(
    'is_pinned',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _receivedAtMeta = const VerificationMeta(
    'receivedAt',
  );
  @override
  late final GeneratedColumn<int> receivedAt = GeneratedColumn<int>(
    'received_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    topic,
    time,
    expires,
    event,
    title,
    body,
    priority,
    tags,
    click,
    icon,
    attachment,
    actions,
    isMarkdown,
    isRead,
    isPinned,
    receivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationMessage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('topic')) {
      context.handle(
        _topicMeta,
        topic.isAcceptableOrUnknown(data['topic']!, _topicMeta),
      );
    } else if (isInserting) {
      context.missing(_topicMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('expires')) {
      context.handle(
        _expiresMeta,
        expires.isAcceptableOrUnknown(data['expires']!, _expiresMeta),
      );
    }
    if (data.containsKey('event')) {
      context.handle(
        _eventMeta,
        event.isAcceptableOrUnknown(data['event']!, _eventMeta),
      );
    } else if (isInserting) {
      context.missing(_eventMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('click')) {
      context.handle(
        _clickMeta,
        click.isAcceptableOrUnknown(data['click']!, _clickMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('attachment')) {
      context.handle(
        _attachmentMeta,
        attachment.isAcceptableOrUnknown(data['attachment']!, _attachmentMeta),
      );
    }
    if (data.containsKey('actions')) {
      context.handle(
        _actionsMeta,
        actions.isAcceptableOrUnknown(data['actions']!, _actionsMeta),
      );
    }
    if (data.containsKey('is_markdown')) {
      context.handle(
        _isMarkdownMeta,
        isMarkdown.isAcceptableOrUnknown(data['is_markdown']!, _isMarkdownMeta),
      );
    }
    if (data.containsKey('is_read')) {
      context.handle(
        _isReadMeta,
        isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta),
      );
    }
    if (data.containsKey('is_pinned')) {
      context.handle(
        _isPinnedMeta,
        isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta),
      );
    }
    if (data.containsKey('received_at')) {
      context.handle(
        _receivedAtMeta,
        receivedAt.isAcceptableOrUnknown(data['received_at']!, _receivedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_receivedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {serverId, id};
  @override
  NotificationMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationMessage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      )!,
      topic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic'],
      )!,
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time'],
      )!,
      expires: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expires'],
      ),
      event: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      ),
      click: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}click'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      attachment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attachment'],
      ),
      actions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actions'],
      ),
      isMarkdown: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_markdown'],
      )!,
      isRead: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_read'],
      )!,
      isPinned: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_pinned'],
      )!,
      receivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}received_at'],
      )!,
    );
  }

  @override
  $NotificationMessagesTable createAlias(String alias) {
    return $NotificationMessagesTable(attachedDatabase, alias);
  }
}

class NotificationMessage extends DataClass
    implements Insertable<NotificationMessage> {
  final String id;
  final String serverId;
  final String topic;
  final int time;
  final int? expires;
  final String event;
  final String? title;
  final String? body;
  final int priority;
  final String? tags;
  final String? click;
  final String? icon;
  final String? attachment;
  final String? actions;
  final int isMarkdown;
  final int isRead;
  final int isPinned;
  final int receivedAt;
  const NotificationMessage({
    required this.id,
    required this.serverId,
    required this.topic,
    required this.time,
    this.expires,
    required this.event,
    this.title,
    this.body,
    required this.priority,
    this.tags,
    this.click,
    this.icon,
    this.attachment,
    this.actions,
    required this.isMarkdown,
    required this.isRead,
    required this.isPinned,
    required this.receivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['server_id'] = Variable<String>(serverId);
    map['topic'] = Variable<String>(topic);
    map['time'] = Variable<int>(time);
    if (!nullToAbsent || expires != null) {
      map['expires'] = Variable<int>(expires);
    }
    map['event'] = Variable<String>(event);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || body != null) {
      map['body'] = Variable<String>(body);
    }
    map['priority'] = Variable<int>(priority);
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    if (!nullToAbsent || click != null) {
      map['click'] = Variable<String>(click);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || attachment != null) {
      map['attachment'] = Variable<String>(attachment);
    }
    if (!nullToAbsent || actions != null) {
      map['actions'] = Variable<String>(actions);
    }
    map['is_markdown'] = Variable<int>(isMarkdown);
    map['is_read'] = Variable<int>(isRead);
    map['is_pinned'] = Variable<int>(isPinned);
    map['received_at'] = Variable<int>(receivedAt);
    return map;
  }

  NotificationMessagesCompanion toCompanion(bool nullToAbsent) {
    return NotificationMessagesCompanion(
      id: Value(id),
      serverId: Value(serverId),
      topic: Value(topic),
      time: Value(time),
      expires: expires == null && nullToAbsent
          ? const Value.absent()
          : Value(expires),
      event: Value(event),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      body: body == null && nullToAbsent ? const Value.absent() : Value(body),
      priority: Value(priority),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      click: click == null && nullToAbsent
          ? const Value.absent()
          : Value(click),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      attachment: attachment == null && nullToAbsent
          ? const Value.absent()
          : Value(attachment),
      actions: actions == null && nullToAbsent
          ? const Value.absent()
          : Value(actions),
      isMarkdown: Value(isMarkdown),
      isRead: Value(isRead),
      isPinned: Value(isPinned),
      receivedAt: Value(receivedAt),
    );
  }

  factory NotificationMessage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationMessage(
      id: serializer.fromJson<String>(json['id']),
      serverId: serializer.fromJson<String>(json['serverId']),
      topic: serializer.fromJson<String>(json['topic']),
      time: serializer.fromJson<int>(json['time']),
      expires: serializer.fromJson<int?>(json['expires']),
      event: serializer.fromJson<String>(json['event']),
      title: serializer.fromJson<String?>(json['title']),
      body: serializer.fromJson<String?>(json['body']),
      priority: serializer.fromJson<int>(json['priority']),
      tags: serializer.fromJson<String?>(json['tags']),
      click: serializer.fromJson<String?>(json['click']),
      icon: serializer.fromJson<String?>(json['icon']),
      attachment: serializer.fromJson<String?>(json['attachment']),
      actions: serializer.fromJson<String?>(json['actions']),
      isMarkdown: serializer.fromJson<int>(json['isMarkdown']),
      isRead: serializer.fromJson<int>(json['isRead']),
      isPinned: serializer.fromJson<int>(json['isPinned']),
      receivedAt: serializer.fromJson<int>(json['receivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serverId': serializer.toJson<String>(serverId),
      'topic': serializer.toJson<String>(topic),
      'time': serializer.toJson<int>(time),
      'expires': serializer.toJson<int?>(expires),
      'event': serializer.toJson<String>(event),
      'title': serializer.toJson<String?>(title),
      'body': serializer.toJson<String?>(body),
      'priority': serializer.toJson<int>(priority),
      'tags': serializer.toJson<String?>(tags),
      'click': serializer.toJson<String?>(click),
      'icon': serializer.toJson<String?>(icon),
      'attachment': serializer.toJson<String?>(attachment),
      'actions': serializer.toJson<String?>(actions),
      'isMarkdown': serializer.toJson<int>(isMarkdown),
      'isRead': serializer.toJson<int>(isRead),
      'isPinned': serializer.toJson<int>(isPinned),
      'receivedAt': serializer.toJson<int>(receivedAt),
    };
  }

  NotificationMessage copyWith({
    String? id,
    String? serverId,
    String? topic,
    int? time,
    Value<int?> expires = const Value.absent(),
    String? event,
    Value<String?> title = const Value.absent(),
    Value<String?> body = const Value.absent(),
    int? priority,
    Value<String?> tags = const Value.absent(),
    Value<String?> click = const Value.absent(),
    Value<String?> icon = const Value.absent(),
    Value<String?> attachment = const Value.absent(),
    Value<String?> actions = const Value.absent(),
    int? isMarkdown,
    int? isRead,
    int? isPinned,
    int? receivedAt,
  }) => NotificationMessage(
    id: id ?? this.id,
    serverId: serverId ?? this.serverId,
    topic: topic ?? this.topic,
    time: time ?? this.time,
    expires: expires.present ? expires.value : this.expires,
    event: event ?? this.event,
    title: title.present ? title.value : this.title,
    body: body.present ? body.value : this.body,
    priority: priority ?? this.priority,
    tags: tags.present ? tags.value : this.tags,
    click: click.present ? click.value : this.click,
    icon: icon.present ? icon.value : this.icon,
    attachment: attachment.present ? attachment.value : this.attachment,
    actions: actions.present ? actions.value : this.actions,
    isMarkdown: isMarkdown ?? this.isMarkdown,
    isRead: isRead ?? this.isRead,
    isPinned: isPinned ?? this.isPinned,
    receivedAt: receivedAt ?? this.receivedAt,
  );
  NotificationMessage copyWithCompanion(NotificationMessagesCompanion data) {
    return NotificationMessage(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      topic: data.topic.present ? data.topic.value : this.topic,
      time: data.time.present ? data.time.value : this.time,
      expires: data.expires.present ? data.expires.value : this.expires,
      event: data.event.present ? data.event.value : this.event,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      priority: data.priority.present ? data.priority.value : this.priority,
      tags: data.tags.present ? data.tags.value : this.tags,
      click: data.click.present ? data.click.value : this.click,
      icon: data.icon.present ? data.icon.value : this.icon,
      attachment: data.attachment.present
          ? data.attachment.value
          : this.attachment,
      actions: data.actions.present ? data.actions.value : this.actions,
      isMarkdown: data.isMarkdown.present
          ? data.isMarkdown.value
          : this.isMarkdown,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
      receivedAt: data.receivedAt.present
          ? data.receivedAt.value
          : this.receivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationMessage(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('topic: $topic, ')
          ..write('time: $time, ')
          ..write('expires: $expires, ')
          ..write('event: $event, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('priority: $priority, ')
          ..write('tags: $tags, ')
          ..write('click: $click, ')
          ..write('icon: $icon, ')
          ..write('attachment: $attachment, ')
          ..write('actions: $actions, ')
          ..write('isMarkdown: $isMarkdown, ')
          ..write('isRead: $isRead, ')
          ..write('isPinned: $isPinned, ')
          ..write('receivedAt: $receivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverId,
    topic,
    time,
    expires,
    event,
    title,
    body,
    priority,
    tags,
    click,
    icon,
    attachment,
    actions,
    isMarkdown,
    isRead,
    isPinned,
    receivedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationMessage &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.topic == this.topic &&
          other.time == this.time &&
          other.expires == this.expires &&
          other.event == this.event &&
          other.title == this.title &&
          other.body == this.body &&
          other.priority == this.priority &&
          other.tags == this.tags &&
          other.click == this.click &&
          other.icon == this.icon &&
          other.attachment == this.attachment &&
          other.actions == this.actions &&
          other.isMarkdown == this.isMarkdown &&
          other.isRead == this.isRead &&
          other.isPinned == this.isPinned &&
          other.receivedAt == this.receivedAt);
}

class NotificationMessagesCompanion
    extends UpdateCompanion<NotificationMessage> {
  final Value<String> id;
  final Value<String> serverId;
  final Value<String> topic;
  final Value<int> time;
  final Value<int?> expires;
  final Value<String> event;
  final Value<String?> title;
  final Value<String?> body;
  final Value<int> priority;
  final Value<String?> tags;
  final Value<String?> click;
  final Value<String?> icon;
  final Value<String?> attachment;
  final Value<String?> actions;
  final Value<int> isMarkdown;
  final Value<int> isRead;
  final Value<int> isPinned;
  final Value<int> receivedAt;
  final Value<int> rowid;
  const NotificationMessagesCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.topic = const Value.absent(),
    this.time = const Value.absent(),
    this.expires = const Value.absent(),
    this.event = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.priority = const Value.absent(),
    this.tags = const Value.absent(),
    this.click = const Value.absent(),
    this.icon = const Value.absent(),
    this.attachment = const Value.absent(),
    this.actions = const Value.absent(),
    this.isMarkdown = const Value.absent(),
    this.isRead = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.receivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotificationMessagesCompanion.insert({
    required String id,
    required String serverId,
    required String topic,
    required int time,
    this.expires = const Value.absent(),
    required String event,
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.priority = const Value.absent(),
    this.tags = const Value.absent(),
    this.click = const Value.absent(),
    this.icon = const Value.absent(),
    this.attachment = const Value.absent(),
    this.actions = const Value.absent(),
    this.isMarkdown = const Value.absent(),
    this.isRead = const Value.absent(),
    this.isPinned = const Value.absent(),
    required int receivedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       serverId = Value(serverId),
       topic = Value(topic),
       time = Value(time),
       event = Value(event),
       receivedAt = Value(receivedAt);
  static Insertable<NotificationMessage> custom({
    Expression<String>? id,
    Expression<String>? serverId,
    Expression<String>? topic,
    Expression<int>? time,
    Expression<int>? expires,
    Expression<String>? event,
    Expression<String>? title,
    Expression<String>? body,
    Expression<int>? priority,
    Expression<String>? tags,
    Expression<String>? click,
    Expression<String>? icon,
    Expression<String>? attachment,
    Expression<String>? actions,
    Expression<int>? isMarkdown,
    Expression<int>? isRead,
    Expression<int>? isPinned,
    Expression<int>? receivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (topic != null) 'topic': topic,
      if (time != null) 'time': time,
      if (expires != null) 'expires': expires,
      if (event != null) 'event': event,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (priority != null) 'priority': priority,
      if (tags != null) 'tags': tags,
      if (click != null) 'click': click,
      if (icon != null) 'icon': icon,
      if (attachment != null) 'attachment': attachment,
      if (actions != null) 'actions': actions,
      if (isMarkdown != null) 'is_markdown': isMarkdown,
      if (isRead != null) 'is_read': isRead,
      if (isPinned != null) 'is_pinned': isPinned,
      if (receivedAt != null) 'received_at': receivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotificationMessagesCompanion copyWith({
    Value<String>? id,
    Value<String>? serverId,
    Value<String>? topic,
    Value<int>? time,
    Value<int?>? expires,
    Value<String>? event,
    Value<String?>? title,
    Value<String?>? body,
    Value<int>? priority,
    Value<String?>? tags,
    Value<String?>? click,
    Value<String?>? icon,
    Value<String?>? attachment,
    Value<String?>? actions,
    Value<int>? isMarkdown,
    Value<int>? isRead,
    Value<int>? isPinned,
    Value<int>? receivedAt,
    Value<int>? rowid,
  }) {
    return NotificationMessagesCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      topic: topic ?? this.topic,
      time: time ?? this.time,
      expires: expires ?? this.expires,
      event: event ?? this.event,
      title: title ?? this.title,
      body: body ?? this.body,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      click: click ?? this.click,
      icon: icon ?? this.icon,
      attachment: attachment ?? this.attachment,
      actions: actions ?? this.actions,
      isMarkdown: isMarkdown ?? this.isMarkdown,
      isRead: isRead ?? this.isRead,
      isPinned: isPinned ?? this.isPinned,
      receivedAt: receivedAt ?? this.receivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (topic.present) {
      map['topic'] = Variable<String>(topic.value);
    }
    if (time.present) {
      map['time'] = Variable<int>(time.value);
    }
    if (expires.present) {
      map['expires'] = Variable<int>(expires.value);
    }
    if (event.present) {
      map['event'] = Variable<String>(event.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (click.present) {
      map['click'] = Variable<String>(click.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (attachment.present) {
      map['attachment'] = Variable<String>(attachment.value);
    }
    if (actions.present) {
      map['actions'] = Variable<String>(actions.value);
    }
    if (isMarkdown.present) {
      map['is_markdown'] = Variable<int>(isMarkdown.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<int>(isRead.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<int>(isPinned.value);
    }
    if (receivedAt.present) {
      map['received_at'] = Variable<int>(receivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationMessagesCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('topic: $topic, ')
          ..write('time: $time, ')
          ..write('expires: $expires, ')
          ..write('event: $event, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('priority: $priority, ')
          ..write('tags: $tags, ')
          ..write('click: $click, ')
          ..write('icon: $icon, ')
          ..write('attachment: $attachment, ')
          ..write('actions: $actions, ')
          ..write('isMarkdown: $isMarkdown, ')
          ..write('isRead: $isRead, ')
          ..write('isPinned: $isPinned, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GroupsTable extends Groups with TableInfo<$GroupsTable, Group> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _filterPrioritiesMeta = const VerificationMeta(
    'filterPriorities',
  );
  @override
  late final GeneratedColumn<String> filterPriorities = GeneratedColumn<String>(
    'filter_priorities',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    icon,
    color,
    sortOrder,
    filterPriorities,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<Group> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('filter_priorities')) {
      context.handle(
        _filterPrioritiesMeta,
        filterPriorities.isAcceptableOrUnknown(
          data['filter_priorities']!,
          _filterPrioritiesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Group map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Group(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      filterPriorities: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}filter_priorities'],
      ),
    );
  }

  @override
  $GroupsTable createAlias(String alias) {
    return $GroupsTable(attachedDatabase, alias);
  }
}

class Group extends DataClass implements Insertable<Group> {
  final String id;
  final String name;
  final String? icon;
  final int? color;
  final int sortOrder;
  final String? filterPriorities;
  const Group({
    required this.id,
    required this.name,
    this.icon,
    this.color,
    required this.sortOrder,
    this.filterPriorities,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<int>(color);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || filterPriorities != null) {
      map['filter_priorities'] = Variable<String>(filterPriorities);
    }
    return map;
  }

  GroupsCompanion toCompanion(bool nullToAbsent) {
    return GroupsCompanion(
      id: Value(id),
      name: Value(name),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      sortOrder: Value(sortOrder),
      filterPriorities: filterPriorities == null && nullToAbsent
          ? const Value.absent()
          : Value(filterPriorities),
    );
  }

  factory Group.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Group(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String?>(json['icon']),
      color: serializer.fromJson<int?>(json['color']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      filterPriorities: serializer.fromJson<String?>(json['filterPriorities']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String?>(icon),
      'color': serializer.toJson<int?>(color),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'filterPriorities': serializer.toJson<String?>(filterPriorities),
    };
  }

  Group copyWith({
    String? id,
    String? name,
    Value<String?> icon = const Value.absent(),
    Value<int?> color = const Value.absent(),
    int? sortOrder,
    Value<String?> filterPriorities = const Value.absent(),
  }) => Group(
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon.present ? icon.value : this.icon,
    color: color.present ? color.value : this.color,
    sortOrder: sortOrder ?? this.sortOrder,
    filterPriorities: filterPriorities.present
        ? filterPriorities.value
        : this.filterPriorities,
  );
  Group copyWithCompanion(GroupsCompanion data) {
    return Group(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      filterPriorities: data.filterPriorities.present
          ? data.filterPriorities.value
          : this.filterPriorities,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Group(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('filterPriorities: $filterPriorities')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, icon, color, sortOrder, filterPriorities);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Group &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.sortOrder == this.sortOrder &&
          other.filterPriorities == this.filterPriorities);
}

class GroupsCompanion extends UpdateCompanion<Group> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> icon;
  final Value<int?> color;
  final Value<int> sortOrder;
  final Value<String?> filterPriorities;
  final Value<int> rowid;
  const GroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.filterPriorities = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupsCompanion.insert({
    required String id,
    required String name,
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.filterPriorities = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Group> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<int>? color,
    Expression<int>? sortOrder,
    Expression<String>? filterPriorities,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (filterPriorities != null) 'filter_priorities': filterPriorities,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? icon,
    Value<int?>? color,
    Value<int>? sortOrder,
    Value<String?>? filterPriorities,
    Value<int>? rowid,
  }) {
    return GroupsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      sortOrder: sortOrder ?? this.sortOrder,
      filterPriorities: filterPriorities ?? this.filterPriorities,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (filterPriorities.present) {
      map['filter_priorities'] = Variable<String>(filterPriorities.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('filterPriorities: $filterPriorities, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GroupMembersTable extends GroupMembers
    with TableInfo<$GroupMembersTable, GroupMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topicMeta = const VerificationMeta('topic');
  @override
  late final GeneratedColumn<String> topic = GeneratedColumn<String>(
    'topic',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [groupId, serverId, topic];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<GroupMember> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('topic')) {
      context.handle(
        _topicMeta,
        topic.isAcceptableOrUnknown(data['topic']!, _topicMeta),
      );
    } else if (isInserting) {
      context.missing(_topicMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {groupId, serverId, topic};
  @override
  GroupMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupMember(
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      )!,
      topic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic'],
      )!,
    );
  }

  @override
  $GroupMembersTable createAlias(String alias) {
    return $GroupMembersTable(attachedDatabase, alias);
  }
}

class GroupMember extends DataClass implements Insertable<GroupMember> {
  final String groupId;
  final String serverId;
  final String topic;
  const GroupMember({
    required this.groupId,
    required this.serverId,
    required this.topic,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['group_id'] = Variable<String>(groupId);
    map['server_id'] = Variable<String>(serverId);
    map['topic'] = Variable<String>(topic);
    return map;
  }

  GroupMembersCompanion toCompanion(bool nullToAbsent) {
    return GroupMembersCompanion(
      groupId: Value(groupId),
      serverId: Value(serverId),
      topic: Value(topic),
    );
  }

  factory GroupMember.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupMember(
      groupId: serializer.fromJson<String>(json['groupId']),
      serverId: serializer.fromJson<String>(json['serverId']),
      topic: serializer.fromJson<String>(json['topic']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'groupId': serializer.toJson<String>(groupId),
      'serverId': serializer.toJson<String>(serverId),
      'topic': serializer.toJson<String>(topic),
    };
  }

  GroupMember copyWith({String? groupId, String? serverId, String? topic}) =>
      GroupMember(
        groupId: groupId ?? this.groupId,
        serverId: serverId ?? this.serverId,
        topic: topic ?? this.topic,
      );
  GroupMember copyWithCompanion(GroupMembersCompanion data) {
    return GroupMember(
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      topic: data.topic.present ? data.topic.value : this.topic,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupMember(')
          ..write('groupId: $groupId, ')
          ..write('serverId: $serverId, ')
          ..write('topic: $topic')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(groupId, serverId, topic);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupMember &&
          other.groupId == this.groupId &&
          other.serverId == this.serverId &&
          other.topic == this.topic);
}

class GroupMembersCompanion extends UpdateCompanion<GroupMember> {
  final Value<String> groupId;
  final Value<String> serverId;
  final Value<String> topic;
  final Value<int> rowid;
  const GroupMembersCompanion({
    this.groupId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.topic = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupMembersCompanion.insert({
    required String groupId,
    required String serverId,
    required String topic,
    this.rowid = const Value.absent(),
  }) : groupId = Value(groupId),
       serverId = Value(serverId),
       topic = Value(topic);
  static Insertable<GroupMember> custom({
    Expression<String>? groupId,
    Expression<String>? serverId,
    Expression<String>? topic,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (groupId != null) 'group_id': groupId,
      if (serverId != null) 'server_id': serverId,
      if (topic != null) 'topic': topic,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupMembersCompanion copyWith({
    Value<String>? groupId,
    Value<String>? serverId,
    Value<String>? topic,
    Value<int>? rowid,
  }) {
    return GroupMembersCompanion(
      groupId: groupId ?? this.groupId,
      serverId: serverId ?? this.serverId,
      topic: topic ?? this.topic,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (topic.present) {
      map['topic'] = Variable<String>(topic.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupMembersCompanion(')
          ..write('groupId: $groupId, ')
          ..write('serverId: $serverId, ')
          ..write('topic: $topic, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('dark'),
  );
  static const VerificationMeta _quietHoursEnabledMeta = const VerificationMeta(
    'quietHoursEnabled',
  );
  @override
  late final GeneratedColumn<int> quietHoursEnabled = GeneratedColumn<int>(
    'quiet_hours_enabled',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _quietHoursStartMeta = const VerificationMeta(
    'quietHoursStart',
  );
  @override
  late final GeneratedColumn<String> quietHoursStart = GeneratedColumn<String>(
    'quiet_hours_start',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quietHoursEndMeta = const VerificationMeta(
    'quietHoursEnd',
  );
  @override
  late final GeneratedColumn<String> quietHoursEnd = GeneratedColumn<String>(
    'quiet_hours_end',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priorityThresholdMeta = const VerificationMeta(
    'priorityThreshold',
  );
  @override
  late final GeneratedColumn<int> priorityThreshold = GeneratedColumn<int>(
    'priority_threshold',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _retentionMaxAgeDaysMeta =
      const VerificationMeta('retentionMaxAgeDays');
  @override
  late final GeneratedColumn<int> retentionMaxAgeDays = GeneratedColumn<int>(
    'retention_max_age_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _retentionMaxRowsMeta = const VerificationMeta(
    'retentionMaxRows',
  );
  @override
  late final GeneratedColumn<int> retentionMaxRows = GeneratedColumn<int>(
    'retention_max_rows',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hideLockScreenContentMeta =
      const VerificationMeta('hideLockScreenContent');
  @override
  late final GeneratedColumn<int> hideLockScreenContent = GeneratedColumn<int>(
    'hide_lock_screen_content',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _analyticsOptOutMeta = const VerificationMeta(
    'analyticsOptOut',
  );
  @override
  late final GeneratedColumn<int> analyticsOptOut = GeneratedColumn<int>(
    'analytics_opt_out',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _biometricLockMeta = const VerificationMeta(
    'biometricLock',
  );
  @override
  late final GeneratedColumn<int> biometricLock = GeneratedColumn<int>(
    'biometric_lock',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    themeMode,
    quietHoursEnabled,
    quietHoursStart,
    quietHoursEnd,
    priorityThreshold,
    retentionMaxAgeDays,
    retentionMaxRows,
    hideLockScreenContent,
    analyticsOptOut,
    biometricLock,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    }
    if (data.containsKey('quiet_hours_enabled')) {
      context.handle(
        _quietHoursEnabledMeta,
        quietHoursEnabled.isAcceptableOrUnknown(
          data['quiet_hours_enabled']!,
          _quietHoursEnabledMeta,
        ),
      );
    }
    if (data.containsKey('quiet_hours_start')) {
      context.handle(
        _quietHoursStartMeta,
        quietHoursStart.isAcceptableOrUnknown(
          data['quiet_hours_start']!,
          _quietHoursStartMeta,
        ),
      );
    }
    if (data.containsKey('quiet_hours_end')) {
      context.handle(
        _quietHoursEndMeta,
        quietHoursEnd.isAcceptableOrUnknown(
          data['quiet_hours_end']!,
          _quietHoursEndMeta,
        ),
      );
    }
    if (data.containsKey('priority_threshold')) {
      context.handle(
        _priorityThresholdMeta,
        priorityThreshold.isAcceptableOrUnknown(
          data['priority_threshold']!,
          _priorityThresholdMeta,
        ),
      );
    }
    if (data.containsKey('retention_max_age_days')) {
      context.handle(
        _retentionMaxAgeDaysMeta,
        retentionMaxAgeDays.isAcceptableOrUnknown(
          data['retention_max_age_days']!,
          _retentionMaxAgeDaysMeta,
        ),
      );
    }
    if (data.containsKey('retention_max_rows')) {
      context.handle(
        _retentionMaxRowsMeta,
        retentionMaxRows.isAcceptableOrUnknown(
          data['retention_max_rows']!,
          _retentionMaxRowsMeta,
        ),
      );
    }
    if (data.containsKey('hide_lock_screen_content')) {
      context.handle(
        _hideLockScreenContentMeta,
        hideLockScreenContent.isAcceptableOrUnknown(
          data['hide_lock_screen_content']!,
          _hideLockScreenContentMeta,
        ),
      );
    }
    if (data.containsKey('analytics_opt_out')) {
      context.handle(
        _analyticsOptOutMeta,
        analyticsOptOut.isAcceptableOrUnknown(
          data['analytics_opt_out']!,
          _analyticsOptOutMeta,
        ),
      );
    }
    if (data.containsKey('biometric_lock')) {
      context.handle(
        _biometricLockMeta,
        biometricLock.isAcceptableOrUnknown(
          data['biometric_lock']!,
          _biometricLockMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
      quietHoursEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quiet_hours_enabled'],
      )!,
      quietHoursStart: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quiet_hours_start'],
      ),
      quietHoursEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quiet_hours_end'],
      ),
      priorityThreshold: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority_threshold'],
      )!,
      retentionMaxAgeDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retention_max_age_days'],
      ),
      retentionMaxRows: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retention_max_rows'],
      ),
      hideLockScreenContent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hide_lock_screen_content'],
      )!,
      analyticsOptOut: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}analytics_opt_out'],
      )!,
      biometricLock: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}biometric_lock'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final int id;
  final String themeMode;
  final int quietHoursEnabled;
  final String? quietHoursStart;
  final String? quietHoursEnd;
  final int priorityThreshold;
  final int? retentionMaxAgeDays;
  final int? retentionMaxRows;
  final int hideLockScreenContent;
  final int analyticsOptOut;
  final int biometricLock;
  const AppSetting({
    required this.id,
    required this.themeMode,
    required this.quietHoursEnabled,
    this.quietHoursStart,
    this.quietHoursEnd,
    required this.priorityThreshold,
    this.retentionMaxAgeDays,
    this.retentionMaxRows,
    required this.hideLockScreenContent,
    required this.analyticsOptOut,
    required this.biometricLock,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['theme_mode'] = Variable<String>(themeMode);
    map['quiet_hours_enabled'] = Variable<int>(quietHoursEnabled);
    if (!nullToAbsent || quietHoursStart != null) {
      map['quiet_hours_start'] = Variable<String>(quietHoursStart);
    }
    if (!nullToAbsent || quietHoursEnd != null) {
      map['quiet_hours_end'] = Variable<String>(quietHoursEnd);
    }
    map['priority_threshold'] = Variable<int>(priorityThreshold);
    if (!nullToAbsent || retentionMaxAgeDays != null) {
      map['retention_max_age_days'] = Variable<int>(retentionMaxAgeDays);
    }
    if (!nullToAbsent || retentionMaxRows != null) {
      map['retention_max_rows'] = Variable<int>(retentionMaxRows);
    }
    map['hide_lock_screen_content'] = Variable<int>(hideLockScreenContent);
    map['analytics_opt_out'] = Variable<int>(analyticsOptOut);
    map['biometric_lock'] = Variable<int>(biometricLock);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      themeMode: Value(themeMode),
      quietHoursEnabled: Value(quietHoursEnabled),
      quietHoursStart: quietHoursStart == null && nullToAbsent
          ? const Value.absent()
          : Value(quietHoursStart),
      quietHoursEnd: quietHoursEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(quietHoursEnd),
      priorityThreshold: Value(priorityThreshold),
      retentionMaxAgeDays: retentionMaxAgeDays == null && nullToAbsent
          ? const Value.absent()
          : Value(retentionMaxAgeDays),
      retentionMaxRows: retentionMaxRows == null && nullToAbsent
          ? const Value.absent()
          : Value(retentionMaxRows),
      hideLockScreenContent: Value(hideLockScreenContent),
      analyticsOptOut: Value(analyticsOptOut),
      biometricLock: Value(biometricLock),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<int>(json['id']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      quietHoursEnabled: serializer.fromJson<int>(json['quietHoursEnabled']),
      quietHoursStart: serializer.fromJson<String?>(json['quietHoursStart']),
      quietHoursEnd: serializer.fromJson<String?>(json['quietHoursEnd']),
      priorityThreshold: serializer.fromJson<int>(json['priorityThreshold']),
      retentionMaxAgeDays: serializer.fromJson<int?>(
        json['retentionMaxAgeDays'],
      ),
      retentionMaxRows: serializer.fromJson<int?>(json['retentionMaxRows']),
      hideLockScreenContent: serializer.fromJson<int>(
        json['hideLockScreenContent'],
      ),
      analyticsOptOut: serializer.fromJson<int>(json['analyticsOptOut']),
      biometricLock: serializer.fromJson<int>(json['biometricLock']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'themeMode': serializer.toJson<String>(themeMode),
      'quietHoursEnabled': serializer.toJson<int>(quietHoursEnabled),
      'quietHoursStart': serializer.toJson<String?>(quietHoursStart),
      'quietHoursEnd': serializer.toJson<String?>(quietHoursEnd),
      'priorityThreshold': serializer.toJson<int>(priorityThreshold),
      'retentionMaxAgeDays': serializer.toJson<int?>(retentionMaxAgeDays),
      'retentionMaxRows': serializer.toJson<int?>(retentionMaxRows),
      'hideLockScreenContent': serializer.toJson<int>(hideLockScreenContent),
      'analyticsOptOut': serializer.toJson<int>(analyticsOptOut),
      'biometricLock': serializer.toJson<int>(biometricLock),
    };
  }

  AppSetting copyWith({
    int? id,
    String? themeMode,
    int? quietHoursEnabled,
    Value<String?> quietHoursStart = const Value.absent(),
    Value<String?> quietHoursEnd = const Value.absent(),
    int? priorityThreshold,
    Value<int?> retentionMaxAgeDays = const Value.absent(),
    Value<int?> retentionMaxRows = const Value.absent(),
    int? hideLockScreenContent,
    int? analyticsOptOut,
    int? biometricLock,
  }) => AppSetting(
    id: id ?? this.id,
    themeMode: themeMode ?? this.themeMode,
    quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
    quietHoursStart: quietHoursStart.present
        ? quietHoursStart.value
        : this.quietHoursStart,
    quietHoursEnd: quietHoursEnd.present
        ? quietHoursEnd.value
        : this.quietHoursEnd,
    priorityThreshold: priorityThreshold ?? this.priorityThreshold,
    retentionMaxAgeDays: retentionMaxAgeDays.present
        ? retentionMaxAgeDays.value
        : this.retentionMaxAgeDays,
    retentionMaxRows: retentionMaxRows.present
        ? retentionMaxRows.value
        : this.retentionMaxRows,
    hideLockScreenContent: hideLockScreenContent ?? this.hideLockScreenContent,
    analyticsOptOut: analyticsOptOut ?? this.analyticsOptOut,
    biometricLock: biometricLock ?? this.biometricLock,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      quietHoursEnabled: data.quietHoursEnabled.present
          ? data.quietHoursEnabled.value
          : this.quietHoursEnabled,
      quietHoursStart: data.quietHoursStart.present
          ? data.quietHoursStart.value
          : this.quietHoursStart,
      quietHoursEnd: data.quietHoursEnd.present
          ? data.quietHoursEnd.value
          : this.quietHoursEnd,
      priorityThreshold: data.priorityThreshold.present
          ? data.priorityThreshold.value
          : this.priorityThreshold,
      retentionMaxAgeDays: data.retentionMaxAgeDays.present
          ? data.retentionMaxAgeDays.value
          : this.retentionMaxAgeDays,
      retentionMaxRows: data.retentionMaxRows.present
          ? data.retentionMaxRows.value
          : this.retentionMaxRows,
      hideLockScreenContent: data.hideLockScreenContent.present
          ? data.hideLockScreenContent.value
          : this.hideLockScreenContent,
      analyticsOptOut: data.analyticsOptOut.present
          ? data.analyticsOptOut.value
          : this.analyticsOptOut,
      biometricLock: data.biometricLock.present
          ? data.biometricLock.value
          : this.biometricLock,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('quietHoursEnabled: $quietHoursEnabled, ')
          ..write('quietHoursStart: $quietHoursStart, ')
          ..write('quietHoursEnd: $quietHoursEnd, ')
          ..write('priorityThreshold: $priorityThreshold, ')
          ..write('retentionMaxAgeDays: $retentionMaxAgeDays, ')
          ..write('retentionMaxRows: $retentionMaxRows, ')
          ..write('hideLockScreenContent: $hideLockScreenContent, ')
          ..write('analyticsOptOut: $analyticsOptOut, ')
          ..write('biometricLock: $biometricLock')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    themeMode,
    quietHoursEnabled,
    quietHoursStart,
    quietHoursEnd,
    priorityThreshold,
    retentionMaxAgeDays,
    retentionMaxRows,
    hideLockScreenContent,
    analyticsOptOut,
    biometricLock,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.themeMode == this.themeMode &&
          other.quietHoursEnabled == this.quietHoursEnabled &&
          other.quietHoursStart == this.quietHoursStart &&
          other.quietHoursEnd == this.quietHoursEnd &&
          other.priorityThreshold == this.priorityThreshold &&
          other.retentionMaxAgeDays == this.retentionMaxAgeDays &&
          other.retentionMaxRows == this.retentionMaxRows &&
          other.hideLockScreenContent == this.hideLockScreenContent &&
          other.analyticsOptOut == this.analyticsOptOut &&
          other.biometricLock == this.biometricLock);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<int> id;
  final Value<String> themeMode;
  final Value<int> quietHoursEnabled;
  final Value<String?> quietHoursStart;
  final Value<String?> quietHoursEnd;
  final Value<int> priorityThreshold;
  final Value<int?> retentionMaxAgeDays;
  final Value<int?> retentionMaxRows;
  final Value<int> hideLockScreenContent;
  final Value<int> analyticsOptOut;
  final Value<int> biometricLock;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.quietHoursEnabled = const Value.absent(),
    this.quietHoursStart = const Value.absent(),
    this.quietHoursEnd = const Value.absent(),
    this.priorityThreshold = const Value.absent(),
    this.retentionMaxAgeDays = const Value.absent(),
    this.retentionMaxRows = const Value.absent(),
    this.hideLockScreenContent = const Value.absent(),
    this.analyticsOptOut = const Value.absent(),
    this.biometricLock = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.quietHoursEnabled = const Value.absent(),
    this.quietHoursStart = const Value.absent(),
    this.quietHoursEnd = const Value.absent(),
    this.priorityThreshold = const Value.absent(),
    this.retentionMaxAgeDays = const Value.absent(),
    this.retentionMaxRows = const Value.absent(),
    this.hideLockScreenContent = const Value.absent(),
    this.analyticsOptOut = const Value.absent(),
    this.biometricLock = const Value.absent(),
  });
  static Insertable<AppSetting> custom({
    Expression<int>? id,
    Expression<String>? themeMode,
    Expression<int>? quietHoursEnabled,
    Expression<String>? quietHoursStart,
    Expression<String>? quietHoursEnd,
    Expression<int>? priorityThreshold,
    Expression<int>? retentionMaxAgeDays,
    Expression<int>? retentionMaxRows,
    Expression<int>? hideLockScreenContent,
    Expression<int>? analyticsOptOut,
    Expression<int>? biometricLock,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (themeMode != null) 'theme_mode': themeMode,
      if (quietHoursEnabled != null) 'quiet_hours_enabled': quietHoursEnabled,
      if (quietHoursStart != null) 'quiet_hours_start': quietHoursStart,
      if (quietHoursEnd != null) 'quiet_hours_end': quietHoursEnd,
      if (priorityThreshold != null) 'priority_threshold': priorityThreshold,
      if (retentionMaxAgeDays != null)
        'retention_max_age_days': retentionMaxAgeDays,
      if (retentionMaxRows != null) 'retention_max_rows': retentionMaxRows,
      if (hideLockScreenContent != null)
        'hide_lock_screen_content': hideLockScreenContent,
      if (analyticsOptOut != null) 'analytics_opt_out': analyticsOptOut,
      if (biometricLock != null) 'biometric_lock': biometricLock,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? themeMode,
    Value<int>? quietHoursEnabled,
    Value<String?>? quietHoursStart,
    Value<String?>? quietHoursEnd,
    Value<int>? priorityThreshold,
    Value<int?>? retentionMaxAgeDays,
    Value<int?>? retentionMaxRows,
    Value<int>? hideLockScreenContent,
    Value<int>? analyticsOptOut,
    Value<int>? biometricLock,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      themeMode: themeMode ?? this.themeMode,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
      priorityThreshold: priorityThreshold ?? this.priorityThreshold,
      retentionMaxAgeDays: retentionMaxAgeDays ?? this.retentionMaxAgeDays,
      retentionMaxRows: retentionMaxRows ?? this.retentionMaxRows,
      hideLockScreenContent:
          hideLockScreenContent ?? this.hideLockScreenContent,
      analyticsOptOut: analyticsOptOut ?? this.analyticsOptOut,
      biometricLock: biometricLock ?? this.biometricLock,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (quietHoursEnabled.present) {
      map['quiet_hours_enabled'] = Variable<int>(quietHoursEnabled.value);
    }
    if (quietHoursStart.present) {
      map['quiet_hours_start'] = Variable<String>(quietHoursStart.value);
    }
    if (quietHoursEnd.present) {
      map['quiet_hours_end'] = Variable<String>(quietHoursEnd.value);
    }
    if (priorityThreshold.present) {
      map['priority_threshold'] = Variable<int>(priorityThreshold.value);
    }
    if (retentionMaxAgeDays.present) {
      map['retention_max_age_days'] = Variable<int>(retentionMaxAgeDays.value);
    }
    if (retentionMaxRows.present) {
      map['retention_max_rows'] = Variable<int>(retentionMaxRows.value);
    }
    if (hideLockScreenContent.present) {
      map['hide_lock_screen_content'] = Variable<int>(
        hideLockScreenContent.value,
      );
    }
    if (analyticsOptOut.present) {
      map['analytics_opt_out'] = Variable<int>(analyticsOptOut.value);
    }
    if (biometricLock.present) {
      map['biometric_lock'] = Variable<int>(biometricLock.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('quietHoursEnabled: $quietHoursEnabled, ')
          ..write('quietHoursStart: $quietHoursStart, ')
          ..write('quietHoursEnd: $quietHoursEnd, ')
          ..write('priorityThreshold: $priorityThreshold, ')
          ..write('retentionMaxAgeDays: $retentionMaxAgeDays, ')
          ..write('retentionMaxRows: $retentionMaxRows, ')
          ..write('hideLockScreenContent: $hideLockScreenContent, ')
          ..write('analyticsOptOut: $analyticsOptOut, ')
          ..write('biometricLock: $biometricLock')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ServerConfigsTable serverConfigs = $ServerConfigsTable(this);
  late final $SubscriptionsTable subscriptions = $SubscriptionsTable(this);
  late final $NotificationMessagesTable notificationMessages =
      $NotificationMessagesTable(this);
  late final $GroupsTable groups = $GroupsTable(this);
  late final $GroupMembersTable groupMembers = $GroupMembersTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final ServerConfigDao serverConfigDao = ServerConfigDao(
    this as AppDatabase,
  );
  late final SubscriptionDao subscriptionDao = SubscriptionDao(
    this as AppDatabase,
  );
  late final MessageDao messageDao = MessageDao(this as AppDatabase);
  late final GroupDao groupDao = GroupDao(this as AppDatabase);
  late final SettingDao settingDao = SettingDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    serverConfigs,
    subscriptions,
    notificationMessages,
    groups,
    groupMembers,
    appSettings,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'server_configs',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('subscriptions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'groups',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('group_members', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ServerConfigsTableCreateCompanionBuilder =
    ServerConfigsCompanion Function({
      required String id,
      required String baseUrl,
      required String displayName,
      required String authType,
      Value<String?> credentialRef,
      Value<int> isDefault,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$ServerConfigsTableUpdateCompanionBuilder =
    ServerConfigsCompanion Function({
      Value<String> id,
      Value<String> baseUrl,
      Value<String> displayName,
      Value<String> authType,
      Value<String?> credentialRef,
      Value<int> isDefault,
      Value<int> createdAt,
      Value<int> rowid,
    });

final class $$ServerConfigsTableReferences
    extends BaseReferences<_$AppDatabase, $ServerConfigsTable, ServerConfig> {
  $$ServerConfigsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$SubscriptionsTable, List<Subscription>>
  _subscriptionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.subscriptions,
    aliasName: $_aliasNameGenerator(
      db.serverConfigs.id,
      db.subscriptions.serverId,
    ),
  );

  $$SubscriptionsTableProcessedTableManager get subscriptionsRefs {
    final manager = $$SubscriptionsTableTableManager(
      $_db,
      $_db.subscriptions,
    ).filter((f) => f.serverId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_subscriptionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ServerConfigsTableFilterComposer
    extends Composer<_$AppDatabase, $ServerConfigsTable> {
  $$ServerConfigsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baseUrl => $composableBuilder(
    column: $table.baseUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authType => $composableBuilder(
    column: $table.authType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get credentialRef => $composableBuilder(
    column: $table.credentialRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> subscriptionsRefs(
    Expression<bool> Function($$SubscriptionsTableFilterComposer f) f,
  ) {
    final $$SubscriptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subscriptions,
      getReferencedColumn: (t) => t.serverId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscriptionsTableFilterComposer(
            $db: $db,
            $table: $db.subscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServerConfigsTableOrderingComposer
    extends Composer<_$AppDatabase, $ServerConfigsTable> {
  $$ServerConfigsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baseUrl => $composableBuilder(
    column: $table.baseUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authType => $composableBuilder(
    column: $table.authType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get credentialRef => $composableBuilder(
    column: $table.credentialRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ServerConfigsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServerConfigsTable> {
  $$ServerConfigsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get baseUrl =>
      $composableBuilder(column: $table.baseUrl, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get authType =>
      $composableBuilder(column: $table.authType, builder: (column) => column);

  GeneratedColumn<String> get credentialRef => $composableBuilder(
    column: $table.credentialRef,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> subscriptionsRefs<T extends Object>(
    Expression<T> Function($$SubscriptionsTableAnnotationComposer a) f,
  ) {
    final $$SubscriptionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subscriptions,
      getReferencedColumn: (t) => t.serverId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscriptionsTableAnnotationComposer(
            $db: $db,
            $table: $db.subscriptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServerConfigsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServerConfigsTable,
          ServerConfig,
          $$ServerConfigsTableFilterComposer,
          $$ServerConfigsTableOrderingComposer,
          $$ServerConfigsTableAnnotationComposer,
          $$ServerConfigsTableCreateCompanionBuilder,
          $$ServerConfigsTableUpdateCompanionBuilder,
          (ServerConfig, $$ServerConfigsTableReferences),
          ServerConfig,
          PrefetchHooks Function({bool subscriptionsRefs})
        > {
  $$ServerConfigsTableTableManager(_$AppDatabase db, $ServerConfigsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServerConfigsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServerConfigsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServerConfigsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> baseUrl = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> authType = const Value.absent(),
                Value<String?> credentialRef = const Value.absent(),
                Value<int> isDefault = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ServerConfigsCompanion(
                id: id,
                baseUrl: baseUrl,
                displayName: displayName,
                authType: authType,
                credentialRef: credentialRef,
                isDefault: isDefault,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String baseUrl,
                required String displayName,
                required String authType,
                Value<String?> credentialRef = const Value.absent(),
                Value<int> isDefault = const Value.absent(),
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ServerConfigsCompanion.insert(
                id: id,
                baseUrl: baseUrl,
                displayName: displayName,
                authType: authType,
                credentialRef: credentialRef,
                isDefault: isDefault,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ServerConfigsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({subscriptionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (subscriptionsRefs) db.subscriptions,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (subscriptionsRefs)
                    await $_getPrefetchedData<
                      ServerConfig,
                      $ServerConfigsTable,
                      Subscription
                    >(
                      currentTable: table,
                      referencedTable: $$ServerConfigsTableReferences
                          ._subscriptionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ServerConfigsTableReferences(
                            db,
                            table,
                            p0,
                          ).subscriptionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.serverId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ServerConfigsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServerConfigsTable,
      ServerConfig,
      $$ServerConfigsTableFilterComposer,
      $$ServerConfigsTableOrderingComposer,
      $$ServerConfigsTableAnnotationComposer,
      $$ServerConfigsTableCreateCompanionBuilder,
      $$ServerConfigsTableUpdateCompanionBuilder,
      (ServerConfig, $$ServerConfigsTableReferences),
      ServerConfig,
      PrefetchHooks Function({bool subscriptionsRefs})
    >;
typedef $$SubscriptionsTableCreateCompanionBuilder =
    SubscriptionsCompanion Function({
      required String id,
      required String serverId,
      required String topic,
      required String displayName,
      Value<int> priorityThreshold,
      Value<int> muted,
      Value<int> pinned,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$SubscriptionsTableUpdateCompanionBuilder =
    SubscriptionsCompanion Function({
      Value<String> id,
      Value<String> serverId,
      Value<String> topic,
      Value<String> displayName,
      Value<int> priorityThreshold,
      Value<int> muted,
      Value<int> pinned,
      Value<int> createdAt,
      Value<int> rowid,
    });

final class $$SubscriptionsTableReferences
    extends BaseReferences<_$AppDatabase, $SubscriptionsTable, Subscription> {
  $$SubscriptionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ServerConfigsTable _serverIdTable(_$AppDatabase db) =>
      db.serverConfigs.createAlias(
        $_aliasNameGenerator(db.subscriptions.serverId, db.serverConfigs.id),
      );

  $$ServerConfigsTableProcessedTableManager get serverId {
    final $_column = $_itemColumn<String>('server_id')!;

    final manager = $$ServerConfigsTableTableManager(
      $_db,
      $_db.serverConfigs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_serverIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SubscriptionsTableFilterComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priorityThreshold => $composableBuilder(
    column: $table.priorityThreshold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get muted => $composableBuilder(
    column: $table.muted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pinned => $composableBuilder(
    column: $table.pinned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ServerConfigsTableFilterComposer get serverId {
    final $$ServerConfigsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serverId,
      referencedTable: $db.serverConfigs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServerConfigsTableFilterComposer(
            $db: $db,
            $table: $db.serverConfigs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubscriptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priorityThreshold => $composableBuilder(
    column: $table.priorityThreshold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get muted => $composableBuilder(
    column: $table.muted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pinned => $composableBuilder(
    column: $table.pinned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ServerConfigsTableOrderingComposer get serverId {
    final $$ServerConfigsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serverId,
      referencedTable: $db.serverConfigs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServerConfigsTableOrderingComposer(
            $db: $db,
            $table: $db.serverConfigs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubscriptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get topic =>
      $composableBuilder(column: $table.topic, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get priorityThreshold => $composableBuilder(
    column: $table.priorityThreshold,
    builder: (column) => column,
  );

  GeneratedColumn<int> get muted =>
      $composableBuilder(column: $table.muted, builder: (column) => column);

  GeneratedColumn<int> get pinned =>
      $composableBuilder(column: $table.pinned, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ServerConfigsTableAnnotationComposer get serverId {
    final $$ServerConfigsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serverId,
      referencedTable: $db.serverConfigs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServerConfigsTableAnnotationComposer(
            $db: $db,
            $table: $db.serverConfigs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubscriptionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubscriptionsTable,
          Subscription,
          $$SubscriptionsTableFilterComposer,
          $$SubscriptionsTableOrderingComposer,
          $$SubscriptionsTableAnnotationComposer,
          $$SubscriptionsTableCreateCompanionBuilder,
          $$SubscriptionsTableUpdateCompanionBuilder,
          (Subscription, $$SubscriptionsTableReferences),
          Subscription,
          PrefetchHooks Function({bool serverId})
        > {
  $$SubscriptionsTableTableManager(_$AppDatabase db, $SubscriptionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubscriptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubscriptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubscriptionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> serverId = const Value.absent(),
                Value<String> topic = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<int> priorityThreshold = const Value.absent(),
                Value<int> muted = const Value.absent(),
                Value<int> pinned = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubscriptionsCompanion(
                id: id,
                serverId: serverId,
                topic: topic,
                displayName: displayName,
                priorityThreshold: priorityThreshold,
                muted: muted,
                pinned: pinned,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String serverId,
                required String topic,
                required String displayName,
                Value<int> priorityThreshold = const Value.absent(),
                Value<int> muted = const Value.absent(),
                Value<int> pinned = const Value.absent(),
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => SubscriptionsCompanion.insert(
                id: id,
                serverId: serverId,
                topic: topic,
                displayName: displayName,
                priorityThreshold: priorityThreshold,
                muted: muted,
                pinned: pinned,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SubscriptionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({serverId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (serverId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.serverId,
                                referencedTable: $$SubscriptionsTableReferences
                                    ._serverIdTable(db),
                                referencedColumn: $$SubscriptionsTableReferences
                                    ._serverIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SubscriptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubscriptionsTable,
      Subscription,
      $$SubscriptionsTableFilterComposer,
      $$SubscriptionsTableOrderingComposer,
      $$SubscriptionsTableAnnotationComposer,
      $$SubscriptionsTableCreateCompanionBuilder,
      $$SubscriptionsTableUpdateCompanionBuilder,
      (Subscription, $$SubscriptionsTableReferences),
      Subscription,
      PrefetchHooks Function({bool serverId})
    >;
typedef $$NotificationMessagesTableCreateCompanionBuilder =
    NotificationMessagesCompanion Function({
      required String id,
      required String serverId,
      required String topic,
      required int time,
      Value<int?> expires,
      required String event,
      Value<String?> title,
      Value<String?> body,
      Value<int> priority,
      Value<String?> tags,
      Value<String?> click,
      Value<String?> icon,
      Value<String?> attachment,
      Value<String?> actions,
      Value<int> isMarkdown,
      Value<int> isRead,
      Value<int> isPinned,
      required int receivedAt,
      Value<int> rowid,
    });
typedef $$NotificationMessagesTableUpdateCompanionBuilder =
    NotificationMessagesCompanion Function({
      Value<String> id,
      Value<String> serverId,
      Value<String> topic,
      Value<int> time,
      Value<int?> expires,
      Value<String> event,
      Value<String?> title,
      Value<String?> body,
      Value<int> priority,
      Value<String?> tags,
      Value<String?> click,
      Value<String?> icon,
      Value<String?> attachment,
      Value<String?> actions,
      Value<int> isMarkdown,
      Value<int> isRead,
      Value<int> isPinned,
      Value<int> receivedAt,
      Value<int> rowid,
    });

class $$NotificationMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationMessagesTable> {
  $$NotificationMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expires => $composableBuilder(
    column: $table.expires,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get event => $composableBuilder(
    column: $table.event,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get click => $composableBuilder(
    column: $table.click,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attachment => $composableBuilder(
    column: $table.attachment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actions => $composableBuilder(
    column: $table.actions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isMarkdown => $composableBuilder(
    column: $table.isMarkdown,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotificationMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationMessagesTable> {
  $$NotificationMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expires => $composableBuilder(
    column: $table.expires,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get event => $composableBuilder(
    column: $table.event,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get click => $composableBuilder(
    column: $table.click,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attachment => $composableBuilder(
    column: $table.attachment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actions => $composableBuilder(
    column: $table.actions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isMarkdown => $composableBuilder(
    column: $table.isMarkdown,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotificationMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationMessagesTable> {
  $$NotificationMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get topic =>
      $composableBuilder(column: $table.topic, builder: (column) => column);

  GeneratedColumn<int> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<int> get expires =>
      $composableBuilder(column: $table.expires, builder: (column) => column);

  GeneratedColumn<String> get event =>
      $composableBuilder(column: $table.event, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get click =>
      $composableBuilder(column: $table.click, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get attachment => $composableBuilder(
    column: $table.attachment,
    builder: (column) => column,
  );

  GeneratedColumn<String> get actions =>
      $composableBuilder(column: $table.actions, builder: (column) => column);

  GeneratedColumn<int> get isMarkdown => $composableBuilder(
    column: $table.isMarkdown,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);

  GeneratedColumn<int> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);

  GeneratedColumn<int> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => column,
  );
}

class $$NotificationMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificationMessagesTable,
          NotificationMessage,
          $$NotificationMessagesTableFilterComposer,
          $$NotificationMessagesTableOrderingComposer,
          $$NotificationMessagesTableAnnotationComposer,
          $$NotificationMessagesTableCreateCompanionBuilder,
          $$NotificationMessagesTableUpdateCompanionBuilder,
          (
            NotificationMessage,
            BaseReferences<
              _$AppDatabase,
              $NotificationMessagesTable,
              NotificationMessage
            >,
          ),
          NotificationMessage,
          PrefetchHooks Function()
        > {
  $$NotificationMessagesTableTableManager(
    _$AppDatabase db,
    $NotificationMessagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationMessagesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$NotificationMessagesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> serverId = const Value.absent(),
                Value<String> topic = const Value.absent(),
                Value<int> time = const Value.absent(),
                Value<int?> expires = const Value.absent(),
                Value<String> event = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> body = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<String?> click = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String?> attachment = const Value.absent(),
                Value<String?> actions = const Value.absent(),
                Value<int> isMarkdown = const Value.absent(),
                Value<int> isRead = const Value.absent(),
                Value<int> isPinned = const Value.absent(),
                Value<int> receivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotificationMessagesCompanion(
                id: id,
                serverId: serverId,
                topic: topic,
                time: time,
                expires: expires,
                event: event,
                title: title,
                body: body,
                priority: priority,
                tags: tags,
                click: click,
                icon: icon,
                attachment: attachment,
                actions: actions,
                isMarkdown: isMarkdown,
                isRead: isRead,
                isPinned: isPinned,
                receivedAt: receivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String serverId,
                required String topic,
                required int time,
                Value<int?> expires = const Value.absent(),
                required String event,
                Value<String?> title = const Value.absent(),
                Value<String?> body = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<String?> click = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String?> attachment = const Value.absent(),
                Value<String?> actions = const Value.absent(),
                Value<int> isMarkdown = const Value.absent(),
                Value<int> isRead = const Value.absent(),
                Value<int> isPinned = const Value.absent(),
                required int receivedAt,
                Value<int> rowid = const Value.absent(),
              }) => NotificationMessagesCompanion.insert(
                id: id,
                serverId: serverId,
                topic: topic,
                time: time,
                expires: expires,
                event: event,
                title: title,
                body: body,
                priority: priority,
                tags: tags,
                click: click,
                icon: icon,
                attachment: attachment,
                actions: actions,
                isMarkdown: isMarkdown,
                isRead: isRead,
                isPinned: isPinned,
                receivedAt: receivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotificationMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificationMessagesTable,
      NotificationMessage,
      $$NotificationMessagesTableFilterComposer,
      $$NotificationMessagesTableOrderingComposer,
      $$NotificationMessagesTableAnnotationComposer,
      $$NotificationMessagesTableCreateCompanionBuilder,
      $$NotificationMessagesTableUpdateCompanionBuilder,
      (
        NotificationMessage,
        BaseReferences<
          _$AppDatabase,
          $NotificationMessagesTable,
          NotificationMessage
        >,
      ),
      NotificationMessage,
      PrefetchHooks Function()
    >;
typedef $$GroupsTableCreateCompanionBuilder =
    GroupsCompanion Function({
      required String id,
      required String name,
      Value<String?> icon,
      Value<int?> color,
      Value<int> sortOrder,
      Value<String?> filterPriorities,
      Value<int> rowid,
    });
typedef $$GroupsTableUpdateCompanionBuilder =
    GroupsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> icon,
      Value<int?> color,
      Value<int> sortOrder,
      Value<String?> filterPriorities,
      Value<int> rowid,
    });

final class $$GroupsTableReferences
    extends BaseReferences<_$AppDatabase, $GroupsTable, Group> {
  $$GroupsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GroupMembersTable, List<GroupMember>>
  _groupMembersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.groupMembers,
    aliasName: $_aliasNameGenerator(db.groups.id, db.groupMembers.groupId),
  );

  $$GroupMembersTableProcessedTableManager get groupMembersRefs {
    final manager = $$GroupMembersTableTableManager(
      $_db,
      $_db.groupMembers,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_groupMembersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GroupsTableFilterComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filterPriorities => $composableBuilder(
    column: $table.filterPriorities,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> groupMembersRefs(
    Expression<bool> Function($$GroupMembersTableFilterComposer f) f,
  ) {
    final $$GroupMembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupMembers,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupMembersTableFilterComposer(
            $db: $db,
            $table: $db.groupMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filterPriorities => $composableBuilder(
    column: $table.filterPriorities,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get filterPriorities => $composableBuilder(
    column: $table.filterPriorities,
    builder: (column) => column,
  );

  Expression<T> groupMembersRefs<T extends Object>(
    Expression<T> Function($$GroupMembersTableAnnotationComposer a) f,
  ) {
    final $$GroupMembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupMembers,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupMembersTableAnnotationComposer(
            $db: $db,
            $table: $db.groupMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroupsTable,
          Group,
          $$GroupsTableFilterComposer,
          $$GroupsTableOrderingComposer,
          $$GroupsTableAnnotationComposer,
          $$GroupsTableCreateCompanionBuilder,
          $$GroupsTableUpdateCompanionBuilder,
          (Group, $$GroupsTableReferences),
          Group,
          PrefetchHooks Function({bool groupMembersRefs})
        > {
  $$GroupsTableTableManager(_$AppDatabase db, $GroupsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<int?> color = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String?> filterPriorities = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupsCompanion(
                id: id,
                name: name,
                icon: icon,
                color: color,
                sortOrder: sortOrder,
                filterPriorities: filterPriorities,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> icon = const Value.absent(),
                Value<int?> color = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String?> filterPriorities = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupsCompanion.insert(
                id: id,
                name: name,
                icon: icon,
                color: color,
                sortOrder: sortOrder,
                filterPriorities: filterPriorities,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$GroupsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({groupMembersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (groupMembersRefs) db.groupMembers],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (groupMembersRefs)
                    await $_getPrefetchedData<Group, $GroupsTable, GroupMember>(
                      currentTable: table,
                      referencedTable: $$GroupsTableReferences
                          ._groupMembersRefsTable(db),
                      managerFromTypedResult: (p0) => $$GroupsTableReferences(
                        db,
                        table,
                        p0,
                      ).groupMembersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.groupId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$GroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroupsTable,
      Group,
      $$GroupsTableFilterComposer,
      $$GroupsTableOrderingComposer,
      $$GroupsTableAnnotationComposer,
      $$GroupsTableCreateCompanionBuilder,
      $$GroupsTableUpdateCompanionBuilder,
      (Group, $$GroupsTableReferences),
      Group,
      PrefetchHooks Function({bool groupMembersRefs})
    >;
typedef $$GroupMembersTableCreateCompanionBuilder =
    GroupMembersCompanion Function({
      required String groupId,
      required String serverId,
      required String topic,
      Value<int> rowid,
    });
typedef $$GroupMembersTableUpdateCompanionBuilder =
    GroupMembersCompanion Function({
      Value<String> groupId,
      Value<String> serverId,
      Value<String> topic,
      Value<int> rowid,
    });

final class $$GroupMembersTableReferences
    extends BaseReferences<_$AppDatabase, $GroupMembersTable, GroupMember> {
  $$GroupMembersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GroupsTable _groupIdTable(_$AppDatabase db) => db.groups.createAlias(
    $_aliasNameGenerator(db.groupMembers.groupId, db.groups.id),
  );

  $$GroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<String>('group_id')!;

    final manager = $$GroupsTableTableManager(
      $_db,
      $_db.groups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GroupMembersTableFilterComposer
    extends Composer<_$AppDatabase, $GroupMembersTable> {
  $$GroupMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnFilters(column),
  );

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableFilterComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupMembersTable> {
  $$GroupMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnOrderings(column),
  );

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableOrderingComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupMembersTable> {
  $$GroupMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get topic =>
      $composableBuilder(column: $table.topic, builder: (column) => column);

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupMembersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroupMembersTable,
          GroupMember,
          $$GroupMembersTableFilterComposer,
          $$GroupMembersTableOrderingComposer,
          $$GroupMembersTableAnnotationComposer,
          $$GroupMembersTableCreateCompanionBuilder,
          $$GroupMembersTableUpdateCompanionBuilder,
          (GroupMember, $$GroupMembersTableReferences),
          GroupMember,
          PrefetchHooks Function({bool groupId})
        > {
  $$GroupMembersTableTableManager(_$AppDatabase db, $GroupMembersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> groupId = const Value.absent(),
                Value<String> serverId = const Value.absent(),
                Value<String> topic = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupMembersCompanion(
                groupId: groupId,
                serverId: serverId,
                topic: topic,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String groupId,
                required String serverId,
                required String topic,
                Value<int> rowid = const Value.absent(),
              }) => GroupMembersCompanion.insert(
                groupId: groupId,
                serverId: serverId,
                topic: topic,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GroupMembersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (groupId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.groupId,
                                referencedTable: $$GroupMembersTableReferences
                                    ._groupIdTable(db),
                                referencedColumn: $$GroupMembersTableReferences
                                    ._groupIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GroupMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroupMembersTable,
      GroupMember,
      $$GroupMembersTableFilterComposer,
      $$GroupMembersTableOrderingComposer,
      $$GroupMembersTableAnnotationComposer,
      $$GroupMembersTableCreateCompanionBuilder,
      $$GroupMembersTableUpdateCompanionBuilder,
      (GroupMember, $$GroupMembersTableReferences),
      GroupMember,
      PrefetchHooks Function({bool groupId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<String> themeMode,
      Value<int> quietHoursEnabled,
      Value<String?> quietHoursStart,
      Value<String?> quietHoursEnd,
      Value<int> priorityThreshold,
      Value<int?> retentionMaxAgeDays,
      Value<int?> retentionMaxRows,
      Value<int> hideLockScreenContent,
      Value<int> analyticsOptOut,
      Value<int> biometricLock,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<String> themeMode,
      Value<int> quietHoursEnabled,
      Value<String?> quietHoursStart,
      Value<String?> quietHoursEnd,
      Value<int> priorityThreshold,
      Value<int?> retentionMaxAgeDays,
      Value<int?> retentionMaxRows,
      Value<int> hideLockScreenContent,
      Value<int> analyticsOptOut,
      Value<int> biometricLock,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quietHoursEnabled => $composableBuilder(
    column: $table.quietHoursEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quietHoursStart => $composableBuilder(
    column: $table.quietHoursStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quietHoursEnd => $composableBuilder(
    column: $table.quietHoursEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priorityThreshold => $composableBuilder(
    column: $table.priorityThreshold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retentionMaxAgeDays => $composableBuilder(
    column: $table.retentionMaxAgeDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retentionMaxRows => $composableBuilder(
    column: $table.retentionMaxRows,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hideLockScreenContent => $composableBuilder(
    column: $table.hideLockScreenContent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get analyticsOptOut => $composableBuilder(
    column: $table.analyticsOptOut,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get biometricLock => $composableBuilder(
    column: $table.biometricLock,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quietHoursEnabled => $composableBuilder(
    column: $table.quietHoursEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quietHoursStart => $composableBuilder(
    column: $table.quietHoursStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quietHoursEnd => $composableBuilder(
    column: $table.quietHoursEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priorityThreshold => $composableBuilder(
    column: $table.priorityThreshold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retentionMaxAgeDays => $composableBuilder(
    column: $table.retentionMaxAgeDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retentionMaxRows => $composableBuilder(
    column: $table.retentionMaxRows,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hideLockScreenContent => $composableBuilder(
    column: $table.hideLockScreenContent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get analyticsOptOut => $composableBuilder(
    column: $table.analyticsOptOut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get biometricLock => $composableBuilder(
    column: $table.biometricLock,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<int> get quietHoursEnabled => $composableBuilder(
    column: $table.quietHoursEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get quietHoursStart => $composableBuilder(
    column: $table.quietHoursStart,
    builder: (column) => column,
  );

  GeneratedColumn<String> get quietHoursEnd => $composableBuilder(
    column: $table.quietHoursEnd,
    builder: (column) => column,
  );

  GeneratedColumn<int> get priorityThreshold => $composableBuilder(
    column: $table.priorityThreshold,
    builder: (column) => column,
  );

  GeneratedColumn<int> get retentionMaxAgeDays => $composableBuilder(
    column: $table.retentionMaxAgeDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get retentionMaxRows => $composableBuilder(
    column: $table.retentionMaxRows,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hideLockScreenContent => $composableBuilder(
    column: $table.hideLockScreenContent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get analyticsOptOut => $composableBuilder(
    column: $table.analyticsOptOut,
    builder: (column) => column,
  );

  GeneratedColumn<int> get biometricLock => $composableBuilder(
    column: $table.biometricLock,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<int> quietHoursEnabled = const Value.absent(),
                Value<String?> quietHoursStart = const Value.absent(),
                Value<String?> quietHoursEnd = const Value.absent(),
                Value<int> priorityThreshold = const Value.absent(),
                Value<int?> retentionMaxAgeDays = const Value.absent(),
                Value<int?> retentionMaxRows = const Value.absent(),
                Value<int> hideLockScreenContent = const Value.absent(),
                Value<int> analyticsOptOut = const Value.absent(),
                Value<int> biometricLock = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                themeMode: themeMode,
                quietHoursEnabled: quietHoursEnabled,
                quietHoursStart: quietHoursStart,
                quietHoursEnd: quietHoursEnd,
                priorityThreshold: priorityThreshold,
                retentionMaxAgeDays: retentionMaxAgeDays,
                retentionMaxRows: retentionMaxRows,
                hideLockScreenContent: hideLockScreenContent,
                analyticsOptOut: analyticsOptOut,
                biometricLock: biometricLock,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<int> quietHoursEnabled = const Value.absent(),
                Value<String?> quietHoursStart = const Value.absent(),
                Value<String?> quietHoursEnd = const Value.absent(),
                Value<int> priorityThreshold = const Value.absent(),
                Value<int?> retentionMaxAgeDays = const Value.absent(),
                Value<int?> retentionMaxRows = const Value.absent(),
                Value<int> hideLockScreenContent = const Value.absent(),
                Value<int> analyticsOptOut = const Value.absent(),
                Value<int> biometricLock = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                themeMode: themeMode,
                quietHoursEnabled: quietHoursEnabled,
                quietHoursStart: quietHoursStart,
                quietHoursEnd: quietHoursEnd,
                priorityThreshold: priorityThreshold,
                retentionMaxAgeDays: retentionMaxAgeDays,
                retentionMaxRows: retentionMaxRows,
                hideLockScreenContent: hideLockScreenContent,
                analyticsOptOut: analyticsOptOut,
                biometricLock: biometricLock,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ServerConfigsTableTableManager get serverConfigs =>
      $$ServerConfigsTableTableManager(_db, _db.serverConfigs);
  $$SubscriptionsTableTableManager get subscriptions =>
      $$SubscriptionsTableTableManager(_db, _db.subscriptions);
  $$NotificationMessagesTableTableManager get notificationMessages =>
      $$NotificationMessagesTableTableManager(_db, _db.notificationMessages);
  $$GroupsTableTableManager get groups =>
      $$GroupsTableTableManager(_db, _db.groups);
  $$GroupMembersTableTableManager get groupMembers =>
      $$GroupMembersTableTableManager(_db, _db.groupMembers);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
