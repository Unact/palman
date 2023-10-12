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
  static const VerificationMeta _preOrderModeMeta =
      const VerificationMeta('preOrderMode');
  @override
  late final GeneratedColumn<bool> preOrderMode =
      GeneratedColumn<bool>('pre_order_mode', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("pre_order_mode" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
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
      [id, username, salesmanName, preOrderMode, email, version];
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
    if (data.containsKey('pre_order_mode')) {
      context.handle(
          _preOrderModeMeta,
          preOrderMode.isAcceptableOrUnknown(
              data['pre_order_mode']!, _preOrderModeMeta));
    } else if (isInserting) {
      context.missing(_preOrderModeMeta);
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
      preOrderMode: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}pre_order_mode'])!,
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
  final bool preOrderMode;
  final String email;
  final String version;
  const User(
      {required this.id,
      required this.username,
      required this.salesmanName,
      required this.preOrderMode,
      required this.email,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    map['salesman_name'] = Variable<String>(salesmanName);
    map['pre_order_mode'] = Variable<bool>(preOrderMode);
    map['email'] = Variable<String>(email);
    map['version'] = Variable<String>(version);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      username: Value(username),
      salesmanName: Value(salesmanName),
      preOrderMode: Value(preOrderMode),
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
      preOrderMode: serializer.fromJson<bool>(json['preOrderMode']),
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
      'preOrderMode': serializer.toJson<bool>(preOrderMode),
      'email': serializer.toJson<String>(email),
      'version': serializer.toJson<String>(version),
    };
  }

  User copyWith(
          {int? id,
          String? username,
          String? salesmanName,
          bool? preOrderMode,
          String? email,
          String? version}) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        salesmanName: salesmanName ?? this.salesmanName,
        preOrderMode: preOrderMode ?? this.preOrderMode,
        email: email ?? this.email,
        version: version ?? this.version,
      );
  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('salesmanName: $salesmanName, ')
          ..write('preOrderMode: $preOrderMode, ')
          ..write('email: $email, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, username, salesmanName, preOrderMode, email, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.username == this.username &&
          other.salesmanName == this.salesmanName &&
          other.preOrderMode == this.preOrderMode &&
          other.email == this.email &&
          other.version == this.version);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> username;
  final Value<String> salesmanName;
  final Value<bool> preOrderMode;
  final Value<String> email;
  final Value<String> version;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.salesmanName = const Value.absent(),
    this.preOrderMode = const Value.absent(),
    this.email = const Value.absent(),
    this.version = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    required String salesmanName,
    required bool preOrderMode,
    required String email,
    required String version,
  })  : username = Value(username),
        salesmanName = Value(salesmanName),
        preOrderMode = Value(preOrderMode),
        email = Value(email),
        version = Value(version);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? salesmanName,
    Expression<bool>? preOrderMode,
    Expression<String>? email,
    Expression<String>? version,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (salesmanName != null) 'salesman_name': salesmanName,
      if (preOrderMode != null) 'pre_order_mode': preOrderMode,
      if (email != null) 'email': email,
      if (version != null) 'version': version,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? username,
      Value<String>? salesmanName,
      Value<bool>? preOrderMode,
      Value<String>? email,
      Value<String>? version}) {
    return UsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      salesmanName: salesmanName ?? this.salesmanName,
      preOrderMode: preOrderMode ?? this.preOrderMode,
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
    if (preOrderMode.present) {
      map['pre_order_mode'] = Variable<bool>(preOrderMode.value);
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
          ..write('preOrderMode: $preOrderMode, ')
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
  static const VerificationMeta _showLocalImageMeta =
      const VerificationMeta('showLocalImage');
  @override
  late final GeneratedColumn<bool> showLocalImage =
      GeneratedColumn<bool>('show_local_image', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("show_local_image" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  static const VerificationMeta _showWithPriceMeta =
      const VerificationMeta('showWithPrice');
  @override
  late final GeneratedColumn<bool> showWithPrice =
      GeneratedColumn<bool>('show_with_price', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("show_with_price" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  static const VerificationMeta _lastLoadTimeMeta =
      const VerificationMeta('lastLoadTime');
  @override
  late final GeneratedColumn<DateTime> lastLoadTime = GeneratedColumn<DateTime>(
      'last_load_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [showLocalImage, showWithPrice, lastLoadTime];
  @override
  String get aliasedName => _alias ?? 'prefs';
  @override
  String get actualTableName => 'prefs';
  @override
  VerificationContext validateIntegrity(Insertable<Pref> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('show_local_image')) {
      context.handle(
          _showLocalImageMeta,
          showLocalImage.isAcceptableOrUnknown(
              data['show_local_image']!, _showLocalImageMeta));
    } else if (isInserting) {
      context.missing(_showLocalImageMeta);
    }
    if (data.containsKey('show_with_price')) {
      context.handle(
          _showWithPriceMeta,
          showWithPrice.isAcceptableOrUnknown(
              data['show_with_price']!, _showWithPriceMeta));
    } else if (isInserting) {
      context.missing(_showWithPriceMeta);
    }
    if (data.containsKey('last_load_time')) {
      context.handle(
          _lastLoadTimeMeta,
          lastLoadTime.isAcceptableOrUnknown(
              data['last_load_time']!, _lastLoadTimeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Pref map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Pref(
      showLocalImage: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_local_image'])!,
      showWithPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_with_price'])!,
      lastLoadTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_load_time']),
    );
  }

  @override
  $PrefsTable createAlias(String alias) {
    return $PrefsTable(attachedDatabase, alias);
  }
}

class Pref extends DataClass implements Insertable<Pref> {
  final bool showLocalImage;
  final bool showWithPrice;
  final DateTime? lastLoadTime;
  const Pref(
      {required this.showLocalImage,
      required this.showWithPrice,
      this.lastLoadTime});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['show_local_image'] = Variable<bool>(showLocalImage);
    map['show_with_price'] = Variable<bool>(showWithPrice);
    if (!nullToAbsent || lastLoadTime != null) {
      map['last_load_time'] = Variable<DateTime>(lastLoadTime);
    }
    return map;
  }

  PrefsCompanion toCompanion(bool nullToAbsent) {
    return PrefsCompanion(
      showLocalImage: Value(showLocalImage),
      showWithPrice: Value(showWithPrice),
      lastLoadTime: lastLoadTime == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLoadTime),
    );
  }

  factory Pref.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Pref(
      showLocalImage: serializer.fromJson<bool>(json['showLocalImage']),
      showWithPrice: serializer.fromJson<bool>(json['showWithPrice']),
      lastLoadTime: serializer.fromJson<DateTime?>(json['lastLoadTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'showLocalImage': serializer.toJson<bool>(showLocalImage),
      'showWithPrice': serializer.toJson<bool>(showWithPrice),
      'lastLoadTime': serializer.toJson<DateTime?>(lastLoadTime),
    };
  }

  Pref copyWith(
          {bool? showLocalImage,
          bool? showWithPrice,
          Value<DateTime?> lastLoadTime = const Value.absent()}) =>
      Pref(
        showLocalImage: showLocalImage ?? this.showLocalImage,
        showWithPrice: showWithPrice ?? this.showWithPrice,
        lastLoadTime:
            lastLoadTime.present ? lastLoadTime.value : this.lastLoadTime,
      );
  @override
  String toString() {
    return (StringBuffer('Pref(')
          ..write('showLocalImage: $showLocalImage, ')
          ..write('showWithPrice: $showWithPrice, ')
          ..write('lastLoadTime: $lastLoadTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(showLocalImage, showWithPrice, lastLoadTime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pref &&
          other.showLocalImage == this.showLocalImage &&
          other.showWithPrice == this.showWithPrice &&
          other.lastLoadTime == this.lastLoadTime);
}

class PrefsCompanion extends UpdateCompanion<Pref> {
  final Value<bool> showLocalImage;
  final Value<bool> showWithPrice;
  final Value<DateTime?> lastLoadTime;
  final Value<int> rowid;
  const PrefsCompanion({
    this.showLocalImage = const Value.absent(),
    this.showWithPrice = const Value.absent(),
    this.lastLoadTime = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PrefsCompanion.insert({
    required bool showLocalImage,
    required bool showWithPrice,
    this.lastLoadTime = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : showLocalImage = Value(showLocalImage),
        showWithPrice = Value(showWithPrice);
  static Insertable<Pref> custom({
    Expression<bool>? showLocalImage,
    Expression<bool>? showWithPrice,
    Expression<DateTime>? lastLoadTime,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (showLocalImage != null) 'show_local_image': showLocalImage,
      if (showWithPrice != null) 'show_with_price': showWithPrice,
      if (lastLoadTime != null) 'last_load_time': lastLoadTime,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PrefsCompanion copyWith(
      {Value<bool>? showLocalImage,
      Value<bool>? showWithPrice,
      Value<DateTime?>? lastLoadTime,
      Value<int>? rowid}) {
    return PrefsCompanion(
      showLocalImage: showLocalImage ?? this.showLocalImage,
      showWithPrice: showWithPrice ?? this.showWithPrice,
      lastLoadTime: lastLoadTime ?? this.lastLoadTime,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (showLocalImage.present) {
      map['show_local_image'] = Variable<bool>(showLocalImage.value);
    }
    if (showWithPrice.present) {
      map['show_with_price'] = Variable<bool>(showWithPrice.value);
    }
    if (lastLoadTime.present) {
      map['last_load_time'] = Variable<DateTime>(lastLoadTime.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrefsCompanion(')
          ..write('showLocalImage: $showLocalImage, ')
          ..write('showWithPrice: $showWithPrice, ')
          ..write('lastLoadTime: $lastLoadTime, ')
          ..write('rowid: $rowid')
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
  static const VerificationMeta _loadtoMeta = const VerificationMeta('loadto');
  @override
  late final GeneratedColumn<String> loadto = GeneratedColumn<String>(
      'loadto', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _partnerIdMeta =
      const VerificationMeta('partnerId');
  @override
  late final GeneratedColumn<int> partnerId = GeneratedColumn<int>(
      'partner_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _siteIdMeta = const VerificationMeta('siteId');
  @override
  late final GeneratedColumn<int> siteId = GeneratedColumn<int>(
      'site_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fridgeSiteIdMeta =
      const VerificationMeta('fridgeSiteId');
  @override
  late final GeneratedColumn<int> fridgeSiteId = GeneratedColumn<int>(
      'fridge_site_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, loadto, partnerId, siteId, fridgeSiteId];
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
    if (data.containsKey('loadto')) {
      context.handle(_loadtoMeta,
          loadto.isAcceptableOrUnknown(data['loadto']!, _loadtoMeta));
    } else if (isInserting) {
      context.missing(_loadtoMeta);
    }
    if (data.containsKey('partner_id')) {
      context.handle(_partnerIdMeta,
          partnerId.isAcceptableOrUnknown(data['partner_id']!, _partnerIdMeta));
    } else if (isInserting) {
      context.missing(_partnerIdMeta);
    }
    if (data.containsKey('site_id')) {
      context.handle(_siteIdMeta,
          siteId.isAcceptableOrUnknown(data['site_id']!, _siteIdMeta));
    } else if (isInserting) {
      context.missing(_siteIdMeta);
    }
    if (data.containsKey('fridge_site_id')) {
      context.handle(
          _fridgeSiteIdMeta,
          fridgeSiteId.isAcceptableOrUnknown(
              data['fridge_site_id']!, _fridgeSiteIdMeta));
    } else if (isInserting) {
      context.missing(_fridgeSiteIdMeta);
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
      loadto: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}loadto'])!,
      partnerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}partner_id'])!,
      siteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}site_id'])!,
      fridgeSiteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fridge_site_id'])!,
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
  final String loadto;
  final int partnerId;
  final int siteId;
  final int fridgeSiteId;
  const Buyer(
      {required this.id,
      required this.name,
      required this.loadto,
      required this.partnerId,
      required this.siteId,
      required this.fridgeSiteId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['loadto'] = Variable<String>(loadto);
    map['partner_id'] = Variable<int>(partnerId);
    map['site_id'] = Variable<int>(siteId);
    map['fridge_site_id'] = Variable<int>(fridgeSiteId);
    return map;
  }

  BuyersCompanion toCompanion(bool nullToAbsent) {
    return BuyersCompanion(
      id: Value(id),
      name: Value(name),
      loadto: Value(loadto),
      partnerId: Value(partnerId),
      siteId: Value(siteId),
      fridgeSiteId: Value(fridgeSiteId),
    );
  }

  factory Buyer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Buyer(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      loadto: serializer.fromJson<String>(json['loadto']),
      partnerId: serializer.fromJson<int>(json['partnerId']),
      siteId: serializer.fromJson<int>(json['siteId']),
      fridgeSiteId: serializer.fromJson<int>(json['fridgeSiteId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'loadto': serializer.toJson<String>(loadto),
      'partnerId': serializer.toJson<int>(partnerId),
      'siteId': serializer.toJson<int>(siteId),
      'fridgeSiteId': serializer.toJson<int>(fridgeSiteId),
    };
  }

  Buyer copyWith(
          {int? id,
          String? name,
          String? loadto,
          int? partnerId,
          int? siteId,
          int? fridgeSiteId}) =>
      Buyer(
        id: id ?? this.id,
        name: name ?? this.name,
        loadto: loadto ?? this.loadto,
        partnerId: partnerId ?? this.partnerId,
        siteId: siteId ?? this.siteId,
        fridgeSiteId: fridgeSiteId ?? this.fridgeSiteId,
      );
  @override
  String toString() {
    return (StringBuffer('Buyer(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('loadto: $loadto, ')
          ..write('partnerId: $partnerId, ')
          ..write('siteId: $siteId, ')
          ..write('fridgeSiteId: $fridgeSiteId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, loadto, partnerId, siteId, fridgeSiteId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Buyer &&
          other.id == this.id &&
          other.name == this.name &&
          other.loadto == this.loadto &&
          other.partnerId == this.partnerId &&
          other.siteId == this.siteId &&
          other.fridgeSiteId == this.fridgeSiteId);
}

class BuyersCompanion extends UpdateCompanion<Buyer> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> loadto;
  final Value<int> partnerId;
  final Value<int> siteId;
  final Value<int> fridgeSiteId;
  const BuyersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.loadto = const Value.absent(),
    this.partnerId = const Value.absent(),
    this.siteId = const Value.absent(),
    this.fridgeSiteId = const Value.absent(),
  });
  BuyersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String loadto,
    required int partnerId,
    required int siteId,
    required int fridgeSiteId,
  })  : name = Value(name),
        loadto = Value(loadto),
        partnerId = Value(partnerId),
        siteId = Value(siteId),
        fridgeSiteId = Value(fridgeSiteId);
  static Insertable<Buyer> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? loadto,
    Expression<int>? partnerId,
    Expression<int>? siteId,
    Expression<int>? fridgeSiteId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (loadto != null) 'loadto': loadto,
      if (partnerId != null) 'partner_id': partnerId,
      if (siteId != null) 'site_id': siteId,
      if (fridgeSiteId != null) 'fridge_site_id': fridgeSiteId,
    });
  }

  BuyersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? loadto,
      Value<int>? partnerId,
      Value<int>? siteId,
      Value<int>? fridgeSiteId}) {
    return BuyersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      loadto: loadto ?? this.loadto,
      partnerId: partnerId ?? this.partnerId,
      siteId: siteId ?? this.siteId,
      fridgeSiteId: fridgeSiteId ?? this.fridgeSiteId,
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
    if (loadto.present) {
      map['loadto'] = Variable<String>(loadto.value);
    }
    if (partnerId.present) {
      map['partner_id'] = Variable<int>(partnerId.value);
    }
    if (siteId.present) {
      map['site_id'] = Variable<int>(siteId.value);
    }
    if (fridgeSiteId.present) {
      map['fridge_site_id'] = Variable<int>(fridgeSiteId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BuyersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('loadto: $loadto, ')
          ..write('partnerId: $partnerId, ')
          ..write('siteId: $siteId, ')
          ..write('fridgeSiteId: $fridgeSiteId')
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

class $LocationsTable extends Locations
    with TableInfo<$LocationsTable, Location> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _accuracyMeta =
      const VerificationMeta('accuracy');
  @override
  late final GeneratedColumn<double> accuracy = GeneratedColumn<double>(
      'accuracy', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _altitudeMeta =
      const VerificationMeta('altitude');
  @override
  late final GeneratedColumn<double> altitude = GeneratedColumn<double>(
      'altitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _headingMeta =
      const VerificationMeta('heading');
  @override
  late final GeneratedColumn<double> heading = GeneratedColumn<double>(
      'heading', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _speedMeta = const VerificationMeta('speed');
  @override
  late final GeneratedColumn<double> speed = GeneratedColumn<double>(
      'speed', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, latitude, longitude, accuracy, altitude, heading, speed, timestamp];
  @override
  String get aliasedName => _alias ?? 'locations';
  @override
  String get actualTableName => 'locations';
  @override
  VerificationContext validateIntegrity(Insertable<Location> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('accuracy')) {
      context.handle(_accuracyMeta,
          accuracy.isAcceptableOrUnknown(data['accuracy']!, _accuracyMeta));
    } else if (isInserting) {
      context.missing(_accuracyMeta);
    }
    if (data.containsKey('altitude')) {
      context.handle(_altitudeMeta,
          altitude.isAcceptableOrUnknown(data['altitude']!, _altitudeMeta));
    } else if (isInserting) {
      context.missing(_altitudeMeta);
    }
    if (data.containsKey('heading')) {
      context.handle(_headingMeta,
          heading.isAcceptableOrUnknown(data['heading']!, _headingMeta));
    } else if (isInserting) {
      context.missing(_headingMeta);
    }
    if (data.containsKey('speed')) {
      context.handle(
          _speedMeta, speed.isAcceptableOrUnknown(data['speed']!, _speedMeta));
    } else if (isInserting) {
      context.missing(_speedMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Location map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Location(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude'])!,
      accuracy: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}accuracy'])!,
      altitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}altitude'])!,
      heading: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}heading'])!,
      speed: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}speed'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
    );
  }

  @override
  $LocationsTable createAlias(String alias) {
    return $LocationsTable(attachedDatabase, alias);
  }
}

class Location extends DataClass implements Insertable<Location> {
  final int id;
  final double latitude;
  final double longitude;
  final double accuracy;
  final double altitude;
  final double heading;
  final double speed;
  final DateTime timestamp;
  const Location(
      {required this.id,
      required this.latitude,
      required this.longitude,
      required this.accuracy,
      required this.altitude,
      required this.heading,
      required this.speed,
      required this.timestamp});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['accuracy'] = Variable<double>(accuracy);
    map['altitude'] = Variable<double>(altitude);
    map['heading'] = Variable<double>(heading);
    map['speed'] = Variable<double>(speed);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  LocationsCompanion toCompanion(bool nullToAbsent) {
    return LocationsCompanion(
      id: Value(id),
      latitude: Value(latitude),
      longitude: Value(longitude),
      accuracy: Value(accuracy),
      altitude: Value(altitude),
      heading: Value(heading),
      speed: Value(speed),
      timestamp: Value(timestamp),
    );
  }

  factory Location.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Location(
      id: serializer.fromJson<int>(json['id']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      accuracy: serializer.fromJson<double>(json['accuracy']),
      altitude: serializer.fromJson<double>(json['altitude']),
      heading: serializer.fromJson<double>(json['heading']),
      speed: serializer.fromJson<double>(json['speed']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'accuracy': serializer.toJson<double>(accuracy),
      'altitude': serializer.toJson<double>(altitude),
      'heading': serializer.toJson<double>(heading),
      'speed': serializer.toJson<double>(speed),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  Location copyWith(
          {int? id,
          double? latitude,
          double? longitude,
          double? accuracy,
          double? altitude,
          double? heading,
          double? speed,
          DateTime? timestamp}) =>
      Location(
        id: id ?? this.id,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        accuracy: accuracy ?? this.accuracy,
        altitude: altitude ?? this.altitude,
        heading: heading ?? this.heading,
        speed: speed ?? this.speed,
        timestamp: timestamp ?? this.timestamp,
      );
  @override
  String toString() {
    return (StringBuffer('Location(')
          ..write('id: $id, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('accuracy: $accuracy, ')
          ..write('altitude: $altitude, ')
          ..write('heading: $heading, ')
          ..write('speed: $speed, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, latitude, longitude, accuracy, altitude, heading, speed, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Location &&
          other.id == this.id &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.accuracy == this.accuracy &&
          other.altitude == this.altitude &&
          other.heading == this.heading &&
          other.speed == this.speed &&
          other.timestamp == this.timestamp);
}

class LocationsCompanion extends UpdateCompanion<Location> {
  final Value<int> id;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<double> accuracy;
  final Value<double> altitude;
  final Value<double> heading;
  final Value<double> speed;
  final Value<DateTime> timestamp;
  const LocationsCompanion({
    this.id = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.altitude = const Value.absent(),
    this.heading = const Value.absent(),
    this.speed = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  LocationsCompanion.insert({
    this.id = const Value.absent(),
    required double latitude,
    required double longitude,
    required double accuracy,
    required double altitude,
    required double heading,
    required double speed,
    required DateTime timestamp,
  })  : latitude = Value(latitude),
        longitude = Value(longitude),
        accuracy = Value(accuracy),
        altitude = Value(altitude),
        heading = Value(heading),
        speed = Value(speed),
        timestamp = Value(timestamp);
  static Insertable<Location> custom({
    Expression<int>? id,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? accuracy,
    Expression<double>? altitude,
    Expression<double>? heading,
    Expression<double>? speed,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (accuracy != null) 'accuracy': accuracy,
      if (altitude != null) 'altitude': altitude,
      if (heading != null) 'heading': heading,
      if (speed != null) 'speed': speed,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  LocationsCompanion copyWith(
      {Value<int>? id,
      Value<double>? latitude,
      Value<double>? longitude,
      Value<double>? accuracy,
      Value<double>? altitude,
      Value<double>? heading,
      Value<double>? speed,
      Value<DateTime>? timestamp}) {
    return LocationsCompanion(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      altitude: altitude ?? this.altitude,
      heading: heading ?? this.heading,
      speed: speed ?? this.speed,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (accuracy.present) {
      map['accuracy'] = Variable<double>(accuracy.value);
    }
    if (altitude.present) {
      map['altitude'] = Variable<double>(altitude.value);
    }
    if (heading.present) {
      map['heading'] = Variable<double>(heading.value);
    }
    if (speed.present) {
      map['speed'] = Variable<double>(speed.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocationsCompanion(')
          ..write('id: $id, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('accuracy: $accuracy, ')
          ..write('altitude: $altitude, ')
          ..write('heading: $heading, ')
          ..write('speed: $speed, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

class $PointFormatsTable extends PointFormats
    with TableInfo<$PointFormatsTable, PointFormat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PointFormatsTable(this.attachedDatabase, [this._alias]);
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
  String get aliasedName => _alias ?? 'point_formats';
  @override
  String get actualTableName => 'point_formats';
  @override
  VerificationContext validateIntegrity(Insertable<PointFormat> instance,
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
  PointFormat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PointFormat(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $PointFormatsTable createAlias(String alias) {
    return $PointFormatsTable(attachedDatabase, alias);
  }
}

class PointFormat extends DataClass implements Insertable<PointFormat> {
  final int id;
  final String name;
  const PointFormat({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  PointFormatsCompanion toCompanion(bool nullToAbsent) {
    return PointFormatsCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory PointFormat.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PointFormat(
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

  PointFormat copyWith({int? id, String? name}) => PointFormat(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('PointFormat(')
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
      (other is PointFormat && other.id == this.id && other.name == this.name);
}

class PointFormatsCompanion extends UpdateCompanion<PointFormat> {
  final Value<int> id;
  final Value<String> name;
  const PointFormatsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  PointFormatsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<PointFormat> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  PointFormatsCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return PointFormatsCompanion(
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
    return (StringBuffer('PointFormatsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $PointsTable extends Points with TableInfo<$PointsTable, Point> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _guidMeta = const VerificationMeta('guid');
  @override
  late final GeneratedColumn<String> guid = GeneratedColumn<String>(
      'guid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted =
      GeneratedColumn<bool>('is_deleted', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_deleted" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _currentTimestampMeta =
      const VerificationMeta('currentTimestamp');
  @override
  late final GeneratedColumn<DateTime> currentTimestamp =
      GeneratedColumn<DateTime>('current_timestamp', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  static const VerificationMeta _lastSyncTimeMeta =
      const VerificationMeta('lastSyncTime');
  @override
  late final GeneratedColumn<DateTime> lastSyncTime = GeneratedColumn<DateTime>(
      'last_sync_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _needSyncMeta =
      const VerificationMeta('needSync');
  @override
  late final GeneratedColumn<bool> needSync = GeneratedColumn<bool>(
      'need_sync', aliasedName, false,
      generatedAs: GeneratedAs(
          (isNew & isDeleted.not()) |
              (isNew.not() & lastSyncTime.isSmallerThan(timestamp)),
          true),
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
        SqlDialect.sqlite: 'CHECK ("need_sync" IN (0, 1))',
        SqlDialect.mysql: '',
        SqlDialect.postgres: '',
      }));
  static const VerificationMeta _isNewMeta = const VerificationMeta('isNew');
  @override
  late final GeneratedColumn<bool> isNew =
      GeneratedColumn<bool>('is_new', aliasedName, false,
          generatedAs: GeneratedAs(lastSyncTime.isNull(), false),
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_new" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _buyerNameMeta =
      const VerificationMeta('buyerName');
  @override
  late final GeneratedColumn<String> buyerName = GeneratedColumn<String>(
      'buyer_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _pointFormatMeta =
      const VerificationMeta('pointFormat');
  @override
  late final GeneratedColumn<int> pointFormat = GeneratedColumn<int>(
      'point_format', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _numberOfCdesksMeta =
      const VerificationMeta('numberOfCdesks');
  @override
  late final GeneratedColumn<int> numberOfCdesks = GeneratedColumn<int>(
      'number_of_cdesks', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _emailOnlineCheckMeta =
      const VerificationMeta('emailOnlineCheck');
  @override
  late final GeneratedColumn<String> emailOnlineCheck = GeneratedColumn<String>(
      'email_online_check', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneOnlineCheckMeta =
      const VerificationMeta('phoneOnlineCheck');
  @override
  late final GeneratedColumn<String> phoneOnlineCheck = GeneratedColumn<String>(
      'phone_online_check', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _innMeta = const VerificationMeta('inn');
  @override
  late final GeneratedColumn<String> inn = GeneratedColumn<String>(
      'inn', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _jurMeta = const VerificationMeta('jur');
  @override
  late final GeneratedColumn<String> jur = GeneratedColumn<String>(
      'jur', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _plongMeta = const VerificationMeta('plong');
  @override
  late final GeneratedColumn<int> plong = GeneratedColumn<int>(
      'plong', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _maxdebtMeta =
      const VerificationMeta('maxdebt');
  @override
  late final GeneratedColumn<int> maxdebt = GeneratedColumn<int>(
      'maxdebt', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nds10Meta = const VerificationMeta('nds10');
  @override
  late final GeneratedColumn<int> nds10 = GeneratedColumn<int>(
      'nds10', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nds20Meta = const VerificationMeta('nds20');
  @override
  late final GeneratedColumn<int> nds20 = GeneratedColumn<int>(
      'nds20', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        guid,
        isDeleted,
        timestamp,
        currentTimestamp,
        lastSyncTime,
        needSync,
        isNew,
        id,
        name,
        address,
        buyerName,
        reason,
        latitude,
        longitude,
        pointFormat,
        numberOfCdesks,
        emailOnlineCheck,
        email,
        phoneOnlineCheck,
        inn,
        jur,
        plong,
        maxdebt,
        nds10,
        nds20
      ];
  @override
  String get aliasedName => _alias ?? 'points';
  @override
  String get actualTableName => 'points';
  @override
  VerificationContext validateIntegrity(Insertable<Point> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('guid')) {
      context.handle(
          _guidMeta, guid.isAcceptableOrUnknown(data['guid']!, _guidMeta));
    } else if (isInserting) {
      context.missing(_guidMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    }
    if (data.containsKey('current_timestamp')) {
      context.handle(
          _currentTimestampMeta,
          currentTimestamp.isAcceptableOrUnknown(
              data['current_timestamp']!, _currentTimestampMeta));
    }
    if (data.containsKey('last_sync_time')) {
      context.handle(
          _lastSyncTimeMeta,
          lastSyncTime.isAcceptableOrUnknown(
              data['last_sync_time']!, _lastSyncTimeMeta));
    }
    if (data.containsKey('need_sync')) {
      context.handle(_needSyncMeta,
          needSync.isAcceptableOrUnknown(data['need_sync']!, _needSyncMeta));
    }
    if (data.containsKey('is_new')) {
      context.handle(
          _isNewMeta, isNew.isAcceptableOrUnknown(data['is_new']!, _isNewMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('buyer_name')) {
      context.handle(_buyerNameMeta,
          buyerName.isAcceptableOrUnknown(data['buyer_name']!, _buyerNameMeta));
    } else if (isInserting) {
      context.missing(_buyerNameMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    }
    if (data.containsKey('point_format')) {
      context.handle(
          _pointFormatMeta,
          pointFormat.isAcceptableOrUnknown(
              data['point_format']!, _pointFormatMeta));
    }
    if (data.containsKey('number_of_cdesks')) {
      context.handle(
          _numberOfCdesksMeta,
          numberOfCdesks.isAcceptableOrUnknown(
              data['number_of_cdesks']!, _numberOfCdesksMeta));
    }
    if (data.containsKey('email_online_check')) {
      context.handle(
          _emailOnlineCheckMeta,
          emailOnlineCheck.isAcceptableOrUnknown(
              data['email_online_check']!, _emailOnlineCheckMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('phone_online_check')) {
      context.handle(
          _phoneOnlineCheckMeta,
          phoneOnlineCheck.isAcceptableOrUnknown(
              data['phone_online_check']!, _phoneOnlineCheckMeta));
    }
    if (data.containsKey('inn')) {
      context.handle(
          _innMeta, inn.isAcceptableOrUnknown(data['inn']!, _innMeta));
    }
    if (data.containsKey('jur')) {
      context.handle(
          _jurMeta, jur.isAcceptableOrUnknown(data['jur']!, _jurMeta));
    }
    if (data.containsKey('plong')) {
      context.handle(
          _plongMeta, plong.isAcceptableOrUnknown(data['plong']!, _plongMeta));
    }
    if (data.containsKey('maxdebt')) {
      context.handle(_maxdebtMeta,
          maxdebt.isAcceptableOrUnknown(data['maxdebt']!, _maxdebtMeta));
    }
    if (data.containsKey('nds10')) {
      context.handle(
          _nds10Meta, nds10.isAcceptableOrUnknown(data['nds10']!, _nds10Meta));
    }
    if (data.containsKey('nds20')) {
      context.handle(
          _nds20Meta, nds20.isAcceptableOrUnknown(data['nds20']!, _nds20Meta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {guid};
  @override
  Point map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Point(
      guid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guid'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      currentTimestamp: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}current_timestamp'])!,
      lastSyncTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_sync_time']),
      needSync: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}need_sync'])!,
      isNew: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_new'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      buyerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}buyer_name'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude']),
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude']),
      pointFormat: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}point_format']),
      numberOfCdesks: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}number_of_cdesks']),
      emailOnlineCheck: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}email_online_check']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      phoneOnlineCheck: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}phone_online_check']),
      inn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}inn']),
      jur: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}jur']),
      plong: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}plong']),
      maxdebt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}maxdebt']),
      nds10: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}nds10']),
      nds20: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}nds20']),
    );
  }

  @override
  $PointsTable createAlias(String alias) {
    return $PointsTable(attachedDatabase, alias);
  }
}

class Point extends DataClass implements Insertable<Point> {
  final String guid;
  final bool isDeleted;
  final DateTime timestamp;
  final DateTime currentTimestamp;
  final DateTime? lastSyncTime;
  final bool needSync;
  final bool isNew;
  final int? id;
  final String name;
  final String? address;
  final String buyerName;
  final String reason;
  final double? latitude;
  final double? longitude;
  final int? pointFormat;
  final int? numberOfCdesks;
  final String? emailOnlineCheck;
  final String? email;
  final String? phoneOnlineCheck;
  final String? inn;
  final String? jur;
  final int? plong;
  final int? maxdebt;
  final int? nds10;
  final int? nds20;
  const Point(
      {required this.guid,
      required this.isDeleted,
      required this.timestamp,
      required this.currentTimestamp,
      this.lastSyncTime,
      required this.needSync,
      required this.isNew,
      this.id,
      required this.name,
      this.address,
      required this.buyerName,
      required this.reason,
      this.latitude,
      this.longitude,
      this.pointFormat,
      this.numberOfCdesks,
      this.emailOnlineCheck,
      this.email,
      this.phoneOnlineCheck,
      this.inn,
      this.jur,
      this.plong,
      this.maxdebt,
      this.nds10,
      this.nds20});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['guid'] = Variable<String>(guid);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['current_timestamp'] = Variable<DateTime>(currentTimestamp);
    if (!nullToAbsent || lastSyncTime != null) {
      map['last_sync_time'] = Variable<DateTime>(lastSyncTime);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['buyer_name'] = Variable<String>(buyerName);
    map['reason'] = Variable<String>(reason);
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || pointFormat != null) {
      map['point_format'] = Variable<int>(pointFormat);
    }
    if (!nullToAbsent || numberOfCdesks != null) {
      map['number_of_cdesks'] = Variable<int>(numberOfCdesks);
    }
    if (!nullToAbsent || emailOnlineCheck != null) {
      map['email_online_check'] = Variable<String>(emailOnlineCheck);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || phoneOnlineCheck != null) {
      map['phone_online_check'] = Variable<String>(phoneOnlineCheck);
    }
    if (!nullToAbsent || inn != null) {
      map['inn'] = Variable<String>(inn);
    }
    if (!nullToAbsent || jur != null) {
      map['jur'] = Variable<String>(jur);
    }
    if (!nullToAbsent || plong != null) {
      map['plong'] = Variable<int>(plong);
    }
    if (!nullToAbsent || maxdebt != null) {
      map['maxdebt'] = Variable<int>(maxdebt);
    }
    if (!nullToAbsent || nds10 != null) {
      map['nds10'] = Variable<int>(nds10);
    }
    if (!nullToAbsent || nds20 != null) {
      map['nds20'] = Variable<int>(nds20);
    }
    return map;
  }

  PointsCompanion toCompanion(bool nullToAbsent) {
    return PointsCompanion(
      guid: Value(guid),
      isDeleted: Value(isDeleted),
      timestamp: Value(timestamp),
      currentTimestamp: Value(currentTimestamp),
      lastSyncTime: lastSyncTime == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncTime),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: Value(name),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      buyerName: Value(buyerName),
      reason: Value(reason),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      pointFormat: pointFormat == null && nullToAbsent
          ? const Value.absent()
          : Value(pointFormat),
      numberOfCdesks: numberOfCdesks == null && nullToAbsent
          ? const Value.absent()
          : Value(numberOfCdesks),
      emailOnlineCheck: emailOnlineCheck == null && nullToAbsent
          ? const Value.absent()
          : Value(emailOnlineCheck),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      phoneOnlineCheck: phoneOnlineCheck == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneOnlineCheck),
      inn: inn == null && nullToAbsent ? const Value.absent() : Value(inn),
      jur: jur == null && nullToAbsent ? const Value.absent() : Value(jur),
      plong:
          plong == null && nullToAbsent ? const Value.absent() : Value(plong),
      maxdebt: maxdebt == null && nullToAbsent
          ? const Value.absent()
          : Value(maxdebt),
      nds10:
          nds10 == null && nullToAbsent ? const Value.absent() : Value(nds10),
      nds20:
          nds20 == null && nullToAbsent ? const Value.absent() : Value(nds20),
    );
  }

  factory Point.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Point(
      guid: serializer.fromJson<String>(json['guid']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      currentTimestamp: serializer.fromJson<DateTime>(json['currentTimestamp']),
      lastSyncTime: serializer.fromJson<DateTime?>(json['lastSyncTime']),
      needSync: serializer.fromJson<bool>(json['needSync']),
      isNew: serializer.fromJson<bool>(json['isNew']),
      id: serializer.fromJson<int?>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String?>(json['address']),
      buyerName: serializer.fromJson<String>(json['buyerName']),
      reason: serializer.fromJson<String>(json['reason']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      pointFormat: serializer.fromJson<int?>(json['pointFormat']),
      numberOfCdesks: serializer.fromJson<int?>(json['numberOfCdesks']),
      emailOnlineCheck: serializer.fromJson<String?>(json['emailOnlineCheck']),
      email: serializer.fromJson<String?>(json['email']),
      phoneOnlineCheck: serializer.fromJson<String?>(json['phoneOnlineCheck']),
      inn: serializer.fromJson<String?>(json['inn']),
      jur: serializer.fromJson<String?>(json['jur']),
      plong: serializer.fromJson<int?>(json['plong']),
      maxdebt: serializer.fromJson<int?>(json['maxdebt']),
      nds10: serializer.fromJson<int?>(json['nds10']),
      nds20: serializer.fromJson<int?>(json['nds20']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'guid': serializer.toJson<String>(guid),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'currentTimestamp': serializer.toJson<DateTime>(currentTimestamp),
      'lastSyncTime': serializer.toJson<DateTime?>(lastSyncTime),
      'needSync': serializer.toJson<bool>(needSync),
      'isNew': serializer.toJson<bool>(isNew),
      'id': serializer.toJson<int?>(id),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String?>(address),
      'buyerName': serializer.toJson<String>(buyerName),
      'reason': serializer.toJson<String>(reason),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'pointFormat': serializer.toJson<int?>(pointFormat),
      'numberOfCdesks': serializer.toJson<int?>(numberOfCdesks),
      'emailOnlineCheck': serializer.toJson<String?>(emailOnlineCheck),
      'email': serializer.toJson<String?>(email),
      'phoneOnlineCheck': serializer.toJson<String?>(phoneOnlineCheck),
      'inn': serializer.toJson<String?>(inn),
      'jur': serializer.toJson<String?>(jur),
      'plong': serializer.toJson<int?>(plong),
      'maxdebt': serializer.toJson<int?>(maxdebt),
      'nds10': serializer.toJson<int?>(nds10),
      'nds20': serializer.toJson<int?>(nds20),
    };
  }

  Point copyWith(
          {String? guid,
          bool? isDeleted,
          DateTime? timestamp,
          DateTime? currentTimestamp,
          Value<DateTime?> lastSyncTime = const Value.absent(),
          bool? needSync,
          bool? isNew,
          Value<int?> id = const Value.absent(),
          String? name,
          Value<String?> address = const Value.absent(),
          String? buyerName,
          String? reason,
          Value<double?> latitude = const Value.absent(),
          Value<double?> longitude = const Value.absent(),
          Value<int?> pointFormat = const Value.absent(),
          Value<int?> numberOfCdesks = const Value.absent(),
          Value<String?> emailOnlineCheck = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> phoneOnlineCheck = const Value.absent(),
          Value<String?> inn = const Value.absent(),
          Value<String?> jur = const Value.absent(),
          Value<int?> plong = const Value.absent(),
          Value<int?> maxdebt = const Value.absent(),
          Value<int?> nds10 = const Value.absent(),
          Value<int?> nds20 = const Value.absent()}) =>
      Point(
        guid: guid ?? this.guid,
        isDeleted: isDeleted ?? this.isDeleted,
        timestamp: timestamp ?? this.timestamp,
        currentTimestamp: currentTimestamp ?? this.currentTimestamp,
        lastSyncTime:
            lastSyncTime.present ? lastSyncTime.value : this.lastSyncTime,
        needSync: needSync ?? this.needSync,
        isNew: isNew ?? this.isNew,
        id: id.present ? id.value : this.id,
        name: name ?? this.name,
        address: address.present ? address.value : this.address,
        buyerName: buyerName ?? this.buyerName,
        reason: reason ?? this.reason,
        latitude: latitude.present ? latitude.value : this.latitude,
        longitude: longitude.present ? longitude.value : this.longitude,
        pointFormat: pointFormat.present ? pointFormat.value : this.pointFormat,
        numberOfCdesks:
            numberOfCdesks.present ? numberOfCdesks.value : this.numberOfCdesks,
        emailOnlineCheck: emailOnlineCheck.present
            ? emailOnlineCheck.value
            : this.emailOnlineCheck,
        email: email.present ? email.value : this.email,
        phoneOnlineCheck: phoneOnlineCheck.present
            ? phoneOnlineCheck.value
            : this.phoneOnlineCheck,
        inn: inn.present ? inn.value : this.inn,
        jur: jur.present ? jur.value : this.jur,
        plong: plong.present ? plong.value : this.plong,
        maxdebt: maxdebt.present ? maxdebt.value : this.maxdebt,
        nds10: nds10.present ? nds10.value : this.nds10,
        nds20: nds20.present ? nds20.value : this.nds20,
      );
  @override
  String toString() {
    return (StringBuffer('Point(')
          ..write('guid: $guid, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('timestamp: $timestamp, ')
          ..write('currentTimestamp: $currentTimestamp, ')
          ..write('lastSyncTime: $lastSyncTime, ')
          ..write('needSync: $needSync, ')
          ..write('isNew: $isNew, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('buyerName: $buyerName, ')
          ..write('reason: $reason, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('pointFormat: $pointFormat, ')
          ..write('numberOfCdesks: $numberOfCdesks, ')
          ..write('emailOnlineCheck: $emailOnlineCheck, ')
          ..write('email: $email, ')
          ..write('phoneOnlineCheck: $phoneOnlineCheck, ')
          ..write('inn: $inn, ')
          ..write('jur: $jur, ')
          ..write('plong: $plong, ')
          ..write('maxdebt: $maxdebt, ')
          ..write('nds10: $nds10, ')
          ..write('nds20: $nds20')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        guid,
        isDeleted,
        timestamp,
        currentTimestamp,
        lastSyncTime,
        needSync,
        isNew,
        id,
        name,
        address,
        buyerName,
        reason,
        latitude,
        longitude,
        pointFormat,
        numberOfCdesks,
        emailOnlineCheck,
        email,
        phoneOnlineCheck,
        inn,
        jur,
        plong,
        maxdebt,
        nds10,
        nds20
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Point &&
          other.guid == this.guid &&
          other.isDeleted == this.isDeleted &&
          other.timestamp == this.timestamp &&
          other.currentTimestamp == this.currentTimestamp &&
          other.lastSyncTime == this.lastSyncTime &&
          other.needSync == this.needSync &&
          other.isNew == this.isNew &&
          other.id == this.id &&
          other.name == this.name &&
          other.address == this.address &&
          other.buyerName == this.buyerName &&
          other.reason == this.reason &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.pointFormat == this.pointFormat &&
          other.numberOfCdesks == this.numberOfCdesks &&
          other.emailOnlineCheck == this.emailOnlineCheck &&
          other.email == this.email &&
          other.phoneOnlineCheck == this.phoneOnlineCheck &&
          other.inn == this.inn &&
          other.jur == this.jur &&
          other.plong == this.plong &&
          other.maxdebt == this.maxdebt &&
          other.nds10 == this.nds10 &&
          other.nds20 == this.nds20);
}

class PointsCompanion extends UpdateCompanion<Point> {
  final Value<String> guid;
  final Value<bool> isDeleted;
  final Value<DateTime> timestamp;
  final Value<DateTime> currentTimestamp;
  final Value<DateTime?> lastSyncTime;
  final Value<int?> id;
  final Value<String> name;
  final Value<String?> address;
  final Value<String> buyerName;
  final Value<String> reason;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<int?> pointFormat;
  final Value<int?> numberOfCdesks;
  final Value<String?> emailOnlineCheck;
  final Value<String?> email;
  final Value<String?> phoneOnlineCheck;
  final Value<String?> inn;
  final Value<String?> jur;
  final Value<int?> plong;
  final Value<int?> maxdebt;
  final Value<int?> nds10;
  final Value<int?> nds20;
  final Value<int> rowid;
  const PointsCompanion({
    this.guid = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.currentTimestamp = const Value.absent(),
    this.lastSyncTime = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.buyerName = const Value.absent(),
    this.reason = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.pointFormat = const Value.absent(),
    this.numberOfCdesks = const Value.absent(),
    this.emailOnlineCheck = const Value.absent(),
    this.email = const Value.absent(),
    this.phoneOnlineCheck = const Value.absent(),
    this.inn = const Value.absent(),
    this.jur = const Value.absent(),
    this.plong = const Value.absent(),
    this.maxdebt = const Value.absent(),
    this.nds10 = const Value.absent(),
    this.nds20 = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PointsCompanion.insert({
    required String guid,
    this.isDeleted = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.currentTimestamp = const Value.absent(),
    this.lastSyncTime = const Value.absent(),
    this.id = const Value.absent(),
    required String name,
    this.address = const Value.absent(),
    required String buyerName,
    required String reason,
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.pointFormat = const Value.absent(),
    this.numberOfCdesks = const Value.absent(),
    this.emailOnlineCheck = const Value.absent(),
    this.email = const Value.absent(),
    this.phoneOnlineCheck = const Value.absent(),
    this.inn = const Value.absent(),
    this.jur = const Value.absent(),
    this.plong = const Value.absent(),
    this.maxdebt = const Value.absent(),
    this.nds10 = const Value.absent(),
    this.nds20 = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : guid = Value(guid),
        name = Value(name),
        buyerName = Value(buyerName),
        reason = Value(reason);
  static Insertable<Point> custom({
    Expression<String>? guid,
    Expression<bool>? isDeleted,
    Expression<DateTime>? timestamp,
    Expression<DateTime>? currentTimestamp,
    Expression<DateTime>? lastSyncTime,
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? address,
    Expression<String>? buyerName,
    Expression<String>? reason,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<int>? pointFormat,
    Expression<int>? numberOfCdesks,
    Expression<String>? emailOnlineCheck,
    Expression<String>? email,
    Expression<String>? phoneOnlineCheck,
    Expression<String>? inn,
    Expression<String>? jur,
    Expression<int>? plong,
    Expression<int>? maxdebt,
    Expression<int>? nds10,
    Expression<int>? nds20,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (guid != null) 'guid': guid,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (timestamp != null) 'timestamp': timestamp,
      if (currentTimestamp != null) 'current_timestamp': currentTimestamp,
      if (lastSyncTime != null) 'last_sync_time': lastSyncTime,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (buyerName != null) 'buyer_name': buyerName,
      if (reason != null) 'reason': reason,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (pointFormat != null) 'point_format': pointFormat,
      if (numberOfCdesks != null) 'number_of_cdesks': numberOfCdesks,
      if (emailOnlineCheck != null) 'email_online_check': emailOnlineCheck,
      if (email != null) 'email': email,
      if (phoneOnlineCheck != null) 'phone_online_check': phoneOnlineCheck,
      if (inn != null) 'inn': inn,
      if (jur != null) 'jur': jur,
      if (plong != null) 'plong': plong,
      if (maxdebt != null) 'maxdebt': maxdebt,
      if (nds10 != null) 'nds10': nds10,
      if (nds20 != null) 'nds20': nds20,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PointsCompanion copyWith(
      {Value<String>? guid,
      Value<bool>? isDeleted,
      Value<DateTime>? timestamp,
      Value<DateTime>? currentTimestamp,
      Value<DateTime?>? lastSyncTime,
      Value<int?>? id,
      Value<String>? name,
      Value<String?>? address,
      Value<String>? buyerName,
      Value<String>? reason,
      Value<double?>? latitude,
      Value<double?>? longitude,
      Value<int?>? pointFormat,
      Value<int?>? numberOfCdesks,
      Value<String?>? emailOnlineCheck,
      Value<String?>? email,
      Value<String?>? phoneOnlineCheck,
      Value<String?>? inn,
      Value<String?>? jur,
      Value<int?>? plong,
      Value<int?>? maxdebt,
      Value<int?>? nds10,
      Value<int?>? nds20,
      Value<int>? rowid}) {
    return PointsCompanion(
      guid: guid ?? this.guid,
      isDeleted: isDeleted ?? this.isDeleted,
      timestamp: timestamp ?? this.timestamp,
      currentTimestamp: currentTimestamp ?? this.currentTimestamp,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      buyerName: buyerName ?? this.buyerName,
      reason: reason ?? this.reason,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      pointFormat: pointFormat ?? this.pointFormat,
      numberOfCdesks: numberOfCdesks ?? this.numberOfCdesks,
      emailOnlineCheck: emailOnlineCheck ?? this.emailOnlineCheck,
      email: email ?? this.email,
      phoneOnlineCheck: phoneOnlineCheck ?? this.phoneOnlineCheck,
      inn: inn ?? this.inn,
      jur: jur ?? this.jur,
      plong: plong ?? this.plong,
      maxdebt: maxdebt ?? this.maxdebt,
      nds10: nds10 ?? this.nds10,
      nds20: nds20 ?? this.nds20,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (guid.present) {
      map['guid'] = Variable<String>(guid.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (currentTimestamp.present) {
      map['current_timestamp'] = Variable<DateTime>(currentTimestamp.value);
    }
    if (lastSyncTime.present) {
      map['last_sync_time'] = Variable<DateTime>(lastSyncTime.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (buyerName.present) {
      map['buyer_name'] = Variable<String>(buyerName.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (pointFormat.present) {
      map['point_format'] = Variable<int>(pointFormat.value);
    }
    if (numberOfCdesks.present) {
      map['number_of_cdesks'] = Variable<int>(numberOfCdesks.value);
    }
    if (emailOnlineCheck.present) {
      map['email_online_check'] = Variable<String>(emailOnlineCheck.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phoneOnlineCheck.present) {
      map['phone_online_check'] = Variable<String>(phoneOnlineCheck.value);
    }
    if (inn.present) {
      map['inn'] = Variable<String>(inn.value);
    }
    if (jur.present) {
      map['jur'] = Variable<String>(jur.value);
    }
    if (plong.present) {
      map['plong'] = Variable<int>(plong.value);
    }
    if (maxdebt.present) {
      map['maxdebt'] = Variable<int>(maxdebt.value);
    }
    if (nds10.present) {
      map['nds10'] = Variable<int>(nds10.value);
    }
    if (nds20.present) {
      map['nds20'] = Variable<int>(nds20.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PointsCompanion(')
          ..write('guid: $guid, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('timestamp: $timestamp, ')
          ..write('currentTimestamp: $currentTimestamp, ')
          ..write('lastSyncTime: $lastSyncTime, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('buyerName: $buyerName, ')
          ..write('reason: $reason, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('pointFormat: $pointFormat, ')
          ..write('numberOfCdesks: $numberOfCdesks, ')
          ..write('emailOnlineCheck: $emailOnlineCheck, ')
          ..write('email: $email, ')
          ..write('phoneOnlineCheck: $phoneOnlineCheck, ')
          ..write('inn: $inn, ')
          ..write('jur: $jur, ')
          ..write('plong: $plong, ')
          ..write('maxdebt: $maxdebt, ')
          ..write('nds10: $nds10, ')
          ..write('nds20: $nds20, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PointImagesTable extends PointImages
    with TableInfo<$PointImagesTable, PointImage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PointImagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _guidMeta = const VerificationMeta('guid');
  @override
  late final GeneratedColumn<String> guid = GeneratedColumn<String>(
      'guid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted =
      GeneratedColumn<bool>('is_deleted', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_deleted" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _currentTimestampMeta =
      const VerificationMeta('currentTimestamp');
  @override
  late final GeneratedColumn<DateTime> currentTimestamp =
      GeneratedColumn<DateTime>('current_timestamp', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  static const VerificationMeta _lastSyncTimeMeta =
      const VerificationMeta('lastSyncTime');
  @override
  late final GeneratedColumn<DateTime> lastSyncTime = GeneratedColumn<DateTime>(
      'last_sync_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _needSyncMeta =
      const VerificationMeta('needSync');
  @override
  late final GeneratedColumn<bool> needSync = GeneratedColumn<bool>(
      'need_sync', aliasedName, false,
      generatedAs: GeneratedAs(
          (isNew & isDeleted.not()) |
              (isNew.not() & lastSyncTime.isSmallerThan(timestamp)),
          true),
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
        SqlDialect.sqlite: 'CHECK ("need_sync" IN (0, 1))',
        SqlDialect.mysql: '',
        SqlDialect.postgres: '',
      }));
  static const VerificationMeta _isNewMeta = const VerificationMeta('isNew');
  @override
  late final GeneratedColumn<bool> isNew =
      GeneratedColumn<bool>('is_new', aliasedName, false,
          generatedAs: GeneratedAs(lastSyncTime.isNull(), false),
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_new" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _pointGuidMeta =
      const VerificationMeta('pointGuid');
  @override
  late final GeneratedColumn<String> pointGuid = GeneratedColumn<String>(
      'point_guid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES points (guid) ON UPDATE CASCADE ON DELETE CASCADE'));
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _accuracyMeta =
      const VerificationMeta('accuracy');
  @override
  late final GeneratedColumn<double> accuracy = GeneratedColumn<double>(
      'accuracy', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _imageUrlMeta =
      const VerificationMeta('imageUrl');
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
      'image_url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imageKeyMeta =
      const VerificationMeta('imageKey');
  @override
  late final GeneratedColumn<String> imageKey = GeneratedColumn<String>(
      'image_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        guid,
        isDeleted,
        timestamp,
        currentTimestamp,
        lastSyncTime,
        needSync,
        isNew,
        id,
        pointGuid,
        latitude,
        longitude,
        accuracy,
        imageUrl,
        imageKey
      ];
  @override
  String get aliasedName => _alias ?? 'point_images';
  @override
  String get actualTableName => 'point_images';
  @override
  VerificationContext validateIntegrity(Insertable<PointImage> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('guid')) {
      context.handle(
          _guidMeta, guid.isAcceptableOrUnknown(data['guid']!, _guidMeta));
    } else if (isInserting) {
      context.missing(_guidMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    }
    if (data.containsKey('current_timestamp')) {
      context.handle(
          _currentTimestampMeta,
          currentTimestamp.isAcceptableOrUnknown(
              data['current_timestamp']!, _currentTimestampMeta));
    }
    if (data.containsKey('last_sync_time')) {
      context.handle(
          _lastSyncTimeMeta,
          lastSyncTime.isAcceptableOrUnknown(
              data['last_sync_time']!, _lastSyncTimeMeta));
    }
    if (data.containsKey('need_sync')) {
      context.handle(_needSyncMeta,
          needSync.isAcceptableOrUnknown(data['need_sync']!, _needSyncMeta));
    }
    if (data.containsKey('is_new')) {
      context.handle(
          _isNewMeta, isNew.isAcceptableOrUnknown(data['is_new']!, _isNewMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('point_guid')) {
      context.handle(_pointGuidMeta,
          pointGuid.isAcceptableOrUnknown(data['point_guid']!, _pointGuidMeta));
    } else if (isInserting) {
      context.missing(_pointGuidMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('accuracy')) {
      context.handle(_accuracyMeta,
          accuracy.isAcceptableOrUnknown(data['accuracy']!, _accuracyMeta));
    } else if (isInserting) {
      context.missing(_accuracyMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    } else if (isInserting) {
      context.missing(_imageUrlMeta);
    }
    if (data.containsKey('image_key')) {
      context.handle(_imageKeyMeta,
          imageKey.isAcceptableOrUnknown(data['image_key']!, _imageKeyMeta));
    } else if (isInserting) {
      context.missing(_imageKeyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {guid};
  @override
  PointImage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PointImage(
      guid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guid'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      currentTimestamp: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}current_timestamp'])!,
      lastSyncTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_sync_time']),
      needSync: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}need_sync'])!,
      isNew: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_new'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id']),
      pointGuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}point_guid'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude'])!,
      accuracy: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}accuracy'])!,
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url'])!,
      imageKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_key'])!,
    );
  }

  @override
  $PointImagesTable createAlias(String alias) {
    return $PointImagesTable(attachedDatabase, alias);
  }
}

class PointImage extends DataClass implements Insertable<PointImage> {
  final String guid;
  final bool isDeleted;
  final DateTime timestamp;
  final DateTime currentTimestamp;
  final DateTime? lastSyncTime;
  final bool needSync;
  final bool isNew;
  final int? id;
  final String pointGuid;
  final double latitude;
  final double longitude;
  final double accuracy;
  final String imageUrl;
  final String imageKey;
  const PointImage(
      {required this.guid,
      required this.isDeleted,
      required this.timestamp,
      required this.currentTimestamp,
      this.lastSyncTime,
      required this.needSync,
      required this.isNew,
      this.id,
      required this.pointGuid,
      required this.latitude,
      required this.longitude,
      required this.accuracy,
      required this.imageUrl,
      required this.imageKey});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['guid'] = Variable<String>(guid);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['current_timestamp'] = Variable<DateTime>(currentTimestamp);
    if (!nullToAbsent || lastSyncTime != null) {
      map['last_sync_time'] = Variable<DateTime>(lastSyncTime);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    map['point_guid'] = Variable<String>(pointGuid);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['accuracy'] = Variable<double>(accuracy);
    map['image_url'] = Variable<String>(imageUrl);
    map['image_key'] = Variable<String>(imageKey);
    return map;
  }

  PointImagesCompanion toCompanion(bool nullToAbsent) {
    return PointImagesCompanion(
      guid: Value(guid),
      isDeleted: Value(isDeleted),
      timestamp: Value(timestamp),
      currentTimestamp: Value(currentTimestamp),
      lastSyncTime: lastSyncTime == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncTime),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      pointGuid: Value(pointGuid),
      latitude: Value(latitude),
      longitude: Value(longitude),
      accuracy: Value(accuracy),
      imageUrl: Value(imageUrl),
      imageKey: Value(imageKey),
    );
  }

  factory PointImage.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PointImage(
      guid: serializer.fromJson<String>(json['guid']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      currentTimestamp: serializer.fromJson<DateTime>(json['currentTimestamp']),
      lastSyncTime: serializer.fromJson<DateTime?>(json['lastSyncTime']),
      needSync: serializer.fromJson<bool>(json['needSync']),
      isNew: serializer.fromJson<bool>(json['isNew']),
      id: serializer.fromJson<int?>(json['id']),
      pointGuid: serializer.fromJson<String>(json['pointGuid']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      accuracy: serializer.fromJson<double>(json['accuracy']),
      imageUrl: serializer.fromJson<String>(json['imageUrl']),
      imageKey: serializer.fromJson<String>(json['imageKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'guid': serializer.toJson<String>(guid),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'currentTimestamp': serializer.toJson<DateTime>(currentTimestamp),
      'lastSyncTime': serializer.toJson<DateTime?>(lastSyncTime),
      'needSync': serializer.toJson<bool>(needSync),
      'isNew': serializer.toJson<bool>(isNew),
      'id': serializer.toJson<int?>(id),
      'pointGuid': serializer.toJson<String>(pointGuid),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'accuracy': serializer.toJson<double>(accuracy),
      'imageUrl': serializer.toJson<String>(imageUrl),
      'imageKey': serializer.toJson<String>(imageKey),
    };
  }

  PointImage copyWith(
          {String? guid,
          bool? isDeleted,
          DateTime? timestamp,
          DateTime? currentTimestamp,
          Value<DateTime?> lastSyncTime = const Value.absent(),
          bool? needSync,
          bool? isNew,
          Value<int?> id = const Value.absent(),
          String? pointGuid,
          double? latitude,
          double? longitude,
          double? accuracy,
          String? imageUrl,
          String? imageKey}) =>
      PointImage(
        guid: guid ?? this.guid,
        isDeleted: isDeleted ?? this.isDeleted,
        timestamp: timestamp ?? this.timestamp,
        currentTimestamp: currentTimestamp ?? this.currentTimestamp,
        lastSyncTime:
            lastSyncTime.present ? lastSyncTime.value : this.lastSyncTime,
        needSync: needSync ?? this.needSync,
        isNew: isNew ?? this.isNew,
        id: id.present ? id.value : this.id,
        pointGuid: pointGuid ?? this.pointGuid,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        accuracy: accuracy ?? this.accuracy,
        imageUrl: imageUrl ?? this.imageUrl,
        imageKey: imageKey ?? this.imageKey,
      );
  @override
  String toString() {
    return (StringBuffer('PointImage(')
          ..write('guid: $guid, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('timestamp: $timestamp, ')
          ..write('currentTimestamp: $currentTimestamp, ')
          ..write('lastSyncTime: $lastSyncTime, ')
          ..write('needSync: $needSync, ')
          ..write('isNew: $isNew, ')
          ..write('id: $id, ')
          ..write('pointGuid: $pointGuid, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('accuracy: $accuracy, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('imageKey: $imageKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      guid,
      isDeleted,
      timestamp,
      currentTimestamp,
      lastSyncTime,
      needSync,
      isNew,
      id,
      pointGuid,
      latitude,
      longitude,
      accuracy,
      imageUrl,
      imageKey);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PointImage &&
          other.guid == this.guid &&
          other.isDeleted == this.isDeleted &&
          other.timestamp == this.timestamp &&
          other.currentTimestamp == this.currentTimestamp &&
          other.lastSyncTime == this.lastSyncTime &&
          other.needSync == this.needSync &&
          other.isNew == this.isNew &&
          other.id == this.id &&
          other.pointGuid == this.pointGuid &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.accuracy == this.accuracy &&
          other.imageUrl == this.imageUrl &&
          other.imageKey == this.imageKey);
}

class PointImagesCompanion extends UpdateCompanion<PointImage> {
  final Value<String> guid;
  final Value<bool> isDeleted;
  final Value<DateTime> timestamp;
  final Value<DateTime> currentTimestamp;
  final Value<DateTime?> lastSyncTime;
  final Value<int?> id;
  final Value<String> pointGuid;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<double> accuracy;
  final Value<String> imageUrl;
  final Value<String> imageKey;
  final Value<int> rowid;
  const PointImagesCompanion({
    this.guid = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.currentTimestamp = const Value.absent(),
    this.lastSyncTime = const Value.absent(),
    this.id = const Value.absent(),
    this.pointGuid = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.imageKey = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PointImagesCompanion.insert({
    required String guid,
    this.isDeleted = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.currentTimestamp = const Value.absent(),
    this.lastSyncTime = const Value.absent(),
    this.id = const Value.absent(),
    required String pointGuid,
    required double latitude,
    required double longitude,
    required double accuracy,
    required String imageUrl,
    required String imageKey,
    this.rowid = const Value.absent(),
  })  : guid = Value(guid),
        pointGuid = Value(pointGuid),
        latitude = Value(latitude),
        longitude = Value(longitude),
        accuracy = Value(accuracy),
        imageUrl = Value(imageUrl),
        imageKey = Value(imageKey);
  static Insertable<PointImage> custom({
    Expression<String>? guid,
    Expression<bool>? isDeleted,
    Expression<DateTime>? timestamp,
    Expression<DateTime>? currentTimestamp,
    Expression<DateTime>? lastSyncTime,
    Expression<int>? id,
    Expression<String>? pointGuid,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? accuracy,
    Expression<String>? imageUrl,
    Expression<String>? imageKey,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (guid != null) 'guid': guid,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (timestamp != null) 'timestamp': timestamp,
      if (currentTimestamp != null) 'current_timestamp': currentTimestamp,
      if (lastSyncTime != null) 'last_sync_time': lastSyncTime,
      if (id != null) 'id': id,
      if (pointGuid != null) 'point_guid': pointGuid,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (accuracy != null) 'accuracy': accuracy,
      if (imageUrl != null) 'image_url': imageUrl,
      if (imageKey != null) 'image_key': imageKey,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PointImagesCompanion copyWith(
      {Value<String>? guid,
      Value<bool>? isDeleted,
      Value<DateTime>? timestamp,
      Value<DateTime>? currentTimestamp,
      Value<DateTime?>? lastSyncTime,
      Value<int?>? id,
      Value<String>? pointGuid,
      Value<double>? latitude,
      Value<double>? longitude,
      Value<double>? accuracy,
      Value<String>? imageUrl,
      Value<String>? imageKey,
      Value<int>? rowid}) {
    return PointImagesCompanion(
      guid: guid ?? this.guid,
      isDeleted: isDeleted ?? this.isDeleted,
      timestamp: timestamp ?? this.timestamp,
      currentTimestamp: currentTimestamp ?? this.currentTimestamp,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      id: id ?? this.id,
      pointGuid: pointGuid ?? this.pointGuid,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      imageUrl: imageUrl ?? this.imageUrl,
      imageKey: imageKey ?? this.imageKey,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (guid.present) {
      map['guid'] = Variable<String>(guid.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (currentTimestamp.present) {
      map['current_timestamp'] = Variable<DateTime>(currentTimestamp.value);
    }
    if (lastSyncTime.present) {
      map['last_sync_time'] = Variable<DateTime>(lastSyncTime.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pointGuid.present) {
      map['point_guid'] = Variable<String>(pointGuid.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (accuracy.present) {
      map['accuracy'] = Variable<double>(accuracy.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (imageKey.present) {
      map['image_key'] = Variable<String>(imageKey.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PointImagesCompanion(')
          ..write('guid: $guid, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('timestamp: $timestamp, ')
          ..write('currentTimestamp: $currentTimestamp, ')
          ..write('lastSyncTime: $lastSyncTime, ')
          ..write('id: $id, ')
          ..write('pointGuid: $pointGuid, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('accuracy: $accuracy, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('imageKey: $imageKey, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DepositsTable extends Deposits with TableInfo<$DepositsTable, Deposit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DepositsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _guidMeta = const VerificationMeta('guid');
  @override
  late final GeneratedColumn<String> guid = GeneratedColumn<String>(
      'guid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted =
      GeneratedColumn<bool>('is_deleted', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_deleted" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _currentTimestampMeta =
      const VerificationMeta('currentTimestamp');
  @override
  late final GeneratedColumn<DateTime> currentTimestamp =
      GeneratedColumn<DateTime>('current_timestamp', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  static const VerificationMeta _lastSyncTimeMeta =
      const VerificationMeta('lastSyncTime');
  @override
  late final GeneratedColumn<DateTime> lastSyncTime = GeneratedColumn<DateTime>(
      'last_sync_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _needSyncMeta =
      const VerificationMeta('needSync');
  @override
  late final GeneratedColumn<bool> needSync = GeneratedColumn<bool>(
      'need_sync', aliasedName, false,
      generatedAs: GeneratedAs(
          (isNew & isDeleted.not()) |
              (isNew.not() & lastSyncTime.isSmallerThan(timestamp)),
          true),
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
        SqlDialect.sqlite: 'CHECK ("need_sync" IN (0, 1))',
        SqlDialect.mysql: '',
        SqlDialect.postgres: '',
      }));
  static const VerificationMeta _isNewMeta = const VerificationMeta('isNew');
  @override
  late final GeneratedColumn<bool> isNew =
      GeneratedColumn<bool>('is_new', aliasedName, false,
          generatedAs: GeneratedAs(lastSyncTime.isNull(), false),
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_new" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _totalSumMeta =
      const VerificationMeta('totalSum');
  @override
  late final GeneratedColumn<double> totalSum = GeneratedColumn<double>(
      'total_sum', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _checkTotalSumMeta =
      const VerificationMeta('checkTotalSum');
  @override
  late final GeneratedColumn<double> checkTotalSum = GeneratedColumn<double>(
      'check_total_sum', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        guid,
        isDeleted,
        timestamp,
        currentTimestamp,
        lastSyncTime,
        needSync,
        isNew,
        id,
        date,
        totalSum,
        checkTotalSum
      ];
  @override
  String get aliasedName => _alias ?? 'deposits';
  @override
  String get actualTableName => 'deposits';
  @override
  VerificationContext validateIntegrity(Insertable<Deposit> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('guid')) {
      context.handle(
          _guidMeta, guid.isAcceptableOrUnknown(data['guid']!, _guidMeta));
    } else if (isInserting) {
      context.missing(_guidMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    }
    if (data.containsKey('current_timestamp')) {
      context.handle(
          _currentTimestampMeta,
          currentTimestamp.isAcceptableOrUnknown(
              data['current_timestamp']!, _currentTimestampMeta));
    }
    if (data.containsKey('last_sync_time')) {
      context.handle(
          _lastSyncTimeMeta,
          lastSyncTime.isAcceptableOrUnknown(
              data['last_sync_time']!, _lastSyncTimeMeta));
    }
    if (data.containsKey('need_sync')) {
      context.handle(_needSyncMeta,
          needSync.isAcceptableOrUnknown(data['need_sync']!, _needSyncMeta));
    }
    if (data.containsKey('is_new')) {
      context.handle(
          _isNewMeta, isNew.isAcceptableOrUnknown(data['is_new']!, _isNewMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('total_sum')) {
      context.handle(_totalSumMeta,
          totalSum.isAcceptableOrUnknown(data['total_sum']!, _totalSumMeta));
    } else if (isInserting) {
      context.missing(_totalSumMeta);
    }
    if (data.containsKey('check_total_sum')) {
      context.handle(
          _checkTotalSumMeta,
          checkTotalSum.isAcceptableOrUnknown(
              data['check_total_sum']!, _checkTotalSumMeta));
    } else if (isInserting) {
      context.missing(_checkTotalSumMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {guid};
  @override
  Deposit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Deposit(
      guid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guid'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      currentTimestamp: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}current_timestamp'])!,
      lastSyncTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_sync_time']),
      needSync: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}need_sync'])!,
      isNew: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_new'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      totalSum: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_sum'])!,
      checkTotalSum: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}check_total_sum'])!,
    );
  }

  @override
  $DepositsTable createAlias(String alias) {
    return $DepositsTable(attachedDatabase, alias);
  }
}

class Deposit extends DataClass implements Insertable<Deposit> {
  final String guid;
  final bool isDeleted;
  final DateTime timestamp;
  final DateTime currentTimestamp;
  final DateTime? lastSyncTime;
  final bool needSync;
  final bool isNew;
  final int? id;
  final DateTime date;
  final double totalSum;
  final double checkTotalSum;
  const Deposit(
      {required this.guid,
      required this.isDeleted,
      required this.timestamp,
      required this.currentTimestamp,
      this.lastSyncTime,
      required this.needSync,
      required this.isNew,
      this.id,
      required this.date,
      required this.totalSum,
      required this.checkTotalSum});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['guid'] = Variable<String>(guid);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['current_timestamp'] = Variable<DateTime>(currentTimestamp);
    if (!nullToAbsent || lastSyncTime != null) {
      map['last_sync_time'] = Variable<DateTime>(lastSyncTime);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    map['date'] = Variable<DateTime>(date);
    map['total_sum'] = Variable<double>(totalSum);
    map['check_total_sum'] = Variable<double>(checkTotalSum);
    return map;
  }

  DepositsCompanion toCompanion(bool nullToAbsent) {
    return DepositsCompanion(
      guid: Value(guid),
      isDeleted: Value(isDeleted),
      timestamp: Value(timestamp),
      currentTimestamp: Value(currentTimestamp),
      lastSyncTime: lastSyncTime == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncTime),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      date: Value(date),
      totalSum: Value(totalSum),
      checkTotalSum: Value(checkTotalSum),
    );
  }

  factory Deposit.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Deposit(
      guid: serializer.fromJson<String>(json['guid']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      currentTimestamp: serializer.fromJson<DateTime>(json['currentTimestamp']),
      lastSyncTime: serializer.fromJson<DateTime?>(json['lastSyncTime']),
      needSync: serializer.fromJson<bool>(json['needSync']),
      isNew: serializer.fromJson<bool>(json['isNew']),
      id: serializer.fromJson<int?>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      totalSum: serializer.fromJson<double>(json['totalSum']),
      checkTotalSum: serializer.fromJson<double>(json['checkTotalSum']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'guid': serializer.toJson<String>(guid),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'currentTimestamp': serializer.toJson<DateTime>(currentTimestamp),
      'lastSyncTime': serializer.toJson<DateTime?>(lastSyncTime),
      'needSync': serializer.toJson<bool>(needSync),
      'isNew': serializer.toJson<bool>(isNew),
      'id': serializer.toJson<int?>(id),
      'date': serializer.toJson<DateTime>(date),
      'totalSum': serializer.toJson<double>(totalSum),
      'checkTotalSum': serializer.toJson<double>(checkTotalSum),
    };
  }

  Deposit copyWith(
          {String? guid,
          bool? isDeleted,
          DateTime? timestamp,
          DateTime? currentTimestamp,
          Value<DateTime?> lastSyncTime = const Value.absent(),
          bool? needSync,
          bool? isNew,
          Value<int?> id = const Value.absent(),
          DateTime? date,
          double? totalSum,
          double? checkTotalSum}) =>
      Deposit(
        guid: guid ?? this.guid,
        isDeleted: isDeleted ?? this.isDeleted,
        timestamp: timestamp ?? this.timestamp,
        currentTimestamp: currentTimestamp ?? this.currentTimestamp,
        lastSyncTime:
            lastSyncTime.present ? lastSyncTime.value : this.lastSyncTime,
        needSync: needSync ?? this.needSync,
        isNew: isNew ?? this.isNew,
        id: id.present ? id.value : this.id,
        date: date ?? this.date,
        totalSum: totalSum ?? this.totalSum,
        checkTotalSum: checkTotalSum ?? this.checkTotalSum,
      );
  @override
  String toString() {
    return (StringBuffer('Deposit(')
          ..write('guid: $guid, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('timestamp: $timestamp, ')
          ..write('currentTimestamp: $currentTimestamp, ')
          ..write('lastSyncTime: $lastSyncTime, ')
          ..write('needSync: $needSync, ')
          ..write('isNew: $isNew, ')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('totalSum: $totalSum, ')
          ..write('checkTotalSum: $checkTotalSum')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(guid, isDeleted, timestamp, currentTimestamp,
      lastSyncTime, needSync, isNew, id, date, totalSum, checkTotalSum);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Deposit &&
          other.guid == this.guid &&
          other.isDeleted == this.isDeleted &&
          other.timestamp == this.timestamp &&
          other.currentTimestamp == this.currentTimestamp &&
          other.lastSyncTime == this.lastSyncTime &&
          other.needSync == this.needSync &&
          other.isNew == this.isNew &&
          other.id == this.id &&
          other.date == this.date &&
          other.totalSum == this.totalSum &&
          other.checkTotalSum == this.checkTotalSum);
}

class DepositsCompanion extends UpdateCompanion<Deposit> {
  final Value<String> guid;
  final Value<bool> isDeleted;
  final Value<DateTime> timestamp;
  final Value<DateTime> currentTimestamp;
  final Value<DateTime?> lastSyncTime;
  final Value<int?> id;
  final Value<DateTime> date;
  final Value<double> totalSum;
  final Value<double> checkTotalSum;
  final Value<int> rowid;
  const DepositsCompanion({
    this.guid = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.currentTimestamp = const Value.absent(),
    this.lastSyncTime = const Value.absent(),
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.totalSum = const Value.absent(),
    this.checkTotalSum = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DepositsCompanion.insert({
    required String guid,
    this.isDeleted = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.currentTimestamp = const Value.absent(),
    this.lastSyncTime = const Value.absent(),
    this.id = const Value.absent(),
    required DateTime date,
    required double totalSum,
    required double checkTotalSum,
    this.rowid = const Value.absent(),
  })  : guid = Value(guid),
        date = Value(date),
        totalSum = Value(totalSum),
        checkTotalSum = Value(checkTotalSum);
  static Insertable<Deposit> custom({
    Expression<String>? guid,
    Expression<bool>? isDeleted,
    Expression<DateTime>? timestamp,
    Expression<DateTime>? currentTimestamp,
    Expression<DateTime>? lastSyncTime,
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<double>? totalSum,
    Expression<double>? checkTotalSum,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (guid != null) 'guid': guid,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (timestamp != null) 'timestamp': timestamp,
      if (currentTimestamp != null) 'current_timestamp': currentTimestamp,
      if (lastSyncTime != null) 'last_sync_time': lastSyncTime,
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (totalSum != null) 'total_sum': totalSum,
      if (checkTotalSum != null) 'check_total_sum': checkTotalSum,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DepositsCompanion copyWith(
      {Value<String>? guid,
      Value<bool>? isDeleted,
      Value<DateTime>? timestamp,
      Value<DateTime>? currentTimestamp,
      Value<DateTime?>? lastSyncTime,
      Value<int?>? id,
      Value<DateTime>? date,
      Value<double>? totalSum,
      Value<double>? checkTotalSum,
      Value<int>? rowid}) {
    return DepositsCompanion(
      guid: guid ?? this.guid,
      isDeleted: isDeleted ?? this.isDeleted,
      timestamp: timestamp ?? this.timestamp,
      currentTimestamp: currentTimestamp ?? this.currentTimestamp,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      id: id ?? this.id,
      date: date ?? this.date,
      totalSum: totalSum ?? this.totalSum,
      checkTotalSum: checkTotalSum ?? this.checkTotalSum,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (guid.present) {
      map['guid'] = Variable<String>(guid.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (currentTimestamp.present) {
      map['current_timestamp'] = Variable<DateTime>(currentTimestamp.value);
    }
    if (lastSyncTime.present) {
      map['last_sync_time'] = Variable<DateTime>(lastSyncTime.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (totalSum.present) {
      map['total_sum'] = Variable<double>(totalSum.value);
    }
    if (checkTotalSum.present) {
      map['check_total_sum'] = Variable<double>(checkTotalSum.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DepositsCompanion(')
          ..write('guid: $guid, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('timestamp: $timestamp, ')
          ..write('currentTimestamp: $currentTimestamp, ')
          ..write('lastSyncTime: $lastSyncTime, ')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('totalSum: $totalSum, ')
          ..write('checkTotalSum: $checkTotalSum, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EncashmentsTable extends Encashments
    with TableInfo<$EncashmentsTable, Encashment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EncashmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _guidMeta = const VerificationMeta('guid');
  @override
  late final GeneratedColumn<String> guid = GeneratedColumn<String>(
      'guid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted =
      GeneratedColumn<bool>('is_deleted', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_deleted" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _currentTimestampMeta =
      const VerificationMeta('currentTimestamp');
  @override
  late final GeneratedColumn<DateTime> currentTimestamp =
      GeneratedColumn<DateTime>('current_timestamp', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  static const VerificationMeta _lastSyncTimeMeta =
      const VerificationMeta('lastSyncTime');
  @override
  late final GeneratedColumn<DateTime> lastSyncTime = GeneratedColumn<DateTime>(
      'last_sync_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _needSyncMeta =
      const VerificationMeta('needSync');
  @override
  late final GeneratedColumn<bool> needSync = GeneratedColumn<bool>(
      'need_sync', aliasedName, false,
      generatedAs: GeneratedAs(
          (isNew & isDeleted.not()) |
              (isNew.not() & lastSyncTime.isSmallerThan(timestamp)),
          true),
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
        SqlDialect.sqlite: 'CHECK ("need_sync" IN (0, 1))',
        SqlDialect.mysql: '',
        SqlDialect.postgres: '',
      }));
  static const VerificationMeta _isNewMeta = const VerificationMeta('isNew');
  @override
  late final GeneratedColumn<bool> isNew =
      GeneratedColumn<bool>('is_new', aliasedName, false,
          generatedAs: GeneratedAs(lastSyncTime.isNull(), false),
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_new" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _depositGuidMeta =
      const VerificationMeta('depositGuid');
  @override
  late final GeneratedColumn<String> depositGuid = GeneratedColumn<String>(
      'deposit_guid', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES deposits (guid) ON UPDATE CASCADE ON DELETE CASCADE'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isCheckMeta =
      const VerificationMeta('isCheck');
  @override
  late final GeneratedColumn<bool> isCheck =
      GeneratedColumn<bool>('is_check', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_check" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  static const VerificationMeta _buyerIdMeta =
      const VerificationMeta('buyerId');
  @override
  late final GeneratedColumn<int> buyerId = GeneratedColumn<int>(
      'buyer_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _debtIdMeta = const VerificationMeta('debtId');
  @override
  late final GeneratedColumn<int> debtId = GeneratedColumn<int>(
      'debt_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _encSumMeta = const VerificationMeta('encSum');
  @override
  late final GeneratedColumn<double> encSum = GeneratedColumn<double>(
      'enc_sum', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        guid,
        isDeleted,
        timestamp,
        currentTimestamp,
        lastSyncTime,
        needSync,
        isNew,
        id,
        depositGuid,
        date,
        isCheck,
        buyerId,
        debtId,
        encSum
      ];
  @override
  String get aliasedName => _alias ?? 'encashments';
  @override
  String get actualTableName => 'encashments';
  @override
  VerificationContext validateIntegrity(Insertable<Encashment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('guid')) {
      context.handle(
          _guidMeta, guid.isAcceptableOrUnknown(data['guid']!, _guidMeta));
    } else if (isInserting) {
      context.missing(_guidMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    }
    if (data.containsKey('current_timestamp')) {
      context.handle(
          _currentTimestampMeta,
          currentTimestamp.isAcceptableOrUnknown(
              data['current_timestamp']!, _currentTimestampMeta));
    }
    if (data.containsKey('last_sync_time')) {
      context.handle(
          _lastSyncTimeMeta,
          lastSyncTime.isAcceptableOrUnknown(
              data['last_sync_time']!, _lastSyncTimeMeta));
    }
    if (data.containsKey('need_sync')) {
      context.handle(_needSyncMeta,
          needSync.isAcceptableOrUnknown(data['need_sync']!, _needSyncMeta));
    }
    if (data.containsKey('is_new')) {
      context.handle(
          _isNewMeta, isNew.isAcceptableOrUnknown(data['is_new']!, _isNewMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('deposit_guid')) {
      context.handle(
          _depositGuidMeta,
          depositGuid.isAcceptableOrUnknown(
              data['deposit_guid']!, _depositGuidMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('is_check')) {
      context.handle(_isCheckMeta,
          isCheck.isAcceptableOrUnknown(data['is_check']!, _isCheckMeta));
    } else if (isInserting) {
      context.missing(_isCheckMeta);
    }
    if (data.containsKey('buyer_id')) {
      context.handle(_buyerIdMeta,
          buyerId.isAcceptableOrUnknown(data['buyer_id']!, _buyerIdMeta));
    } else if (isInserting) {
      context.missing(_buyerIdMeta);
    }
    if (data.containsKey('debt_id')) {
      context.handle(_debtIdMeta,
          debtId.isAcceptableOrUnknown(data['debt_id']!, _debtIdMeta));
    }
    if (data.containsKey('enc_sum')) {
      context.handle(_encSumMeta,
          encSum.isAcceptableOrUnknown(data['enc_sum']!, _encSumMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {guid};
  @override
  Encashment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Encashment(
      guid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guid'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      currentTimestamp: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}current_timestamp'])!,
      lastSyncTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_sync_time']),
      needSync: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}need_sync'])!,
      isNew: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_new'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id']),
      depositGuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}deposit_guid']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      isCheck: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_check'])!,
      buyerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}buyer_id'])!,
      debtId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}debt_id']),
      encSum: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}enc_sum']),
    );
  }

  @override
  $EncashmentsTable createAlias(String alias) {
    return $EncashmentsTable(attachedDatabase, alias);
  }
}

class Encashment extends DataClass implements Insertable<Encashment> {
  final String guid;
  final bool isDeleted;
  final DateTime timestamp;
  final DateTime currentTimestamp;
  final DateTime? lastSyncTime;
  final bool needSync;
  final bool isNew;
  final int? id;
  final String? depositGuid;
  final DateTime date;
  final bool isCheck;
  final int buyerId;
  final int? debtId;
  final double? encSum;
  const Encashment(
      {required this.guid,
      required this.isDeleted,
      required this.timestamp,
      required this.currentTimestamp,
      this.lastSyncTime,
      required this.needSync,
      required this.isNew,
      this.id,
      this.depositGuid,
      required this.date,
      required this.isCheck,
      required this.buyerId,
      this.debtId,
      this.encSum});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['guid'] = Variable<String>(guid);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['current_timestamp'] = Variable<DateTime>(currentTimestamp);
    if (!nullToAbsent || lastSyncTime != null) {
      map['last_sync_time'] = Variable<DateTime>(lastSyncTime);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || depositGuid != null) {
      map['deposit_guid'] = Variable<String>(depositGuid);
    }
    map['date'] = Variable<DateTime>(date);
    map['is_check'] = Variable<bool>(isCheck);
    map['buyer_id'] = Variable<int>(buyerId);
    if (!nullToAbsent || debtId != null) {
      map['debt_id'] = Variable<int>(debtId);
    }
    if (!nullToAbsent || encSum != null) {
      map['enc_sum'] = Variable<double>(encSum);
    }
    return map;
  }

  EncashmentsCompanion toCompanion(bool nullToAbsent) {
    return EncashmentsCompanion(
      guid: Value(guid),
      isDeleted: Value(isDeleted),
      timestamp: Value(timestamp),
      currentTimestamp: Value(currentTimestamp),
      lastSyncTime: lastSyncTime == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncTime),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      depositGuid: depositGuid == null && nullToAbsent
          ? const Value.absent()
          : Value(depositGuid),
      date: Value(date),
      isCheck: Value(isCheck),
      buyerId: Value(buyerId),
      debtId:
          debtId == null && nullToAbsent ? const Value.absent() : Value(debtId),
      encSum:
          encSum == null && nullToAbsent ? const Value.absent() : Value(encSum),
    );
  }

  factory Encashment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Encashment(
      guid: serializer.fromJson<String>(json['guid']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      currentTimestamp: serializer.fromJson<DateTime>(json['currentTimestamp']),
      lastSyncTime: serializer.fromJson<DateTime?>(json['lastSyncTime']),
      needSync: serializer.fromJson<bool>(json['needSync']),
      isNew: serializer.fromJson<bool>(json['isNew']),
      id: serializer.fromJson<int?>(json['id']),
      depositGuid: serializer.fromJson<String?>(json['depositGuid']),
      date: serializer.fromJson<DateTime>(json['date']),
      isCheck: serializer.fromJson<bool>(json['isCheck']),
      buyerId: serializer.fromJson<int>(json['buyerId']),
      debtId: serializer.fromJson<int?>(json['debtId']),
      encSum: serializer.fromJson<double?>(json['encSum']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'guid': serializer.toJson<String>(guid),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'currentTimestamp': serializer.toJson<DateTime>(currentTimestamp),
      'lastSyncTime': serializer.toJson<DateTime?>(lastSyncTime),
      'needSync': serializer.toJson<bool>(needSync),
      'isNew': serializer.toJson<bool>(isNew),
      'id': serializer.toJson<int?>(id),
      'depositGuid': serializer.toJson<String?>(depositGuid),
      'date': serializer.toJson<DateTime>(date),
      'isCheck': serializer.toJson<bool>(isCheck),
      'buyerId': serializer.toJson<int>(buyerId),
      'debtId': serializer.toJson<int?>(debtId),
      'encSum': serializer.toJson<double?>(encSum),
    };
  }

  Encashment copyWith(
          {String? guid,
          bool? isDeleted,
          DateTime? timestamp,
          DateTime? currentTimestamp,
          Value<DateTime?> lastSyncTime = const Value.absent(),
          bool? needSync,
          bool? isNew,
          Value<int?> id = const Value.absent(),
          Value<String?> depositGuid = const Value.absent(),
          DateTime? date,
          bool? isCheck,
          int? buyerId,
          Value<int?> debtId = const Value.absent(),
          Value<double?> encSum = const Value.absent()}) =>
      Encashment(
        guid: guid ?? this.guid,
        isDeleted: isDeleted ?? this.isDeleted,
        timestamp: timestamp ?? this.timestamp,
        currentTimestamp: currentTimestamp ?? this.currentTimestamp,
        lastSyncTime:
            lastSyncTime.present ? lastSyncTime.value : this.lastSyncTime,
        needSync: needSync ?? this.needSync,
        isNew: isNew ?? this.isNew,
        id: id.present ? id.value : this.id,
        depositGuid: depositGuid.present ? depositGuid.value : this.depositGuid,
        date: date ?? this.date,
        isCheck: isCheck ?? this.isCheck,
        buyerId: buyerId ?? this.buyerId,
        debtId: debtId.present ? debtId.value : this.debtId,
        encSum: encSum.present ? encSum.value : this.encSum,
      );
  @override
  String toString() {
    return (StringBuffer('Encashment(')
          ..write('guid: $guid, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('timestamp: $timestamp, ')
          ..write('currentTimestamp: $currentTimestamp, ')
          ..write('lastSyncTime: $lastSyncTime, ')
          ..write('needSync: $needSync, ')
          ..write('isNew: $isNew, ')
          ..write('id: $id, ')
          ..write('depositGuid: $depositGuid, ')
          ..write('date: $date, ')
          ..write('isCheck: $isCheck, ')
          ..write('buyerId: $buyerId, ')
          ..write('debtId: $debtId, ')
          ..write('encSum: $encSum')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      guid,
      isDeleted,
      timestamp,
      currentTimestamp,
      lastSyncTime,
      needSync,
      isNew,
      id,
      depositGuid,
      date,
      isCheck,
      buyerId,
      debtId,
      encSum);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Encashment &&
          other.guid == this.guid &&
          other.isDeleted == this.isDeleted &&
          other.timestamp == this.timestamp &&
          other.currentTimestamp == this.currentTimestamp &&
          other.lastSyncTime == this.lastSyncTime &&
          other.needSync == this.needSync &&
          other.isNew == this.isNew &&
          other.id == this.id &&
          other.depositGuid == this.depositGuid &&
          other.date == this.date &&
          other.isCheck == this.isCheck &&
          other.buyerId == this.buyerId &&
          other.debtId == this.debtId &&
          other.encSum == this.encSum);
}

class EncashmentsCompanion extends UpdateCompanion<Encashment> {
  final Value<String> guid;
  final Value<bool> isDeleted;
  final Value<DateTime> timestamp;
  final Value<DateTime> currentTimestamp;
  final Value<DateTime?> lastSyncTime;
  final Value<int?> id;
  final Value<String?> depositGuid;
  final Value<DateTime> date;
  final Value<bool> isCheck;
  final Value<int> buyerId;
  final Value<int?> debtId;
  final Value<double?> encSum;
  final Value<int> rowid;
  const EncashmentsCompanion({
    this.guid = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.currentTimestamp = const Value.absent(),
    this.lastSyncTime = const Value.absent(),
    this.id = const Value.absent(),
    this.depositGuid = const Value.absent(),
    this.date = const Value.absent(),
    this.isCheck = const Value.absent(),
    this.buyerId = const Value.absent(),
    this.debtId = const Value.absent(),
    this.encSum = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EncashmentsCompanion.insert({
    required String guid,
    this.isDeleted = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.currentTimestamp = const Value.absent(),
    this.lastSyncTime = const Value.absent(),
    this.id = const Value.absent(),
    this.depositGuid = const Value.absent(),
    required DateTime date,
    required bool isCheck,
    required int buyerId,
    this.debtId = const Value.absent(),
    this.encSum = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : guid = Value(guid),
        date = Value(date),
        isCheck = Value(isCheck),
        buyerId = Value(buyerId);
  static Insertable<Encashment> custom({
    Expression<String>? guid,
    Expression<bool>? isDeleted,
    Expression<DateTime>? timestamp,
    Expression<DateTime>? currentTimestamp,
    Expression<DateTime>? lastSyncTime,
    Expression<int>? id,
    Expression<String>? depositGuid,
    Expression<DateTime>? date,
    Expression<bool>? isCheck,
    Expression<int>? buyerId,
    Expression<int>? debtId,
    Expression<double>? encSum,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (guid != null) 'guid': guid,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (timestamp != null) 'timestamp': timestamp,
      if (currentTimestamp != null) 'current_timestamp': currentTimestamp,
      if (lastSyncTime != null) 'last_sync_time': lastSyncTime,
      if (id != null) 'id': id,
      if (depositGuid != null) 'deposit_guid': depositGuid,
      if (date != null) 'date': date,
      if (isCheck != null) 'is_check': isCheck,
      if (buyerId != null) 'buyer_id': buyerId,
      if (debtId != null) 'debt_id': debtId,
      if (encSum != null) 'enc_sum': encSum,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EncashmentsCompanion copyWith(
      {Value<String>? guid,
      Value<bool>? isDeleted,
      Value<DateTime>? timestamp,
      Value<DateTime>? currentTimestamp,
      Value<DateTime?>? lastSyncTime,
      Value<int?>? id,
      Value<String?>? depositGuid,
      Value<DateTime>? date,
      Value<bool>? isCheck,
      Value<int>? buyerId,
      Value<int?>? debtId,
      Value<double?>? encSum,
      Value<int>? rowid}) {
    return EncashmentsCompanion(
      guid: guid ?? this.guid,
      isDeleted: isDeleted ?? this.isDeleted,
      timestamp: timestamp ?? this.timestamp,
      currentTimestamp: currentTimestamp ?? this.currentTimestamp,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      id: id ?? this.id,
      depositGuid: depositGuid ?? this.depositGuid,
      date: date ?? this.date,
      isCheck: isCheck ?? this.isCheck,
      buyerId: buyerId ?? this.buyerId,
      debtId: debtId ?? this.debtId,
      encSum: encSum ?? this.encSum,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (guid.present) {
      map['guid'] = Variable<String>(guid.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (currentTimestamp.present) {
      map['current_timestamp'] = Variable<DateTime>(currentTimestamp.value);
    }
    if (lastSyncTime.present) {
      map['last_sync_time'] = Variable<DateTime>(lastSyncTime.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (depositGuid.present) {
      map['deposit_guid'] = Variable<String>(depositGuid.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (isCheck.present) {
      map['is_check'] = Variable<bool>(isCheck.value);
    }
    if (buyerId.present) {
      map['buyer_id'] = Variable<int>(buyerId.value);
    }
    if (debtId.present) {
      map['debt_id'] = Variable<int>(debtId.value);
    }
    if (encSum.present) {
      map['enc_sum'] = Variable<double>(encSum.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EncashmentsCompanion(')
          ..write('guid: $guid, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('timestamp: $timestamp, ')
          ..write('currentTimestamp: $currentTimestamp, ')
          ..write('lastSyncTime: $lastSyncTime, ')
          ..write('id: $id, ')
          ..write('depositGuid: $depositGuid, ')
          ..write('date: $date, ')
          ..write('isCheck: $isCheck, ')
          ..write('buyerId: $buyerId, ')
          ..write('debtId: $debtId, ')
          ..write('encSum: $encSum, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DebtsTable extends Debts with TableInfo<$DebtsTable, Debt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DebtsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _buyerIdMeta =
      const VerificationMeta('buyerId');
  @override
  late final GeneratedColumn<int> buyerId = GeneratedColumn<int>(
      'buyer_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _infoMeta = const VerificationMeta('info');
  @override
  late final GeneratedColumn<String> info = GeneratedColumn<String>(
      'info', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _debtSumMeta =
      const VerificationMeta('debtSum');
  @override
  late final GeneratedColumn<double> debtSum = GeneratedColumn<double>(
      'debt_sum', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _orderSumMeta =
      const VerificationMeta('orderSum');
  @override
  late final GeneratedColumn<double> orderSum = GeneratedColumn<double>(
      'order_sum', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _isCheckMeta =
      const VerificationMeta('isCheck');
  @override
  late final GeneratedColumn<bool> isCheck =
      GeneratedColumn<bool>('is_check', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_check" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  static const VerificationMeta _dateUntilMeta =
      const VerificationMeta('dateUntil');
  @override
  late final GeneratedColumn<DateTime> dateUntil = GeneratedColumn<DateTime>(
      'date_until', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _overdueMeta =
      const VerificationMeta('overdue');
  @override
  late final GeneratedColumn<bool> overdue =
      GeneratedColumn<bool>('overdue', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("overdue" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  @override
  List<GeneratedColumn> get $columns =>
      [id, date, buyerId, info, debtSum, orderSum, isCheck, dateUntil, overdue];
  @override
  String get aliasedName => _alias ?? 'debts';
  @override
  String get actualTableName => 'debts';
  @override
  VerificationContext validateIntegrity(Insertable<Debt> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('buyer_id')) {
      context.handle(_buyerIdMeta,
          buyerId.isAcceptableOrUnknown(data['buyer_id']!, _buyerIdMeta));
    } else if (isInserting) {
      context.missing(_buyerIdMeta);
    }
    if (data.containsKey('info')) {
      context.handle(
          _infoMeta, info.isAcceptableOrUnknown(data['info']!, _infoMeta));
    }
    if (data.containsKey('debt_sum')) {
      context.handle(_debtSumMeta,
          debtSum.isAcceptableOrUnknown(data['debt_sum']!, _debtSumMeta));
    } else if (isInserting) {
      context.missing(_debtSumMeta);
    }
    if (data.containsKey('order_sum')) {
      context.handle(_orderSumMeta,
          orderSum.isAcceptableOrUnknown(data['order_sum']!, _orderSumMeta));
    } else if (isInserting) {
      context.missing(_orderSumMeta);
    }
    if (data.containsKey('is_check')) {
      context.handle(_isCheckMeta,
          isCheck.isAcceptableOrUnknown(data['is_check']!, _isCheckMeta));
    } else if (isInserting) {
      context.missing(_isCheckMeta);
    }
    if (data.containsKey('date_until')) {
      context.handle(_dateUntilMeta,
          dateUntil.isAcceptableOrUnknown(data['date_until']!, _dateUntilMeta));
    } else if (isInserting) {
      context.missing(_dateUntilMeta);
    }
    if (data.containsKey('overdue')) {
      context.handle(_overdueMeta,
          overdue.isAcceptableOrUnknown(data['overdue']!, _overdueMeta));
    } else if (isInserting) {
      context.missing(_overdueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Debt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Debt(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      buyerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}buyer_id'])!,
      info: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}info']),
      debtSum: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}debt_sum'])!,
      orderSum: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}order_sum'])!,
      isCheck: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_check'])!,
      dateUntil: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_until'])!,
      overdue: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}overdue'])!,
    );
  }

  @override
  $DebtsTable createAlias(String alias) {
    return $DebtsTable(attachedDatabase, alias);
  }
}

class Debt extends DataClass implements Insertable<Debt> {
  final int id;
  final DateTime date;
  final int buyerId;
  final String? info;
  final double debtSum;
  final double orderSum;
  final bool isCheck;
  final DateTime dateUntil;
  final bool overdue;
  const Debt(
      {required this.id,
      required this.date,
      required this.buyerId,
      this.info,
      required this.debtSum,
      required this.orderSum,
      required this.isCheck,
      required this.dateUntil,
      required this.overdue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['buyer_id'] = Variable<int>(buyerId);
    if (!nullToAbsent || info != null) {
      map['info'] = Variable<String>(info);
    }
    map['debt_sum'] = Variable<double>(debtSum);
    map['order_sum'] = Variable<double>(orderSum);
    map['is_check'] = Variable<bool>(isCheck);
    map['date_until'] = Variable<DateTime>(dateUntil);
    map['overdue'] = Variable<bool>(overdue);
    return map;
  }

  DebtsCompanion toCompanion(bool nullToAbsent) {
    return DebtsCompanion(
      id: Value(id),
      date: Value(date),
      buyerId: Value(buyerId),
      info: info == null && nullToAbsent ? const Value.absent() : Value(info),
      debtSum: Value(debtSum),
      orderSum: Value(orderSum),
      isCheck: Value(isCheck),
      dateUntil: Value(dateUntil),
      overdue: Value(overdue),
    );
  }

  factory Debt.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Debt(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      buyerId: serializer.fromJson<int>(json['buyerId']),
      info: serializer.fromJson<String?>(json['info']),
      debtSum: serializer.fromJson<double>(json['debtSum']),
      orderSum: serializer.fromJson<double>(json['orderSum']),
      isCheck: serializer.fromJson<bool>(json['isCheck']),
      dateUntil: serializer.fromJson<DateTime>(json['dateUntil']),
      overdue: serializer.fromJson<bool>(json['overdue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'buyerId': serializer.toJson<int>(buyerId),
      'info': serializer.toJson<String?>(info),
      'debtSum': serializer.toJson<double>(debtSum),
      'orderSum': serializer.toJson<double>(orderSum),
      'isCheck': serializer.toJson<bool>(isCheck),
      'dateUntil': serializer.toJson<DateTime>(dateUntil),
      'overdue': serializer.toJson<bool>(overdue),
    };
  }

  Debt copyWith(
          {int? id,
          DateTime? date,
          int? buyerId,
          Value<String?> info = const Value.absent(),
          double? debtSum,
          double? orderSum,
          bool? isCheck,
          DateTime? dateUntil,
          bool? overdue}) =>
      Debt(
        id: id ?? this.id,
        date: date ?? this.date,
        buyerId: buyerId ?? this.buyerId,
        info: info.present ? info.value : this.info,
        debtSum: debtSum ?? this.debtSum,
        orderSum: orderSum ?? this.orderSum,
        isCheck: isCheck ?? this.isCheck,
        dateUntil: dateUntil ?? this.dateUntil,
        overdue: overdue ?? this.overdue,
      );
  @override
  String toString() {
    return (StringBuffer('Debt(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('buyerId: $buyerId, ')
          ..write('info: $info, ')
          ..write('debtSum: $debtSum, ')
          ..write('orderSum: $orderSum, ')
          ..write('isCheck: $isCheck, ')
          ..write('dateUntil: $dateUntil, ')
          ..write('overdue: $overdue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, date, buyerId, info, debtSum, orderSum, isCheck, dateUntil, overdue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Debt &&
          other.id == this.id &&
          other.date == this.date &&
          other.buyerId == this.buyerId &&
          other.info == this.info &&
          other.debtSum == this.debtSum &&
          other.orderSum == this.orderSum &&
          other.isCheck == this.isCheck &&
          other.dateUntil == this.dateUntil &&
          other.overdue == this.overdue);
}

class DebtsCompanion extends UpdateCompanion<Debt> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> buyerId;
  final Value<String?> info;
  final Value<double> debtSum;
  final Value<double> orderSum;
  final Value<bool> isCheck;
  final Value<DateTime> dateUntil;
  final Value<bool> overdue;
  const DebtsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.buyerId = const Value.absent(),
    this.info = const Value.absent(),
    this.debtSum = const Value.absent(),
    this.orderSum = const Value.absent(),
    this.isCheck = const Value.absent(),
    this.dateUntil = const Value.absent(),
    this.overdue = const Value.absent(),
  });
  DebtsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required int buyerId,
    this.info = const Value.absent(),
    required double debtSum,
    required double orderSum,
    required bool isCheck,
    required DateTime dateUntil,
    required bool overdue,
  })  : date = Value(date),
        buyerId = Value(buyerId),
        debtSum = Value(debtSum),
        orderSum = Value(orderSum),
        isCheck = Value(isCheck),
        dateUntil = Value(dateUntil),
        overdue = Value(overdue);
  static Insertable<Debt> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? buyerId,
    Expression<String>? info,
    Expression<double>? debtSum,
    Expression<double>? orderSum,
    Expression<bool>? isCheck,
    Expression<DateTime>? dateUntil,
    Expression<bool>? overdue,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (buyerId != null) 'buyer_id': buyerId,
      if (info != null) 'info': info,
      if (debtSum != null) 'debt_sum': debtSum,
      if (orderSum != null) 'order_sum': orderSum,
      if (isCheck != null) 'is_check': isCheck,
      if (dateUntil != null) 'date_until': dateUntil,
      if (overdue != null) 'overdue': overdue,
    });
  }

  DebtsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<int>? buyerId,
      Value<String?>? info,
      Value<double>? debtSum,
      Value<double>? orderSum,
      Value<bool>? isCheck,
      Value<DateTime>? dateUntil,
      Value<bool>? overdue}) {
    return DebtsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      buyerId: buyerId ?? this.buyerId,
      info: info ?? this.info,
      debtSum: debtSum ?? this.debtSum,
      orderSum: orderSum ?? this.orderSum,
      isCheck: isCheck ?? this.isCheck,
      dateUntil: dateUntil ?? this.dateUntil,
      overdue: overdue ?? this.overdue,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (buyerId.present) {
      map['buyer_id'] = Variable<int>(buyerId.value);
    }
    if (info.present) {
      map['info'] = Variable<String>(info.value);
    }
    if (debtSum.present) {
      map['debt_sum'] = Variable<double>(debtSum.value);
    }
    if (orderSum.present) {
      map['order_sum'] = Variable<double>(orderSum.value);
    }
    if (isCheck.present) {
      map['is_check'] = Variable<bool>(isCheck.value);
    }
    if (dateUntil.present) {
      map['date_until'] = Variable<DateTime>(dateUntil.value);
    }
    if (overdue.present) {
      map['overdue'] = Variable<bool>(overdue.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DebtsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('buyerId: $buyerId, ')
          ..write('info: $info, ')
          ..write('debtSum: $debtSum, ')
          ..write('orderSum: $orderSum, ')
          ..write('isCheck: $isCheck, ')
          ..write('dateUntil: $dateUntil, ')
          ..write('overdue: $overdue')
          ..write(')'))
        .toString();
  }
}

class $ShipmentsTable extends Shipments
    with TableInfo<$ShipmentsTable, Shipment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShipmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _ndocMeta = const VerificationMeta('ndoc');
  @override
  late final GeneratedColumn<String> ndoc = GeneratedColumn<String>(
      'ndoc', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _infoMeta = const VerificationMeta('info');
  @override
  late final GeneratedColumn<String> info = GeneratedColumn<String>(
      'info', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _debtSumMeta =
      const VerificationMeta('debtSum');
  @override
  late final GeneratedColumn<double> debtSum = GeneratedColumn<double>(
      'debt_sum', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _shipmentSumMeta =
      const VerificationMeta('shipmentSum');
  @override
  late final GeneratedColumn<double> shipmentSum = GeneratedColumn<double>(
      'shipment_sum', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _buyerIdMeta =
      const VerificationMeta('buyerId');
  @override
  late final GeneratedColumn<int> buyerId = GeneratedColumn<int>(
      'buyer_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, date, ndoc, info, status, debtSum, shipmentSum, buyerId];
  @override
  String get aliasedName => _alias ?? 'shipments';
  @override
  String get actualTableName => 'shipments';
  @override
  VerificationContext validateIntegrity(Insertable<Shipment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('ndoc')) {
      context.handle(
          _ndocMeta, ndoc.isAcceptableOrUnknown(data['ndoc']!, _ndocMeta));
    } else if (isInserting) {
      context.missing(_ndocMeta);
    }
    if (data.containsKey('info')) {
      context.handle(
          _infoMeta, info.isAcceptableOrUnknown(data['info']!, _infoMeta));
    } else if (isInserting) {
      context.missing(_infoMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('debt_sum')) {
      context.handle(_debtSumMeta,
          debtSum.isAcceptableOrUnknown(data['debt_sum']!, _debtSumMeta));
    }
    if (data.containsKey('shipment_sum')) {
      context.handle(
          _shipmentSumMeta,
          shipmentSum.isAcceptableOrUnknown(
              data['shipment_sum']!, _shipmentSumMeta));
    } else if (isInserting) {
      context.missing(_shipmentSumMeta);
    }
    if (data.containsKey('buyer_id')) {
      context.handle(_buyerIdMeta,
          buyerId.isAcceptableOrUnknown(data['buyer_id']!, _buyerIdMeta));
    } else if (isInserting) {
      context.missing(_buyerIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Shipment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Shipment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      ndoc: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ndoc'])!,
      info: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}info'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      debtSum: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}debt_sum']),
      shipmentSum: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}shipment_sum'])!,
      buyerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}buyer_id'])!,
    );
  }

  @override
  $ShipmentsTable createAlias(String alias) {
    return $ShipmentsTable(attachedDatabase, alias);
  }
}

class Shipment extends DataClass implements Insertable<Shipment> {
  final int id;
  final DateTime date;
  final String ndoc;
  final String info;
  final String status;
  final double? debtSum;
  final double shipmentSum;
  final int buyerId;
  const Shipment(
      {required this.id,
      required this.date,
      required this.ndoc,
      required this.info,
      required this.status,
      this.debtSum,
      required this.shipmentSum,
      required this.buyerId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['ndoc'] = Variable<String>(ndoc);
    map['info'] = Variable<String>(info);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || debtSum != null) {
      map['debt_sum'] = Variable<double>(debtSum);
    }
    map['shipment_sum'] = Variable<double>(shipmentSum);
    map['buyer_id'] = Variable<int>(buyerId);
    return map;
  }

  ShipmentsCompanion toCompanion(bool nullToAbsent) {
    return ShipmentsCompanion(
      id: Value(id),
      date: Value(date),
      ndoc: Value(ndoc),
      info: Value(info),
      status: Value(status),
      debtSum: debtSum == null && nullToAbsent
          ? const Value.absent()
          : Value(debtSum),
      shipmentSum: Value(shipmentSum),
      buyerId: Value(buyerId),
    );
  }

  factory Shipment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Shipment(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      ndoc: serializer.fromJson<String>(json['ndoc']),
      info: serializer.fromJson<String>(json['info']),
      status: serializer.fromJson<String>(json['status']),
      debtSum: serializer.fromJson<double?>(json['debtSum']),
      shipmentSum: serializer.fromJson<double>(json['shipmentSum']),
      buyerId: serializer.fromJson<int>(json['buyerId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'ndoc': serializer.toJson<String>(ndoc),
      'info': serializer.toJson<String>(info),
      'status': serializer.toJson<String>(status),
      'debtSum': serializer.toJson<double?>(debtSum),
      'shipmentSum': serializer.toJson<double>(shipmentSum),
      'buyerId': serializer.toJson<int>(buyerId),
    };
  }

  Shipment copyWith(
          {int? id,
          DateTime? date,
          String? ndoc,
          String? info,
          String? status,
          Value<double?> debtSum = const Value.absent(),
          double? shipmentSum,
          int? buyerId}) =>
      Shipment(
        id: id ?? this.id,
        date: date ?? this.date,
        ndoc: ndoc ?? this.ndoc,
        info: info ?? this.info,
        status: status ?? this.status,
        debtSum: debtSum.present ? debtSum.value : this.debtSum,
        shipmentSum: shipmentSum ?? this.shipmentSum,
        buyerId: buyerId ?? this.buyerId,
      );
  @override
  String toString() {
    return (StringBuffer('Shipment(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('ndoc: $ndoc, ')
          ..write('info: $info, ')
          ..write('status: $status, ')
          ..write('debtSum: $debtSum, ')
          ..write('shipmentSum: $shipmentSum, ')
          ..write('buyerId: $buyerId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, ndoc, info, status, debtSum, shipmentSum, buyerId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Shipment &&
          other.id == this.id &&
          other.date == this.date &&
          other.ndoc == this.ndoc &&
          other.info == this.info &&
          other.status == this.status &&
          other.debtSum == this.debtSum &&
          other.shipmentSum == this.shipmentSum &&
          other.buyerId == this.buyerId);
}

class ShipmentsCompanion extends UpdateCompanion<Shipment> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> ndoc;
  final Value<String> info;
  final Value<String> status;
  final Value<double?> debtSum;
  final Value<double> shipmentSum;
  final Value<int> buyerId;
  const ShipmentsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.ndoc = const Value.absent(),
    this.info = const Value.absent(),
    this.status = const Value.absent(),
    this.debtSum = const Value.absent(),
    this.shipmentSum = const Value.absent(),
    this.buyerId = const Value.absent(),
  });
  ShipmentsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required String ndoc,
    required String info,
    required String status,
    this.debtSum = const Value.absent(),
    required double shipmentSum,
    required int buyerId,
  })  : date = Value(date),
        ndoc = Value(ndoc),
        info = Value(info),
        status = Value(status),
        shipmentSum = Value(shipmentSum),
        buyerId = Value(buyerId);
  static Insertable<Shipment> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? ndoc,
    Expression<String>? info,
    Expression<String>? status,
    Expression<double>? debtSum,
    Expression<double>? shipmentSum,
    Expression<int>? buyerId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (ndoc != null) 'ndoc': ndoc,
      if (info != null) 'info': info,
      if (status != null) 'status': status,
      if (debtSum != null) 'debt_sum': debtSum,
      if (shipmentSum != null) 'shipment_sum': shipmentSum,
      if (buyerId != null) 'buyer_id': buyerId,
    });
  }

  ShipmentsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<String>? ndoc,
      Value<String>? info,
      Value<String>? status,
      Value<double?>? debtSum,
      Value<double>? shipmentSum,
      Value<int>? buyerId}) {
    return ShipmentsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      ndoc: ndoc ?? this.ndoc,
      info: info ?? this.info,
      status: status ?? this.status,
      debtSum: debtSum ?? this.debtSum,
      shipmentSum: shipmentSum ?? this.shipmentSum,
      buyerId: buyerId ?? this.buyerId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (ndoc.present) {
      map['ndoc'] = Variable<String>(ndoc.value);
    }
    if (info.present) {
      map['info'] = Variable<String>(info.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (debtSum.present) {
      map['debt_sum'] = Variable<double>(debtSum.value);
    }
    if (shipmentSum.present) {
      map['shipment_sum'] = Variable<double>(shipmentSum.value);
    }
    if (buyerId.present) {
      map['buyer_id'] = Variable<int>(buyerId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShipmentsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('ndoc: $ndoc, ')
          ..write('info: $info, ')
          ..write('status: $status, ')
          ..write('debtSum: $debtSum, ')
          ..write('shipmentSum: $shipmentSum, ')
          ..write('buyerId: $buyerId')
          ..write(')'))
        .toString();
  }
}

class $ShipmentLinesTable extends ShipmentLines
    with TableInfo<$ShipmentLinesTable, ShipmentLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShipmentLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _shipmentIdMeta =
      const VerificationMeta('shipmentId');
  @override
  late final GeneratedColumn<int> shipmentId = GeneratedColumn<int>(
      'shipment_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _goodsIdMeta =
      const VerificationMeta('goodsId');
  @override
  late final GeneratedColumn<int> goodsId = GeneratedColumn<int>(
      'goods_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _volMeta = const VerificationMeta('vol');
  @override
  late final GeneratedColumn<double> vol = GeneratedColumn<double>(
      'vol', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, shipmentId, goodsId, vol, price];
  @override
  String get aliasedName => _alias ?? 'shipment_lines';
  @override
  String get actualTableName => 'shipment_lines';
  @override
  VerificationContext validateIntegrity(Insertable<ShipmentLine> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('shipment_id')) {
      context.handle(
          _shipmentIdMeta,
          shipmentId.isAcceptableOrUnknown(
              data['shipment_id']!, _shipmentIdMeta));
    } else if (isInserting) {
      context.missing(_shipmentIdMeta);
    }
    if (data.containsKey('goods_id')) {
      context.handle(_goodsIdMeta,
          goodsId.isAcceptableOrUnknown(data['goods_id']!, _goodsIdMeta));
    } else if (isInserting) {
      context.missing(_goodsIdMeta);
    }
    if (data.containsKey('vol')) {
      context.handle(
          _volMeta, vol.isAcceptableOrUnknown(data['vol']!, _volMeta));
    } else if (isInserting) {
      context.missing(_volMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShipmentLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShipmentLine(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      shipmentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}shipment_id'])!,
      goodsId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}goods_id'])!,
      vol: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}vol'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
    );
  }

  @override
  $ShipmentLinesTable createAlias(String alias) {
    return $ShipmentLinesTable(attachedDatabase, alias);
  }
}

class ShipmentLine extends DataClass implements Insertable<ShipmentLine> {
  final int id;
  final int shipmentId;
  final int goodsId;
  final double vol;
  final double price;
  const ShipmentLine(
      {required this.id,
      required this.shipmentId,
      required this.goodsId,
      required this.vol,
      required this.price});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['shipment_id'] = Variable<int>(shipmentId);
    map['goods_id'] = Variable<int>(goodsId);
    map['vol'] = Variable<double>(vol);
    map['price'] = Variable<double>(price);
    return map;
  }

  ShipmentLinesCompanion toCompanion(bool nullToAbsent) {
    return ShipmentLinesCompanion(
      id: Value(id),
      shipmentId: Value(shipmentId),
      goodsId: Value(goodsId),
      vol: Value(vol),
      price: Value(price),
    );
  }

  factory ShipmentLine.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShipmentLine(
      id: serializer.fromJson<int>(json['id']),
      shipmentId: serializer.fromJson<int>(json['shipmentId']),
      goodsId: serializer.fromJson<int>(json['goodsId']),
      vol: serializer.fromJson<double>(json['vol']),
      price: serializer.fromJson<double>(json['price']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'shipmentId': serializer.toJson<int>(shipmentId),
      'goodsId': serializer.toJson<int>(goodsId),
      'vol': serializer.toJson<double>(vol),
      'price': serializer.toJson<double>(price),
    };
  }

  ShipmentLine copyWith(
          {int? id,
          int? shipmentId,
          int? goodsId,
          double? vol,
          double? price}) =>
      ShipmentLine(
        id: id ?? this.id,
        shipmentId: shipmentId ?? this.shipmentId,
        goodsId: goodsId ?? this.goodsId,
        vol: vol ?? this.vol,
        price: price ?? this.price,
      );
  @override
  String toString() {
    return (StringBuffer('ShipmentLine(')
          ..write('id: $id, ')
          ..write('shipmentId: $shipmentId, ')
          ..write('goodsId: $goodsId, ')
          ..write('vol: $vol, ')
          ..write('price: $price')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, shipmentId, goodsId, vol, price);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShipmentLine &&
          other.id == this.id &&
          other.shipmentId == this.shipmentId &&
          other.goodsId == this.goodsId &&
          other.vol == this.vol &&
          other.price == this.price);
}

class ShipmentLinesCompanion extends UpdateCompanion<ShipmentLine> {
  final Value<int> id;
  final Value<int> shipmentId;
  final Value<int> goodsId;
  final Value<double> vol;
  final Value<double> price;
  const ShipmentLinesCompanion({
    this.id = const Value.absent(),
    this.shipmentId = const Value.absent(),
    this.goodsId = const Value.absent(),
    this.vol = const Value.absent(),
    this.price = const Value.absent(),
  });
  ShipmentLinesCompanion.insert({
    this.id = const Value.absent(),
    required int shipmentId,
    required int goodsId,
    required double vol,
    required double price,
  })  : shipmentId = Value(shipmentId),
        goodsId = Value(goodsId),
        vol = Value(vol),
        price = Value(price);
  static Insertable<ShipmentLine> custom({
    Expression<int>? id,
    Expression<int>? shipmentId,
    Expression<int>? goodsId,
    Expression<double>? vol,
    Expression<double>? price,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shipmentId != null) 'shipment_id': shipmentId,
      if (goodsId != null) 'goods_id': goodsId,
      if (vol != null) 'vol': vol,
      if (price != null) 'price': price,
    });
  }

  ShipmentLinesCompanion copyWith(
      {Value<int>? id,
      Value<int>? shipmentId,
      Value<int>? goodsId,
      Value<double>? vol,
      Value<double>? price}) {
    return ShipmentLinesCompanion(
      id: id ?? this.id,
      shipmentId: shipmentId ?? this.shipmentId,
      goodsId: goodsId ?? this.goodsId,
      vol: vol ?? this.vol,
      price: price ?? this.price,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (shipmentId.present) {
      map['shipment_id'] = Variable<int>(shipmentId.value);
    }
    if (goodsId.present) {
      map['goods_id'] = Variable<int>(goodsId.value);
    }
    if (vol.present) {
      map['vol'] = Variable<double>(vol.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShipmentLinesCompanion(')
          ..write('id: $id, ')
          ..write('shipmentId: $shipmentId, ')
          ..write('goodsId: $goodsId, ')
          ..write('vol: $vol, ')
          ..write('price: $price')
          ..write(')'))
        .toString();
  }
}

class $IncRequestsTable extends IncRequests
    with TableInfo<$IncRequestsTable, IncRequest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IncRequestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _guidMeta = const VerificationMeta('guid');
  @override
  late final GeneratedColumn<String> guid = GeneratedColumn<String>(
      'guid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted =
      GeneratedColumn<bool>('is_deleted', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_deleted" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _currentTimestampMeta =
      const VerificationMeta('currentTimestamp');
  @override
  late final GeneratedColumn<DateTime> currentTimestamp =
      GeneratedColumn<DateTime>('current_timestamp', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  static const VerificationMeta _lastSyncTimeMeta =
      const VerificationMeta('lastSyncTime');
  @override
  late final GeneratedColumn<DateTime> lastSyncTime = GeneratedColumn<DateTime>(
      'last_sync_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _needSyncMeta =
      const VerificationMeta('needSync');
  @override
  late final GeneratedColumn<bool> needSync = GeneratedColumn<bool>(
      'need_sync', aliasedName, false,
      generatedAs: GeneratedAs(
          (isNew & isDeleted.not()) |
              (isNew.not() & lastSyncTime.isSmallerThan(timestamp)),
          true),
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
        SqlDialect.sqlite: 'CHECK ("need_sync" IN (0, 1))',
        SqlDialect.mysql: '',
        SqlDialect.postgres: '',
      }));
  static const VerificationMeta _isNewMeta = const VerificationMeta('isNew');
  @override
  late final GeneratedColumn<bool> isNew =
      GeneratedColumn<bool>('is_new', aliasedName, false,
          generatedAs: GeneratedAs(lastSyncTime.isNull(), false),
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_new" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _buyerIdMeta =
      const VerificationMeta('buyerId');
  @override
  late final GeneratedColumn<int> buyerId = GeneratedColumn<int>(
      'buyer_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _incSumMeta = const VerificationMeta('incSum');
  @override
  late final GeneratedColumn<double> incSum = GeneratedColumn<double>(
      'inc_sum', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _infoMeta = const VerificationMeta('info');
  @override
  late final GeneratedColumn<String> info = GeneratedColumn<String>(
      'info', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        guid,
        isDeleted,
        timestamp,
        currentTimestamp,
        lastSyncTime,
        needSync,
        isNew,
        id,
        date,
        buyerId,
        incSum,
        info,
        status
      ];
  @override
  String get aliasedName => _alias ?? 'inc_requests';
  @override
  String get actualTableName => 'inc_requests';
  @override
  VerificationContext validateIntegrity(Insertable<IncRequest> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('guid')) {
      context.handle(
          _guidMeta, guid.isAcceptableOrUnknown(data['guid']!, _guidMeta));
    } else if (isInserting) {
      context.missing(_guidMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    }
    if (data.containsKey('current_timestamp')) {
      context.handle(
          _currentTimestampMeta,
          currentTimestamp.isAcceptableOrUnknown(
              data['current_timestamp']!, _currentTimestampMeta));
    }
    if (data.containsKey('last_sync_time')) {
      context.handle(
          _lastSyncTimeMeta,
          lastSyncTime.isAcceptableOrUnknown(
              data['last_sync_time']!, _lastSyncTimeMeta));
    }
    if (data.containsKey('need_sync')) {
      context.handle(_needSyncMeta,
          needSync.isAcceptableOrUnknown(data['need_sync']!, _needSyncMeta));
    }
    if (data.containsKey('is_new')) {
      context.handle(
          _isNewMeta, isNew.isAcceptableOrUnknown(data['is_new']!, _isNewMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('buyer_id')) {
      context.handle(_buyerIdMeta,
          buyerId.isAcceptableOrUnknown(data['buyer_id']!, _buyerIdMeta));
    }
    if (data.containsKey('inc_sum')) {
      context.handle(_incSumMeta,
          incSum.isAcceptableOrUnknown(data['inc_sum']!, _incSumMeta));
    }
    if (data.containsKey('info')) {
      context.handle(
          _infoMeta, info.isAcceptableOrUnknown(data['info']!, _infoMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {guid};
  @override
  IncRequest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IncRequest(
      guid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guid'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      currentTimestamp: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}current_timestamp'])!,
      lastSyncTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_sync_time']),
      needSync: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}need_sync'])!,
      isNew: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_new'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date']),
      buyerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}buyer_id']),
      incSum: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}inc_sum']),
      info: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}info']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $IncRequestsTable createAlias(String alias) {
    return $IncRequestsTable(attachedDatabase, alias);
  }
}

class IncRequest extends DataClass implements Insertable<IncRequest> {
  final String guid;
  final bool isDeleted;
  final DateTime timestamp;
  final DateTime currentTimestamp;
  final DateTime? lastSyncTime;
  final bool needSync;
  final bool isNew;
  final int? id;
  final DateTime? date;
  final int? buyerId;
  final double? incSum;
  final String? info;
  final String status;
  const IncRequest(
      {required this.guid,
      required this.isDeleted,
      required this.timestamp,
      required this.currentTimestamp,
      this.lastSyncTime,
      required this.needSync,
      required this.isNew,
      this.id,
      this.date,
      this.buyerId,
      this.incSum,
      this.info,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['guid'] = Variable<String>(guid);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['current_timestamp'] = Variable<DateTime>(currentTimestamp);
    if (!nullToAbsent || lastSyncTime != null) {
      map['last_sync_time'] = Variable<DateTime>(lastSyncTime);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    if (!nullToAbsent || buyerId != null) {
      map['buyer_id'] = Variable<int>(buyerId);
    }
    if (!nullToAbsent || incSum != null) {
      map['inc_sum'] = Variable<double>(incSum);
    }
    if (!nullToAbsent || info != null) {
      map['info'] = Variable<String>(info);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  IncRequestsCompanion toCompanion(bool nullToAbsent) {
    return IncRequestsCompanion(
      guid: Value(guid),
      isDeleted: Value(isDeleted),
      timestamp: Value(timestamp),
      currentTimestamp: Value(currentTimestamp),
      lastSyncTime: lastSyncTime == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncTime),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      buyerId: buyerId == null && nullToAbsent
          ? const Value.absent()
          : Value(buyerId),
      incSum:
          incSum == null && nullToAbsent ? const Value.absent() : Value(incSum),
      info: info == null && nullToAbsent ? const Value.absent() : Value(info),
      status: Value(status),
    );
  }

  factory IncRequest.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IncRequest(
      guid: serializer.fromJson<String>(json['guid']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      currentTimestamp: serializer.fromJson<DateTime>(json['currentTimestamp']),
      lastSyncTime: serializer.fromJson<DateTime?>(json['lastSyncTime']),
      needSync: serializer.fromJson<bool>(json['needSync']),
      isNew: serializer.fromJson<bool>(json['isNew']),
      id: serializer.fromJson<int?>(json['id']),
      date: serializer.fromJson<DateTime?>(json['date']),
      buyerId: serializer.fromJson<int?>(json['buyerId']),
      incSum: serializer.fromJson<double?>(json['incSum']),
      info: serializer.fromJson<String?>(json['info']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'guid': serializer.toJson<String>(guid),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'currentTimestamp': serializer.toJson<DateTime>(currentTimestamp),
      'lastSyncTime': serializer.toJson<DateTime?>(lastSyncTime),
      'needSync': serializer.toJson<bool>(needSync),
      'isNew': serializer.toJson<bool>(isNew),
      'id': serializer.toJson<int?>(id),
      'date': serializer.toJson<DateTime?>(date),
      'buyerId': serializer.toJson<int?>(buyerId),
      'incSum': serializer.toJson<double?>(incSum),
      'info': serializer.toJson<String?>(info),
      'status': serializer.toJson<String>(status),
    };
  }

  IncRequest copyWith(
          {String? guid,
          bool? isDeleted,
          DateTime? timestamp,
          DateTime? currentTimestamp,
          Value<DateTime?> lastSyncTime = const Value.absent(),
          bool? needSync,
          bool? isNew,
          Value<int?> id = const Value.absent(),
          Value<DateTime?> date = const Value.absent(),
          Value<int?> buyerId = const Value.absent(),
          Value<double?> incSum = const Value.absent(),
          Value<String?> info = const Value.absent(),
          String? status}) =>
      IncRequest(
        guid: guid ?? this.guid,
        isDeleted: isDeleted ?? this.isDeleted,
        timestamp: timestamp ?? this.timestamp,
        currentTimestamp: currentTimestamp ?? this.currentTimestamp,
        lastSyncTime:
            lastSyncTime.present ? lastSyncTime.value : this.lastSyncTime,
        needSync: needSync ?? this.needSync,
        isNew: isNew ?? this.isNew,
        id: id.present ? id.value : this.id,
        date: date.present ? date.value : this.date,
        buyerId: buyerId.present ? buyerId.value : this.buyerId,
        incSum: incSum.present ? incSum.value : this.incSum,
        info: info.present ? info.value : this.info,
        status: status ?? this.status,
      );
  @override
  String toString() {
    return (StringBuffer('IncRequest(')
          ..write('guid: $guid, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('timestamp: $timestamp, ')
          ..write('currentTimestamp: $currentTimestamp, ')
          ..write('lastSyncTime: $lastSyncTime, ')
          ..write('needSync: $needSync, ')
          ..write('isNew: $isNew, ')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('buyerId: $buyerId, ')
          ..write('incSum: $incSum, ')
          ..write('info: $info, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(guid, isDeleted, timestamp, currentTimestamp,
      lastSyncTime, needSync, isNew, id, date, buyerId, incSum, info, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IncRequest &&
          other.guid == this.guid &&
          other.isDeleted == this.isDeleted &&
          other.timestamp == this.timestamp &&
          other.currentTimestamp == this.currentTimestamp &&
          other.lastSyncTime == this.lastSyncTime &&
          other.needSync == this.needSync &&
          other.isNew == this.isNew &&
          other.id == this.id &&
          other.date == this.date &&
          other.buyerId == this.buyerId &&
          other.incSum == this.incSum &&
          other.info == this.info &&
          other.status == this.status);
}

class IncRequestsCompanion extends UpdateCompanion<IncRequest> {
  final Value<String> guid;
  final Value<bool> isDeleted;
  final Value<DateTime> timestamp;
  final Value<DateTime> currentTimestamp;
  final Value<DateTime?> lastSyncTime;
  final Value<int?> id;
  final Value<DateTime?> date;
  final Value<int?> buyerId;
  final Value<double?> incSum;
  final Value<String?> info;
  final Value<String> status;
  final Value<int> rowid;
  const IncRequestsCompanion({
    this.guid = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.currentTimestamp = const Value.absent(),
    this.lastSyncTime = const Value.absent(),
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.buyerId = const Value.absent(),
    this.incSum = const Value.absent(),
    this.info = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IncRequestsCompanion.insert({
    required String guid,
    this.isDeleted = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.currentTimestamp = const Value.absent(),
    this.lastSyncTime = const Value.absent(),
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.buyerId = const Value.absent(),
    this.incSum = const Value.absent(),
    this.info = const Value.absent(),
    required String status,
    this.rowid = const Value.absent(),
  })  : guid = Value(guid),
        status = Value(status);
  static Insertable<IncRequest> custom({
    Expression<String>? guid,
    Expression<bool>? isDeleted,
    Expression<DateTime>? timestamp,
    Expression<DateTime>? currentTimestamp,
    Expression<DateTime>? lastSyncTime,
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? buyerId,
    Expression<double>? incSum,
    Expression<String>? info,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (guid != null) 'guid': guid,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (timestamp != null) 'timestamp': timestamp,
      if (currentTimestamp != null) 'current_timestamp': currentTimestamp,
      if (lastSyncTime != null) 'last_sync_time': lastSyncTime,
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (buyerId != null) 'buyer_id': buyerId,
      if (incSum != null) 'inc_sum': incSum,
      if (info != null) 'info': info,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IncRequestsCompanion copyWith(
      {Value<String>? guid,
      Value<bool>? isDeleted,
      Value<DateTime>? timestamp,
      Value<DateTime>? currentTimestamp,
      Value<DateTime?>? lastSyncTime,
      Value<int?>? id,
      Value<DateTime?>? date,
      Value<int?>? buyerId,
      Value<double?>? incSum,
      Value<String?>? info,
      Value<String>? status,
      Value<int>? rowid}) {
    return IncRequestsCompanion(
      guid: guid ?? this.guid,
      isDeleted: isDeleted ?? this.isDeleted,
      timestamp: timestamp ?? this.timestamp,
      currentTimestamp: currentTimestamp ?? this.currentTimestamp,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      id: id ?? this.id,
      date: date ?? this.date,
      buyerId: buyerId ?? this.buyerId,
      incSum: incSum ?? this.incSum,
      info: info ?? this.info,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (guid.present) {
      map['guid'] = Variable<String>(guid.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (currentTimestamp.present) {
      map['current_timestamp'] = Variable<DateTime>(currentTimestamp.value);
    }
    if (lastSyncTime.present) {
      map['last_sync_time'] = Variable<DateTime>(lastSyncTime.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (buyerId.present) {
      map['buyer_id'] = Variable<int>(buyerId.value);
    }
    if (incSum.present) {
      map['inc_sum'] = Variable<double>(incSum.value);
    }
    if (info.present) {
      map['info'] = Variable<String>(info.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IncRequestsCompanion(')
          ..write('guid: $guid, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('timestamp: $timestamp, ')
          ..write('currentTimestamp: $currentTimestamp, ')
          ..write('lastSyncTime: $lastSyncTime, ')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('buyerId: $buyerId, ')
          ..write('incSum: $incSum, ')
          ..write('info: $info, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
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
  static const VerificationMeta _imageUrlMeta =
      const VerificationMeta('imageUrl');
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
      'image_url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imageKeyMeta =
      const VerificationMeta('imageKey');
  @override
  late final GeneratedColumn<String> imageKey = GeneratedColumn<String>(
      'image_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _manufacturerMeta =
      const VerificationMeta('manufacturer');
  @override
  late final GeneratedColumn<String> manufacturer = GeneratedColumn<String>(
      'manufacturer', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isLatestMeta =
      const VerificationMeta('isLatest');
  @override
  late final GeneratedColumn<bool> isLatest =
      GeneratedColumn<bool>('is_latest', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_latest" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  static const VerificationMeta _pricelistSetIdMeta =
      const VerificationMeta('pricelistSetId');
  @override
  late final GeneratedColumn<int> pricelistSetId = GeneratedColumn<int>(
      'pricelist_set_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<double> cost = GeneratedColumn<double>(
      'cost', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _minPriceMeta =
      const VerificationMeta('minPrice');
  @override
  late final GeneratedColumn<double> minPrice = GeneratedColumn<double>(
      'min_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _handPriceMeta =
      const VerificationMeta('handPrice');
  @override
  late final GeneratedColumn<double> handPrice = GeneratedColumn<double>(
      'hand_price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _extraLabelMeta =
      const VerificationMeta('extraLabel');
  @override
  late final GeneratedColumn<String> extraLabel = GeneratedColumn<String>(
      'extra_label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _packageMeta =
      const VerificationMeta('package');
  @override
  late final GeneratedColumn<int> package = GeneratedColumn<int>(
      'package', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _relMeta = const VerificationMeta('rel');
  @override
  late final GeneratedColumn<int> rel = GeneratedColumn<int>(
      'rel', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _categoryUserPackageRelMeta =
      const VerificationMeta('categoryUserPackageRel');
  @override
  late final GeneratedColumn<int> categoryUserPackageRel = GeneratedColumn<int>(
      'category_user_package_rel', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _categoryPackageRelMeta =
      const VerificationMeta('categoryPackageRel');
  @override
  late final GeneratedColumn<int> categoryPackageRel = GeneratedColumn<int>(
      'category_package_rel', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _categoryBlockRelMeta =
      const VerificationMeta('categoryBlockRel');
  @override
  late final GeneratedColumn<int> categoryBlockRel = GeneratedColumn<int>(
      'category_block_rel', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
      'weight', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _mcVolMeta = const VerificationMeta('mcVol');
  @override
  late final GeneratedColumn<double> mcVol = GeneratedColumn<double>(
      'mc_vol', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _isFridgeMeta =
      const VerificationMeta('isFridge');
  @override
  late final GeneratedColumn<bool> isFridge =
      GeneratedColumn<bool>('is_fridge', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_fridge" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  static const VerificationMeta _shelfLifeMeta =
      const VerificationMeta('shelfLife');
  @override
  late final GeneratedColumn<int> shelfLife = GeneratedColumn<int>(
      'shelf_life', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _shelfLifeTypeNameMeta =
      const VerificationMeta('shelfLifeTypeName');
  @override
  late final GeneratedColumn<String> shelfLifeTypeName =
      GeneratedColumn<String>('shelf_life_type_name', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _barcodesMeta =
      const VerificationMeta('barcodes');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> barcodes =
      GeneratedColumn<String>('barcodes', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>($AllGoodsTable.$converterbarcodes);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        imageUrl,
        imageKey,
        categoryId,
        manufacturer,
        isLatest,
        pricelistSetId,
        cost,
        minPrice,
        handPrice,
        extraLabel,
        package,
        rel,
        categoryUserPackageRel,
        categoryPackageRel,
        categoryBlockRel,
        weight,
        mcVol,
        isFridge,
        shelfLife,
        shelfLifeTypeName,
        barcodes
      ];
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
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    } else if (isInserting) {
      context.missing(_imageUrlMeta);
    }
    if (data.containsKey('image_key')) {
      context.handle(_imageKeyMeta,
          imageKey.isAcceptableOrUnknown(data['image_key']!, _imageKeyMeta));
    } else if (isInserting) {
      context.missing(_imageKeyMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('manufacturer')) {
      context.handle(
          _manufacturerMeta,
          manufacturer.isAcceptableOrUnknown(
              data['manufacturer']!, _manufacturerMeta));
    }
    if (data.containsKey('is_latest')) {
      context.handle(_isLatestMeta,
          isLatest.isAcceptableOrUnknown(data['is_latest']!, _isLatestMeta));
    } else if (isInserting) {
      context.missing(_isLatestMeta);
    }
    if (data.containsKey('pricelist_set_id')) {
      context.handle(
          _pricelistSetIdMeta,
          pricelistSetId.isAcceptableOrUnknown(
              data['pricelist_set_id']!, _pricelistSetIdMeta));
    } else if (isInserting) {
      context.missing(_pricelistSetIdMeta);
    }
    if (data.containsKey('cost')) {
      context.handle(
          _costMeta, cost.isAcceptableOrUnknown(data['cost']!, _costMeta));
    } else if (isInserting) {
      context.missing(_costMeta);
    }
    if (data.containsKey('min_price')) {
      context.handle(_minPriceMeta,
          minPrice.isAcceptableOrUnknown(data['min_price']!, _minPriceMeta));
    } else if (isInserting) {
      context.missing(_minPriceMeta);
    }
    if (data.containsKey('hand_price')) {
      context.handle(_handPriceMeta,
          handPrice.isAcceptableOrUnknown(data['hand_price']!, _handPriceMeta));
    }
    if (data.containsKey('extra_label')) {
      context.handle(
          _extraLabelMeta,
          extraLabel.isAcceptableOrUnknown(
              data['extra_label']!, _extraLabelMeta));
    } else if (isInserting) {
      context.missing(_extraLabelMeta);
    }
    if (data.containsKey('package')) {
      context.handle(_packageMeta,
          package.isAcceptableOrUnknown(data['package']!, _packageMeta));
    } else if (isInserting) {
      context.missing(_packageMeta);
    }
    if (data.containsKey('rel')) {
      context.handle(
          _relMeta, rel.isAcceptableOrUnknown(data['rel']!, _relMeta));
    } else if (isInserting) {
      context.missing(_relMeta);
    }
    if (data.containsKey('category_user_package_rel')) {
      context.handle(
          _categoryUserPackageRelMeta,
          categoryUserPackageRel.isAcceptableOrUnknown(
              data['category_user_package_rel']!, _categoryUserPackageRelMeta));
    } else if (isInserting) {
      context.missing(_categoryUserPackageRelMeta);
    }
    if (data.containsKey('category_package_rel')) {
      context.handle(
          _categoryPackageRelMeta,
          categoryPackageRel.isAcceptableOrUnknown(
              data['category_package_rel']!, _categoryPackageRelMeta));
    } else if (isInserting) {
      context.missing(_categoryPackageRelMeta);
    }
    if (data.containsKey('category_block_rel')) {
      context.handle(
          _categoryBlockRelMeta,
          categoryBlockRel.isAcceptableOrUnknown(
              data['category_block_rel']!, _categoryBlockRelMeta));
    } else if (isInserting) {
      context.missing(_categoryBlockRelMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(_weightMeta,
          weight.isAcceptableOrUnknown(data['weight']!, _weightMeta));
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (data.containsKey('mc_vol')) {
      context.handle(
          _mcVolMeta, mcVol.isAcceptableOrUnknown(data['mc_vol']!, _mcVolMeta));
    } else if (isInserting) {
      context.missing(_mcVolMeta);
    }
    if (data.containsKey('is_fridge')) {
      context.handle(_isFridgeMeta,
          isFridge.isAcceptableOrUnknown(data['is_fridge']!, _isFridgeMeta));
    } else if (isInserting) {
      context.missing(_isFridgeMeta);
    }
    if (data.containsKey('shelf_life')) {
      context.handle(_shelfLifeMeta,
          shelfLife.isAcceptableOrUnknown(data['shelf_life']!, _shelfLifeMeta));
    } else if (isInserting) {
      context.missing(_shelfLifeMeta);
    }
    if (data.containsKey('shelf_life_type_name')) {
      context.handle(
          _shelfLifeTypeNameMeta,
          shelfLifeTypeName.isAcceptableOrUnknown(
              data['shelf_life_type_name']!, _shelfLifeTypeNameMeta));
    } else if (isInserting) {
      context.missing(_shelfLifeTypeNameMeta);
    }
    context.handle(_barcodesMeta, const VerificationResult.success());
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
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url'])!,
      imageKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_key'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      manufacturer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}manufacturer']),
      isLatest: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_latest'])!,
      pricelistSetId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pricelist_set_id'])!,
      cost: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cost'])!,
      minPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}min_price'])!,
      handPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}hand_price']),
      extraLabel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}extra_label'])!,
      package: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}package'])!,
      rel: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rel'])!,
      categoryUserPackageRel: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}category_user_package_rel'])!,
      categoryPackageRel: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}category_package_rel'])!,
      categoryBlockRel: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}category_block_rel'])!,
      weight: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight'])!,
      mcVol: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}mc_vol'])!,
      isFridge: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_fridge'])!,
      shelfLife: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}shelf_life'])!,
      shelfLifeTypeName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}shelf_life_type_name'])!,
      barcodes: $AllGoodsTable.$converterbarcodes.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcodes'])!),
    );
  }

  @override
  $AllGoodsTable createAlias(String alias) {
    return $AllGoodsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterbarcodes =
      const JsonListConverter();
}

class Goods extends DataClass implements Insertable<Goods> {
  final int id;
  final String name;
  final String imageUrl;
  final String imageKey;
  final int categoryId;
  final String? manufacturer;
  final bool isLatest;
  final int pricelistSetId;
  final double cost;
  final double minPrice;
  final double? handPrice;
  final String extraLabel;
  final int package;
  final int rel;
  final int categoryUserPackageRel;
  final int categoryPackageRel;
  final int categoryBlockRel;
  final double weight;
  final double mcVol;
  final bool isFridge;
  final int shelfLife;
  final String shelfLifeTypeName;
  final List<String> barcodes;
  const Goods(
      {required this.id,
      required this.name,
      required this.imageUrl,
      required this.imageKey,
      required this.categoryId,
      this.manufacturer,
      required this.isLatest,
      required this.pricelistSetId,
      required this.cost,
      required this.minPrice,
      this.handPrice,
      required this.extraLabel,
      required this.package,
      required this.rel,
      required this.categoryUserPackageRel,
      required this.categoryPackageRel,
      required this.categoryBlockRel,
      required this.weight,
      required this.mcVol,
      required this.isFridge,
      required this.shelfLife,
      required this.shelfLifeTypeName,
      required this.barcodes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['image_url'] = Variable<String>(imageUrl);
    map['image_key'] = Variable<String>(imageKey);
    map['category_id'] = Variable<int>(categoryId);
    if (!nullToAbsent || manufacturer != null) {
      map['manufacturer'] = Variable<String>(manufacturer);
    }
    map['is_latest'] = Variable<bool>(isLatest);
    map['pricelist_set_id'] = Variable<int>(pricelistSetId);
    map['cost'] = Variable<double>(cost);
    map['min_price'] = Variable<double>(minPrice);
    if (!nullToAbsent || handPrice != null) {
      map['hand_price'] = Variable<double>(handPrice);
    }
    map['extra_label'] = Variable<String>(extraLabel);
    map['package'] = Variable<int>(package);
    map['rel'] = Variable<int>(rel);
    map['category_user_package_rel'] = Variable<int>(categoryUserPackageRel);
    map['category_package_rel'] = Variable<int>(categoryPackageRel);
    map['category_block_rel'] = Variable<int>(categoryBlockRel);
    map['weight'] = Variable<double>(weight);
    map['mc_vol'] = Variable<double>(mcVol);
    map['is_fridge'] = Variable<bool>(isFridge);
    map['shelf_life'] = Variable<int>(shelfLife);
    map['shelf_life_type_name'] = Variable<String>(shelfLifeTypeName);
    {
      final converter = $AllGoodsTable.$converterbarcodes;
      map['barcodes'] = Variable<String>(converter.toSql(barcodes));
    }
    return map;
  }

  AllGoodsCompanion toCompanion(bool nullToAbsent) {
    return AllGoodsCompanion(
      id: Value(id),
      name: Value(name),
      imageUrl: Value(imageUrl),
      imageKey: Value(imageKey),
      categoryId: Value(categoryId),
      manufacturer: manufacturer == null && nullToAbsent
          ? const Value.absent()
          : Value(manufacturer),
      isLatest: Value(isLatest),
      pricelistSetId: Value(pricelistSetId),
      cost: Value(cost),
      minPrice: Value(minPrice),
      handPrice: handPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(handPrice),
      extraLabel: Value(extraLabel),
      package: Value(package),
      rel: Value(rel),
      categoryUserPackageRel: Value(categoryUserPackageRel),
      categoryPackageRel: Value(categoryPackageRel),
      categoryBlockRel: Value(categoryBlockRel),
      weight: Value(weight),
      mcVol: Value(mcVol),
      isFridge: Value(isFridge),
      shelfLife: Value(shelfLife),
      shelfLifeTypeName: Value(shelfLifeTypeName),
      barcodes: Value(barcodes),
    );
  }

  factory Goods.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Goods(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      imageUrl: serializer.fromJson<String>(json['imageUrl']),
      imageKey: serializer.fromJson<String>(json['imageKey']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      manufacturer: serializer.fromJson<String?>(json['manufacturer']),
      isLatest: serializer.fromJson<bool>(json['isLatest']),
      pricelistSetId: serializer.fromJson<int>(json['pricelistSetId']),
      cost: serializer.fromJson<double>(json['cost']),
      minPrice: serializer.fromJson<double>(json['minPrice']),
      handPrice: serializer.fromJson<double?>(json['handPrice']),
      extraLabel: serializer.fromJson<String>(json['extraLabel']),
      package: serializer.fromJson<int>(json['package']),
      rel: serializer.fromJson<int>(json['rel']),
      categoryUserPackageRel:
          serializer.fromJson<int>(json['categoryUserPackageRel']),
      categoryPackageRel: serializer.fromJson<int>(json['categoryPackageRel']),
      categoryBlockRel: serializer.fromJson<int>(json['categoryBlockRel']),
      weight: serializer.fromJson<double>(json['weight']),
      mcVol: serializer.fromJson<double>(json['mcVol']),
      isFridge: serializer.fromJson<bool>(json['isFridge']),
      shelfLife: serializer.fromJson<int>(json['shelfLife']),
      shelfLifeTypeName: serializer.fromJson<String>(json['shelfLifeTypeName']),
      barcodes: serializer.fromJson<List<String>>(json['barcodes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'imageUrl': serializer.toJson<String>(imageUrl),
      'imageKey': serializer.toJson<String>(imageKey),
      'categoryId': serializer.toJson<int>(categoryId),
      'manufacturer': serializer.toJson<String?>(manufacturer),
      'isLatest': serializer.toJson<bool>(isLatest),
      'pricelistSetId': serializer.toJson<int>(pricelistSetId),
      'cost': serializer.toJson<double>(cost),
      'minPrice': serializer.toJson<double>(minPrice),
      'handPrice': serializer.toJson<double?>(handPrice),
      'extraLabel': serializer.toJson<String>(extraLabel),
      'package': serializer.toJson<int>(package),
      'rel': serializer.toJson<int>(rel),
      'categoryUserPackageRel': serializer.toJson<int>(categoryUserPackageRel),
      'categoryPackageRel': serializer.toJson<int>(categoryPackageRel),
      'categoryBlockRel': serializer.toJson<int>(categoryBlockRel),
      'weight': serializer.toJson<double>(weight),
      'mcVol': serializer.toJson<double>(mcVol),
      'isFridge': serializer.toJson<bool>(isFridge),
      'shelfLife': serializer.toJson<int>(shelfLife),
      'shelfLifeTypeName': serializer.toJson<String>(shelfLifeTypeName),
      'barcodes': serializer.toJson<List<String>>(barcodes),
    };
  }

  Goods copyWith(
          {int? id,
          String? name,
          String? imageUrl,
          String? imageKey,
          int? categoryId,
          Value<String?> manufacturer = const Value.absent(),
          bool? isLatest,
          int? pricelistSetId,
          double? cost,
          double? minPrice,
          Value<double?> handPrice = const Value.absent(),
          String? extraLabel,
          int? package,
          int? rel,
          int? categoryUserPackageRel,
          int? categoryPackageRel,
          int? categoryBlockRel,
          double? weight,
          double? mcVol,
          bool? isFridge,
          int? shelfLife,
          String? shelfLifeTypeName,
          List<String>? barcodes}) =>
      Goods(
        id: id ?? this.id,
        name: name ?? this.name,
        imageUrl: imageUrl ?? this.imageUrl,
        imageKey: imageKey ?? this.imageKey,
        categoryId: categoryId ?? this.categoryId,
        manufacturer:
            manufacturer.present ? manufacturer.value : this.manufacturer,
        isLatest: isLatest ?? this.isLatest,
        pricelistSetId: pricelistSetId ?? this.pricelistSetId,
        cost: cost ?? this.cost,
        minPrice: minPrice ?? this.minPrice,
        handPrice: handPrice.present ? handPrice.value : this.handPrice,
        extraLabel: extraLabel ?? this.extraLabel,
        package: package ?? this.package,
        rel: rel ?? this.rel,
        categoryUserPackageRel:
            categoryUserPackageRel ?? this.categoryUserPackageRel,
        categoryPackageRel: categoryPackageRel ?? this.categoryPackageRel,
        categoryBlockRel: categoryBlockRel ?? this.categoryBlockRel,
        weight: weight ?? this.weight,
        mcVol: mcVol ?? this.mcVol,
        isFridge: isFridge ?? this.isFridge,
        shelfLife: shelfLife ?? this.shelfLife,
        shelfLifeTypeName: shelfLifeTypeName ?? this.shelfLifeTypeName,
        barcodes: barcodes ?? this.barcodes,
      );
  @override
  String toString() {
    return (StringBuffer('Goods(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('imageKey: $imageKey, ')
          ..write('categoryId: $categoryId, ')
          ..write('manufacturer: $manufacturer, ')
          ..write('isLatest: $isLatest, ')
          ..write('pricelistSetId: $pricelistSetId, ')
          ..write('cost: $cost, ')
          ..write('minPrice: $minPrice, ')
          ..write('handPrice: $handPrice, ')
          ..write('extraLabel: $extraLabel, ')
          ..write('package: $package, ')
          ..write('rel: $rel, ')
          ..write('categoryUserPackageRel: $categoryUserPackageRel, ')
          ..write('categoryPackageRel: $categoryPackageRel, ')
          ..write('categoryBlockRel: $categoryBlockRel, ')
          ..write('weight: $weight, ')
          ..write('mcVol: $mcVol, ')
          ..write('isFridge: $isFridge, ')
          ..write('shelfLife: $shelfLife, ')
          ..write('shelfLifeTypeName: $shelfLifeTypeName, ')
          ..write('barcodes: $barcodes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        name,
        imageUrl,
        imageKey,
        categoryId,
        manufacturer,
        isLatest,
        pricelistSetId,
        cost,
        minPrice,
        handPrice,
        extraLabel,
        package,
        rel,
        categoryUserPackageRel,
        categoryPackageRel,
        categoryBlockRel,
        weight,
        mcVol,
        isFridge,
        shelfLife,
        shelfLifeTypeName,
        barcodes
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Goods &&
          other.id == this.id &&
          other.name == this.name &&
          other.imageUrl == this.imageUrl &&
          other.imageKey == this.imageKey &&
          other.categoryId == this.categoryId &&
          other.manufacturer == this.manufacturer &&
          other.isLatest == this.isLatest &&
          other.pricelistSetId == this.pricelistSetId &&
          other.cost == this.cost &&
          other.minPrice == this.minPrice &&
          other.handPrice == this.handPrice &&
          other.extraLabel == this.extraLabel &&
          other.package == this.package &&
          other.rel == this.rel &&
          other.categoryUserPackageRel == this.categoryUserPackageRel &&
          other.categoryPackageRel == this.categoryPackageRel &&
          other.categoryBlockRel == this.categoryBlockRel &&
          other.weight == this.weight &&
          other.mcVol == this.mcVol &&
          other.isFridge == this.isFridge &&
          other.shelfLife == this.shelfLife &&
          other.shelfLifeTypeName == this.shelfLifeTypeName &&
          other.barcodes == this.barcodes);
}

class AllGoodsCompanion extends UpdateCompanion<Goods> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> imageUrl;
  final Value<String> imageKey;
  final Value<int> categoryId;
  final Value<String?> manufacturer;
  final Value<bool> isLatest;
  final Value<int> pricelistSetId;
  final Value<double> cost;
  final Value<double> minPrice;
  final Value<double?> handPrice;
  final Value<String> extraLabel;
  final Value<int> package;
  final Value<int> rel;
  final Value<int> categoryUserPackageRel;
  final Value<int> categoryPackageRel;
  final Value<int> categoryBlockRel;
  final Value<double> weight;
  final Value<double> mcVol;
  final Value<bool> isFridge;
  final Value<int> shelfLife;
  final Value<String> shelfLifeTypeName;
  final Value<List<String>> barcodes;
  const AllGoodsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.imageKey = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.manufacturer = const Value.absent(),
    this.isLatest = const Value.absent(),
    this.pricelistSetId = const Value.absent(),
    this.cost = const Value.absent(),
    this.minPrice = const Value.absent(),
    this.handPrice = const Value.absent(),
    this.extraLabel = const Value.absent(),
    this.package = const Value.absent(),
    this.rel = const Value.absent(),
    this.categoryUserPackageRel = const Value.absent(),
    this.categoryPackageRel = const Value.absent(),
    this.categoryBlockRel = const Value.absent(),
    this.weight = const Value.absent(),
    this.mcVol = const Value.absent(),
    this.isFridge = const Value.absent(),
    this.shelfLife = const Value.absent(),
    this.shelfLifeTypeName = const Value.absent(),
    this.barcodes = const Value.absent(),
  });
  AllGoodsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String imageUrl,
    required String imageKey,
    required int categoryId,
    this.manufacturer = const Value.absent(),
    required bool isLatest,
    required int pricelistSetId,
    required double cost,
    required double minPrice,
    this.handPrice = const Value.absent(),
    required String extraLabel,
    required int package,
    required int rel,
    required int categoryUserPackageRel,
    required int categoryPackageRel,
    required int categoryBlockRel,
    required double weight,
    required double mcVol,
    required bool isFridge,
    required int shelfLife,
    required String shelfLifeTypeName,
    required List<String> barcodes,
  })  : name = Value(name),
        imageUrl = Value(imageUrl),
        imageKey = Value(imageKey),
        categoryId = Value(categoryId),
        isLatest = Value(isLatest),
        pricelistSetId = Value(pricelistSetId),
        cost = Value(cost),
        minPrice = Value(minPrice),
        extraLabel = Value(extraLabel),
        package = Value(package),
        rel = Value(rel),
        categoryUserPackageRel = Value(categoryUserPackageRel),
        categoryPackageRel = Value(categoryPackageRel),
        categoryBlockRel = Value(categoryBlockRel),
        weight = Value(weight),
        mcVol = Value(mcVol),
        isFridge = Value(isFridge),
        shelfLife = Value(shelfLife),
        shelfLifeTypeName = Value(shelfLifeTypeName),
        barcodes = Value(barcodes);
  static Insertable<Goods> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? imageUrl,
    Expression<String>? imageKey,
    Expression<int>? categoryId,
    Expression<String>? manufacturer,
    Expression<bool>? isLatest,
    Expression<int>? pricelistSetId,
    Expression<double>? cost,
    Expression<double>? minPrice,
    Expression<double>? handPrice,
    Expression<String>? extraLabel,
    Expression<int>? package,
    Expression<int>? rel,
    Expression<int>? categoryUserPackageRel,
    Expression<int>? categoryPackageRel,
    Expression<int>? categoryBlockRel,
    Expression<double>? weight,
    Expression<double>? mcVol,
    Expression<bool>? isFridge,
    Expression<int>? shelfLife,
    Expression<String>? shelfLifeTypeName,
    Expression<String>? barcodes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (imageUrl != null) 'image_url': imageUrl,
      if (imageKey != null) 'image_key': imageKey,
      if (categoryId != null) 'category_id': categoryId,
      if (manufacturer != null) 'manufacturer': manufacturer,
      if (isLatest != null) 'is_latest': isLatest,
      if (pricelistSetId != null) 'pricelist_set_id': pricelistSetId,
      if (cost != null) 'cost': cost,
      if (minPrice != null) 'min_price': minPrice,
      if (handPrice != null) 'hand_price': handPrice,
      if (extraLabel != null) 'extra_label': extraLabel,
      if (package != null) 'package': package,
      if (rel != null) 'rel': rel,
      if (categoryUserPackageRel != null)
        'category_user_package_rel': categoryUserPackageRel,
      if (categoryPackageRel != null)
        'category_package_rel': categoryPackageRel,
      if (categoryBlockRel != null) 'category_block_rel': categoryBlockRel,
      if (weight != null) 'weight': weight,
      if (mcVol != null) 'mc_vol': mcVol,
      if (isFridge != null) 'is_fridge': isFridge,
      if (shelfLife != null) 'shelf_life': shelfLife,
      if (shelfLifeTypeName != null) 'shelf_life_type_name': shelfLifeTypeName,
      if (barcodes != null) 'barcodes': barcodes,
    });
  }

  AllGoodsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? imageUrl,
      Value<String>? imageKey,
      Value<int>? categoryId,
      Value<String?>? manufacturer,
      Value<bool>? isLatest,
      Value<int>? pricelistSetId,
      Value<double>? cost,
      Value<double>? minPrice,
      Value<double?>? handPrice,
      Value<String>? extraLabel,
      Value<int>? package,
      Value<int>? rel,
      Value<int>? categoryUserPackageRel,
      Value<int>? categoryPackageRel,
      Value<int>? categoryBlockRel,
      Value<double>? weight,
      Value<double>? mcVol,
      Value<bool>? isFridge,
      Value<int>? shelfLife,
      Value<String>? shelfLifeTypeName,
      Value<List<String>>? barcodes}) {
    return AllGoodsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      imageKey: imageKey ?? this.imageKey,
      categoryId: categoryId ?? this.categoryId,
      manufacturer: manufacturer ?? this.manufacturer,
      isLatest: isLatest ?? this.isLatest,
      pricelistSetId: pricelistSetId ?? this.pricelistSetId,
      cost: cost ?? this.cost,
      minPrice: minPrice ?? this.minPrice,
      handPrice: handPrice ?? this.handPrice,
      extraLabel: extraLabel ?? this.extraLabel,
      package: package ?? this.package,
      rel: rel ?? this.rel,
      categoryUserPackageRel:
          categoryUserPackageRel ?? this.categoryUserPackageRel,
      categoryPackageRel: categoryPackageRel ?? this.categoryPackageRel,
      categoryBlockRel: categoryBlockRel ?? this.categoryBlockRel,
      weight: weight ?? this.weight,
      mcVol: mcVol ?? this.mcVol,
      isFridge: isFridge ?? this.isFridge,
      shelfLife: shelfLife ?? this.shelfLife,
      shelfLifeTypeName: shelfLifeTypeName ?? this.shelfLifeTypeName,
      barcodes: barcodes ?? this.barcodes,
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
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (imageKey.present) {
      map['image_key'] = Variable<String>(imageKey.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (manufacturer.present) {
      map['manufacturer'] = Variable<String>(manufacturer.value);
    }
    if (isLatest.present) {
      map['is_latest'] = Variable<bool>(isLatest.value);
    }
    if (pricelistSetId.present) {
      map['pricelist_set_id'] = Variable<int>(pricelistSetId.value);
    }
    if (cost.present) {
      map['cost'] = Variable<double>(cost.value);
    }
    if (minPrice.present) {
      map['min_price'] = Variable<double>(minPrice.value);
    }
    if (handPrice.present) {
      map['hand_price'] = Variable<double>(handPrice.value);
    }
    if (extraLabel.present) {
      map['extra_label'] = Variable<String>(extraLabel.value);
    }
    if (package.present) {
      map['package'] = Variable<int>(package.value);
    }
    if (rel.present) {
      map['rel'] = Variable<int>(rel.value);
    }
    if (categoryUserPackageRel.present) {
      map['category_user_package_rel'] =
          Variable<int>(categoryUserPackageRel.value);
    }
    if (categoryPackageRel.present) {
      map['category_package_rel'] = Variable<int>(categoryPackageRel.value);
    }
    if (categoryBlockRel.present) {
      map['category_block_rel'] = Variable<int>(categoryBlockRel.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (mcVol.present) {
      map['mc_vol'] = Variable<double>(mcVol.value);
    }
    if (isFridge.present) {
      map['is_fridge'] = Variable<bool>(isFridge.value);
    }
    if (shelfLife.present) {
      map['shelf_life'] = Variable<int>(shelfLife.value);
    }
    if (shelfLifeTypeName.present) {
      map['shelf_life_type_name'] = Variable<String>(shelfLifeTypeName.value);
    }
    if (barcodes.present) {
      final converter = $AllGoodsTable.$converterbarcodes;
      map['barcodes'] = Variable<String>(converter.toSql(barcodes.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AllGoodsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('imageKey: $imageKey, ')
          ..write('categoryId: $categoryId, ')
          ..write('manufacturer: $manufacturer, ')
          ..write('isLatest: $isLatest, ')
          ..write('pricelistSetId: $pricelistSetId, ')
          ..write('cost: $cost, ')
          ..write('minPrice: $minPrice, ')
          ..write('handPrice: $handPrice, ')
          ..write('extraLabel: $extraLabel, ')
          ..write('package: $package, ')
          ..write('rel: $rel, ')
          ..write('categoryUserPackageRel: $categoryUserPackageRel, ')
          ..write('categoryPackageRel: $categoryPackageRel, ')
          ..write('categoryBlockRel: $categoryBlockRel, ')
          ..write('weight: $weight, ')
          ..write('mcVol: $mcVol, ')
          ..write('isFridge: $isFridge, ')
          ..write('shelfLife: $shelfLife, ')
          ..write('shelfLifeTypeName: $shelfLifeTypeName, ')
          ..write('barcodes: $barcodes')
          ..write(')'))
        .toString();
  }
}

class $WorkdatesTable extends Workdates
    with TableInfo<$WorkdatesTable, Workdate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkdatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [date];
  @override
  String get aliasedName => _alias ?? 'workdates';
  @override
  String get actualTableName => 'workdates';
  @override
  VerificationContext validateIntegrity(Insertable<Workdate> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  Workdate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Workdate(
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
    );
  }

  @override
  $WorkdatesTable createAlias(String alias) {
    return $WorkdatesTable(attachedDatabase, alias);
  }
}

class Workdate extends DataClass implements Insertable<Workdate> {
  final DateTime date;
  const Workdate({required this.date});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<DateTime>(date);
    return map;
  }

  WorkdatesCompanion toCompanion(bool nullToAbsent) {
    return WorkdatesCompanion(
      date: Value(date),
    );
  }

  factory Workdate.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Workdate(
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<DateTime>(date),
    };
  }

  Workdate copyWith({DateTime? date}) => Workdate(
        date: date ?? this.date,
      );
  @override
  String toString() {
    return (StringBuffer('Workdate(')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => date.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Workdate && other.date == this.date);
}

class WorkdatesCompanion extends UpdateCompanion<Workdate> {
  final Value<DateTime> date;
  final Value<int> rowid;
  const WorkdatesCompanion({
    this.date = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkdatesCompanion.insert({
    required DateTime date,
    this.rowid = const Value.absent(),
  }) : date = Value(date);
  static Insertable<Workdate> custom({
    Expression<DateTime>? date,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkdatesCompanion copyWith({Value<DateTime>? date, Value<int>? rowid}) {
    return WorkdatesCompanion(
      date: date ?? this.date,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkdatesCompanion(')
          ..write('date: $date, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShopDepartmentsTable extends ShopDepartments
    with TableInfo<$ShopDepartmentsTable, ShopDepartment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShopDepartmentsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _ordMeta = const VerificationMeta('ord');
  @override
  late final GeneratedColumn<int> ord = GeneratedColumn<int>(
      'ord', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, ord];
  @override
  String get aliasedName => _alias ?? 'shop_departments';
  @override
  String get actualTableName => 'shop_departments';
  @override
  VerificationContext validateIntegrity(Insertable<ShopDepartment> instance,
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
    if (data.containsKey('ord')) {
      context.handle(
          _ordMeta, ord.isAcceptableOrUnknown(data['ord']!, _ordMeta));
    } else if (isInserting) {
      context.missing(_ordMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShopDepartment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShopDepartment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      ord: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ord'])!,
    );
  }

  @override
  $ShopDepartmentsTable createAlias(String alias) {
    return $ShopDepartmentsTable(attachedDatabase, alias);
  }
}

class ShopDepartment extends DataClass implements Insertable<ShopDepartment> {
  final int id;
  final String name;
  final int ord;
  const ShopDepartment(
      {required this.id, required this.name, required this.ord});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['ord'] = Variable<int>(ord);
    return map;
  }

  ShopDepartmentsCompanion toCompanion(bool nullToAbsent) {
    return ShopDepartmentsCompanion(
      id: Value(id),
      name: Value(name),
      ord: Value(ord),
    );
  }

  factory ShopDepartment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShopDepartment(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      ord: serializer.fromJson<int>(json['ord']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'ord': serializer.toJson<int>(ord),
    };
  }

  ShopDepartment copyWith({int? id, String? name, int? ord}) => ShopDepartment(
        id: id ?? this.id,
        name: name ?? this.name,
        ord: ord ?? this.ord,
      );
  @override
  String toString() {
    return (StringBuffer('ShopDepartment(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('ord: $ord')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, ord);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShopDepartment &&
          other.id == this.id &&
          other.name == this.name &&
          other.ord == this.ord);
}

class ShopDepartmentsCompanion extends UpdateCompanion<ShopDepartment> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> ord;
  const ShopDepartmentsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.ord = const Value.absent(),
  });
  ShopDepartmentsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int ord,
  })  : name = Value(name),
        ord = Value(ord);
  static Insertable<ShopDepartment> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? ord,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (ord != null) 'ord': ord,
    });
  }

  ShopDepartmentsCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<int>? ord}) {
    return ShopDepartmentsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      ord: ord ?? this.ord,
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
    if (ord.present) {
      map['ord'] = Variable<int>(ord.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShopDepartmentsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('ord: $ord')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _ordMeta = const VerificationMeta('ord');
  @override
  late final GeneratedColumn<int> ord = GeneratedColumn<int>(
      'ord', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _shopDepartmentIdMeta =
      const VerificationMeta('shopDepartmentId');
  @override
  late final GeneratedColumn<int> shopDepartmentId = GeneratedColumn<int>(
      'shop_department_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _packageMeta =
      const VerificationMeta('package');
  @override
  late final GeneratedColumn<int> package = GeneratedColumn<int>(
      'package', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _userPackageMeta =
      const VerificationMeta('userPackage');
  @override
  late final GeneratedColumn<int> userPackage = GeneratedColumn<int>(
      'user_package', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, ord, shopDepartmentId, package, userPackage];
  @override
  String get aliasedName => _alias ?? 'categories';
  @override
  String get actualTableName => 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
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
    if (data.containsKey('ord')) {
      context.handle(
          _ordMeta, ord.isAcceptableOrUnknown(data['ord']!, _ordMeta));
    } else if (isInserting) {
      context.missing(_ordMeta);
    }
    if (data.containsKey('shop_department_id')) {
      context.handle(
          _shopDepartmentIdMeta,
          shopDepartmentId.isAcceptableOrUnknown(
              data['shop_department_id']!, _shopDepartmentIdMeta));
    } else if (isInserting) {
      context.missing(_shopDepartmentIdMeta);
    }
    if (data.containsKey('package')) {
      context.handle(_packageMeta,
          package.isAcceptableOrUnknown(data['package']!, _packageMeta));
    } else if (isInserting) {
      context.missing(_packageMeta);
    }
    if (data.containsKey('user_package')) {
      context.handle(
          _userPackageMeta,
          userPackage.isAcceptableOrUnknown(
              data['user_package']!, _userPackageMeta));
    } else if (isInserting) {
      context.missing(_userPackageMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      ord: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ord'])!,
      shopDepartmentId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}shop_department_id'])!,
      package: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}package'])!,
      userPackage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_package'])!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  final int ord;
  final int shopDepartmentId;
  final int package;
  final int userPackage;
  const Category(
      {required this.id,
      required this.name,
      required this.ord,
      required this.shopDepartmentId,
      required this.package,
      required this.userPackage});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['ord'] = Variable<int>(ord);
    map['shop_department_id'] = Variable<int>(shopDepartmentId);
    map['package'] = Variable<int>(package);
    map['user_package'] = Variable<int>(userPackage);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      ord: Value(ord),
      shopDepartmentId: Value(shopDepartmentId),
      package: Value(package),
      userPackage: Value(userPackage),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      ord: serializer.fromJson<int>(json['ord']),
      shopDepartmentId: serializer.fromJson<int>(json['shopDepartmentId']),
      package: serializer.fromJson<int>(json['package']),
      userPackage: serializer.fromJson<int>(json['userPackage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'ord': serializer.toJson<int>(ord),
      'shopDepartmentId': serializer.toJson<int>(shopDepartmentId),
      'package': serializer.toJson<int>(package),
      'userPackage': serializer.toJson<int>(userPackage),
    };
  }

  Category copyWith(
          {int? id,
          String? name,
          int? ord,
          int? shopDepartmentId,
          int? package,
          int? userPackage}) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        ord: ord ?? this.ord,
        shopDepartmentId: shopDepartmentId ?? this.shopDepartmentId,
        package: package ?? this.package,
        userPackage: userPackage ?? this.userPackage,
      );
  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('ord: $ord, ')
          ..write('shopDepartmentId: $shopDepartmentId, ')
          ..write('package: $package, ')
          ..write('userPackage: $userPackage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, ord, shopDepartmentId, package, userPackage);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.ord == this.ord &&
          other.shopDepartmentId == this.shopDepartmentId &&
          other.package == this.package &&
          other.userPackage == this.userPackage);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> ord;
  final Value<int> shopDepartmentId;
  final Value<int> package;
  final Value<int> userPackage;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.ord = const Value.absent(),
    this.shopDepartmentId = const Value.absent(),
    this.package = const Value.absent(),
    this.userPackage = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int ord,
    required int shopDepartmentId,
    required int package,
    required int userPackage,
  })  : name = Value(name),
        ord = Value(ord),
        shopDepartmentId = Value(shopDepartmentId),
        package = Value(package),
        userPackage = Value(userPackage);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? ord,
    Expression<int>? shopDepartmentId,
    Expression<int>? package,
    Expression<int>? userPackage,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (ord != null) 'ord': ord,
      if (shopDepartmentId != null) 'shop_department_id': shopDepartmentId,
      if (package != null) 'package': package,
      if (userPackage != null) 'user_package': userPackage,
    });
  }

  CategoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? ord,
      Value<int>? shopDepartmentId,
      Value<int>? package,
      Value<int>? userPackage}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      ord: ord ?? this.ord,
      shopDepartmentId: shopDepartmentId ?? this.shopDepartmentId,
      package: package ?? this.package,
      userPackage: userPackage ?? this.userPackage,
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
    if (ord.present) {
      map['ord'] = Variable<int>(ord.value);
    }
    if (shopDepartmentId.present) {
      map['shop_department_id'] = Variable<int>(shopDepartmentId.value);
    }
    if (package.present) {
      map['package'] = Variable<int>(package.value);
    }
    if (userPackage.present) {
      map['user_package'] = Variable<int>(userPackage.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('ord: $ord, ')
          ..write('shopDepartmentId: $shopDepartmentId, ')
          ..write('package: $package, ')
          ..write('userPackage: $userPackage')
          ..write(')'))
        .toString();
  }
}

class $GoodsFiltersTable extends GoodsFilters
    with TableInfo<$GoodsFiltersTable, GoodsFilter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoodsFiltersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, value];
  @override
  String get aliasedName => _alias ?? 'goods_filters';
  @override
  String get actualTableName => 'goods_filters';
  @override
  VerificationContext validateIntegrity(Insertable<GoodsFilter> instance,
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
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoodsFilter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoodsFilter(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $GoodsFiltersTable createAlias(String alias) {
    return $GoodsFiltersTable(attachedDatabase, alias);
  }
}

class GoodsFilter extends DataClass implements Insertable<GoodsFilter> {
  final int id;
  final String name;
  final String value;
  const GoodsFilter(
      {required this.id, required this.name, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['value'] = Variable<String>(value);
    return map;
  }

  GoodsFiltersCompanion toCompanion(bool nullToAbsent) {
    return GoodsFiltersCompanion(
      id: Value(id),
      name: Value(name),
      value: Value(value),
    );
  }

  factory GoodsFilter.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoodsFilter(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'value': serializer.toJson<String>(value),
    };
  }

  GoodsFilter copyWith({int? id, String? name, String? value}) => GoodsFilter(
        id: id ?? this.id,
        name: name ?? this.name,
        value: value ?? this.value,
      );
  @override
  String toString() {
    return (StringBuffer('GoodsFilter(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoodsFilter &&
          other.id == this.id &&
          other.name == this.name &&
          other.value == this.value);
}

class GoodsFiltersCompanion extends UpdateCompanion<GoodsFilter> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> value;
  const GoodsFiltersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.value = const Value.absent(),
  });
  GoodsFiltersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String value,
  })  : name = Value(name),
        value = Value(value);
  static Insertable<GoodsFilter> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? value,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (value != null) 'value': value,
    });
  }

  GoodsFiltersCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<String>? value}) {
    return GoodsFiltersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
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
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoodsFiltersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $OrdersTable extends Orders with TableInfo<$OrdersTable, Order> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _guidMeta = const VerificationMeta('guid');
  @override
  late final GeneratedColumn<String> guid = GeneratedColumn<String>(
      'guid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted =
      GeneratedColumn<bool>('is_deleted', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_deleted" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _currentTimestampMeta =
      const VerificationMeta('currentTimestamp');
  @override
  late final GeneratedColumn<DateTime> currentTimestamp =
      GeneratedColumn<DateTime>('current_timestamp', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  static const VerificationMeta _lastSyncTimeMeta =
      const VerificationMeta('lastSyncTime');
  @override
  late final GeneratedColumn<DateTime> lastSyncTime = GeneratedColumn<DateTime>(
      'last_sync_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _needSyncMeta =
      const VerificationMeta('needSync');
  @override
  late final GeneratedColumn<bool> needSync = GeneratedColumn<bool>(
      'need_sync', aliasedName, false,
      generatedAs: GeneratedAs(
          (isNew & isDeleted.not()) |
              (isNew.not() & lastSyncTime.isSmallerThan(timestamp)),
          true),
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
        SqlDialect.sqlite: 'CHECK ("need_sync" IN (0, 1))',
        SqlDialect.mysql: '',
        SqlDialect.postgres: '',
      }));
  static const VerificationMeta _isNewMeta = const VerificationMeta('isNew');
  @override
  late final GeneratedColumn<bool> isNew =
      GeneratedColumn<bool>('is_new', aliasedName, false,
          generatedAs: GeneratedAs(lastSyncTime.isNull(), false),
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_new" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _preOrderIdMeta =
      const VerificationMeta('preOrderId');
  @override
  late final GeneratedColumn<int> preOrderId = GeneratedColumn<int>(
      'pre_order_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _needDocsMeta =
      const VerificationMeta('needDocs');
  @override
  late final GeneratedColumn<bool> needDocs =
      GeneratedColumn<bool>('need_docs', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("need_docs" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  static const VerificationMeta _needIncMeta =
      const VerificationMeta('needInc');
  @override
  late final GeneratedColumn<bool> needInc =
      GeneratedColumn<bool>('need_inc', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("need_inc" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  static const VerificationMeta _isBonusMeta =
      const VerificationMeta('isBonus');
  @override
  late final GeneratedColumn<bool> isBonus =
      GeneratedColumn<bool>('is_bonus', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_bonus" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  static const VerificationMeta _isPhysicalMeta =
      const VerificationMeta('isPhysical');
  @override
  late final GeneratedColumn<bool> isPhysical =
      GeneratedColumn<bool>('is_physical', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_physical" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  static const VerificationMeta _buyerIdMeta =
      const VerificationMeta('buyerId');
  @override
  late final GeneratedColumn<int> buyerId = GeneratedColumn<int>(
      'buyer_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _infoMeta = const VerificationMeta('info');
  @override
  late final GeneratedColumn<String> info = GeneratedColumn<String>(
      'info', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _needProcessingMeta =
      const VerificationMeta('needProcessing');
  @override
  late final GeneratedColumn<bool> needProcessing =
      GeneratedColumn<bool>('need_processing', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("need_processing" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  static const VerificationMeta _isEditableMeta =
      const VerificationMeta('isEditable');
  @override
  late final GeneratedColumn<bool> isEditable =
      GeneratedColumn<bool>('is_editable', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_editable" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  @override
  List<GeneratedColumn> get $columns => [
        guid,
        isDeleted,
        timestamp,
        currentTimestamp,
        lastSyncTime,
        needSync,
        isNew,
        id,
        date,
        status,
        preOrderId,
        needDocs,
        needInc,
        isBonus,
        isPhysical,
        buyerId,
        info,
        needProcessing,
        isEditable
      ];
  @override
  String get aliasedName => _alias ?? 'orders';
  @override
  String get actualTableName => 'orders';
  @override
  VerificationContext validateIntegrity(Insertable<Order> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('guid')) {
      context.handle(
          _guidMeta, guid.isAcceptableOrUnknown(data['guid']!, _guidMeta));
    } else if (isInserting) {
      context.missing(_guidMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    }
    if (data.containsKey('current_timestamp')) {
      context.handle(
          _currentTimestampMeta,
          currentTimestamp.isAcceptableOrUnknown(
              data['current_timestamp']!, _currentTimestampMeta));
    }
    if (data.containsKey('last_sync_time')) {
      context.handle(
          _lastSyncTimeMeta,
          lastSyncTime.isAcceptableOrUnknown(
              data['last_sync_time']!, _lastSyncTimeMeta));
    }
    if (data.containsKey('need_sync')) {
      context.handle(_needSyncMeta,
          needSync.isAcceptableOrUnknown(data['need_sync']!, _needSyncMeta));
    }
    if (data.containsKey('is_new')) {
      context.handle(
          _isNewMeta, isNew.isAcceptableOrUnknown(data['is_new']!, _isNewMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('pre_order_id')) {
      context.handle(
          _preOrderIdMeta,
          preOrderId.isAcceptableOrUnknown(
              data['pre_order_id']!, _preOrderIdMeta));
    }
    if (data.containsKey('need_docs')) {
      context.handle(_needDocsMeta,
          needDocs.isAcceptableOrUnknown(data['need_docs']!, _needDocsMeta));
    } else if (isInserting) {
      context.missing(_needDocsMeta);
    }
    if (data.containsKey('need_inc')) {
      context.handle(_needIncMeta,
          needInc.isAcceptableOrUnknown(data['need_inc']!, _needIncMeta));
    } else if (isInserting) {
      context.missing(_needIncMeta);
    }
    if (data.containsKey('is_bonus')) {
      context.handle(_isBonusMeta,
          isBonus.isAcceptableOrUnknown(data['is_bonus']!, _isBonusMeta));
    } else if (isInserting) {
      context.missing(_isBonusMeta);
    }
    if (data.containsKey('is_physical')) {
      context.handle(
          _isPhysicalMeta,
          isPhysical.isAcceptableOrUnknown(
              data['is_physical']!, _isPhysicalMeta));
    } else if (isInserting) {
      context.missing(_isPhysicalMeta);
    }
    if (data.containsKey('buyer_id')) {
      context.handle(_buyerIdMeta,
          buyerId.isAcceptableOrUnknown(data['buyer_id']!, _buyerIdMeta));
    }
    if (data.containsKey('info')) {
      context.handle(
          _infoMeta, info.isAcceptableOrUnknown(data['info']!, _infoMeta));
    }
    if (data.containsKey('need_processing')) {
      context.handle(
          _needProcessingMeta,
          needProcessing.isAcceptableOrUnknown(
              data['need_processing']!, _needProcessingMeta));
    } else if (isInserting) {
      context.missing(_needProcessingMeta);
    }
    if (data.containsKey('is_editable')) {
      context.handle(
          _isEditableMeta,
          isEditable.isAcceptableOrUnknown(
              data['is_editable']!, _isEditableMeta));
    } else if (isInserting) {
      context.missing(_isEditableMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {guid};
  @override
  Order map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Order(
      guid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guid'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      currentTimestamp: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}current_timestamp'])!,
      lastSyncTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_sync_time']),
      needSync: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}need_sync'])!,
      isNew: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_new'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      preOrderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pre_order_id']),
      needDocs: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}need_docs'])!,
      needInc: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}need_inc'])!,
      isBonus: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_bonus'])!,
      isPhysical: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_physical'])!,
      buyerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}buyer_id']),
      info: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}info']),
      needProcessing: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}need_processing'])!,
      isEditable: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_editable'])!,
    );
  }

  @override
  $OrdersTable createAlias(String alias) {
    return $OrdersTable(attachedDatabase, alias);
  }
}

class Order extends DataClass implements Insertable<Order> {
  final String guid;
  final bool isDeleted;
  final DateTime timestamp;
  final DateTime currentTimestamp;
  final DateTime? lastSyncTime;
  final bool needSync;
  final bool isNew;
  final int? id;
  final DateTime? date;
  final String status;
  final int? preOrderId;
  final bool needDocs;
  final bool needInc;
  final bool isBonus;
  final bool isPhysical;
  final int? buyerId;
  final String? info;
  final bool needProcessing;
  final bool isEditable;
  const Order(
      {required this.guid,
      required this.isDeleted,
      required this.timestamp,
      required this.currentTimestamp,
      this.lastSyncTime,
      required this.needSync,
      required this.isNew,
      this.id,
      this.date,
      required this.status,
      this.preOrderId,
      required this.needDocs,
      required this.needInc,
      required this.isBonus,
      required this.isPhysical,
      this.buyerId,
      this.info,
      required this.needProcessing,
      required this.isEditable});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['guid'] = Variable<String>(guid);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['current_timestamp'] = Variable<DateTime>(currentTimestamp);
    if (!nullToAbsent || lastSyncTime != null) {
      map['last_sync_time'] = Variable<DateTime>(lastSyncTime);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || preOrderId != null) {
      map['pre_order_id'] = Variable<int>(preOrderId);
    }
    map['need_docs'] = Variable<bool>(needDocs);
    map['need_inc'] = Variable<bool>(needInc);
    map['is_bonus'] = Variable<bool>(isBonus);
    map['is_physical'] = Variable<bool>(isPhysical);
    if (!nullToAbsent || buyerId != null) {
      map['buyer_id'] = Variable<int>(buyerId);
    }
    if (!nullToAbsent || info != null) {
      map['info'] = Variable<String>(info);
    }
    map['need_processing'] = Variable<bool>(needProcessing);
    map['is_editable'] = Variable<bool>(isEditable);
    return map;
  }

  OrdersCompanion toCompanion(bool nullToAbsent) {
    return OrdersCompanion(
      guid: Value(guid),
      isDeleted: Value(isDeleted),
      timestamp: Value(timestamp),
      currentTimestamp: Value(currentTimestamp),
      lastSyncTime: lastSyncTime == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncTime),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      status: Value(status),
      preOrderId: preOrderId == null && nullToAbsent
          ? const Value.absent()
          : Value(preOrderId),
      needDocs: Value(needDocs),
      needInc: Value(needInc),
      isBonus: Value(isBonus),
      isPhysical: Value(isPhysical),
      buyerId: buyerId == null && nullToAbsent
          ? const Value.absent()
          : Value(buyerId),
      info: info == null && nullToAbsent ? const Value.absent() : Value(info),
      needProcessing: Value(needProcessing),
      isEditable: Value(isEditable),
    );
  }

  factory Order.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Order(
      guid: serializer.fromJson<String>(json['guid']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      currentTimestamp: serializer.fromJson<DateTime>(json['currentTimestamp']),
      lastSyncTime: serializer.fromJson<DateTime?>(json['lastSyncTime']),
      needSync: serializer.fromJson<bool>(json['needSync']),
      isNew: serializer.fromJson<bool>(json['isNew']),
      id: serializer.fromJson<int?>(json['id']),
      date: serializer.fromJson<DateTime?>(json['date']),
      status: serializer.fromJson<String>(json['status']),
      preOrderId: serializer.fromJson<int?>(json['preOrderId']),
      needDocs: serializer.fromJson<bool>(json['needDocs']),
      needInc: serializer.fromJson<bool>(json['needInc']),
      isBonus: serializer.fromJson<bool>(json['isBonus']),
      isPhysical: serializer.fromJson<bool>(json['isPhysical']),
      buyerId: serializer.fromJson<int?>(json['buyerId']),
      info: serializer.fromJson<String?>(json['info']),
      needProcessing: serializer.fromJson<bool>(json['needProcessing']),
      isEditable: serializer.fromJson<bool>(json['isEditable']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'guid': serializer.toJson<String>(guid),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'currentTimestamp': serializer.toJson<DateTime>(currentTimestamp),
      'lastSyncTime': serializer.toJson<DateTime?>(lastSyncTime),
      'needSync': serializer.toJson<bool>(needSync),
      'isNew': serializer.toJson<bool>(isNew),
      'id': serializer.toJson<int?>(id),
      'date': serializer.toJson<DateTime?>(date),
      'status': serializer.toJson<String>(status),
      'preOrderId': serializer.toJson<int?>(preOrderId),
      'needDocs': serializer.toJson<bool>(needDocs),
      'needInc': serializer.toJson<bool>(needInc),
      'isBonus': serializer.toJson<bool>(isBonus),
      'isPhysical': serializer.toJson<bool>(isPhysical),
      'buyerId': serializer.toJson<int?>(buyerId),
      'info': serializer.toJson<String?>(info),
      'needProcessing': serializer.toJson<bool>(needProcessing),
      'isEditable': serializer.toJson<bool>(isEditable),
    };
  }

  Order copyWith(
          {String? guid,
          bool? isDeleted,
          DateTime? timestamp,
          DateTime? currentTimestamp,
          Value<DateTime?> lastSyncTime = const Value.absent(),
          bool? needSync,
          bool? isNew,
          Value<int?> id = const Value.absent(),
          Value<DateTime?> date = const Value.absent(),
          String? status,
          Value<int?> preOrderId = const Value.absent(),
          bool? needDocs,
          bool? needInc,
          bool? isBonus,
          bool? isPhysical,
          Value<int?> buyerId = const Value.absent(),
          Value<String?> info = const Value.absent(),
          bool? needProcessing,
          bool? isEditable}) =>
      Order(
        guid: guid ?? this.guid,
        isDeleted: isDeleted ?? this.isDeleted,
        timestamp: timestamp ?? this.timestamp,
        currentTimestamp: currentTimestamp ?? this.currentTimestamp,
        lastSyncTime:
            lastSyncTime.present ? lastSyncTime.value : this.lastSyncTime,
        needSync: needSync ?? this.needSync,
        isNew: isNew ?? this.isNew,
        id: id.present ? id.value : this.id,
        date: date.present ? date.value : this.date,
        status: status ?? this.status,
        preOrderId: preOrderId.present ? preOrderId.value : this.preOrderId,
        needDocs: needDocs ?? this.needDocs,
        needInc: needInc ?? this.needInc,
        isBonus: isBonus ?? this.isBonus,
        isPhysical: isPhysical ?? this.isPhysical,
        buyerId: buyerId.present ? buyerId.value : this.buyerId,
        info: info.present ? info.value : this.info,
        needProcessing: needProcessing ?? this.needProcessing,
        isEditable: isEditable ?? this.isEditable,
      );
  @override
  String toString() {
    return (StringBuffer('Order(')
          ..write('guid: $guid, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('timestamp: $timestamp, ')
          ..write('currentTimestamp: $currentTimestamp, ')
          ..write('lastSyncTime: $lastSyncTime, ')
          ..write('needSync: $needSync, ')
          ..write('isNew: $isNew, ')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('preOrderId: $preOrderId, ')
          ..write('needDocs: $needDocs, ')
          ..write('needInc: $needInc, ')
          ..write('isBonus: $isBonus, ')
          ..write('isPhysical: $isPhysical, ')
          ..write('buyerId: $buyerId, ')
          ..write('info: $info, ')
          ..write('needProcessing: $needProcessing, ')
          ..write('isEditable: $isEditable')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      guid,
      isDeleted,
      timestamp,
      currentTimestamp,
      lastSyncTime,
      needSync,
      isNew,
      id,
      date,
      status,
      preOrderId,
      needDocs,
      needInc,
      isBonus,
      isPhysical,
      buyerId,
      info,
      needProcessing,
      isEditable);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Order &&
          other.guid == this.guid &&
          other.isDeleted == this.isDeleted &&
          other.timestamp == this.timestamp &&
          other.currentTimestamp == this.currentTimestamp &&
          other.lastSyncTime == this.lastSyncTime &&
          other.needSync == this.needSync &&
          other.isNew == this.isNew &&
          other.id == this.id &&
          other.date == this.date &&
          other.status == this.status &&
          other.preOrderId == this.preOrderId &&
          other.needDocs == this.needDocs &&
          other.needInc == this.needInc &&
          other.isBonus == this.isBonus &&
          other.isPhysical == this.isPhysical &&
          other.buyerId == this.buyerId &&
          other.info == this.info &&
          other.needProcessing == this.needProcessing &&
          other.isEditable == this.isEditable);
}

class OrdersCompanion extends UpdateCompanion<Order> {
  final Value<String> guid;
  final Value<bool> isDeleted;
  final Value<DateTime> timestamp;
  final Value<DateTime> currentTimestamp;
  final Value<DateTime?> lastSyncTime;
  final Value<int?> id;
  final Value<DateTime?> date;
  final Value<String> status;
  final Value<int?> preOrderId;
  final Value<bool> needDocs;
  final Value<bool> needInc;
  final Value<bool> isBonus;
  final Value<bool> isPhysical;
  final Value<int?> buyerId;
  final Value<String?> info;
  final Value<bool> needProcessing;
  final Value<bool> isEditable;
  final Value<int> rowid;
  const OrdersCompanion({
    this.guid = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.currentTimestamp = const Value.absent(),
    this.lastSyncTime = const Value.absent(),
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.status = const Value.absent(),
    this.preOrderId = const Value.absent(),
    this.needDocs = const Value.absent(),
    this.needInc = const Value.absent(),
    this.isBonus = const Value.absent(),
    this.isPhysical = const Value.absent(),
    this.buyerId = const Value.absent(),
    this.info = const Value.absent(),
    this.needProcessing = const Value.absent(),
    this.isEditable = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrdersCompanion.insert({
    required String guid,
    this.isDeleted = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.currentTimestamp = const Value.absent(),
    this.lastSyncTime = const Value.absent(),
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    required String status,
    this.preOrderId = const Value.absent(),
    required bool needDocs,
    required bool needInc,
    required bool isBonus,
    required bool isPhysical,
    this.buyerId = const Value.absent(),
    this.info = const Value.absent(),
    required bool needProcessing,
    required bool isEditable,
    this.rowid = const Value.absent(),
  })  : guid = Value(guid),
        status = Value(status),
        needDocs = Value(needDocs),
        needInc = Value(needInc),
        isBonus = Value(isBonus),
        isPhysical = Value(isPhysical),
        needProcessing = Value(needProcessing),
        isEditable = Value(isEditable);
  static Insertable<Order> custom({
    Expression<String>? guid,
    Expression<bool>? isDeleted,
    Expression<DateTime>? timestamp,
    Expression<DateTime>? currentTimestamp,
    Expression<DateTime>? lastSyncTime,
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? status,
    Expression<int>? preOrderId,
    Expression<bool>? needDocs,
    Expression<bool>? needInc,
    Expression<bool>? isBonus,
    Expression<bool>? isPhysical,
    Expression<int>? buyerId,
    Expression<String>? info,
    Expression<bool>? needProcessing,
    Expression<bool>? isEditable,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (guid != null) 'guid': guid,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (timestamp != null) 'timestamp': timestamp,
      if (currentTimestamp != null) 'current_timestamp': currentTimestamp,
      if (lastSyncTime != null) 'last_sync_time': lastSyncTime,
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (status != null) 'status': status,
      if (preOrderId != null) 'pre_order_id': preOrderId,
      if (needDocs != null) 'need_docs': needDocs,
      if (needInc != null) 'need_inc': needInc,
      if (isBonus != null) 'is_bonus': isBonus,
      if (isPhysical != null) 'is_physical': isPhysical,
      if (buyerId != null) 'buyer_id': buyerId,
      if (info != null) 'info': info,
      if (needProcessing != null) 'need_processing': needProcessing,
      if (isEditable != null) 'is_editable': isEditable,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrdersCompanion copyWith(
      {Value<String>? guid,
      Value<bool>? isDeleted,
      Value<DateTime>? timestamp,
      Value<DateTime>? currentTimestamp,
      Value<DateTime?>? lastSyncTime,
      Value<int?>? id,
      Value<DateTime?>? date,
      Value<String>? status,
      Value<int?>? preOrderId,
      Value<bool>? needDocs,
      Value<bool>? needInc,
      Value<bool>? isBonus,
      Value<bool>? isPhysical,
      Value<int?>? buyerId,
      Value<String?>? info,
      Value<bool>? needProcessing,
      Value<bool>? isEditable,
      Value<int>? rowid}) {
    return OrdersCompanion(
      guid: guid ?? this.guid,
      isDeleted: isDeleted ?? this.isDeleted,
      timestamp: timestamp ?? this.timestamp,
      currentTimestamp: currentTimestamp ?? this.currentTimestamp,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      id: id ?? this.id,
      date: date ?? this.date,
      status: status ?? this.status,
      preOrderId: preOrderId ?? this.preOrderId,
      needDocs: needDocs ?? this.needDocs,
      needInc: needInc ?? this.needInc,
      isBonus: isBonus ?? this.isBonus,
      isPhysical: isPhysical ?? this.isPhysical,
      buyerId: buyerId ?? this.buyerId,
      info: info ?? this.info,
      needProcessing: needProcessing ?? this.needProcessing,
      isEditable: isEditable ?? this.isEditable,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (guid.present) {
      map['guid'] = Variable<String>(guid.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (currentTimestamp.present) {
      map['current_timestamp'] = Variable<DateTime>(currentTimestamp.value);
    }
    if (lastSyncTime.present) {
      map['last_sync_time'] = Variable<DateTime>(lastSyncTime.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (preOrderId.present) {
      map['pre_order_id'] = Variable<int>(preOrderId.value);
    }
    if (needDocs.present) {
      map['need_docs'] = Variable<bool>(needDocs.value);
    }
    if (needInc.present) {
      map['need_inc'] = Variable<bool>(needInc.value);
    }
    if (isBonus.present) {
      map['is_bonus'] = Variable<bool>(isBonus.value);
    }
    if (isPhysical.present) {
      map['is_physical'] = Variable<bool>(isPhysical.value);
    }
    if (buyerId.present) {
      map['buyer_id'] = Variable<int>(buyerId.value);
    }
    if (info.present) {
      map['info'] = Variable<String>(info.value);
    }
    if (needProcessing.present) {
      map['need_processing'] = Variable<bool>(needProcessing.value);
    }
    if (isEditable.present) {
      map['is_editable'] = Variable<bool>(isEditable.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersCompanion(')
          ..write('guid: $guid, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('timestamp: $timestamp, ')
          ..write('currentTimestamp: $currentTimestamp, ')
          ..write('lastSyncTime: $lastSyncTime, ')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('preOrderId: $preOrderId, ')
          ..write('needDocs: $needDocs, ')
          ..write('needInc: $needInc, ')
          ..write('isBonus: $isBonus, ')
          ..write('isPhysical: $isPhysical, ')
          ..write('buyerId: $buyerId, ')
          ..write('info: $info, ')
          ..write('needProcessing: $needProcessing, ')
          ..write('isEditable: $isEditable, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrderLinesTable extends OrderLines
    with TableInfo<$OrderLinesTable, OrderLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _guidMeta = const VerificationMeta('guid');
  @override
  late final GeneratedColumn<String> guid = GeneratedColumn<String>(
      'guid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted =
      GeneratedColumn<bool>('is_deleted', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_deleted" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _currentTimestampMeta =
      const VerificationMeta('currentTimestamp');
  @override
  late final GeneratedColumn<DateTime> currentTimestamp =
      GeneratedColumn<DateTime>('current_timestamp', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  static const VerificationMeta _lastSyncTimeMeta =
      const VerificationMeta('lastSyncTime');
  @override
  late final GeneratedColumn<DateTime> lastSyncTime = GeneratedColumn<DateTime>(
      'last_sync_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _needSyncMeta =
      const VerificationMeta('needSync');
  @override
  late final GeneratedColumn<bool> needSync = GeneratedColumn<bool>(
      'need_sync', aliasedName, false,
      generatedAs: GeneratedAs(
          (isNew & isDeleted.not()) |
              (isNew.not() & lastSyncTime.isSmallerThan(timestamp)),
          true),
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
        SqlDialect.sqlite: 'CHECK ("need_sync" IN (0, 1))',
        SqlDialect.mysql: '',
        SqlDialect.postgres: '',
      }));
  static const VerificationMeta _isNewMeta = const VerificationMeta('isNew');
  @override
  late final GeneratedColumn<bool> isNew =
      GeneratedColumn<bool>('is_new', aliasedName, false,
          generatedAs: GeneratedAs(lastSyncTime.isNull(), false),
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_new" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _orderGuidMeta =
      const VerificationMeta('orderGuid');
  @override
  late final GeneratedColumn<String> orderGuid = GeneratedColumn<String>(
      'order_guid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES orders (guid) ON UPDATE CASCADE ON DELETE CASCADE'));
  static const VerificationMeta _goodsIdMeta =
      const VerificationMeta('goodsId');
  @override
  late final GeneratedColumn<int> goodsId = GeneratedColumn<int>(
      'goods_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _volMeta = const VerificationMeta('vol');
  @override
  late final GeneratedColumn<double> vol = GeneratedColumn<double>(
      'vol', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _priceOriginalMeta =
      const VerificationMeta('priceOriginal');
  @override
  late final GeneratedColumn<double> priceOriginal = GeneratedColumn<double>(
      'price_original', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _packageMeta =
      const VerificationMeta('package');
  @override
  late final GeneratedColumn<int> package = GeneratedColumn<int>(
      'package', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _relMeta = const VerificationMeta('rel');
  @override
  late final GeneratedColumn<int> rel = GeneratedColumn<int>(
      'rel', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        guid,
        isDeleted,
        timestamp,
        currentTimestamp,
        lastSyncTime,
        needSync,
        isNew,
        id,
        orderGuid,
        goodsId,
        vol,
        price,
        priceOriginal,
        package,
        rel
      ];
  @override
  String get aliasedName => _alias ?? 'order_lines';
  @override
  String get actualTableName => 'order_lines';
  @override
  VerificationContext validateIntegrity(Insertable<OrderLine> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('guid')) {
      context.handle(
          _guidMeta, guid.isAcceptableOrUnknown(data['guid']!, _guidMeta));
    } else if (isInserting) {
      context.missing(_guidMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    }
    if (data.containsKey('current_timestamp')) {
      context.handle(
          _currentTimestampMeta,
          currentTimestamp.isAcceptableOrUnknown(
              data['current_timestamp']!, _currentTimestampMeta));
    }
    if (data.containsKey('last_sync_time')) {
      context.handle(
          _lastSyncTimeMeta,
          lastSyncTime.isAcceptableOrUnknown(
              data['last_sync_time']!, _lastSyncTimeMeta));
    }
    if (data.containsKey('need_sync')) {
      context.handle(_needSyncMeta,
          needSync.isAcceptableOrUnknown(data['need_sync']!, _needSyncMeta));
    }
    if (data.containsKey('is_new')) {
      context.handle(
          _isNewMeta, isNew.isAcceptableOrUnknown(data['is_new']!, _isNewMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_guid')) {
      context.handle(_orderGuidMeta,
          orderGuid.isAcceptableOrUnknown(data['order_guid']!, _orderGuidMeta));
    } else if (isInserting) {
      context.missing(_orderGuidMeta);
    }
    if (data.containsKey('goods_id')) {
      context.handle(_goodsIdMeta,
          goodsId.isAcceptableOrUnknown(data['goods_id']!, _goodsIdMeta));
    } else if (isInserting) {
      context.missing(_goodsIdMeta);
    }
    if (data.containsKey('vol')) {
      context.handle(
          _volMeta, vol.isAcceptableOrUnknown(data['vol']!, _volMeta));
    } else if (isInserting) {
      context.missing(_volMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('price_original')) {
      context.handle(
          _priceOriginalMeta,
          priceOriginal.isAcceptableOrUnknown(
              data['price_original']!, _priceOriginalMeta));
    } else if (isInserting) {
      context.missing(_priceOriginalMeta);
    }
    if (data.containsKey('package')) {
      context.handle(_packageMeta,
          package.isAcceptableOrUnknown(data['package']!, _packageMeta));
    } else if (isInserting) {
      context.missing(_packageMeta);
    }
    if (data.containsKey('rel')) {
      context.handle(
          _relMeta, rel.isAcceptableOrUnknown(data['rel']!, _relMeta));
    } else if (isInserting) {
      context.missing(_relMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {guid};
  @override
  OrderLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderLine(
      guid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guid'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      currentTimestamp: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}current_timestamp'])!,
      lastSyncTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_sync_time']),
      needSync: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}need_sync'])!,
      isNew: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_new'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id']),
      orderGuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}order_guid'])!,
      goodsId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}goods_id'])!,
      vol: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}vol'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      priceOriginal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price_original'])!,
      package: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}package'])!,
      rel: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rel'])!,
    );
  }

  @override
  $OrderLinesTable createAlias(String alias) {
    return $OrderLinesTable(attachedDatabase, alias);
  }
}

class OrderLine extends DataClass implements Insertable<OrderLine> {
  final String guid;
  final bool isDeleted;
  final DateTime timestamp;
  final DateTime currentTimestamp;
  final DateTime? lastSyncTime;
  final bool needSync;
  final bool isNew;
  final int? id;
  final String orderGuid;
  final int goodsId;
  final double vol;
  final double price;
  final double priceOriginal;
  final int package;
  final int rel;
  const OrderLine(
      {required this.guid,
      required this.isDeleted,
      required this.timestamp,
      required this.currentTimestamp,
      this.lastSyncTime,
      required this.needSync,
      required this.isNew,
      this.id,
      required this.orderGuid,
      required this.goodsId,
      required this.vol,
      required this.price,
      required this.priceOriginal,
      required this.package,
      required this.rel});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['guid'] = Variable<String>(guid);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['current_timestamp'] = Variable<DateTime>(currentTimestamp);
    if (!nullToAbsent || lastSyncTime != null) {
      map['last_sync_time'] = Variable<DateTime>(lastSyncTime);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    map['order_guid'] = Variable<String>(orderGuid);
    map['goods_id'] = Variable<int>(goodsId);
    map['vol'] = Variable<double>(vol);
    map['price'] = Variable<double>(price);
    map['price_original'] = Variable<double>(priceOriginal);
    map['package'] = Variable<int>(package);
    map['rel'] = Variable<int>(rel);
    return map;
  }

  OrderLinesCompanion toCompanion(bool nullToAbsent) {
    return OrderLinesCompanion(
      guid: Value(guid),
      isDeleted: Value(isDeleted),
      timestamp: Value(timestamp),
      currentTimestamp: Value(currentTimestamp),
      lastSyncTime: lastSyncTime == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncTime),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      orderGuid: Value(orderGuid),
      goodsId: Value(goodsId),
      vol: Value(vol),
      price: Value(price),
      priceOriginal: Value(priceOriginal),
      package: Value(package),
      rel: Value(rel),
    );
  }

  factory OrderLine.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderLine(
      guid: serializer.fromJson<String>(json['guid']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      currentTimestamp: serializer.fromJson<DateTime>(json['currentTimestamp']),
      lastSyncTime: serializer.fromJson<DateTime?>(json['lastSyncTime']),
      needSync: serializer.fromJson<bool>(json['needSync']),
      isNew: serializer.fromJson<bool>(json['isNew']),
      id: serializer.fromJson<int?>(json['id']),
      orderGuid: serializer.fromJson<String>(json['orderGuid']),
      goodsId: serializer.fromJson<int>(json['goodsId']),
      vol: serializer.fromJson<double>(json['vol']),
      price: serializer.fromJson<double>(json['price']),
      priceOriginal: serializer.fromJson<double>(json['priceOriginal']),
      package: serializer.fromJson<int>(json['package']),
      rel: serializer.fromJson<int>(json['rel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'guid': serializer.toJson<String>(guid),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'currentTimestamp': serializer.toJson<DateTime>(currentTimestamp),
      'lastSyncTime': serializer.toJson<DateTime?>(lastSyncTime),
      'needSync': serializer.toJson<bool>(needSync),
      'isNew': serializer.toJson<bool>(isNew),
      'id': serializer.toJson<int?>(id),
      'orderGuid': serializer.toJson<String>(orderGuid),
      'goodsId': serializer.toJson<int>(goodsId),
      'vol': serializer.toJson<double>(vol),
      'price': serializer.toJson<double>(price),
      'priceOriginal': serializer.toJson<double>(priceOriginal),
      'package': serializer.toJson<int>(package),
      'rel': serializer.toJson<int>(rel),
    };
  }

  OrderLine copyWith(
          {String? guid,
          bool? isDeleted,
          DateTime? timestamp,
          DateTime? currentTimestamp,
          Value<DateTime?> lastSyncTime = const Value.absent(),
          bool? needSync,
          bool? isNew,
          Value<int?> id = const Value.absent(),
          String? orderGuid,
          int? goodsId,
          double? vol,
          double? price,
          double? priceOriginal,
          int? package,
          int? rel}) =>
      OrderLine(
        guid: guid ?? this.guid,
        isDeleted: isDeleted ?? this.isDeleted,
        timestamp: timestamp ?? this.timestamp,
        currentTimestamp: currentTimestamp ?? this.currentTimestamp,
        lastSyncTime:
            lastSyncTime.present ? lastSyncTime.value : this.lastSyncTime,
        needSync: needSync ?? this.needSync,
        isNew: isNew ?? this.isNew,
        id: id.present ? id.value : this.id,
        orderGuid: orderGuid ?? this.orderGuid,
        goodsId: goodsId ?? this.goodsId,
        vol: vol ?? this.vol,
        price: price ?? this.price,
        priceOriginal: priceOriginal ?? this.priceOriginal,
        package: package ?? this.package,
        rel: rel ?? this.rel,
      );
  @override
  String toString() {
    return (StringBuffer('OrderLine(')
          ..write('guid: $guid, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('timestamp: $timestamp, ')
          ..write('currentTimestamp: $currentTimestamp, ')
          ..write('lastSyncTime: $lastSyncTime, ')
          ..write('needSync: $needSync, ')
          ..write('isNew: $isNew, ')
          ..write('id: $id, ')
          ..write('orderGuid: $orderGuid, ')
          ..write('goodsId: $goodsId, ')
          ..write('vol: $vol, ')
          ..write('price: $price, ')
          ..write('priceOriginal: $priceOriginal, ')
          ..write('package: $package, ')
          ..write('rel: $rel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      guid,
      isDeleted,
      timestamp,
      currentTimestamp,
      lastSyncTime,
      needSync,
      isNew,
      id,
      orderGuid,
      goodsId,
      vol,
      price,
      priceOriginal,
      package,
      rel);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderLine &&
          other.guid == this.guid &&
          other.isDeleted == this.isDeleted &&
          other.timestamp == this.timestamp &&
          other.currentTimestamp == this.currentTimestamp &&
          other.lastSyncTime == this.lastSyncTime &&
          other.needSync == this.needSync &&
          other.isNew == this.isNew &&
          other.id == this.id &&
          other.orderGuid == this.orderGuid &&
          other.goodsId == this.goodsId &&
          other.vol == this.vol &&
          other.price == this.price &&
          other.priceOriginal == this.priceOriginal &&
          other.package == this.package &&
          other.rel == this.rel);
}

class OrderLinesCompanion extends UpdateCompanion<OrderLine> {
  final Value<String> guid;
  final Value<bool> isDeleted;
  final Value<DateTime> timestamp;
  final Value<DateTime> currentTimestamp;
  final Value<DateTime?> lastSyncTime;
  final Value<int?> id;
  final Value<String> orderGuid;
  final Value<int> goodsId;
  final Value<double> vol;
  final Value<double> price;
  final Value<double> priceOriginal;
  final Value<int> package;
  final Value<int> rel;
  final Value<int> rowid;
  const OrderLinesCompanion({
    this.guid = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.currentTimestamp = const Value.absent(),
    this.lastSyncTime = const Value.absent(),
    this.id = const Value.absent(),
    this.orderGuid = const Value.absent(),
    this.goodsId = const Value.absent(),
    this.vol = const Value.absent(),
    this.price = const Value.absent(),
    this.priceOriginal = const Value.absent(),
    this.package = const Value.absent(),
    this.rel = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrderLinesCompanion.insert({
    required String guid,
    this.isDeleted = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.currentTimestamp = const Value.absent(),
    this.lastSyncTime = const Value.absent(),
    this.id = const Value.absent(),
    required String orderGuid,
    required int goodsId,
    required double vol,
    required double price,
    required double priceOriginal,
    required int package,
    required int rel,
    this.rowid = const Value.absent(),
  })  : guid = Value(guid),
        orderGuid = Value(orderGuid),
        goodsId = Value(goodsId),
        vol = Value(vol),
        price = Value(price),
        priceOriginal = Value(priceOriginal),
        package = Value(package),
        rel = Value(rel);
  static Insertable<OrderLine> custom({
    Expression<String>? guid,
    Expression<bool>? isDeleted,
    Expression<DateTime>? timestamp,
    Expression<DateTime>? currentTimestamp,
    Expression<DateTime>? lastSyncTime,
    Expression<int>? id,
    Expression<String>? orderGuid,
    Expression<int>? goodsId,
    Expression<double>? vol,
    Expression<double>? price,
    Expression<double>? priceOriginal,
    Expression<int>? package,
    Expression<int>? rel,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (guid != null) 'guid': guid,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (timestamp != null) 'timestamp': timestamp,
      if (currentTimestamp != null) 'current_timestamp': currentTimestamp,
      if (lastSyncTime != null) 'last_sync_time': lastSyncTime,
      if (id != null) 'id': id,
      if (orderGuid != null) 'order_guid': orderGuid,
      if (goodsId != null) 'goods_id': goodsId,
      if (vol != null) 'vol': vol,
      if (price != null) 'price': price,
      if (priceOriginal != null) 'price_original': priceOriginal,
      if (package != null) 'package': package,
      if (rel != null) 'rel': rel,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrderLinesCompanion copyWith(
      {Value<String>? guid,
      Value<bool>? isDeleted,
      Value<DateTime>? timestamp,
      Value<DateTime>? currentTimestamp,
      Value<DateTime?>? lastSyncTime,
      Value<int?>? id,
      Value<String>? orderGuid,
      Value<int>? goodsId,
      Value<double>? vol,
      Value<double>? price,
      Value<double>? priceOriginal,
      Value<int>? package,
      Value<int>? rel,
      Value<int>? rowid}) {
    return OrderLinesCompanion(
      guid: guid ?? this.guid,
      isDeleted: isDeleted ?? this.isDeleted,
      timestamp: timestamp ?? this.timestamp,
      currentTimestamp: currentTimestamp ?? this.currentTimestamp,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      id: id ?? this.id,
      orderGuid: orderGuid ?? this.orderGuid,
      goodsId: goodsId ?? this.goodsId,
      vol: vol ?? this.vol,
      price: price ?? this.price,
      priceOriginal: priceOriginal ?? this.priceOriginal,
      package: package ?? this.package,
      rel: rel ?? this.rel,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (guid.present) {
      map['guid'] = Variable<String>(guid.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (currentTimestamp.present) {
      map['current_timestamp'] = Variable<DateTime>(currentTimestamp.value);
    }
    if (lastSyncTime.present) {
      map['last_sync_time'] = Variable<DateTime>(lastSyncTime.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderGuid.present) {
      map['order_guid'] = Variable<String>(orderGuid.value);
    }
    if (goodsId.present) {
      map['goods_id'] = Variable<int>(goodsId.value);
    }
    if (vol.present) {
      map['vol'] = Variable<double>(vol.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (priceOriginal.present) {
      map['price_original'] = Variable<double>(priceOriginal.value);
    }
    if (package.present) {
      map['package'] = Variable<int>(package.value);
    }
    if (rel.present) {
      map['rel'] = Variable<int>(rel.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderLinesCompanion(')
          ..write('guid: $guid, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('timestamp: $timestamp, ')
          ..write('currentTimestamp: $currentTimestamp, ')
          ..write('lastSyncTime: $lastSyncTime, ')
          ..write('id: $id, ')
          ..write('orderGuid: $orderGuid, ')
          ..write('goodsId: $goodsId, ')
          ..write('vol: $vol, ')
          ..write('price: $price, ')
          ..write('priceOriginal: $priceOriginal, ')
          ..write('package: $package, ')
          ..write('rel: $rel, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PreOrdersTable extends PreOrders
    with TableInfo<$PreOrdersTable, PreOrder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreOrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _buyerIdMeta =
      const VerificationMeta('buyerId');
  @override
  late final GeneratedColumn<int> buyerId = GeneratedColumn<int>(
      'buyer_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _needDocsMeta =
      const VerificationMeta('needDocs');
  @override
  late final GeneratedColumn<bool> needDocs =
      GeneratedColumn<bool>('need_docs', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("need_docs" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  static const VerificationMeta _infoMeta = const VerificationMeta('info');
  @override
  late final GeneratedColumn<String> info = GeneratedColumn<String>(
      'info', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, date, buyerId, needDocs, info];
  @override
  String get aliasedName => _alias ?? 'pre_orders';
  @override
  String get actualTableName => 'pre_orders';
  @override
  VerificationContext validateIntegrity(Insertable<PreOrder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('buyer_id')) {
      context.handle(_buyerIdMeta,
          buyerId.isAcceptableOrUnknown(data['buyer_id']!, _buyerIdMeta));
    } else if (isInserting) {
      context.missing(_buyerIdMeta);
    }
    if (data.containsKey('need_docs')) {
      context.handle(_needDocsMeta,
          needDocs.isAcceptableOrUnknown(data['need_docs']!, _needDocsMeta));
    } else if (isInserting) {
      context.missing(_needDocsMeta);
    }
    if (data.containsKey('info')) {
      context.handle(
          _infoMeta, info.isAcceptableOrUnknown(data['info']!, _infoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PreOrder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreOrder(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      buyerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}buyer_id'])!,
      needDocs: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}need_docs'])!,
      info: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}info']),
    );
  }

  @override
  $PreOrdersTable createAlias(String alias) {
    return $PreOrdersTable(attachedDatabase, alias);
  }
}

class PreOrder extends DataClass implements Insertable<PreOrder> {
  final int id;
  final DateTime date;
  final int buyerId;
  final bool needDocs;
  final String? info;
  const PreOrder(
      {required this.id,
      required this.date,
      required this.buyerId,
      required this.needDocs,
      this.info});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['buyer_id'] = Variable<int>(buyerId);
    map['need_docs'] = Variable<bool>(needDocs);
    if (!nullToAbsent || info != null) {
      map['info'] = Variable<String>(info);
    }
    return map;
  }

  PreOrdersCompanion toCompanion(bool nullToAbsent) {
    return PreOrdersCompanion(
      id: Value(id),
      date: Value(date),
      buyerId: Value(buyerId),
      needDocs: Value(needDocs),
      info: info == null && nullToAbsent ? const Value.absent() : Value(info),
    );
  }

  factory PreOrder.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreOrder(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      buyerId: serializer.fromJson<int>(json['buyerId']),
      needDocs: serializer.fromJson<bool>(json['needDocs']),
      info: serializer.fromJson<String?>(json['info']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'buyerId': serializer.toJson<int>(buyerId),
      'needDocs': serializer.toJson<bool>(needDocs),
      'info': serializer.toJson<String?>(info),
    };
  }

  PreOrder copyWith(
          {int? id,
          DateTime? date,
          int? buyerId,
          bool? needDocs,
          Value<String?> info = const Value.absent()}) =>
      PreOrder(
        id: id ?? this.id,
        date: date ?? this.date,
        buyerId: buyerId ?? this.buyerId,
        needDocs: needDocs ?? this.needDocs,
        info: info.present ? info.value : this.info,
      );
  @override
  String toString() {
    return (StringBuffer('PreOrder(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('buyerId: $buyerId, ')
          ..write('needDocs: $needDocs, ')
          ..write('info: $info')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, buyerId, needDocs, info);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreOrder &&
          other.id == this.id &&
          other.date == this.date &&
          other.buyerId == this.buyerId &&
          other.needDocs == this.needDocs &&
          other.info == this.info);
}

class PreOrdersCompanion extends UpdateCompanion<PreOrder> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> buyerId;
  final Value<bool> needDocs;
  final Value<String?> info;
  const PreOrdersCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.buyerId = const Value.absent(),
    this.needDocs = const Value.absent(),
    this.info = const Value.absent(),
  });
  PreOrdersCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required int buyerId,
    required bool needDocs,
    this.info = const Value.absent(),
  })  : date = Value(date),
        buyerId = Value(buyerId),
        needDocs = Value(needDocs);
  static Insertable<PreOrder> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? buyerId,
    Expression<bool>? needDocs,
    Expression<String>? info,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (buyerId != null) 'buyer_id': buyerId,
      if (needDocs != null) 'need_docs': needDocs,
      if (info != null) 'info': info,
    });
  }

  PreOrdersCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<int>? buyerId,
      Value<bool>? needDocs,
      Value<String?>? info}) {
    return PreOrdersCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      buyerId: buyerId ?? this.buyerId,
      needDocs: needDocs ?? this.needDocs,
      info: info ?? this.info,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (buyerId.present) {
      map['buyer_id'] = Variable<int>(buyerId.value);
    }
    if (needDocs.present) {
      map['need_docs'] = Variable<bool>(needDocs.value);
    }
    if (info.present) {
      map['info'] = Variable<String>(info.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreOrdersCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('buyerId: $buyerId, ')
          ..write('needDocs: $needDocs, ')
          ..write('info: $info')
          ..write(')'))
        .toString();
  }
}

class $PreOrderLinesTable extends PreOrderLines
    with TableInfo<$PreOrderLinesTable, PreOrderLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreOrderLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _preOrderIdMeta =
      const VerificationMeta('preOrderId');
  @override
  late final GeneratedColumn<int> preOrderId = GeneratedColumn<int>(
      'pre_order_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _goodsIdMeta =
      const VerificationMeta('goodsId');
  @override
  late final GeneratedColumn<int> goodsId = GeneratedColumn<int>(
      'goods_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _volMeta = const VerificationMeta('vol');
  @override
  late final GeneratedColumn<double> vol = GeneratedColumn<double>(
      'vol', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _packageMeta =
      const VerificationMeta('package');
  @override
  late final GeneratedColumn<int> package = GeneratedColumn<int>(
      'package', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _relMeta = const VerificationMeta('rel');
  @override
  late final GeneratedColumn<int> rel = GeneratedColumn<int>(
      'rel', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, preOrderId, goodsId, vol, price, package, rel];
  @override
  String get aliasedName => _alias ?? 'pre_order_lines';
  @override
  String get actualTableName => 'pre_order_lines';
  @override
  VerificationContext validateIntegrity(Insertable<PreOrderLine> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pre_order_id')) {
      context.handle(
          _preOrderIdMeta,
          preOrderId.isAcceptableOrUnknown(
              data['pre_order_id']!, _preOrderIdMeta));
    } else if (isInserting) {
      context.missing(_preOrderIdMeta);
    }
    if (data.containsKey('goods_id')) {
      context.handle(_goodsIdMeta,
          goodsId.isAcceptableOrUnknown(data['goods_id']!, _goodsIdMeta));
    } else if (isInserting) {
      context.missing(_goodsIdMeta);
    }
    if (data.containsKey('vol')) {
      context.handle(
          _volMeta, vol.isAcceptableOrUnknown(data['vol']!, _volMeta));
    } else if (isInserting) {
      context.missing(_volMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('package')) {
      context.handle(_packageMeta,
          package.isAcceptableOrUnknown(data['package']!, _packageMeta));
    } else if (isInserting) {
      context.missing(_packageMeta);
    }
    if (data.containsKey('rel')) {
      context.handle(
          _relMeta, rel.isAcceptableOrUnknown(data['rel']!, _relMeta));
    } else if (isInserting) {
      context.missing(_relMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PreOrderLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreOrderLine(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      preOrderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pre_order_id'])!,
      goodsId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}goods_id'])!,
      vol: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}vol'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      package: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}package'])!,
      rel: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rel'])!,
    );
  }

  @override
  $PreOrderLinesTable createAlias(String alias) {
    return $PreOrderLinesTable(attachedDatabase, alias);
  }
}

class PreOrderLine extends DataClass implements Insertable<PreOrderLine> {
  final int id;
  final int preOrderId;
  final int goodsId;
  final double vol;
  final double price;
  final int package;
  final int rel;
  const PreOrderLine(
      {required this.id,
      required this.preOrderId,
      required this.goodsId,
      required this.vol,
      required this.price,
      required this.package,
      required this.rel});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pre_order_id'] = Variable<int>(preOrderId);
    map['goods_id'] = Variable<int>(goodsId);
    map['vol'] = Variable<double>(vol);
    map['price'] = Variable<double>(price);
    map['package'] = Variable<int>(package);
    map['rel'] = Variable<int>(rel);
    return map;
  }

  PreOrderLinesCompanion toCompanion(bool nullToAbsent) {
    return PreOrderLinesCompanion(
      id: Value(id),
      preOrderId: Value(preOrderId),
      goodsId: Value(goodsId),
      vol: Value(vol),
      price: Value(price),
      package: Value(package),
      rel: Value(rel),
    );
  }

  factory PreOrderLine.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreOrderLine(
      id: serializer.fromJson<int>(json['id']),
      preOrderId: serializer.fromJson<int>(json['preOrderId']),
      goodsId: serializer.fromJson<int>(json['goodsId']),
      vol: serializer.fromJson<double>(json['vol']),
      price: serializer.fromJson<double>(json['price']),
      package: serializer.fromJson<int>(json['package']),
      rel: serializer.fromJson<int>(json['rel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'preOrderId': serializer.toJson<int>(preOrderId),
      'goodsId': serializer.toJson<int>(goodsId),
      'vol': serializer.toJson<double>(vol),
      'price': serializer.toJson<double>(price),
      'package': serializer.toJson<int>(package),
      'rel': serializer.toJson<int>(rel),
    };
  }

  PreOrderLine copyWith(
          {int? id,
          int? preOrderId,
          int? goodsId,
          double? vol,
          double? price,
          int? package,
          int? rel}) =>
      PreOrderLine(
        id: id ?? this.id,
        preOrderId: preOrderId ?? this.preOrderId,
        goodsId: goodsId ?? this.goodsId,
        vol: vol ?? this.vol,
        price: price ?? this.price,
        package: package ?? this.package,
        rel: rel ?? this.rel,
      );
  @override
  String toString() {
    return (StringBuffer('PreOrderLine(')
          ..write('id: $id, ')
          ..write('preOrderId: $preOrderId, ')
          ..write('goodsId: $goodsId, ')
          ..write('vol: $vol, ')
          ..write('price: $price, ')
          ..write('package: $package, ')
          ..write('rel: $rel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, preOrderId, goodsId, vol, price, package, rel);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreOrderLine &&
          other.id == this.id &&
          other.preOrderId == this.preOrderId &&
          other.goodsId == this.goodsId &&
          other.vol == this.vol &&
          other.price == this.price &&
          other.package == this.package &&
          other.rel == this.rel);
}

class PreOrderLinesCompanion extends UpdateCompanion<PreOrderLine> {
  final Value<int> id;
  final Value<int> preOrderId;
  final Value<int> goodsId;
  final Value<double> vol;
  final Value<double> price;
  final Value<int> package;
  final Value<int> rel;
  const PreOrderLinesCompanion({
    this.id = const Value.absent(),
    this.preOrderId = const Value.absent(),
    this.goodsId = const Value.absent(),
    this.vol = const Value.absent(),
    this.price = const Value.absent(),
    this.package = const Value.absent(),
    this.rel = const Value.absent(),
  });
  PreOrderLinesCompanion.insert({
    this.id = const Value.absent(),
    required int preOrderId,
    required int goodsId,
    required double vol,
    required double price,
    required int package,
    required int rel,
  })  : preOrderId = Value(preOrderId),
        goodsId = Value(goodsId),
        vol = Value(vol),
        price = Value(price),
        package = Value(package),
        rel = Value(rel);
  static Insertable<PreOrderLine> custom({
    Expression<int>? id,
    Expression<int>? preOrderId,
    Expression<int>? goodsId,
    Expression<double>? vol,
    Expression<double>? price,
    Expression<int>? package,
    Expression<int>? rel,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (preOrderId != null) 'pre_order_id': preOrderId,
      if (goodsId != null) 'goods_id': goodsId,
      if (vol != null) 'vol': vol,
      if (price != null) 'price': price,
      if (package != null) 'package': package,
      if (rel != null) 'rel': rel,
    });
  }

  PreOrderLinesCompanion copyWith(
      {Value<int>? id,
      Value<int>? preOrderId,
      Value<int>? goodsId,
      Value<double>? vol,
      Value<double>? price,
      Value<int>? package,
      Value<int>? rel}) {
    return PreOrderLinesCompanion(
      id: id ?? this.id,
      preOrderId: preOrderId ?? this.preOrderId,
      goodsId: goodsId ?? this.goodsId,
      vol: vol ?? this.vol,
      price: price ?? this.price,
      package: package ?? this.package,
      rel: rel ?? this.rel,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (preOrderId.present) {
      map['pre_order_id'] = Variable<int>(preOrderId.value);
    }
    if (goodsId.present) {
      map['goods_id'] = Variable<int>(goodsId.value);
    }
    if (vol.present) {
      map['vol'] = Variable<double>(vol.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (package.present) {
      map['package'] = Variable<int>(package.value);
    }
    if (rel.present) {
      map['rel'] = Variable<int>(rel.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreOrderLinesCompanion(')
          ..write('id: $id, ')
          ..write('preOrderId: $preOrderId, ')
          ..write('goodsId: $goodsId, ')
          ..write('vol: $vol, ')
          ..write('price: $price, ')
          ..write('package: $package, ')
          ..write('rel: $rel')
          ..write(')'))
        .toString();
  }
}

class $SeenPreOrdersTable extends SeenPreOrders
    with TableInfo<$SeenPreOrdersTable, SeenPreOrder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SeenPreOrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  @override
  List<GeneratedColumn> get $columns => [id];
  @override
  String get aliasedName => _alias ?? 'seen_pre_orders';
  @override
  String get actualTableName => 'seen_pre_orders';
  @override
  VerificationContext validateIntegrity(Insertable<SeenPreOrder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SeenPreOrder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SeenPreOrder(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
    );
  }

  @override
  $SeenPreOrdersTable createAlias(String alias) {
    return $SeenPreOrdersTable(attachedDatabase, alias);
  }
}

class SeenPreOrder extends DataClass implements Insertable<SeenPreOrder> {
  final int id;
  const SeenPreOrder({required this.id});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    return map;
  }

  SeenPreOrdersCompanion toCompanion(bool nullToAbsent) {
    return SeenPreOrdersCompanion(
      id: Value(id),
    );
  }

  factory SeenPreOrder.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SeenPreOrder(
      id: serializer.fromJson<int>(json['id']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
    };
  }

  SeenPreOrder copyWith({int? id}) => SeenPreOrder(
        id: id ?? this.id,
      );
  @override
  String toString() {
    return (StringBuffer('SeenPreOrder(')
          ..write('id: $id')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => id.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is SeenPreOrder && other.id == this.id);
}

class SeenPreOrdersCompanion extends UpdateCompanion<SeenPreOrder> {
  final Value<int> id;
  const SeenPreOrdersCompanion({
    this.id = const Value.absent(),
  });
  SeenPreOrdersCompanion.insert({
    this.id = const Value.absent(),
  });
  static Insertable<SeenPreOrder> custom({
    Expression<int>? id,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
    });
  }

  SeenPreOrdersCompanion copyWith({Value<int>? id}) {
    return SeenPreOrdersCompanion(
      id: id ?? this.id,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SeenPreOrdersCompanion(')
          ..write('id: $id')
          ..write(')'))
        .toString();
  }
}

class $BonusProgramGroupsTable extends BonusProgramGroups
    with TableInfo<$BonusProgramGroupsTable, BonusProgramGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BonusProgramGroupsTable(this.attachedDatabase, [this._alias]);
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
  String get aliasedName => _alias ?? 'bonus_program_groups';
  @override
  String get actualTableName => 'bonus_program_groups';
  @override
  VerificationContext validateIntegrity(Insertable<BonusProgramGroup> instance,
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
  BonusProgramGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BonusProgramGroup(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $BonusProgramGroupsTable createAlias(String alias) {
    return $BonusProgramGroupsTable(attachedDatabase, alias);
  }
}

class BonusProgramGroup extends DataClass
    implements Insertable<BonusProgramGroup> {
  final int id;
  final String name;
  const BonusProgramGroup({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  BonusProgramGroupsCompanion toCompanion(bool nullToAbsent) {
    return BonusProgramGroupsCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory BonusProgramGroup.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BonusProgramGroup(
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

  BonusProgramGroup copyWith({int? id, String? name}) => BonusProgramGroup(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('BonusProgramGroup(')
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
      (other is BonusProgramGroup &&
          other.id == this.id &&
          other.name == this.name);
}

class BonusProgramGroupsCompanion extends UpdateCompanion<BonusProgramGroup> {
  final Value<int> id;
  final Value<String> name;
  const BonusProgramGroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  BonusProgramGroupsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<BonusProgramGroup> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  BonusProgramGroupsCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return BonusProgramGroupsCompanion(
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
    return (StringBuffer('BonusProgramGroupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $BonusProgramsTable extends BonusPrograms
    with TableInfo<$BonusProgramsTable, BonusProgram> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BonusProgramsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dateFromMeta =
      const VerificationMeta('dateFrom');
  @override
  late final GeneratedColumn<DateTime> dateFrom = GeneratedColumn<DateTime>(
      'date_from', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _dateToMeta = const VerificationMeta('dateTo');
  @override
  late final GeneratedColumn<DateTime> dateTo = GeneratedColumn<DateTime>(
      'date_to', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _conditionMeta =
      const VerificationMeta('condition');
  @override
  late final GeneratedColumn<String> condition = GeneratedColumn<String>(
      'condition', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _presentMeta =
      const VerificationMeta('present');
  @override
  late final GeneratedColumn<String> present = GeneratedColumn<String>(
      'present', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tagTextMeta =
      const VerificationMeta('tagText');
  @override
  late final GeneratedColumn<String> tagText = GeneratedColumn<String>(
      'tag_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _discountPercentMeta =
      const VerificationMeta('discountPercent');
  @override
  late final GeneratedColumn<int> discountPercent = GeneratedColumn<int>(
      'discount_percent', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _coefMeta = const VerificationMeta('coef');
  @override
  late final GeneratedColumn<double> coef = GeneratedColumn<double>(
      'coef', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _conditionalDiscountMeta =
      const VerificationMeta('conditionalDiscount');
  @override
  late final GeneratedColumn<int> conditionalDiscount = GeneratedColumn<int>(
      'conditional_discount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _bonusProgramGroupIdMeta =
      const VerificationMeta('bonusProgramGroupId');
  @override
  late final GeneratedColumn<int> bonusProgramGroupId = GeneratedColumn<int>(
      'bonus_program_group_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        dateFrom,
        dateTo,
        condition,
        present,
        tagText,
        discountPercent,
        coef,
        conditionalDiscount,
        bonusProgramGroupId
      ];
  @override
  String get aliasedName => _alias ?? 'bonus_programs';
  @override
  String get actualTableName => 'bonus_programs';
  @override
  VerificationContext validateIntegrity(Insertable<BonusProgram> instance,
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
    if (data.containsKey('date_from')) {
      context.handle(_dateFromMeta,
          dateFrom.isAcceptableOrUnknown(data['date_from']!, _dateFromMeta));
    } else if (isInserting) {
      context.missing(_dateFromMeta);
    }
    if (data.containsKey('date_to')) {
      context.handle(_dateToMeta,
          dateTo.isAcceptableOrUnknown(data['date_to']!, _dateToMeta));
    } else if (isInserting) {
      context.missing(_dateToMeta);
    }
    if (data.containsKey('condition')) {
      context.handle(_conditionMeta,
          condition.isAcceptableOrUnknown(data['condition']!, _conditionMeta));
    } else if (isInserting) {
      context.missing(_conditionMeta);
    }
    if (data.containsKey('present')) {
      context.handle(_presentMeta,
          present.isAcceptableOrUnknown(data['present']!, _presentMeta));
    } else if (isInserting) {
      context.missing(_presentMeta);
    }
    if (data.containsKey('tag_text')) {
      context.handle(_tagTextMeta,
          tagText.isAcceptableOrUnknown(data['tag_text']!, _tagTextMeta));
    } else if (isInserting) {
      context.missing(_tagTextMeta);
    }
    if (data.containsKey('discount_percent')) {
      context.handle(
          _discountPercentMeta,
          discountPercent.isAcceptableOrUnknown(
              data['discount_percent']!, _discountPercentMeta));
    }
    if (data.containsKey('coef')) {
      context.handle(
          _coefMeta, coef.isAcceptableOrUnknown(data['coef']!, _coefMeta));
    } else if (isInserting) {
      context.missing(_coefMeta);
    }
    if (data.containsKey('conditional_discount')) {
      context.handle(
          _conditionalDiscountMeta,
          conditionalDiscount.isAcceptableOrUnknown(
              data['conditional_discount']!, _conditionalDiscountMeta));
    } else if (isInserting) {
      context.missing(_conditionalDiscountMeta);
    }
    if (data.containsKey('bonus_program_group_id')) {
      context.handle(
          _bonusProgramGroupIdMeta,
          bonusProgramGroupId.isAcceptableOrUnknown(
              data['bonus_program_group_id']!, _bonusProgramGroupIdMeta));
    } else if (isInserting) {
      context.missing(_bonusProgramGroupIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BonusProgram map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BonusProgram(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      dateFrom: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_from'])!,
      dateTo: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_to'])!,
      condition: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}condition'])!,
      present: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}present'])!,
      tagText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tag_text'])!,
      discountPercent: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}discount_percent']),
      coef: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}coef'])!,
      conditionalDiscount: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}conditional_discount'])!,
      bonusProgramGroupId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}bonus_program_group_id'])!,
    );
  }

  @override
  $BonusProgramsTable createAlias(String alias) {
    return $BonusProgramsTable(attachedDatabase, alias);
  }
}

class BonusProgram extends DataClass implements Insertable<BonusProgram> {
  final int id;
  final String name;
  final DateTime dateFrom;
  final DateTime dateTo;
  final String condition;
  final String present;
  final String tagText;
  final int? discountPercent;
  final double coef;
  final int conditionalDiscount;
  final int bonusProgramGroupId;
  const BonusProgram(
      {required this.id,
      required this.name,
      required this.dateFrom,
      required this.dateTo,
      required this.condition,
      required this.present,
      required this.tagText,
      this.discountPercent,
      required this.coef,
      required this.conditionalDiscount,
      required this.bonusProgramGroupId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['date_from'] = Variable<DateTime>(dateFrom);
    map['date_to'] = Variable<DateTime>(dateTo);
    map['condition'] = Variable<String>(condition);
    map['present'] = Variable<String>(present);
    map['tag_text'] = Variable<String>(tagText);
    if (!nullToAbsent || discountPercent != null) {
      map['discount_percent'] = Variable<int>(discountPercent);
    }
    map['coef'] = Variable<double>(coef);
    map['conditional_discount'] = Variable<int>(conditionalDiscount);
    map['bonus_program_group_id'] = Variable<int>(bonusProgramGroupId);
    return map;
  }

  BonusProgramsCompanion toCompanion(bool nullToAbsent) {
    return BonusProgramsCompanion(
      id: Value(id),
      name: Value(name),
      dateFrom: Value(dateFrom),
      dateTo: Value(dateTo),
      condition: Value(condition),
      present: Value(present),
      tagText: Value(tagText),
      discountPercent: discountPercent == null && nullToAbsent
          ? const Value.absent()
          : Value(discountPercent),
      coef: Value(coef),
      conditionalDiscount: Value(conditionalDiscount),
      bonusProgramGroupId: Value(bonusProgramGroupId),
    );
  }

  factory BonusProgram.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BonusProgram(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      dateFrom: serializer.fromJson<DateTime>(json['dateFrom']),
      dateTo: serializer.fromJson<DateTime>(json['dateTo']),
      condition: serializer.fromJson<String>(json['condition']),
      present: serializer.fromJson<String>(json['present']),
      tagText: serializer.fromJson<String>(json['tagText']),
      discountPercent: serializer.fromJson<int?>(json['discountPercent']),
      coef: serializer.fromJson<double>(json['coef']),
      conditionalDiscount:
          serializer.fromJson<int>(json['conditionalDiscount']),
      bonusProgramGroupId:
          serializer.fromJson<int>(json['bonusProgramGroupId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'dateFrom': serializer.toJson<DateTime>(dateFrom),
      'dateTo': serializer.toJson<DateTime>(dateTo),
      'condition': serializer.toJson<String>(condition),
      'present': serializer.toJson<String>(present),
      'tagText': serializer.toJson<String>(tagText),
      'discountPercent': serializer.toJson<int?>(discountPercent),
      'coef': serializer.toJson<double>(coef),
      'conditionalDiscount': serializer.toJson<int>(conditionalDiscount),
      'bonusProgramGroupId': serializer.toJson<int>(bonusProgramGroupId),
    };
  }

  BonusProgram copyWith(
          {int? id,
          String? name,
          DateTime? dateFrom,
          DateTime? dateTo,
          String? condition,
          String? present,
          String? tagText,
          Value<int?> discountPercent = const Value.absent(),
          double? coef,
          int? conditionalDiscount,
          int? bonusProgramGroupId}) =>
      BonusProgram(
        id: id ?? this.id,
        name: name ?? this.name,
        dateFrom: dateFrom ?? this.dateFrom,
        dateTo: dateTo ?? this.dateTo,
        condition: condition ?? this.condition,
        present: present ?? this.present,
        tagText: tagText ?? this.tagText,
        discountPercent: discountPercent.present
            ? discountPercent.value
            : this.discountPercent,
        coef: coef ?? this.coef,
        conditionalDiscount: conditionalDiscount ?? this.conditionalDiscount,
        bonusProgramGroupId: bonusProgramGroupId ?? this.bonusProgramGroupId,
      );
  @override
  String toString() {
    return (StringBuffer('BonusProgram(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dateFrom: $dateFrom, ')
          ..write('dateTo: $dateTo, ')
          ..write('condition: $condition, ')
          ..write('present: $present, ')
          ..write('tagText: $tagText, ')
          ..write('discountPercent: $discountPercent, ')
          ..write('coef: $coef, ')
          ..write('conditionalDiscount: $conditionalDiscount, ')
          ..write('bonusProgramGroupId: $bonusProgramGroupId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      dateFrom,
      dateTo,
      condition,
      present,
      tagText,
      discountPercent,
      coef,
      conditionalDiscount,
      bonusProgramGroupId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BonusProgram &&
          other.id == this.id &&
          other.name == this.name &&
          other.dateFrom == this.dateFrom &&
          other.dateTo == this.dateTo &&
          other.condition == this.condition &&
          other.present == this.present &&
          other.tagText == this.tagText &&
          other.discountPercent == this.discountPercent &&
          other.coef == this.coef &&
          other.conditionalDiscount == this.conditionalDiscount &&
          other.bonusProgramGroupId == this.bonusProgramGroupId);
}

class BonusProgramsCompanion extends UpdateCompanion<BonusProgram> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> dateFrom;
  final Value<DateTime> dateTo;
  final Value<String> condition;
  final Value<String> present;
  final Value<String> tagText;
  final Value<int?> discountPercent;
  final Value<double> coef;
  final Value<int> conditionalDiscount;
  final Value<int> bonusProgramGroupId;
  const BonusProgramsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.dateFrom = const Value.absent(),
    this.dateTo = const Value.absent(),
    this.condition = const Value.absent(),
    this.present = const Value.absent(),
    this.tagText = const Value.absent(),
    this.discountPercent = const Value.absent(),
    this.coef = const Value.absent(),
    this.conditionalDiscount = const Value.absent(),
    this.bonusProgramGroupId = const Value.absent(),
  });
  BonusProgramsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DateTime dateFrom,
    required DateTime dateTo,
    required String condition,
    required String present,
    required String tagText,
    this.discountPercent = const Value.absent(),
    required double coef,
    required int conditionalDiscount,
    required int bonusProgramGroupId,
  })  : name = Value(name),
        dateFrom = Value(dateFrom),
        dateTo = Value(dateTo),
        condition = Value(condition),
        present = Value(present),
        tagText = Value(tagText),
        coef = Value(coef),
        conditionalDiscount = Value(conditionalDiscount),
        bonusProgramGroupId = Value(bonusProgramGroupId);
  static Insertable<BonusProgram> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? dateFrom,
    Expression<DateTime>? dateTo,
    Expression<String>? condition,
    Expression<String>? present,
    Expression<String>? tagText,
    Expression<int>? discountPercent,
    Expression<double>? coef,
    Expression<int>? conditionalDiscount,
    Expression<int>? bonusProgramGroupId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (dateFrom != null) 'date_from': dateFrom,
      if (dateTo != null) 'date_to': dateTo,
      if (condition != null) 'condition': condition,
      if (present != null) 'present': present,
      if (tagText != null) 'tag_text': tagText,
      if (discountPercent != null) 'discount_percent': discountPercent,
      if (coef != null) 'coef': coef,
      if (conditionalDiscount != null)
        'conditional_discount': conditionalDiscount,
      if (bonusProgramGroupId != null)
        'bonus_program_group_id': bonusProgramGroupId,
    });
  }

  BonusProgramsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<DateTime>? dateFrom,
      Value<DateTime>? dateTo,
      Value<String>? condition,
      Value<String>? present,
      Value<String>? tagText,
      Value<int?>? discountPercent,
      Value<double>? coef,
      Value<int>? conditionalDiscount,
      Value<int>? bonusProgramGroupId}) {
    return BonusProgramsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      condition: condition ?? this.condition,
      present: present ?? this.present,
      tagText: tagText ?? this.tagText,
      discountPercent: discountPercent ?? this.discountPercent,
      coef: coef ?? this.coef,
      conditionalDiscount: conditionalDiscount ?? this.conditionalDiscount,
      bonusProgramGroupId: bonusProgramGroupId ?? this.bonusProgramGroupId,
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
    if (dateFrom.present) {
      map['date_from'] = Variable<DateTime>(dateFrom.value);
    }
    if (dateTo.present) {
      map['date_to'] = Variable<DateTime>(dateTo.value);
    }
    if (condition.present) {
      map['condition'] = Variable<String>(condition.value);
    }
    if (present.present) {
      map['present'] = Variable<String>(present.value);
    }
    if (tagText.present) {
      map['tag_text'] = Variable<String>(tagText.value);
    }
    if (discountPercent.present) {
      map['discount_percent'] = Variable<int>(discountPercent.value);
    }
    if (coef.present) {
      map['coef'] = Variable<double>(coef.value);
    }
    if (conditionalDiscount.present) {
      map['conditional_discount'] = Variable<int>(conditionalDiscount.value);
    }
    if (bonusProgramGroupId.present) {
      map['bonus_program_group_id'] = Variable<int>(bonusProgramGroupId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BonusProgramsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dateFrom: $dateFrom, ')
          ..write('dateTo: $dateTo, ')
          ..write('condition: $condition, ')
          ..write('present: $present, ')
          ..write('tagText: $tagText, ')
          ..write('discountPercent: $discountPercent, ')
          ..write('coef: $coef, ')
          ..write('conditionalDiscount: $conditionalDiscount, ')
          ..write('bonusProgramGroupId: $bonusProgramGroupId')
          ..write(')'))
        .toString();
  }
}

class $BuyersSetsTable extends BuyersSets
    with TableInfo<$BuyersSetsTable, BuyersSet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BuyersSetsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _isForAllMeta =
      const VerificationMeta('isForAll');
  @override
  late final GeneratedColumn<bool> isForAll =
      GeneratedColumn<bool>('is_for_all', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_for_all" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  @override
  List<GeneratedColumn> get $columns => [id, name, isForAll];
  @override
  String get aliasedName => _alias ?? 'buyers_sets';
  @override
  String get actualTableName => 'buyers_sets';
  @override
  VerificationContext validateIntegrity(Insertable<BuyersSet> instance,
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
    if (data.containsKey('is_for_all')) {
      context.handle(_isForAllMeta,
          isForAll.isAcceptableOrUnknown(data['is_for_all']!, _isForAllMeta));
    } else if (isInserting) {
      context.missing(_isForAllMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BuyersSet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BuyersSet(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      isForAll: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_for_all'])!,
    );
  }

  @override
  $BuyersSetsTable createAlias(String alias) {
    return $BuyersSetsTable(attachedDatabase, alias);
  }
}

class BuyersSet extends DataClass implements Insertable<BuyersSet> {
  final int id;
  final String name;
  final bool isForAll;
  const BuyersSet(
      {required this.id, required this.name, required this.isForAll});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['is_for_all'] = Variable<bool>(isForAll);
    return map;
  }

  BuyersSetsCompanion toCompanion(bool nullToAbsent) {
    return BuyersSetsCompanion(
      id: Value(id),
      name: Value(name),
      isForAll: Value(isForAll),
    );
  }

  factory BuyersSet.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BuyersSet(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isForAll: serializer.fromJson<bool>(json['isForAll']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isForAll': serializer.toJson<bool>(isForAll),
    };
  }

  BuyersSet copyWith({int? id, String? name, bool? isForAll}) => BuyersSet(
        id: id ?? this.id,
        name: name ?? this.name,
        isForAll: isForAll ?? this.isForAll,
      );
  @override
  String toString() {
    return (StringBuffer('BuyersSet(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isForAll: $isForAll')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, isForAll);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BuyersSet &&
          other.id == this.id &&
          other.name == this.name &&
          other.isForAll == this.isForAll);
}

class BuyersSetsCompanion extends UpdateCompanion<BuyersSet> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> isForAll;
  const BuyersSetsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isForAll = const Value.absent(),
  });
  BuyersSetsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required bool isForAll,
  })  : name = Value(name),
        isForAll = Value(isForAll);
  static Insertable<BuyersSet> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? isForAll,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isForAll != null) 'is_for_all': isForAll,
    });
  }

  BuyersSetsCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<bool>? isForAll}) {
    return BuyersSetsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isForAll: isForAll ?? this.isForAll,
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
    if (isForAll.present) {
      map['is_for_all'] = Variable<bool>(isForAll.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BuyersSetsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isForAll: $isForAll')
          ..write(')'))
        .toString();
  }
}

class $BuyersSetsBonusProgramsTable extends BuyersSetsBonusPrograms
    with TableInfo<$BuyersSetsBonusProgramsTable, BuyersSetsBonusProgram> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BuyersSetsBonusProgramsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _buyersSetIdMeta =
      const VerificationMeta('buyersSetId');
  @override
  late final GeneratedColumn<int> buyersSetId = GeneratedColumn<int>(
      'buyers_set_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _bonusProgramIdMeta =
      const VerificationMeta('bonusProgramId');
  @override
  late final GeneratedColumn<int> bonusProgramId = GeneratedColumn<int>(
      'bonus_program_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [buyersSetId, bonusProgramId];
  @override
  String get aliasedName => _alias ?? 'buyers_sets_bonus_programs';
  @override
  String get actualTableName => 'buyers_sets_bonus_programs';
  @override
  VerificationContext validateIntegrity(
      Insertable<BuyersSetsBonusProgram> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('buyers_set_id')) {
      context.handle(
          _buyersSetIdMeta,
          buyersSetId.isAcceptableOrUnknown(
              data['buyers_set_id']!, _buyersSetIdMeta));
    } else if (isInserting) {
      context.missing(_buyersSetIdMeta);
    }
    if (data.containsKey('bonus_program_id')) {
      context.handle(
          _bonusProgramIdMeta,
          bonusProgramId.isAcceptableOrUnknown(
              data['bonus_program_id']!, _bonusProgramIdMeta));
    } else if (isInserting) {
      context.missing(_bonusProgramIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {buyersSetId, bonusProgramId};
  @override
  BuyersSetsBonusProgram map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BuyersSetsBonusProgram(
      buyersSetId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}buyers_set_id'])!,
      bonusProgramId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bonus_program_id'])!,
    );
  }

  @override
  $BuyersSetsBonusProgramsTable createAlias(String alias) {
    return $BuyersSetsBonusProgramsTable(attachedDatabase, alias);
  }
}

class BuyersSetsBonusProgram extends DataClass
    implements Insertable<BuyersSetsBonusProgram> {
  final int buyersSetId;
  final int bonusProgramId;
  const BuyersSetsBonusProgram(
      {required this.buyersSetId, required this.bonusProgramId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['buyers_set_id'] = Variable<int>(buyersSetId);
    map['bonus_program_id'] = Variable<int>(bonusProgramId);
    return map;
  }

  BuyersSetsBonusProgramsCompanion toCompanion(bool nullToAbsent) {
    return BuyersSetsBonusProgramsCompanion(
      buyersSetId: Value(buyersSetId),
      bonusProgramId: Value(bonusProgramId),
    );
  }

  factory BuyersSetsBonusProgram.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BuyersSetsBonusProgram(
      buyersSetId: serializer.fromJson<int>(json['buyersSetId']),
      bonusProgramId: serializer.fromJson<int>(json['bonusProgramId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'buyersSetId': serializer.toJson<int>(buyersSetId),
      'bonusProgramId': serializer.toJson<int>(bonusProgramId),
    };
  }

  BuyersSetsBonusProgram copyWith({int? buyersSetId, int? bonusProgramId}) =>
      BuyersSetsBonusProgram(
        buyersSetId: buyersSetId ?? this.buyersSetId,
        bonusProgramId: bonusProgramId ?? this.bonusProgramId,
      );
  @override
  String toString() {
    return (StringBuffer('BuyersSetsBonusProgram(')
          ..write('buyersSetId: $buyersSetId, ')
          ..write('bonusProgramId: $bonusProgramId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(buyersSetId, bonusProgramId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BuyersSetsBonusProgram &&
          other.buyersSetId == this.buyersSetId &&
          other.bonusProgramId == this.bonusProgramId);
}

class BuyersSetsBonusProgramsCompanion
    extends UpdateCompanion<BuyersSetsBonusProgram> {
  final Value<int> buyersSetId;
  final Value<int> bonusProgramId;
  final Value<int> rowid;
  const BuyersSetsBonusProgramsCompanion({
    this.buyersSetId = const Value.absent(),
    this.bonusProgramId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BuyersSetsBonusProgramsCompanion.insert({
    required int buyersSetId,
    required int bonusProgramId,
    this.rowid = const Value.absent(),
  })  : buyersSetId = Value(buyersSetId),
        bonusProgramId = Value(bonusProgramId);
  static Insertable<BuyersSetsBonusProgram> custom({
    Expression<int>? buyersSetId,
    Expression<int>? bonusProgramId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (buyersSetId != null) 'buyers_set_id': buyersSetId,
      if (bonusProgramId != null) 'bonus_program_id': bonusProgramId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BuyersSetsBonusProgramsCompanion copyWith(
      {Value<int>? buyersSetId,
      Value<int>? bonusProgramId,
      Value<int>? rowid}) {
    return BuyersSetsBonusProgramsCompanion(
      buyersSetId: buyersSetId ?? this.buyersSetId,
      bonusProgramId: bonusProgramId ?? this.bonusProgramId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (buyersSetId.present) {
      map['buyers_set_id'] = Variable<int>(buyersSetId.value);
    }
    if (bonusProgramId.present) {
      map['bonus_program_id'] = Variable<int>(bonusProgramId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BuyersSetsBonusProgramsCompanion(')
          ..write('buyersSetId: $buyersSetId, ')
          ..write('bonusProgramId: $bonusProgramId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BuyersSetsBuyersTable extends BuyersSetsBuyers
    with TableInfo<$BuyersSetsBuyersTable, BuyersSetsBuyer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BuyersSetsBuyersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _buyersSetIdMeta =
      const VerificationMeta('buyersSetId');
  @override
  late final GeneratedColumn<int> buyersSetId = GeneratedColumn<int>(
      'buyers_set_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _buyerIdMeta =
      const VerificationMeta('buyerId');
  @override
  late final GeneratedColumn<int> buyerId = GeneratedColumn<int>(
      'buyer_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [buyersSetId, buyerId];
  @override
  String get aliasedName => _alias ?? 'buyers_sets_buyers';
  @override
  String get actualTableName => 'buyers_sets_buyers';
  @override
  VerificationContext validateIntegrity(Insertable<BuyersSetsBuyer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('buyers_set_id')) {
      context.handle(
          _buyersSetIdMeta,
          buyersSetId.isAcceptableOrUnknown(
              data['buyers_set_id']!, _buyersSetIdMeta));
    } else if (isInserting) {
      context.missing(_buyersSetIdMeta);
    }
    if (data.containsKey('buyer_id')) {
      context.handle(_buyerIdMeta,
          buyerId.isAcceptableOrUnknown(data['buyer_id']!, _buyerIdMeta));
    } else if (isInserting) {
      context.missing(_buyerIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {buyersSetId, buyerId};
  @override
  BuyersSetsBuyer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BuyersSetsBuyer(
      buyersSetId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}buyers_set_id'])!,
      buyerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}buyer_id'])!,
    );
  }

  @override
  $BuyersSetsBuyersTable createAlias(String alias) {
    return $BuyersSetsBuyersTable(attachedDatabase, alias);
  }
}

class BuyersSetsBuyer extends DataClass implements Insertable<BuyersSetsBuyer> {
  final int buyersSetId;
  final int buyerId;
  const BuyersSetsBuyer({required this.buyersSetId, required this.buyerId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['buyers_set_id'] = Variable<int>(buyersSetId);
    map['buyer_id'] = Variable<int>(buyerId);
    return map;
  }

  BuyersSetsBuyersCompanion toCompanion(bool nullToAbsent) {
    return BuyersSetsBuyersCompanion(
      buyersSetId: Value(buyersSetId),
      buyerId: Value(buyerId),
    );
  }

  factory BuyersSetsBuyer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BuyersSetsBuyer(
      buyersSetId: serializer.fromJson<int>(json['buyersSetId']),
      buyerId: serializer.fromJson<int>(json['buyerId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'buyersSetId': serializer.toJson<int>(buyersSetId),
      'buyerId': serializer.toJson<int>(buyerId),
    };
  }

  BuyersSetsBuyer copyWith({int? buyersSetId, int? buyerId}) => BuyersSetsBuyer(
        buyersSetId: buyersSetId ?? this.buyersSetId,
        buyerId: buyerId ?? this.buyerId,
      );
  @override
  String toString() {
    return (StringBuffer('BuyersSetsBuyer(')
          ..write('buyersSetId: $buyersSetId, ')
          ..write('buyerId: $buyerId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(buyersSetId, buyerId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BuyersSetsBuyer &&
          other.buyersSetId == this.buyersSetId &&
          other.buyerId == this.buyerId);
}

class BuyersSetsBuyersCompanion extends UpdateCompanion<BuyersSetsBuyer> {
  final Value<int> buyersSetId;
  final Value<int> buyerId;
  final Value<int> rowid;
  const BuyersSetsBuyersCompanion({
    this.buyersSetId = const Value.absent(),
    this.buyerId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BuyersSetsBuyersCompanion.insert({
    required int buyersSetId,
    required int buyerId,
    this.rowid = const Value.absent(),
  })  : buyersSetId = Value(buyersSetId),
        buyerId = Value(buyerId);
  static Insertable<BuyersSetsBuyer> custom({
    Expression<int>? buyersSetId,
    Expression<int>? buyerId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (buyersSetId != null) 'buyers_set_id': buyersSetId,
      if (buyerId != null) 'buyer_id': buyerId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BuyersSetsBuyersCompanion copyWith(
      {Value<int>? buyersSetId, Value<int>? buyerId, Value<int>? rowid}) {
    return BuyersSetsBuyersCompanion(
      buyersSetId: buyersSetId ?? this.buyersSetId,
      buyerId: buyerId ?? this.buyerId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (buyersSetId.present) {
      map['buyers_set_id'] = Variable<int>(buyersSetId.value);
    }
    if (buyerId.present) {
      map['buyer_id'] = Variable<int>(buyerId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BuyersSetsBuyersCompanion(')
          ..write('buyersSetId: $buyersSetId, ')
          ..write('buyerId: $buyerId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoodsBonusProgramsTable extends GoodsBonusPrograms
    with TableInfo<$GoodsBonusProgramsTable, GoodsBonusProgram> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoodsBonusProgramsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _bonusProgramIdMeta =
      const VerificationMeta('bonusProgramId');
  @override
  late final GeneratedColumn<int> bonusProgramId = GeneratedColumn<int>(
      'bonus_program_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _goodsIdMeta =
      const VerificationMeta('goodsId');
  @override
  late final GeneratedColumn<int> goodsId = GeneratedColumn<int>(
      'goods_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [bonusProgramId, goodsId];
  @override
  String get aliasedName => _alias ?? 'goods_bonus_programs';
  @override
  String get actualTableName => 'goods_bonus_programs';
  @override
  VerificationContext validateIntegrity(Insertable<GoodsBonusProgram> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('bonus_program_id')) {
      context.handle(
          _bonusProgramIdMeta,
          bonusProgramId.isAcceptableOrUnknown(
              data['bonus_program_id']!, _bonusProgramIdMeta));
    } else if (isInserting) {
      context.missing(_bonusProgramIdMeta);
    }
    if (data.containsKey('goods_id')) {
      context.handle(_goodsIdMeta,
          goodsId.isAcceptableOrUnknown(data['goods_id']!, _goodsIdMeta));
    } else if (isInserting) {
      context.missing(_goodsIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {bonusProgramId, goodsId};
  @override
  GoodsBonusProgram map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoodsBonusProgram(
      bonusProgramId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bonus_program_id'])!,
      goodsId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}goods_id'])!,
    );
  }

  @override
  $GoodsBonusProgramsTable createAlias(String alias) {
    return $GoodsBonusProgramsTable(attachedDatabase, alias);
  }
}

class GoodsBonusProgram extends DataClass
    implements Insertable<GoodsBonusProgram> {
  final int bonusProgramId;
  final int goodsId;
  const GoodsBonusProgram(
      {required this.bonusProgramId, required this.goodsId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['bonus_program_id'] = Variable<int>(bonusProgramId);
    map['goods_id'] = Variable<int>(goodsId);
    return map;
  }

  GoodsBonusProgramsCompanion toCompanion(bool nullToAbsent) {
    return GoodsBonusProgramsCompanion(
      bonusProgramId: Value(bonusProgramId),
      goodsId: Value(goodsId),
    );
  }

  factory GoodsBonusProgram.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoodsBonusProgram(
      bonusProgramId: serializer.fromJson<int>(json['bonusProgramId']),
      goodsId: serializer.fromJson<int>(json['goodsId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'bonusProgramId': serializer.toJson<int>(bonusProgramId),
      'goodsId': serializer.toJson<int>(goodsId),
    };
  }

  GoodsBonusProgram copyWith({int? bonusProgramId, int? goodsId}) =>
      GoodsBonusProgram(
        bonusProgramId: bonusProgramId ?? this.bonusProgramId,
        goodsId: goodsId ?? this.goodsId,
      );
  @override
  String toString() {
    return (StringBuffer('GoodsBonusProgram(')
          ..write('bonusProgramId: $bonusProgramId, ')
          ..write('goodsId: $goodsId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(bonusProgramId, goodsId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoodsBonusProgram &&
          other.bonusProgramId == this.bonusProgramId &&
          other.goodsId == this.goodsId);
}

class GoodsBonusProgramsCompanion extends UpdateCompanion<GoodsBonusProgram> {
  final Value<int> bonusProgramId;
  final Value<int> goodsId;
  final Value<int> rowid;
  const GoodsBonusProgramsCompanion({
    this.bonusProgramId = const Value.absent(),
    this.goodsId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoodsBonusProgramsCompanion.insert({
    required int bonusProgramId,
    required int goodsId,
    this.rowid = const Value.absent(),
  })  : bonusProgramId = Value(bonusProgramId),
        goodsId = Value(goodsId);
  static Insertable<GoodsBonusProgram> custom({
    Expression<int>? bonusProgramId,
    Expression<int>? goodsId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (bonusProgramId != null) 'bonus_program_id': bonusProgramId,
      if (goodsId != null) 'goods_id': goodsId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoodsBonusProgramsCompanion copyWith(
      {Value<int>? bonusProgramId, Value<int>? goodsId, Value<int>? rowid}) {
    return GoodsBonusProgramsCompanion(
      bonusProgramId: bonusProgramId ?? this.bonusProgramId,
      goodsId: goodsId ?? this.goodsId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (bonusProgramId.present) {
      map['bonus_program_id'] = Variable<int>(bonusProgramId.value);
    }
    if (goodsId.present) {
      map['goods_id'] = Variable<int>(goodsId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoodsBonusProgramsCompanion(')
          ..write('bonusProgramId: $bonusProgramId, ')
          ..write('goodsId: $goodsId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoodsBonusProgramPricesTable extends GoodsBonusProgramPrices
    with TableInfo<$GoodsBonusProgramPricesTable, GoodsBonusProgramPrice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoodsBonusProgramPricesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _bonusProgramIdMeta =
      const VerificationMeta('bonusProgramId');
  @override
  late final GeneratedColumn<int> bonusProgramId = GeneratedColumn<int>(
      'bonus_program_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _goodsIdMeta =
      const VerificationMeta('goodsId');
  @override
  late final GeneratedColumn<int> goodsId = GeneratedColumn<int>(
      'goods_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [bonusProgramId, goodsId, price];
  @override
  String get aliasedName => _alias ?? 'goods_bonus_program_prices';
  @override
  String get actualTableName => 'goods_bonus_program_prices';
  @override
  VerificationContext validateIntegrity(
      Insertable<GoodsBonusProgramPrice> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('bonus_program_id')) {
      context.handle(
          _bonusProgramIdMeta,
          bonusProgramId.isAcceptableOrUnknown(
              data['bonus_program_id']!, _bonusProgramIdMeta));
    } else if (isInserting) {
      context.missing(_bonusProgramIdMeta);
    }
    if (data.containsKey('goods_id')) {
      context.handle(_goodsIdMeta,
          goodsId.isAcceptableOrUnknown(data['goods_id']!, _goodsIdMeta));
    } else if (isInserting) {
      context.missing(_goodsIdMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {bonusProgramId, goodsId};
  @override
  GoodsBonusProgramPrice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoodsBonusProgramPrice(
      bonusProgramId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bonus_program_id'])!,
      goodsId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}goods_id'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
    );
  }

  @override
  $GoodsBonusProgramPricesTable createAlias(String alias) {
    return $GoodsBonusProgramPricesTable(attachedDatabase, alias);
  }
}

class GoodsBonusProgramPrice extends DataClass
    implements Insertable<GoodsBonusProgramPrice> {
  final int bonusProgramId;
  final int goodsId;
  final double price;
  const GoodsBonusProgramPrice(
      {required this.bonusProgramId,
      required this.goodsId,
      required this.price});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['bonus_program_id'] = Variable<int>(bonusProgramId);
    map['goods_id'] = Variable<int>(goodsId);
    map['price'] = Variable<double>(price);
    return map;
  }

  GoodsBonusProgramPricesCompanion toCompanion(bool nullToAbsent) {
    return GoodsBonusProgramPricesCompanion(
      bonusProgramId: Value(bonusProgramId),
      goodsId: Value(goodsId),
      price: Value(price),
    );
  }

  factory GoodsBonusProgramPrice.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoodsBonusProgramPrice(
      bonusProgramId: serializer.fromJson<int>(json['bonusProgramId']),
      goodsId: serializer.fromJson<int>(json['goodsId']),
      price: serializer.fromJson<double>(json['price']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'bonusProgramId': serializer.toJson<int>(bonusProgramId),
      'goodsId': serializer.toJson<int>(goodsId),
      'price': serializer.toJson<double>(price),
    };
  }

  GoodsBonusProgramPrice copyWith(
          {int? bonusProgramId, int? goodsId, double? price}) =>
      GoodsBonusProgramPrice(
        bonusProgramId: bonusProgramId ?? this.bonusProgramId,
        goodsId: goodsId ?? this.goodsId,
        price: price ?? this.price,
      );
  @override
  String toString() {
    return (StringBuffer('GoodsBonusProgramPrice(')
          ..write('bonusProgramId: $bonusProgramId, ')
          ..write('goodsId: $goodsId, ')
          ..write('price: $price')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(bonusProgramId, goodsId, price);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoodsBonusProgramPrice &&
          other.bonusProgramId == this.bonusProgramId &&
          other.goodsId == this.goodsId &&
          other.price == this.price);
}

class GoodsBonusProgramPricesCompanion
    extends UpdateCompanion<GoodsBonusProgramPrice> {
  final Value<int> bonusProgramId;
  final Value<int> goodsId;
  final Value<double> price;
  final Value<int> rowid;
  const GoodsBonusProgramPricesCompanion({
    this.bonusProgramId = const Value.absent(),
    this.goodsId = const Value.absent(),
    this.price = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoodsBonusProgramPricesCompanion.insert({
    required int bonusProgramId,
    required int goodsId,
    required double price,
    this.rowid = const Value.absent(),
  })  : bonusProgramId = Value(bonusProgramId),
        goodsId = Value(goodsId),
        price = Value(price);
  static Insertable<GoodsBonusProgramPrice> custom({
    Expression<int>? bonusProgramId,
    Expression<int>? goodsId,
    Expression<double>? price,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (bonusProgramId != null) 'bonus_program_id': bonusProgramId,
      if (goodsId != null) 'goods_id': goodsId,
      if (price != null) 'price': price,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoodsBonusProgramPricesCompanion copyWith(
      {Value<int>? bonusProgramId,
      Value<int>? goodsId,
      Value<double>? price,
      Value<int>? rowid}) {
    return GoodsBonusProgramPricesCompanion(
      bonusProgramId: bonusProgramId ?? this.bonusProgramId,
      goodsId: goodsId ?? this.goodsId,
      price: price ?? this.price,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (bonusProgramId.present) {
      map['bonus_program_id'] = Variable<int>(bonusProgramId.value);
    }
    if (goodsId.present) {
      map['goods_id'] = Variable<int>(goodsId.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoodsBonusProgramPricesCompanion(')
          ..write('bonusProgramId: $bonusProgramId, ')
          ..write('goodsId: $goodsId, ')
          ..write('price: $price, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PricelistsTable extends Pricelists
    with TableInfo<$PricelistsTable, Pricelist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PricelistsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _permitMeta = const VerificationMeta('permit');
  @override
  late final GeneratedColumn<bool> permit =
      GeneratedColumn<bool>('permit', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("permit" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  @override
  List<GeneratedColumn> get $columns => [id, name, permit];
  @override
  String get aliasedName => _alias ?? 'pricelists';
  @override
  String get actualTableName => 'pricelists';
  @override
  VerificationContext validateIntegrity(Insertable<Pricelist> instance,
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
    if (data.containsKey('permit')) {
      context.handle(_permitMeta,
          permit.isAcceptableOrUnknown(data['permit']!, _permitMeta));
    } else if (isInserting) {
      context.missing(_permitMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Pricelist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Pricelist(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      permit: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}permit'])!,
    );
  }

  @override
  $PricelistsTable createAlias(String alias) {
    return $PricelistsTable(attachedDatabase, alias);
  }
}

class Pricelist extends DataClass implements Insertable<Pricelist> {
  final int id;
  final String name;
  final bool permit;
  const Pricelist({required this.id, required this.name, required this.permit});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['permit'] = Variable<bool>(permit);
    return map;
  }

  PricelistsCompanion toCompanion(bool nullToAbsent) {
    return PricelistsCompanion(
      id: Value(id),
      name: Value(name),
      permit: Value(permit),
    );
  }

  factory Pricelist.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Pricelist(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      permit: serializer.fromJson<bool>(json['permit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'permit': serializer.toJson<bool>(permit),
    };
  }

  Pricelist copyWith({int? id, String? name, bool? permit}) => Pricelist(
        id: id ?? this.id,
        name: name ?? this.name,
        permit: permit ?? this.permit,
      );
  @override
  String toString() {
    return (StringBuffer('Pricelist(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('permit: $permit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, permit);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pricelist &&
          other.id == this.id &&
          other.name == this.name &&
          other.permit == this.permit);
}

class PricelistsCompanion extends UpdateCompanion<Pricelist> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> permit;
  const PricelistsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.permit = const Value.absent(),
  });
  PricelistsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required bool permit,
  })  : name = Value(name),
        permit = Value(permit);
  static Insertable<Pricelist> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? permit,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (permit != null) 'permit': permit,
    });
  }

  PricelistsCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<bool>? permit}) {
    return PricelistsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      permit: permit ?? this.permit,
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
    if (permit.present) {
      map['permit'] = Variable<bool>(permit.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PricelistsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('permit: $permit')
          ..write(')'))
        .toString();
  }
}

class $PricelistSetCategoriesTable extends PricelistSetCategories
    with TableInfo<$PricelistSetCategoriesTable, PricelistSetCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PricelistSetCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _pricelistSetIdMeta =
      const VerificationMeta('pricelistSetId');
  @override
  late final GeneratedColumn<int> pricelistSetId = GeneratedColumn<int>(
      'pricelist_set_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [pricelistSetId, categoryId];
  @override
  String get aliasedName => _alias ?? 'pricelist_set_categories';
  @override
  String get actualTableName => 'pricelist_set_categories';
  @override
  VerificationContext validateIntegrity(
      Insertable<PricelistSetCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pricelist_set_id')) {
      context.handle(
          _pricelistSetIdMeta,
          pricelistSetId.isAcceptableOrUnknown(
              data['pricelist_set_id']!, _pricelistSetIdMeta));
    } else if (isInserting) {
      context.missing(_pricelistSetIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {pricelistSetId, categoryId};
  @override
  PricelistSetCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PricelistSetCategory(
      pricelistSetId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pricelist_set_id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
    );
  }

  @override
  $PricelistSetCategoriesTable createAlias(String alias) {
    return $PricelistSetCategoriesTable(attachedDatabase, alias);
  }
}

class PricelistSetCategory extends DataClass
    implements Insertable<PricelistSetCategory> {
  final int pricelistSetId;
  final int categoryId;
  const PricelistSetCategory(
      {required this.pricelistSetId, required this.categoryId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pricelist_set_id'] = Variable<int>(pricelistSetId);
    map['category_id'] = Variable<int>(categoryId);
    return map;
  }

  PricelistSetCategoriesCompanion toCompanion(bool nullToAbsent) {
    return PricelistSetCategoriesCompanion(
      pricelistSetId: Value(pricelistSetId),
      categoryId: Value(categoryId),
    );
  }

  factory PricelistSetCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PricelistSetCategory(
      pricelistSetId: serializer.fromJson<int>(json['pricelistSetId']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'pricelistSetId': serializer.toJson<int>(pricelistSetId),
      'categoryId': serializer.toJson<int>(categoryId),
    };
  }

  PricelistSetCategory copyWith({int? pricelistSetId, int? categoryId}) =>
      PricelistSetCategory(
        pricelistSetId: pricelistSetId ?? this.pricelistSetId,
        categoryId: categoryId ?? this.categoryId,
      );
  @override
  String toString() {
    return (StringBuffer('PricelistSetCategory(')
          ..write('pricelistSetId: $pricelistSetId, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(pricelistSetId, categoryId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PricelistSetCategory &&
          other.pricelistSetId == this.pricelistSetId &&
          other.categoryId == this.categoryId);
}

class PricelistSetCategoriesCompanion
    extends UpdateCompanion<PricelistSetCategory> {
  final Value<int> pricelistSetId;
  final Value<int> categoryId;
  final Value<int> rowid;
  const PricelistSetCategoriesCompanion({
    this.pricelistSetId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PricelistSetCategoriesCompanion.insert({
    required int pricelistSetId,
    required int categoryId,
    this.rowid = const Value.absent(),
  })  : pricelistSetId = Value(pricelistSetId),
        categoryId = Value(categoryId);
  static Insertable<PricelistSetCategory> custom({
    Expression<int>? pricelistSetId,
    Expression<int>? categoryId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (pricelistSetId != null) 'pricelist_set_id': pricelistSetId,
      if (categoryId != null) 'category_id': categoryId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PricelistSetCategoriesCompanion copyWith(
      {Value<int>? pricelistSetId, Value<int>? categoryId, Value<int>? rowid}) {
    return PricelistSetCategoriesCompanion(
      pricelistSetId: pricelistSetId ?? this.pricelistSetId,
      categoryId: categoryId ?? this.categoryId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (pricelistSetId.present) {
      map['pricelist_set_id'] = Variable<int>(pricelistSetId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PricelistSetCategoriesCompanion(')
          ..write('pricelistSetId: $pricelistSetId, ')
          ..write('categoryId: $categoryId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PartnersPricesTable extends PartnersPrices
    with TableInfo<$PartnersPricesTable, PartnersPrice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartnersPricesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _guidMeta = const VerificationMeta('guid');
  @override
  late final GeneratedColumn<String> guid = GeneratedColumn<String>(
      'guid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted =
      GeneratedColumn<bool>('is_deleted', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_deleted" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _currentTimestampMeta =
      const VerificationMeta('currentTimestamp');
  @override
  late final GeneratedColumn<DateTime> currentTimestamp =
      GeneratedColumn<DateTime>('current_timestamp', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  static const VerificationMeta _lastSyncTimeMeta =
      const VerificationMeta('lastSyncTime');
  @override
  late final GeneratedColumn<DateTime> lastSyncTime = GeneratedColumn<DateTime>(
      'last_sync_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _needSyncMeta =
      const VerificationMeta('needSync');
  @override
  late final GeneratedColumn<bool> needSync = GeneratedColumn<bool>(
      'need_sync', aliasedName, false,
      generatedAs: GeneratedAs(
          (isNew & isDeleted.not()) |
              (isNew.not() & lastSyncTime.isSmallerThan(timestamp)),
          true),
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
        SqlDialect.sqlite: 'CHECK ("need_sync" IN (0, 1))',
        SqlDialect.mysql: '',
        SqlDialect.postgres: '',
      }));
  static const VerificationMeta _isNewMeta = const VerificationMeta('isNew');
  @override
  late final GeneratedColumn<bool> isNew =
      GeneratedColumn<bool>('is_new', aliasedName, false,
          generatedAs: GeneratedAs(lastSyncTime.isNull(), false),
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_new" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _goodsIdMeta =
      const VerificationMeta('goodsId');
  @override
  late final GeneratedColumn<int> goodsId = GeneratedColumn<int>(
      'goods_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _partnerIdMeta =
      const VerificationMeta('partnerId');
  @override
  late final GeneratedColumn<int> partnerId = GeneratedColumn<int>(
      'partner_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _dateFromMeta =
      const VerificationMeta('dateFrom');
  @override
  late final GeneratedColumn<DateTime> dateFrom = GeneratedColumn<DateTime>(
      'date_from', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _dateToMeta = const VerificationMeta('dateTo');
  @override
  late final GeneratedColumn<DateTime> dateTo = GeneratedColumn<DateTime>(
      'date_to', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        guid,
        isDeleted,
        timestamp,
        currentTimestamp,
        lastSyncTime,
        needSync,
        isNew,
        id,
        goodsId,
        partnerId,
        price,
        dateFrom,
        dateTo
      ];
  @override
  String get aliasedName => _alias ?? 'partners_prices';
  @override
  String get actualTableName => 'partners_prices';
  @override
  VerificationContext validateIntegrity(Insertable<PartnersPrice> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('guid')) {
      context.handle(
          _guidMeta, guid.isAcceptableOrUnknown(data['guid']!, _guidMeta));
    } else if (isInserting) {
      context.missing(_guidMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    }
    if (data.containsKey('current_timestamp')) {
      context.handle(
          _currentTimestampMeta,
          currentTimestamp.isAcceptableOrUnknown(
              data['current_timestamp']!, _currentTimestampMeta));
    }
    if (data.containsKey('last_sync_time')) {
      context.handle(
          _lastSyncTimeMeta,
          lastSyncTime.isAcceptableOrUnknown(
              data['last_sync_time']!, _lastSyncTimeMeta));
    }
    if (data.containsKey('need_sync')) {
      context.handle(_needSyncMeta,
          needSync.isAcceptableOrUnknown(data['need_sync']!, _needSyncMeta));
    }
    if (data.containsKey('is_new')) {
      context.handle(
          _isNewMeta, isNew.isAcceptableOrUnknown(data['is_new']!, _isNewMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('goods_id')) {
      context.handle(_goodsIdMeta,
          goodsId.isAcceptableOrUnknown(data['goods_id']!, _goodsIdMeta));
    } else if (isInserting) {
      context.missing(_goodsIdMeta);
    }
    if (data.containsKey('partner_id')) {
      context.handle(_partnerIdMeta,
          partnerId.isAcceptableOrUnknown(data['partner_id']!, _partnerIdMeta));
    } else if (isInserting) {
      context.missing(_partnerIdMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('date_from')) {
      context.handle(_dateFromMeta,
          dateFrom.isAcceptableOrUnknown(data['date_from']!, _dateFromMeta));
    } else if (isInserting) {
      context.missing(_dateFromMeta);
    }
    if (data.containsKey('date_to')) {
      context.handle(_dateToMeta,
          dateTo.isAcceptableOrUnknown(data['date_to']!, _dateToMeta));
    } else if (isInserting) {
      context.missing(_dateToMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {guid};
  @override
  PartnersPrice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartnersPrice(
      guid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guid'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      currentTimestamp: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}current_timestamp'])!,
      lastSyncTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_sync_time']),
      needSync: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}need_sync'])!,
      isNew: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_new'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id']),
      goodsId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}goods_id'])!,
      partnerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}partner_id'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      dateFrom: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_from'])!,
      dateTo: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_to'])!,
    );
  }

  @override
  $PartnersPricesTable createAlias(String alias) {
    return $PartnersPricesTable(attachedDatabase, alias);
  }
}

class PartnersPrice extends DataClass implements Insertable<PartnersPrice> {
  final String guid;
  final bool isDeleted;
  final DateTime timestamp;
  final DateTime currentTimestamp;
  final DateTime? lastSyncTime;
  final bool needSync;
  final bool isNew;
  final int? id;
  final int goodsId;
  final int partnerId;
  final double price;
  final DateTime dateFrom;
  final DateTime dateTo;
  const PartnersPrice(
      {required this.guid,
      required this.isDeleted,
      required this.timestamp,
      required this.currentTimestamp,
      this.lastSyncTime,
      required this.needSync,
      required this.isNew,
      this.id,
      required this.goodsId,
      required this.partnerId,
      required this.price,
      required this.dateFrom,
      required this.dateTo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['guid'] = Variable<String>(guid);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['current_timestamp'] = Variable<DateTime>(currentTimestamp);
    if (!nullToAbsent || lastSyncTime != null) {
      map['last_sync_time'] = Variable<DateTime>(lastSyncTime);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    map['goods_id'] = Variable<int>(goodsId);
    map['partner_id'] = Variable<int>(partnerId);
    map['price'] = Variable<double>(price);
    map['date_from'] = Variable<DateTime>(dateFrom);
    map['date_to'] = Variable<DateTime>(dateTo);
    return map;
  }

  PartnersPricesCompanion toCompanion(bool nullToAbsent) {
    return PartnersPricesCompanion(
      guid: Value(guid),
      isDeleted: Value(isDeleted),
      timestamp: Value(timestamp),
      currentTimestamp: Value(currentTimestamp),
      lastSyncTime: lastSyncTime == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncTime),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      goodsId: Value(goodsId),
      partnerId: Value(partnerId),
      price: Value(price),
      dateFrom: Value(dateFrom),
      dateTo: Value(dateTo),
    );
  }

  factory PartnersPrice.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartnersPrice(
      guid: serializer.fromJson<String>(json['guid']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      currentTimestamp: serializer.fromJson<DateTime>(json['currentTimestamp']),
      lastSyncTime: serializer.fromJson<DateTime?>(json['lastSyncTime']),
      needSync: serializer.fromJson<bool>(json['needSync']),
      isNew: serializer.fromJson<bool>(json['isNew']),
      id: serializer.fromJson<int?>(json['id']),
      goodsId: serializer.fromJson<int>(json['goodsId']),
      partnerId: serializer.fromJson<int>(json['partnerId']),
      price: serializer.fromJson<double>(json['price']),
      dateFrom: serializer.fromJson<DateTime>(json['dateFrom']),
      dateTo: serializer.fromJson<DateTime>(json['dateTo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'guid': serializer.toJson<String>(guid),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'currentTimestamp': serializer.toJson<DateTime>(currentTimestamp),
      'lastSyncTime': serializer.toJson<DateTime?>(lastSyncTime),
      'needSync': serializer.toJson<bool>(needSync),
      'isNew': serializer.toJson<bool>(isNew),
      'id': serializer.toJson<int?>(id),
      'goodsId': serializer.toJson<int>(goodsId),
      'partnerId': serializer.toJson<int>(partnerId),
      'price': serializer.toJson<double>(price),
      'dateFrom': serializer.toJson<DateTime>(dateFrom),
      'dateTo': serializer.toJson<DateTime>(dateTo),
    };
  }

  PartnersPrice copyWith(
          {String? guid,
          bool? isDeleted,
          DateTime? timestamp,
          DateTime? currentTimestamp,
          Value<DateTime?> lastSyncTime = const Value.absent(),
          bool? needSync,
          bool? isNew,
          Value<int?> id = const Value.absent(),
          int? goodsId,
          int? partnerId,
          double? price,
          DateTime? dateFrom,
          DateTime? dateTo}) =>
      PartnersPrice(
        guid: guid ?? this.guid,
        isDeleted: isDeleted ?? this.isDeleted,
        timestamp: timestamp ?? this.timestamp,
        currentTimestamp: currentTimestamp ?? this.currentTimestamp,
        lastSyncTime:
            lastSyncTime.present ? lastSyncTime.value : this.lastSyncTime,
        needSync: needSync ?? this.needSync,
        isNew: isNew ?? this.isNew,
        id: id.present ? id.value : this.id,
        goodsId: goodsId ?? this.goodsId,
        partnerId: partnerId ?? this.partnerId,
        price: price ?? this.price,
        dateFrom: dateFrom ?? this.dateFrom,
        dateTo: dateTo ?? this.dateTo,
      );
  @override
  String toString() {
    return (StringBuffer('PartnersPrice(')
          ..write('guid: $guid, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('timestamp: $timestamp, ')
          ..write('currentTimestamp: $currentTimestamp, ')
          ..write('lastSyncTime: $lastSyncTime, ')
          ..write('needSync: $needSync, ')
          ..write('isNew: $isNew, ')
          ..write('id: $id, ')
          ..write('goodsId: $goodsId, ')
          ..write('partnerId: $partnerId, ')
          ..write('price: $price, ')
          ..write('dateFrom: $dateFrom, ')
          ..write('dateTo: $dateTo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      guid,
      isDeleted,
      timestamp,
      currentTimestamp,
      lastSyncTime,
      needSync,
      isNew,
      id,
      goodsId,
      partnerId,
      price,
      dateFrom,
      dateTo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartnersPrice &&
          other.guid == this.guid &&
          other.isDeleted == this.isDeleted &&
          other.timestamp == this.timestamp &&
          other.currentTimestamp == this.currentTimestamp &&
          other.lastSyncTime == this.lastSyncTime &&
          other.needSync == this.needSync &&
          other.isNew == this.isNew &&
          other.id == this.id &&
          other.goodsId == this.goodsId &&
          other.partnerId == this.partnerId &&
          other.price == this.price &&
          other.dateFrom == this.dateFrom &&
          other.dateTo == this.dateTo);
}

class PartnersPricesCompanion extends UpdateCompanion<PartnersPrice> {
  final Value<String> guid;
  final Value<bool> isDeleted;
  final Value<DateTime> timestamp;
  final Value<DateTime> currentTimestamp;
  final Value<DateTime?> lastSyncTime;
  final Value<int?> id;
  final Value<int> goodsId;
  final Value<int> partnerId;
  final Value<double> price;
  final Value<DateTime> dateFrom;
  final Value<DateTime> dateTo;
  final Value<int> rowid;
  const PartnersPricesCompanion({
    this.guid = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.currentTimestamp = const Value.absent(),
    this.lastSyncTime = const Value.absent(),
    this.id = const Value.absent(),
    this.goodsId = const Value.absent(),
    this.partnerId = const Value.absent(),
    this.price = const Value.absent(),
    this.dateFrom = const Value.absent(),
    this.dateTo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PartnersPricesCompanion.insert({
    required String guid,
    this.isDeleted = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.currentTimestamp = const Value.absent(),
    this.lastSyncTime = const Value.absent(),
    this.id = const Value.absent(),
    required int goodsId,
    required int partnerId,
    required double price,
    required DateTime dateFrom,
    required DateTime dateTo,
    this.rowid = const Value.absent(),
  })  : guid = Value(guid),
        goodsId = Value(goodsId),
        partnerId = Value(partnerId),
        price = Value(price),
        dateFrom = Value(dateFrom),
        dateTo = Value(dateTo);
  static Insertable<PartnersPrice> custom({
    Expression<String>? guid,
    Expression<bool>? isDeleted,
    Expression<DateTime>? timestamp,
    Expression<DateTime>? currentTimestamp,
    Expression<DateTime>? lastSyncTime,
    Expression<int>? id,
    Expression<int>? goodsId,
    Expression<int>? partnerId,
    Expression<double>? price,
    Expression<DateTime>? dateFrom,
    Expression<DateTime>? dateTo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (guid != null) 'guid': guid,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (timestamp != null) 'timestamp': timestamp,
      if (currentTimestamp != null) 'current_timestamp': currentTimestamp,
      if (lastSyncTime != null) 'last_sync_time': lastSyncTime,
      if (id != null) 'id': id,
      if (goodsId != null) 'goods_id': goodsId,
      if (partnerId != null) 'partner_id': partnerId,
      if (price != null) 'price': price,
      if (dateFrom != null) 'date_from': dateFrom,
      if (dateTo != null) 'date_to': dateTo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PartnersPricesCompanion copyWith(
      {Value<String>? guid,
      Value<bool>? isDeleted,
      Value<DateTime>? timestamp,
      Value<DateTime>? currentTimestamp,
      Value<DateTime?>? lastSyncTime,
      Value<int?>? id,
      Value<int>? goodsId,
      Value<int>? partnerId,
      Value<double>? price,
      Value<DateTime>? dateFrom,
      Value<DateTime>? dateTo,
      Value<int>? rowid}) {
    return PartnersPricesCompanion(
      guid: guid ?? this.guid,
      isDeleted: isDeleted ?? this.isDeleted,
      timestamp: timestamp ?? this.timestamp,
      currentTimestamp: currentTimestamp ?? this.currentTimestamp,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      id: id ?? this.id,
      goodsId: goodsId ?? this.goodsId,
      partnerId: partnerId ?? this.partnerId,
      price: price ?? this.price,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (guid.present) {
      map['guid'] = Variable<String>(guid.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (currentTimestamp.present) {
      map['current_timestamp'] = Variable<DateTime>(currentTimestamp.value);
    }
    if (lastSyncTime.present) {
      map['last_sync_time'] = Variable<DateTime>(lastSyncTime.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (goodsId.present) {
      map['goods_id'] = Variable<int>(goodsId.value);
    }
    if (partnerId.present) {
      map['partner_id'] = Variable<int>(partnerId.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (dateFrom.present) {
      map['date_from'] = Variable<DateTime>(dateFrom.value);
    }
    if (dateTo.present) {
      map['date_to'] = Variable<DateTime>(dateTo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartnersPricesCompanion(')
          ..write('guid: $guid, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('timestamp: $timestamp, ')
          ..write('currentTimestamp: $currentTimestamp, ')
          ..write('lastSyncTime: $lastSyncTime, ')
          ..write('id: $id, ')
          ..write('goodsId: $goodsId, ')
          ..write('partnerId: $partnerId, ')
          ..write('price: $price, ')
          ..write('dateFrom: $dateFrom, ')
          ..write('dateTo: $dateTo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PricelistPricesTable extends PricelistPrices
    with TableInfo<$PricelistPricesTable, PricelistPrice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PricelistPricesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _goodsIdMeta =
      const VerificationMeta('goodsId');
  @override
  late final GeneratedColumn<int> goodsId = GeneratedColumn<int>(
      'goods_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _pricelistIdMeta =
      const VerificationMeta('pricelistId');
  @override
  late final GeneratedColumn<int> pricelistId = GeneratedColumn<int>(
      'pricelist_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _dateFromMeta =
      const VerificationMeta('dateFrom');
  @override
  late final GeneratedColumn<DateTime> dateFrom = GeneratedColumn<DateTime>(
      'date_from', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _dateToMeta = const VerificationMeta('dateTo');
  @override
  late final GeneratedColumn<DateTime> dateTo = GeneratedColumn<DateTime>(
      'date_to', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [goodsId, pricelistId, price, dateFrom, dateTo];
  @override
  String get aliasedName => _alias ?? 'pricelist_prices';
  @override
  String get actualTableName => 'pricelist_prices';
  @override
  VerificationContext validateIntegrity(Insertable<PricelistPrice> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('goods_id')) {
      context.handle(_goodsIdMeta,
          goodsId.isAcceptableOrUnknown(data['goods_id']!, _goodsIdMeta));
    } else if (isInserting) {
      context.missing(_goodsIdMeta);
    }
    if (data.containsKey('pricelist_id')) {
      context.handle(
          _pricelistIdMeta,
          pricelistId.isAcceptableOrUnknown(
              data['pricelist_id']!, _pricelistIdMeta));
    } else if (isInserting) {
      context.missing(_pricelistIdMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('date_from')) {
      context.handle(_dateFromMeta,
          dateFrom.isAcceptableOrUnknown(data['date_from']!, _dateFromMeta));
    } else if (isInserting) {
      context.missing(_dateFromMeta);
    }
    if (data.containsKey('date_to')) {
      context.handle(_dateToMeta,
          dateTo.isAcceptableOrUnknown(data['date_to']!, _dateToMeta));
    } else if (isInserting) {
      context.missing(_dateToMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  PricelistPrice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PricelistPrice(
      goodsId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}goods_id'])!,
      pricelistId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pricelist_id'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      dateFrom: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_from'])!,
      dateTo: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_to'])!,
    );
  }

  @override
  $PricelistPricesTable createAlias(String alias) {
    return $PricelistPricesTable(attachedDatabase, alias);
  }
}

class PricelistPrice extends DataClass implements Insertable<PricelistPrice> {
  final int goodsId;
  final int pricelistId;
  final double price;
  final DateTime dateFrom;
  final DateTime dateTo;
  const PricelistPrice(
      {required this.goodsId,
      required this.pricelistId,
      required this.price,
      required this.dateFrom,
      required this.dateTo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['goods_id'] = Variable<int>(goodsId);
    map['pricelist_id'] = Variable<int>(pricelistId);
    map['price'] = Variable<double>(price);
    map['date_from'] = Variable<DateTime>(dateFrom);
    map['date_to'] = Variable<DateTime>(dateTo);
    return map;
  }

  PricelistPricesCompanion toCompanion(bool nullToAbsent) {
    return PricelistPricesCompanion(
      goodsId: Value(goodsId),
      pricelistId: Value(pricelistId),
      price: Value(price),
      dateFrom: Value(dateFrom),
      dateTo: Value(dateTo),
    );
  }

  factory PricelistPrice.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PricelistPrice(
      goodsId: serializer.fromJson<int>(json['goodsId']),
      pricelistId: serializer.fromJson<int>(json['pricelistId']),
      price: serializer.fromJson<double>(json['price']),
      dateFrom: serializer.fromJson<DateTime>(json['dateFrom']),
      dateTo: serializer.fromJson<DateTime>(json['dateTo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'goodsId': serializer.toJson<int>(goodsId),
      'pricelistId': serializer.toJson<int>(pricelistId),
      'price': serializer.toJson<double>(price),
      'dateFrom': serializer.toJson<DateTime>(dateFrom),
      'dateTo': serializer.toJson<DateTime>(dateTo),
    };
  }

  PricelistPrice copyWith(
          {int? goodsId,
          int? pricelistId,
          double? price,
          DateTime? dateFrom,
          DateTime? dateTo}) =>
      PricelistPrice(
        goodsId: goodsId ?? this.goodsId,
        pricelistId: pricelistId ?? this.pricelistId,
        price: price ?? this.price,
        dateFrom: dateFrom ?? this.dateFrom,
        dateTo: dateTo ?? this.dateTo,
      );
  @override
  String toString() {
    return (StringBuffer('PricelistPrice(')
          ..write('goodsId: $goodsId, ')
          ..write('pricelistId: $pricelistId, ')
          ..write('price: $price, ')
          ..write('dateFrom: $dateFrom, ')
          ..write('dateTo: $dateTo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(goodsId, pricelistId, price, dateFrom, dateTo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PricelistPrice &&
          other.goodsId == this.goodsId &&
          other.pricelistId == this.pricelistId &&
          other.price == this.price &&
          other.dateFrom == this.dateFrom &&
          other.dateTo == this.dateTo);
}

class PricelistPricesCompanion extends UpdateCompanion<PricelistPrice> {
  final Value<int> goodsId;
  final Value<int> pricelistId;
  final Value<double> price;
  final Value<DateTime> dateFrom;
  final Value<DateTime> dateTo;
  final Value<int> rowid;
  const PricelistPricesCompanion({
    this.goodsId = const Value.absent(),
    this.pricelistId = const Value.absent(),
    this.price = const Value.absent(),
    this.dateFrom = const Value.absent(),
    this.dateTo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PricelistPricesCompanion.insert({
    required int goodsId,
    required int pricelistId,
    required double price,
    required DateTime dateFrom,
    required DateTime dateTo,
    this.rowid = const Value.absent(),
  })  : goodsId = Value(goodsId),
        pricelistId = Value(pricelistId),
        price = Value(price),
        dateFrom = Value(dateFrom),
        dateTo = Value(dateTo);
  static Insertable<PricelistPrice> custom({
    Expression<int>? goodsId,
    Expression<int>? pricelistId,
    Expression<double>? price,
    Expression<DateTime>? dateFrom,
    Expression<DateTime>? dateTo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (goodsId != null) 'goods_id': goodsId,
      if (pricelistId != null) 'pricelist_id': pricelistId,
      if (price != null) 'price': price,
      if (dateFrom != null) 'date_from': dateFrom,
      if (dateTo != null) 'date_to': dateTo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PricelistPricesCompanion copyWith(
      {Value<int>? goodsId,
      Value<int>? pricelistId,
      Value<double>? price,
      Value<DateTime>? dateFrom,
      Value<DateTime>? dateTo,
      Value<int>? rowid}) {
    return PricelistPricesCompanion(
      goodsId: goodsId ?? this.goodsId,
      pricelistId: pricelistId ?? this.pricelistId,
      price: price ?? this.price,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (goodsId.present) {
      map['goods_id'] = Variable<int>(goodsId.value);
    }
    if (pricelistId.present) {
      map['pricelist_id'] = Variable<int>(pricelistId.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (dateFrom.present) {
      map['date_from'] = Variable<DateTime>(dateFrom.value);
    }
    if (dateTo.present) {
      map['date_to'] = Variable<DateTime>(dateTo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PricelistPricesCompanion(')
          ..write('goodsId: $goodsId, ')
          ..write('pricelistId: $pricelistId, ')
          ..write('price: $price, ')
          ..write('dateFrom: $dateFrom, ')
          ..write('dateTo: $dateTo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PartnersPricelistsTable extends PartnersPricelists
    with TableInfo<$PartnersPricelistsTable, PartnersPricelist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartnersPricelistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _guidMeta = const VerificationMeta('guid');
  @override
  late final GeneratedColumn<String> guid = GeneratedColumn<String>(
      'guid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted =
      GeneratedColumn<bool>('is_deleted', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_deleted" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _currentTimestampMeta =
      const VerificationMeta('currentTimestamp');
  @override
  late final GeneratedColumn<DateTime> currentTimestamp =
      GeneratedColumn<DateTime>('current_timestamp', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  static const VerificationMeta _lastSyncTimeMeta =
      const VerificationMeta('lastSyncTime');
  @override
  late final GeneratedColumn<DateTime> lastSyncTime = GeneratedColumn<DateTime>(
      'last_sync_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _needSyncMeta =
      const VerificationMeta('needSync');
  @override
  late final GeneratedColumn<bool> needSync = GeneratedColumn<bool>(
      'need_sync', aliasedName, false,
      generatedAs: GeneratedAs(
          (isNew & isDeleted.not()) |
              (isNew.not() & lastSyncTime.isSmallerThan(timestamp)),
          true),
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
        SqlDialect.sqlite: 'CHECK ("need_sync" IN (0, 1))',
        SqlDialect.mysql: '',
        SqlDialect.postgres: '',
      }));
  static const VerificationMeta _isNewMeta = const VerificationMeta('isNew');
  @override
  late final GeneratedColumn<bool> isNew =
      GeneratedColumn<bool>('is_new', aliasedName, false,
          generatedAs: GeneratedAs(lastSyncTime.isNull(), false),
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_new" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _partnerIdMeta =
      const VerificationMeta('partnerId');
  @override
  late final GeneratedColumn<int> partnerId = GeneratedColumn<int>(
      'partner_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _pricelistIdMeta =
      const VerificationMeta('pricelistId');
  @override
  late final GeneratedColumn<int> pricelistId = GeneratedColumn<int>(
      'pricelist_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _pricelistSetIdMeta =
      const VerificationMeta('pricelistSetId');
  @override
  late final GeneratedColumn<int> pricelistSetId = GeneratedColumn<int>(
      'pricelist_set_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _discountMeta =
      const VerificationMeta('discount');
  @override
  late final GeneratedColumn<double> discount = GeneratedColumn<double>(
      'discount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        guid,
        isDeleted,
        timestamp,
        currentTimestamp,
        lastSyncTime,
        needSync,
        isNew,
        id,
        partnerId,
        pricelistId,
        pricelistSetId,
        discount
      ];
  @override
  String get aliasedName => _alias ?? 'partners_pricelists';
  @override
  String get actualTableName => 'partners_pricelists';
  @override
  VerificationContext validateIntegrity(Insertable<PartnersPricelist> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('guid')) {
      context.handle(
          _guidMeta, guid.isAcceptableOrUnknown(data['guid']!, _guidMeta));
    } else if (isInserting) {
      context.missing(_guidMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    }
    if (data.containsKey('current_timestamp')) {
      context.handle(
          _currentTimestampMeta,
          currentTimestamp.isAcceptableOrUnknown(
              data['current_timestamp']!, _currentTimestampMeta));
    }
    if (data.containsKey('last_sync_time')) {
      context.handle(
          _lastSyncTimeMeta,
          lastSyncTime.isAcceptableOrUnknown(
              data['last_sync_time']!, _lastSyncTimeMeta));
    }
    if (data.containsKey('need_sync')) {
      context.handle(_needSyncMeta,
          needSync.isAcceptableOrUnknown(data['need_sync']!, _needSyncMeta));
    }
    if (data.containsKey('is_new')) {
      context.handle(
          _isNewMeta, isNew.isAcceptableOrUnknown(data['is_new']!, _isNewMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('partner_id')) {
      context.handle(_partnerIdMeta,
          partnerId.isAcceptableOrUnknown(data['partner_id']!, _partnerIdMeta));
    } else if (isInserting) {
      context.missing(_partnerIdMeta);
    }
    if (data.containsKey('pricelist_id')) {
      context.handle(
          _pricelistIdMeta,
          pricelistId.isAcceptableOrUnknown(
              data['pricelist_id']!, _pricelistIdMeta));
    } else if (isInserting) {
      context.missing(_pricelistIdMeta);
    }
    if (data.containsKey('pricelist_set_id')) {
      context.handle(
          _pricelistSetIdMeta,
          pricelistSetId.isAcceptableOrUnknown(
              data['pricelist_set_id']!, _pricelistSetIdMeta));
    } else if (isInserting) {
      context.missing(_pricelistSetIdMeta);
    }
    if (data.containsKey('discount')) {
      context.handle(_discountMeta,
          discount.isAcceptableOrUnknown(data['discount']!, _discountMeta));
    } else if (isInserting) {
      context.missing(_discountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {guid};
  @override
  PartnersPricelist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartnersPricelist(
      guid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guid'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      currentTimestamp: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}current_timestamp'])!,
      lastSyncTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_sync_time']),
      needSync: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}need_sync'])!,
      isNew: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_new'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id']),
      partnerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}partner_id'])!,
      pricelistId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pricelist_id'])!,
      pricelistSetId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pricelist_set_id'])!,
      discount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}discount'])!,
    );
  }

  @override
  $PartnersPricelistsTable createAlias(String alias) {
    return $PartnersPricelistsTable(attachedDatabase, alias);
  }
}

class PartnersPricelist extends DataClass
    implements Insertable<PartnersPricelist> {
  final String guid;
  final bool isDeleted;
  final DateTime timestamp;
  final DateTime currentTimestamp;
  final DateTime? lastSyncTime;
  final bool needSync;
  final bool isNew;
  final int? id;
  final int partnerId;
  final int pricelistId;
  final int pricelistSetId;
  final double discount;
  const PartnersPricelist(
      {required this.guid,
      required this.isDeleted,
      required this.timestamp,
      required this.currentTimestamp,
      this.lastSyncTime,
      required this.needSync,
      required this.isNew,
      this.id,
      required this.partnerId,
      required this.pricelistId,
      required this.pricelistSetId,
      required this.discount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['guid'] = Variable<String>(guid);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['current_timestamp'] = Variable<DateTime>(currentTimestamp);
    if (!nullToAbsent || lastSyncTime != null) {
      map['last_sync_time'] = Variable<DateTime>(lastSyncTime);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    map['partner_id'] = Variable<int>(partnerId);
    map['pricelist_id'] = Variable<int>(pricelistId);
    map['pricelist_set_id'] = Variable<int>(pricelistSetId);
    map['discount'] = Variable<double>(discount);
    return map;
  }

  PartnersPricelistsCompanion toCompanion(bool nullToAbsent) {
    return PartnersPricelistsCompanion(
      guid: Value(guid),
      isDeleted: Value(isDeleted),
      timestamp: Value(timestamp),
      currentTimestamp: Value(currentTimestamp),
      lastSyncTime: lastSyncTime == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncTime),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      partnerId: Value(partnerId),
      pricelistId: Value(pricelistId),
      pricelistSetId: Value(pricelistSetId),
      discount: Value(discount),
    );
  }

  factory PartnersPricelist.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartnersPricelist(
      guid: serializer.fromJson<String>(json['guid']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      currentTimestamp: serializer.fromJson<DateTime>(json['currentTimestamp']),
      lastSyncTime: serializer.fromJson<DateTime?>(json['lastSyncTime']),
      needSync: serializer.fromJson<bool>(json['needSync']),
      isNew: serializer.fromJson<bool>(json['isNew']),
      id: serializer.fromJson<int?>(json['id']),
      partnerId: serializer.fromJson<int>(json['partnerId']),
      pricelistId: serializer.fromJson<int>(json['pricelistId']),
      pricelistSetId: serializer.fromJson<int>(json['pricelistSetId']),
      discount: serializer.fromJson<double>(json['discount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'guid': serializer.toJson<String>(guid),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'currentTimestamp': serializer.toJson<DateTime>(currentTimestamp),
      'lastSyncTime': serializer.toJson<DateTime?>(lastSyncTime),
      'needSync': serializer.toJson<bool>(needSync),
      'isNew': serializer.toJson<bool>(isNew),
      'id': serializer.toJson<int?>(id),
      'partnerId': serializer.toJson<int>(partnerId),
      'pricelistId': serializer.toJson<int>(pricelistId),
      'pricelistSetId': serializer.toJson<int>(pricelistSetId),
      'discount': serializer.toJson<double>(discount),
    };
  }

  PartnersPricelist copyWith(
          {String? guid,
          bool? isDeleted,
          DateTime? timestamp,
          DateTime? currentTimestamp,
          Value<DateTime?> lastSyncTime = const Value.absent(),
          bool? needSync,
          bool? isNew,
          Value<int?> id = const Value.absent(),
          int? partnerId,
          int? pricelistId,
          int? pricelistSetId,
          double? discount}) =>
      PartnersPricelist(
        guid: guid ?? this.guid,
        isDeleted: isDeleted ?? this.isDeleted,
        timestamp: timestamp ?? this.timestamp,
        currentTimestamp: currentTimestamp ?? this.currentTimestamp,
        lastSyncTime:
            lastSyncTime.present ? lastSyncTime.value : this.lastSyncTime,
        needSync: needSync ?? this.needSync,
        isNew: isNew ?? this.isNew,
        id: id.present ? id.value : this.id,
        partnerId: partnerId ?? this.partnerId,
        pricelistId: pricelistId ?? this.pricelistId,
        pricelistSetId: pricelistSetId ?? this.pricelistSetId,
        discount: discount ?? this.discount,
      );
  @override
  String toString() {
    return (StringBuffer('PartnersPricelist(')
          ..write('guid: $guid, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('timestamp: $timestamp, ')
          ..write('currentTimestamp: $currentTimestamp, ')
          ..write('lastSyncTime: $lastSyncTime, ')
          ..write('needSync: $needSync, ')
          ..write('isNew: $isNew, ')
          ..write('id: $id, ')
          ..write('partnerId: $partnerId, ')
          ..write('pricelistId: $pricelistId, ')
          ..write('pricelistSetId: $pricelistSetId, ')
          ..write('discount: $discount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      guid,
      isDeleted,
      timestamp,
      currentTimestamp,
      lastSyncTime,
      needSync,
      isNew,
      id,
      partnerId,
      pricelistId,
      pricelistSetId,
      discount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartnersPricelist &&
          other.guid == this.guid &&
          other.isDeleted == this.isDeleted &&
          other.timestamp == this.timestamp &&
          other.currentTimestamp == this.currentTimestamp &&
          other.lastSyncTime == this.lastSyncTime &&
          other.needSync == this.needSync &&
          other.isNew == this.isNew &&
          other.id == this.id &&
          other.partnerId == this.partnerId &&
          other.pricelistId == this.pricelistId &&
          other.pricelistSetId == this.pricelistSetId &&
          other.discount == this.discount);
}

class PartnersPricelistsCompanion extends UpdateCompanion<PartnersPricelist> {
  final Value<String> guid;
  final Value<bool> isDeleted;
  final Value<DateTime> timestamp;
  final Value<DateTime> currentTimestamp;
  final Value<DateTime?> lastSyncTime;
  final Value<int?> id;
  final Value<int> partnerId;
  final Value<int> pricelistId;
  final Value<int> pricelistSetId;
  final Value<double> discount;
  final Value<int> rowid;
  const PartnersPricelistsCompanion({
    this.guid = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.currentTimestamp = const Value.absent(),
    this.lastSyncTime = const Value.absent(),
    this.id = const Value.absent(),
    this.partnerId = const Value.absent(),
    this.pricelistId = const Value.absent(),
    this.pricelistSetId = const Value.absent(),
    this.discount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PartnersPricelistsCompanion.insert({
    required String guid,
    this.isDeleted = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.currentTimestamp = const Value.absent(),
    this.lastSyncTime = const Value.absent(),
    this.id = const Value.absent(),
    required int partnerId,
    required int pricelistId,
    required int pricelistSetId,
    required double discount,
    this.rowid = const Value.absent(),
  })  : guid = Value(guid),
        partnerId = Value(partnerId),
        pricelistId = Value(pricelistId),
        pricelistSetId = Value(pricelistSetId),
        discount = Value(discount);
  static Insertable<PartnersPricelist> custom({
    Expression<String>? guid,
    Expression<bool>? isDeleted,
    Expression<DateTime>? timestamp,
    Expression<DateTime>? currentTimestamp,
    Expression<DateTime>? lastSyncTime,
    Expression<int>? id,
    Expression<int>? partnerId,
    Expression<int>? pricelistId,
    Expression<int>? pricelistSetId,
    Expression<double>? discount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (guid != null) 'guid': guid,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (timestamp != null) 'timestamp': timestamp,
      if (currentTimestamp != null) 'current_timestamp': currentTimestamp,
      if (lastSyncTime != null) 'last_sync_time': lastSyncTime,
      if (id != null) 'id': id,
      if (partnerId != null) 'partner_id': partnerId,
      if (pricelistId != null) 'pricelist_id': pricelistId,
      if (pricelistSetId != null) 'pricelist_set_id': pricelistSetId,
      if (discount != null) 'discount': discount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PartnersPricelistsCompanion copyWith(
      {Value<String>? guid,
      Value<bool>? isDeleted,
      Value<DateTime>? timestamp,
      Value<DateTime>? currentTimestamp,
      Value<DateTime?>? lastSyncTime,
      Value<int?>? id,
      Value<int>? partnerId,
      Value<int>? pricelistId,
      Value<int>? pricelistSetId,
      Value<double>? discount,
      Value<int>? rowid}) {
    return PartnersPricelistsCompanion(
      guid: guid ?? this.guid,
      isDeleted: isDeleted ?? this.isDeleted,
      timestamp: timestamp ?? this.timestamp,
      currentTimestamp: currentTimestamp ?? this.currentTimestamp,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      id: id ?? this.id,
      partnerId: partnerId ?? this.partnerId,
      pricelistId: pricelistId ?? this.pricelistId,
      pricelistSetId: pricelistSetId ?? this.pricelistSetId,
      discount: discount ?? this.discount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (guid.present) {
      map['guid'] = Variable<String>(guid.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (currentTimestamp.present) {
      map['current_timestamp'] = Variable<DateTime>(currentTimestamp.value);
    }
    if (lastSyncTime.present) {
      map['last_sync_time'] = Variable<DateTime>(lastSyncTime.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (partnerId.present) {
      map['partner_id'] = Variable<int>(partnerId.value);
    }
    if (pricelistId.present) {
      map['pricelist_id'] = Variable<int>(pricelistId.value);
    }
    if (pricelistSetId.present) {
      map['pricelist_set_id'] = Variable<int>(pricelistSetId.value);
    }
    if (discount.present) {
      map['discount'] = Variable<double>(discount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartnersPricelistsCompanion(')
          ..write('guid: $guid, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('timestamp: $timestamp, ')
          ..write('currentTimestamp: $currentTimestamp, ')
          ..write('lastSyncTime: $lastSyncTime, ')
          ..write('id: $id, ')
          ..write('partnerId: $partnerId, ')
          ..write('pricelistId: $pricelistId, ')
          ..write('pricelistSetId: $pricelistSetId, ')
          ..write('discount: $discount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoodsRestrictionsTable extends GoodsRestrictions
    with TableInfo<$GoodsRestrictionsTable, GoodsRestriction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoodsRestrictionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _goodsIdMeta =
      const VerificationMeta('goodsId');
  @override
  late final GeneratedColumn<int> goodsId = GeneratedColumn<int>(
      'goods_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _buyerIdMeta =
      const VerificationMeta('buyerId');
  @override
  late final GeneratedColumn<int> buyerId = GeneratedColumn<int>(
      'buyer_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [goodsId, buyerId];
  @override
  String get aliasedName => _alias ?? 'goods_restrictions';
  @override
  String get actualTableName => 'goods_restrictions';
  @override
  VerificationContext validateIntegrity(Insertable<GoodsRestriction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('goods_id')) {
      context.handle(_goodsIdMeta,
          goodsId.isAcceptableOrUnknown(data['goods_id']!, _goodsIdMeta));
    } else if (isInserting) {
      context.missing(_goodsIdMeta);
    }
    if (data.containsKey('buyer_id')) {
      context.handle(_buyerIdMeta,
          buyerId.isAcceptableOrUnknown(data['buyer_id']!, _buyerIdMeta));
    } else if (isInserting) {
      context.missing(_buyerIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {goodsId, buyerId};
  @override
  GoodsRestriction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoodsRestriction(
      goodsId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}goods_id'])!,
      buyerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}buyer_id'])!,
    );
  }

  @override
  $GoodsRestrictionsTable createAlias(String alias) {
    return $GoodsRestrictionsTable(attachedDatabase, alias);
  }
}

class GoodsRestriction extends DataClass
    implements Insertable<GoodsRestriction> {
  final int goodsId;
  final int buyerId;
  const GoodsRestriction({required this.goodsId, required this.buyerId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['goods_id'] = Variable<int>(goodsId);
    map['buyer_id'] = Variable<int>(buyerId);
    return map;
  }

  GoodsRestrictionsCompanion toCompanion(bool nullToAbsent) {
    return GoodsRestrictionsCompanion(
      goodsId: Value(goodsId),
      buyerId: Value(buyerId),
    );
  }

  factory GoodsRestriction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoodsRestriction(
      goodsId: serializer.fromJson<int>(json['goodsId']),
      buyerId: serializer.fromJson<int>(json['buyerId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'goodsId': serializer.toJson<int>(goodsId),
      'buyerId': serializer.toJson<int>(buyerId),
    };
  }

  GoodsRestriction copyWith({int? goodsId, int? buyerId}) => GoodsRestriction(
        goodsId: goodsId ?? this.goodsId,
        buyerId: buyerId ?? this.buyerId,
      );
  @override
  String toString() {
    return (StringBuffer('GoodsRestriction(')
          ..write('goodsId: $goodsId, ')
          ..write('buyerId: $buyerId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(goodsId, buyerId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoodsRestriction &&
          other.goodsId == this.goodsId &&
          other.buyerId == this.buyerId);
}

class GoodsRestrictionsCompanion extends UpdateCompanion<GoodsRestriction> {
  final Value<int> goodsId;
  final Value<int> buyerId;
  final Value<int> rowid;
  const GoodsRestrictionsCompanion({
    this.goodsId = const Value.absent(),
    this.buyerId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoodsRestrictionsCompanion.insert({
    required int goodsId,
    required int buyerId,
    this.rowid = const Value.absent(),
  })  : goodsId = Value(goodsId),
        buyerId = Value(buyerId);
  static Insertable<GoodsRestriction> custom({
    Expression<int>? goodsId,
    Expression<int>? buyerId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (goodsId != null) 'goods_id': goodsId,
      if (buyerId != null) 'buyer_id': buyerId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoodsRestrictionsCompanion copyWith(
      {Value<int>? goodsId, Value<int>? buyerId, Value<int>? rowid}) {
    return GoodsRestrictionsCompanion(
      goodsId: goodsId ?? this.goodsId,
      buyerId: buyerId ?? this.buyerId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (goodsId.present) {
      map['goods_id'] = Variable<int>(goodsId.value);
    }
    if (buyerId.present) {
      map['buyer_id'] = Variable<int>(buyerId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoodsRestrictionsCompanion(')
          ..write('goodsId: $goodsId, ')
          ..write('buyerId: $buyerId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoodsStocksTable extends GoodsStocks
    with TableInfo<$GoodsStocksTable, GoodsStock> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoodsStocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _goodsIdMeta =
      const VerificationMeta('goodsId');
  @override
  late final GeneratedColumn<int> goodsId = GeneratedColumn<int>(
      'goods_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _siteIdMeta = const VerificationMeta('siteId');
  @override
  late final GeneratedColumn<int> siteId = GeneratedColumn<int>(
      'site_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isVollowMeta =
      const VerificationMeta('isVollow');
  @override
  late final GeneratedColumn<bool> isVollow =
      GeneratedColumn<bool>('is_vollow', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_vollow" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  static const VerificationMeta _factorMeta = const VerificationMeta('factor');
  @override
  late final GeneratedColumn<double> factor = GeneratedColumn<double>(
      'factor', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _volMeta = const VerificationMeta('vol');
  @override
  late final GeneratedColumn<double> vol = GeneratedColumn<double>(
      'vol', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [goodsId, siteId, isVollow, factor, vol];
  @override
  String get aliasedName => _alias ?? 'goods_stocks';
  @override
  String get actualTableName => 'goods_stocks';
  @override
  VerificationContext validateIntegrity(Insertable<GoodsStock> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('goods_id')) {
      context.handle(_goodsIdMeta,
          goodsId.isAcceptableOrUnknown(data['goods_id']!, _goodsIdMeta));
    } else if (isInserting) {
      context.missing(_goodsIdMeta);
    }
    if (data.containsKey('site_id')) {
      context.handle(_siteIdMeta,
          siteId.isAcceptableOrUnknown(data['site_id']!, _siteIdMeta));
    } else if (isInserting) {
      context.missing(_siteIdMeta);
    }
    if (data.containsKey('is_vollow')) {
      context.handle(_isVollowMeta,
          isVollow.isAcceptableOrUnknown(data['is_vollow']!, _isVollowMeta));
    } else if (isInserting) {
      context.missing(_isVollowMeta);
    }
    if (data.containsKey('factor')) {
      context.handle(_factorMeta,
          factor.isAcceptableOrUnknown(data['factor']!, _factorMeta));
    } else if (isInserting) {
      context.missing(_factorMeta);
    }
    if (data.containsKey('vol')) {
      context.handle(
          _volMeta, vol.isAcceptableOrUnknown(data['vol']!, _volMeta));
    } else if (isInserting) {
      context.missing(_volMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {goodsId, siteId};
  @override
  GoodsStock map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoodsStock(
      goodsId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}goods_id'])!,
      siteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}site_id'])!,
      isVollow: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_vollow'])!,
      factor: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}factor'])!,
      vol: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}vol'])!,
    );
  }

  @override
  $GoodsStocksTable createAlias(String alias) {
    return $GoodsStocksTable(attachedDatabase, alias);
  }
}

class GoodsStock extends DataClass implements Insertable<GoodsStock> {
  final int goodsId;
  final int siteId;
  final bool isVollow;
  final double factor;
  final double vol;
  const GoodsStock(
      {required this.goodsId,
      required this.siteId,
      required this.isVollow,
      required this.factor,
      required this.vol});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['goods_id'] = Variable<int>(goodsId);
    map['site_id'] = Variable<int>(siteId);
    map['is_vollow'] = Variable<bool>(isVollow);
    map['factor'] = Variable<double>(factor);
    map['vol'] = Variable<double>(vol);
    return map;
  }

  GoodsStocksCompanion toCompanion(bool nullToAbsent) {
    return GoodsStocksCompanion(
      goodsId: Value(goodsId),
      siteId: Value(siteId),
      isVollow: Value(isVollow),
      factor: Value(factor),
      vol: Value(vol),
    );
  }

  factory GoodsStock.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoodsStock(
      goodsId: serializer.fromJson<int>(json['goodsId']),
      siteId: serializer.fromJson<int>(json['siteId']),
      isVollow: serializer.fromJson<bool>(json['isVollow']),
      factor: serializer.fromJson<double>(json['factor']),
      vol: serializer.fromJson<double>(json['vol']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'goodsId': serializer.toJson<int>(goodsId),
      'siteId': serializer.toJson<int>(siteId),
      'isVollow': serializer.toJson<bool>(isVollow),
      'factor': serializer.toJson<double>(factor),
      'vol': serializer.toJson<double>(vol),
    };
  }

  GoodsStock copyWith(
          {int? goodsId,
          int? siteId,
          bool? isVollow,
          double? factor,
          double? vol}) =>
      GoodsStock(
        goodsId: goodsId ?? this.goodsId,
        siteId: siteId ?? this.siteId,
        isVollow: isVollow ?? this.isVollow,
        factor: factor ?? this.factor,
        vol: vol ?? this.vol,
      );
  @override
  String toString() {
    return (StringBuffer('GoodsStock(')
          ..write('goodsId: $goodsId, ')
          ..write('siteId: $siteId, ')
          ..write('isVollow: $isVollow, ')
          ..write('factor: $factor, ')
          ..write('vol: $vol')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(goodsId, siteId, isVollow, factor, vol);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoodsStock &&
          other.goodsId == this.goodsId &&
          other.siteId == this.siteId &&
          other.isVollow == this.isVollow &&
          other.factor == this.factor &&
          other.vol == this.vol);
}

class GoodsStocksCompanion extends UpdateCompanion<GoodsStock> {
  final Value<int> goodsId;
  final Value<int> siteId;
  final Value<bool> isVollow;
  final Value<double> factor;
  final Value<double> vol;
  final Value<int> rowid;
  const GoodsStocksCompanion({
    this.goodsId = const Value.absent(),
    this.siteId = const Value.absent(),
    this.isVollow = const Value.absent(),
    this.factor = const Value.absent(),
    this.vol = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoodsStocksCompanion.insert({
    required int goodsId,
    required int siteId,
    required bool isVollow,
    required double factor,
    required double vol,
    this.rowid = const Value.absent(),
  })  : goodsId = Value(goodsId),
        siteId = Value(siteId),
        isVollow = Value(isVollow),
        factor = Value(factor),
        vol = Value(vol);
  static Insertable<GoodsStock> custom({
    Expression<int>? goodsId,
    Expression<int>? siteId,
    Expression<bool>? isVollow,
    Expression<double>? factor,
    Expression<double>? vol,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (goodsId != null) 'goods_id': goodsId,
      if (siteId != null) 'site_id': siteId,
      if (isVollow != null) 'is_vollow': isVollow,
      if (factor != null) 'factor': factor,
      if (vol != null) 'vol': vol,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoodsStocksCompanion copyWith(
      {Value<int>? goodsId,
      Value<int>? siteId,
      Value<bool>? isVollow,
      Value<double>? factor,
      Value<double>? vol,
      Value<int>? rowid}) {
    return GoodsStocksCompanion(
      goodsId: goodsId ?? this.goodsId,
      siteId: siteId ?? this.siteId,
      isVollow: isVollow ?? this.isVollow,
      factor: factor ?? this.factor,
      vol: vol ?? this.vol,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (goodsId.present) {
      map['goods_id'] = Variable<int>(goodsId.value);
    }
    if (siteId.present) {
      map['site_id'] = Variable<int>(siteId.value);
    }
    if (isVollow.present) {
      map['is_vollow'] = Variable<bool>(isVollow.value);
    }
    if (factor.present) {
      map['factor'] = Variable<double>(factor.value);
    }
    if (vol.present) {
      map['vol'] = Variable<double>(vol.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoodsStocksCompanion(')
          ..write('goodsId: $goodsId, ')
          ..write('siteId: $siteId, ')
          ..write('isVollow: $isVollow, ')
          ..write('factor: $factor, ')
          ..write('vol: $vol, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoodsPartnersPricelistsTable extends GoodsPartnersPricelists
    with TableInfo<$GoodsPartnersPricelistsTable, GoodsPartnersPricelist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoodsPartnersPricelistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _goodsIdMeta =
      const VerificationMeta('goodsId');
  @override
  late final GeneratedColumn<int> goodsId = GeneratedColumn<int>(
      'goods_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _partnerPricelistIdMeta =
      const VerificationMeta('partnerPricelistId');
  @override
  late final GeneratedColumn<int> partnerPricelistId = GeneratedColumn<int>(
      'partner_pricelist_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _pricelistIdMeta =
      const VerificationMeta('pricelistId');
  @override
  late final GeneratedColumn<int> pricelistId = GeneratedColumn<int>(
      'pricelist_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _discountMeta =
      const VerificationMeta('discount');
  @override
  late final GeneratedColumn<double> discount = GeneratedColumn<double>(
      'discount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [goodsId, partnerPricelistId, pricelistId, discount];
  @override
  String get aliasedName => _alias ?? 'goods_partners_pricelists';
  @override
  String get actualTableName => 'goods_partners_pricelists';
  @override
  VerificationContext validateIntegrity(
      Insertable<GoodsPartnersPricelist> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('goods_id')) {
      context.handle(_goodsIdMeta,
          goodsId.isAcceptableOrUnknown(data['goods_id']!, _goodsIdMeta));
    } else if (isInserting) {
      context.missing(_goodsIdMeta);
    }
    if (data.containsKey('partner_pricelist_id')) {
      context.handle(
          _partnerPricelistIdMeta,
          partnerPricelistId.isAcceptableOrUnknown(
              data['partner_pricelist_id']!, _partnerPricelistIdMeta));
    } else if (isInserting) {
      context.missing(_partnerPricelistIdMeta);
    }
    if (data.containsKey('pricelist_id')) {
      context.handle(
          _pricelistIdMeta,
          pricelistId.isAcceptableOrUnknown(
              data['pricelist_id']!, _pricelistIdMeta));
    } else if (isInserting) {
      context.missing(_pricelistIdMeta);
    }
    if (data.containsKey('discount')) {
      context.handle(_discountMeta,
          discount.isAcceptableOrUnknown(data['discount']!, _discountMeta));
    } else if (isInserting) {
      context.missing(_discountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey =>
      {goodsId, partnerPricelistId, pricelistId};
  @override
  GoodsPartnersPricelist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoodsPartnersPricelist(
      goodsId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}goods_id'])!,
      partnerPricelistId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}partner_pricelist_id'])!,
      pricelistId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pricelist_id'])!,
      discount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}discount'])!,
    );
  }

  @override
  $GoodsPartnersPricelistsTable createAlias(String alias) {
    return $GoodsPartnersPricelistsTable(attachedDatabase, alias);
  }
}

class GoodsPartnersPricelist extends DataClass
    implements Insertable<GoodsPartnersPricelist> {
  final int goodsId;
  final int partnerPricelistId;
  final int pricelistId;
  final double discount;
  const GoodsPartnersPricelist(
      {required this.goodsId,
      required this.partnerPricelistId,
      required this.pricelistId,
      required this.discount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['goods_id'] = Variable<int>(goodsId);
    map['partner_pricelist_id'] = Variable<int>(partnerPricelistId);
    map['pricelist_id'] = Variable<int>(pricelistId);
    map['discount'] = Variable<double>(discount);
    return map;
  }

  GoodsPartnersPricelistsCompanion toCompanion(bool nullToAbsent) {
    return GoodsPartnersPricelistsCompanion(
      goodsId: Value(goodsId),
      partnerPricelistId: Value(partnerPricelistId),
      pricelistId: Value(pricelistId),
      discount: Value(discount),
    );
  }

  factory GoodsPartnersPricelist.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoodsPartnersPricelist(
      goodsId: serializer.fromJson<int>(json['goodsId']),
      partnerPricelistId: serializer.fromJson<int>(json['partnerPricelistId']),
      pricelistId: serializer.fromJson<int>(json['pricelistId']),
      discount: serializer.fromJson<double>(json['discount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'goodsId': serializer.toJson<int>(goodsId),
      'partnerPricelistId': serializer.toJson<int>(partnerPricelistId),
      'pricelistId': serializer.toJson<int>(pricelistId),
      'discount': serializer.toJson<double>(discount),
    };
  }

  GoodsPartnersPricelist copyWith(
          {int? goodsId,
          int? partnerPricelistId,
          int? pricelistId,
          double? discount}) =>
      GoodsPartnersPricelist(
        goodsId: goodsId ?? this.goodsId,
        partnerPricelistId: partnerPricelistId ?? this.partnerPricelistId,
        pricelistId: pricelistId ?? this.pricelistId,
        discount: discount ?? this.discount,
      );
  @override
  String toString() {
    return (StringBuffer('GoodsPartnersPricelist(')
          ..write('goodsId: $goodsId, ')
          ..write('partnerPricelistId: $partnerPricelistId, ')
          ..write('pricelistId: $pricelistId, ')
          ..write('discount: $discount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(goodsId, partnerPricelistId, pricelistId, discount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoodsPartnersPricelist &&
          other.goodsId == this.goodsId &&
          other.partnerPricelistId == this.partnerPricelistId &&
          other.pricelistId == this.pricelistId &&
          other.discount == this.discount);
}

class GoodsPartnersPricelistsCompanion
    extends UpdateCompanion<GoodsPartnersPricelist> {
  final Value<int> goodsId;
  final Value<int> partnerPricelistId;
  final Value<int> pricelistId;
  final Value<double> discount;
  final Value<int> rowid;
  const GoodsPartnersPricelistsCompanion({
    this.goodsId = const Value.absent(),
    this.partnerPricelistId = const Value.absent(),
    this.pricelistId = const Value.absent(),
    this.discount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoodsPartnersPricelistsCompanion.insert({
    required int goodsId,
    required int partnerPricelistId,
    required int pricelistId,
    required double discount,
    this.rowid = const Value.absent(),
  })  : goodsId = Value(goodsId),
        partnerPricelistId = Value(partnerPricelistId),
        pricelistId = Value(pricelistId),
        discount = Value(discount);
  static Insertable<GoodsPartnersPricelist> custom({
    Expression<int>? goodsId,
    Expression<int>? partnerPricelistId,
    Expression<int>? pricelistId,
    Expression<double>? discount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (goodsId != null) 'goods_id': goodsId,
      if (partnerPricelistId != null)
        'partner_pricelist_id': partnerPricelistId,
      if (pricelistId != null) 'pricelist_id': pricelistId,
      if (discount != null) 'discount': discount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoodsPartnersPricelistsCompanion copyWith(
      {Value<int>? goodsId,
      Value<int>? partnerPricelistId,
      Value<int>? pricelistId,
      Value<double>? discount,
      Value<int>? rowid}) {
    return GoodsPartnersPricelistsCompanion(
      goodsId: goodsId ?? this.goodsId,
      partnerPricelistId: partnerPricelistId ?? this.partnerPricelistId,
      pricelistId: pricelistId ?? this.pricelistId,
      discount: discount ?? this.discount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (goodsId.present) {
      map['goods_id'] = Variable<int>(goodsId.value);
    }
    if (partnerPricelistId.present) {
      map['partner_pricelist_id'] = Variable<int>(partnerPricelistId.value);
    }
    if (pricelistId.present) {
      map['pricelist_id'] = Variable<int>(pricelistId.value);
    }
    if (discount.present) {
      map['discount'] = Variable<double>(discount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoodsPartnersPricelistsCompanion(')
          ..write('goodsId: $goodsId, ')
          ..write('partnerPricelistId: $partnerPricelistId, ')
          ..write('pricelistId: $pricelistId, ')
          ..write('discount: $discount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoodsReturnStocksTable extends GoodsReturnStocks
    with TableInfo<$GoodsReturnStocksTable, GoodsReturnStock> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoodsReturnStocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _goodsIdMeta =
      const VerificationMeta('goodsId');
  @override
  late final GeneratedColumn<int> goodsId = GeneratedColumn<int>(
      'goods_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _returnActTypeIdMeta =
      const VerificationMeta('returnActTypeId');
  @override
  late final GeneratedColumn<int> returnActTypeId = GeneratedColumn<int>(
      'return_act_type_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _buyerIdMeta =
      const VerificationMeta('buyerId');
  @override
  late final GeneratedColumn<int> buyerId = GeneratedColumn<int>(
      'buyer_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _volMeta = const VerificationMeta('vol');
  @override
  late final GeneratedColumn<double> vol = GeneratedColumn<double>(
      'vol', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _receptIdMeta =
      const VerificationMeta('receptId');
  @override
  late final GeneratedColumn<int> receptId = GeneratedColumn<int>(
      'recept_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _receptSubidMeta =
      const VerificationMeta('receptSubid');
  @override
  late final GeneratedColumn<int> receptSubid = GeneratedColumn<int>(
      'recept_subid', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _receptDateMeta =
      const VerificationMeta('receptDate');
  @override
  late final GeneratedColumn<DateTime> receptDate = GeneratedColumn<DateTime>(
      'recept_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _receptNdocMeta =
      const VerificationMeta('receptNdoc');
  @override
  late final GeneratedColumn<String> receptNdoc = GeneratedColumn<String>(
      'recept_ndoc', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        goodsId,
        returnActTypeId,
        buyerId,
        vol,
        receptId,
        receptSubid,
        receptDate,
        receptNdoc
      ];
  @override
  String get aliasedName => _alias ?? 'goods_return_stocks';
  @override
  String get actualTableName => 'goods_return_stocks';
  @override
  VerificationContext validateIntegrity(Insertable<GoodsReturnStock> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('goods_id')) {
      context.handle(_goodsIdMeta,
          goodsId.isAcceptableOrUnknown(data['goods_id']!, _goodsIdMeta));
    } else if (isInserting) {
      context.missing(_goodsIdMeta);
    }
    if (data.containsKey('return_act_type_id')) {
      context.handle(
          _returnActTypeIdMeta,
          returnActTypeId.isAcceptableOrUnknown(
              data['return_act_type_id']!, _returnActTypeIdMeta));
    } else if (isInserting) {
      context.missing(_returnActTypeIdMeta);
    }
    if (data.containsKey('buyer_id')) {
      context.handle(_buyerIdMeta,
          buyerId.isAcceptableOrUnknown(data['buyer_id']!, _buyerIdMeta));
    } else if (isInserting) {
      context.missing(_buyerIdMeta);
    }
    if (data.containsKey('vol')) {
      context.handle(
          _volMeta, vol.isAcceptableOrUnknown(data['vol']!, _volMeta));
    } else if (isInserting) {
      context.missing(_volMeta);
    }
    if (data.containsKey('recept_id')) {
      context.handle(_receptIdMeta,
          receptId.isAcceptableOrUnknown(data['recept_id']!, _receptIdMeta));
    } else if (isInserting) {
      context.missing(_receptIdMeta);
    }
    if (data.containsKey('recept_subid')) {
      context.handle(
          _receptSubidMeta,
          receptSubid.isAcceptableOrUnknown(
              data['recept_subid']!, _receptSubidMeta));
    } else if (isInserting) {
      context.missing(_receptSubidMeta);
    }
    if (data.containsKey('recept_date')) {
      context.handle(
          _receptDateMeta,
          receptDate.isAcceptableOrUnknown(
              data['recept_date']!, _receptDateMeta));
    } else if (isInserting) {
      context.missing(_receptDateMeta);
    }
    if (data.containsKey('recept_ndoc')) {
      context.handle(
          _receptNdocMeta,
          receptNdoc.isAcceptableOrUnknown(
              data['recept_ndoc']!, _receptNdocMeta));
    } else if (isInserting) {
      context.missing(_receptNdocMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey =>
      {goodsId, receptId, receptSubid, returnActTypeId};
  @override
  GoodsReturnStock map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoodsReturnStock(
      goodsId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}goods_id'])!,
      returnActTypeId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}return_act_type_id'])!,
      buyerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}buyer_id'])!,
      vol: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}vol'])!,
      receptId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recept_id'])!,
      receptSubid: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recept_subid'])!,
      receptDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}recept_date'])!,
      receptNdoc: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recept_ndoc'])!,
    );
  }

  @override
  $GoodsReturnStocksTable createAlias(String alias) {
    return $GoodsReturnStocksTable(attachedDatabase, alias);
  }
}

class GoodsReturnStock extends DataClass
    implements Insertable<GoodsReturnStock> {
  final int goodsId;
  final int returnActTypeId;
  final int buyerId;
  final double vol;
  final int receptId;
  final int receptSubid;
  final DateTime receptDate;
  final String receptNdoc;
  const GoodsReturnStock(
      {required this.goodsId,
      required this.returnActTypeId,
      required this.buyerId,
      required this.vol,
      required this.receptId,
      required this.receptSubid,
      required this.receptDate,
      required this.receptNdoc});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['goods_id'] = Variable<int>(goodsId);
    map['return_act_type_id'] = Variable<int>(returnActTypeId);
    map['buyer_id'] = Variable<int>(buyerId);
    map['vol'] = Variable<double>(vol);
    map['recept_id'] = Variable<int>(receptId);
    map['recept_subid'] = Variable<int>(receptSubid);
    map['recept_date'] = Variable<DateTime>(receptDate);
    map['recept_ndoc'] = Variable<String>(receptNdoc);
    return map;
  }

  GoodsReturnStocksCompanion toCompanion(bool nullToAbsent) {
    return GoodsReturnStocksCompanion(
      goodsId: Value(goodsId),
      returnActTypeId: Value(returnActTypeId),
      buyerId: Value(buyerId),
      vol: Value(vol),
      receptId: Value(receptId),
      receptSubid: Value(receptSubid),
      receptDate: Value(receptDate),
      receptNdoc: Value(receptNdoc),
    );
  }

  factory GoodsReturnStock.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoodsReturnStock(
      goodsId: serializer.fromJson<int>(json['goodsId']),
      returnActTypeId: serializer.fromJson<int>(json['returnActTypeId']),
      buyerId: serializer.fromJson<int>(json['buyerId']),
      vol: serializer.fromJson<double>(json['vol']),
      receptId: serializer.fromJson<int>(json['receptId']),
      receptSubid: serializer.fromJson<int>(json['receptSubid']),
      receptDate: serializer.fromJson<DateTime>(json['receptDate']),
      receptNdoc: serializer.fromJson<String>(json['receptNdoc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'goodsId': serializer.toJson<int>(goodsId),
      'returnActTypeId': serializer.toJson<int>(returnActTypeId),
      'buyerId': serializer.toJson<int>(buyerId),
      'vol': serializer.toJson<double>(vol),
      'receptId': serializer.toJson<int>(receptId),
      'receptSubid': serializer.toJson<int>(receptSubid),
      'receptDate': serializer.toJson<DateTime>(receptDate),
      'receptNdoc': serializer.toJson<String>(receptNdoc),
    };
  }

  GoodsReturnStock copyWith(
          {int? goodsId,
          int? returnActTypeId,
          int? buyerId,
          double? vol,
          int? receptId,
          int? receptSubid,
          DateTime? receptDate,
          String? receptNdoc}) =>
      GoodsReturnStock(
        goodsId: goodsId ?? this.goodsId,
        returnActTypeId: returnActTypeId ?? this.returnActTypeId,
        buyerId: buyerId ?? this.buyerId,
        vol: vol ?? this.vol,
        receptId: receptId ?? this.receptId,
        receptSubid: receptSubid ?? this.receptSubid,
        receptDate: receptDate ?? this.receptDate,
        receptNdoc: receptNdoc ?? this.receptNdoc,
      );
  @override
  String toString() {
    return (StringBuffer('GoodsReturnStock(')
          ..write('goodsId: $goodsId, ')
          ..write('returnActTypeId: $returnActTypeId, ')
          ..write('buyerId: $buyerId, ')
          ..write('vol: $vol, ')
          ..write('receptId: $receptId, ')
          ..write('receptSubid: $receptSubid, ')
          ..write('receptDate: $receptDate, ')
          ..write('receptNdoc: $receptNdoc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(goodsId, returnActTypeId, buyerId, vol,
      receptId, receptSubid, receptDate, receptNdoc);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoodsReturnStock &&
          other.goodsId == this.goodsId &&
          other.returnActTypeId == this.returnActTypeId &&
          other.buyerId == this.buyerId &&
          other.vol == this.vol &&
          other.receptId == this.receptId &&
          other.receptSubid == this.receptSubid &&
          other.receptDate == this.receptDate &&
          other.receptNdoc == this.receptNdoc);
}

class GoodsReturnStocksCompanion extends UpdateCompanion<GoodsReturnStock> {
  final Value<int> goodsId;
  final Value<int> returnActTypeId;
  final Value<int> buyerId;
  final Value<double> vol;
  final Value<int> receptId;
  final Value<int> receptSubid;
  final Value<DateTime> receptDate;
  final Value<String> receptNdoc;
  final Value<int> rowid;
  const GoodsReturnStocksCompanion({
    this.goodsId = const Value.absent(),
    this.returnActTypeId = const Value.absent(),
    this.buyerId = const Value.absent(),
    this.vol = const Value.absent(),
    this.receptId = const Value.absent(),
    this.receptSubid = const Value.absent(),
    this.receptDate = const Value.absent(),
    this.receptNdoc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoodsReturnStocksCompanion.insert({
    required int goodsId,
    required int returnActTypeId,
    required int buyerId,
    required double vol,
    required int receptId,
    required int receptSubid,
    required DateTime receptDate,
    required String receptNdoc,
    this.rowid = const Value.absent(),
  })  : goodsId = Value(goodsId),
        returnActTypeId = Value(returnActTypeId),
        buyerId = Value(buyerId),
        vol = Value(vol),
        receptId = Value(receptId),
        receptSubid = Value(receptSubid),
        receptDate = Value(receptDate),
        receptNdoc = Value(receptNdoc);
  static Insertable<GoodsReturnStock> custom({
    Expression<int>? goodsId,
    Expression<int>? returnActTypeId,
    Expression<int>? buyerId,
    Expression<double>? vol,
    Expression<int>? receptId,
    Expression<int>? receptSubid,
    Expression<DateTime>? receptDate,
    Expression<String>? receptNdoc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (goodsId != null) 'goods_id': goodsId,
      if (returnActTypeId != null) 'return_act_type_id': returnActTypeId,
      if (buyerId != null) 'buyer_id': buyerId,
      if (vol != null) 'vol': vol,
      if (receptId != null) 'recept_id': receptId,
      if (receptSubid != null) 'recept_subid': receptSubid,
      if (receptDate != null) 'recept_date': receptDate,
      if (receptNdoc != null) 'recept_ndoc': receptNdoc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoodsReturnStocksCompanion copyWith(
      {Value<int>? goodsId,
      Value<int>? returnActTypeId,
      Value<int>? buyerId,
      Value<double>? vol,
      Value<int>? receptId,
      Value<int>? receptSubid,
      Value<DateTime>? receptDate,
      Value<String>? receptNdoc,
      Value<int>? rowid}) {
    return GoodsReturnStocksCompanion(
      goodsId: goodsId ?? this.goodsId,
      returnActTypeId: returnActTypeId ?? this.returnActTypeId,
      buyerId: buyerId ?? this.buyerId,
      vol: vol ?? this.vol,
      receptId: receptId ?? this.receptId,
      receptSubid: receptSubid ?? this.receptSubid,
      receptDate: receptDate ?? this.receptDate,
      receptNdoc: receptNdoc ?? this.receptNdoc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (goodsId.present) {
      map['goods_id'] = Variable<int>(goodsId.value);
    }
    if (returnActTypeId.present) {
      map['return_act_type_id'] = Variable<int>(returnActTypeId.value);
    }
    if (buyerId.present) {
      map['buyer_id'] = Variable<int>(buyerId.value);
    }
    if (vol.present) {
      map['vol'] = Variable<double>(vol.value);
    }
    if (receptId.present) {
      map['recept_id'] = Variable<int>(receptId.value);
    }
    if (receptSubid.present) {
      map['recept_subid'] = Variable<int>(receptSubid.value);
    }
    if (receptDate.present) {
      map['recept_date'] = Variable<DateTime>(receptDate.value);
    }
    if (receptNdoc.present) {
      map['recept_ndoc'] = Variable<String>(receptNdoc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoodsReturnStocksCompanion(')
          ..write('goodsId: $goodsId, ')
          ..write('returnActTypeId: $returnActTypeId, ')
          ..write('buyerId: $buyerId, ')
          ..write('vol: $vol, ')
          ..write('receptId: $receptId, ')
          ..write('receptSubid: $receptSubid, ')
          ..write('receptDate: $receptDate, ')
          ..write('receptNdoc: $receptNdoc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReturnActsTable extends ReturnActs
    with TableInfo<$ReturnActsTable, ReturnAct> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReturnActsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _guidMeta = const VerificationMeta('guid');
  @override
  late final GeneratedColumn<String> guid = GeneratedColumn<String>(
      'guid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted =
      GeneratedColumn<bool>('is_deleted', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_deleted" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _currentTimestampMeta =
      const VerificationMeta('currentTimestamp');
  @override
  late final GeneratedColumn<DateTime> currentTimestamp =
      GeneratedColumn<DateTime>('current_timestamp', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  static const VerificationMeta _lastSyncTimeMeta =
      const VerificationMeta('lastSyncTime');
  @override
  late final GeneratedColumn<DateTime> lastSyncTime = GeneratedColumn<DateTime>(
      'last_sync_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _needSyncMeta =
      const VerificationMeta('needSync');
  @override
  late final GeneratedColumn<bool> needSync = GeneratedColumn<bool>(
      'need_sync', aliasedName, false,
      generatedAs: GeneratedAs(
          (isNew & isDeleted.not()) |
              (isNew.not() & lastSyncTime.isSmallerThan(timestamp)),
          true),
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
        SqlDialect.sqlite: 'CHECK ("need_sync" IN (0, 1))',
        SqlDialect.mysql: '',
        SqlDialect.postgres: '',
      }));
  static const VerificationMeta _isNewMeta = const VerificationMeta('isNew');
  @override
  late final GeneratedColumn<bool> isNew =
      GeneratedColumn<bool>('is_new', aliasedName, false,
          generatedAs: GeneratedAs(lastSyncTime.isNull(), false),
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_new" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<String> number = GeneratedColumn<String>(
      'number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _buyerIdMeta =
      const VerificationMeta('buyerId');
  @override
  late final GeneratedColumn<int> buyerId = GeneratedColumn<int>(
      'buyer_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _needPickupMeta =
      const VerificationMeta('needPickup');
  @override
  late final GeneratedColumn<bool> needPickup =
      GeneratedColumn<bool>('need_pickup', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("need_pickup" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  static const VerificationMeta _returnActTypeIdMeta =
      const VerificationMeta('returnActTypeId');
  @override
  late final GeneratedColumn<int> returnActTypeId = GeneratedColumn<int>(
      'return_act_type_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _receptIdMeta =
      const VerificationMeta('receptId');
  @override
  late final GeneratedColumn<int> receptId = GeneratedColumn<int>(
      'recept_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _receptNdocMeta =
      const VerificationMeta('receptNdoc');
  @override
  late final GeneratedColumn<String> receptNdoc = GeneratedColumn<String>(
      'recept_ndoc', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _receptDateMeta =
      const VerificationMeta('receptDate');
  @override
  late final GeneratedColumn<DateTime> receptDate = GeneratedColumn<DateTime>(
      'recept_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        guid,
        isDeleted,
        timestamp,
        currentTimestamp,
        lastSyncTime,
        needSync,
        isNew,
        id,
        date,
        number,
        buyerId,
        needPickup,
        returnActTypeId,
        receptId,
        receptNdoc,
        receptDate
      ];
  @override
  String get aliasedName => _alias ?? 'return_acts';
  @override
  String get actualTableName => 'return_acts';
  @override
  VerificationContext validateIntegrity(Insertable<ReturnAct> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('guid')) {
      context.handle(
          _guidMeta, guid.isAcceptableOrUnknown(data['guid']!, _guidMeta));
    } else if (isInserting) {
      context.missing(_guidMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    }
    if (data.containsKey('current_timestamp')) {
      context.handle(
          _currentTimestampMeta,
          currentTimestamp.isAcceptableOrUnknown(
              data['current_timestamp']!, _currentTimestampMeta));
    }
    if (data.containsKey('last_sync_time')) {
      context.handle(
          _lastSyncTimeMeta,
          lastSyncTime.isAcceptableOrUnknown(
              data['last_sync_time']!, _lastSyncTimeMeta));
    }
    if (data.containsKey('need_sync')) {
      context.handle(_needSyncMeta,
          needSync.isAcceptableOrUnknown(data['need_sync']!, _needSyncMeta));
    }
    if (data.containsKey('is_new')) {
      context.handle(
          _isNewMeta, isNew.isAcceptableOrUnknown(data['is_new']!, _isNewMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('number')) {
      context.handle(_numberMeta,
          number.isAcceptableOrUnknown(data['number']!, _numberMeta));
    }
    if (data.containsKey('buyer_id')) {
      context.handle(_buyerIdMeta,
          buyerId.isAcceptableOrUnknown(data['buyer_id']!, _buyerIdMeta));
    }
    if (data.containsKey('need_pickup')) {
      context.handle(
          _needPickupMeta,
          needPickup.isAcceptableOrUnknown(
              data['need_pickup']!, _needPickupMeta));
    } else if (isInserting) {
      context.missing(_needPickupMeta);
    }
    if (data.containsKey('return_act_type_id')) {
      context.handle(
          _returnActTypeIdMeta,
          returnActTypeId.isAcceptableOrUnknown(
              data['return_act_type_id']!, _returnActTypeIdMeta));
    }
    if (data.containsKey('recept_id')) {
      context.handle(_receptIdMeta,
          receptId.isAcceptableOrUnknown(data['recept_id']!, _receptIdMeta));
    }
    if (data.containsKey('recept_ndoc')) {
      context.handle(
          _receptNdocMeta,
          receptNdoc.isAcceptableOrUnknown(
              data['recept_ndoc']!, _receptNdocMeta));
    }
    if (data.containsKey('recept_date')) {
      context.handle(
          _receptDateMeta,
          receptDate.isAcceptableOrUnknown(
              data['recept_date']!, _receptDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {guid};
  @override
  ReturnAct map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReturnAct(
      guid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guid'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      currentTimestamp: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}current_timestamp'])!,
      lastSyncTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_sync_time']),
      needSync: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}need_sync'])!,
      isNew: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_new'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date']),
      number: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}number']),
      buyerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}buyer_id']),
      needPickup: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}need_pickup'])!,
      returnActTypeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}return_act_type_id']),
      receptId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recept_id']),
      receptNdoc: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recept_ndoc']),
      receptDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}recept_date']),
    );
  }

  @override
  $ReturnActsTable createAlias(String alias) {
    return $ReturnActsTable(attachedDatabase, alias);
  }
}

class ReturnAct extends DataClass implements Insertable<ReturnAct> {
  final String guid;
  final bool isDeleted;
  final DateTime timestamp;
  final DateTime currentTimestamp;
  final DateTime? lastSyncTime;
  final bool needSync;
  final bool isNew;
  final int? id;
  final DateTime? date;
  final String? number;
  final int? buyerId;
  final bool needPickup;
  final int? returnActTypeId;
  final int? receptId;
  final String? receptNdoc;
  final DateTime? receptDate;
  const ReturnAct(
      {required this.guid,
      required this.isDeleted,
      required this.timestamp,
      required this.currentTimestamp,
      this.lastSyncTime,
      required this.needSync,
      required this.isNew,
      this.id,
      this.date,
      this.number,
      this.buyerId,
      required this.needPickup,
      this.returnActTypeId,
      this.receptId,
      this.receptNdoc,
      this.receptDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['guid'] = Variable<String>(guid);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['current_timestamp'] = Variable<DateTime>(currentTimestamp);
    if (!nullToAbsent || lastSyncTime != null) {
      map['last_sync_time'] = Variable<DateTime>(lastSyncTime);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    if (!nullToAbsent || number != null) {
      map['number'] = Variable<String>(number);
    }
    if (!nullToAbsent || buyerId != null) {
      map['buyer_id'] = Variable<int>(buyerId);
    }
    map['need_pickup'] = Variable<bool>(needPickup);
    if (!nullToAbsent || returnActTypeId != null) {
      map['return_act_type_id'] = Variable<int>(returnActTypeId);
    }
    if (!nullToAbsent || receptId != null) {
      map['recept_id'] = Variable<int>(receptId);
    }
    if (!nullToAbsent || receptNdoc != null) {
      map['recept_ndoc'] = Variable<String>(receptNdoc);
    }
    if (!nullToAbsent || receptDate != null) {
      map['recept_date'] = Variable<DateTime>(receptDate);
    }
    return map;
  }

  ReturnActsCompanion toCompanion(bool nullToAbsent) {
    return ReturnActsCompanion(
      guid: Value(guid),
      isDeleted: Value(isDeleted),
      timestamp: Value(timestamp),
      currentTimestamp: Value(currentTimestamp),
      lastSyncTime: lastSyncTime == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncTime),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      number:
          number == null && nullToAbsent ? const Value.absent() : Value(number),
      buyerId: buyerId == null && nullToAbsent
          ? const Value.absent()
          : Value(buyerId),
      needPickup: Value(needPickup),
      returnActTypeId: returnActTypeId == null && nullToAbsent
          ? const Value.absent()
          : Value(returnActTypeId),
      receptId: receptId == null && nullToAbsent
          ? const Value.absent()
          : Value(receptId),
      receptNdoc: receptNdoc == null && nullToAbsent
          ? const Value.absent()
          : Value(receptNdoc),
      receptDate: receptDate == null && nullToAbsent
          ? const Value.absent()
          : Value(receptDate),
    );
  }

  factory ReturnAct.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReturnAct(
      guid: serializer.fromJson<String>(json['guid']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      currentTimestamp: serializer.fromJson<DateTime>(json['currentTimestamp']),
      lastSyncTime: serializer.fromJson<DateTime?>(json['lastSyncTime']),
      needSync: serializer.fromJson<bool>(json['needSync']),
      isNew: serializer.fromJson<bool>(json['isNew']),
      id: serializer.fromJson<int?>(json['id']),
      date: serializer.fromJson<DateTime?>(json['date']),
      number: serializer.fromJson<String?>(json['number']),
      buyerId: serializer.fromJson<int?>(json['buyerId']),
      needPickup: serializer.fromJson<bool>(json['needPickup']),
      returnActTypeId: serializer.fromJson<int?>(json['returnActTypeId']),
      receptId: serializer.fromJson<int?>(json['receptId']),
      receptNdoc: serializer.fromJson<String?>(json['receptNdoc']),
      receptDate: serializer.fromJson<DateTime?>(json['receptDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'guid': serializer.toJson<String>(guid),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'currentTimestamp': serializer.toJson<DateTime>(currentTimestamp),
      'lastSyncTime': serializer.toJson<DateTime?>(lastSyncTime),
      'needSync': serializer.toJson<bool>(needSync),
      'isNew': serializer.toJson<bool>(isNew),
      'id': serializer.toJson<int?>(id),
      'date': serializer.toJson<DateTime?>(date),
      'number': serializer.toJson<String?>(number),
      'buyerId': serializer.toJson<int?>(buyerId),
      'needPickup': serializer.toJson<bool>(needPickup),
      'returnActTypeId': serializer.toJson<int?>(returnActTypeId),
      'receptId': serializer.toJson<int?>(receptId),
      'receptNdoc': serializer.toJson<String?>(receptNdoc),
      'receptDate': serializer.toJson<DateTime?>(receptDate),
    };
  }

  ReturnAct copyWith(
          {String? guid,
          bool? isDeleted,
          DateTime? timestamp,
          DateTime? currentTimestamp,
          Value<DateTime?> lastSyncTime = const Value.absent(),
          bool? needSync,
          bool? isNew,
          Value<int?> id = const Value.absent(),
          Value<DateTime?> date = const Value.absent(),
          Value<String?> number = const Value.absent(),
          Value<int?> buyerId = const Value.absent(),
          bool? needPickup,
          Value<int?> returnActTypeId = const Value.absent(),
          Value<int?> receptId = const Value.absent(),
          Value<String?> receptNdoc = const Value.absent(),
          Value<DateTime?> receptDate = const Value.absent()}) =>
      ReturnAct(
        guid: guid ?? this.guid,
        isDeleted: isDeleted ?? this.isDeleted,
        timestamp: timestamp ?? this.timestamp,
        currentTimestamp: currentTimestamp ?? this.currentTimestamp,
        lastSyncTime:
            lastSyncTime.present ? lastSyncTime.value : this.lastSyncTime,
        needSync: needSync ?? this.needSync,
        isNew: isNew ?? this.isNew,
        id: id.present ? id.value : this.id,
        date: date.present ? date.value : this.date,
        number: number.present ? number.value : this.number,
        buyerId: buyerId.present ? buyerId.value : this.buyerId,
        needPickup: needPickup ?? this.needPickup,
        returnActTypeId: returnActTypeId.present
            ? returnActTypeId.value
            : this.returnActTypeId,
        receptId: receptId.present ? receptId.value : this.receptId,
        receptNdoc: receptNdoc.present ? receptNdoc.value : this.receptNdoc,
        receptDate: receptDate.present ? receptDate.value : this.receptDate,
      );
  @override
  String toString() {
    return (StringBuffer('ReturnAct(')
          ..write('guid: $guid, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('timestamp: $timestamp, ')
          ..write('currentTimestamp: $currentTimestamp, ')
          ..write('lastSyncTime: $lastSyncTime, ')
          ..write('needSync: $needSync, ')
          ..write('isNew: $isNew, ')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('number: $number, ')
          ..write('buyerId: $buyerId, ')
          ..write('needPickup: $needPickup, ')
          ..write('returnActTypeId: $returnActTypeId, ')
          ..write('receptId: $receptId, ')
          ..write('receptNdoc: $receptNdoc, ')
          ..write('receptDate: $receptDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      guid,
      isDeleted,
      timestamp,
      currentTimestamp,
      lastSyncTime,
      needSync,
      isNew,
      id,
      date,
      number,
      buyerId,
      needPickup,
      returnActTypeId,
      receptId,
      receptNdoc,
      receptDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReturnAct &&
          other.guid == this.guid &&
          other.isDeleted == this.isDeleted &&
          other.timestamp == this.timestamp &&
          other.currentTimestamp == this.currentTimestamp &&
          other.lastSyncTime == this.lastSyncTime &&
          other.needSync == this.needSync &&
          other.isNew == this.isNew &&
          other.id == this.id &&
          other.date == this.date &&
          other.number == this.number &&
          other.buyerId == this.buyerId &&
          other.needPickup == this.needPickup &&
          other.returnActTypeId == this.returnActTypeId &&
          other.receptId == this.receptId &&
          other.receptNdoc == this.receptNdoc &&
          other.receptDate == this.receptDate);
}

class ReturnActsCompanion extends UpdateCompanion<ReturnAct> {
  final Value<String> guid;
  final Value<bool> isDeleted;
  final Value<DateTime> timestamp;
  final Value<DateTime> currentTimestamp;
  final Value<DateTime?> lastSyncTime;
  final Value<int?> id;
  final Value<DateTime?> date;
  final Value<String?> number;
  final Value<int?> buyerId;
  final Value<bool> needPickup;
  final Value<int?> returnActTypeId;
  final Value<int?> receptId;
  final Value<String?> receptNdoc;
  final Value<DateTime?> receptDate;
  final Value<int> rowid;
  const ReturnActsCompanion({
    this.guid = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.currentTimestamp = const Value.absent(),
    this.lastSyncTime = const Value.absent(),
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.number = const Value.absent(),
    this.buyerId = const Value.absent(),
    this.needPickup = const Value.absent(),
    this.returnActTypeId = const Value.absent(),
    this.receptId = const Value.absent(),
    this.receptNdoc = const Value.absent(),
    this.receptDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReturnActsCompanion.insert({
    required String guid,
    this.isDeleted = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.currentTimestamp = const Value.absent(),
    this.lastSyncTime = const Value.absent(),
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.number = const Value.absent(),
    this.buyerId = const Value.absent(),
    required bool needPickup,
    this.returnActTypeId = const Value.absent(),
    this.receptId = const Value.absent(),
    this.receptNdoc = const Value.absent(),
    this.receptDate = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : guid = Value(guid),
        needPickup = Value(needPickup);
  static Insertable<ReturnAct> custom({
    Expression<String>? guid,
    Expression<bool>? isDeleted,
    Expression<DateTime>? timestamp,
    Expression<DateTime>? currentTimestamp,
    Expression<DateTime>? lastSyncTime,
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? number,
    Expression<int>? buyerId,
    Expression<bool>? needPickup,
    Expression<int>? returnActTypeId,
    Expression<int>? receptId,
    Expression<String>? receptNdoc,
    Expression<DateTime>? receptDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (guid != null) 'guid': guid,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (timestamp != null) 'timestamp': timestamp,
      if (currentTimestamp != null) 'current_timestamp': currentTimestamp,
      if (lastSyncTime != null) 'last_sync_time': lastSyncTime,
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (number != null) 'number': number,
      if (buyerId != null) 'buyer_id': buyerId,
      if (needPickup != null) 'need_pickup': needPickup,
      if (returnActTypeId != null) 'return_act_type_id': returnActTypeId,
      if (receptId != null) 'recept_id': receptId,
      if (receptNdoc != null) 'recept_ndoc': receptNdoc,
      if (receptDate != null) 'recept_date': receptDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReturnActsCompanion copyWith(
      {Value<String>? guid,
      Value<bool>? isDeleted,
      Value<DateTime>? timestamp,
      Value<DateTime>? currentTimestamp,
      Value<DateTime?>? lastSyncTime,
      Value<int?>? id,
      Value<DateTime?>? date,
      Value<String?>? number,
      Value<int?>? buyerId,
      Value<bool>? needPickup,
      Value<int?>? returnActTypeId,
      Value<int?>? receptId,
      Value<String?>? receptNdoc,
      Value<DateTime?>? receptDate,
      Value<int>? rowid}) {
    return ReturnActsCompanion(
      guid: guid ?? this.guid,
      isDeleted: isDeleted ?? this.isDeleted,
      timestamp: timestamp ?? this.timestamp,
      currentTimestamp: currentTimestamp ?? this.currentTimestamp,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      id: id ?? this.id,
      date: date ?? this.date,
      number: number ?? this.number,
      buyerId: buyerId ?? this.buyerId,
      needPickup: needPickup ?? this.needPickup,
      returnActTypeId: returnActTypeId ?? this.returnActTypeId,
      receptId: receptId ?? this.receptId,
      receptNdoc: receptNdoc ?? this.receptNdoc,
      receptDate: receptDate ?? this.receptDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (guid.present) {
      map['guid'] = Variable<String>(guid.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (currentTimestamp.present) {
      map['current_timestamp'] = Variable<DateTime>(currentTimestamp.value);
    }
    if (lastSyncTime.present) {
      map['last_sync_time'] = Variable<DateTime>(lastSyncTime.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (number.present) {
      map['number'] = Variable<String>(number.value);
    }
    if (buyerId.present) {
      map['buyer_id'] = Variable<int>(buyerId.value);
    }
    if (needPickup.present) {
      map['need_pickup'] = Variable<bool>(needPickup.value);
    }
    if (returnActTypeId.present) {
      map['return_act_type_id'] = Variable<int>(returnActTypeId.value);
    }
    if (receptId.present) {
      map['recept_id'] = Variable<int>(receptId.value);
    }
    if (receptNdoc.present) {
      map['recept_ndoc'] = Variable<String>(receptNdoc.value);
    }
    if (receptDate.present) {
      map['recept_date'] = Variable<DateTime>(receptDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReturnActsCompanion(')
          ..write('guid: $guid, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('timestamp: $timestamp, ')
          ..write('currentTimestamp: $currentTimestamp, ')
          ..write('lastSyncTime: $lastSyncTime, ')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('number: $number, ')
          ..write('buyerId: $buyerId, ')
          ..write('needPickup: $needPickup, ')
          ..write('returnActTypeId: $returnActTypeId, ')
          ..write('receptId: $receptId, ')
          ..write('receptNdoc: $receptNdoc, ')
          ..write('receptDate: $receptDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReturnActLinesTable extends ReturnActLines
    with TableInfo<$ReturnActLinesTable, ReturnActLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReturnActLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _guidMeta = const VerificationMeta('guid');
  @override
  late final GeneratedColumn<String> guid = GeneratedColumn<String>(
      'guid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted =
      GeneratedColumn<bool>('is_deleted', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_deleted" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _currentTimestampMeta =
      const VerificationMeta('currentTimestamp');
  @override
  late final GeneratedColumn<DateTime> currentTimestamp =
      GeneratedColumn<DateTime>('current_timestamp', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  static const VerificationMeta _lastSyncTimeMeta =
      const VerificationMeta('lastSyncTime');
  @override
  late final GeneratedColumn<DateTime> lastSyncTime = GeneratedColumn<DateTime>(
      'last_sync_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _needSyncMeta =
      const VerificationMeta('needSync');
  @override
  late final GeneratedColumn<bool> needSync = GeneratedColumn<bool>(
      'need_sync', aliasedName, false,
      generatedAs: GeneratedAs(
          (isNew & isDeleted.not()) |
              (isNew.not() & lastSyncTime.isSmallerThan(timestamp)),
          true),
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
        SqlDialect.sqlite: 'CHECK ("need_sync" IN (0, 1))',
        SqlDialect.mysql: '',
        SqlDialect.postgres: '',
      }));
  static const VerificationMeta _isNewMeta = const VerificationMeta('isNew');
  @override
  late final GeneratedColumn<bool> isNew =
      GeneratedColumn<bool>('is_new', aliasedName, false,
          generatedAs: GeneratedAs(lastSyncTime.isNull(), false),
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_new" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _returnActGuidMeta =
      const VerificationMeta('returnActGuid');
  @override
  late final GeneratedColumn<String> returnActGuid = GeneratedColumn<String>(
      'return_act_guid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES return_acts (guid) ON UPDATE CASCADE ON DELETE CASCADE'));
  static const VerificationMeta _goodsIdMeta =
      const VerificationMeta('goodsId');
  @override
  late final GeneratedColumn<int> goodsId = GeneratedColumn<int>(
      'goods_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _volMeta = const VerificationMeta('vol');
  @override
  late final GeneratedColumn<double> vol = GeneratedColumn<double>(
      'vol', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _productionDateMeta =
      const VerificationMeta('productionDate');
  @override
  late final GeneratedColumn<DateTime> productionDate =
      GeneratedColumn<DateTime>('production_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isBadMeta = const VerificationMeta('isBad');
  @override
  late final GeneratedColumn<bool> isBad =
      GeneratedColumn<bool>('is_bad', aliasedName, true,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_bad" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  @override
  List<GeneratedColumn> get $columns => [
        guid,
        isDeleted,
        timestamp,
        currentTimestamp,
        lastSyncTime,
        needSync,
        isNew,
        id,
        returnActGuid,
        goodsId,
        vol,
        productionDate,
        isBad
      ];
  @override
  String get aliasedName => _alias ?? 'return_act_lines';
  @override
  String get actualTableName => 'return_act_lines';
  @override
  VerificationContext validateIntegrity(Insertable<ReturnActLine> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('guid')) {
      context.handle(
          _guidMeta, guid.isAcceptableOrUnknown(data['guid']!, _guidMeta));
    } else if (isInserting) {
      context.missing(_guidMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    }
    if (data.containsKey('current_timestamp')) {
      context.handle(
          _currentTimestampMeta,
          currentTimestamp.isAcceptableOrUnknown(
              data['current_timestamp']!, _currentTimestampMeta));
    }
    if (data.containsKey('last_sync_time')) {
      context.handle(
          _lastSyncTimeMeta,
          lastSyncTime.isAcceptableOrUnknown(
              data['last_sync_time']!, _lastSyncTimeMeta));
    }
    if (data.containsKey('need_sync')) {
      context.handle(_needSyncMeta,
          needSync.isAcceptableOrUnknown(data['need_sync']!, _needSyncMeta));
    }
    if (data.containsKey('is_new')) {
      context.handle(
          _isNewMeta, isNew.isAcceptableOrUnknown(data['is_new']!, _isNewMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('return_act_guid')) {
      context.handle(
          _returnActGuidMeta,
          returnActGuid.isAcceptableOrUnknown(
              data['return_act_guid']!, _returnActGuidMeta));
    } else if (isInserting) {
      context.missing(_returnActGuidMeta);
    }
    if (data.containsKey('goods_id')) {
      context.handle(_goodsIdMeta,
          goodsId.isAcceptableOrUnknown(data['goods_id']!, _goodsIdMeta));
    } else if (isInserting) {
      context.missing(_goodsIdMeta);
    }
    if (data.containsKey('vol')) {
      context.handle(
          _volMeta, vol.isAcceptableOrUnknown(data['vol']!, _volMeta));
    } else if (isInserting) {
      context.missing(_volMeta);
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
  Set<GeneratedColumn> get $primaryKey => {guid};
  @override
  ReturnActLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReturnActLine(
      guid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guid'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      currentTimestamp: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}current_timestamp'])!,
      lastSyncTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_sync_time']),
      needSync: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}need_sync'])!,
      isNew: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_new'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id']),
      returnActGuid: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}return_act_guid'])!,
      goodsId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}goods_id'])!,
      vol: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}vol'])!,
      productionDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}production_date']),
      isBad: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_bad']),
    );
  }

  @override
  $ReturnActLinesTable createAlias(String alias) {
    return $ReturnActLinesTable(attachedDatabase, alias);
  }
}

class ReturnActLine extends DataClass implements Insertable<ReturnActLine> {
  final String guid;
  final bool isDeleted;
  final DateTime timestamp;
  final DateTime currentTimestamp;
  final DateTime? lastSyncTime;
  final bool needSync;
  final bool isNew;
  final int? id;
  final String returnActGuid;
  final int goodsId;
  final double vol;
  final DateTime? productionDate;
  final bool? isBad;
  const ReturnActLine(
      {required this.guid,
      required this.isDeleted,
      required this.timestamp,
      required this.currentTimestamp,
      this.lastSyncTime,
      required this.needSync,
      required this.isNew,
      this.id,
      required this.returnActGuid,
      required this.goodsId,
      required this.vol,
      this.productionDate,
      this.isBad});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['guid'] = Variable<String>(guid);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['current_timestamp'] = Variable<DateTime>(currentTimestamp);
    if (!nullToAbsent || lastSyncTime != null) {
      map['last_sync_time'] = Variable<DateTime>(lastSyncTime);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    map['return_act_guid'] = Variable<String>(returnActGuid);
    map['goods_id'] = Variable<int>(goodsId);
    map['vol'] = Variable<double>(vol);
    if (!nullToAbsent || productionDate != null) {
      map['production_date'] = Variable<DateTime>(productionDate);
    }
    if (!nullToAbsent || isBad != null) {
      map['is_bad'] = Variable<bool>(isBad);
    }
    return map;
  }

  ReturnActLinesCompanion toCompanion(bool nullToAbsent) {
    return ReturnActLinesCompanion(
      guid: Value(guid),
      isDeleted: Value(isDeleted),
      timestamp: Value(timestamp),
      currentTimestamp: Value(currentTimestamp),
      lastSyncTime: lastSyncTime == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncTime),
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      returnActGuid: Value(returnActGuid),
      goodsId: Value(goodsId),
      vol: Value(vol),
      productionDate: productionDate == null && nullToAbsent
          ? const Value.absent()
          : Value(productionDate),
      isBad:
          isBad == null && nullToAbsent ? const Value.absent() : Value(isBad),
    );
  }

  factory ReturnActLine.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReturnActLine(
      guid: serializer.fromJson<String>(json['guid']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      currentTimestamp: serializer.fromJson<DateTime>(json['currentTimestamp']),
      lastSyncTime: serializer.fromJson<DateTime?>(json['lastSyncTime']),
      needSync: serializer.fromJson<bool>(json['needSync']),
      isNew: serializer.fromJson<bool>(json['isNew']),
      id: serializer.fromJson<int?>(json['id']),
      returnActGuid: serializer.fromJson<String>(json['returnActGuid']),
      goodsId: serializer.fromJson<int>(json['goodsId']),
      vol: serializer.fromJson<double>(json['vol']),
      productionDate: serializer.fromJson<DateTime?>(json['productionDate']),
      isBad: serializer.fromJson<bool?>(json['isBad']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'guid': serializer.toJson<String>(guid),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'currentTimestamp': serializer.toJson<DateTime>(currentTimestamp),
      'lastSyncTime': serializer.toJson<DateTime?>(lastSyncTime),
      'needSync': serializer.toJson<bool>(needSync),
      'isNew': serializer.toJson<bool>(isNew),
      'id': serializer.toJson<int?>(id),
      'returnActGuid': serializer.toJson<String>(returnActGuid),
      'goodsId': serializer.toJson<int>(goodsId),
      'vol': serializer.toJson<double>(vol),
      'productionDate': serializer.toJson<DateTime?>(productionDate),
      'isBad': serializer.toJson<bool?>(isBad),
    };
  }

  ReturnActLine copyWith(
          {String? guid,
          bool? isDeleted,
          DateTime? timestamp,
          DateTime? currentTimestamp,
          Value<DateTime?> lastSyncTime = const Value.absent(),
          bool? needSync,
          bool? isNew,
          Value<int?> id = const Value.absent(),
          String? returnActGuid,
          int? goodsId,
          double? vol,
          Value<DateTime?> productionDate = const Value.absent(),
          Value<bool?> isBad = const Value.absent()}) =>
      ReturnActLine(
        guid: guid ?? this.guid,
        isDeleted: isDeleted ?? this.isDeleted,
        timestamp: timestamp ?? this.timestamp,
        currentTimestamp: currentTimestamp ?? this.currentTimestamp,
        lastSyncTime:
            lastSyncTime.present ? lastSyncTime.value : this.lastSyncTime,
        needSync: needSync ?? this.needSync,
        isNew: isNew ?? this.isNew,
        id: id.present ? id.value : this.id,
        returnActGuid: returnActGuid ?? this.returnActGuid,
        goodsId: goodsId ?? this.goodsId,
        vol: vol ?? this.vol,
        productionDate:
            productionDate.present ? productionDate.value : this.productionDate,
        isBad: isBad.present ? isBad.value : this.isBad,
      );
  @override
  String toString() {
    return (StringBuffer('ReturnActLine(')
          ..write('guid: $guid, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('timestamp: $timestamp, ')
          ..write('currentTimestamp: $currentTimestamp, ')
          ..write('lastSyncTime: $lastSyncTime, ')
          ..write('needSync: $needSync, ')
          ..write('isNew: $isNew, ')
          ..write('id: $id, ')
          ..write('returnActGuid: $returnActGuid, ')
          ..write('goodsId: $goodsId, ')
          ..write('vol: $vol, ')
          ..write('productionDate: $productionDate, ')
          ..write('isBad: $isBad')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      guid,
      isDeleted,
      timestamp,
      currentTimestamp,
      lastSyncTime,
      needSync,
      isNew,
      id,
      returnActGuid,
      goodsId,
      vol,
      productionDate,
      isBad);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReturnActLine &&
          other.guid == this.guid &&
          other.isDeleted == this.isDeleted &&
          other.timestamp == this.timestamp &&
          other.currentTimestamp == this.currentTimestamp &&
          other.lastSyncTime == this.lastSyncTime &&
          other.needSync == this.needSync &&
          other.isNew == this.isNew &&
          other.id == this.id &&
          other.returnActGuid == this.returnActGuid &&
          other.goodsId == this.goodsId &&
          other.vol == this.vol &&
          other.productionDate == this.productionDate &&
          other.isBad == this.isBad);
}

class ReturnActLinesCompanion extends UpdateCompanion<ReturnActLine> {
  final Value<String> guid;
  final Value<bool> isDeleted;
  final Value<DateTime> timestamp;
  final Value<DateTime> currentTimestamp;
  final Value<DateTime?> lastSyncTime;
  final Value<int?> id;
  final Value<String> returnActGuid;
  final Value<int> goodsId;
  final Value<double> vol;
  final Value<DateTime?> productionDate;
  final Value<bool?> isBad;
  final Value<int> rowid;
  const ReturnActLinesCompanion({
    this.guid = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.currentTimestamp = const Value.absent(),
    this.lastSyncTime = const Value.absent(),
    this.id = const Value.absent(),
    this.returnActGuid = const Value.absent(),
    this.goodsId = const Value.absent(),
    this.vol = const Value.absent(),
    this.productionDate = const Value.absent(),
    this.isBad = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReturnActLinesCompanion.insert({
    required String guid,
    this.isDeleted = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.currentTimestamp = const Value.absent(),
    this.lastSyncTime = const Value.absent(),
    this.id = const Value.absent(),
    required String returnActGuid,
    required int goodsId,
    required double vol,
    this.productionDate = const Value.absent(),
    this.isBad = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : guid = Value(guid),
        returnActGuid = Value(returnActGuid),
        goodsId = Value(goodsId),
        vol = Value(vol);
  static Insertable<ReturnActLine> custom({
    Expression<String>? guid,
    Expression<bool>? isDeleted,
    Expression<DateTime>? timestamp,
    Expression<DateTime>? currentTimestamp,
    Expression<DateTime>? lastSyncTime,
    Expression<int>? id,
    Expression<String>? returnActGuid,
    Expression<int>? goodsId,
    Expression<double>? vol,
    Expression<DateTime>? productionDate,
    Expression<bool>? isBad,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (guid != null) 'guid': guid,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (timestamp != null) 'timestamp': timestamp,
      if (currentTimestamp != null) 'current_timestamp': currentTimestamp,
      if (lastSyncTime != null) 'last_sync_time': lastSyncTime,
      if (id != null) 'id': id,
      if (returnActGuid != null) 'return_act_guid': returnActGuid,
      if (goodsId != null) 'goods_id': goodsId,
      if (vol != null) 'vol': vol,
      if (productionDate != null) 'production_date': productionDate,
      if (isBad != null) 'is_bad': isBad,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReturnActLinesCompanion copyWith(
      {Value<String>? guid,
      Value<bool>? isDeleted,
      Value<DateTime>? timestamp,
      Value<DateTime>? currentTimestamp,
      Value<DateTime?>? lastSyncTime,
      Value<int?>? id,
      Value<String>? returnActGuid,
      Value<int>? goodsId,
      Value<double>? vol,
      Value<DateTime?>? productionDate,
      Value<bool?>? isBad,
      Value<int>? rowid}) {
    return ReturnActLinesCompanion(
      guid: guid ?? this.guid,
      isDeleted: isDeleted ?? this.isDeleted,
      timestamp: timestamp ?? this.timestamp,
      currentTimestamp: currentTimestamp ?? this.currentTimestamp,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      id: id ?? this.id,
      returnActGuid: returnActGuid ?? this.returnActGuid,
      goodsId: goodsId ?? this.goodsId,
      vol: vol ?? this.vol,
      productionDate: productionDate ?? this.productionDate,
      isBad: isBad ?? this.isBad,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (guid.present) {
      map['guid'] = Variable<String>(guid.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (currentTimestamp.present) {
      map['current_timestamp'] = Variable<DateTime>(currentTimestamp.value);
    }
    if (lastSyncTime.present) {
      map['last_sync_time'] = Variable<DateTime>(lastSyncTime.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (returnActGuid.present) {
      map['return_act_guid'] = Variable<String>(returnActGuid.value);
    }
    if (goodsId.present) {
      map['goods_id'] = Variable<int>(goodsId.value);
    }
    if (vol.present) {
      map['vol'] = Variable<double>(vol.value);
    }
    if (productionDate.present) {
      map['production_date'] = Variable<DateTime>(productionDate.value);
    }
    if (isBad.present) {
      map['is_bad'] = Variable<bool>(isBad.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReturnActLinesCompanion(')
          ..write('guid: $guid, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('timestamp: $timestamp, ')
          ..write('currentTimestamp: $currentTimestamp, ')
          ..write('lastSyncTime: $lastSyncTime, ')
          ..write('id: $id, ')
          ..write('returnActGuid: $returnActGuid, ')
          ..write('goodsId: $goodsId, ')
          ..write('vol: $vol, ')
          ..write('productionDate: $productionDate, ')
          ..write('isBad: $isBad, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReturnActTypesTable extends ReturnActTypes
    with TableInfo<$ReturnActTypesTable, ReturnActType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReturnActTypesTable(this.attachedDatabase, [this._alias]);
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
  String get aliasedName => _alias ?? 'return_act_types';
  @override
  String get actualTableName => 'return_act_types';
  @override
  VerificationContext validateIntegrity(Insertable<ReturnActType> instance,
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
  ReturnActType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReturnActType(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $ReturnActTypesTable createAlias(String alias) {
    return $ReturnActTypesTable(attachedDatabase, alias);
  }
}

class ReturnActType extends DataClass implements Insertable<ReturnActType> {
  final int id;
  final String name;
  const ReturnActType({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  ReturnActTypesCompanion toCompanion(bool nullToAbsent) {
    return ReturnActTypesCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory ReturnActType.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReturnActType(
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

  ReturnActType copyWith({int? id, String? name}) => ReturnActType(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('ReturnActType(')
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
      (other is ReturnActType &&
          other.id == this.id &&
          other.name == this.name);
}

class ReturnActTypesCompanion extends UpdateCompanion<ReturnActType> {
  final Value<int> id;
  final Value<String> name;
  const ReturnActTypesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  ReturnActTypesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<ReturnActType> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  ReturnActTypesCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return ReturnActTypesCompanion(
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
    return (StringBuffer('ReturnActTypesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $PartnersReturnActTypesTable extends PartnersReturnActTypes
    with TableInfo<$PartnersReturnActTypesTable, PartnersReturnActType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartnersReturnActTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _returnActTypeIdMeta =
      const VerificationMeta('returnActTypeId');
  @override
  late final GeneratedColumn<int> returnActTypeId = GeneratedColumn<int>(
      'return_act_type_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _partnerIdMeta =
      const VerificationMeta('partnerId');
  @override
  late final GeneratedColumn<int> partnerId = GeneratedColumn<int>(
      'partner_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [returnActTypeId, partnerId];
  @override
  String get aliasedName => _alias ?? 'partners_return_act_types';
  @override
  String get actualTableName => 'partners_return_act_types';
  @override
  VerificationContext validateIntegrity(
      Insertable<PartnersReturnActType> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('return_act_type_id')) {
      context.handle(
          _returnActTypeIdMeta,
          returnActTypeId.isAcceptableOrUnknown(
              data['return_act_type_id']!, _returnActTypeIdMeta));
    } else if (isInserting) {
      context.missing(_returnActTypeIdMeta);
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
  Set<GeneratedColumn> get $primaryKey => {returnActTypeId, partnerId};
  @override
  PartnersReturnActType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartnersReturnActType(
      returnActTypeId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}return_act_type_id'])!,
      partnerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}partner_id'])!,
    );
  }

  @override
  $PartnersReturnActTypesTable createAlias(String alias) {
    return $PartnersReturnActTypesTable(attachedDatabase, alias);
  }
}

class PartnersReturnActType extends DataClass
    implements Insertable<PartnersReturnActType> {
  final int returnActTypeId;
  final int partnerId;
  const PartnersReturnActType(
      {required this.returnActTypeId, required this.partnerId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['return_act_type_id'] = Variable<int>(returnActTypeId);
    map['partner_id'] = Variable<int>(partnerId);
    return map;
  }

  PartnersReturnActTypesCompanion toCompanion(bool nullToAbsent) {
    return PartnersReturnActTypesCompanion(
      returnActTypeId: Value(returnActTypeId),
      partnerId: Value(partnerId),
    );
  }

  factory PartnersReturnActType.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartnersReturnActType(
      returnActTypeId: serializer.fromJson<int>(json['returnActTypeId']),
      partnerId: serializer.fromJson<int>(json['partnerId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'returnActTypeId': serializer.toJson<int>(returnActTypeId),
      'partnerId': serializer.toJson<int>(partnerId),
    };
  }

  PartnersReturnActType copyWith({int? returnActTypeId, int? partnerId}) =>
      PartnersReturnActType(
        returnActTypeId: returnActTypeId ?? this.returnActTypeId,
        partnerId: partnerId ?? this.partnerId,
      );
  @override
  String toString() {
    return (StringBuffer('PartnersReturnActType(')
          ..write('returnActTypeId: $returnActTypeId, ')
          ..write('partnerId: $partnerId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(returnActTypeId, partnerId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartnersReturnActType &&
          other.returnActTypeId == this.returnActTypeId &&
          other.partnerId == this.partnerId);
}

class PartnersReturnActTypesCompanion
    extends UpdateCompanion<PartnersReturnActType> {
  final Value<int> returnActTypeId;
  final Value<int> partnerId;
  final Value<int> rowid;
  const PartnersReturnActTypesCompanion({
    this.returnActTypeId = const Value.absent(),
    this.partnerId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PartnersReturnActTypesCompanion.insert({
    required int returnActTypeId,
    required int partnerId,
    this.rowid = const Value.absent(),
  })  : returnActTypeId = Value(returnActTypeId),
        partnerId = Value(partnerId);
  static Insertable<PartnersReturnActType> custom({
    Expression<int>? returnActTypeId,
    Expression<int>? partnerId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (returnActTypeId != null) 'return_act_type_id': returnActTypeId,
      if (partnerId != null) 'partner_id': partnerId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PartnersReturnActTypesCompanion copyWith(
      {Value<int>? returnActTypeId, Value<int>? partnerId, Value<int>? rowid}) {
    return PartnersReturnActTypesCompanion(
      returnActTypeId: returnActTypeId ?? this.returnActTypeId,
      partnerId: partnerId ?? this.partnerId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (returnActTypeId.present) {
      map['return_act_type_id'] = Variable<int>(returnActTypeId.value);
    }
    if (partnerId.present) {
      map['partner_id'] = Variable<int>(partnerId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartnersReturnActTypesCompanion(')
          ..write('returnActTypeId: $returnActTypeId, ')
          ..write('partnerId: $partnerId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDataStore extends GeneratedDatabase {
  _$AppDataStore(QueryExecutor e) : super(e);
  late final $UsersTable users = $UsersTable(this);
  late final $PrefsTable prefs = $PrefsTable(this);
  late final $BuyersTable buyers = $BuyersTable(this);
  late final $PartnersTable partners = $PartnersTable(this);
  late final $LocationsTable locations = $LocationsTable(this);
  late final $PointFormatsTable pointFormats = $PointFormatsTable(this);
  late final $PointsTable points = $PointsTable(this);
  late final $PointImagesTable pointImages = $PointImagesTable(this);
  late final $DepositsTable deposits = $DepositsTable(this);
  late final $EncashmentsTable encashments = $EncashmentsTable(this);
  late final $DebtsTable debts = $DebtsTable(this);
  late final $ShipmentsTable shipments = $ShipmentsTable(this);
  late final $ShipmentLinesTable shipmentLines = $ShipmentLinesTable(this);
  late final $IncRequestsTable incRequests = $IncRequestsTable(this);
  late final $AllGoodsTable allGoods = $AllGoodsTable(this);
  late final $WorkdatesTable workdates = $WorkdatesTable(this);
  late final $ShopDepartmentsTable shopDepartments =
      $ShopDepartmentsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $GoodsFiltersTable goodsFilters = $GoodsFiltersTable(this);
  late final $OrdersTable orders = $OrdersTable(this);
  late final $OrderLinesTable orderLines = $OrderLinesTable(this);
  late final $PreOrdersTable preOrders = $PreOrdersTable(this);
  late final $PreOrderLinesTable preOrderLines = $PreOrderLinesTable(this);
  late final $SeenPreOrdersTable seenPreOrders = $SeenPreOrdersTable(this);
  late final $BonusProgramGroupsTable bonusProgramGroups =
      $BonusProgramGroupsTable(this);
  late final $BonusProgramsTable bonusPrograms = $BonusProgramsTable(this);
  late final $BuyersSetsTable buyersSets = $BuyersSetsTable(this);
  late final $BuyersSetsBonusProgramsTable buyersSetsBonusPrograms =
      $BuyersSetsBonusProgramsTable(this);
  late final $BuyersSetsBuyersTable buyersSetsBuyers =
      $BuyersSetsBuyersTable(this);
  late final $GoodsBonusProgramsTable goodsBonusPrograms =
      $GoodsBonusProgramsTable(this);
  late final $GoodsBonusProgramPricesTable goodsBonusProgramPrices =
      $GoodsBonusProgramPricesTable(this);
  late final $PricelistsTable pricelists = $PricelistsTable(this);
  late final $PricelistSetCategoriesTable pricelistSetCategories =
      $PricelistSetCategoriesTable(this);
  late final $PartnersPricesTable partnersPrices = $PartnersPricesTable(this);
  late final $PricelistPricesTable pricelistPrices =
      $PricelistPricesTable(this);
  late final $PartnersPricelistsTable partnersPricelists =
      $PartnersPricelistsTable(this);
  late final $GoodsRestrictionsTable goodsRestrictions =
      $GoodsRestrictionsTable(this);
  late final $GoodsStocksTable goodsStocks = $GoodsStocksTable(this);
  late final $GoodsPartnersPricelistsTable goodsPartnersPricelists =
      $GoodsPartnersPricelistsTable(this);
  late final $GoodsReturnStocksTable goodsReturnStocks =
      $GoodsReturnStocksTable(this);
  late final $ReturnActsTable returnActs = $ReturnActsTable(this);
  late final $ReturnActLinesTable returnActLines = $ReturnActLinesTable(this);
  late final $ReturnActTypesTable returnActTypes = $ReturnActTypesTable(this);
  late final $PartnersReturnActTypesTable partnersReturnActTypes =
      $PartnersReturnActTypesTable(this);
  late final BonusProgramsDao bonusProgramsDao =
      BonusProgramsDao(this as AppDataStore);
  late final DebtsDao debtsDao = DebtsDao(this as AppDataStore);
  late final OrdersDao ordersDao = OrdersDao(this as AppDataStore);
  late final PartnersDao partnersDao = PartnersDao(this as AppDataStore);
  late final PointsDao pointsDao = PointsDao(this as AppDataStore);
  late final PricesDao pricesDao = PricesDao(this as AppDataStore);
  late final ShipmentsDao shipmentsDao = ShipmentsDao(this as AppDataStore);
  late final ReturnActsDao returnActsDao = ReturnActsDao(this as AppDataStore);
  late final UsersDao usersDao = UsersDao(this as AppDataStore);
  Selectable<AppInfoResult> appInfo() {
    return customSelect(
        'SELECT prefs.*, (SELECT COUNT(*) FROM points WHERE need_sync = 1 OR EXISTS (SELECT 1 FROM point_images WHERE point_guid = points.guid AND need_sync = 1)) AS points_to_sync, (SELECT COUNT(*) FROM deposits WHERE need_sync = 1 OR EXISTS (SELECT 1 FROM encashments WHERE deposit_guid = deposits.guid AND need_sync = 1)) AS deposits_to_sync, (SELECT COUNT(*) FROM orders WHERE need_sync = 1 OR EXISTS (SELECT 1 FROM order_lines WHERE order_guid = orders.guid AND need_sync = 1)) AS orders_to_sync, (SELECT COUNT(*) FROM return_acts WHERE need_sync = 1 OR EXISTS (SELECT 1 FROM return_act_lines WHERE return_act_guid = return_acts.guid AND need_sync = 1)) AS return_acts_to_sync, (SELECT COUNT(*) FROM inc_requests WHERE need_sync = 1) AS inc_requests_to_sync, (SELECT COUNT(*) FROM partners_prices WHERE need_sync = 1) AS partner_prices_to_sync, (SELECT COUNT(*) FROM partners_pricelists WHERE need_sync = 1) AS partners_pricelists_to_sync, (SELECT COUNT(*) FROM points) AS points_total, (SELECT COUNT(*) FROM encashments) AS encashments_total, (SELECT COUNT(*) FROM shipments) AS shipments_total, (SELECT COUNT(*) FROM orders) AS orders_total, (SELECT COUNT(*) FROM pre_orders) AS pre_orders_total, (SELECT COUNT(*) FROM return_acts) AS return_acts_total FROM prefs',
        variables: [],
        readsFrom: {
          points,
          pointImages,
          deposits,
          encashments,
          orders,
          orderLines,
          returnActs,
          returnActLines,
          incRequests,
          partnersPrices,
          partnersPricelists,
          shipments,
          preOrders,
          prefs,
        }).map((QueryRow row) {
      return AppInfoResult(
        showLocalImage: row.read<bool>('show_local_image'),
        showWithPrice: row.read<bool>('show_with_price'),
        lastLoadTime: row.readNullable<DateTime>('last_load_time'),
        pointsToSync: row.read<int>('points_to_sync'),
        depositsToSync: row.read<int>('deposits_to_sync'),
        ordersToSync: row.read<int>('orders_to_sync'),
        returnActsToSync: row.read<int>('return_acts_to_sync'),
        incRequestsToSync: row.read<int>('inc_requests_to_sync'),
        partnerPricesToSync: row.read<int>('partner_prices_to_sync'),
        partnersPricelistsToSync: row.read<int>('partners_pricelists_to_sync'),
        pointsTotal: row.read<int>('points_total'),
        encashmentsTotal: row.read<int>('encashments_total'),
        shipmentsTotal: row.read<int>('shipments_total'),
        ordersTotal: row.read<int>('orders_total'),
        preOrdersTotal: row.read<int>('pre_orders_total'),
        returnActsTotal: row.read<int>('return_acts_total'),
      );
    });
  }

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        users,
        prefs,
        buyers,
        partners,
        locations,
        pointFormats,
        points,
        pointImages,
        deposits,
        encashments,
        debts,
        shipments,
        shipmentLines,
        incRequests,
        allGoods,
        workdates,
        shopDepartments,
        categories,
        goodsFilters,
        orders,
        orderLines,
        preOrders,
        preOrderLines,
        seenPreOrders,
        bonusProgramGroups,
        bonusPrograms,
        buyersSets,
        buyersSetsBonusPrograms,
        buyersSetsBuyers,
        goodsBonusPrograms,
        goodsBonusProgramPrices,
        pricelists,
        pricelistSetCategories,
        partnersPrices,
        pricelistPrices,
        partnersPricelists,
        goodsRestrictions,
        goodsStocks,
        goodsPartnersPricelists,
        goodsReturnStocks,
        returnActs,
        returnActLines,
        returnActTypes,
        partnersReturnActTypes
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('points',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('point_images', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('points',
                limitUpdateKind: UpdateKind.update),
            result: [
              TableUpdate('point_images', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('deposits',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('encashments', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('deposits',
                limitUpdateKind: UpdateKind.update),
            result: [
              TableUpdate('encashments', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('orders',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('order_lines', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('orders',
                limitUpdateKind: UpdateKind.update),
            result: [
              TableUpdate('order_lines', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('return_acts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('return_act_lines', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('return_acts',
                limitUpdateKind: UpdateKind.update),
            result: [
              TableUpdate('return_act_lines', kind: UpdateKind.update),
            ],
          ),
        ],
      );
}

class AppInfoResult {
  final bool showLocalImage;
  final bool showWithPrice;
  final DateTime? lastLoadTime;
  final int pointsToSync;
  final int depositsToSync;
  final int ordersToSync;
  final int returnActsToSync;
  final int incRequestsToSync;
  final int partnerPricesToSync;
  final int partnersPricelistsToSync;
  final int pointsTotal;
  final int encashmentsTotal;
  final int shipmentsTotal;
  final int ordersTotal;
  final int preOrdersTotal;
  final int returnActsTotal;
  AppInfoResult({
    required this.showLocalImage,
    required this.showWithPrice,
    this.lastLoadTime,
    required this.pointsToSync,
    required this.depositsToSync,
    required this.ordersToSync,
    required this.returnActsToSync,
    required this.incRequestsToSync,
    required this.partnerPricesToSync,
    required this.partnersPricelistsToSync,
    required this.pointsTotal,
    required this.encashmentsTotal,
    required this.shipmentsTotal,
    required this.ordersTotal,
    required this.preOrdersTotal,
    required this.returnActsTotal,
  });
}

mixin _$BonusProgramsDaoMixin on DatabaseAccessor<AppDataStore> {
  $AllGoodsTable get allGoods => attachedDatabase.allGoods;
  $BonusProgramGroupsTable get bonusProgramGroups =>
      attachedDatabase.bonusProgramGroups;
  $BonusProgramsTable get bonusPrograms => attachedDatabase.bonusPrograms;
  $BuyersSetsTable get buyersSets => attachedDatabase.buyersSets;
  $BuyersSetsBonusProgramsTable get buyersSetsBonusPrograms =>
      attachedDatabase.buyersSetsBonusPrograms;
  $BuyersSetsBuyersTable get buyersSetsBuyers =>
      attachedDatabase.buyersSetsBuyers;
  $GoodsBonusProgramsTable get goodsBonusPrograms =>
      attachedDatabase.goodsBonusPrograms;
  $GoodsBonusProgramPricesTable get goodsBonusProgramPrices =>
      attachedDatabase.goodsBonusProgramPrices;
  Selectable<FilteredBonusProgramsResult> filteredBonusPrograms(
      String? bonusProgramGroupId,
      String? goodsId,
      String? categoryId,
      int buyerId,
      DateTime date) {
    return customSelect(
        'SELECT DISTINCT bonus_programs.id, bonus_programs.name, bonus_programs.condition, bonus_programs.present FROM bonus_programs JOIN buyers_sets_bonus_programs ON buyers_sets_bonus_programs.bonus_program_id = bonus_programs.id JOIN buyers_sets_buyers ON buyers_sets_buyers.buyers_set_id = buyers_sets_bonus_programs.buyers_set_id JOIN buyers_sets ON buyers_sets.id = buyers_sets_buyers.buyers_set_id JOIN goods_bonus_programs ON goods_bonus_programs.bonus_program_id = bonus_programs.id JOIN goods ON goods.id = goods_bonus_programs.goods_id WHERE(?1 = bonus_programs.bonus_program_group_id OR ?1 IS NULL)AND(?2 = goods_bonus_programs.goods_id OR ?2 IS NULL)AND(?3 = goods.category_id OR ?3 IS NULL)AND(buyers_sets.is_for_all = 1 OR buyers_sets_buyers.buyer_id = ?4)AND ?5 BETWEEN bonus_programs.date_from AND bonus_programs.date_to ORDER BY bonus_programs.name',
        variables: [
          Variable<String>(bonusProgramGroupId),
          Variable<String>(goodsId),
          Variable<String>(categoryId),
          Variable<int>(buyerId),
          Variable<DateTime>(date)
        ],
        readsFrom: {
          bonusPrograms,
          buyersSetsBonusPrograms,
          buyersSetsBuyers,
          buyersSets,
          goodsBonusPrograms,
          allGoods,
        }).map((QueryRow row) {
      return FilteredBonusProgramsResult(
        id: row.read<int>('id'),
        name: row.read<String>('name'),
        condition: row.read<String>('condition'),
        present: row.read<String>('present'),
      );
    });
  }

  Selectable<FilteredGoodsBonusProgramsResult> filteredGoodsBonusPrograms(
      int buyerId, List<int> goodsIds, DateTime date) {
    var $arrayStartIndex = 3;
    final expandedgoodsIds = $expandVar($arrayStartIndex, goodsIds.length);
    $arrayStartIndex += goodsIds.length;
    return customSelect(
        'SELECT DISTINCT bonus_programs.id AS bonus_program_id, CAST(COALESCE(MAX(CASE WHEN bonus_programs.discount_percent > 0 THEN bonus_programs.conditional_discount ELSE 0 END), 0) AS INT) AS conditional_discount, (SELECT MAX(goods_bonus_program_prices.price) FROM goods_bonus_program_prices WHERE goods_bonus_program_prices.bonus_program_id = bonus_programs.id AND goods_bonus_program_prices.goods_id = goods.id) AS goods_price, MAX(bonus_programs.discount_percent) AS discount_percent, MAX(bonus_programs.coef) AS coef, bonus_programs.tag_text, goods.id AS goods_id FROM bonus_programs JOIN buyers_sets_bonus_programs ON buyers_sets_bonus_programs.bonus_program_id = bonus_programs.id JOIN buyers_sets_buyers ON buyers_sets_buyers.buyers_set_id = buyers_sets_bonus_programs.buyers_set_id JOIN buyers_sets ON buyers_sets.id = buyers_sets_buyers.buyers_set_id JOIN goods_bonus_programs ON goods_bonus_programs.bonus_program_id = bonus_programs.id JOIN goods ON goods.id = goods_bonus_programs.goods_id WHERE LENGTH(bonus_programs.tag_text) > 0 AND(buyers_sets.is_for_all = 1 OR buyers_sets_buyers.buyer_id = ?1)AND goods_bonus_programs.goods_id IN ($expandedgoodsIds) AND ?2 BETWEEN bonus_programs.date_from AND bonus_programs.date_to GROUP BY bonus_programs.id, bonus_programs.tag_text, goods.id, goods.name ORDER BY bonus_programs.id, goods.name',
        variables: [
          Variable<int>(buyerId),
          Variable<DateTime>(date),
          for (var $ in goodsIds) Variable<int>($)
        ],
        readsFrom: {
          bonusPrograms,
          goodsBonusProgramPrices,
          allGoods,
          buyersSetsBonusPrograms,
          buyersSetsBuyers,
          buyersSets,
          goodsBonusPrograms,
        }).map((QueryRow row) {
      return FilteredGoodsBonusProgramsResult(
        bonusProgramId: row.read<int>('bonus_program_id'),
        conditionalDiscount: row.read<bool>('conditional_discount'),
        goodsPrice: row.readNullable<double>('goods_price'),
        discountPercent: row.readNullable<int>('discount_percent'),
        coef: row.readNullable<double>('coef'),
        tagText: row.read<String>('tag_text'),
        goodsId: row.read<int>('goods_id'),
      );
    });
  }
}

class FilteredBonusProgramsResult {
  final int id;
  final String name;
  final String condition;
  final String present;
  FilteredBonusProgramsResult({
    required this.id,
    required this.name,
    required this.condition,
    required this.present,
  });
}

class FilteredGoodsBonusProgramsResult {
  final int bonusProgramId;
  final bool conditionalDiscount;
  final double? goodsPrice;
  final int? discountPercent;
  final double? coef;
  final String tagText;
  final int goodsId;
  FilteredGoodsBonusProgramsResult({
    required this.bonusProgramId,
    required this.conditionalDiscount,
    this.goodsPrice,
    this.discountPercent,
    this.coef,
    required this.tagText,
    required this.goodsId,
  });
}

mixin _$DebtsDaoMixin on DatabaseAccessor<AppDataStore> {
  $PartnersTable get partners => attachedDatabase.partners;
  $BuyersTable get buyers => attachedDatabase.buyers;
  $DebtsTable get debts => attachedDatabase.debts;
  $DepositsTable get deposits => attachedDatabase.deposits;
  $EncashmentsTable get encashments => attachedDatabase.encashments;
}
mixin _$OrdersDaoMixin on DatabaseAccessor<AppDataStore> {
  $BuyersTable get buyers => attachedDatabase.buyers;
  $AllGoodsTable get allGoods => attachedDatabase.allGoods;
  $CategoriesTable get categories => attachedDatabase.categories;
  $ShopDepartmentsTable get shopDepartments => attachedDatabase.shopDepartments;
  $GoodsFiltersTable get goodsFilters => attachedDatabase.goodsFilters;
  $ShipmentsTable get shipments => attachedDatabase.shipments;
  $ShipmentLinesTable get shipmentLines => attachedDatabase.shipmentLines;
  $GoodsBonusProgramsTable get goodsBonusPrograms =>
      attachedDatabase.goodsBonusPrograms;
  $GoodsStocksTable get goodsStocks => attachedDatabase.goodsStocks;
  $GoodsRestrictionsTable get goodsRestrictions =>
      attachedDatabase.goodsRestrictions;
  $OrdersTable get orders => attachedDatabase.orders;
  $OrderLinesTable get orderLines => attachedDatabase.orderLines;
  $PreOrdersTable get preOrders => attachedDatabase.preOrders;
  $PreOrderLinesTable get preOrderLines => attachedDatabase.preOrderLines;
  $SeenPreOrdersTable get seenPreOrders => attachedDatabase.seenPreOrders;
  Selectable<OrderExResult> orderEx() {
    return customSelect(
        'SELECT"orders"."guid" AS "nested_0.guid", "orders"."is_deleted" AS "nested_0.is_deleted", "orders"."timestamp" AS "nested_0.timestamp", "orders"."current_timestamp" AS "nested_0.current_timestamp", "orders"."last_sync_time" AS "nested_0.last_sync_time", "orders"."need_sync" AS "nested_0.need_sync", "orders"."is_new" AS "nested_0.is_new", "orders"."id" AS "nested_0.id", "orders"."date" AS "nested_0.date", "orders"."status" AS "nested_0.status", "orders"."pre_order_id" AS "nested_0.pre_order_id", "orders"."need_docs" AS "nested_0.need_docs", "orders"."need_inc" AS "nested_0.need_inc", "orders"."is_bonus" AS "nested_0.is_bonus", "orders"."is_physical" AS "nested_0.is_physical", "orders"."buyer_id" AS "nested_0.buyer_id", "orders"."info" AS "nested_0.info", "orders"."need_processing" AS "nested_0.need_processing", "orders"."is_editable" AS "nested_0.is_editable","buyers"."id" AS "nested_1.id", "buyers"."name" AS "nested_1.name", "buyers"."loadto" AS "nested_1.loadto", "buyers"."partner_id" AS "nested_1.partner_id", "buyers"."site_id" AS "nested_1.site_id", "buyers"."fridge_site_id" AS "nested_1.fridge_site_id", COALESCE((SELECT SUM(order_lines.rel * order_lines.vol * order_lines.price) FROM order_lines WHERE order_lines.order_guid = orders.guid AND order_lines.is_deleted = 0), 0) AS lines_total, (SELECT COUNT(*) FROM order_lines WHERE order_guid = orders.guid AND order_lines.is_deleted = 0) AS lines_count, COALESCE((SELECT MAX(need_sync) FROM order_lines WHERE order_guid = orders.guid), 0) AS lines_need_sync FROM orders LEFT JOIN buyers ON buyers.id = orders.buyer_id ORDER BY orders.date DESC, buyers.name',
        variables: [],
        readsFrom: {
          orderLines,
          orders,
          buyers,
        }).asyncMap((QueryRow row) async {
      return OrderExResult(
        order: await orders.mapFromRow(row, tablePrefix: 'nested_0'),
        buyer: await buyers.mapFromRowOrNull(row, tablePrefix: 'nested_1'),
        linesTotal: row.read<double>('lines_total'),
        linesCount: row.read<int>('lines_count'),
        linesNeedSync: row.read<bool>('lines_need_sync'),
      );
    });
  }

  Selectable<OrderLineExResult> orderLineEx(String orderGuid) {
    return customSelect(
        'SELECT"order_lines"."guid" AS "nested_0.guid", "order_lines"."is_deleted" AS "nested_0.is_deleted", "order_lines"."timestamp" AS "nested_0.timestamp", "order_lines"."current_timestamp" AS "nested_0.current_timestamp", "order_lines"."last_sync_time" AS "nested_0.last_sync_time", "order_lines"."need_sync" AS "nested_0.need_sync", "order_lines"."is_new" AS "nested_0.is_new", "order_lines"."id" AS "nested_0.id", "order_lines"."order_guid" AS "nested_0.order_guid", "order_lines"."goods_id" AS "nested_0.goods_id", "order_lines"."vol" AS "nested_0.vol", "order_lines"."price" AS "nested_0.price", "order_lines"."price_original" AS "nested_0.price_original", "order_lines"."package" AS "nested_0.package", "order_lines"."rel" AS "nested_0.rel", goods.name AS goods_name FROM order_lines JOIN goods ON goods.id = order_lines.goods_id WHERE order_lines.order_guid = ?1 ORDER BY goods.name',
        variables: [
          Variable<String>(orderGuid)
        ],
        readsFrom: {
          allGoods,
          orderLines,
        }).asyncMap((QueryRow row) async {
      return OrderLineExResult(
        line: await orderLines.mapFromRow(row, tablePrefix: 'nested_0'),
        goodsName: row.read<String>('goods_name'),
      );
    });
  }

  Selectable<PreOrderExResult> preOrderEx() {
    return customSelect(
        'SELECT"pre_orders"."id" AS "nested_0.id", "pre_orders"."date" AS "nested_0.date", "pre_orders"."buyer_id" AS "nested_0.buyer_id", "pre_orders"."need_docs" AS "nested_0.need_docs", "pre_orders"."info" AS "nested_0.info","buyers"."id" AS "nested_1.id", "buyers"."name" AS "nested_1.name", "buyers"."loadto" AS "nested_1.loadto", "buyers"."partner_id" AS "nested_1.partner_id", "buyers"."site_id" AS "nested_1.site_id", "buyers"."fridge_site_id" AS "nested_1.fridge_site_id", COALESCE((SELECT SUM(pre_order_lines.rel * pre_order_lines.vol * pre_order_lines.price) FROM pre_order_lines WHERE pre_order_lines.pre_order_id = pre_orders.id), 0) AS lines_total, (SELECT COUNT(*) FROM pre_order_lines WHERE pre_order_id = pre_orders.id) AS lines_count, EXISTS (SELECT 1 AS _c0 FROM orders WHERE pre_order_id = pre_orders.id) AS has_order, EXISTS (SELECT 1 AS _c1 FROM seen_pre_orders WHERE id = pre_orders.id) AS was_seen FROM pre_orders JOIN buyers ON buyers.id = pre_orders.buyer_id ORDER BY pre_orders.date DESC, buyers.name',
        variables: [],
        readsFrom: {
          preOrderLines,
          preOrders,
          orders,
          seenPreOrders,
          buyers,
        }).asyncMap((QueryRow row) async {
      return PreOrderExResult(
        preOrder: await preOrders.mapFromRow(row, tablePrefix: 'nested_0'),
        buyer: await buyers.mapFromRow(row, tablePrefix: 'nested_1'),
        linesTotal: row.read<double>('lines_total'),
        linesCount: row.read<int>('lines_count'),
        hasOrder: row.read<bool>('has_order'),
        wasSeen: row.read<bool>('was_seen'),
      );
    });
  }

  Selectable<PreOrderLineExResult> preOrderLineEx(int preOrderId) {
    return customSelect(
        'SELECT"pre_order_lines"."id" AS "nested_0.id", "pre_order_lines"."pre_order_id" AS "nested_0.pre_order_id", "pre_order_lines"."goods_id" AS "nested_0.goods_id", "pre_order_lines"."vol" AS "nested_0.vol", "pre_order_lines"."price" AS "nested_0.price", "pre_order_lines"."package" AS "nested_0.package", "pre_order_lines"."rel" AS "nested_0.rel", goods.name AS goods_name FROM pre_order_lines JOIN goods ON goods.id = pre_order_lines.goods_id WHERE pre_order_lines.pre_order_id = ?1 ORDER BY goods.name',
        variables: [
          Variable<int>(preOrderId)
        ],
        readsFrom: {
          allGoods,
          preOrderLines,
        }).asyncMap((QueryRow row) async {
      return PreOrderLineExResult(
        line: await preOrderLines.mapFromRow(row, tablePrefix: 'nested_0'),
        goodsName: row.read<String>('goods_name'),
      );
    });
  }

  Selectable<GoodsExResult> goodsEx(int buyerId, List<int> goodsIds) {
    var $arrayStartIndex = 2;
    final expandedgoodsIds = $expandVar($arrayStartIndex, goodsIds.length);
    $arrayStartIndex += goodsIds.length;
    return customSelect(
        'SELECT"goods"."id" AS "nested_0.id", "goods"."name" AS "nested_0.name", "goods"."image_url" AS "nested_0.image_url", "goods"."image_key" AS "nested_0.image_key", "goods"."category_id" AS "nested_0.category_id", "goods"."manufacturer" AS "nested_0.manufacturer", "goods"."is_latest" AS "nested_0.is_latest", "goods"."pricelist_set_id" AS "nested_0.pricelist_set_id", "goods"."cost" AS "nested_0.cost", "goods"."min_price" AS "nested_0.min_price", "goods"."hand_price" AS "nested_0.hand_price", "goods"."extra_label" AS "nested_0.extra_label", "goods"."package" AS "nested_0.package", "goods"."rel" AS "nested_0.rel", "goods"."category_user_package_rel" AS "nested_0.category_user_package_rel", "goods"."category_package_rel" AS "nested_0.category_package_rel", "goods"."category_block_rel" AS "nested_0.category_block_rel", "goods"."weight" AS "nested_0.weight", "goods"."mc_vol" AS "nested_0.mc_vol", "goods"."is_fridge" AS "nested_0.is_fridge", "goods"."shelf_life" AS "nested_0.shelf_life", "goods"."shelf_life_type_name" AS "nested_0.shelf_life_type_name", "goods"."barcodes" AS "nested_0.barcodes", categories.package AS categoryPackage, categories.user_package AS categoryUserPackage,"normal_stocks"."goods_id" AS "nested_1.goods_id", "normal_stocks"."site_id" AS "nested_1.site_id", "normal_stocks"."is_vollow" AS "nested_1.is_vollow", "normal_stocks"."factor" AS "nested_1.factor", "normal_stocks"."vol" AS "nested_1.vol","fridge_stocks"."goods_id" AS "nested_2.goods_id", "fridge_stocks"."site_id" AS "nested_2.site_id", "fridge_stocks"."is_vollow" AS "nested_2.is_vollow", "fridge_stocks"."factor" AS "nested_2.factor", "fridge_stocks"."vol" AS "nested_2.vol", EXISTS (SELECT 1 AS _c0 FROM goods_restrictions WHERE goods_restrictions.goods_id = goods.id AND goods_restrictions.buyer_id = buyers.id) AS restricted, (SELECT MAX(shipments.date) FROM shipment_lines JOIN shipments ON shipments.id = shipment_lines.shipment_id WHERE shipment_lines.goods_id = goods.id AND shipments.buyer_id = buyers.id AND shipments.date < STRFTIME(\'%s\', \'now\', \'start of day\')) AS last_shipment_date, (SELECT MAX(shipment_lines.price) FROM shipment_lines JOIN shipments ON shipments.id = shipment_lines.shipment_id JOIN (SELECT MAX(shipments.date) AS last_shipment_date, shipments.buyer_id FROM shipments GROUP BY shipments.buyer_id) AS sm ON sm.last_shipment_date = shipments.date AND sm.buyer_id = shipments.buyer_id WHERE shipment_lines.goods_id = goods.id AND shipments.buyer_id = buyers.id AND shipments.date < STRFTIME(\'%s\', \'now\', \'start of day\')) AS last_price FROM goods JOIN categories ON categories.id = goods.category_id CROSS JOIN buyers LEFT JOIN goods_stocks AS normal_stocks ON normal_stocks.goods_id = goods.id AND normal_stocks.site_id = buyers.site_id LEFT JOIN goods_stocks AS fridge_stocks ON fridge_stocks.goods_id = goods.id AND fridge_stocks.site_id = buyers.fridge_site_id WHERE buyers.id = ?1 AND goods.id IN ($expandedgoodsIds) ORDER BY goods.name',
        variables: [
          Variable<int>(buyerId),
          for (var $ in goodsIds) Variable<int>($)
        ],
        readsFrom: {
          categories,
          goodsRestrictions,
          allGoods,
          buyers,
          shipments,
          shipmentLines,
          goodsStocks,
        }).asyncMap((QueryRow row) async {
      return GoodsExResult(
        goods: await allGoods.mapFromRow(row, tablePrefix: 'nested_0'),
        categoryPackage: row.read<int>('categoryPackage'),
        categoryUserPackage: row.read<int>('categoryUserPackage'),
        normalStock:
            await goodsStocks.mapFromRowOrNull(row, tablePrefix: 'nested_1'),
        fridgeStock:
            await goodsStocks.mapFromRowOrNull(row, tablePrefix: 'nested_2'),
        restricted: row.read<bool>('restricted'),
        lastShipmentDate: row.readNullable<DateTime>('last_shipment_date'),
        lastPrice: row.readNullable<double>('last_price'),
      );
    });
  }

  Selectable<CategoriesExResult> categoriesEx(int buyerId) {
    return customSelect(
        'SELECT categories.*, (SELECT MAX(shipments.date) FROM shipment_lines JOIN shipments ON shipments.id = shipment_lines.shipment_id JOIN goods ON shipment_lines.goods_id = goods.id WHERE categories.id = goods.category_id AND shipments.buyer_id = ?1 AND shipments.date < STRFTIME(\'%s\', \'now\', \'start of day\')) AS last_shipment_date FROM categories WHERE EXISTS (SELECT 1 AS _c0 FROM goods WHERE goods.category_id = categories.id) ORDER BY categories.name',
        variables: [
          Variable<int>(buyerId)
        ],
        readsFrom: {
          shipments,
          shipmentLines,
          allGoods,
          categories,
        }).map((QueryRow row) {
      return CategoriesExResult(
        id: row.read<int>('id'),
        name: row.read<String>('name'),
        ord: row.read<int>('ord'),
        shopDepartmentId: row.read<int>('shop_department_id'),
        package: row.read<int>('package'),
        userPackage: row.read<int>('user_package'),
        lastShipmentDate: row.readNullable<DateTime>('last_shipment_date'),
      );
    });
  }
}

class OrderExResult {
  final Order order;
  final Buyer? buyer;
  final double linesTotal;
  final int linesCount;
  final bool linesNeedSync;
  OrderExResult({
    required this.order,
    this.buyer,
    required this.linesTotal,
    required this.linesCount,
    required this.linesNeedSync,
  });
}

class OrderLineExResult {
  final OrderLine line;
  final String goodsName;
  OrderLineExResult({
    required this.line,
    required this.goodsName,
  });
}

class PreOrderExResult {
  final PreOrder preOrder;
  final Buyer buyer;
  final double linesTotal;
  final int linesCount;
  final bool hasOrder;
  final bool wasSeen;
  PreOrderExResult({
    required this.preOrder,
    required this.buyer,
    required this.linesTotal,
    required this.linesCount,
    required this.hasOrder,
    required this.wasSeen,
  });
}

class PreOrderLineExResult {
  final PreOrderLine line;
  final String goodsName;
  PreOrderLineExResult({
    required this.line,
    required this.goodsName,
  });
}

class GoodsExResult {
  final Goods goods;
  final int categoryPackage;
  final int categoryUserPackage;
  final GoodsStock? normalStock;
  final GoodsStock? fridgeStock;
  final bool restricted;
  final DateTime? lastShipmentDate;
  final double? lastPrice;
  GoodsExResult({
    required this.goods,
    required this.categoryPackage,
    required this.categoryUserPackage,
    this.normalStock,
    this.fridgeStock,
    required this.restricted,
    this.lastShipmentDate,
    this.lastPrice,
  });
}

class CategoriesExResult {
  final int id;
  final String name;
  final int ord;
  final int shopDepartmentId;
  final int package;
  final int userPackage;
  final DateTime? lastShipmentDate;
  CategoriesExResult({
    required this.id,
    required this.name,
    required this.ord,
    required this.shopDepartmentId,
    required this.package,
    required this.userPackage,
    this.lastShipmentDate,
  });
}

mixin _$PartnersDaoMixin on DatabaseAccessor<AppDataStore> {
  $BuyersTable get buyers => attachedDatabase.buyers;
  $PartnersTable get partners => attachedDatabase.partners;
}
mixin _$PointsDaoMixin on DatabaseAccessor<AppDataStore> {
  $PointsTable get points => attachedDatabase.points;
  $PointImagesTable get pointImages => attachedDatabase.pointImages;
  $PointFormatsTable get pointFormats => attachedDatabase.pointFormats;
}
mixin _$PricesDaoMixin on DatabaseAccessor<AppDataStore> {
  $BuyersTable get buyers => attachedDatabase.buyers;
  $AllGoodsTable get allGoods => attachedDatabase.allGoods;
  $PricelistsTable get pricelists => attachedDatabase.pricelists;
  $PricelistSetCategoriesTable get pricelistSetCategories =>
      attachedDatabase.pricelistSetCategories;
  $PartnersPricesTable get partnersPrices => attachedDatabase.partnersPrices;
  $PricelistPricesTable get pricelistPrices => attachedDatabase.pricelistPrices;
  $PartnersPricelistsTable get partnersPricelists =>
      attachedDatabase.partnersPricelists;
  $GoodsPartnersPricelistsTable get goodsPartnersPricelists =>
      attachedDatabase.goodsPartnersPricelists;
  Selectable<GoodsPricesResult> goodsPrices(
      int buyerId, List<int> goodsIds, DateTime date) {
    var $arrayStartIndex = 3;
    final expandedgoodsIds = $expandVar($arrayStartIndex, goodsIds.length);
    $arrayStartIndex += goodsIds.length;
    return customSelect(
        'SELECT goods_id, MIN(price) AS price FROM (SELECT prices.goods_id, prices.disc * pricelist_prices.price AS price FROM (SELECT goods_partners_pricelists.goods_id, goods_partners_pricelists.pricelist_id,(100 + goods_partners_pricelists.discount)/ 100 *(1 - partners_pricelists.discount / 100.0)AS disc FROM partners_pricelists JOIN buyers ON buyers.partner_id = partners_pricelists.partner_id JOIN goods_partners_pricelists ON goods_partners_pricelists.partner_pricelist_id = partners_pricelists.pricelist_id JOIN goods ON goods.id = goods_partners_pricelists.goods_id WHERE buyers.id = ?1 AND goods_partners_pricelists.goods_id IN ($expandedgoodsIds) AND(EXISTS (SELECT 1 AS _c0 FROM pricelist_set_categories WHERE pricelist_set_categories.pricelist_set_id = partners_pricelists.pricelist_set_id AND pricelist_set_categories.category_id = goods.category_id) OR NOT EXISTS (SELECT 1 AS _c1 FROM pricelist_set_categories WHERE pricelist_set_categories.pricelist_set_id = partners_pricelists.pricelist_set_id))) AS prices JOIN pricelist_prices ON pricelist_prices.pricelist_id = prices.pricelist_id AND pricelist_prices.goods_id = prices.goods_id AND ?2 BETWEEN pricelist_prices.date_from AND pricelist_prices.date_to WHERE NOT EXISTS (SELECT 1 AS _c2 FROM partners_prices JOIN buyers ON buyers.partner_id = partners_prices.partner_id WHERE partners_prices.goods_id IN ($expandedgoodsIds) AND buyers.id = ?1 AND ?2 BETWEEN partners_prices.date_from AND partners_prices.date_to AND partners_prices.goods_id = pricelist_prices.goods_id) UNION ALL SELECT partners_prices.goods_id, partners_prices.price FROM partners_prices JOIN buyers ON buyers.partner_id = partners_prices.partner_id WHERE partners_prices.goods_id IN ($expandedgoodsIds) AND buyers.id = ?1 AND ?2 BETWEEN partners_prices.date_from AND partners_prices.date_to) GROUP BY goods_id',
        variables: [
          Variable<int>(buyerId),
          Variable<DateTime>(date),
          for (var $ in goodsIds) Variable<int>($)
        ],
        readsFrom: {
          pricelistPrices,
          goodsPartnersPricelists,
          partnersPricelists,
          buyers,
          allGoods,
          pricelistSetCategories,
          partnersPrices,
        }).map((QueryRow row) {
      return GoodsPricesResult(
        goodsId: row.read<int>('goods_id'),
        price: row.readNullable<double>('price'),
      );
    });
  }

  Selectable<GoodsPricelistsResult> goodsPricelists(
      DateTime date, int goodsId) {
    return customSelect(
        'SELECT pricelists.id, pricelists.name, pricelists.permit,(100 + goods_partners_pricelists.discount)/ 100 * pricelist_prices.price AS price FROM pricelists JOIN goods_partners_pricelists ON goods_partners_pricelists.partner_pricelist_id = pricelists.id AND goods_partners_pricelists.goods_id = pricelist_prices.goods_id JOIN pricelist_prices ON goods_partners_pricelists.pricelist_id = pricelist_prices.pricelist_id WHERE ?1 BETWEEN pricelist_prices.date_from AND pricelist_prices.date_to AND goods_partners_pricelists.goods_id = ?2 ORDER BY price, pricelists.name',
        variables: [
          Variable<DateTime>(date),
          Variable<int>(goodsId)
        ],
        readsFrom: {
          pricelists,
          goodsPartnersPricelists,
          pricelistPrices,
        }).map((QueryRow row) {
      return GoodsPricelistsResult(
        id: row.read<int>('id'),
        name: row.read<String>('name'),
        permit: row.read<bool>('permit'),
        price: row.read<double>('price'),
      );
    });
  }
}

class GoodsPricesResult {
  final int goodsId;
  final double? price;
  GoodsPricesResult({
    required this.goodsId,
    this.price,
  });
}

class GoodsPricelistsResult {
  final int id;
  final String name;
  final bool permit;
  final double price;
  GoodsPricelistsResult({
    required this.id,
    required this.name,
    required this.permit,
    required this.price,
  });
}

mixin _$ShipmentsDaoMixin on DatabaseAccessor<AppDataStore> {
  $BuyersTable get buyers => attachedDatabase.buyers;
  $ShipmentsTable get shipments => attachedDatabase.shipments;
  $ShipmentLinesTable get shipmentLines => attachedDatabase.shipmentLines;
  $IncRequestsTable get incRequests => attachedDatabase.incRequests;
  $AllGoodsTable get allGoods => attachedDatabase.allGoods;
  $WorkdatesTable get workdates => attachedDatabase.workdates;
  Selectable<ShipmentExResult> shipmentEx() {
    return customSelect(
        'SELECT"shipments"."id" AS "nested_0.id", "shipments"."date" AS "nested_0.date", "shipments"."ndoc" AS "nested_0.ndoc", "shipments"."info" AS "nested_0.info", "shipments"."status" AS "nested_0.status", "shipments"."debt_sum" AS "nested_0.debt_sum", "shipments"."shipment_sum" AS "nested_0.shipment_sum", "shipments"."buyer_id" AS "nested_0.buyer_id","buyers"."id" AS "nested_1.id", "buyers"."name" AS "nested_1.name", "buyers"."loadto" AS "nested_1.loadto", "buyers"."partner_id" AS "nested_1.partner_id", "buyers"."site_id" AS "nested_1.site_id", "buyers"."fridge_site_id" AS "nested_1.fridge_site_id", (SELECT COUNT(*) FROM shipment_lines WHERE shipments.id = shipment_lines.shipment_id) AS lines_count FROM shipments JOIN buyers ON buyers.id = shipments.buyer_id ORDER BY shipments.date DESC, buyers.name',
        variables: [],
        readsFrom: {
          shipmentLines,
          shipments,
          buyers,
        }).asyncMap((QueryRow row) async {
      return ShipmentExResult(
        shipment: await shipments.mapFromRow(row, tablePrefix: 'nested_0'),
        buyer: await buyers.mapFromRow(row, tablePrefix: 'nested_1'),
        linesCount: row.read<int>('lines_count'),
      );
    });
  }

  Selectable<GoodsShipmentsResult> goodsShipments(int buyerId, int goodsId) {
    return customSelect(
        'SELECT shipments.date, shipment_lines.vol, shipment_lines.price FROM shipments JOIN shipment_lines ON shipment_lines.shipment_id = shipments.id WHERE shipments.buyer_id = ?1 AND shipment_lines.goods_id = ?2 ORDER BY shipments.date DESC',
        variables: [
          Variable<int>(buyerId),
          Variable<int>(goodsId)
        ],
        readsFrom: {
          shipments,
          shipmentLines,
        }).map((QueryRow row) {
      return GoodsShipmentsResult(
        date: row.read<DateTime>('date'),
        vol: row.read<double>('vol'),
        price: row.read<double>('price'),
      );
    });
  }
}

class ShipmentExResult {
  final Shipment shipment;
  final Buyer buyer;
  final int linesCount;
  ShipmentExResult({
    required this.shipment,
    required this.buyer,
    required this.linesCount,
  });
}

class GoodsShipmentsResult {
  final DateTime date;
  final double vol;
  final double price;
  GoodsShipmentsResult({
    required this.date,
    required this.vol,
    required this.price,
  });
}

mixin _$ReturnActsDaoMixin on DatabaseAccessor<AppDataStore> {
  $CategoriesTable get categories => attachedDatabase.categories;
  $BuyersTable get buyers => attachedDatabase.buyers;
  $AllGoodsTable get allGoods => attachedDatabase.allGoods;
  $GoodsReturnStocksTable get goodsReturnStocks =>
      attachedDatabase.goodsReturnStocks;
  $ReturnActsTable get returnActs => attachedDatabase.returnActs;
  $ReturnActLinesTable get returnActLines => attachedDatabase.returnActLines;
  $ReturnActTypesTable get returnActTypes => attachedDatabase.returnActTypes;
  $PartnersReturnActTypesTable get partnersReturnActTypes =>
      attachedDatabase.partnersReturnActTypes;
  Selectable<ReturnActExResult> returnActEx() {
    return customSelect(
        'SELECT"return_acts"."guid" AS "nested_0.guid", "return_acts"."is_deleted" AS "nested_0.is_deleted", "return_acts"."timestamp" AS "nested_0.timestamp", "return_acts"."current_timestamp" AS "nested_0.current_timestamp", "return_acts"."last_sync_time" AS "nested_0.last_sync_time", "return_acts"."need_sync" AS "nested_0.need_sync", "return_acts"."is_new" AS "nested_0.is_new", "return_acts"."id" AS "nested_0.id", "return_acts"."date" AS "nested_0.date", "return_acts"."number" AS "nested_0.number", "return_acts"."buyer_id" AS "nested_0.buyer_id", "return_acts"."need_pickup" AS "nested_0.need_pickup", "return_acts"."return_act_type_id" AS "nested_0.return_act_type_id", "return_acts"."recept_id" AS "nested_0.recept_id", "return_acts"."recept_ndoc" AS "nested_0.recept_ndoc", "return_acts"."recept_date" AS "nested_0.recept_date", COALESCE((SELECT name FROM return_act_types WHERE id = return_acts.return_act_type_id), \'Не указан\') AS return_act_type_name,"buyers"."id" AS "nested_1.id", "buyers"."name" AS "nested_1.name", "buyers"."loadto" AS "nested_1.loadto", "buyers"."partner_id" AS "nested_1.partner_id", "buyers"."site_id" AS "nested_1.site_id", "buyers"."fridge_site_id" AS "nested_1.fridge_site_id", (SELECT COUNT(*) FROM return_act_lines WHERE return_act_guid = return_acts.guid AND return_act_lines.is_deleted = 0) AS lines_count, COALESCE((SELECT MAX(need_sync) FROM return_act_lines WHERE return_act_guid = return_acts.guid), 0) AS lines_need_sync FROM return_acts LEFT JOIN buyers ON buyers.id = return_acts.buyer_id ORDER BY return_acts.date DESC, buyers.name',
        variables: [],
        readsFrom: {
          returnActTypes,
          returnActs,
          returnActLines,
          buyers,
        }).asyncMap((QueryRow row) async {
      return ReturnActExResult(
        returnAct: await returnActs.mapFromRow(row, tablePrefix: 'nested_0'),
        returnActTypeName: row.read<String>('return_act_type_name'),
        buyer: await buyers.mapFromRowOrNull(row, tablePrefix: 'nested_1'),
        linesCount: row.read<int>('lines_count'),
        linesNeedSync: row.read<bool>('lines_need_sync'),
      );
    });
  }

  Selectable<ReturnActLineExResult> returnActLineEx(String returnActGuid) {
    return customSelect(
        'SELECT"return_act_lines"."guid" AS "nested_0.guid", "return_act_lines"."is_deleted" AS "nested_0.is_deleted", "return_act_lines"."timestamp" AS "nested_0.timestamp", "return_act_lines"."current_timestamp" AS "nested_0.current_timestamp", "return_act_lines"."last_sync_time" AS "nested_0.last_sync_time", "return_act_lines"."need_sync" AS "nested_0.need_sync", "return_act_lines"."is_new" AS "nested_0.is_new", "return_act_lines"."id" AS "nested_0.id", "return_act_lines"."return_act_guid" AS "nested_0.return_act_guid", "return_act_lines"."goods_id" AS "nested_0.goods_id", "return_act_lines"."vol" AS "nested_0.vol", "return_act_lines"."production_date" AS "nested_0.production_date", "return_act_lines"."is_bad" AS "nested_0.is_bad", goods.name AS goods_name FROM return_act_lines JOIN goods ON goods.id = return_act_lines.goods_id WHERE return_act_lines.return_act_guid = ?1 ORDER BY goods.name',
        variables: [
          Variable<String>(returnActGuid)
        ],
        readsFrom: {
          allGoods,
          returnActLines,
        }).asyncMap((QueryRow row) async {
      return ReturnActLineExResult(
        line: await returnActLines.mapFromRow(row, tablePrefix: 'nested_0'),
        goodsName: row.read<String>('goods_name'),
      );
    });
  }

  Selectable<ReceptExResult> receptEx(int buyerId, int returnActTypeId) {
    return customSelect(
        'SELECT goods_return_stocks.recept_id AS id, goods_return_stocks.recept_date AS date, goods_return_stocks.recept_ndoc AS ndoc FROM goods_return_stocks WHERE goods_return_stocks.buyer_id = ?1 AND goods_return_stocks.return_act_type_id = ?2 GROUP BY recept_id, recept_date, recept_ndoc ORDER BY recept_ndoc, recept_date DESC',
        variables: [
          Variable<int>(buyerId),
          Variable<int>(returnActTypeId)
        ],
        readsFrom: {
          goodsReturnStocks,
        }).map((QueryRow row) {
      return ReceptExResult(
        id: row.read<int>('id'),
        date: row.read<DateTime>('date'),
        ndoc: row.read<String>('ndoc'),
      );
    });
  }
}

class ReturnActExResult {
  final ReturnAct returnAct;
  final String returnActTypeName;
  final Buyer? buyer;
  final int linesCount;
  final bool linesNeedSync;
  ReturnActExResult({
    required this.returnAct,
    required this.returnActTypeName,
    this.buyer,
    required this.linesCount,
    required this.linesNeedSync,
  });
}

class ReturnActLineExResult {
  final ReturnActLine line;
  final String goodsName;
  ReturnActLineExResult({
    required this.line,
    required this.goodsName,
  });
}

class ReceptExResult {
  final int id;
  final DateTime date;
  final String ndoc;
  ReceptExResult({
    required this.id,
    required this.date,
    required this.ndoc,
  });
}

mixin _$UsersDaoMixin on DatabaseAccessor<AppDataStore> {
  $UsersTable get users => attachedDatabase.users;
}
