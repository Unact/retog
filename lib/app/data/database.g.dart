// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _salesmanNameMeta =
      const VerificationMeta('salesmanName');
  @override
  late final GeneratedColumn<String> salesmanName = GeneratedColumn<String>(
      'salesman_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
      'version', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, username, salesmanName, email, version];
  @override
  String get aliasedName => _alias ?? 'users';
  @override
  String get actualTableName => 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('salesman_name')) {
      context.handle(
          _salesmanNameMeta,
          salesmanName.isAcceptableOrUnknown(
              data['salesman_name']!, _salesmanNameMeta));
    } else if (isInserting) {
      context.missing(_salesmanNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      salesmanName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}salesman_name'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String username;
  final String salesmanName;
  final String email;
  final String version;
  const User(
      {required this.id,
      required this.username,
      required this.salesmanName,
      required this.email,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    map['salesman_name'] = Variable<String>(salesmanName);
    map['email'] = Variable<String>(email);
    map['version'] = Variable<String>(version);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      username: Value(username),
      salesmanName: Value(salesmanName),
      email: Value(email),
      version: Value(version),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      salesmanName: serializer.fromJson<String>(json['salesmanName']),
      email: serializer.fromJson<String>(json['email']),
      version: serializer.fromJson<String>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'salesmanName': serializer.toJson<String>(salesmanName),
      'email': serializer.toJson<String>(email),
      'version': serializer.toJson<String>(version),
    };
  }

  User copyWith(
          {int? id,
          String? username,
          String? salesmanName,
          String? email,
          String? version}) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        salesmanName: salesmanName ?? this.salesmanName,
        email: email ?? this.email,
        version: version ?? this.version,
      );
  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('salesmanName: $salesmanName, ')
          ..write('email: $email, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, username, salesmanName, email, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.username == this.username &&
          other.salesmanName == this.salesmanName &&
          other.email == this.email &&
          other.version == this.version);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> username;
  final Value<String> salesmanName;
  final Value<String> email;
  final Value<String> version;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.salesmanName = const Value.absent(),
    this.email = const Value.absent(),
    this.version = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    required String salesmanName,
    required String email,
    required String version,
  })  : username = Value(username),
        salesmanName = Value(salesmanName),
        email = Value(email),
        version = Value(version);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? salesmanName,
    Expression<String>? email,
    Expression<String>? version,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (salesmanName != null) 'salesman_name': salesmanName,
      if (email != null) 'email': email,
      if (version != null) 'version': version,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? username,
      Value<String>? salesmanName,
      Value<String>? email,
      Value<String>? version}) {
    return UsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      salesmanName: salesmanName ?? this.salesmanName,
      email: email ?? this.email,
      version: version ?? this.version,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (salesmanName.present) {
      map['salesman_name'] = Variable<String>(salesmanName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('salesmanName: $salesmanName, ')
          ..write('email: $email, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }
}

class $PrefsTable extends Prefs with TableInfo<$PrefsTable, Pref> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrefsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lastSyncTimeMeta =
      const VerificationMeta('lastSyncTime');
  @override
  late final GeneratedColumn<DateTime> lastSyncTime = GeneratedColumn<DateTime>(
      'last_sync_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [lastSyncTime];
  @override
  String get aliasedName => _alias ?? 'prefs';
  @override
  String get actualTableName => 'prefs';
  @override
  VerificationContext validateIntegrity(Insertable<Pref> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('last_sync_time')) {
      context.handle(
          _lastSyncTimeMeta,
          lastSyncTime.isAcceptableOrUnknown(
              data['last_sync_time']!, _lastSyncTimeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Pref map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Pref(
      lastSyncTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_sync_time']),
    );
  }

  @override
  $PrefsTable createAlias(String alias) {
    return $PrefsTable(attachedDatabase, alias);
  }
}

class Pref extends DataClass implements Insertable<Pref> {
  final DateTime? lastSyncTime;
  const Pref({this.lastSyncTime});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || lastSyncTime != null) {
      map['last_sync_time'] = Variable<DateTime>(lastSyncTime);
    }
    return map;
  }

  PrefsCompanion toCompanion(bool nullToAbsent) {
    return PrefsCompanion(
      lastSyncTime: lastSyncTime == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncTime),
    );
  }

  factory Pref.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Pref(
      lastSyncTime: serializer.fromJson<DateTime?>(json['lastSyncTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lastSyncTime': serializer.toJson<DateTime?>(lastSyncTime),
    };
  }

  Pref copyWith({Value<DateTime?> lastSyncTime = const Value.absent()}) => Pref(
        lastSyncTime:
            lastSyncTime.present ? lastSyncTime.value : this.lastSyncTime,
      );
  @override
  String toString() {
    return (StringBuffer('Pref(')
          ..write('lastSyncTime: $lastSyncTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => lastSyncTime.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pref && other.lastSyncTime == this.lastSyncTime);
}

class PrefsCompanion extends UpdateCompanion<Pref> {
  final Value<DateTime?> lastSyncTime;
  final Value<int> rowid;
  const PrefsCompanion({
    this.lastSyncTime = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PrefsCompanion.insert({
    this.lastSyncTime = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<Pref> custom({
    Expression<DateTime>? lastSyncTime,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (lastSyncTime != null) 'last_sync_time': lastSyncTime,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PrefsCompanion copyWith({Value<DateTime?>? lastSyncTime, Value<int>? rowid}) {
    return PrefsCompanion(
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lastSyncTime.present) {
      map['last_sync_time'] = Variable<DateTime>(lastSyncTime.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrefsCompanion(')
          ..write('lastSyncTime: $lastSyncTime, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActsTable extends Acts with TableInfo<$ActsTable, Act> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
      'number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _typeNameMeta =
      const VerificationMeta('typeName');
  @override
  late final GeneratedColumn<String> typeName = GeneratedColumn<String>(
      'type_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _goodsCntMeta =
      const VerificationMeta('goodsCnt');
  @override
  late final GeneratedColumn<int> goodsCnt = GeneratedColumn<int>(
      'goods_cnt', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, number, typeName, goodsCnt];
  @override
  String get aliasedName => _alias ?? 'acts';
  @override
  String get actualTableName => 'acts';
  @override
  VerificationContext validateIntegrity(Insertable<Act> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('number')) {
      context.handle(_numberMeta,
          number.isAcceptableOrUnknown(data['number']!, _numberMeta));
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('type_name')) {
      context.handle(_typeNameMeta,
          typeName.isAcceptableOrUnknown(data['type_name']!, _typeNameMeta));
    } else if (isInserting) {
      context.missing(_typeNameMeta);
    }
    if (data.containsKey('goods_cnt')) {
      context.handle(_goodsCntMeta,
          goodsCnt.isAcceptableOrUnknown(data['goods_cnt']!, _goodsCntMeta));
    } else if (isInserting) {
      context.missing(_goodsCntMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Act map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Act(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      number: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}number'])!,
      typeName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type_name'])!,
      goodsCnt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}goods_cnt'])!,
    );
  }

  @override
  $ActsTable createAlias(String alias) {
    return $ActsTable(attachedDatabase, alias);
  }
}

class Act extends DataClass implements Insertable<Act> {
  final int id;
  final int number;
  final String typeName;
  final int goodsCnt;
  const Act(
      {required this.id,
      required this.number,
      required this.typeName,
      required this.goodsCnt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['number'] = Variable<int>(number);
    map['type_name'] = Variable<String>(typeName);
    map['goods_cnt'] = Variable<int>(goodsCnt);
    return map;
  }

  ActsCompanion toCompanion(bool nullToAbsent) {
    return ActsCompanion(
      id: Value(id),
      number: Value(number),
      typeName: Value(typeName),
      goodsCnt: Value(goodsCnt),
    );
  }

  factory Act.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Act(
      id: serializer.fromJson<int>(json['id']),
      number: serializer.fromJson<int>(json['number']),
      typeName: serializer.fromJson<String>(json['typeName']),
      goodsCnt: serializer.fromJson<int>(json['goodsCnt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'number': serializer.toJson<int>(number),
      'typeName': serializer.toJson<String>(typeName),
      'goodsCnt': serializer.toJson<int>(goodsCnt),
    };
  }

  Act copyWith({int? id, int? number, String? typeName, int? goodsCnt}) => Act(
        id: id ?? this.id,
        number: number ?? this.number,
        typeName: typeName ?? this.typeName,
        goodsCnt: goodsCnt ?? this.goodsCnt,
      );
  @override
  String toString() {
    return (StringBuffer('Act(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('typeName: $typeName, ')
          ..write('goodsCnt: $goodsCnt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, number, typeName, goodsCnt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Act &&
          other.id == this.id &&
          other.number == this.number &&
          other.typeName == this.typeName &&
          other.goodsCnt == this.goodsCnt);
}

class ActsCompanion extends UpdateCompanion<Act> {
  final Value<int> id;
  final Value<int> number;
  final Value<String> typeName;
  final Value<int> goodsCnt;
  const ActsCompanion({
    this.id = const Value.absent(),
    this.number = const Value.absent(),
    this.typeName = const Value.absent(),
    this.goodsCnt = const Value.absent(),
  });
  ActsCompanion.insert({
    this.id = const Value.absent(),
    required int number,
    required String typeName,
    required int goodsCnt,
  })  : number = Value(number),
        typeName = Value(typeName),
        goodsCnt = Value(goodsCnt);
  static Insertable<Act> custom({
    Expression<int>? id,
    Expression<int>? number,
    Expression<String>? typeName,
    Expression<int>? goodsCnt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (number != null) 'number': number,
      if (typeName != null) 'type_name': typeName,
      if (goodsCnt != null) 'goods_cnt': goodsCnt,
    });
  }

  ActsCompanion copyWith(
      {Value<int>? id,
      Value<int>? number,
      Value<String>? typeName,
      Value<int>? goodsCnt}) {
    return ActsCompanion(
      id: id ?? this.id,
      number: number ?? this.number,
      typeName: typeName ?? this.typeName,
      goodsCnt: goodsCnt ?? this.goodsCnt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (typeName.present) {
      map['type_name'] = Variable<String>(typeName.value);
    }
    if (goodsCnt.present) {
      map['goods_cnt'] = Variable<int>(goodsCnt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActsCompanion(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('typeName: $typeName, ')
          ..write('goodsCnt: $goodsCnt')
          ..write(')'))
        .toString();
  }
}

class $ReceptsTable extends Recepts with TableInfo<$ReceptsTable, Recept> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReceptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _ndocMeta = const VerificationMeta('ndoc');
  @override
  late final GeneratedColumn<String> ndoc = GeneratedColumn<String>(
      'ndoc', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ddateMeta = const VerificationMeta('ddate');
  @override
  late final GeneratedColumn<DateTime> ddate = GeneratedColumn<DateTime>(
      'ddate', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, ndoc, ddate];
  @override
  String get aliasedName => _alias ?? 'recepts';
  @override
  String get actualTableName => 'recepts';
  @override
  VerificationContext validateIntegrity(Insertable<Recept> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('ndoc')) {
      context.handle(
          _ndocMeta, ndoc.isAcceptableOrUnknown(data['ndoc']!, _ndocMeta));
    } else if (isInserting) {
      context.missing(_ndocMeta);
    }
    if (data.containsKey('ddate')) {
      context.handle(
          _ddateMeta, ddate.isAcceptableOrUnknown(data['ddate']!, _ddateMeta));
    } else if (isInserting) {
      context.missing(_ddateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Recept map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recept(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      ndoc: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ndoc'])!,
      ddate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}ddate'])!,
    );
  }

  @override
  $ReceptsTable createAlias(String alias) {
    return $ReceptsTable(attachedDatabase, alias);
  }
}

class Recept extends DataClass implements Insertable<Recept> {
  final int id;
  final String ndoc;
  final DateTime ddate;
  const Recept({required this.id, required this.ndoc, required this.ddate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['ndoc'] = Variable<String>(ndoc);
    map['ddate'] = Variable<DateTime>(ddate);
    return map;
  }

  ReceptsCompanion toCompanion(bool nullToAbsent) {
    return ReceptsCompanion(
      id: Value(id),
      ndoc: Value(ndoc),
      ddate: Value(ddate),
    );
  }

  factory Recept.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recept(
      id: serializer.fromJson<int>(json['id']),
      ndoc: serializer.fromJson<String>(json['ndoc']),
      ddate: serializer.fromJson<DateTime>(json['ddate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ndoc': serializer.toJson<String>(ndoc),
      'ddate': serializer.toJson<DateTime>(ddate),
    };
  }

  Recept copyWith({int? id, String? ndoc, DateTime? ddate}) => Recept(
        id: id ?? this.id,
        ndoc: ndoc ?? this.ndoc,
        ddate: ddate ?? this.ddate,
      );
  @override
  String toString() {
    return (StringBuffer('Recept(')
          ..write('id: $id, ')
          ..write('ndoc: $ndoc, ')
          ..write('ddate: $ddate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ndoc, ddate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recept &&
          other.id == this.id &&
          other.ndoc == this.ndoc &&
          other.ddate == this.ddate);
}

class ReceptsCompanion extends UpdateCompanion<Recept> {
  final Value<int> id;
  final Value<String> ndoc;
  final Value<DateTime> ddate;
  const ReceptsCompanion({
    this.id = const Value.absent(),
    this.ndoc = const Value.absent(),
    this.ddate = const Value.absent(),
  });
  ReceptsCompanion.insert({
    this.id = const Value.absent(),
    required String ndoc,
    required DateTime ddate,
  })  : ndoc = Value(ndoc),
        ddate = Value(ddate);
  static Insertable<Recept> custom({
    Expression<int>? id,
    Expression<String>? ndoc,
    Expression<DateTime>? ddate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ndoc != null) 'ndoc': ndoc,
      if (ddate != null) 'ddate': ddate,
    });
  }

  ReceptsCompanion copyWith(
      {Value<int>? id, Value<String>? ndoc, Value<DateTime>? ddate}) {
    return ReceptsCompanion(
      id: id ?? this.id,
      ndoc: ndoc ?? this.ndoc,
      ddate: ddate ?? this.ddate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ndoc.present) {
      map['ndoc'] = Variable<String>(ndoc.value);
    }
    if (ddate.present) {
      map['ddate'] = Variable<DateTime>(ddate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReceptsCompanion(')
          ..write('id: $id, ')
          ..write('ndoc: $ndoc, ')
          ..write('ddate: $ddate')
          ..write(')'))
        .toString();
  }
}

class $PartnersTable extends Partners with TableInfo<$PartnersTable, Partner> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartnersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? 'partners';
  @override
  String get actualTableName => 'partners';
  @override
  VerificationContext validateIntegrity(Insertable<Partner> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Partner map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Partner(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $PartnersTable createAlias(String alias) {
    return $PartnersTable(attachedDatabase, alias);
  }
}

class Partner extends DataClass implements Insertable<Partner> {
  final int id;
  final String name;
  const Partner({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  PartnersCompanion toCompanion(bool nullToAbsent) {
    return PartnersCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory Partner.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Partner(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Partner copyWith({int? id, String? name}) => Partner(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('Partner(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Partner && other.id == this.id && other.name == this.name);
}

class PartnersCompanion extends UpdateCompanion<Partner> {
  final Value<int> id;
  final Value<String> name;
  const PartnersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  PartnersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<Partner> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  PartnersCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return PartnersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartnersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $BuyersTable extends Buyers with TableInfo<$BuyersTable, Buyer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BuyersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _partnerIdMeta =
      const VerificationMeta('partnerId');
  @override
  late final GeneratedColumn<int> partnerId = GeneratedColumn<int>(
      'partner_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, partnerId];
  @override
  String get aliasedName => _alias ?? 'buyers';
  @override
  String get actualTableName => 'buyers';
  @override
  VerificationContext validateIntegrity(Insertable<Buyer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('partner_id')) {
      context.handle(_partnerIdMeta,
          partnerId.isAcceptableOrUnknown(data['partner_id']!, _partnerIdMeta));
    } else if (isInserting) {
      context.missing(_partnerIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Buyer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Buyer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      partnerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}partner_id'])!,
    );
  }

  @override
  $BuyersTable createAlias(String alias) {
    return $BuyersTable(attachedDatabase, alias);
  }
}

class Buyer extends DataClass implements Insertable<Buyer> {
  final int id;
  final String name;
  final int partnerId;
  const Buyer({required this.id, required this.name, required this.partnerId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['partner_id'] = Variable<int>(partnerId);
    return map;
  }

  BuyersCompanion toCompanion(bool nullToAbsent) {
    return BuyersCompanion(
      id: Value(id),
      name: Value(name),
      partnerId: Value(partnerId),
    );
  }

  factory Buyer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Buyer(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      partnerId: serializer.fromJson<int>(json['partnerId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'partnerId': serializer.toJson<int>(partnerId),
    };
  }

  Buyer copyWith({int? id, String? name, int? partnerId}) => Buyer(
        id: id ?? this.id,
        name: name ?? this.name,
        partnerId: partnerId ?? this.partnerId,
      );
  @override
  String toString() {
    return (StringBuffer('Buyer(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('partnerId: $partnerId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, partnerId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Buyer &&
          other.id == this.id &&
          other.name == this.name &&
          other.partnerId == this.partnerId);
}

class BuyersCompanion extends UpdateCompanion<Buyer> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> partnerId;
  const BuyersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.partnerId = const Value.absent(),
  });
  BuyersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int partnerId,
  })  : name = Value(name),
        partnerId = Value(partnerId);
  static Insertable<Buyer> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? partnerId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (partnerId != null) 'partner_id': partnerId,
    });
  }

  BuyersCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<int>? partnerId}) {
    return BuyersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      partnerId: partnerId ?? this.partnerId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (partnerId.present) {
      map['partner_id'] = Variable<int>(partnerId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BuyersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('partnerId: $partnerId')
          ..write(')'))
        .toString();
  }
}

class $PartnerReturnTypesTable extends PartnerReturnTypes
    with TableInfo<$PartnerReturnTypesTable, PartnerReturnType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartnerReturnTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _partnerIdMeta =
      const VerificationMeta('partnerId');
  @override
  late final GeneratedColumn<int> partnerId = GeneratedColumn<int>(
      'partner_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _returnTypeIdMeta =
      const VerificationMeta('returnTypeId');
  @override
  late final GeneratedColumn<int> returnTypeId = GeneratedColumn<int>(
      'return_type_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [partnerId, returnTypeId];
  @override
  String get aliasedName => _alias ?? 'partner_return_types';
  @override
  String get actualTableName => 'partner_return_types';
  @override
  VerificationContext validateIntegrity(Insertable<PartnerReturnType> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('partner_id')) {
      context.handle(_partnerIdMeta,
          partnerId.isAcceptableOrUnknown(data['partner_id']!, _partnerIdMeta));
    } else if (isInserting) {
      context.missing(_partnerIdMeta);
    }
    if (data.containsKey('return_type_id')) {
      context.handle(
          _returnTypeIdMeta,
          returnTypeId.isAcceptableOrUnknown(
              data['return_type_id']!, _returnTypeIdMeta));
    } else if (isInserting) {
      context.missing(_returnTypeIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {partnerId, returnTypeId};
  @override
  PartnerReturnType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartnerReturnType(
      partnerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}partner_id'])!,
      returnTypeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}return_type_id'])!,
    );
  }

  @override
  $PartnerReturnTypesTable createAlias(String alias) {
    return $PartnerReturnTypesTable(attachedDatabase, alias);
  }
}

class PartnerReturnType extends DataClass
    implements Insertable<PartnerReturnType> {
  final int partnerId;
  final int returnTypeId;
  const PartnerReturnType(
      {required this.partnerId, required this.returnTypeId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['partner_id'] = Variable<int>(partnerId);
    map['return_type_id'] = Variable<int>(returnTypeId);
    return map;
  }

  PartnerReturnTypesCompanion toCompanion(bool nullToAbsent) {
    return PartnerReturnTypesCompanion(
      partnerId: Value(partnerId),
      returnTypeId: Value(returnTypeId),
    );
  }

  factory PartnerReturnType.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartnerReturnType(
      partnerId: serializer.fromJson<int>(json['partnerId']),
      returnTypeId: serializer.fromJson<int>(json['returnTypeId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'partnerId': serializer.toJson<int>(partnerId),
      'returnTypeId': serializer.toJson<int>(returnTypeId),
    };
  }

  PartnerReturnType copyWith({int? partnerId, int? returnTypeId}) =>
      PartnerReturnType(
        partnerId: partnerId ?? this.partnerId,
        returnTypeId: returnTypeId ?? this.returnTypeId,
      );
  @override
  String toString() {
    return (StringBuffer('PartnerReturnType(')
          ..write('partnerId: $partnerId, ')
          ..write('returnTypeId: $returnTypeId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(partnerId, returnTypeId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartnerReturnType &&
          other.partnerId == this.partnerId &&
          other.returnTypeId == this.returnTypeId);
}

class PartnerReturnTypesCompanion extends UpdateCompanion<PartnerReturnType> {
  final Value<int> partnerId;
  final Value<int> returnTypeId;
  final Value<int> rowid;
  const PartnerReturnTypesCompanion({
    this.partnerId = const Value.absent(),
    this.returnTypeId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PartnerReturnTypesCompanion.insert({
    required int partnerId,
    required int returnTypeId,
    this.rowid = const Value.absent(),
  })  : partnerId = Value(partnerId),
        returnTypeId = Value(returnTypeId);
  static Insertable<PartnerReturnType> custom({
    Expression<int>? partnerId,
    Expression<int>? returnTypeId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (partnerId != null) 'partner_id': partnerId,
      if (returnTypeId != null) 'return_type_id': returnTypeId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PartnerReturnTypesCompanion copyWith(
      {Value<int>? partnerId, Value<int>? returnTypeId, Value<int>? rowid}) {
    return PartnerReturnTypesCompanion(
      partnerId: partnerId ?? this.partnerId,
      returnTypeId: returnTypeId ?? this.returnTypeId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (partnerId.present) {
      map['partner_id'] = Variable<int>(partnerId.value);
    }
    if (returnTypeId.present) {
      map['return_type_id'] = Variable<int>(returnTypeId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartnerReturnTypesCompanion(')
          ..write('partnerId: $partnerId, ')
          ..write('returnTypeId: $returnTypeId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReturnTypesTable extends ReturnTypes
    with TableInfo<$ReturnTypesTable, ReturnType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReturnTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? 'return_types';
  @override
  String get actualTableName => 'return_types';
  @override
  VerificationContext validateIntegrity(Insertable<ReturnType> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReturnType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReturnType(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $ReturnTypesTable createAlias(String alias) {
    return $ReturnTypesTable(attachedDatabase, alias);
  }
}

class ReturnType extends DataClass implements Insertable<ReturnType> {
  final int id;
  final String name;
  const ReturnType({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  ReturnTypesCompanion toCompanion(bool nullToAbsent) {
    return ReturnTypesCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory ReturnType.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReturnType(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  ReturnType copyWith({int? id, String? name}) => ReturnType(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('ReturnType(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReturnType && other.id == this.id && other.name == this.name);
}

class ReturnTypesCompanion extends UpdateCompanion<ReturnType> {
  final Value<int> id;
  final Value<String> name;
  const ReturnTypesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  ReturnTypesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<ReturnType> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  ReturnTypesCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return ReturnTypesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReturnTypesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $ReturnOrdersTable extends ReturnOrders
    with TableInfo<$ReturnOrdersTable, ReturnOrder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReturnOrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _buyerIdMeta =
      const VerificationMeta('buyerId');
  @override
  late final GeneratedColumn<int> buyerId = GeneratedColumn<int>(
      'buyer_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _needPickupMeta =
      const VerificationMeta('needPickup');
  @override
  late final GeneratedColumn<bool> needPickup = GeneratedColumn<bool>(
      'need_pickup', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("need_pickup" IN (0, 1))'));
  static const VerificationMeta _returnTypeIdMeta =
      const VerificationMeta('returnTypeId');
  @override
  late final GeneratedColumn<int> returnTypeId = GeneratedColumn<int>(
      'return_type_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _receptIdMeta =
      const VerificationMeta('receptId');
  @override
  late final GeneratedColumn<int> receptId = GeneratedColumn<int>(
      'recept_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, buyerId, needPickup, returnTypeId, receptId];
  @override
  String get aliasedName => _alias ?? 'return_orders';
  @override
  String get actualTableName => 'return_orders';
  @override
  VerificationContext validateIntegrity(Insertable<ReturnOrder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('buyer_id')) {
      context.handle(_buyerIdMeta,
          buyerId.isAcceptableOrUnknown(data['buyer_id']!, _buyerIdMeta));
    } else if (isInserting) {
      context.missing(_buyerIdMeta);
    }
    if (data.containsKey('need_pickup')) {
      context.handle(
          _needPickupMeta,
          needPickup.isAcceptableOrUnknown(
              data['need_pickup']!, _needPickupMeta));
    } else if (isInserting) {
      context.missing(_needPickupMeta);
    }
    if (data.containsKey('return_type_id')) {
      context.handle(
          _returnTypeIdMeta,
          returnTypeId.isAcceptableOrUnknown(
              data['return_type_id']!, _returnTypeIdMeta));
    }
    if (data.containsKey('recept_id')) {
      context.handle(_receptIdMeta,
          receptId.isAcceptableOrUnknown(data['recept_id']!, _receptIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReturnOrder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReturnOrder(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      buyerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}buyer_id'])!,
      needPickup: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}need_pickup'])!,
      returnTypeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}return_type_id']),
      receptId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recept_id']),
    );
  }

  @override
  $ReturnOrdersTable createAlias(String alias) {
    return $ReturnOrdersTable(attachedDatabase, alias);
  }
}

class ReturnOrder extends DataClass implements Insertable<ReturnOrder> {
  final int id;
  final int buyerId;
  final bool needPickup;
  final int? returnTypeId;
  final int? receptId;
  const ReturnOrder(
      {required this.id,
      required this.buyerId,
      required this.needPickup,
      this.returnTypeId,
      this.receptId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['buyer_id'] = Variable<int>(buyerId);
    map['need_pickup'] = Variable<bool>(needPickup);
    if (!nullToAbsent || returnTypeId != null) {
      map['return_type_id'] = Variable<int>(returnTypeId);
    }
    if (!nullToAbsent || receptId != null) {
      map['recept_id'] = Variable<int>(receptId);
    }
    return map;
  }

  ReturnOrdersCompanion toCompanion(bool nullToAbsent) {
    return ReturnOrdersCompanion(
      id: Value(id),
      buyerId: Value(buyerId),
      needPickup: Value(needPickup),
      returnTypeId: returnTypeId == null && nullToAbsent
          ? const Value.absent()
          : Value(returnTypeId),
      receptId: receptId == null && nullToAbsent
          ? const Value.absent()
          : Value(receptId),
    );
  }

  factory ReturnOrder.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReturnOrder(
      id: serializer.fromJson<int>(json['id']),
      buyerId: serializer.fromJson<int>(json['buyerId']),
      needPickup: serializer.fromJson<bool>(json['needPickup']),
      returnTypeId: serializer.fromJson<int?>(json['returnTypeId']),
      receptId: serializer.fromJson<int?>(json['receptId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'buyerId': serializer.toJson<int>(buyerId),
      'needPickup': serializer.toJson<bool>(needPickup),
      'returnTypeId': serializer.toJson<int?>(returnTypeId),
      'receptId': serializer.toJson<int?>(receptId),
    };
  }

  ReturnOrder copyWith(
          {int? id,
          int? buyerId,
          bool? needPickup,
          Value<int?> returnTypeId = const Value.absent(),
          Value<int?> receptId = const Value.absent()}) =>
      ReturnOrder(
        id: id ?? this.id,
        buyerId: buyerId ?? this.buyerId,
        needPickup: needPickup ?? this.needPickup,
        returnTypeId:
            returnTypeId.present ? returnTypeId.value : this.returnTypeId,
        receptId: receptId.present ? receptId.value : this.receptId,
      );
  @override
  String toString() {
    return (StringBuffer('ReturnOrder(')
          ..write('id: $id, ')
          ..write('buyerId: $buyerId, ')
          ..write('needPickup: $needPickup, ')
          ..write('returnTypeId: $returnTypeId, ')
          ..write('receptId: $receptId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, buyerId, needPickup, returnTypeId, receptId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReturnOrder &&
          other.id == this.id &&
          other.buyerId == this.buyerId &&
          other.needPickup == this.needPickup &&
          other.returnTypeId == this.returnTypeId &&
          other.receptId == this.receptId);
}

class ReturnOrdersCompanion extends UpdateCompanion<ReturnOrder> {
  final Value<int> id;
  final Value<int> buyerId;
  final Value<bool> needPickup;
  final Value<int?> returnTypeId;
  final Value<int?> receptId;
  const ReturnOrdersCompanion({
    this.id = const Value.absent(),
    this.buyerId = const Value.absent(),
    this.needPickup = const Value.absent(),
    this.returnTypeId = const Value.absent(),
    this.receptId = const Value.absent(),
  });
  ReturnOrdersCompanion.insert({
    this.id = const Value.absent(),
    required int buyerId,
    required bool needPickup,
    this.returnTypeId = const Value.absent(),
    this.receptId = const Value.absent(),
  })  : buyerId = Value(buyerId),
        needPickup = Value(needPickup);
  static Insertable<ReturnOrder> custom({
    Expression<int>? id,
    Expression<int>? buyerId,
    Expression<bool>? needPickup,
    Expression<int>? returnTypeId,
    Expression<int>? receptId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (buyerId != null) 'buyer_id': buyerId,
      if (needPickup != null) 'need_pickup': needPickup,
      if (returnTypeId != null) 'return_type_id': returnTypeId,
      if (receptId != null) 'recept_id': receptId,
    });
  }

  ReturnOrdersCompanion copyWith(
      {Value<int>? id,
      Value<int>? buyerId,
      Value<bool>? needPickup,
      Value<int?>? returnTypeId,
      Value<int?>? receptId}) {
    return ReturnOrdersCompanion(
      id: id ?? this.id,
      buyerId: buyerId ?? this.buyerId,
      needPickup: needPickup ?? this.needPickup,
      returnTypeId: returnTypeId ?? this.returnTypeId,
      receptId: receptId ?? this.receptId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (buyerId.present) {
      map['buyer_id'] = Variable<int>(buyerId.value);
    }
    if (needPickup.present) {
      map['need_pickup'] = Variable<bool>(needPickup.value);
    }
    if (returnTypeId.present) {
      map['return_type_id'] = Variable<int>(returnTypeId.value);
    }
    if (receptId.present) {
      map['recept_id'] = Variable<int>(receptId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReturnOrdersCompanion(')
          ..write('id: $id, ')
          ..write('buyerId: $buyerId, ')
          ..write('needPickup: $needPickup, ')
          ..write('returnTypeId: $returnTypeId, ')
          ..write('receptId: $receptId')
          ..write(')'))
        .toString();
  }
}

class $ReturnOrderLinesTable extends ReturnOrderLines
    with TableInfo<$ReturnOrderLinesTable, ReturnOrderLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReturnOrderLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _returnOrderIdMeta =
      const VerificationMeta('returnOrderId');
  @override
  late final GeneratedColumn<int> returnOrderId = GeneratedColumn<int>(
      'return_order_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _goodsIdMeta =
      const VerificationMeta('goodsId');
  @override
  late final GeneratedColumn<int> goodsId = GeneratedColumn<int>(
      'goods_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _volumeMeta = const VerificationMeta('volume');
  @override
  late final GeneratedColumn<int> volume = GeneratedColumn<int>(
      'volume', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _productionDateMeta =
      const VerificationMeta('productionDate');
  @override
  late final GeneratedColumn<DateTime> productionDate =
      GeneratedColumn<DateTime>('production_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isBadMeta = const VerificationMeta('isBad');
  @override
  late final GeneratedColumn<bool> isBad = GeneratedColumn<bool>(
      'is_bad', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_bad" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, returnOrderId, goodsId, volume, productionDate, isBad];
  @override
  String get aliasedName => _alias ?? 'return_order_lines';
  @override
  String get actualTableName => 'return_order_lines';
  @override
  VerificationContext validateIntegrity(Insertable<ReturnOrderLine> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('return_order_id')) {
      context.handle(
          _returnOrderIdMeta,
          returnOrderId.isAcceptableOrUnknown(
              data['return_order_id']!, _returnOrderIdMeta));
    } else if (isInserting) {
      context.missing(_returnOrderIdMeta);
    }
    if (data.containsKey('goods_id')) {
      context.handle(_goodsIdMeta,
          goodsId.isAcceptableOrUnknown(data['goods_id']!, _goodsIdMeta));
    }
    if (data.containsKey('volume')) {
      context.handle(_volumeMeta,
          volume.isAcceptableOrUnknown(data['volume']!, _volumeMeta));
    }
    if (data.containsKey('production_date')) {
      context.handle(
          _productionDateMeta,
          productionDate.isAcceptableOrUnknown(
              data['production_date']!, _productionDateMeta));
    }
    if (data.containsKey('is_bad')) {
      context.handle(
          _isBadMeta, isBad.isAcceptableOrUnknown(data['is_bad']!, _isBadMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReturnOrderLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReturnOrderLine(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      returnOrderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}return_order_id'])!,
      goodsId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}goods_id']),
      volume: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}volume']),
      productionDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}production_date']),
      isBad: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_bad']),
    );
  }

  @override
  $ReturnOrderLinesTable createAlias(String alias) {
    return $ReturnOrderLinesTable(attachedDatabase, alias);
  }
}

class ReturnOrderLine extends DataClass implements Insertable<ReturnOrderLine> {
  final int id;
  final int returnOrderId;
  final int? goodsId;
  final int? volume;
  final DateTime? productionDate;
  final bool? isBad;
  const ReturnOrderLine(
      {required this.id,
      required this.returnOrderId,
      this.goodsId,
      this.volume,
      this.productionDate,
      this.isBad});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['return_order_id'] = Variable<int>(returnOrderId);
    if (!nullToAbsent || goodsId != null) {
      map['goods_id'] = Variable<int>(goodsId);
    }
    if (!nullToAbsent || volume != null) {
      map['volume'] = Variable<int>(volume);
    }
    if (!nullToAbsent || productionDate != null) {
      map['production_date'] = Variable<DateTime>(productionDate);
    }
    if (!nullToAbsent || isBad != null) {
      map['is_bad'] = Variable<bool>(isBad);
    }
    return map;
  }

  ReturnOrderLinesCompanion toCompanion(bool nullToAbsent) {
    return ReturnOrderLinesCompanion(
      id: Value(id),
      returnOrderId: Value(returnOrderId),
      goodsId: goodsId == null && nullToAbsent
          ? const Value.absent()
          : Value(goodsId),
      volume:
          volume == null && nullToAbsent ? const Value.absent() : Value(volume),
      productionDate: productionDate == null && nullToAbsent
          ? const Value.absent()
          : Value(productionDate),
      isBad:
          isBad == null && nullToAbsent ? const Value.absent() : Value(isBad),
    );
  }

  factory ReturnOrderLine.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReturnOrderLine(
      id: serializer.fromJson<int>(json['id']),
      returnOrderId: serializer.fromJson<int>(json['returnOrderId']),
      goodsId: serializer.fromJson<int?>(json['goodsId']),
      volume: serializer.fromJson<int?>(json['volume']),
      productionDate: serializer.fromJson<DateTime?>(json['productionDate']),
      isBad: serializer.fromJson<bool?>(json['isBad']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'returnOrderId': serializer.toJson<int>(returnOrderId),
      'goodsId': serializer.toJson<int?>(goodsId),
      'volume': serializer.toJson<int?>(volume),
      'productionDate': serializer.toJson<DateTime?>(productionDate),
      'isBad': serializer.toJson<bool?>(isBad),
    };
  }

  ReturnOrderLine copyWith(
          {int? id,
          int? returnOrderId,
          Value<int?> goodsId = const Value.absent(),
          Value<int?> volume = const Value.absent(),
          Value<DateTime?> productionDate = const Value.absent(),
          Value<bool?> isBad = const Value.absent()}) =>
      ReturnOrderLine(
        id: id ?? this.id,
        returnOrderId: returnOrderId ?? this.returnOrderId,
        goodsId: goodsId.present ? goodsId.value : this.goodsId,
        volume: volume.present ? volume.value : this.volume,
        productionDate:
            productionDate.present ? productionDate.value : this.productionDate,
        isBad: isBad.present ? isBad.value : this.isBad,
      );
  @override
  String toString() {
    return (StringBuffer('ReturnOrderLine(')
          ..write('id: $id, ')
          ..write('returnOrderId: $returnOrderId, ')
          ..write('goodsId: $goodsId, ')
          ..write('volume: $volume, ')
          ..write('productionDate: $productionDate, ')
          ..write('isBad: $isBad')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, returnOrderId, goodsId, volume, productionDate, isBad);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReturnOrderLine &&
          other.id == this.id &&
          other.returnOrderId == this.returnOrderId &&
          other.goodsId == this.goodsId &&
          other.volume == this.volume &&
          other.productionDate == this.productionDate &&
          other.isBad == this.isBad);
}

class ReturnOrderLinesCompanion extends UpdateCompanion<ReturnOrderLine> {
  final Value<int> id;
  final Value<int> returnOrderId;
  final Value<int?> goodsId;
  final Value<int?> volume;
  final Value<DateTime?> productionDate;
  final Value<bool?> isBad;
  const ReturnOrderLinesCompanion({
    this.id = const Value.absent(),
    this.returnOrderId = const Value.absent(),
    this.goodsId = const Value.absent(),
    this.volume = const Value.absent(),
    this.productionDate = const Value.absent(),
    this.isBad = const Value.absent(),
  });
  ReturnOrderLinesCompanion.insert({
    this.id = const Value.absent(),
    required int returnOrderId,
    this.goodsId = const Value.absent(),
    this.volume = const Value.absent(),
    this.productionDate = const Value.absent(),
    this.isBad = const Value.absent(),
  }) : returnOrderId = Value(returnOrderId);
  static Insertable<ReturnOrderLine> custom({
    Expression<int>? id,
    Expression<int>? returnOrderId,
    Expression<int>? goodsId,
    Expression<int>? volume,
    Expression<DateTime>? productionDate,
    Expression<bool>? isBad,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (returnOrderId != null) 'return_order_id': returnOrderId,
      if (goodsId != null) 'goods_id': goodsId,
      if (volume != null) 'volume': volume,
      if (productionDate != null) 'production_date': productionDate,
      if (isBad != null) 'is_bad': isBad,
    });
  }

  ReturnOrderLinesCompanion copyWith(
      {Value<int>? id,
      Value<int>? returnOrderId,
      Value<int?>? goodsId,
      Value<int?>? volume,
      Value<DateTime?>? productionDate,
      Value<bool?>? isBad}) {
    return ReturnOrderLinesCompanion(
      id: id ?? this.id,
      returnOrderId: returnOrderId ?? this.returnOrderId,
      goodsId: goodsId ?? this.goodsId,
      volume: volume ?? this.volume,
      productionDate: productionDate ?? this.productionDate,
      isBad: isBad ?? this.isBad,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (returnOrderId.present) {
      map['return_order_id'] = Variable<int>(returnOrderId.value);
    }
    if (goodsId.present) {
      map['goods_id'] = Variable<int>(goodsId.value);
    }
    if (volume.present) {
      map['volume'] = Variable<int>(volume.value);
    }
    if (productionDate.present) {
      map['production_date'] = Variable<DateTime>(productionDate.value);
    }
    if (isBad.present) {
      map['is_bad'] = Variable<bool>(isBad.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReturnOrderLinesCompanion(')
          ..write('id: $id, ')
          ..write('returnOrderId: $returnOrderId, ')
          ..write('goodsId: $goodsId, ')
          ..write('volume: $volume, ')
          ..write('productionDate: $productionDate, ')
          ..write('isBad: $isBad')
          ..write(')'))
        .toString();
  }
}

class $AllGoodsTable extends AllGoods with TableInfo<$AllGoodsTable, Goods> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AllGoodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _leftVolumeMeta =
      const VerificationMeta('leftVolume');
  @override
  late final GeneratedColumn<int> leftVolume = GeneratedColumn<int>(
      'left_volume', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, leftVolume];
  @override
  String get aliasedName => _alias ?? 'goods';
  @override
  String get actualTableName => 'goods';
  @override
  VerificationContext validateIntegrity(Insertable<Goods> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('left_volume')) {
      context.handle(
          _leftVolumeMeta,
          leftVolume.isAcceptableOrUnknown(
              data['left_volume']!, _leftVolumeMeta));
    } else if (isInserting) {
      context.missing(_leftVolumeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Goods map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Goods(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      leftVolume: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}left_volume'])!,
    );
  }

  @override
  $AllGoodsTable createAlias(String alias) {
    return $AllGoodsTable(attachedDatabase, alias);
  }
}

class Goods extends DataClass implements Insertable<Goods> {
  final int id;
  final String name;
  final int leftVolume;
  const Goods({required this.id, required this.name, required this.leftVolume});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['left_volume'] = Variable<int>(leftVolume);
    return map;
  }

  AllGoodsCompanion toCompanion(bool nullToAbsent) {
    return AllGoodsCompanion(
      id: Value(id),
      name: Value(name),
      leftVolume: Value(leftVolume),
    );
  }

  factory Goods.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Goods(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      leftVolume: serializer.fromJson<int>(json['leftVolume']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'leftVolume': serializer.toJson<int>(leftVolume),
    };
  }

  Goods copyWith({int? id, String? name, int? leftVolume}) => Goods(
        id: id ?? this.id,
        name: name ?? this.name,
        leftVolume: leftVolume ?? this.leftVolume,
      );
  @override
  String toString() {
    return (StringBuffer('Goods(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('leftVolume: $leftVolume')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, leftVolume);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Goods &&
          other.id == this.id &&
          other.name == this.name &&
          other.leftVolume == this.leftVolume);
}

class AllGoodsCompanion extends UpdateCompanion<Goods> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> leftVolume;
  const AllGoodsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.leftVolume = const Value.absent(),
  });
  AllGoodsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int leftVolume,
  })  : name = Value(name),
        leftVolume = Value(leftVolume);
  static Insertable<Goods> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? leftVolume,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (leftVolume != null) 'left_volume': leftVolume,
    });
  }

  AllGoodsCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<int>? leftVolume}) {
    return AllGoodsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      leftVolume: leftVolume ?? this.leftVolume,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (leftVolume.present) {
      map['left_volume'] = Variable<int>(leftVolume.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AllGoodsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('leftVolume: $leftVolume')
          ..write(')'))
        .toString();
  }
}

class $GoodsBarcodesTable extends GoodsBarcodes
    with TableInfo<$GoodsBarcodesTable, GoodsBarcode> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoodsBarcodesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _goodsIdMeta =
      const VerificationMeta('goodsId');
  @override
  late final GeneratedColumn<int> goodsId = GeneratedColumn<int>(
      'goods_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _barcodeMeta =
      const VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
      'barcode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [goodsId, barcode];
  @override
  String get aliasedName => _alias ?? 'goods_barcodes';
  @override
  String get actualTableName => 'goods_barcodes';
  @override
  VerificationContext validateIntegrity(Insertable<GoodsBarcode> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('goods_id')) {
      context.handle(_goodsIdMeta,
          goodsId.isAcceptableOrUnknown(data['goods_id']!, _goodsIdMeta));
    } else if (isInserting) {
      context.missing(_goodsIdMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta,
          barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    } else if (isInserting) {
      context.missing(_barcodeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {goodsId, barcode};
  @override
  GoodsBarcode map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoodsBarcode(
      goodsId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}goods_id'])!,
      barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode'])!,
    );
  }

  @override
  $GoodsBarcodesTable createAlias(String alias) {
    return $GoodsBarcodesTable(attachedDatabase, alias);
  }
}

class GoodsBarcode extends DataClass implements Insertable<GoodsBarcode> {
  final int goodsId;
  final String barcode;
  const GoodsBarcode({required this.goodsId, required this.barcode});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['goods_id'] = Variable<int>(goodsId);
    map['barcode'] = Variable<String>(barcode);
    return map;
  }

  GoodsBarcodesCompanion toCompanion(bool nullToAbsent) {
    return GoodsBarcodesCompanion(
      goodsId: Value(goodsId),
      barcode: Value(barcode),
    );
  }

  factory GoodsBarcode.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoodsBarcode(
      goodsId: serializer.fromJson<int>(json['goodsId']),
      barcode: serializer.fromJson<String>(json['barcode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'goodsId': serializer.toJson<int>(goodsId),
      'barcode': serializer.toJson<String>(barcode),
    };
  }

  GoodsBarcode copyWith({int? goodsId, String? barcode}) => GoodsBarcode(
        goodsId: goodsId ?? this.goodsId,
        barcode: barcode ?? this.barcode,
      );
  @override
  String toString() {
    return (StringBuffer('GoodsBarcode(')
          ..write('goodsId: $goodsId, ')
          ..write('barcode: $barcode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(goodsId, barcode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoodsBarcode &&
          other.goodsId == this.goodsId &&
          other.barcode == this.barcode);
}

class GoodsBarcodesCompanion extends UpdateCompanion<GoodsBarcode> {
  final Value<int> goodsId;
  final Value<String> barcode;
  final Value<int> rowid;
  const GoodsBarcodesCompanion({
    this.goodsId = const Value.absent(),
    this.barcode = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoodsBarcodesCompanion.insert({
    required int goodsId,
    required String barcode,
    this.rowid = const Value.absent(),
  })  : goodsId = Value(goodsId),
        barcode = Value(barcode);
  static Insertable<GoodsBarcode> custom({
    Expression<int>? goodsId,
    Expression<String>? barcode,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (goodsId != null) 'goods_id': goodsId,
      if (barcode != null) 'barcode': barcode,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoodsBarcodesCompanion copyWith(
      {Value<int>? goodsId, Value<String>? barcode, Value<int>? rowid}) {
    return GoodsBarcodesCompanion(
      goodsId: goodsId ?? this.goodsId,
      barcode: barcode ?? this.barcode,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (goodsId.present) {
      map['goods_id'] = Variable<int>(goodsId.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoodsBarcodesCompanion(')
          ..write('goodsId: $goodsId, ')
          ..write('barcode: $barcode, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDataStore extends GeneratedDatabase {
  _$AppDataStore(QueryExecutor e) : super(e);
  late final $UsersTable users = $UsersTable(this);
  late final $PrefsTable prefs = $PrefsTable(this);
  late final $ActsTable acts = $ActsTable(this);
  late final $ReceptsTable recepts = $ReceptsTable(this);
  late final $PartnersTable partners = $PartnersTable(this);
  late final $BuyersTable buyers = $BuyersTable(this);
  late final $PartnerReturnTypesTable partnerReturnTypes =
      $PartnerReturnTypesTable(this);
  late final $ReturnTypesTable returnTypes = $ReturnTypesTable(this);
  late final $ReturnOrdersTable returnOrders = $ReturnOrdersTable(this);
  late final $ReturnOrderLinesTable returnOrderLines =
      $ReturnOrderLinesTable(this);
  late final $AllGoodsTable allGoods = $AllGoodsTable(this);
  late final $GoodsBarcodesTable goodsBarcodes = $GoodsBarcodesTable(this);
  late final ReturnsDao returnsDao = ReturnsDao(this as AppDataStore);
  late final UsersDao usersDao = UsersDao(this as AppDataStore);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        users,
        prefs,
        acts,
        recepts,
        partners,
        buyers,
        partnerReturnTypes,
        returnTypes,
        returnOrders,
        returnOrderLines,
        allGoods,
        goodsBarcodes
      ];
}

mixin _$ReturnsDaoMixin on DatabaseAccessor<AppDataStore> {
  $ActsTable get acts => attachedDatabase.acts;
  $BuyersTable get buyers => attachedDatabase.buyers;
  $PartnersTable get partners => attachedDatabase.partners;
  $ReceptsTable get recepts => attachedDatabase.recepts;
  $ReturnOrdersTable get returnOrders => attachedDatabase.returnOrders;
  $ReturnOrderLinesTable get returnOrderLines =>
      attachedDatabase.returnOrderLines;
  $ReturnTypesTable get returnTypes => attachedDatabase.returnTypes;
  $PartnerReturnTypesTable get partnerReturnTypes =>
      attachedDatabase.partnerReturnTypes;
  $AllGoodsTable get allGoods => attachedDatabase.allGoods;
  $GoodsBarcodesTable get goodsBarcodes => attachedDatabase.goodsBarcodes;
}
mixin _$UsersDaoMixin on DatabaseAccessor<AppDataStore> {
  $UsersTable get users => attachedDatabase.users;
}
