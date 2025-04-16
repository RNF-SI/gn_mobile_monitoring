// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TModulesTable extends TModules with TableInfo<$TModulesTable, TModule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TModulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idModuleMeta =
      const VerificationMeta('idModule');
  @override
  late final GeneratedColumn<int> idModule = GeneratedColumn<int>(
      'id_module', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _moduleCodeMeta =
      const VerificationMeta('moduleCode');
  @override
  late final GeneratedColumn<String> moduleCode = GeneratedColumn<String>(
      'module_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _moduleLabelMeta =
      const VerificationMeta('moduleLabel');
  @override
  late final GeneratedColumn<String> moduleLabel = GeneratedColumn<String>(
      'module_label', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _moduleDescMeta =
      const VerificationMeta('moduleDesc');
  @override
  late final GeneratedColumn<String> moduleDesc = GeneratedColumn<String>(
      'module_desc', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _activeFrontendMeta =
      const VerificationMeta('activeFrontend');
  @override
  late final GeneratedColumn<bool> activeFrontend = GeneratedColumn<bool>(
      'active_frontend', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("active_frontend" IN (0, 1))'));
  static const VerificationMeta _activeBackendMeta =
      const VerificationMeta('activeBackend');
  @override
  late final GeneratedColumn<bool> activeBackend = GeneratedColumn<bool>(
      'active_backend', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("active_backend" IN (0, 1))'));
  static const VerificationMeta _downloadedMeta =
      const VerificationMeta('downloaded');
  @override
  late final GeneratedColumn<bool> downloaded = GeneratedColumn<bool>(
      'downloaded', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("downloaded" IN (0, 1))'),
      defaultValue: Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        idModule,
        moduleCode,
        moduleLabel,
        moduleDesc,
        activeFrontend,
        activeBackend,
        downloaded
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 't_modules';
  @override
  VerificationContext validateIntegrity(Insertable<TModule> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_module')) {
      context.handle(_idModuleMeta,
          idModule.isAcceptableOrUnknown(data['id_module']!, _idModuleMeta));
    }
    if (data.containsKey('module_code')) {
      context.handle(
          _moduleCodeMeta,
          moduleCode.isAcceptableOrUnknown(
              data['module_code']!, _moduleCodeMeta));
    }
    if (data.containsKey('module_label')) {
      context.handle(
          _moduleLabelMeta,
          moduleLabel.isAcceptableOrUnknown(
              data['module_label']!, _moduleLabelMeta));
    }
    if (data.containsKey('module_desc')) {
      context.handle(
          _moduleDescMeta,
          moduleDesc.isAcceptableOrUnknown(
              data['module_desc']!, _moduleDescMeta));
    }
    if (data.containsKey('active_frontend')) {
      context.handle(
          _activeFrontendMeta,
          activeFrontend.isAcceptableOrUnknown(
              data['active_frontend']!, _activeFrontendMeta));
    }
    if (data.containsKey('active_backend')) {
      context.handle(
          _activeBackendMeta,
          activeBackend.isAcceptableOrUnknown(
              data['active_backend']!, _activeBackendMeta));
    }
    if (data.containsKey('downloaded')) {
      context.handle(
          _downloadedMeta,
          downloaded.isAcceptableOrUnknown(
              data['downloaded']!, _downloadedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idModule};
  @override
  TModule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TModule(
      idModule: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_module'])!,
      moduleCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}module_code']),
      moduleLabel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}module_label']),
      moduleDesc: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}module_desc']),
      activeFrontend: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}active_frontend']),
      activeBackend: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}active_backend']),
      downloaded: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}downloaded'])!,
    );
  }

  @override
  $TModulesTable createAlias(String alias) {
    return $TModulesTable(attachedDatabase, alias);
  }
}

class TModule extends DataClass implements Insertable<TModule> {
  final int idModule;
  final String? moduleCode;
  final String? moduleLabel;
  final String? moduleDesc;
  final bool? activeFrontend;
  final bool? activeBackend;
  final bool downloaded;
  const TModule(
      {required this.idModule,
      this.moduleCode,
      this.moduleLabel,
      this.moduleDesc,
      this.activeFrontend,
      this.activeBackend,
      required this.downloaded});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_module'] = Variable<int>(idModule);
    if (!nullToAbsent || moduleCode != null) {
      map['module_code'] = Variable<String>(moduleCode);
    }
    if (!nullToAbsent || moduleLabel != null) {
      map['module_label'] = Variable<String>(moduleLabel);
    }
    if (!nullToAbsent || moduleDesc != null) {
      map['module_desc'] = Variable<String>(moduleDesc);
    }
    if (!nullToAbsent || activeFrontend != null) {
      map['active_frontend'] = Variable<bool>(activeFrontend);
    }
    if (!nullToAbsent || activeBackend != null) {
      map['active_backend'] = Variable<bool>(activeBackend);
    }
    map['downloaded'] = Variable<bool>(downloaded);
    return map;
  }

  TModulesCompanion toCompanion(bool nullToAbsent) {
    return TModulesCompanion(
      idModule: Value(idModule),
      moduleCode: moduleCode == null && nullToAbsent
          ? const Value.absent()
          : Value(moduleCode),
      moduleLabel: moduleLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(moduleLabel),
      moduleDesc: moduleDesc == null && nullToAbsent
          ? const Value.absent()
          : Value(moduleDesc),
      activeFrontend: activeFrontend == null && nullToAbsent
          ? const Value.absent()
          : Value(activeFrontend),
      activeBackend: activeBackend == null && nullToAbsent
          ? const Value.absent()
          : Value(activeBackend),
      downloaded: Value(downloaded),
    );
  }

  factory TModule.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TModule(
      idModule: serializer.fromJson<int>(json['idModule']),
      moduleCode: serializer.fromJson<String?>(json['moduleCode']),
      moduleLabel: serializer.fromJson<String?>(json['moduleLabel']),
      moduleDesc: serializer.fromJson<String?>(json['moduleDesc']),
      activeFrontend: serializer.fromJson<bool?>(json['activeFrontend']),
      activeBackend: serializer.fromJson<bool?>(json['activeBackend']),
      downloaded: serializer.fromJson<bool>(json['downloaded']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idModule': serializer.toJson<int>(idModule),
      'moduleCode': serializer.toJson<String?>(moduleCode),
      'moduleLabel': serializer.toJson<String?>(moduleLabel),
      'moduleDesc': serializer.toJson<String?>(moduleDesc),
      'activeFrontend': serializer.toJson<bool?>(activeFrontend),
      'activeBackend': serializer.toJson<bool?>(activeBackend),
      'downloaded': serializer.toJson<bool>(downloaded),
    };
  }

  TModule copyWith(
          {int? idModule,
          Value<String?> moduleCode = const Value.absent(),
          Value<String?> moduleLabel = const Value.absent(),
          Value<String?> moduleDesc = const Value.absent(),
          Value<bool?> activeFrontend = const Value.absent(),
          Value<bool?> activeBackend = const Value.absent(),
          bool? downloaded}) =>
      TModule(
        idModule: idModule ?? this.idModule,
        moduleCode: moduleCode.present ? moduleCode.value : this.moduleCode,
        moduleLabel: moduleLabel.present ? moduleLabel.value : this.moduleLabel,
        moduleDesc: moduleDesc.present ? moduleDesc.value : this.moduleDesc,
        activeFrontend:
            activeFrontend.present ? activeFrontend.value : this.activeFrontend,
        activeBackend:
            activeBackend.present ? activeBackend.value : this.activeBackend,
        downloaded: downloaded ?? this.downloaded,
      );
  TModule copyWithCompanion(TModulesCompanion data) {
    return TModule(
      idModule: data.idModule.present ? data.idModule.value : this.idModule,
      moduleCode:
          data.moduleCode.present ? data.moduleCode.value : this.moduleCode,
      moduleLabel:
          data.moduleLabel.present ? data.moduleLabel.value : this.moduleLabel,
      moduleDesc:
          data.moduleDesc.present ? data.moduleDesc.value : this.moduleDesc,
      activeFrontend: data.activeFrontend.present
          ? data.activeFrontend.value
          : this.activeFrontend,
      activeBackend: data.activeBackend.present
          ? data.activeBackend.value
          : this.activeBackend,
      downloaded:
          data.downloaded.present ? data.downloaded.value : this.downloaded,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TModule(')
          ..write('idModule: $idModule, ')
          ..write('moduleCode: $moduleCode, ')
          ..write('moduleLabel: $moduleLabel, ')
          ..write('moduleDesc: $moduleDesc, ')
          ..write('activeFrontend: $activeFrontend, ')
          ..write('activeBackend: $activeBackend, ')
          ..write('downloaded: $downloaded')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(idModule, moduleCode, moduleLabel, moduleDesc,
      activeFrontend, activeBackend, downloaded);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TModule &&
          other.idModule == this.idModule &&
          other.moduleCode == this.moduleCode &&
          other.moduleLabel == this.moduleLabel &&
          other.moduleDesc == this.moduleDesc &&
          other.activeFrontend == this.activeFrontend &&
          other.activeBackend == this.activeBackend &&
          other.downloaded == this.downloaded);
}

class TModulesCompanion extends UpdateCompanion<TModule> {
  final Value<int> idModule;
  final Value<String?> moduleCode;
  final Value<String?> moduleLabel;
  final Value<String?> moduleDesc;
  final Value<bool?> activeFrontend;
  final Value<bool?> activeBackend;
  final Value<bool> downloaded;
  const TModulesCompanion({
    this.idModule = const Value.absent(),
    this.moduleCode = const Value.absent(),
    this.moduleLabel = const Value.absent(),
    this.moduleDesc = const Value.absent(),
    this.activeFrontend = const Value.absent(),
    this.activeBackend = const Value.absent(),
    this.downloaded = const Value.absent(),
  });
  TModulesCompanion.insert({
    this.idModule = const Value.absent(),
    this.moduleCode = const Value.absent(),
    this.moduleLabel = const Value.absent(),
    this.moduleDesc = const Value.absent(),
    this.activeFrontend = const Value.absent(),
    this.activeBackend = const Value.absent(),
    this.downloaded = const Value.absent(),
  });
  static Insertable<TModule> custom({
    Expression<int>? idModule,
    Expression<String>? moduleCode,
    Expression<String>? moduleLabel,
    Expression<String>? moduleDesc,
    Expression<bool>? activeFrontend,
    Expression<bool>? activeBackend,
    Expression<bool>? downloaded,
  }) {
    return RawValuesInsertable({
      if (idModule != null) 'id_module': idModule,
      if (moduleCode != null) 'module_code': moduleCode,
      if (moduleLabel != null) 'module_label': moduleLabel,
      if (moduleDesc != null) 'module_desc': moduleDesc,
      if (activeFrontend != null) 'active_frontend': activeFrontend,
      if (activeBackend != null) 'active_backend': activeBackend,
      if (downloaded != null) 'downloaded': downloaded,
    });
  }

  TModulesCompanion copyWith(
      {Value<int>? idModule,
      Value<String?>? moduleCode,
      Value<String?>? moduleLabel,
      Value<String?>? moduleDesc,
      Value<bool?>? activeFrontend,
      Value<bool?>? activeBackend,
      Value<bool>? downloaded}) {
    return TModulesCompanion(
      idModule: idModule ?? this.idModule,
      moduleCode: moduleCode ?? this.moduleCode,
      moduleLabel: moduleLabel ?? this.moduleLabel,
      moduleDesc: moduleDesc ?? this.moduleDesc,
      activeFrontend: activeFrontend ?? this.activeFrontend,
      activeBackend: activeBackend ?? this.activeBackend,
      downloaded: downloaded ?? this.downloaded,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idModule.present) {
      map['id_module'] = Variable<int>(idModule.value);
    }
    if (moduleCode.present) {
      map['module_code'] = Variable<String>(moduleCode.value);
    }
    if (moduleLabel.present) {
      map['module_label'] = Variable<String>(moduleLabel.value);
    }
    if (moduleDesc.present) {
      map['module_desc'] = Variable<String>(moduleDesc.value);
    }
    if (activeFrontend.present) {
      map['active_frontend'] = Variable<bool>(activeFrontend.value);
    }
    if (activeBackend.present) {
      map['active_backend'] = Variable<bool>(activeBackend.value);
    }
    if (downloaded.present) {
      map['downloaded'] = Variable<bool>(downloaded.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TModulesCompanion(')
          ..write('idModule: $idModule, ')
          ..write('moduleCode: $moduleCode, ')
          ..write('moduleLabel: $moduleLabel, ')
          ..write('moduleDesc: $moduleDesc, ')
          ..write('activeFrontend: $activeFrontend, ')
          ..write('activeBackend: $activeBackend, ')
          ..write('downloaded: $downloaded')
          ..write(')'))
        .toString();
  }
}

class $TBaseSitesTable extends TBaseSites
    with TableInfo<$TBaseSitesTable, TBaseSite> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TBaseSitesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idBaseSiteMeta =
      const VerificationMeta('idBaseSite');
  @override
  late final GeneratedColumn<int> idBaseSite = GeneratedColumn<int>(
      'id_base_site', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _idInventorMeta =
      const VerificationMeta('idInventor');
  @override
  late final GeneratedColumn<int> idInventor = GeneratedColumn<int>(
      'id_inventor', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _idDigitiserMeta =
      const VerificationMeta('idDigitiser');
  @override
  late final GeneratedColumn<int> idDigitiser = GeneratedColumn<int>(
      'id_digitiser', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _baseSiteNameMeta =
      const VerificationMeta('baseSiteName');
  @override
  late final GeneratedColumn<String> baseSiteName = GeneratedColumn<String>(
      'base_site_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _baseSiteDescriptionMeta =
      const VerificationMeta('baseSiteDescription');
  @override
  late final GeneratedColumn<String> baseSiteDescription =
      GeneratedColumn<String>('base_site_description', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _baseSiteCodeMeta =
      const VerificationMeta('baseSiteCode');
  @override
  late final GeneratedColumn<String> baseSiteCode = GeneratedColumn<String>(
      'base_site_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _firstUseDateMeta =
      const VerificationMeta('firstUseDate');
  @override
  late final GeneratedColumn<DateTime> firstUseDate = GeneratedColumn<DateTime>(
      'first_use_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _geomMeta = const VerificationMeta('geom');
  @override
  late final GeneratedColumn<String> geom = GeneratedColumn<String>(
      'geom', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _uuidBaseSiteMeta =
      const VerificationMeta('uuidBaseSite');
  @override
  late final GeneratedColumn<String> uuidBaseSite = GeneratedColumn<String>(
      'uuid_base_site', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _metaCreateDateMeta =
      const VerificationMeta('metaCreateDate');
  @override
  late final GeneratedColumn<DateTime> metaCreateDate =
      GeneratedColumn<DateTime>('meta_create_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _metaUpdateDateMeta =
      const VerificationMeta('metaUpdateDate');
  @override
  late final GeneratedColumn<DateTime> metaUpdateDate =
      GeneratedColumn<DateTime>('meta_update_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _altitudeMinMeta =
      const VerificationMeta('altitudeMin');
  @override
  late final GeneratedColumn<int> altitudeMin = GeneratedColumn<int>(
      'altitude_min', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _altitudeMaxMeta =
      const VerificationMeta('altitudeMax');
  @override
  late final GeneratedColumn<int> altitudeMax = GeneratedColumn<int>(
      'altitude_max', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        idBaseSite,
        idInventor,
        idDigitiser,
        baseSiteName,
        baseSiteDescription,
        baseSiteCode,
        firstUseDate,
        geom,
        uuidBaseSite,
        metaCreateDate,
        metaUpdateDate,
        altitudeMin,
        altitudeMax
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 't_base_sites';
  @override
  VerificationContext validateIntegrity(Insertable<TBaseSite> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_base_site')) {
      context.handle(
          _idBaseSiteMeta,
          idBaseSite.isAcceptableOrUnknown(
              data['id_base_site']!, _idBaseSiteMeta));
    }
    if (data.containsKey('id_inventor')) {
      context.handle(
          _idInventorMeta,
          idInventor.isAcceptableOrUnknown(
              data['id_inventor']!, _idInventorMeta));
    }
    if (data.containsKey('id_digitiser')) {
      context.handle(
          _idDigitiserMeta,
          idDigitiser.isAcceptableOrUnknown(
              data['id_digitiser']!, _idDigitiserMeta));
    }
    if (data.containsKey('base_site_name')) {
      context.handle(
          _baseSiteNameMeta,
          baseSiteName.isAcceptableOrUnknown(
              data['base_site_name']!, _baseSiteNameMeta));
    }
    if (data.containsKey('base_site_description')) {
      context.handle(
          _baseSiteDescriptionMeta,
          baseSiteDescription.isAcceptableOrUnknown(
              data['base_site_description']!, _baseSiteDescriptionMeta));
    }
    if (data.containsKey('base_site_code')) {
      context.handle(
          _baseSiteCodeMeta,
          baseSiteCode.isAcceptableOrUnknown(
              data['base_site_code']!, _baseSiteCodeMeta));
    }
    if (data.containsKey('first_use_date')) {
      context.handle(
          _firstUseDateMeta,
          firstUseDate.isAcceptableOrUnknown(
              data['first_use_date']!, _firstUseDateMeta));
    }
    if (data.containsKey('geom')) {
      context.handle(
          _geomMeta, geom.isAcceptableOrUnknown(data['geom']!, _geomMeta));
    }
    if (data.containsKey('uuid_base_site')) {
      context.handle(
          _uuidBaseSiteMeta,
          uuidBaseSite.isAcceptableOrUnknown(
              data['uuid_base_site']!, _uuidBaseSiteMeta));
    }
    if (data.containsKey('meta_create_date')) {
      context.handle(
          _metaCreateDateMeta,
          metaCreateDate.isAcceptableOrUnknown(
              data['meta_create_date']!, _metaCreateDateMeta));
    }
    if (data.containsKey('meta_update_date')) {
      context.handle(
          _metaUpdateDateMeta,
          metaUpdateDate.isAcceptableOrUnknown(
              data['meta_update_date']!, _metaUpdateDateMeta));
    }
    if (data.containsKey('altitude_min')) {
      context.handle(
          _altitudeMinMeta,
          altitudeMin.isAcceptableOrUnknown(
              data['altitude_min']!, _altitudeMinMeta));
    }
    if (data.containsKey('altitude_max')) {
      context.handle(
          _altitudeMaxMeta,
          altitudeMax.isAcceptableOrUnknown(
              data['altitude_max']!, _altitudeMaxMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idBaseSite};
  @override
  TBaseSite map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TBaseSite(
      idBaseSite: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_base_site'])!,
      idInventor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_inventor']),
      idDigitiser: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_digitiser']),
      baseSiteName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}base_site_name']),
      baseSiteDescription: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}base_site_description']),
      baseSiteCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}base_site_code']),
      firstUseDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}first_use_date']),
      geom: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}geom']),
      uuidBaseSite: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid_base_site']),
      metaCreateDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}meta_create_date']),
      metaUpdateDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}meta_update_date']),
      altitudeMin: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}altitude_min']),
      altitudeMax: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}altitude_max']),
    );
  }

  @override
  $TBaseSitesTable createAlias(String alias) {
    return $TBaseSitesTable(attachedDatabase, alias);
  }
}

class TBaseSite extends DataClass implements Insertable<TBaseSite> {
  final int idBaseSite;
  final int? idInventor;
  final int? idDigitiser;
  final String? baseSiteName;
  final String? baseSiteDescription;
  final String? baseSiteCode;
  final DateTime? firstUseDate;
  final String? geom;
  final String? uuidBaseSite;
  final DateTime? metaCreateDate;
  final DateTime? metaUpdateDate;
  final int? altitudeMin;
  final int? altitudeMax;
  const TBaseSite(
      {required this.idBaseSite,
      this.idInventor,
      this.idDigitiser,
      this.baseSiteName,
      this.baseSiteDescription,
      this.baseSiteCode,
      this.firstUseDate,
      this.geom,
      this.uuidBaseSite,
      this.metaCreateDate,
      this.metaUpdateDate,
      this.altitudeMin,
      this.altitudeMax});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_base_site'] = Variable<int>(idBaseSite);
    if (!nullToAbsent || idInventor != null) {
      map['id_inventor'] = Variable<int>(idInventor);
    }
    if (!nullToAbsent || idDigitiser != null) {
      map['id_digitiser'] = Variable<int>(idDigitiser);
    }
    if (!nullToAbsent || baseSiteName != null) {
      map['base_site_name'] = Variable<String>(baseSiteName);
    }
    if (!nullToAbsent || baseSiteDescription != null) {
      map['base_site_description'] = Variable<String>(baseSiteDescription);
    }
    if (!nullToAbsent || baseSiteCode != null) {
      map['base_site_code'] = Variable<String>(baseSiteCode);
    }
    if (!nullToAbsent || firstUseDate != null) {
      map['first_use_date'] = Variable<DateTime>(firstUseDate);
    }
    if (!nullToAbsent || geom != null) {
      map['geom'] = Variable<String>(geom);
    }
    if (!nullToAbsent || uuidBaseSite != null) {
      map['uuid_base_site'] = Variable<String>(uuidBaseSite);
    }
    if (!nullToAbsent || metaCreateDate != null) {
      map['meta_create_date'] = Variable<DateTime>(metaCreateDate);
    }
    if (!nullToAbsent || metaUpdateDate != null) {
      map['meta_update_date'] = Variable<DateTime>(metaUpdateDate);
    }
    if (!nullToAbsent || altitudeMin != null) {
      map['altitude_min'] = Variable<int>(altitudeMin);
    }
    if (!nullToAbsent || altitudeMax != null) {
      map['altitude_max'] = Variable<int>(altitudeMax);
    }
    return map;
  }

  TBaseSitesCompanion toCompanion(bool nullToAbsent) {
    return TBaseSitesCompanion(
      idBaseSite: Value(idBaseSite),
      idInventor: idInventor == null && nullToAbsent
          ? const Value.absent()
          : Value(idInventor),
      idDigitiser: idDigitiser == null && nullToAbsent
          ? const Value.absent()
          : Value(idDigitiser),
      baseSiteName: baseSiteName == null && nullToAbsent
          ? const Value.absent()
          : Value(baseSiteName),
      baseSiteDescription: baseSiteDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(baseSiteDescription),
      baseSiteCode: baseSiteCode == null && nullToAbsent
          ? const Value.absent()
          : Value(baseSiteCode),
      firstUseDate: firstUseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(firstUseDate),
      geom: geom == null && nullToAbsent ? const Value.absent() : Value(geom),
      uuidBaseSite: uuidBaseSite == null && nullToAbsent
          ? const Value.absent()
          : Value(uuidBaseSite),
      metaCreateDate: metaCreateDate == null && nullToAbsent
          ? const Value.absent()
          : Value(metaCreateDate),
      metaUpdateDate: metaUpdateDate == null && nullToAbsent
          ? const Value.absent()
          : Value(metaUpdateDate),
      altitudeMin: altitudeMin == null && nullToAbsent
          ? const Value.absent()
          : Value(altitudeMin),
      altitudeMax: altitudeMax == null && nullToAbsent
          ? const Value.absent()
          : Value(altitudeMax),
    );
  }

  factory TBaseSite.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TBaseSite(
      idBaseSite: serializer.fromJson<int>(json['idBaseSite']),
      idInventor: serializer.fromJson<int?>(json['idInventor']),
      idDigitiser: serializer.fromJson<int?>(json['idDigitiser']),
      baseSiteName: serializer.fromJson<String?>(json['baseSiteName']),
      baseSiteDescription:
          serializer.fromJson<String?>(json['baseSiteDescription']),
      baseSiteCode: serializer.fromJson<String?>(json['baseSiteCode']),
      firstUseDate: serializer.fromJson<DateTime?>(json['firstUseDate']),
      geom: serializer.fromJson<String?>(json['geom']),
      uuidBaseSite: serializer.fromJson<String?>(json['uuidBaseSite']),
      metaCreateDate: serializer.fromJson<DateTime?>(json['metaCreateDate']),
      metaUpdateDate: serializer.fromJson<DateTime?>(json['metaUpdateDate']),
      altitudeMin: serializer.fromJson<int?>(json['altitudeMin']),
      altitudeMax: serializer.fromJson<int?>(json['altitudeMax']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idBaseSite': serializer.toJson<int>(idBaseSite),
      'idInventor': serializer.toJson<int?>(idInventor),
      'idDigitiser': serializer.toJson<int?>(idDigitiser),
      'baseSiteName': serializer.toJson<String?>(baseSiteName),
      'baseSiteDescription': serializer.toJson<String?>(baseSiteDescription),
      'baseSiteCode': serializer.toJson<String?>(baseSiteCode),
      'firstUseDate': serializer.toJson<DateTime?>(firstUseDate),
      'geom': serializer.toJson<String?>(geom),
      'uuidBaseSite': serializer.toJson<String?>(uuidBaseSite),
      'metaCreateDate': serializer.toJson<DateTime?>(metaCreateDate),
      'metaUpdateDate': serializer.toJson<DateTime?>(metaUpdateDate),
      'altitudeMin': serializer.toJson<int?>(altitudeMin),
      'altitudeMax': serializer.toJson<int?>(altitudeMax),
    };
  }

  TBaseSite copyWith(
          {int? idBaseSite,
          Value<int?> idInventor = const Value.absent(),
          Value<int?> idDigitiser = const Value.absent(),
          Value<String?> baseSiteName = const Value.absent(),
          Value<String?> baseSiteDescription = const Value.absent(),
          Value<String?> baseSiteCode = const Value.absent(),
          Value<DateTime?> firstUseDate = const Value.absent(),
          Value<String?> geom = const Value.absent(),
          Value<String?> uuidBaseSite = const Value.absent(),
          Value<DateTime?> metaCreateDate = const Value.absent(),
          Value<DateTime?> metaUpdateDate = const Value.absent(),
          Value<int?> altitudeMin = const Value.absent(),
          Value<int?> altitudeMax = const Value.absent()}) =>
      TBaseSite(
        idBaseSite: idBaseSite ?? this.idBaseSite,
        idInventor: idInventor.present ? idInventor.value : this.idInventor,
        idDigitiser: idDigitiser.present ? idDigitiser.value : this.idDigitiser,
        baseSiteName:
            baseSiteName.present ? baseSiteName.value : this.baseSiteName,
        baseSiteDescription: baseSiteDescription.present
            ? baseSiteDescription.value
            : this.baseSiteDescription,
        baseSiteCode:
            baseSiteCode.present ? baseSiteCode.value : this.baseSiteCode,
        firstUseDate:
            firstUseDate.present ? firstUseDate.value : this.firstUseDate,
        geom: geom.present ? geom.value : this.geom,
        uuidBaseSite:
            uuidBaseSite.present ? uuidBaseSite.value : this.uuidBaseSite,
        metaCreateDate:
            metaCreateDate.present ? metaCreateDate.value : this.metaCreateDate,
        metaUpdateDate:
            metaUpdateDate.present ? metaUpdateDate.value : this.metaUpdateDate,
        altitudeMin: altitudeMin.present ? altitudeMin.value : this.altitudeMin,
        altitudeMax: altitudeMax.present ? altitudeMax.value : this.altitudeMax,
      );
  TBaseSite copyWithCompanion(TBaseSitesCompanion data) {
    return TBaseSite(
      idBaseSite:
          data.idBaseSite.present ? data.idBaseSite.value : this.idBaseSite,
      idInventor:
          data.idInventor.present ? data.idInventor.value : this.idInventor,
      idDigitiser:
          data.idDigitiser.present ? data.idDigitiser.value : this.idDigitiser,
      baseSiteName: data.baseSiteName.present
          ? data.baseSiteName.value
          : this.baseSiteName,
      baseSiteDescription: data.baseSiteDescription.present
          ? data.baseSiteDescription.value
          : this.baseSiteDescription,
      baseSiteCode: data.baseSiteCode.present
          ? data.baseSiteCode.value
          : this.baseSiteCode,
      firstUseDate: data.firstUseDate.present
          ? data.firstUseDate.value
          : this.firstUseDate,
      geom: data.geom.present ? data.geom.value : this.geom,
      uuidBaseSite: data.uuidBaseSite.present
          ? data.uuidBaseSite.value
          : this.uuidBaseSite,
      metaCreateDate: data.metaCreateDate.present
          ? data.metaCreateDate.value
          : this.metaCreateDate,
      metaUpdateDate: data.metaUpdateDate.present
          ? data.metaUpdateDate.value
          : this.metaUpdateDate,
      altitudeMin:
          data.altitudeMin.present ? data.altitudeMin.value : this.altitudeMin,
      altitudeMax:
          data.altitudeMax.present ? data.altitudeMax.value : this.altitudeMax,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TBaseSite(')
          ..write('idBaseSite: $idBaseSite, ')
          ..write('idInventor: $idInventor, ')
          ..write('idDigitiser: $idDigitiser, ')
          ..write('baseSiteName: $baseSiteName, ')
          ..write('baseSiteDescription: $baseSiteDescription, ')
          ..write('baseSiteCode: $baseSiteCode, ')
          ..write('firstUseDate: $firstUseDate, ')
          ..write('geom: $geom, ')
          ..write('uuidBaseSite: $uuidBaseSite, ')
          ..write('metaCreateDate: $metaCreateDate, ')
          ..write('metaUpdateDate: $metaUpdateDate, ')
          ..write('altitudeMin: $altitudeMin, ')
          ..write('altitudeMax: $altitudeMax')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      idBaseSite,
      idInventor,
      idDigitiser,
      baseSiteName,
      baseSiteDescription,
      baseSiteCode,
      firstUseDate,
      geom,
      uuidBaseSite,
      metaCreateDate,
      metaUpdateDate,
      altitudeMin,
      altitudeMax);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TBaseSite &&
          other.idBaseSite == this.idBaseSite &&
          other.idInventor == this.idInventor &&
          other.idDigitiser == this.idDigitiser &&
          other.baseSiteName == this.baseSiteName &&
          other.baseSiteDescription == this.baseSiteDescription &&
          other.baseSiteCode == this.baseSiteCode &&
          other.firstUseDate == this.firstUseDate &&
          other.geom == this.geom &&
          other.uuidBaseSite == this.uuidBaseSite &&
          other.metaCreateDate == this.metaCreateDate &&
          other.metaUpdateDate == this.metaUpdateDate &&
          other.altitudeMin == this.altitudeMin &&
          other.altitudeMax == this.altitudeMax);
}

class TBaseSitesCompanion extends UpdateCompanion<TBaseSite> {
  final Value<int> idBaseSite;
  final Value<int?> idInventor;
  final Value<int?> idDigitiser;
  final Value<String?> baseSiteName;
  final Value<String?> baseSiteDescription;
  final Value<String?> baseSiteCode;
  final Value<DateTime?> firstUseDate;
  final Value<String?> geom;
  final Value<String?> uuidBaseSite;
  final Value<DateTime?> metaCreateDate;
  final Value<DateTime?> metaUpdateDate;
  final Value<int?> altitudeMin;
  final Value<int?> altitudeMax;
  const TBaseSitesCompanion({
    this.idBaseSite = const Value.absent(),
    this.idInventor = const Value.absent(),
    this.idDigitiser = const Value.absent(),
    this.baseSiteName = const Value.absent(),
    this.baseSiteDescription = const Value.absent(),
    this.baseSiteCode = const Value.absent(),
    this.firstUseDate = const Value.absent(),
    this.geom = const Value.absent(),
    this.uuidBaseSite = const Value.absent(),
    this.metaCreateDate = const Value.absent(),
    this.metaUpdateDate = const Value.absent(),
    this.altitudeMin = const Value.absent(),
    this.altitudeMax = const Value.absent(),
  });
  TBaseSitesCompanion.insert({
    this.idBaseSite = const Value.absent(),
    this.idInventor = const Value.absent(),
    this.idDigitiser = const Value.absent(),
    this.baseSiteName = const Value.absent(),
    this.baseSiteDescription = const Value.absent(),
    this.baseSiteCode = const Value.absent(),
    this.firstUseDate = const Value.absent(),
    this.geom = const Value.absent(),
    this.uuidBaseSite = const Value.absent(),
    this.metaCreateDate = const Value.absent(),
    this.metaUpdateDate = const Value.absent(),
    this.altitudeMin = const Value.absent(),
    this.altitudeMax = const Value.absent(),
  });
  static Insertable<TBaseSite> custom({
    Expression<int>? idBaseSite,
    Expression<int>? idInventor,
    Expression<int>? idDigitiser,
    Expression<String>? baseSiteName,
    Expression<String>? baseSiteDescription,
    Expression<String>? baseSiteCode,
    Expression<DateTime>? firstUseDate,
    Expression<String>? geom,
    Expression<String>? uuidBaseSite,
    Expression<DateTime>? metaCreateDate,
    Expression<DateTime>? metaUpdateDate,
    Expression<int>? altitudeMin,
    Expression<int>? altitudeMax,
  }) {
    return RawValuesInsertable({
      if (idBaseSite != null) 'id_base_site': idBaseSite,
      if (idInventor != null) 'id_inventor': idInventor,
      if (idDigitiser != null) 'id_digitiser': idDigitiser,
      if (baseSiteName != null) 'base_site_name': baseSiteName,
      if (baseSiteDescription != null)
        'base_site_description': baseSiteDescription,
      if (baseSiteCode != null) 'base_site_code': baseSiteCode,
      if (firstUseDate != null) 'first_use_date': firstUseDate,
      if (geom != null) 'geom': geom,
      if (uuidBaseSite != null) 'uuid_base_site': uuidBaseSite,
      if (metaCreateDate != null) 'meta_create_date': metaCreateDate,
      if (metaUpdateDate != null) 'meta_update_date': metaUpdateDate,
      if (altitudeMin != null) 'altitude_min': altitudeMin,
      if (altitudeMax != null) 'altitude_max': altitudeMax,
    });
  }

  TBaseSitesCompanion copyWith(
      {Value<int>? idBaseSite,
      Value<int?>? idInventor,
      Value<int?>? idDigitiser,
      Value<String?>? baseSiteName,
      Value<String?>? baseSiteDescription,
      Value<String?>? baseSiteCode,
      Value<DateTime?>? firstUseDate,
      Value<String?>? geom,
      Value<String?>? uuidBaseSite,
      Value<DateTime?>? metaCreateDate,
      Value<DateTime?>? metaUpdateDate,
      Value<int?>? altitudeMin,
      Value<int?>? altitudeMax}) {
    return TBaseSitesCompanion(
      idBaseSite: idBaseSite ?? this.idBaseSite,
      idInventor: idInventor ?? this.idInventor,
      idDigitiser: idDigitiser ?? this.idDigitiser,
      baseSiteName: baseSiteName ?? this.baseSiteName,
      baseSiteDescription: baseSiteDescription ?? this.baseSiteDescription,
      baseSiteCode: baseSiteCode ?? this.baseSiteCode,
      firstUseDate: firstUseDate ?? this.firstUseDate,
      geom: geom ?? this.geom,
      uuidBaseSite: uuidBaseSite ?? this.uuidBaseSite,
      metaCreateDate: metaCreateDate ?? this.metaCreateDate,
      metaUpdateDate: metaUpdateDate ?? this.metaUpdateDate,
      altitudeMin: altitudeMin ?? this.altitudeMin,
      altitudeMax: altitudeMax ?? this.altitudeMax,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idBaseSite.present) {
      map['id_base_site'] = Variable<int>(idBaseSite.value);
    }
    if (idInventor.present) {
      map['id_inventor'] = Variable<int>(idInventor.value);
    }
    if (idDigitiser.present) {
      map['id_digitiser'] = Variable<int>(idDigitiser.value);
    }
    if (baseSiteName.present) {
      map['base_site_name'] = Variable<String>(baseSiteName.value);
    }
    if (baseSiteDescription.present) {
      map['base_site_description'] =
          Variable<String>(baseSiteDescription.value);
    }
    if (baseSiteCode.present) {
      map['base_site_code'] = Variable<String>(baseSiteCode.value);
    }
    if (firstUseDate.present) {
      map['first_use_date'] = Variable<DateTime>(firstUseDate.value);
    }
    if (geom.present) {
      map['geom'] = Variable<String>(geom.value);
    }
    if (uuidBaseSite.present) {
      map['uuid_base_site'] = Variable<String>(uuidBaseSite.value);
    }
    if (metaCreateDate.present) {
      map['meta_create_date'] = Variable<DateTime>(metaCreateDate.value);
    }
    if (metaUpdateDate.present) {
      map['meta_update_date'] = Variable<DateTime>(metaUpdateDate.value);
    }
    if (altitudeMin.present) {
      map['altitude_min'] = Variable<int>(altitudeMin.value);
    }
    if (altitudeMax.present) {
      map['altitude_max'] = Variable<int>(altitudeMax.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TBaseSitesCompanion(')
          ..write('idBaseSite: $idBaseSite, ')
          ..write('idInventor: $idInventor, ')
          ..write('idDigitiser: $idDigitiser, ')
          ..write('baseSiteName: $baseSiteName, ')
          ..write('baseSiteDescription: $baseSiteDescription, ')
          ..write('baseSiteCode: $baseSiteCode, ')
          ..write('firstUseDate: $firstUseDate, ')
          ..write('geom: $geom, ')
          ..write('uuidBaseSite: $uuidBaseSite, ')
          ..write('metaCreateDate: $metaCreateDate, ')
          ..write('metaUpdateDate: $metaUpdateDate, ')
          ..write('altitudeMin: $altitudeMin, ')
          ..write('altitudeMax: $altitudeMax')
          ..write(')'))
        .toString();
  }
}

class $TNomenclaturesTable extends TNomenclatures
    with TableInfo<$TNomenclaturesTable, TNomenclature> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TNomenclaturesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idNomenclatureMeta =
      const VerificationMeta('idNomenclature');
  @override
  late final GeneratedColumn<int> idNomenclature = GeneratedColumn<int>(
      'id_nomenclature', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _idTypeMeta = const VerificationMeta('idType');
  @override
  late final GeneratedColumn<int> idType = GeneratedColumn<int>(
      'id_type', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _cdNomenclatureMeta =
      const VerificationMeta('cdNomenclature');
  @override
  late final GeneratedColumn<String> cdNomenclature = GeneratedColumn<String>(
      'cd_nomenclature', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mnemoniqueMeta =
      const VerificationMeta('mnemonique');
  @override
  late final GeneratedColumn<String> mnemonique = GeneratedColumn<String>(
      'mnemonique', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _codeTypeMeta =
      const VerificationMeta('codeType');
  @override
  late final GeneratedColumn<String> codeType = GeneratedColumn<String>(
      'code_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _labelDefaultMeta =
      const VerificationMeta('labelDefault');
  @override
  late final GeneratedColumn<String> labelDefault = GeneratedColumn<String>(
      'label_default', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _definitionDefaultMeta =
      const VerificationMeta('definitionDefault');
  @override
  late final GeneratedColumn<String> definitionDefault =
      GeneratedColumn<String>('definition_default', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _labelFrMeta =
      const VerificationMeta('labelFr');
  @override
  late final GeneratedColumn<String> labelFr = GeneratedColumn<String>(
      'label_fr', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _definitionFrMeta =
      const VerificationMeta('definitionFr');
  @override
  late final GeneratedColumn<String> definitionFr = GeneratedColumn<String>(
      'definition_fr', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _labelEnMeta =
      const VerificationMeta('labelEn');
  @override
  late final GeneratedColumn<String> labelEn = GeneratedColumn<String>(
      'label_en', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _definitionEnMeta =
      const VerificationMeta('definitionEn');
  @override
  late final GeneratedColumn<String> definitionEn = GeneratedColumn<String>(
      'definition_en', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _labelEsMeta =
      const VerificationMeta('labelEs');
  @override
  late final GeneratedColumn<String> labelEs = GeneratedColumn<String>(
      'label_es', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _definitionEsMeta =
      const VerificationMeta('definitionEs');
  @override
  late final GeneratedColumn<String> definitionEs = GeneratedColumn<String>(
      'definition_es', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _labelDeMeta =
      const VerificationMeta('labelDe');
  @override
  late final GeneratedColumn<String> labelDe = GeneratedColumn<String>(
      'label_de', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _definitionDeMeta =
      const VerificationMeta('definitionDe');
  @override
  late final GeneratedColumn<String> definitionDe = GeneratedColumn<String>(
      'definition_de', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _labelItMeta =
      const VerificationMeta('labelIt');
  @override
  late final GeneratedColumn<String> labelIt = GeneratedColumn<String>(
      'label_it', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _definitionItMeta =
      const VerificationMeta('definitionIt');
  @override
  late final GeneratedColumn<String> definitionIt = GeneratedColumn<String>(
      'definition_it', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statutMeta = const VerificationMeta('statut');
  @override
  late final GeneratedColumn<String> statut = GeneratedColumn<String>(
      'statut', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _idBroaderMeta =
      const VerificationMeta('idBroader');
  @override
  late final GeneratedColumn<int> idBroader = GeneratedColumn<int>(
      'id_broader', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _hierarchyMeta =
      const VerificationMeta('hierarchy');
  @override
  late final GeneratedColumn<String> hierarchy = GeneratedColumn<String>(
      'hierarchy', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
      'active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("active" IN (0, 1))'),
      defaultValue: Constant(true));
  static const VerificationMeta _metaCreateDateMeta =
      const VerificationMeta('metaCreateDate');
  @override
  late final GeneratedColumn<DateTime> metaCreateDate =
      GeneratedColumn<DateTime>('meta_create_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _metaUpdateDateMeta =
      const VerificationMeta('metaUpdateDate');
  @override
  late final GeneratedColumn<DateTime> metaUpdateDate =
      GeneratedColumn<DateTime>('meta_update_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        idNomenclature,
        idType,
        cdNomenclature,
        mnemonique,
        codeType,
        labelDefault,
        definitionDefault,
        labelFr,
        definitionFr,
        labelEn,
        definitionEn,
        labelEs,
        definitionEs,
        labelDe,
        definitionDe,
        labelIt,
        definitionIt,
        source,
        statut,
        idBroader,
        hierarchy,
        active,
        metaCreateDate,
        metaUpdateDate
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 't_nomenclatures';
  @override
  VerificationContext validateIntegrity(Insertable<TNomenclature> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_nomenclature')) {
      context.handle(
          _idNomenclatureMeta,
          idNomenclature.isAcceptableOrUnknown(
              data['id_nomenclature']!, _idNomenclatureMeta));
    }
    if (data.containsKey('id_type')) {
      context.handle(_idTypeMeta,
          idType.isAcceptableOrUnknown(data['id_type']!, _idTypeMeta));
    } else if (isInserting) {
      context.missing(_idTypeMeta);
    }
    if (data.containsKey('cd_nomenclature')) {
      context.handle(
          _cdNomenclatureMeta,
          cdNomenclature.isAcceptableOrUnknown(
              data['cd_nomenclature']!, _cdNomenclatureMeta));
    } else if (isInserting) {
      context.missing(_cdNomenclatureMeta);
    }
    if (data.containsKey('mnemonique')) {
      context.handle(
          _mnemoniqueMeta,
          mnemonique.isAcceptableOrUnknown(
              data['mnemonique']!, _mnemoniqueMeta));
    }
    if (data.containsKey('code_type')) {
      context.handle(_codeTypeMeta,
          codeType.isAcceptableOrUnknown(data['code_type']!, _codeTypeMeta));
    }
    if (data.containsKey('label_default')) {
      context.handle(
          _labelDefaultMeta,
          labelDefault.isAcceptableOrUnknown(
              data['label_default']!, _labelDefaultMeta));
    }
    if (data.containsKey('definition_default')) {
      context.handle(
          _definitionDefaultMeta,
          definitionDefault.isAcceptableOrUnknown(
              data['definition_default']!, _definitionDefaultMeta));
    }
    if (data.containsKey('label_fr')) {
      context.handle(_labelFrMeta,
          labelFr.isAcceptableOrUnknown(data['label_fr']!, _labelFrMeta));
    }
    if (data.containsKey('definition_fr')) {
      context.handle(
          _definitionFrMeta,
          definitionFr.isAcceptableOrUnknown(
              data['definition_fr']!, _definitionFrMeta));
    }
    if (data.containsKey('label_en')) {
      context.handle(_labelEnMeta,
          labelEn.isAcceptableOrUnknown(data['label_en']!, _labelEnMeta));
    }
    if (data.containsKey('definition_en')) {
      context.handle(
          _definitionEnMeta,
          definitionEn.isAcceptableOrUnknown(
              data['definition_en']!, _definitionEnMeta));
    }
    if (data.containsKey('label_es')) {
      context.handle(_labelEsMeta,
          labelEs.isAcceptableOrUnknown(data['label_es']!, _labelEsMeta));
    }
    if (data.containsKey('definition_es')) {
      context.handle(
          _definitionEsMeta,
          definitionEs.isAcceptableOrUnknown(
              data['definition_es']!, _definitionEsMeta));
    }
    if (data.containsKey('label_de')) {
      context.handle(_labelDeMeta,
          labelDe.isAcceptableOrUnknown(data['label_de']!, _labelDeMeta));
    }
    if (data.containsKey('definition_de')) {
      context.handle(
          _definitionDeMeta,
          definitionDe.isAcceptableOrUnknown(
              data['definition_de']!, _definitionDeMeta));
    }
    if (data.containsKey('label_it')) {
      context.handle(_labelItMeta,
          labelIt.isAcceptableOrUnknown(data['label_it']!, _labelItMeta));
    }
    if (data.containsKey('definition_it')) {
      context.handle(
          _definitionItMeta,
          definitionIt.isAcceptableOrUnknown(
              data['definition_it']!, _definitionItMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('statut')) {
      context.handle(_statutMeta,
          statut.isAcceptableOrUnknown(data['statut']!, _statutMeta));
    }
    if (data.containsKey('id_broader')) {
      context.handle(_idBroaderMeta,
          idBroader.isAcceptableOrUnknown(data['id_broader']!, _idBroaderMeta));
    }
    if (data.containsKey('hierarchy')) {
      context.handle(_hierarchyMeta,
          hierarchy.isAcceptableOrUnknown(data['hierarchy']!, _hierarchyMeta));
    }
    if (data.containsKey('active')) {
      context.handle(_activeMeta,
          active.isAcceptableOrUnknown(data['active']!, _activeMeta));
    }
    if (data.containsKey('meta_create_date')) {
      context.handle(
          _metaCreateDateMeta,
          metaCreateDate.isAcceptableOrUnknown(
              data['meta_create_date']!, _metaCreateDateMeta));
    }
    if (data.containsKey('meta_update_date')) {
      context.handle(
          _metaUpdateDateMeta,
          metaUpdateDate.isAcceptableOrUnknown(
              data['meta_update_date']!, _metaUpdateDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idNomenclature};
  @override
  TNomenclature map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TNomenclature(
      idNomenclature: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_nomenclature'])!,
      idType: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_type'])!,
      cdNomenclature: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}cd_nomenclature'])!,
      mnemonique: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mnemonique']),
      codeType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code_type']),
      labelDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label_default']),
      definitionDefault: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}definition_default']),
      labelFr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label_fr']),
      definitionFr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}definition_fr']),
      labelEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label_en']),
      definitionEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}definition_en']),
      labelEs: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label_es']),
      definitionEs: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}definition_es']),
      labelDe: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label_de']),
      definitionDe: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}definition_de']),
      labelIt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label_it']),
      definitionIt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}definition_it']),
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source']),
      statut: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}statut']),
      idBroader: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_broader']),
      hierarchy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hierarchy']),
      active: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}active'])!,
      metaCreateDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}meta_create_date']),
      metaUpdateDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}meta_update_date']),
    );
  }

  @override
  $TNomenclaturesTable createAlias(String alias) {
    return $TNomenclaturesTable(attachedDatabase, alias);
  }
}

class TNomenclature extends DataClass implements Insertable<TNomenclature> {
  final int idNomenclature;
  final int idType;
  final String cdNomenclature;
  final String? mnemonique;
  final String? codeType;
  final String? labelDefault;
  final String? definitionDefault;
  final String? labelFr;
  final String? definitionFr;
  final String? labelEn;
  final String? definitionEn;
  final String? labelEs;
  final String? definitionEs;
  final String? labelDe;
  final String? definitionDe;
  final String? labelIt;
  final String? definitionIt;
  final String? source;
  final String? statut;
  final int? idBroader;
  final String? hierarchy;
  final bool active;
  final DateTime? metaCreateDate;
  final DateTime? metaUpdateDate;
  const TNomenclature(
      {required this.idNomenclature,
      required this.idType,
      required this.cdNomenclature,
      this.mnemonique,
      this.codeType,
      this.labelDefault,
      this.definitionDefault,
      this.labelFr,
      this.definitionFr,
      this.labelEn,
      this.definitionEn,
      this.labelEs,
      this.definitionEs,
      this.labelDe,
      this.definitionDe,
      this.labelIt,
      this.definitionIt,
      this.source,
      this.statut,
      this.idBroader,
      this.hierarchy,
      required this.active,
      this.metaCreateDate,
      this.metaUpdateDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_nomenclature'] = Variable<int>(idNomenclature);
    map['id_type'] = Variable<int>(idType);
    map['cd_nomenclature'] = Variable<String>(cdNomenclature);
    if (!nullToAbsent || mnemonique != null) {
      map['mnemonique'] = Variable<String>(mnemonique);
    }
    if (!nullToAbsent || codeType != null) {
      map['code_type'] = Variable<String>(codeType);
    }
    if (!nullToAbsent || labelDefault != null) {
      map['label_default'] = Variable<String>(labelDefault);
    }
    if (!nullToAbsent || definitionDefault != null) {
      map['definition_default'] = Variable<String>(definitionDefault);
    }
    if (!nullToAbsent || labelFr != null) {
      map['label_fr'] = Variable<String>(labelFr);
    }
    if (!nullToAbsent || definitionFr != null) {
      map['definition_fr'] = Variable<String>(definitionFr);
    }
    if (!nullToAbsent || labelEn != null) {
      map['label_en'] = Variable<String>(labelEn);
    }
    if (!nullToAbsent || definitionEn != null) {
      map['definition_en'] = Variable<String>(definitionEn);
    }
    if (!nullToAbsent || labelEs != null) {
      map['label_es'] = Variable<String>(labelEs);
    }
    if (!nullToAbsent || definitionEs != null) {
      map['definition_es'] = Variable<String>(definitionEs);
    }
    if (!nullToAbsent || labelDe != null) {
      map['label_de'] = Variable<String>(labelDe);
    }
    if (!nullToAbsent || definitionDe != null) {
      map['definition_de'] = Variable<String>(definitionDe);
    }
    if (!nullToAbsent || labelIt != null) {
      map['label_it'] = Variable<String>(labelIt);
    }
    if (!nullToAbsent || definitionIt != null) {
      map['definition_it'] = Variable<String>(definitionIt);
    }
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    if (!nullToAbsent || statut != null) {
      map['statut'] = Variable<String>(statut);
    }
    if (!nullToAbsent || idBroader != null) {
      map['id_broader'] = Variable<int>(idBroader);
    }
    if (!nullToAbsent || hierarchy != null) {
      map['hierarchy'] = Variable<String>(hierarchy);
    }
    map['active'] = Variable<bool>(active);
    if (!nullToAbsent || metaCreateDate != null) {
      map['meta_create_date'] = Variable<DateTime>(metaCreateDate);
    }
    if (!nullToAbsent || metaUpdateDate != null) {
      map['meta_update_date'] = Variable<DateTime>(metaUpdateDate);
    }
    return map;
  }

  TNomenclaturesCompanion toCompanion(bool nullToAbsent) {
    return TNomenclaturesCompanion(
      idNomenclature: Value(idNomenclature),
      idType: Value(idType),
      cdNomenclature: Value(cdNomenclature),
      mnemonique: mnemonique == null && nullToAbsent
          ? const Value.absent()
          : Value(mnemonique),
      codeType: codeType == null && nullToAbsent
          ? const Value.absent()
          : Value(codeType),
      labelDefault: labelDefault == null && nullToAbsent
          ? const Value.absent()
          : Value(labelDefault),
      definitionDefault: definitionDefault == null && nullToAbsent
          ? const Value.absent()
          : Value(definitionDefault),
      labelFr: labelFr == null && nullToAbsent
          ? const Value.absent()
          : Value(labelFr),
      definitionFr: definitionFr == null && nullToAbsent
          ? const Value.absent()
          : Value(definitionFr),
      labelEn: labelEn == null && nullToAbsent
          ? const Value.absent()
          : Value(labelEn),
      definitionEn: definitionEn == null && nullToAbsent
          ? const Value.absent()
          : Value(definitionEn),
      labelEs: labelEs == null && nullToAbsent
          ? const Value.absent()
          : Value(labelEs),
      definitionEs: definitionEs == null && nullToAbsent
          ? const Value.absent()
          : Value(definitionEs),
      labelDe: labelDe == null && nullToAbsent
          ? const Value.absent()
          : Value(labelDe),
      definitionDe: definitionDe == null && nullToAbsent
          ? const Value.absent()
          : Value(definitionDe),
      labelIt: labelIt == null && nullToAbsent
          ? const Value.absent()
          : Value(labelIt),
      definitionIt: definitionIt == null && nullToAbsent
          ? const Value.absent()
          : Value(definitionIt),
      source:
          source == null && nullToAbsent ? const Value.absent() : Value(source),
      statut:
          statut == null && nullToAbsent ? const Value.absent() : Value(statut),
      idBroader: idBroader == null && nullToAbsent
          ? const Value.absent()
          : Value(idBroader),
      hierarchy: hierarchy == null && nullToAbsent
          ? const Value.absent()
          : Value(hierarchy),
      active: Value(active),
      metaCreateDate: metaCreateDate == null && nullToAbsent
          ? const Value.absent()
          : Value(metaCreateDate),
      metaUpdateDate: metaUpdateDate == null && nullToAbsent
          ? const Value.absent()
          : Value(metaUpdateDate),
    );
  }

  factory TNomenclature.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TNomenclature(
      idNomenclature: serializer.fromJson<int>(json['idNomenclature']),
      idType: serializer.fromJson<int>(json['idType']),
      cdNomenclature: serializer.fromJson<String>(json['cdNomenclature']),
      mnemonique: serializer.fromJson<String?>(json['mnemonique']),
      codeType: serializer.fromJson<String?>(json['codeType']),
      labelDefault: serializer.fromJson<String?>(json['labelDefault']),
      definitionDefault:
          serializer.fromJson<String?>(json['definitionDefault']),
      labelFr: serializer.fromJson<String?>(json['labelFr']),
      definitionFr: serializer.fromJson<String?>(json['definitionFr']),
      labelEn: serializer.fromJson<String?>(json['labelEn']),
      definitionEn: serializer.fromJson<String?>(json['definitionEn']),
      labelEs: serializer.fromJson<String?>(json['labelEs']),
      definitionEs: serializer.fromJson<String?>(json['definitionEs']),
      labelDe: serializer.fromJson<String?>(json['labelDe']),
      definitionDe: serializer.fromJson<String?>(json['definitionDe']),
      labelIt: serializer.fromJson<String?>(json['labelIt']),
      definitionIt: serializer.fromJson<String?>(json['definitionIt']),
      source: serializer.fromJson<String?>(json['source']),
      statut: serializer.fromJson<String?>(json['statut']),
      idBroader: serializer.fromJson<int?>(json['idBroader']),
      hierarchy: serializer.fromJson<String?>(json['hierarchy']),
      active: serializer.fromJson<bool>(json['active']),
      metaCreateDate: serializer.fromJson<DateTime?>(json['metaCreateDate']),
      metaUpdateDate: serializer.fromJson<DateTime?>(json['metaUpdateDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idNomenclature': serializer.toJson<int>(idNomenclature),
      'idType': serializer.toJson<int>(idType),
      'cdNomenclature': serializer.toJson<String>(cdNomenclature),
      'mnemonique': serializer.toJson<String?>(mnemonique),
      'codeType': serializer.toJson<String?>(codeType),
      'labelDefault': serializer.toJson<String?>(labelDefault),
      'definitionDefault': serializer.toJson<String?>(definitionDefault),
      'labelFr': serializer.toJson<String?>(labelFr),
      'definitionFr': serializer.toJson<String?>(definitionFr),
      'labelEn': serializer.toJson<String?>(labelEn),
      'definitionEn': serializer.toJson<String?>(definitionEn),
      'labelEs': serializer.toJson<String?>(labelEs),
      'definitionEs': serializer.toJson<String?>(definitionEs),
      'labelDe': serializer.toJson<String?>(labelDe),
      'definitionDe': serializer.toJson<String?>(definitionDe),
      'labelIt': serializer.toJson<String?>(labelIt),
      'definitionIt': serializer.toJson<String?>(definitionIt),
      'source': serializer.toJson<String?>(source),
      'statut': serializer.toJson<String?>(statut),
      'idBroader': serializer.toJson<int?>(idBroader),
      'hierarchy': serializer.toJson<String?>(hierarchy),
      'active': serializer.toJson<bool>(active),
      'metaCreateDate': serializer.toJson<DateTime?>(metaCreateDate),
      'metaUpdateDate': serializer.toJson<DateTime?>(metaUpdateDate),
    };
  }

  TNomenclature copyWith(
          {int? idNomenclature,
          int? idType,
          String? cdNomenclature,
          Value<String?> mnemonique = const Value.absent(),
          Value<String?> codeType = const Value.absent(),
          Value<String?> labelDefault = const Value.absent(),
          Value<String?> definitionDefault = const Value.absent(),
          Value<String?> labelFr = const Value.absent(),
          Value<String?> definitionFr = const Value.absent(),
          Value<String?> labelEn = const Value.absent(),
          Value<String?> definitionEn = const Value.absent(),
          Value<String?> labelEs = const Value.absent(),
          Value<String?> definitionEs = const Value.absent(),
          Value<String?> labelDe = const Value.absent(),
          Value<String?> definitionDe = const Value.absent(),
          Value<String?> labelIt = const Value.absent(),
          Value<String?> definitionIt = const Value.absent(),
          Value<String?> source = const Value.absent(),
          Value<String?> statut = const Value.absent(),
          Value<int?> idBroader = const Value.absent(),
          Value<String?> hierarchy = const Value.absent(),
          bool? active,
          Value<DateTime?> metaCreateDate = const Value.absent(),
          Value<DateTime?> metaUpdateDate = const Value.absent()}) =>
      TNomenclature(
        idNomenclature: idNomenclature ?? this.idNomenclature,
        idType: idType ?? this.idType,
        cdNomenclature: cdNomenclature ?? this.cdNomenclature,
        mnemonique: mnemonique.present ? mnemonique.value : this.mnemonique,
        codeType: codeType.present ? codeType.value : this.codeType,
        labelDefault:
            labelDefault.present ? labelDefault.value : this.labelDefault,
        definitionDefault: definitionDefault.present
            ? definitionDefault.value
            : this.definitionDefault,
        labelFr: labelFr.present ? labelFr.value : this.labelFr,
        definitionFr:
            definitionFr.present ? definitionFr.value : this.definitionFr,
        labelEn: labelEn.present ? labelEn.value : this.labelEn,
        definitionEn:
            definitionEn.present ? definitionEn.value : this.definitionEn,
        labelEs: labelEs.present ? labelEs.value : this.labelEs,
        definitionEs:
            definitionEs.present ? definitionEs.value : this.definitionEs,
        labelDe: labelDe.present ? labelDe.value : this.labelDe,
        definitionDe:
            definitionDe.present ? definitionDe.value : this.definitionDe,
        labelIt: labelIt.present ? labelIt.value : this.labelIt,
        definitionIt:
            definitionIt.present ? definitionIt.value : this.definitionIt,
        source: source.present ? source.value : this.source,
        statut: statut.present ? statut.value : this.statut,
        idBroader: idBroader.present ? idBroader.value : this.idBroader,
        hierarchy: hierarchy.present ? hierarchy.value : this.hierarchy,
        active: active ?? this.active,
        metaCreateDate:
            metaCreateDate.present ? metaCreateDate.value : this.metaCreateDate,
        metaUpdateDate:
            metaUpdateDate.present ? metaUpdateDate.value : this.metaUpdateDate,
      );
  TNomenclature copyWithCompanion(TNomenclaturesCompanion data) {
    return TNomenclature(
      idNomenclature: data.idNomenclature.present
          ? data.idNomenclature.value
          : this.idNomenclature,
      idType: data.idType.present ? data.idType.value : this.idType,
      cdNomenclature: data.cdNomenclature.present
          ? data.cdNomenclature.value
          : this.cdNomenclature,
      mnemonique:
          data.mnemonique.present ? data.mnemonique.value : this.mnemonique,
      codeType: data.codeType.present ? data.codeType.value : this.codeType,
      labelDefault: data.labelDefault.present
          ? data.labelDefault.value
          : this.labelDefault,
      definitionDefault: data.definitionDefault.present
          ? data.definitionDefault.value
          : this.definitionDefault,
      labelFr: data.labelFr.present ? data.labelFr.value : this.labelFr,
      definitionFr: data.definitionFr.present
          ? data.definitionFr.value
          : this.definitionFr,
      labelEn: data.labelEn.present ? data.labelEn.value : this.labelEn,
      definitionEn: data.definitionEn.present
          ? data.definitionEn.value
          : this.definitionEn,
      labelEs: data.labelEs.present ? data.labelEs.value : this.labelEs,
      definitionEs: data.definitionEs.present
          ? data.definitionEs.value
          : this.definitionEs,
      labelDe: data.labelDe.present ? data.labelDe.value : this.labelDe,
      definitionDe: data.definitionDe.present
          ? data.definitionDe.value
          : this.definitionDe,
      labelIt: data.labelIt.present ? data.labelIt.value : this.labelIt,
      definitionIt: data.definitionIt.present
          ? data.definitionIt.value
          : this.definitionIt,
      source: data.source.present ? data.source.value : this.source,
      statut: data.statut.present ? data.statut.value : this.statut,
      idBroader: data.idBroader.present ? data.idBroader.value : this.idBroader,
      hierarchy: data.hierarchy.present ? data.hierarchy.value : this.hierarchy,
      active: data.active.present ? data.active.value : this.active,
      metaCreateDate: data.metaCreateDate.present
          ? data.metaCreateDate.value
          : this.metaCreateDate,
      metaUpdateDate: data.metaUpdateDate.present
          ? data.metaUpdateDate.value
          : this.metaUpdateDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TNomenclature(')
          ..write('idNomenclature: $idNomenclature, ')
          ..write('idType: $idType, ')
          ..write('cdNomenclature: $cdNomenclature, ')
          ..write('mnemonique: $mnemonique, ')
          ..write('codeType: $codeType, ')
          ..write('labelDefault: $labelDefault, ')
          ..write('definitionDefault: $definitionDefault, ')
          ..write('labelFr: $labelFr, ')
          ..write('definitionFr: $definitionFr, ')
          ..write('labelEn: $labelEn, ')
          ..write('definitionEn: $definitionEn, ')
          ..write('labelEs: $labelEs, ')
          ..write('definitionEs: $definitionEs, ')
          ..write('labelDe: $labelDe, ')
          ..write('definitionDe: $definitionDe, ')
          ..write('labelIt: $labelIt, ')
          ..write('definitionIt: $definitionIt, ')
          ..write('source: $source, ')
          ..write('statut: $statut, ')
          ..write('idBroader: $idBroader, ')
          ..write('hierarchy: $hierarchy, ')
          ..write('active: $active, ')
          ..write('metaCreateDate: $metaCreateDate, ')
          ..write('metaUpdateDate: $metaUpdateDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        idNomenclature,
        idType,
        cdNomenclature,
        mnemonique,
        codeType,
        labelDefault,
        definitionDefault,
        labelFr,
        definitionFr,
        labelEn,
        definitionEn,
        labelEs,
        definitionEs,
        labelDe,
        definitionDe,
        labelIt,
        definitionIt,
        source,
        statut,
        idBroader,
        hierarchy,
        active,
        metaCreateDate,
        metaUpdateDate
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TNomenclature &&
          other.idNomenclature == this.idNomenclature &&
          other.idType == this.idType &&
          other.cdNomenclature == this.cdNomenclature &&
          other.mnemonique == this.mnemonique &&
          other.codeType == this.codeType &&
          other.labelDefault == this.labelDefault &&
          other.definitionDefault == this.definitionDefault &&
          other.labelFr == this.labelFr &&
          other.definitionFr == this.definitionFr &&
          other.labelEn == this.labelEn &&
          other.definitionEn == this.definitionEn &&
          other.labelEs == this.labelEs &&
          other.definitionEs == this.definitionEs &&
          other.labelDe == this.labelDe &&
          other.definitionDe == this.definitionDe &&
          other.labelIt == this.labelIt &&
          other.definitionIt == this.definitionIt &&
          other.source == this.source &&
          other.statut == this.statut &&
          other.idBroader == this.idBroader &&
          other.hierarchy == this.hierarchy &&
          other.active == this.active &&
          other.metaCreateDate == this.metaCreateDate &&
          other.metaUpdateDate == this.metaUpdateDate);
}

class TNomenclaturesCompanion extends UpdateCompanion<TNomenclature> {
  final Value<int> idNomenclature;
  final Value<int> idType;
  final Value<String> cdNomenclature;
  final Value<String?> mnemonique;
  final Value<String?> codeType;
  final Value<String?> labelDefault;
  final Value<String?> definitionDefault;
  final Value<String?> labelFr;
  final Value<String?> definitionFr;
  final Value<String?> labelEn;
  final Value<String?> definitionEn;
  final Value<String?> labelEs;
  final Value<String?> definitionEs;
  final Value<String?> labelDe;
  final Value<String?> definitionDe;
  final Value<String?> labelIt;
  final Value<String?> definitionIt;
  final Value<String?> source;
  final Value<String?> statut;
  final Value<int?> idBroader;
  final Value<String?> hierarchy;
  final Value<bool> active;
  final Value<DateTime?> metaCreateDate;
  final Value<DateTime?> metaUpdateDate;
  const TNomenclaturesCompanion({
    this.idNomenclature = const Value.absent(),
    this.idType = const Value.absent(),
    this.cdNomenclature = const Value.absent(),
    this.mnemonique = const Value.absent(),
    this.codeType = const Value.absent(),
    this.labelDefault = const Value.absent(),
    this.definitionDefault = const Value.absent(),
    this.labelFr = const Value.absent(),
    this.definitionFr = const Value.absent(),
    this.labelEn = const Value.absent(),
    this.definitionEn = const Value.absent(),
    this.labelEs = const Value.absent(),
    this.definitionEs = const Value.absent(),
    this.labelDe = const Value.absent(),
    this.definitionDe = const Value.absent(),
    this.labelIt = const Value.absent(),
    this.definitionIt = const Value.absent(),
    this.source = const Value.absent(),
    this.statut = const Value.absent(),
    this.idBroader = const Value.absent(),
    this.hierarchy = const Value.absent(),
    this.active = const Value.absent(),
    this.metaCreateDate = const Value.absent(),
    this.metaUpdateDate = const Value.absent(),
  });
  TNomenclaturesCompanion.insert({
    this.idNomenclature = const Value.absent(),
    required int idType,
    required String cdNomenclature,
    this.mnemonique = const Value.absent(),
    this.codeType = const Value.absent(),
    this.labelDefault = const Value.absent(),
    this.definitionDefault = const Value.absent(),
    this.labelFr = const Value.absent(),
    this.definitionFr = const Value.absent(),
    this.labelEn = const Value.absent(),
    this.definitionEn = const Value.absent(),
    this.labelEs = const Value.absent(),
    this.definitionEs = const Value.absent(),
    this.labelDe = const Value.absent(),
    this.definitionDe = const Value.absent(),
    this.labelIt = const Value.absent(),
    this.definitionIt = const Value.absent(),
    this.source = const Value.absent(),
    this.statut = const Value.absent(),
    this.idBroader = const Value.absent(),
    this.hierarchy = const Value.absent(),
    this.active = const Value.absent(),
    this.metaCreateDate = const Value.absent(),
    this.metaUpdateDate = const Value.absent(),
  })  : idType = Value(idType),
        cdNomenclature = Value(cdNomenclature);
  static Insertable<TNomenclature> custom({
    Expression<int>? idNomenclature,
    Expression<int>? idType,
    Expression<String>? cdNomenclature,
    Expression<String>? mnemonique,
    Expression<String>? codeType,
    Expression<String>? labelDefault,
    Expression<String>? definitionDefault,
    Expression<String>? labelFr,
    Expression<String>? definitionFr,
    Expression<String>? labelEn,
    Expression<String>? definitionEn,
    Expression<String>? labelEs,
    Expression<String>? definitionEs,
    Expression<String>? labelDe,
    Expression<String>? definitionDe,
    Expression<String>? labelIt,
    Expression<String>? definitionIt,
    Expression<String>? source,
    Expression<String>? statut,
    Expression<int>? idBroader,
    Expression<String>? hierarchy,
    Expression<bool>? active,
    Expression<DateTime>? metaCreateDate,
    Expression<DateTime>? metaUpdateDate,
  }) {
    return RawValuesInsertable({
      if (idNomenclature != null) 'id_nomenclature': idNomenclature,
      if (idType != null) 'id_type': idType,
      if (cdNomenclature != null) 'cd_nomenclature': cdNomenclature,
      if (mnemonique != null) 'mnemonique': mnemonique,
      if (codeType != null) 'code_type': codeType,
      if (labelDefault != null) 'label_default': labelDefault,
      if (definitionDefault != null) 'definition_default': definitionDefault,
      if (labelFr != null) 'label_fr': labelFr,
      if (definitionFr != null) 'definition_fr': definitionFr,
      if (labelEn != null) 'label_en': labelEn,
      if (definitionEn != null) 'definition_en': definitionEn,
      if (labelEs != null) 'label_es': labelEs,
      if (definitionEs != null) 'definition_es': definitionEs,
      if (labelDe != null) 'label_de': labelDe,
      if (definitionDe != null) 'definition_de': definitionDe,
      if (labelIt != null) 'label_it': labelIt,
      if (definitionIt != null) 'definition_it': definitionIt,
      if (source != null) 'source': source,
      if (statut != null) 'statut': statut,
      if (idBroader != null) 'id_broader': idBroader,
      if (hierarchy != null) 'hierarchy': hierarchy,
      if (active != null) 'active': active,
      if (metaCreateDate != null) 'meta_create_date': metaCreateDate,
      if (metaUpdateDate != null) 'meta_update_date': metaUpdateDate,
    });
  }

  TNomenclaturesCompanion copyWith(
      {Value<int>? idNomenclature,
      Value<int>? idType,
      Value<String>? cdNomenclature,
      Value<String?>? mnemonique,
      Value<String?>? codeType,
      Value<String?>? labelDefault,
      Value<String?>? definitionDefault,
      Value<String?>? labelFr,
      Value<String?>? definitionFr,
      Value<String?>? labelEn,
      Value<String?>? definitionEn,
      Value<String?>? labelEs,
      Value<String?>? definitionEs,
      Value<String?>? labelDe,
      Value<String?>? definitionDe,
      Value<String?>? labelIt,
      Value<String?>? definitionIt,
      Value<String?>? source,
      Value<String?>? statut,
      Value<int?>? idBroader,
      Value<String?>? hierarchy,
      Value<bool>? active,
      Value<DateTime?>? metaCreateDate,
      Value<DateTime?>? metaUpdateDate}) {
    return TNomenclaturesCompanion(
      idNomenclature: idNomenclature ?? this.idNomenclature,
      idType: idType ?? this.idType,
      cdNomenclature: cdNomenclature ?? this.cdNomenclature,
      mnemonique: mnemonique ?? this.mnemonique,
      codeType: codeType ?? this.codeType,
      labelDefault: labelDefault ?? this.labelDefault,
      definitionDefault: definitionDefault ?? this.definitionDefault,
      labelFr: labelFr ?? this.labelFr,
      definitionFr: definitionFr ?? this.definitionFr,
      labelEn: labelEn ?? this.labelEn,
      definitionEn: definitionEn ?? this.definitionEn,
      labelEs: labelEs ?? this.labelEs,
      definitionEs: definitionEs ?? this.definitionEs,
      labelDe: labelDe ?? this.labelDe,
      definitionDe: definitionDe ?? this.definitionDe,
      labelIt: labelIt ?? this.labelIt,
      definitionIt: definitionIt ?? this.definitionIt,
      source: source ?? this.source,
      statut: statut ?? this.statut,
      idBroader: idBroader ?? this.idBroader,
      hierarchy: hierarchy ?? this.hierarchy,
      active: active ?? this.active,
      metaCreateDate: metaCreateDate ?? this.metaCreateDate,
      metaUpdateDate: metaUpdateDate ?? this.metaUpdateDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idNomenclature.present) {
      map['id_nomenclature'] = Variable<int>(idNomenclature.value);
    }
    if (idType.present) {
      map['id_type'] = Variable<int>(idType.value);
    }
    if (cdNomenclature.present) {
      map['cd_nomenclature'] = Variable<String>(cdNomenclature.value);
    }
    if (mnemonique.present) {
      map['mnemonique'] = Variable<String>(mnemonique.value);
    }
    if (codeType.present) {
      map['code_type'] = Variable<String>(codeType.value);
    }
    if (labelDefault.present) {
      map['label_default'] = Variable<String>(labelDefault.value);
    }
    if (definitionDefault.present) {
      map['definition_default'] = Variable<String>(definitionDefault.value);
    }
    if (labelFr.present) {
      map['label_fr'] = Variable<String>(labelFr.value);
    }
    if (definitionFr.present) {
      map['definition_fr'] = Variable<String>(definitionFr.value);
    }
    if (labelEn.present) {
      map['label_en'] = Variable<String>(labelEn.value);
    }
    if (definitionEn.present) {
      map['definition_en'] = Variable<String>(definitionEn.value);
    }
    if (labelEs.present) {
      map['label_es'] = Variable<String>(labelEs.value);
    }
    if (definitionEs.present) {
      map['definition_es'] = Variable<String>(definitionEs.value);
    }
    if (labelDe.present) {
      map['label_de'] = Variable<String>(labelDe.value);
    }
    if (definitionDe.present) {
      map['definition_de'] = Variable<String>(definitionDe.value);
    }
    if (labelIt.present) {
      map['label_it'] = Variable<String>(labelIt.value);
    }
    if (definitionIt.present) {
      map['definition_it'] = Variable<String>(definitionIt.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (statut.present) {
      map['statut'] = Variable<String>(statut.value);
    }
    if (idBroader.present) {
      map['id_broader'] = Variable<int>(idBroader.value);
    }
    if (hierarchy.present) {
      map['hierarchy'] = Variable<String>(hierarchy.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (metaCreateDate.present) {
      map['meta_create_date'] = Variable<DateTime>(metaCreateDate.value);
    }
    if (metaUpdateDate.present) {
      map['meta_update_date'] = Variable<DateTime>(metaUpdateDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TNomenclaturesCompanion(')
          ..write('idNomenclature: $idNomenclature, ')
          ..write('idType: $idType, ')
          ..write('cdNomenclature: $cdNomenclature, ')
          ..write('mnemonique: $mnemonique, ')
          ..write('codeType: $codeType, ')
          ..write('labelDefault: $labelDefault, ')
          ..write('definitionDefault: $definitionDefault, ')
          ..write('labelFr: $labelFr, ')
          ..write('definitionFr: $definitionFr, ')
          ..write('labelEn: $labelEn, ')
          ..write('definitionEn: $definitionEn, ')
          ..write('labelEs: $labelEs, ')
          ..write('definitionEs: $definitionEs, ')
          ..write('labelDe: $labelDe, ')
          ..write('definitionDe: $definitionDe, ')
          ..write('labelIt: $labelIt, ')
          ..write('definitionIt: $definitionIt, ')
          ..write('source: $source, ')
          ..write('statut: $statut, ')
          ..write('idBroader: $idBroader, ')
          ..write('hierarchy: $hierarchy, ')
          ..write('active: $active, ')
          ..write('metaCreateDate: $metaCreateDate, ')
          ..write('metaUpdateDate: $metaUpdateDate')
          ..write(')'))
        .toString();
  }
}

class $TDatasetsTable extends TDatasets
    with TableInfo<$TDatasetsTable, TDataset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TDatasetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idDatasetMeta =
      const VerificationMeta('idDataset');
  @override
  late final GeneratedColumn<int> idDataset = GeneratedColumn<int>(
      'id_dataset', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uniqueDatasetIdMeta =
      const VerificationMeta('uniqueDatasetId');
  @override
  late final GeneratedColumn<String> uniqueDatasetId = GeneratedColumn<String>(
      'unique_dataset_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _idAcquisitionFrameworkMeta =
      const VerificationMeta('idAcquisitionFramework');
  @override
  late final GeneratedColumn<int> idAcquisitionFramework = GeneratedColumn<int>(
      'id_acquisition_framework', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _datasetNameMeta =
      const VerificationMeta('datasetName');
  @override
  late final GeneratedColumn<String> datasetName = GeneratedColumn<String>(
      'dataset_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _datasetShortnameMeta =
      const VerificationMeta('datasetShortname');
  @override
  late final GeneratedColumn<String> datasetShortname = GeneratedColumn<String>(
      'dataset_shortname', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _datasetDescMeta =
      const VerificationMeta('datasetDesc');
  @override
  late final GeneratedColumn<String> datasetDesc = GeneratedColumn<String>(
      'dataset_desc', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _idNomenclatureDataTypeMeta =
      const VerificationMeta('idNomenclatureDataType');
  @override
  late final GeneratedColumn<int> idNomenclatureDataType = GeneratedColumn<int>(
      'id_nomenclature_data_type', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _keywordsMeta =
      const VerificationMeta('keywords');
  @override
  late final GeneratedColumn<String> keywords = GeneratedColumn<String>(
      'keywords', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _marineDomainMeta =
      const VerificationMeta('marineDomain');
  @override
  late final GeneratedColumn<bool> marineDomain = GeneratedColumn<bool>(
      'marine_domain', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("marine_domain" IN (0, 1))'));
  static const VerificationMeta _terrestrialDomainMeta =
      const VerificationMeta('terrestrialDomain');
  @override
  late final GeneratedColumn<bool> terrestrialDomain = GeneratedColumn<bool>(
      'terrestrial_domain', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("terrestrial_domain" IN (0, 1))'));
  static const VerificationMeta _idNomenclatureDatasetObjectifMeta =
      const VerificationMeta('idNomenclatureDatasetObjectif');
  @override
  late final GeneratedColumn<int> idNomenclatureDatasetObjectif =
      GeneratedColumn<int>(
          'id_nomenclature_dataset_objectif', aliasedName, false,
          type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _bboxWestMeta =
      const VerificationMeta('bboxWest');
  @override
  late final GeneratedColumn<double> bboxWest = GeneratedColumn<double>(
      'bbox_west', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _bboxEastMeta =
      const VerificationMeta('bboxEast');
  @override
  late final GeneratedColumn<double> bboxEast = GeneratedColumn<double>(
      'bbox_east', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _bboxSouthMeta =
      const VerificationMeta('bboxSouth');
  @override
  late final GeneratedColumn<double> bboxSouth = GeneratedColumn<double>(
      'bbox_south', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _bboxNorthMeta =
      const VerificationMeta('bboxNorth');
  @override
  late final GeneratedColumn<double> bboxNorth = GeneratedColumn<double>(
      'bbox_north', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _idNomenclatureCollectingMethodMeta =
      const VerificationMeta('idNomenclatureCollectingMethod');
  @override
  late final GeneratedColumn<int> idNomenclatureCollectingMethod =
      GeneratedColumn<int>(
          'id_nomenclature_collecting_method', aliasedName, false,
          type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _idNomenclatureDataOriginMeta =
      const VerificationMeta('idNomenclatureDataOrigin');
  @override
  late final GeneratedColumn<int> idNomenclatureDataOrigin =
      GeneratedColumn<int>('id_nomenclature_data_origin', aliasedName, false,
          type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _idNomenclatureSourceStatusMeta =
      const VerificationMeta('idNomenclatureSourceStatus');
  @override
  late final GeneratedColumn<int> idNomenclatureSourceStatus =
      GeneratedColumn<int>('id_nomenclature_source_status', aliasedName, false,
          type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _idNomenclatureResourceTypeMeta =
      const VerificationMeta('idNomenclatureResourceType');
  @override
  late final GeneratedColumn<int> idNomenclatureResourceType =
      GeneratedColumn<int>('id_nomenclature_resource_type', aliasedName, false,
          type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
      'active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("active" IN (0, 1))'),
      defaultValue: Constant(true));
  static const VerificationMeta _validableMeta =
      const VerificationMeta('validable');
  @override
  late final GeneratedColumn<bool> validable = GeneratedColumn<bool>(
      'validable', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("validable" IN (0, 1))'),
      defaultValue: Constant(true));
  static const VerificationMeta _idDigitizerMeta =
      const VerificationMeta('idDigitizer');
  @override
  late final GeneratedColumn<int> idDigitizer = GeneratedColumn<int>(
      'id_digitizer', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _idTaxaListMeta =
      const VerificationMeta('idTaxaList');
  @override
  late final GeneratedColumn<int> idTaxaList = GeneratedColumn<int>(
      'id_taxa_list', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _metaCreateDateMeta =
      const VerificationMeta('metaCreateDate');
  @override
  late final GeneratedColumn<DateTime> metaCreateDate =
      GeneratedColumn<DateTime>('meta_create_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _metaUpdateDateMeta =
      const VerificationMeta('metaUpdateDate');
  @override
  late final GeneratedColumn<DateTime> metaUpdateDate =
      GeneratedColumn<DateTime>('meta_update_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        idDataset,
        uniqueDatasetId,
        idAcquisitionFramework,
        datasetName,
        datasetShortname,
        datasetDesc,
        idNomenclatureDataType,
        keywords,
        marineDomain,
        terrestrialDomain,
        idNomenclatureDatasetObjectif,
        bboxWest,
        bboxEast,
        bboxSouth,
        bboxNorth,
        idNomenclatureCollectingMethod,
        idNomenclatureDataOrigin,
        idNomenclatureSourceStatus,
        idNomenclatureResourceType,
        active,
        validable,
        idDigitizer,
        idTaxaList,
        metaCreateDate,
        metaUpdateDate
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 't_datasets';
  @override
  VerificationContext validateIntegrity(Insertable<TDataset> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_dataset')) {
      context.handle(_idDatasetMeta,
          idDataset.isAcceptableOrUnknown(data['id_dataset']!, _idDatasetMeta));
    }
    if (data.containsKey('unique_dataset_id')) {
      context.handle(
          _uniqueDatasetIdMeta,
          uniqueDatasetId.isAcceptableOrUnknown(
              data['unique_dataset_id']!, _uniqueDatasetIdMeta));
    } else if (isInserting) {
      context.missing(_uniqueDatasetIdMeta);
    }
    if (data.containsKey('id_acquisition_framework')) {
      context.handle(
          _idAcquisitionFrameworkMeta,
          idAcquisitionFramework.isAcceptableOrUnknown(
              data['id_acquisition_framework']!, _idAcquisitionFrameworkMeta));
    } else if (isInserting) {
      context.missing(_idAcquisitionFrameworkMeta);
    }
    if (data.containsKey('dataset_name')) {
      context.handle(
          _datasetNameMeta,
          datasetName.isAcceptableOrUnknown(
              data['dataset_name']!, _datasetNameMeta));
    } else if (isInserting) {
      context.missing(_datasetNameMeta);
    }
    if (data.containsKey('dataset_shortname')) {
      context.handle(
          _datasetShortnameMeta,
          datasetShortname.isAcceptableOrUnknown(
              data['dataset_shortname']!, _datasetShortnameMeta));
    } else if (isInserting) {
      context.missing(_datasetShortnameMeta);
    }
    if (data.containsKey('dataset_desc')) {
      context.handle(
          _datasetDescMeta,
          datasetDesc.isAcceptableOrUnknown(
              data['dataset_desc']!, _datasetDescMeta));
    } else if (isInserting) {
      context.missing(_datasetDescMeta);
    }
    if (data.containsKey('id_nomenclature_data_type')) {
      context.handle(
          _idNomenclatureDataTypeMeta,
          idNomenclatureDataType.isAcceptableOrUnknown(
              data['id_nomenclature_data_type']!, _idNomenclatureDataTypeMeta));
    } else if (isInserting) {
      context.missing(_idNomenclatureDataTypeMeta);
    }
    if (data.containsKey('keywords')) {
      context.handle(_keywordsMeta,
          keywords.isAcceptableOrUnknown(data['keywords']!, _keywordsMeta));
    }
    if (data.containsKey('marine_domain')) {
      context.handle(
          _marineDomainMeta,
          marineDomain.isAcceptableOrUnknown(
              data['marine_domain']!, _marineDomainMeta));
    } else if (isInserting) {
      context.missing(_marineDomainMeta);
    }
    if (data.containsKey('terrestrial_domain')) {
      context.handle(
          _terrestrialDomainMeta,
          terrestrialDomain.isAcceptableOrUnknown(
              data['terrestrial_domain']!, _terrestrialDomainMeta));
    } else if (isInserting) {
      context.missing(_terrestrialDomainMeta);
    }
    if (data.containsKey('id_nomenclature_dataset_objectif')) {
      context.handle(
          _idNomenclatureDatasetObjectifMeta,
          idNomenclatureDatasetObjectif.isAcceptableOrUnknown(
              data['id_nomenclature_dataset_objectif']!,
              _idNomenclatureDatasetObjectifMeta));
    } else if (isInserting) {
      context.missing(_idNomenclatureDatasetObjectifMeta);
    }
    if (data.containsKey('bbox_west')) {
      context.handle(_bboxWestMeta,
          bboxWest.isAcceptableOrUnknown(data['bbox_west']!, _bboxWestMeta));
    }
    if (data.containsKey('bbox_east')) {
      context.handle(_bboxEastMeta,
          bboxEast.isAcceptableOrUnknown(data['bbox_east']!, _bboxEastMeta));
    }
    if (data.containsKey('bbox_south')) {
      context.handle(_bboxSouthMeta,
          bboxSouth.isAcceptableOrUnknown(data['bbox_south']!, _bboxSouthMeta));
    }
    if (data.containsKey('bbox_north')) {
      context.handle(_bboxNorthMeta,
          bboxNorth.isAcceptableOrUnknown(data['bbox_north']!, _bboxNorthMeta));
    }
    if (data.containsKey('id_nomenclature_collecting_method')) {
      context.handle(
          _idNomenclatureCollectingMethodMeta,
          idNomenclatureCollectingMethod.isAcceptableOrUnknown(
              data['id_nomenclature_collecting_method']!,
              _idNomenclatureCollectingMethodMeta));
    } else if (isInserting) {
      context.missing(_idNomenclatureCollectingMethodMeta);
    }
    if (data.containsKey('id_nomenclature_data_origin')) {
      context.handle(
          _idNomenclatureDataOriginMeta,
          idNomenclatureDataOrigin.isAcceptableOrUnknown(
              data['id_nomenclature_data_origin']!,
              _idNomenclatureDataOriginMeta));
    } else if (isInserting) {
      context.missing(_idNomenclatureDataOriginMeta);
    }
    if (data.containsKey('id_nomenclature_source_status')) {
      context.handle(
          _idNomenclatureSourceStatusMeta,
          idNomenclatureSourceStatus.isAcceptableOrUnknown(
              data['id_nomenclature_source_status']!,
              _idNomenclatureSourceStatusMeta));
    } else if (isInserting) {
      context.missing(_idNomenclatureSourceStatusMeta);
    }
    if (data.containsKey('id_nomenclature_resource_type')) {
      context.handle(
          _idNomenclatureResourceTypeMeta,
          idNomenclatureResourceType.isAcceptableOrUnknown(
              data['id_nomenclature_resource_type']!,
              _idNomenclatureResourceTypeMeta));
    } else if (isInserting) {
      context.missing(_idNomenclatureResourceTypeMeta);
    }
    if (data.containsKey('active')) {
      context.handle(_activeMeta,
          active.isAcceptableOrUnknown(data['active']!, _activeMeta));
    }
    if (data.containsKey('validable')) {
      context.handle(_validableMeta,
          validable.isAcceptableOrUnknown(data['validable']!, _validableMeta));
    }
    if (data.containsKey('id_digitizer')) {
      context.handle(
          _idDigitizerMeta,
          idDigitizer.isAcceptableOrUnknown(
              data['id_digitizer']!, _idDigitizerMeta));
    }
    if (data.containsKey('id_taxa_list')) {
      context.handle(
          _idTaxaListMeta,
          idTaxaList.isAcceptableOrUnknown(
              data['id_taxa_list']!, _idTaxaListMeta));
    }
    if (data.containsKey('meta_create_date')) {
      context.handle(
          _metaCreateDateMeta,
          metaCreateDate.isAcceptableOrUnknown(
              data['meta_create_date']!, _metaCreateDateMeta));
    }
    if (data.containsKey('meta_update_date')) {
      context.handle(
          _metaUpdateDateMeta,
          metaUpdateDate.isAcceptableOrUnknown(
              data['meta_update_date']!, _metaUpdateDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idDataset};
  @override
  TDataset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TDataset(
      idDataset: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_dataset'])!,
      uniqueDatasetId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}unique_dataset_id'])!,
      idAcquisitionFramework: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}id_acquisition_framework'])!,
      datasetName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dataset_name'])!,
      datasetShortname: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}dataset_shortname'])!,
      datasetDesc: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dataset_desc'])!,
      idNomenclatureDataType: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}id_nomenclature_data_type'])!,
      keywords: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}keywords']),
      marineDomain: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}marine_domain'])!,
      terrestrialDomain: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}terrestrial_domain'])!,
      idNomenclatureDatasetObjectif: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}id_nomenclature_dataset_objectif'])!,
      bboxWest: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bbox_west']),
      bboxEast: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bbox_east']),
      bboxSouth: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bbox_south']),
      bboxNorth: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bbox_north']),
      idNomenclatureCollectingMethod: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}id_nomenclature_collecting_method'])!,
      idNomenclatureDataOrigin: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}id_nomenclature_data_origin'])!,
      idNomenclatureSourceStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}id_nomenclature_source_status'])!,
      idNomenclatureResourceType: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}id_nomenclature_resource_type'])!,
      active: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}active'])!,
      validable: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}validable']),
      idDigitizer: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_digitizer']),
      idTaxaList: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_taxa_list']),
      metaCreateDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}meta_create_date']),
      metaUpdateDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}meta_update_date']),
    );
  }

  @override
  $TDatasetsTable createAlias(String alias) {
    return $TDatasetsTable(attachedDatabase, alias);
  }
}

class TDataset extends DataClass implements Insertable<TDataset> {
  final int idDataset;
  final String uniqueDatasetId;
  final int idAcquisitionFramework;
  final String datasetName;
  final String datasetShortname;
  final String datasetDesc;
  final int idNomenclatureDataType;
  final String? keywords;
  final bool marineDomain;
  final bool terrestrialDomain;
  final int idNomenclatureDatasetObjectif;
  final double? bboxWest;
  final double? bboxEast;
  final double? bboxSouth;
  final double? bboxNorth;
  final int idNomenclatureCollectingMethod;
  final int idNomenclatureDataOrigin;
  final int idNomenclatureSourceStatus;
  final int idNomenclatureResourceType;
  final bool active;
  final bool? validable;
  final int? idDigitizer;
  final int? idTaxaList;
  final DateTime? metaCreateDate;
  final DateTime? metaUpdateDate;
  const TDataset(
      {required this.idDataset,
      required this.uniqueDatasetId,
      required this.idAcquisitionFramework,
      required this.datasetName,
      required this.datasetShortname,
      required this.datasetDesc,
      required this.idNomenclatureDataType,
      this.keywords,
      required this.marineDomain,
      required this.terrestrialDomain,
      required this.idNomenclatureDatasetObjectif,
      this.bboxWest,
      this.bboxEast,
      this.bboxSouth,
      this.bboxNorth,
      required this.idNomenclatureCollectingMethod,
      required this.idNomenclatureDataOrigin,
      required this.idNomenclatureSourceStatus,
      required this.idNomenclatureResourceType,
      required this.active,
      this.validable,
      this.idDigitizer,
      this.idTaxaList,
      this.metaCreateDate,
      this.metaUpdateDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_dataset'] = Variable<int>(idDataset);
    map['unique_dataset_id'] = Variable<String>(uniqueDatasetId);
    map['id_acquisition_framework'] = Variable<int>(idAcquisitionFramework);
    map['dataset_name'] = Variable<String>(datasetName);
    map['dataset_shortname'] = Variable<String>(datasetShortname);
    map['dataset_desc'] = Variable<String>(datasetDesc);
    map['id_nomenclature_data_type'] = Variable<int>(idNomenclatureDataType);
    if (!nullToAbsent || keywords != null) {
      map['keywords'] = Variable<String>(keywords);
    }
    map['marine_domain'] = Variable<bool>(marineDomain);
    map['terrestrial_domain'] = Variable<bool>(terrestrialDomain);
    map['id_nomenclature_dataset_objectif'] =
        Variable<int>(idNomenclatureDatasetObjectif);
    if (!nullToAbsent || bboxWest != null) {
      map['bbox_west'] = Variable<double>(bboxWest);
    }
    if (!nullToAbsent || bboxEast != null) {
      map['bbox_east'] = Variable<double>(bboxEast);
    }
    if (!nullToAbsent || bboxSouth != null) {
      map['bbox_south'] = Variable<double>(bboxSouth);
    }
    if (!nullToAbsent || bboxNorth != null) {
      map['bbox_north'] = Variable<double>(bboxNorth);
    }
    map['id_nomenclature_collecting_method'] =
        Variable<int>(idNomenclatureCollectingMethod);
    map['id_nomenclature_data_origin'] =
        Variable<int>(idNomenclatureDataOrigin);
    map['id_nomenclature_source_status'] =
        Variable<int>(idNomenclatureSourceStatus);
    map['id_nomenclature_resource_type'] =
        Variable<int>(idNomenclatureResourceType);
    map['active'] = Variable<bool>(active);
    if (!nullToAbsent || validable != null) {
      map['validable'] = Variable<bool>(validable);
    }
    if (!nullToAbsent || idDigitizer != null) {
      map['id_digitizer'] = Variable<int>(idDigitizer);
    }
    if (!nullToAbsent || idTaxaList != null) {
      map['id_taxa_list'] = Variable<int>(idTaxaList);
    }
    if (!nullToAbsent || metaCreateDate != null) {
      map['meta_create_date'] = Variable<DateTime>(metaCreateDate);
    }
    if (!nullToAbsent || metaUpdateDate != null) {
      map['meta_update_date'] = Variable<DateTime>(metaUpdateDate);
    }
    return map;
  }

  TDatasetsCompanion toCompanion(bool nullToAbsent) {
    return TDatasetsCompanion(
      idDataset: Value(idDataset),
      uniqueDatasetId: Value(uniqueDatasetId),
      idAcquisitionFramework: Value(idAcquisitionFramework),
      datasetName: Value(datasetName),
      datasetShortname: Value(datasetShortname),
      datasetDesc: Value(datasetDesc),
      idNomenclatureDataType: Value(idNomenclatureDataType),
      keywords: keywords == null && nullToAbsent
          ? const Value.absent()
          : Value(keywords),
      marineDomain: Value(marineDomain),
      terrestrialDomain: Value(terrestrialDomain),
      idNomenclatureDatasetObjectif: Value(idNomenclatureDatasetObjectif),
      bboxWest: bboxWest == null && nullToAbsent
          ? const Value.absent()
          : Value(bboxWest),
      bboxEast: bboxEast == null && nullToAbsent
          ? const Value.absent()
          : Value(bboxEast),
      bboxSouth: bboxSouth == null && nullToAbsent
          ? const Value.absent()
          : Value(bboxSouth),
      bboxNorth: bboxNorth == null && nullToAbsent
          ? const Value.absent()
          : Value(bboxNorth),
      idNomenclatureCollectingMethod: Value(idNomenclatureCollectingMethod),
      idNomenclatureDataOrigin: Value(idNomenclatureDataOrigin),
      idNomenclatureSourceStatus: Value(idNomenclatureSourceStatus),
      idNomenclatureResourceType: Value(idNomenclatureResourceType),
      active: Value(active),
      validable: validable == null && nullToAbsent
          ? const Value.absent()
          : Value(validable),
      idDigitizer: idDigitizer == null && nullToAbsent
          ? const Value.absent()
          : Value(idDigitizer),
      idTaxaList: idTaxaList == null && nullToAbsent
          ? const Value.absent()
          : Value(idTaxaList),
      metaCreateDate: metaCreateDate == null && nullToAbsent
          ? const Value.absent()
          : Value(metaCreateDate),
      metaUpdateDate: metaUpdateDate == null && nullToAbsent
          ? const Value.absent()
          : Value(metaUpdateDate),
    );
  }

  factory TDataset.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TDataset(
      idDataset: serializer.fromJson<int>(json['idDataset']),
      uniqueDatasetId: serializer.fromJson<String>(json['uniqueDatasetId']),
      idAcquisitionFramework:
          serializer.fromJson<int>(json['idAcquisitionFramework']),
      datasetName: serializer.fromJson<String>(json['datasetName']),
      datasetShortname: serializer.fromJson<String>(json['datasetShortname']),
      datasetDesc: serializer.fromJson<String>(json['datasetDesc']),
      idNomenclatureDataType:
          serializer.fromJson<int>(json['idNomenclatureDataType']),
      keywords: serializer.fromJson<String?>(json['keywords']),
      marineDomain: serializer.fromJson<bool>(json['marineDomain']),
      terrestrialDomain: serializer.fromJson<bool>(json['terrestrialDomain']),
      idNomenclatureDatasetObjectif:
          serializer.fromJson<int>(json['idNomenclatureDatasetObjectif']),
      bboxWest: serializer.fromJson<double?>(json['bboxWest']),
      bboxEast: serializer.fromJson<double?>(json['bboxEast']),
      bboxSouth: serializer.fromJson<double?>(json['bboxSouth']),
      bboxNorth: serializer.fromJson<double?>(json['bboxNorth']),
      idNomenclatureCollectingMethod:
          serializer.fromJson<int>(json['idNomenclatureCollectingMethod']),
      idNomenclatureDataOrigin:
          serializer.fromJson<int>(json['idNomenclatureDataOrigin']),
      idNomenclatureSourceStatus:
          serializer.fromJson<int>(json['idNomenclatureSourceStatus']),
      idNomenclatureResourceType:
          serializer.fromJson<int>(json['idNomenclatureResourceType']),
      active: serializer.fromJson<bool>(json['active']),
      validable: serializer.fromJson<bool?>(json['validable']),
      idDigitizer: serializer.fromJson<int?>(json['idDigitizer']),
      idTaxaList: serializer.fromJson<int?>(json['idTaxaList']),
      metaCreateDate: serializer.fromJson<DateTime?>(json['metaCreateDate']),
      metaUpdateDate: serializer.fromJson<DateTime?>(json['metaUpdateDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idDataset': serializer.toJson<int>(idDataset),
      'uniqueDatasetId': serializer.toJson<String>(uniqueDatasetId),
      'idAcquisitionFramework': serializer.toJson<int>(idAcquisitionFramework),
      'datasetName': serializer.toJson<String>(datasetName),
      'datasetShortname': serializer.toJson<String>(datasetShortname),
      'datasetDesc': serializer.toJson<String>(datasetDesc),
      'idNomenclatureDataType': serializer.toJson<int>(idNomenclatureDataType),
      'keywords': serializer.toJson<String?>(keywords),
      'marineDomain': serializer.toJson<bool>(marineDomain),
      'terrestrialDomain': serializer.toJson<bool>(terrestrialDomain),
      'idNomenclatureDatasetObjectif':
          serializer.toJson<int>(idNomenclatureDatasetObjectif),
      'bboxWest': serializer.toJson<double?>(bboxWest),
      'bboxEast': serializer.toJson<double?>(bboxEast),
      'bboxSouth': serializer.toJson<double?>(bboxSouth),
      'bboxNorth': serializer.toJson<double?>(bboxNorth),
      'idNomenclatureCollectingMethod':
          serializer.toJson<int>(idNomenclatureCollectingMethod),
      'idNomenclatureDataOrigin':
          serializer.toJson<int>(idNomenclatureDataOrigin),
      'idNomenclatureSourceStatus':
          serializer.toJson<int>(idNomenclatureSourceStatus),
      'idNomenclatureResourceType':
          serializer.toJson<int>(idNomenclatureResourceType),
      'active': serializer.toJson<bool>(active),
      'validable': serializer.toJson<bool?>(validable),
      'idDigitizer': serializer.toJson<int?>(idDigitizer),
      'idTaxaList': serializer.toJson<int?>(idTaxaList),
      'metaCreateDate': serializer.toJson<DateTime?>(metaCreateDate),
      'metaUpdateDate': serializer.toJson<DateTime?>(metaUpdateDate),
    };
  }

  TDataset copyWith(
          {int? idDataset,
          String? uniqueDatasetId,
          int? idAcquisitionFramework,
          String? datasetName,
          String? datasetShortname,
          String? datasetDesc,
          int? idNomenclatureDataType,
          Value<String?> keywords = const Value.absent(),
          bool? marineDomain,
          bool? terrestrialDomain,
          int? idNomenclatureDatasetObjectif,
          Value<double?> bboxWest = const Value.absent(),
          Value<double?> bboxEast = const Value.absent(),
          Value<double?> bboxSouth = const Value.absent(),
          Value<double?> bboxNorth = const Value.absent(),
          int? idNomenclatureCollectingMethod,
          int? idNomenclatureDataOrigin,
          int? idNomenclatureSourceStatus,
          int? idNomenclatureResourceType,
          bool? active,
          Value<bool?> validable = const Value.absent(),
          Value<int?> idDigitizer = const Value.absent(),
          Value<int?> idTaxaList = const Value.absent(),
          Value<DateTime?> metaCreateDate = const Value.absent(),
          Value<DateTime?> metaUpdateDate = const Value.absent()}) =>
      TDataset(
        idDataset: idDataset ?? this.idDataset,
        uniqueDatasetId: uniqueDatasetId ?? this.uniqueDatasetId,
        idAcquisitionFramework:
            idAcquisitionFramework ?? this.idAcquisitionFramework,
        datasetName: datasetName ?? this.datasetName,
        datasetShortname: datasetShortname ?? this.datasetShortname,
        datasetDesc: datasetDesc ?? this.datasetDesc,
        idNomenclatureDataType:
            idNomenclatureDataType ?? this.idNomenclatureDataType,
        keywords: keywords.present ? keywords.value : this.keywords,
        marineDomain: marineDomain ?? this.marineDomain,
        terrestrialDomain: terrestrialDomain ?? this.terrestrialDomain,
        idNomenclatureDatasetObjectif:
            idNomenclatureDatasetObjectif ?? this.idNomenclatureDatasetObjectif,
        bboxWest: bboxWest.present ? bboxWest.value : this.bboxWest,
        bboxEast: bboxEast.present ? bboxEast.value : this.bboxEast,
        bboxSouth: bboxSouth.present ? bboxSouth.value : this.bboxSouth,
        bboxNorth: bboxNorth.present ? bboxNorth.value : this.bboxNorth,
        idNomenclatureCollectingMethod: idNomenclatureCollectingMethod ??
            this.idNomenclatureCollectingMethod,
        idNomenclatureDataOrigin:
            idNomenclatureDataOrigin ?? this.idNomenclatureDataOrigin,
        idNomenclatureSourceStatus:
            idNomenclatureSourceStatus ?? this.idNomenclatureSourceStatus,
        idNomenclatureResourceType:
            idNomenclatureResourceType ?? this.idNomenclatureResourceType,
        active: active ?? this.active,
        validable: validable.present ? validable.value : this.validable,
        idDigitizer: idDigitizer.present ? idDigitizer.value : this.idDigitizer,
        idTaxaList: idTaxaList.present ? idTaxaList.value : this.idTaxaList,
        metaCreateDate:
            metaCreateDate.present ? metaCreateDate.value : this.metaCreateDate,
        metaUpdateDate:
            metaUpdateDate.present ? metaUpdateDate.value : this.metaUpdateDate,
      );
  TDataset copyWithCompanion(TDatasetsCompanion data) {
    return TDataset(
      idDataset: data.idDataset.present ? data.idDataset.value : this.idDataset,
      uniqueDatasetId: data.uniqueDatasetId.present
          ? data.uniqueDatasetId.value
          : this.uniqueDatasetId,
      idAcquisitionFramework: data.idAcquisitionFramework.present
          ? data.idAcquisitionFramework.value
          : this.idAcquisitionFramework,
      datasetName:
          data.datasetName.present ? data.datasetName.value : this.datasetName,
      datasetShortname: data.datasetShortname.present
          ? data.datasetShortname.value
          : this.datasetShortname,
      datasetDesc:
          data.datasetDesc.present ? data.datasetDesc.value : this.datasetDesc,
      idNomenclatureDataType: data.idNomenclatureDataType.present
          ? data.idNomenclatureDataType.value
          : this.idNomenclatureDataType,
      keywords: data.keywords.present ? data.keywords.value : this.keywords,
      marineDomain: data.marineDomain.present
          ? data.marineDomain.value
          : this.marineDomain,
      terrestrialDomain: data.terrestrialDomain.present
          ? data.terrestrialDomain.value
          : this.terrestrialDomain,
      idNomenclatureDatasetObjectif: data.idNomenclatureDatasetObjectif.present
          ? data.idNomenclatureDatasetObjectif.value
          : this.idNomenclatureDatasetObjectif,
      bboxWest: data.bboxWest.present ? data.bboxWest.value : this.bboxWest,
      bboxEast: data.bboxEast.present ? data.bboxEast.value : this.bboxEast,
      bboxSouth: data.bboxSouth.present ? data.bboxSouth.value : this.bboxSouth,
      bboxNorth: data.bboxNorth.present ? data.bboxNorth.value : this.bboxNorth,
      idNomenclatureCollectingMethod:
          data.idNomenclatureCollectingMethod.present
              ? data.idNomenclatureCollectingMethod.value
              : this.idNomenclatureCollectingMethod,
      idNomenclatureDataOrigin: data.idNomenclatureDataOrigin.present
          ? data.idNomenclatureDataOrigin.value
          : this.idNomenclatureDataOrigin,
      idNomenclatureSourceStatus: data.idNomenclatureSourceStatus.present
          ? data.idNomenclatureSourceStatus.value
          : this.idNomenclatureSourceStatus,
      idNomenclatureResourceType: data.idNomenclatureResourceType.present
          ? data.idNomenclatureResourceType.value
          : this.idNomenclatureResourceType,
      active: data.active.present ? data.active.value : this.active,
      validable: data.validable.present ? data.validable.value : this.validable,
      idDigitizer:
          data.idDigitizer.present ? data.idDigitizer.value : this.idDigitizer,
      idTaxaList:
          data.idTaxaList.present ? data.idTaxaList.value : this.idTaxaList,
      metaCreateDate: data.metaCreateDate.present
          ? data.metaCreateDate.value
          : this.metaCreateDate,
      metaUpdateDate: data.metaUpdateDate.present
          ? data.metaUpdateDate.value
          : this.metaUpdateDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TDataset(')
          ..write('idDataset: $idDataset, ')
          ..write('uniqueDatasetId: $uniqueDatasetId, ')
          ..write('idAcquisitionFramework: $idAcquisitionFramework, ')
          ..write('datasetName: $datasetName, ')
          ..write('datasetShortname: $datasetShortname, ')
          ..write('datasetDesc: $datasetDesc, ')
          ..write('idNomenclatureDataType: $idNomenclatureDataType, ')
          ..write('keywords: $keywords, ')
          ..write('marineDomain: $marineDomain, ')
          ..write('terrestrialDomain: $terrestrialDomain, ')
          ..write(
              'idNomenclatureDatasetObjectif: $idNomenclatureDatasetObjectif, ')
          ..write('bboxWest: $bboxWest, ')
          ..write('bboxEast: $bboxEast, ')
          ..write('bboxSouth: $bboxSouth, ')
          ..write('bboxNorth: $bboxNorth, ')
          ..write(
              'idNomenclatureCollectingMethod: $idNomenclatureCollectingMethod, ')
          ..write('idNomenclatureDataOrigin: $idNomenclatureDataOrigin, ')
          ..write('idNomenclatureSourceStatus: $idNomenclatureSourceStatus, ')
          ..write('idNomenclatureResourceType: $idNomenclatureResourceType, ')
          ..write('active: $active, ')
          ..write('validable: $validable, ')
          ..write('idDigitizer: $idDigitizer, ')
          ..write('idTaxaList: $idTaxaList, ')
          ..write('metaCreateDate: $metaCreateDate, ')
          ..write('metaUpdateDate: $metaUpdateDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        idDataset,
        uniqueDatasetId,
        idAcquisitionFramework,
        datasetName,
        datasetShortname,
        datasetDesc,
        idNomenclatureDataType,
        keywords,
        marineDomain,
        terrestrialDomain,
        idNomenclatureDatasetObjectif,
        bboxWest,
        bboxEast,
        bboxSouth,
        bboxNorth,
        idNomenclatureCollectingMethod,
        idNomenclatureDataOrigin,
        idNomenclatureSourceStatus,
        idNomenclatureResourceType,
        active,
        validable,
        idDigitizer,
        idTaxaList,
        metaCreateDate,
        metaUpdateDate
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TDataset &&
          other.idDataset == this.idDataset &&
          other.uniqueDatasetId == this.uniqueDatasetId &&
          other.idAcquisitionFramework == this.idAcquisitionFramework &&
          other.datasetName == this.datasetName &&
          other.datasetShortname == this.datasetShortname &&
          other.datasetDesc == this.datasetDesc &&
          other.idNomenclatureDataType == this.idNomenclatureDataType &&
          other.keywords == this.keywords &&
          other.marineDomain == this.marineDomain &&
          other.terrestrialDomain == this.terrestrialDomain &&
          other.idNomenclatureDatasetObjectif ==
              this.idNomenclatureDatasetObjectif &&
          other.bboxWest == this.bboxWest &&
          other.bboxEast == this.bboxEast &&
          other.bboxSouth == this.bboxSouth &&
          other.bboxNorth == this.bboxNorth &&
          other.idNomenclatureCollectingMethod ==
              this.idNomenclatureCollectingMethod &&
          other.idNomenclatureDataOrigin == this.idNomenclatureDataOrigin &&
          other.idNomenclatureSourceStatus == this.idNomenclatureSourceStatus &&
          other.idNomenclatureResourceType == this.idNomenclatureResourceType &&
          other.active == this.active &&
          other.validable == this.validable &&
          other.idDigitizer == this.idDigitizer &&
          other.idTaxaList == this.idTaxaList &&
          other.metaCreateDate == this.metaCreateDate &&
          other.metaUpdateDate == this.metaUpdateDate);
}

class TDatasetsCompanion extends UpdateCompanion<TDataset> {
  final Value<int> idDataset;
  final Value<String> uniqueDatasetId;
  final Value<int> idAcquisitionFramework;
  final Value<String> datasetName;
  final Value<String> datasetShortname;
  final Value<String> datasetDesc;
  final Value<int> idNomenclatureDataType;
  final Value<String?> keywords;
  final Value<bool> marineDomain;
  final Value<bool> terrestrialDomain;
  final Value<int> idNomenclatureDatasetObjectif;
  final Value<double?> bboxWest;
  final Value<double?> bboxEast;
  final Value<double?> bboxSouth;
  final Value<double?> bboxNorth;
  final Value<int> idNomenclatureCollectingMethod;
  final Value<int> idNomenclatureDataOrigin;
  final Value<int> idNomenclatureSourceStatus;
  final Value<int> idNomenclatureResourceType;
  final Value<bool> active;
  final Value<bool?> validable;
  final Value<int?> idDigitizer;
  final Value<int?> idTaxaList;
  final Value<DateTime?> metaCreateDate;
  final Value<DateTime?> metaUpdateDate;
  const TDatasetsCompanion({
    this.idDataset = const Value.absent(),
    this.uniqueDatasetId = const Value.absent(),
    this.idAcquisitionFramework = const Value.absent(),
    this.datasetName = const Value.absent(),
    this.datasetShortname = const Value.absent(),
    this.datasetDesc = const Value.absent(),
    this.idNomenclatureDataType = const Value.absent(),
    this.keywords = const Value.absent(),
    this.marineDomain = const Value.absent(),
    this.terrestrialDomain = const Value.absent(),
    this.idNomenclatureDatasetObjectif = const Value.absent(),
    this.bboxWest = const Value.absent(),
    this.bboxEast = const Value.absent(),
    this.bboxSouth = const Value.absent(),
    this.bboxNorth = const Value.absent(),
    this.idNomenclatureCollectingMethod = const Value.absent(),
    this.idNomenclatureDataOrigin = const Value.absent(),
    this.idNomenclatureSourceStatus = const Value.absent(),
    this.idNomenclatureResourceType = const Value.absent(),
    this.active = const Value.absent(),
    this.validable = const Value.absent(),
    this.idDigitizer = const Value.absent(),
    this.idTaxaList = const Value.absent(),
    this.metaCreateDate = const Value.absent(),
    this.metaUpdateDate = const Value.absent(),
  });
  TDatasetsCompanion.insert({
    this.idDataset = const Value.absent(),
    required String uniqueDatasetId,
    required int idAcquisitionFramework,
    required String datasetName,
    required String datasetShortname,
    required String datasetDesc,
    required int idNomenclatureDataType,
    this.keywords = const Value.absent(),
    required bool marineDomain,
    required bool terrestrialDomain,
    required int idNomenclatureDatasetObjectif,
    this.bboxWest = const Value.absent(),
    this.bboxEast = const Value.absent(),
    this.bboxSouth = const Value.absent(),
    this.bboxNorth = const Value.absent(),
    required int idNomenclatureCollectingMethod,
    required int idNomenclatureDataOrigin,
    required int idNomenclatureSourceStatus,
    required int idNomenclatureResourceType,
    this.active = const Value.absent(),
    this.validable = const Value.absent(),
    this.idDigitizer = const Value.absent(),
    this.idTaxaList = const Value.absent(),
    this.metaCreateDate = const Value.absent(),
    this.metaUpdateDate = const Value.absent(),
  })  : uniqueDatasetId = Value(uniqueDatasetId),
        idAcquisitionFramework = Value(idAcquisitionFramework),
        datasetName = Value(datasetName),
        datasetShortname = Value(datasetShortname),
        datasetDesc = Value(datasetDesc),
        idNomenclatureDataType = Value(idNomenclatureDataType),
        marineDomain = Value(marineDomain),
        terrestrialDomain = Value(terrestrialDomain),
        idNomenclatureDatasetObjectif = Value(idNomenclatureDatasetObjectif),
        idNomenclatureCollectingMethod = Value(idNomenclatureCollectingMethod),
        idNomenclatureDataOrigin = Value(idNomenclatureDataOrigin),
        idNomenclatureSourceStatus = Value(idNomenclatureSourceStatus),
        idNomenclatureResourceType = Value(idNomenclatureResourceType);
  static Insertable<TDataset> custom({
    Expression<int>? idDataset,
    Expression<String>? uniqueDatasetId,
    Expression<int>? idAcquisitionFramework,
    Expression<String>? datasetName,
    Expression<String>? datasetShortname,
    Expression<String>? datasetDesc,
    Expression<int>? idNomenclatureDataType,
    Expression<String>? keywords,
    Expression<bool>? marineDomain,
    Expression<bool>? terrestrialDomain,
    Expression<int>? idNomenclatureDatasetObjectif,
    Expression<double>? bboxWest,
    Expression<double>? bboxEast,
    Expression<double>? bboxSouth,
    Expression<double>? bboxNorth,
    Expression<int>? idNomenclatureCollectingMethod,
    Expression<int>? idNomenclatureDataOrigin,
    Expression<int>? idNomenclatureSourceStatus,
    Expression<int>? idNomenclatureResourceType,
    Expression<bool>? active,
    Expression<bool>? validable,
    Expression<int>? idDigitizer,
    Expression<int>? idTaxaList,
    Expression<DateTime>? metaCreateDate,
    Expression<DateTime>? metaUpdateDate,
  }) {
    return RawValuesInsertable({
      if (idDataset != null) 'id_dataset': idDataset,
      if (uniqueDatasetId != null) 'unique_dataset_id': uniqueDatasetId,
      if (idAcquisitionFramework != null)
        'id_acquisition_framework': idAcquisitionFramework,
      if (datasetName != null) 'dataset_name': datasetName,
      if (datasetShortname != null) 'dataset_shortname': datasetShortname,
      if (datasetDesc != null) 'dataset_desc': datasetDesc,
      if (idNomenclatureDataType != null)
        'id_nomenclature_data_type': idNomenclatureDataType,
      if (keywords != null) 'keywords': keywords,
      if (marineDomain != null) 'marine_domain': marineDomain,
      if (terrestrialDomain != null) 'terrestrial_domain': terrestrialDomain,
      if (idNomenclatureDatasetObjectif != null)
        'id_nomenclature_dataset_objectif': idNomenclatureDatasetObjectif,
      if (bboxWest != null) 'bbox_west': bboxWest,
      if (bboxEast != null) 'bbox_east': bboxEast,
      if (bboxSouth != null) 'bbox_south': bboxSouth,
      if (bboxNorth != null) 'bbox_north': bboxNorth,
      if (idNomenclatureCollectingMethod != null)
        'id_nomenclature_collecting_method': idNomenclatureCollectingMethod,
      if (idNomenclatureDataOrigin != null)
        'id_nomenclature_data_origin': idNomenclatureDataOrigin,
      if (idNomenclatureSourceStatus != null)
        'id_nomenclature_source_status': idNomenclatureSourceStatus,
      if (idNomenclatureResourceType != null)
        'id_nomenclature_resource_type': idNomenclatureResourceType,
      if (active != null) 'active': active,
      if (validable != null) 'validable': validable,
      if (idDigitizer != null) 'id_digitizer': idDigitizer,
      if (idTaxaList != null) 'id_taxa_list': idTaxaList,
      if (metaCreateDate != null) 'meta_create_date': metaCreateDate,
      if (metaUpdateDate != null) 'meta_update_date': metaUpdateDate,
    });
  }

  TDatasetsCompanion copyWith(
      {Value<int>? idDataset,
      Value<String>? uniqueDatasetId,
      Value<int>? idAcquisitionFramework,
      Value<String>? datasetName,
      Value<String>? datasetShortname,
      Value<String>? datasetDesc,
      Value<int>? idNomenclatureDataType,
      Value<String?>? keywords,
      Value<bool>? marineDomain,
      Value<bool>? terrestrialDomain,
      Value<int>? idNomenclatureDatasetObjectif,
      Value<double?>? bboxWest,
      Value<double?>? bboxEast,
      Value<double?>? bboxSouth,
      Value<double?>? bboxNorth,
      Value<int>? idNomenclatureCollectingMethod,
      Value<int>? idNomenclatureDataOrigin,
      Value<int>? idNomenclatureSourceStatus,
      Value<int>? idNomenclatureResourceType,
      Value<bool>? active,
      Value<bool?>? validable,
      Value<int?>? idDigitizer,
      Value<int?>? idTaxaList,
      Value<DateTime?>? metaCreateDate,
      Value<DateTime?>? metaUpdateDate}) {
    return TDatasetsCompanion(
      idDataset: idDataset ?? this.idDataset,
      uniqueDatasetId: uniqueDatasetId ?? this.uniqueDatasetId,
      idAcquisitionFramework:
          idAcquisitionFramework ?? this.idAcquisitionFramework,
      datasetName: datasetName ?? this.datasetName,
      datasetShortname: datasetShortname ?? this.datasetShortname,
      datasetDesc: datasetDesc ?? this.datasetDesc,
      idNomenclatureDataType:
          idNomenclatureDataType ?? this.idNomenclatureDataType,
      keywords: keywords ?? this.keywords,
      marineDomain: marineDomain ?? this.marineDomain,
      terrestrialDomain: terrestrialDomain ?? this.terrestrialDomain,
      idNomenclatureDatasetObjectif:
          idNomenclatureDatasetObjectif ?? this.idNomenclatureDatasetObjectif,
      bboxWest: bboxWest ?? this.bboxWest,
      bboxEast: bboxEast ?? this.bboxEast,
      bboxSouth: bboxSouth ?? this.bboxSouth,
      bboxNorth: bboxNorth ?? this.bboxNorth,
      idNomenclatureCollectingMethod:
          idNomenclatureCollectingMethod ?? this.idNomenclatureCollectingMethod,
      idNomenclatureDataOrigin:
          idNomenclatureDataOrigin ?? this.idNomenclatureDataOrigin,
      idNomenclatureSourceStatus:
          idNomenclatureSourceStatus ?? this.idNomenclatureSourceStatus,
      idNomenclatureResourceType:
          idNomenclatureResourceType ?? this.idNomenclatureResourceType,
      active: active ?? this.active,
      validable: validable ?? this.validable,
      idDigitizer: idDigitizer ?? this.idDigitizer,
      idTaxaList: idTaxaList ?? this.idTaxaList,
      metaCreateDate: metaCreateDate ?? this.metaCreateDate,
      metaUpdateDate: metaUpdateDate ?? this.metaUpdateDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idDataset.present) {
      map['id_dataset'] = Variable<int>(idDataset.value);
    }
    if (uniqueDatasetId.present) {
      map['unique_dataset_id'] = Variable<String>(uniqueDatasetId.value);
    }
    if (idAcquisitionFramework.present) {
      map['id_acquisition_framework'] =
          Variable<int>(idAcquisitionFramework.value);
    }
    if (datasetName.present) {
      map['dataset_name'] = Variable<String>(datasetName.value);
    }
    if (datasetShortname.present) {
      map['dataset_shortname'] = Variable<String>(datasetShortname.value);
    }
    if (datasetDesc.present) {
      map['dataset_desc'] = Variable<String>(datasetDesc.value);
    }
    if (idNomenclatureDataType.present) {
      map['id_nomenclature_data_type'] =
          Variable<int>(idNomenclatureDataType.value);
    }
    if (keywords.present) {
      map['keywords'] = Variable<String>(keywords.value);
    }
    if (marineDomain.present) {
      map['marine_domain'] = Variable<bool>(marineDomain.value);
    }
    if (terrestrialDomain.present) {
      map['terrestrial_domain'] = Variable<bool>(terrestrialDomain.value);
    }
    if (idNomenclatureDatasetObjectif.present) {
      map['id_nomenclature_dataset_objectif'] =
          Variable<int>(idNomenclatureDatasetObjectif.value);
    }
    if (bboxWest.present) {
      map['bbox_west'] = Variable<double>(bboxWest.value);
    }
    if (bboxEast.present) {
      map['bbox_east'] = Variable<double>(bboxEast.value);
    }
    if (bboxSouth.present) {
      map['bbox_south'] = Variable<double>(bboxSouth.value);
    }
    if (bboxNorth.present) {
      map['bbox_north'] = Variable<double>(bboxNorth.value);
    }
    if (idNomenclatureCollectingMethod.present) {
      map['id_nomenclature_collecting_method'] =
          Variable<int>(idNomenclatureCollectingMethod.value);
    }
    if (idNomenclatureDataOrigin.present) {
      map['id_nomenclature_data_origin'] =
          Variable<int>(idNomenclatureDataOrigin.value);
    }
    if (idNomenclatureSourceStatus.present) {
      map['id_nomenclature_source_status'] =
          Variable<int>(idNomenclatureSourceStatus.value);
    }
    if (idNomenclatureResourceType.present) {
      map['id_nomenclature_resource_type'] =
          Variable<int>(idNomenclatureResourceType.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (validable.present) {
      map['validable'] = Variable<bool>(validable.value);
    }
    if (idDigitizer.present) {
      map['id_digitizer'] = Variable<int>(idDigitizer.value);
    }
    if (idTaxaList.present) {
      map['id_taxa_list'] = Variable<int>(idTaxaList.value);
    }
    if (metaCreateDate.present) {
      map['meta_create_date'] = Variable<DateTime>(metaCreateDate.value);
    }
    if (metaUpdateDate.present) {
      map['meta_update_date'] = Variable<DateTime>(metaUpdateDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TDatasetsCompanion(')
          ..write('idDataset: $idDataset, ')
          ..write('uniqueDatasetId: $uniqueDatasetId, ')
          ..write('idAcquisitionFramework: $idAcquisitionFramework, ')
          ..write('datasetName: $datasetName, ')
          ..write('datasetShortname: $datasetShortname, ')
          ..write('datasetDesc: $datasetDesc, ')
          ..write('idNomenclatureDataType: $idNomenclatureDataType, ')
          ..write('keywords: $keywords, ')
          ..write('marineDomain: $marineDomain, ')
          ..write('terrestrialDomain: $terrestrialDomain, ')
          ..write(
              'idNomenclatureDatasetObjectif: $idNomenclatureDatasetObjectif, ')
          ..write('bboxWest: $bboxWest, ')
          ..write('bboxEast: $bboxEast, ')
          ..write('bboxSouth: $bboxSouth, ')
          ..write('bboxNorth: $bboxNorth, ')
          ..write(
              'idNomenclatureCollectingMethod: $idNomenclatureCollectingMethod, ')
          ..write('idNomenclatureDataOrigin: $idNomenclatureDataOrigin, ')
          ..write('idNomenclatureSourceStatus: $idNomenclatureSourceStatus, ')
          ..write('idNomenclatureResourceType: $idNomenclatureResourceType, ')
          ..write('active: $active, ')
          ..write('validable: $validable, ')
          ..write('idDigitizer: $idDigitizer, ')
          ..write('idTaxaList: $idTaxaList, ')
          ..write('metaCreateDate: $metaCreateDate, ')
          ..write('metaUpdateDate: $metaUpdateDate')
          ..write(')'))
        .toString();
  }
}

class $TModuleComplementsTable extends TModuleComplements
    with TableInfo<$TModuleComplementsTable, TModuleComplement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TModuleComplementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idModuleMeta =
      const VerificationMeta('idModule');
  @override
  late final GeneratedColumn<int> idModule = GeneratedColumn<int>(
      'id_module', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uuidModuleComplementMeta =
      const VerificationMeta('uuidModuleComplement');
  @override
  late final GeneratedColumn<String> uuidModuleComplement =
      GeneratedColumn<String>('uuid_module_complement', aliasedName, true,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
          defaultValue: const Constant('randomblob(16)'));
  static const VerificationMeta _idListObserverMeta =
      const VerificationMeta('idListObserver');
  @override
  late final GeneratedColumn<int> idListObserver = GeneratedColumn<int>(
      'id_list_observer', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _idListTaxonomyMeta =
      const VerificationMeta('idListTaxonomy');
  @override
  late final GeneratedColumn<int> idListTaxonomy = GeneratedColumn<int>(
      'id_list_taxonomy', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _bSyntheseMeta =
      const VerificationMeta('bSynthese');
  @override
  late final GeneratedColumn<bool> bSynthese = GeneratedColumn<bool>(
      'b_synthese', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("b_synthese" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _taxonomyDisplayFieldNameMeta =
      const VerificationMeta('taxonomyDisplayFieldName');
  @override
  late final GeneratedColumn<String> taxonomyDisplayFieldName =
      GeneratedColumn<String>('taxonomy_display_field_name', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('nom_vern,lb_nom'));
  static const VerificationMeta _bDrawSitesGroupMeta =
      const VerificationMeta('bDrawSitesGroup');
  @override
  late final GeneratedColumn<bool> bDrawSitesGroup = GeneratedColumn<bool>(
      'b_draw_sites_group', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("b_draw_sites_group" IN (0, 1))'));
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _configurationMeta =
      const VerificationMeta('configuration');
  @override
  late final GeneratedColumn<String> configuration = GeneratedColumn<String>(
      'configuration', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        idModule,
        uuidModuleComplement,
        idListObserver,
        idListTaxonomy,
        bSynthese,
        taxonomyDisplayFieldName,
        bDrawSitesGroup,
        data,
        configuration
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 't_module_complements';
  @override
  VerificationContext validateIntegrity(Insertable<TModuleComplement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_module')) {
      context.handle(_idModuleMeta,
          idModule.isAcceptableOrUnknown(data['id_module']!, _idModuleMeta));
    }
    if (data.containsKey('uuid_module_complement')) {
      context.handle(
          _uuidModuleComplementMeta,
          uuidModuleComplement.isAcceptableOrUnknown(
              data['uuid_module_complement']!, _uuidModuleComplementMeta));
    }
    if (data.containsKey('id_list_observer')) {
      context.handle(
          _idListObserverMeta,
          idListObserver.isAcceptableOrUnknown(
              data['id_list_observer']!, _idListObserverMeta));
    }
    if (data.containsKey('id_list_taxonomy')) {
      context.handle(
          _idListTaxonomyMeta,
          idListTaxonomy.isAcceptableOrUnknown(
              data['id_list_taxonomy']!, _idListTaxonomyMeta));
    }
    if (data.containsKey('b_synthese')) {
      context.handle(_bSyntheseMeta,
          bSynthese.isAcceptableOrUnknown(data['b_synthese']!, _bSyntheseMeta));
    }
    if (data.containsKey('taxonomy_display_field_name')) {
      context.handle(
          _taxonomyDisplayFieldNameMeta,
          taxonomyDisplayFieldName.isAcceptableOrUnknown(
              data['taxonomy_display_field_name']!,
              _taxonomyDisplayFieldNameMeta));
    }
    if (data.containsKey('b_draw_sites_group')) {
      context.handle(
          _bDrawSitesGroupMeta,
          bDrawSitesGroup.isAcceptableOrUnknown(
              data['b_draw_sites_group']!, _bDrawSitesGroupMeta));
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    }
    if (data.containsKey('configuration')) {
      context.handle(
          _configurationMeta,
          configuration.isAcceptableOrUnknown(
              data['configuration']!, _configurationMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idModule};
  @override
  TModuleComplement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TModuleComplement(
      idModule: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_module'])!,
      uuidModuleComplement: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}uuid_module_complement']),
      idListObserver: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_list_observer']),
      idListTaxonomy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_list_taxonomy']),
      bSynthese: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}b_synthese'])!,
      taxonomyDisplayFieldName: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}taxonomy_display_field_name'])!,
      bDrawSitesGroup: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}b_draw_sites_group']),
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data']),
      configuration: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}configuration']),
    );
  }

  @override
  $TModuleComplementsTable createAlias(String alias) {
    return $TModuleComplementsTable(attachedDatabase, alias);
  }
}

class TModuleComplement extends DataClass
    implements Insertable<TModuleComplement> {
  final int idModule;
  final String? uuidModuleComplement;
  final int? idListObserver;
  final int? idListTaxonomy;
  final bool bSynthese;
  final String taxonomyDisplayFieldName;
  final bool? bDrawSitesGroup;
  final String? data;
  final String? configuration;
  const TModuleComplement(
      {required this.idModule,
      this.uuidModuleComplement,
      this.idListObserver,
      this.idListTaxonomy,
      required this.bSynthese,
      required this.taxonomyDisplayFieldName,
      this.bDrawSitesGroup,
      this.data,
      this.configuration});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_module'] = Variable<int>(idModule);
    if (!nullToAbsent || uuidModuleComplement != null) {
      map['uuid_module_complement'] = Variable<String>(uuidModuleComplement);
    }
    if (!nullToAbsent || idListObserver != null) {
      map['id_list_observer'] = Variable<int>(idListObserver);
    }
    if (!nullToAbsent || idListTaxonomy != null) {
      map['id_list_taxonomy'] = Variable<int>(idListTaxonomy);
    }
    map['b_synthese'] = Variable<bool>(bSynthese);
    map['taxonomy_display_field_name'] =
        Variable<String>(taxonomyDisplayFieldName);
    if (!nullToAbsent || bDrawSitesGroup != null) {
      map['b_draw_sites_group'] = Variable<bool>(bDrawSitesGroup);
    }
    if (!nullToAbsent || data != null) {
      map['data'] = Variable<String>(data);
    }
    if (!nullToAbsent || configuration != null) {
      map['configuration'] = Variable<String>(configuration);
    }
    return map;
  }

  TModuleComplementsCompanion toCompanion(bool nullToAbsent) {
    return TModuleComplementsCompanion(
      idModule: Value(idModule),
      uuidModuleComplement: uuidModuleComplement == null && nullToAbsent
          ? const Value.absent()
          : Value(uuidModuleComplement),
      idListObserver: idListObserver == null && nullToAbsent
          ? const Value.absent()
          : Value(idListObserver),
      idListTaxonomy: idListTaxonomy == null && nullToAbsent
          ? const Value.absent()
          : Value(idListTaxonomy),
      bSynthese: Value(bSynthese),
      taxonomyDisplayFieldName: Value(taxonomyDisplayFieldName),
      bDrawSitesGroup: bDrawSitesGroup == null && nullToAbsent
          ? const Value.absent()
          : Value(bDrawSitesGroup),
      data: data == null && nullToAbsent ? const Value.absent() : Value(data),
      configuration: configuration == null && nullToAbsent
          ? const Value.absent()
          : Value(configuration),
    );
  }

  factory TModuleComplement.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TModuleComplement(
      idModule: serializer.fromJson<int>(json['idModule']),
      uuidModuleComplement:
          serializer.fromJson<String?>(json['uuidModuleComplement']),
      idListObserver: serializer.fromJson<int?>(json['idListObserver']),
      idListTaxonomy: serializer.fromJson<int?>(json['idListTaxonomy']),
      bSynthese: serializer.fromJson<bool>(json['bSynthese']),
      taxonomyDisplayFieldName:
          serializer.fromJson<String>(json['taxonomyDisplayFieldName']),
      bDrawSitesGroup: serializer.fromJson<bool?>(json['bDrawSitesGroup']),
      data: serializer.fromJson<String?>(json['data']),
      configuration: serializer.fromJson<String?>(json['configuration']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idModule': serializer.toJson<int>(idModule),
      'uuidModuleComplement': serializer.toJson<String?>(uuidModuleComplement),
      'idListObserver': serializer.toJson<int?>(idListObserver),
      'idListTaxonomy': serializer.toJson<int?>(idListTaxonomy),
      'bSynthese': serializer.toJson<bool>(bSynthese),
      'taxonomyDisplayFieldName':
          serializer.toJson<String>(taxonomyDisplayFieldName),
      'bDrawSitesGroup': serializer.toJson<bool?>(bDrawSitesGroup),
      'data': serializer.toJson<String?>(data),
      'configuration': serializer.toJson<String?>(configuration),
    };
  }

  TModuleComplement copyWith(
          {int? idModule,
          Value<String?> uuidModuleComplement = const Value.absent(),
          Value<int?> idListObserver = const Value.absent(),
          Value<int?> idListTaxonomy = const Value.absent(),
          bool? bSynthese,
          String? taxonomyDisplayFieldName,
          Value<bool?> bDrawSitesGroup = const Value.absent(),
          Value<String?> data = const Value.absent(),
          Value<String?> configuration = const Value.absent()}) =>
      TModuleComplement(
        idModule: idModule ?? this.idModule,
        uuidModuleComplement: uuidModuleComplement.present
            ? uuidModuleComplement.value
            : this.uuidModuleComplement,
        idListObserver:
            idListObserver.present ? idListObserver.value : this.idListObserver,
        idListTaxonomy:
            idListTaxonomy.present ? idListTaxonomy.value : this.idListTaxonomy,
        bSynthese: bSynthese ?? this.bSynthese,
        taxonomyDisplayFieldName:
            taxonomyDisplayFieldName ?? this.taxonomyDisplayFieldName,
        bDrawSitesGroup: bDrawSitesGroup.present
            ? bDrawSitesGroup.value
            : this.bDrawSitesGroup,
        data: data.present ? data.value : this.data,
        configuration:
            configuration.present ? configuration.value : this.configuration,
      );
  TModuleComplement copyWithCompanion(TModuleComplementsCompanion data) {
    return TModuleComplement(
      idModule: data.idModule.present ? data.idModule.value : this.idModule,
      uuidModuleComplement: data.uuidModuleComplement.present
          ? data.uuidModuleComplement.value
          : this.uuidModuleComplement,
      idListObserver: data.idListObserver.present
          ? data.idListObserver.value
          : this.idListObserver,
      idListTaxonomy: data.idListTaxonomy.present
          ? data.idListTaxonomy.value
          : this.idListTaxonomy,
      bSynthese: data.bSynthese.present ? data.bSynthese.value : this.bSynthese,
      taxonomyDisplayFieldName: data.taxonomyDisplayFieldName.present
          ? data.taxonomyDisplayFieldName.value
          : this.taxonomyDisplayFieldName,
      bDrawSitesGroup: data.bDrawSitesGroup.present
          ? data.bDrawSitesGroup.value
          : this.bDrawSitesGroup,
      data: data.data.present ? data.data.value : this.data,
      configuration: data.configuration.present
          ? data.configuration.value
          : this.configuration,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TModuleComplement(')
          ..write('idModule: $idModule, ')
          ..write('uuidModuleComplement: $uuidModuleComplement, ')
          ..write('idListObserver: $idListObserver, ')
          ..write('idListTaxonomy: $idListTaxonomy, ')
          ..write('bSynthese: $bSynthese, ')
          ..write('taxonomyDisplayFieldName: $taxonomyDisplayFieldName, ')
          ..write('bDrawSitesGroup: $bDrawSitesGroup, ')
          ..write('data: $data, ')
          ..write('configuration: $configuration')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      idModule,
      uuidModuleComplement,
      idListObserver,
      idListTaxonomy,
      bSynthese,
      taxonomyDisplayFieldName,
      bDrawSitesGroup,
      data,
      configuration);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TModuleComplement &&
          other.idModule == this.idModule &&
          other.uuidModuleComplement == this.uuidModuleComplement &&
          other.idListObserver == this.idListObserver &&
          other.idListTaxonomy == this.idListTaxonomy &&
          other.bSynthese == this.bSynthese &&
          other.taxonomyDisplayFieldName == this.taxonomyDisplayFieldName &&
          other.bDrawSitesGroup == this.bDrawSitesGroup &&
          other.data == this.data &&
          other.configuration == this.configuration);
}

class TModuleComplementsCompanion extends UpdateCompanion<TModuleComplement> {
  final Value<int> idModule;
  final Value<String?> uuidModuleComplement;
  final Value<int?> idListObserver;
  final Value<int?> idListTaxonomy;
  final Value<bool> bSynthese;
  final Value<String> taxonomyDisplayFieldName;
  final Value<bool?> bDrawSitesGroup;
  final Value<String?> data;
  final Value<String?> configuration;
  const TModuleComplementsCompanion({
    this.idModule = const Value.absent(),
    this.uuidModuleComplement = const Value.absent(),
    this.idListObserver = const Value.absent(),
    this.idListTaxonomy = const Value.absent(),
    this.bSynthese = const Value.absent(),
    this.taxonomyDisplayFieldName = const Value.absent(),
    this.bDrawSitesGroup = const Value.absent(),
    this.data = const Value.absent(),
    this.configuration = const Value.absent(),
  });
  TModuleComplementsCompanion.insert({
    this.idModule = const Value.absent(),
    this.uuidModuleComplement = const Value.absent(),
    this.idListObserver = const Value.absent(),
    this.idListTaxonomy = const Value.absent(),
    this.bSynthese = const Value.absent(),
    this.taxonomyDisplayFieldName = const Value.absent(),
    this.bDrawSitesGroup = const Value.absent(),
    this.data = const Value.absent(),
    this.configuration = const Value.absent(),
  });
  static Insertable<TModuleComplement> custom({
    Expression<int>? idModule,
    Expression<String>? uuidModuleComplement,
    Expression<int>? idListObserver,
    Expression<int>? idListTaxonomy,
    Expression<bool>? bSynthese,
    Expression<String>? taxonomyDisplayFieldName,
    Expression<bool>? bDrawSitesGroup,
    Expression<String>? data,
    Expression<String>? configuration,
  }) {
    return RawValuesInsertable({
      if (idModule != null) 'id_module': idModule,
      if (uuidModuleComplement != null)
        'uuid_module_complement': uuidModuleComplement,
      if (idListObserver != null) 'id_list_observer': idListObserver,
      if (idListTaxonomy != null) 'id_list_taxonomy': idListTaxonomy,
      if (bSynthese != null) 'b_synthese': bSynthese,
      if (taxonomyDisplayFieldName != null)
        'taxonomy_display_field_name': taxonomyDisplayFieldName,
      if (bDrawSitesGroup != null) 'b_draw_sites_group': bDrawSitesGroup,
      if (data != null) 'data': data,
      if (configuration != null) 'configuration': configuration,
    });
  }

  TModuleComplementsCompanion copyWith(
      {Value<int>? idModule,
      Value<String?>? uuidModuleComplement,
      Value<int?>? idListObserver,
      Value<int?>? idListTaxonomy,
      Value<bool>? bSynthese,
      Value<String>? taxonomyDisplayFieldName,
      Value<bool?>? bDrawSitesGroup,
      Value<String?>? data,
      Value<String?>? configuration}) {
    return TModuleComplementsCompanion(
      idModule: idModule ?? this.idModule,
      uuidModuleComplement: uuidModuleComplement ?? this.uuidModuleComplement,
      idListObserver: idListObserver ?? this.idListObserver,
      idListTaxonomy: idListTaxonomy ?? this.idListTaxonomy,
      bSynthese: bSynthese ?? this.bSynthese,
      taxonomyDisplayFieldName:
          taxonomyDisplayFieldName ?? this.taxonomyDisplayFieldName,
      bDrawSitesGroup: bDrawSitesGroup ?? this.bDrawSitesGroup,
      data: data ?? this.data,
      configuration: configuration ?? this.configuration,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idModule.present) {
      map['id_module'] = Variable<int>(idModule.value);
    }
    if (uuidModuleComplement.present) {
      map['uuid_module_complement'] =
          Variable<String>(uuidModuleComplement.value);
    }
    if (idListObserver.present) {
      map['id_list_observer'] = Variable<int>(idListObserver.value);
    }
    if (idListTaxonomy.present) {
      map['id_list_taxonomy'] = Variable<int>(idListTaxonomy.value);
    }
    if (bSynthese.present) {
      map['b_synthese'] = Variable<bool>(bSynthese.value);
    }
    if (taxonomyDisplayFieldName.present) {
      map['taxonomy_display_field_name'] =
          Variable<String>(taxonomyDisplayFieldName.value);
    }
    if (bDrawSitesGroup.present) {
      map['b_draw_sites_group'] = Variable<bool>(bDrawSitesGroup.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (configuration.present) {
      map['configuration'] = Variable<String>(configuration.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TModuleComplementsCompanion(')
          ..write('idModule: $idModule, ')
          ..write('uuidModuleComplement: $uuidModuleComplement, ')
          ..write('idListObserver: $idListObserver, ')
          ..write('idListTaxonomy: $idListTaxonomy, ')
          ..write('bSynthese: $bSynthese, ')
          ..write('taxonomyDisplayFieldName: $taxonomyDisplayFieldName, ')
          ..write('bDrawSitesGroup: $bDrawSitesGroup, ')
          ..write('data: $data, ')
          ..write('configuration: $configuration')
          ..write(')'))
        .toString();
  }
}

class $TSitesGroupsTable extends TSitesGroups
    with TableInfo<$TSitesGroupsTable, TSitesGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TSitesGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idSitesGroupMeta =
      const VerificationMeta('idSitesGroup');
  @override
  late final GeneratedColumn<int> idSitesGroup = GeneratedColumn<int>(
      'id_sites_group', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sitesGroupNameMeta =
      const VerificationMeta('sitesGroupName');
  @override
  late final GeneratedColumn<String> sitesGroupName = GeneratedColumn<String>(
      'sites_group_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sitesGroupCodeMeta =
      const VerificationMeta('sitesGroupCode');
  @override
  late final GeneratedColumn<String> sitesGroupCode = GeneratedColumn<String>(
      'sites_group_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sitesGroupDescriptionMeta =
      const VerificationMeta('sitesGroupDescription');
  @override
  late final GeneratedColumn<String> sitesGroupDescription =
      GeneratedColumn<String>('sites_group_description', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _uuidSitesGroupMeta =
      const VerificationMeta('uuidSitesGroup');
  @override
  late final GeneratedColumn<String> uuidSitesGroup = GeneratedColumn<String>(
      'uuid_sites_group', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _commentsMeta =
      const VerificationMeta('comments');
  @override
  late final GeneratedColumn<String> comments = GeneratedColumn<String>(
      'comments', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _metaCreateDateMeta =
      const VerificationMeta('metaCreateDate');
  @override
  late final GeneratedColumn<DateTime> metaCreateDate =
      GeneratedColumn<DateTime>('meta_create_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _metaUpdateDateMeta =
      const VerificationMeta('metaUpdateDate');
  @override
  late final GeneratedColumn<DateTime> metaUpdateDate =
      GeneratedColumn<DateTime>('meta_update_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _idDigitiserMeta =
      const VerificationMeta('idDigitiser');
  @override
  late final GeneratedColumn<int> idDigitiser = GeneratedColumn<int>(
      'id_digitiser', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _geomMeta = const VerificationMeta('geom');
  @override
  late final GeneratedColumn<String> geom = GeneratedColumn<String>(
      'geom', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _altitudeMinMeta =
      const VerificationMeta('altitudeMin');
  @override
  late final GeneratedColumn<int> altitudeMin = GeneratedColumn<int>(
      'altitude_min', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _altitudeMaxMeta =
      const VerificationMeta('altitudeMax');
  @override
  late final GeneratedColumn<int> altitudeMax = GeneratedColumn<int>(
      'altitude_max', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        idSitesGroup,
        sitesGroupName,
        sitesGroupCode,
        sitesGroupDescription,
        uuidSitesGroup,
        comments,
        data,
        metaCreateDate,
        metaUpdateDate,
        idDigitiser,
        geom,
        altitudeMin,
        altitudeMax
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 't_sites_groups';
  @override
  VerificationContext validateIntegrity(Insertable<TSitesGroup> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_sites_group')) {
      context.handle(
          _idSitesGroupMeta,
          idSitesGroup.isAcceptableOrUnknown(
              data['id_sites_group']!, _idSitesGroupMeta));
    }
    if (data.containsKey('sites_group_name')) {
      context.handle(
          _sitesGroupNameMeta,
          sitesGroupName.isAcceptableOrUnknown(
              data['sites_group_name']!, _sitesGroupNameMeta));
    }
    if (data.containsKey('sites_group_code')) {
      context.handle(
          _sitesGroupCodeMeta,
          sitesGroupCode.isAcceptableOrUnknown(
              data['sites_group_code']!, _sitesGroupCodeMeta));
    }
    if (data.containsKey('sites_group_description')) {
      context.handle(
          _sitesGroupDescriptionMeta,
          sitesGroupDescription.isAcceptableOrUnknown(
              data['sites_group_description']!, _sitesGroupDescriptionMeta));
    }
    if (data.containsKey('uuid_sites_group')) {
      context.handle(
          _uuidSitesGroupMeta,
          uuidSitesGroup.isAcceptableOrUnknown(
              data['uuid_sites_group']!, _uuidSitesGroupMeta));
    }
    if (data.containsKey('comments')) {
      context.handle(_commentsMeta,
          comments.isAcceptableOrUnknown(data['comments']!, _commentsMeta));
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    }
    if (data.containsKey('meta_create_date')) {
      context.handle(
          _metaCreateDateMeta,
          metaCreateDate.isAcceptableOrUnknown(
              data['meta_create_date']!, _metaCreateDateMeta));
    }
    if (data.containsKey('meta_update_date')) {
      context.handle(
          _metaUpdateDateMeta,
          metaUpdateDate.isAcceptableOrUnknown(
              data['meta_update_date']!, _metaUpdateDateMeta));
    }
    if (data.containsKey('id_digitiser')) {
      context.handle(
          _idDigitiserMeta,
          idDigitiser.isAcceptableOrUnknown(
              data['id_digitiser']!, _idDigitiserMeta));
    }
    if (data.containsKey('geom')) {
      context.handle(
          _geomMeta, geom.isAcceptableOrUnknown(data['geom']!, _geomMeta));
    }
    if (data.containsKey('altitude_min')) {
      context.handle(
          _altitudeMinMeta,
          altitudeMin.isAcceptableOrUnknown(
              data['altitude_min']!, _altitudeMinMeta));
    }
    if (data.containsKey('altitude_max')) {
      context.handle(
          _altitudeMaxMeta,
          altitudeMax.isAcceptableOrUnknown(
              data['altitude_max']!, _altitudeMaxMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idSitesGroup};
  @override
  TSitesGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TSitesGroup(
      idSitesGroup: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_sites_group'])!,
      sitesGroupName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}sites_group_name']),
      sitesGroupCode: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}sites_group_code']),
      sitesGroupDescription: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sites_group_description']),
      uuidSitesGroup: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}uuid_sites_group']),
      comments: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}comments']),
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data']),
      metaCreateDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}meta_create_date']),
      metaUpdateDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}meta_update_date']),
      idDigitiser: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_digitiser']),
      geom: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}geom']),
      altitudeMin: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}altitude_min']),
      altitudeMax: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}altitude_max']),
    );
  }

  @override
  $TSitesGroupsTable createAlias(String alias) {
    return $TSitesGroupsTable(attachedDatabase, alias);
  }
}

class TSitesGroup extends DataClass implements Insertable<TSitesGroup> {
  final int idSitesGroup;
  final String? sitesGroupName;
  final String? sitesGroupCode;
  final String? sitesGroupDescription;
  final String? uuidSitesGroup;
  final String? comments;
  final String? data;
  final DateTime? metaCreateDate;
  final DateTime? metaUpdateDate;
  final int? idDigitiser;
  final String? geom;
  final int? altitudeMin;
  final int? altitudeMax;
  const TSitesGroup(
      {required this.idSitesGroup,
      this.sitesGroupName,
      this.sitesGroupCode,
      this.sitesGroupDescription,
      this.uuidSitesGroup,
      this.comments,
      this.data,
      this.metaCreateDate,
      this.metaUpdateDate,
      this.idDigitiser,
      this.geom,
      this.altitudeMin,
      this.altitudeMax});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_sites_group'] = Variable<int>(idSitesGroup);
    if (!nullToAbsent || sitesGroupName != null) {
      map['sites_group_name'] = Variable<String>(sitesGroupName);
    }
    if (!nullToAbsent || sitesGroupCode != null) {
      map['sites_group_code'] = Variable<String>(sitesGroupCode);
    }
    if (!nullToAbsent || sitesGroupDescription != null) {
      map['sites_group_description'] = Variable<String>(sitesGroupDescription);
    }
    if (!nullToAbsent || uuidSitesGroup != null) {
      map['uuid_sites_group'] = Variable<String>(uuidSitesGroup);
    }
    if (!nullToAbsent || comments != null) {
      map['comments'] = Variable<String>(comments);
    }
    if (!nullToAbsent || data != null) {
      map['data'] = Variable<String>(data);
    }
    if (!nullToAbsent || metaCreateDate != null) {
      map['meta_create_date'] = Variable<DateTime>(metaCreateDate);
    }
    if (!nullToAbsent || metaUpdateDate != null) {
      map['meta_update_date'] = Variable<DateTime>(metaUpdateDate);
    }
    if (!nullToAbsent || idDigitiser != null) {
      map['id_digitiser'] = Variable<int>(idDigitiser);
    }
    if (!nullToAbsent || geom != null) {
      map['geom'] = Variable<String>(geom);
    }
    if (!nullToAbsent || altitudeMin != null) {
      map['altitude_min'] = Variable<int>(altitudeMin);
    }
    if (!nullToAbsent || altitudeMax != null) {
      map['altitude_max'] = Variable<int>(altitudeMax);
    }
    return map;
  }

  TSitesGroupsCompanion toCompanion(bool nullToAbsent) {
    return TSitesGroupsCompanion(
      idSitesGroup: Value(idSitesGroup),
      sitesGroupName: sitesGroupName == null && nullToAbsent
          ? const Value.absent()
          : Value(sitesGroupName),
      sitesGroupCode: sitesGroupCode == null && nullToAbsent
          ? const Value.absent()
          : Value(sitesGroupCode),
      sitesGroupDescription: sitesGroupDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(sitesGroupDescription),
      uuidSitesGroup: uuidSitesGroup == null && nullToAbsent
          ? const Value.absent()
          : Value(uuidSitesGroup),
      comments: comments == null && nullToAbsent
          ? const Value.absent()
          : Value(comments),
      data: data == null && nullToAbsent ? const Value.absent() : Value(data),
      metaCreateDate: metaCreateDate == null && nullToAbsent
          ? const Value.absent()
          : Value(metaCreateDate),
      metaUpdateDate: metaUpdateDate == null && nullToAbsent
          ? const Value.absent()
          : Value(metaUpdateDate),
      idDigitiser: idDigitiser == null && nullToAbsent
          ? const Value.absent()
          : Value(idDigitiser),
      geom: geom == null && nullToAbsent ? const Value.absent() : Value(geom),
      altitudeMin: altitudeMin == null && nullToAbsent
          ? const Value.absent()
          : Value(altitudeMin),
      altitudeMax: altitudeMax == null && nullToAbsent
          ? const Value.absent()
          : Value(altitudeMax),
    );
  }

  factory TSitesGroup.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TSitesGroup(
      idSitesGroup: serializer.fromJson<int>(json['idSitesGroup']),
      sitesGroupName: serializer.fromJson<String?>(json['sitesGroupName']),
      sitesGroupCode: serializer.fromJson<String?>(json['sitesGroupCode']),
      sitesGroupDescription:
          serializer.fromJson<String?>(json['sitesGroupDescription']),
      uuidSitesGroup: serializer.fromJson<String?>(json['uuidSitesGroup']),
      comments: serializer.fromJson<String?>(json['comments']),
      data: serializer.fromJson<String?>(json['data']),
      metaCreateDate: serializer.fromJson<DateTime?>(json['metaCreateDate']),
      metaUpdateDate: serializer.fromJson<DateTime?>(json['metaUpdateDate']),
      idDigitiser: serializer.fromJson<int?>(json['idDigitiser']),
      geom: serializer.fromJson<String?>(json['geom']),
      altitudeMin: serializer.fromJson<int?>(json['altitudeMin']),
      altitudeMax: serializer.fromJson<int?>(json['altitudeMax']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idSitesGroup': serializer.toJson<int>(idSitesGroup),
      'sitesGroupName': serializer.toJson<String?>(sitesGroupName),
      'sitesGroupCode': serializer.toJson<String?>(sitesGroupCode),
      'sitesGroupDescription':
          serializer.toJson<String?>(sitesGroupDescription),
      'uuidSitesGroup': serializer.toJson<String?>(uuidSitesGroup),
      'comments': serializer.toJson<String?>(comments),
      'data': serializer.toJson<String?>(data),
      'metaCreateDate': serializer.toJson<DateTime?>(metaCreateDate),
      'metaUpdateDate': serializer.toJson<DateTime?>(metaUpdateDate),
      'idDigitiser': serializer.toJson<int?>(idDigitiser),
      'geom': serializer.toJson<String?>(geom),
      'altitudeMin': serializer.toJson<int?>(altitudeMin),
      'altitudeMax': serializer.toJson<int?>(altitudeMax),
    };
  }

  TSitesGroup copyWith(
          {int? idSitesGroup,
          Value<String?> sitesGroupName = const Value.absent(),
          Value<String?> sitesGroupCode = const Value.absent(),
          Value<String?> sitesGroupDescription = const Value.absent(),
          Value<String?> uuidSitesGroup = const Value.absent(),
          Value<String?> comments = const Value.absent(),
          Value<String?> data = const Value.absent(),
          Value<DateTime?> metaCreateDate = const Value.absent(),
          Value<DateTime?> metaUpdateDate = const Value.absent(),
          Value<int?> idDigitiser = const Value.absent(),
          Value<String?> geom = const Value.absent(),
          Value<int?> altitudeMin = const Value.absent(),
          Value<int?> altitudeMax = const Value.absent()}) =>
      TSitesGroup(
        idSitesGroup: idSitesGroup ?? this.idSitesGroup,
        sitesGroupName:
            sitesGroupName.present ? sitesGroupName.value : this.sitesGroupName,
        sitesGroupCode:
            sitesGroupCode.present ? sitesGroupCode.value : this.sitesGroupCode,
        sitesGroupDescription: sitesGroupDescription.present
            ? sitesGroupDescription.value
            : this.sitesGroupDescription,
        uuidSitesGroup:
            uuidSitesGroup.present ? uuidSitesGroup.value : this.uuidSitesGroup,
        comments: comments.present ? comments.value : this.comments,
        data: data.present ? data.value : this.data,
        metaCreateDate:
            metaCreateDate.present ? metaCreateDate.value : this.metaCreateDate,
        metaUpdateDate:
            metaUpdateDate.present ? metaUpdateDate.value : this.metaUpdateDate,
        idDigitiser: idDigitiser.present ? idDigitiser.value : this.idDigitiser,
        geom: geom.present ? geom.value : this.geom,
        altitudeMin: altitudeMin.present ? altitudeMin.value : this.altitudeMin,
        altitudeMax: altitudeMax.present ? altitudeMax.value : this.altitudeMax,
      );
  TSitesGroup copyWithCompanion(TSitesGroupsCompanion data) {
    return TSitesGroup(
      idSitesGroup: data.idSitesGroup.present
          ? data.idSitesGroup.value
          : this.idSitesGroup,
      sitesGroupName: data.sitesGroupName.present
          ? data.sitesGroupName.value
          : this.sitesGroupName,
      sitesGroupCode: data.sitesGroupCode.present
          ? data.sitesGroupCode.value
          : this.sitesGroupCode,
      sitesGroupDescription: data.sitesGroupDescription.present
          ? data.sitesGroupDescription.value
          : this.sitesGroupDescription,
      uuidSitesGroup: data.uuidSitesGroup.present
          ? data.uuidSitesGroup.value
          : this.uuidSitesGroup,
      comments: data.comments.present ? data.comments.value : this.comments,
      data: data.data.present ? data.data.value : this.data,
      metaCreateDate: data.metaCreateDate.present
          ? data.metaCreateDate.value
          : this.metaCreateDate,
      metaUpdateDate: data.metaUpdateDate.present
          ? data.metaUpdateDate.value
          : this.metaUpdateDate,
      idDigitiser:
          data.idDigitiser.present ? data.idDigitiser.value : this.idDigitiser,
      geom: data.geom.present ? data.geom.value : this.geom,
      altitudeMin:
          data.altitudeMin.present ? data.altitudeMin.value : this.altitudeMin,
      altitudeMax:
          data.altitudeMax.present ? data.altitudeMax.value : this.altitudeMax,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TSitesGroup(')
          ..write('idSitesGroup: $idSitesGroup, ')
          ..write('sitesGroupName: $sitesGroupName, ')
          ..write('sitesGroupCode: $sitesGroupCode, ')
          ..write('sitesGroupDescription: $sitesGroupDescription, ')
          ..write('uuidSitesGroup: $uuidSitesGroup, ')
          ..write('comments: $comments, ')
          ..write('data: $data, ')
          ..write('metaCreateDate: $metaCreateDate, ')
          ..write('metaUpdateDate: $metaUpdateDate, ')
          ..write('idDigitiser: $idDigitiser, ')
          ..write('geom: $geom, ')
          ..write('altitudeMin: $altitudeMin, ')
          ..write('altitudeMax: $altitudeMax')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      idSitesGroup,
      sitesGroupName,
      sitesGroupCode,
      sitesGroupDescription,
      uuidSitesGroup,
      comments,
      data,
      metaCreateDate,
      metaUpdateDate,
      idDigitiser,
      geom,
      altitudeMin,
      altitudeMax);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TSitesGroup &&
          other.idSitesGroup == this.idSitesGroup &&
          other.sitesGroupName == this.sitesGroupName &&
          other.sitesGroupCode == this.sitesGroupCode &&
          other.sitesGroupDescription == this.sitesGroupDescription &&
          other.uuidSitesGroup == this.uuidSitesGroup &&
          other.comments == this.comments &&
          other.data == this.data &&
          other.metaCreateDate == this.metaCreateDate &&
          other.metaUpdateDate == this.metaUpdateDate &&
          other.idDigitiser == this.idDigitiser &&
          other.geom == this.geom &&
          other.altitudeMin == this.altitudeMin &&
          other.altitudeMax == this.altitudeMax);
}

class TSitesGroupsCompanion extends UpdateCompanion<TSitesGroup> {
  final Value<int> idSitesGroup;
  final Value<String?> sitesGroupName;
  final Value<String?> sitesGroupCode;
  final Value<String?> sitesGroupDescription;
  final Value<String?> uuidSitesGroup;
  final Value<String?> comments;
  final Value<String?> data;
  final Value<DateTime?> metaCreateDate;
  final Value<DateTime?> metaUpdateDate;
  final Value<int?> idDigitiser;
  final Value<String?> geom;
  final Value<int?> altitudeMin;
  final Value<int?> altitudeMax;
  const TSitesGroupsCompanion({
    this.idSitesGroup = const Value.absent(),
    this.sitesGroupName = const Value.absent(),
    this.sitesGroupCode = const Value.absent(),
    this.sitesGroupDescription = const Value.absent(),
    this.uuidSitesGroup = const Value.absent(),
    this.comments = const Value.absent(),
    this.data = const Value.absent(),
    this.metaCreateDate = const Value.absent(),
    this.metaUpdateDate = const Value.absent(),
    this.idDigitiser = const Value.absent(),
    this.geom = const Value.absent(),
    this.altitudeMin = const Value.absent(),
    this.altitudeMax = const Value.absent(),
  });
  TSitesGroupsCompanion.insert({
    this.idSitesGroup = const Value.absent(),
    this.sitesGroupName = const Value.absent(),
    this.sitesGroupCode = const Value.absent(),
    this.sitesGroupDescription = const Value.absent(),
    this.uuidSitesGroup = const Value.absent(),
    this.comments = const Value.absent(),
    this.data = const Value.absent(),
    this.metaCreateDate = const Value.absent(),
    this.metaUpdateDate = const Value.absent(),
    this.idDigitiser = const Value.absent(),
    this.geom = const Value.absent(),
    this.altitudeMin = const Value.absent(),
    this.altitudeMax = const Value.absent(),
  });
  static Insertable<TSitesGroup> custom({
    Expression<int>? idSitesGroup,
    Expression<String>? sitesGroupName,
    Expression<String>? sitesGroupCode,
    Expression<String>? sitesGroupDescription,
    Expression<String>? uuidSitesGroup,
    Expression<String>? comments,
    Expression<String>? data,
    Expression<DateTime>? metaCreateDate,
    Expression<DateTime>? metaUpdateDate,
    Expression<int>? idDigitiser,
    Expression<String>? geom,
    Expression<int>? altitudeMin,
    Expression<int>? altitudeMax,
  }) {
    return RawValuesInsertable({
      if (idSitesGroup != null) 'id_sites_group': idSitesGroup,
      if (sitesGroupName != null) 'sites_group_name': sitesGroupName,
      if (sitesGroupCode != null) 'sites_group_code': sitesGroupCode,
      if (sitesGroupDescription != null)
        'sites_group_description': sitesGroupDescription,
      if (uuidSitesGroup != null) 'uuid_sites_group': uuidSitesGroup,
      if (comments != null) 'comments': comments,
      if (data != null) 'data': data,
      if (metaCreateDate != null) 'meta_create_date': metaCreateDate,
      if (metaUpdateDate != null) 'meta_update_date': metaUpdateDate,
      if (idDigitiser != null) 'id_digitiser': idDigitiser,
      if (geom != null) 'geom': geom,
      if (altitudeMin != null) 'altitude_min': altitudeMin,
      if (altitudeMax != null) 'altitude_max': altitudeMax,
    });
  }

  TSitesGroupsCompanion copyWith(
      {Value<int>? idSitesGroup,
      Value<String?>? sitesGroupName,
      Value<String?>? sitesGroupCode,
      Value<String?>? sitesGroupDescription,
      Value<String?>? uuidSitesGroup,
      Value<String?>? comments,
      Value<String?>? data,
      Value<DateTime?>? metaCreateDate,
      Value<DateTime?>? metaUpdateDate,
      Value<int?>? idDigitiser,
      Value<String?>? geom,
      Value<int?>? altitudeMin,
      Value<int?>? altitudeMax}) {
    return TSitesGroupsCompanion(
      idSitesGroup: idSitesGroup ?? this.idSitesGroup,
      sitesGroupName: sitesGroupName ?? this.sitesGroupName,
      sitesGroupCode: sitesGroupCode ?? this.sitesGroupCode,
      sitesGroupDescription:
          sitesGroupDescription ?? this.sitesGroupDescription,
      uuidSitesGroup: uuidSitesGroup ?? this.uuidSitesGroup,
      comments: comments ?? this.comments,
      data: data ?? this.data,
      metaCreateDate: metaCreateDate ?? this.metaCreateDate,
      metaUpdateDate: metaUpdateDate ?? this.metaUpdateDate,
      idDigitiser: idDigitiser ?? this.idDigitiser,
      geom: geom ?? this.geom,
      altitudeMin: altitudeMin ?? this.altitudeMin,
      altitudeMax: altitudeMax ?? this.altitudeMax,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idSitesGroup.present) {
      map['id_sites_group'] = Variable<int>(idSitesGroup.value);
    }
    if (sitesGroupName.present) {
      map['sites_group_name'] = Variable<String>(sitesGroupName.value);
    }
    if (sitesGroupCode.present) {
      map['sites_group_code'] = Variable<String>(sitesGroupCode.value);
    }
    if (sitesGroupDescription.present) {
      map['sites_group_description'] =
          Variable<String>(sitesGroupDescription.value);
    }
    if (uuidSitesGroup.present) {
      map['uuid_sites_group'] = Variable<String>(uuidSitesGroup.value);
    }
    if (comments.present) {
      map['comments'] = Variable<String>(comments.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (metaCreateDate.present) {
      map['meta_create_date'] = Variable<DateTime>(metaCreateDate.value);
    }
    if (metaUpdateDate.present) {
      map['meta_update_date'] = Variable<DateTime>(metaUpdateDate.value);
    }
    if (idDigitiser.present) {
      map['id_digitiser'] = Variable<int>(idDigitiser.value);
    }
    if (geom.present) {
      map['geom'] = Variable<String>(geom.value);
    }
    if (altitudeMin.present) {
      map['altitude_min'] = Variable<int>(altitudeMin.value);
    }
    if (altitudeMax.present) {
      map['altitude_max'] = Variable<int>(altitudeMax.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TSitesGroupsCompanion(')
          ..write('idSitesGroup: $idSitesGroup, ')
          ..write('sitesGroupName: $sitesGroupName, ')
          ..write('sitesGroupCode: $sitesGroupCode, ')
          ..write('sitesGroupDescription: $sitesGroupDescription, ')
          ..write('uuidSitesGroup: $uuidSitesGroup, ')
          ..write('comments: $comments, ')
          ..write('data: $data, ')
          ..write('metaCreateDate: $metaCreateDate, ')
          ..write('metaUpdateDate: $metaUpdateDate, ')
          ..write('idDigitiser: $idDigitiser, ')
          ..write('geom: $geom, ')
          ..write('altitudeMin: $altitudeMin, ')
          ..write('altitudeMax: $altitudeMax')
          ..write(')'))
        .toString();
  }
}

class $TSiteComplementsTable extends TSiteComplements
    with TableInfo<$TSiteComplementsTable, TSiteComplement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TSiteComplementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idBaseSiteMeta =
      const VerificationMeta('idBaseSite');
  @override
  late final GeneratedColumn<int> idBaseSite = GeneratedColumn<int>(
      'id_base_site', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _idSitesGroupMeta =
      const VerificationMeta('idSitesGroup');
  @override
  late final GeneratedColumn<int> idSitesGroup = GeneratedColumn<int>(
      'id_sites_group', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [idBaseSite, idSitesGroup, data];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 't_site_complements';
  @override
  VerificationContext validateIntegrity(Insertable<TSiteComplement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_base_site')) {
      context.handle(
          _idBaseSiteMeta,
          idBaseSite.isAcceptableOrUnknown(
              data['id_base_site']!, _idBaseSiteMeta));
    }
    if (data.containsKey('id_sites_group')) {
      context.handle(
          _idSitesGroupMeta,
          idSitesGroup.isAcceptableOrUnknown(
              data['id_sites_group']!, _idSitesGroupMeta));
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idBaseSite};
  @override
  TSiteComplement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TSiteComplement(
      idBaseSite: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_base_site'])!,
      idSitesGroup: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_sites_group']),
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data']),
    );
  }

  @override
  $TSiteComplementsTable createAlias(String alias) {
    return $TSiteComplementsTable(attachedDatabase, alias);
  }
}

class TSiteComplement extends DataClass implements Insertable<TSiteComplement> {
  final int idBaseSite;
  final int? idSitesGroup;
  final String? data;
  const TSiteComplement(
      {required this.idBaseSite, this.idSitesGroup, this.data});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_base_site'] = Variable<int>(idBaseSite);
    if (!nullToAbsent || idSitesGroup != null) {
      map['id_sites_group'] = Variable<int>(idSitesGroup);
    }
    if (!nullToAbsent || data != null) {
      map['data'] = Variable<String>(data);
    }
    return map;
  }

  TSiteComplementsCompanion toCompanion(bool nullToAbsent) {
    return TSiteComplementsCompanion(
      idBaseSite: Value(idBaseSite),
      idSitesGroup: idSitesGroup == null && nullToAbsent
          ? const Value.absent()
          : Value(idSitesGroup),
      data: data == null && nullToAbsent ? const Value.absent() : Value(data),
    );
  }

  factory TSiteComplement.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TSiteComplement(
      idBaseSite: serializer.fromJson<int>(json['idBaseSite']),
      idSitesGroup: serializer.fromJson<int?>(json['idSitesGroup']),
      data: serializer.fromJson<String?>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idBaseSite': serializer.toJson<int>(idBaseSite),
      'idSitesGroup': serializer.toJson<int?>(idSitesGroup),
      'data': serializer.toJson<String?>(data),
    };
  }

  TSiteComplement copyWith(
          {int? idBaseSite,
          Value<int?> idSitesGroup = const Value.absent(),
          Value<String?> data = const Value.absent()}) =>
      TSiteComplement(
        idBaseSite: idBaseSite ?? this.idBaseSite,
        idSitesGroup:
            idSitesGroup.present ? idSitesGroup.value : this.idSitesGroup,
        data: data.present ? data.value : this.data,
      );
  TSiteComplement copyWithCompanion(TSiteComplementsCompanion data) {
    return TSiteComplement(
      idBaseSite:
          data.idBaseSite.present ? data.idBaseSite.value : this.idBaseSite,
      idSitesGroup: data.idSitesGroup.present
          ? data.idSitesGroup.value
          : this.idSitesGroup,
      data: data.data.present ? data.data.value : this.data,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TSiteComplement(')
          ..write('idBaseSite: $idBaseSite, ')
          ..write('idSitesGroup: $idSitesGroup, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(idBaseSite, idSitesGroup, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TSiteComplement &&
          other.idBaseSite == this.idBaseSite &&
          other.idSitesGroup == this.idSitesGroup &&
          other.data == this.data);
}

class TSiteComplementsCompanion extends UpdateCompanion<TSiteComplement> {
  final Value<int> idBaseSite;
  final Value<int?> idSitesGroup;
  final Value<String?> data;
  const TSiteComplementsCompanion({
    this.idBaseSite = const Value.absent(),
    this.idSitesGroup = const Value.absent(),
    this.data = const Value.absent(),
  });
  TSiteComplementsCompanion.insert({
    this.idBaseSite = const Value.absent(),
    this.idSitesGroup = const Value.absent(),
    this.data = const Value.absent(),
  });
  static Insertable<TSiteComplement> custom({
    Expression<int>? idBaseSite,
    Expression<int>? idSitesGroup,
    Expression<String>? data,
  }) {
    return RawValuesInsertable({
      if (idBaseSite != null) 'id_base_site': idBaseSite,
      if (idSitesGroup != null) 'id_sites_group': idSitesGroup,
      if (data != null) 'data': data,
    });
  }

  TSiteComplementsCompanion copyWith(
      {Value<int>? idBaseSite,
      Value<int?>? idSitesGroup,
      Value<String?>? data}) {
    return TSiteComplementsCompanion(
      idBaseSite: idBaseSite ?? this.idBaseSite,
      idSitesGroup: idSitesGroup ?? this.idSitesGroup,
      data: data ?? this.data,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idBaseSite.present) {
      map['id_base_site'] = Variable<int>(idBaseSite.value);
    }
    if (idSitesGroup.present) {
      map['id_sites_group'] = Variable<int>(idSitesGroup.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TSiteComplementsCompanion(')
          ..write('idBaseSite: $idBaseSite, ')
          ..write('idSitesGroup: $idSitesGroup, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }
}

class $TVisitComplementsTable extends TVisitComplements
    with TableInfo<$TVisitComplementsTable, TVisitComplement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TVisitComplementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idBaseVisitMeta =
      const VerificationMeta('idBaseVisit');
  @override
  late final GeneratedColumn<int> idBaseVisit = GeneratedColumn<int>(
      'id_base_visit', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [idBaseVisit, data];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 't_visit_complements';
  @override
  VerificationContext validateIntegrity(Insertable<TVisitComplement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_base_visit')) {
      context.handle(
          _idBaseVisitMeta,
          idBaseVisit.isAcceptableOrUnknown(
              data['id_base_visit']!, _idBaseVisitMeta));
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idBaseVisit};
  @override
  TVisitComplement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TVisitComplement(
      idBaseVisit: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_base_visit'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data']),
    );
  }

  @override
  $TVisitComplementsTable createAlias(String alias) {
    return $TVisitComplementsTable(attachedDatabase, alias);
  }
}

class TVisitComplement extends DataClass
    implements Insertable<TVisitComplement> {
  final int idBaseVisit;
  final String? data;
  const TVisitComplement({required this.idBaseVisit, this.data});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_base_visit'] = Variable<int>(idBaseVisit);
    if (!nullToAbsent || data != null) {
      map['data'] = Variable<String>(data);
    }
    return map;
  }

  TVisitComplementsCompanion toCompanion(bool nullToAbsent) {
    return TVisitComplementsCompanion(
      idBaseVisit: Value(idBaseVisit),
      data: data == null && nullToAbsent ? const Value.absent() : Value(data),
    );
  }

  factory TVisitComplement.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TVisitComplement(
      idBaseVisit: serializer.fromJson<int>(json['idBaseVisit']),
      data: serializer.fromJson<String?>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idBaseVisit': serializer.toJson<int>(idBaseVisit),
      'data': serializer.toJson<String?>(data),
    };
  }

  TVisitComplement copyWith(
          {int? idBaseVisit, Value<String?> data = const Value.absent()}) =>
      TVisitComplement(
        idBaseVisit: idBaseVisit ?? this.idBaseVisit,
        data: data.present ? data.value : this.data,
      );
  TVisitComplement copyWithCompanion(TVisitComplementsCompanion data) {
    return TVisitComplement(
      idBaseVisit:
          data.idBaseVisit.present ? data.idBaseVisit.value : this.idBaseVisit,
      data: data.data.present ? data.data.value : this.data,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TVisitComplement(')
          ..write('idBaseVisit: $idBaseVisit, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(idBaseVisit, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TVisitComplement &&
          other.idBaseVisit == this.idBaseVisit &&
          other.data == this.data);
}

class TVisitComplementsCompanion extends UpdateCompanion<TVisitComplement> {
  final Value<int> idBaseVisit;
  final Value<String?> data;
  const TVisitComplementsCompanion({
    this.idBaseVisit = const Value.absent(),
    this.data = const Value.absent(),
  });
  TVisitComplementsCompanion.insert({
    this.idBaseVisit = const Value.absent(),
    this.data = const Value.absent(),
  });
  static Insertable<TVisitComplement> custom({
    Expression<int>? idBaseVisit,
    Expression<String>? data,
  }) {
    return RawValuesInsertable({
      if (idBaseVisit != null) 'id_base_visit': idBaseVisit,
      if (data != null) 'data': data,
    });
  }

  TVisitComplementsCompanion copyWith(
      {Value<int>? idBaseVisit, Value<String?>? data}) {
    return TVisitComplementsCompanion(
      idBaseVisit: idBaseVisit ?? this.idBaseVisit,
      data: data ?? this.data,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idBaseVisit.present) {
      map['id_base_visit'] = Variable<int>(idBaseVisit.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TVisitComplementsCompanion(')
          ..write('idBaseVisit: $idBaseVisit, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }
}

class $TObservationsTable extends TObservations
    with TableInfo<$TObservationsTable, TObservation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TObservationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idObservationMeta =
      const VerificationMeta('idObservation');
  @override
  late final GeneratedColumn<int> idObservation = GeneratedColumn<int>(
      'id_observation', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _idBaseVisitMeta =
      const VerificationMeta('idBaseVisit');
  @override
  late final GeneratedColumn<int> idBaseVisit = GeneratedColumn<int>(
      'id_base_visit', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _cdNomMeta = const VerificationMeta('cdNom');
  @override
  late final GeneratedColumn<int> cdNom = GeneratedColumn<int>(
      'cd_nom', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _commentsMeta =
      const VerificationMeta('comments');
  @override
  late final GeneratedColumn<String> comments = GeneratedColumn<String>(
      'comments', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _uuidObservationMeta =
      const VerificationMeta('uuidObservation');
  @override
  late final GeneratedColumn<String> uuidObservation = GeneratedColumn<String>(
      'uuid_observation', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  List<GeneratedColumn> get $columns =>
      [idObservation, idBaseVisit, cdNom, comments, uuidObservation];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 't_observations';
  @override
  VerificationContext validateIntegrity(Insertable<TObservation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_observation')) {
      context.handle(
          _idObservationMeta,
          idObservation.isAcceptableOrUnknown(
              data['id_observation']!, _idObservationMeta));
    }
    if (data.containsKey('id_base_visit')) {
      context.handle(
          _idBaseVisitMeta,
          idBaseVisit.isAcceptableOrUnknown(
              data['id_base_visit']!, _idBaseVisitMeta));
    }
    if (data.containsKey('cd_nom')) {
      context.handle(
          _cdNomMeta, cdNom.isAcceptableOrUnknown(data['cd_nom']!, _cdNomMeta));
    }
    if (data.containsKey('comments')) {
      context.handle(_commentsMeta,
          comments.isAcceptableOrUnknown(data['comments']!, _commentsMeta));
    }
    if (data.containsKey('uuid_observation')) {
      context.handle(
          _uuidObservationMeta,
          uuidObservation.isAcceptableOrUnknown(
              data['uuid_observation']!, _uuidObservationMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idObservation};
  @override
  TObservation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TObservation(
      idObservation: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_observation'])!,
      idBaseVisit: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_base_visit']),
      cdNom: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cd_nom']),
      comments: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}comments']),
      uuidObservation: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}uuid_observation']),
    );
  }

  @override
  $TObservationsTable createAlias(String alias) {
    return $TObservationsTable(attachedDatabase, alias);
  }
}

class TObservation extends DataClass implements Insertable<TObservation> {
  final int idObservation;
  final int? idBaseVisit;
  final int? cdNom;
  final String? comments;
  final String? uuidObservation;
  const TObservation(
      {required this.idObservation,
      this.idBaseVisit,
      this.cdNom,
      this.comments,
      this.uuidObservation});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_observation'] = Variable<int>(idObservation);
    if (!nullToAbsent || idBaseVisit != null) {
      map['id_base_visit'] = Variable<int>(idBaseVisit);
    }
    if (!nullToAbsent || cdNom != null) {
      map['cd_nom'] = Variable<int>(cdNom);
    }
    if (!nullToAbsent || comments != null) {
      map['comments'] = Variable<String>(comments);
    }
    if (!nullToAbsent || uuidObservation != null) {
      map['uuid_observation'] = Variable<String>(uuidObservation);
    }
    return map;
  }

  TObservationsCompanion toCompanion(bool nullToAbsent) {
    return TObservationsCompanion(
      idObservation: Value(idObservation),
      idBaseVisit: idBaseVisit == null && nullToAbsent
          ? const Value.absent()
          : Value(idBaseVisit),
      cdNom:
          cdNom == null && nullToAbsent ? const Value.absent() : Value(cdNom),
      comments: comments == null && nullToAbsent
          ? const Value.absent()
          : Value(comments),
      uuidObservation: uuidObservation == null && nullToAbsent
          ? const Value.absent()
          : Value(uuidObservation),
    );
  }

  factory TObservation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TObservation(
      idObservation: serializer.fromJson<int>(json['idObservation']),
      idBaseVisit: serializer.fromJson<int?>(json['idBaseVisit']),
      cdNom: serializer.fromJson<int?>(json['cdNom']),
      comments: serializer.fromJson<String?>(json['comments']),
      uuidObservation: serializer.fromJson<String?>(json['uuidObservation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idObservation': serializer.toJson<int>(idObservation),
      'idBaseVisit': serializer.toJson<int?>(idBaseVisit),
      'cdNom': serializer.toJson<int?>(cdNom),
      'comments': serializer.toJson<String?>(comments),
      'uuidObservation': serializer.toJson<String?>(uuidObservation),
    };
  }

  TObservation copyWith(
          {int? idObservation,
          Value<int?> idBaseVisit = const Value.absent(),
          Value<int?> cdNom = const Value.absent(),
          Value<String?> comments = const Value.absent(),
          Value<String?> uuidObservation = const Value.absent()}) =>
      TObservation(
        idObservation: idObservation ?? this.idObservation,
        idBaseVisit: idBaseVisit.present ? idBaseVisit.value : this.idBaseVisit,
        cdNom: cdNom.present ? cdNom.value : this.cdNom,
        comments: comments.present ? comments.value : this.comments,
        uuidObservation: uuidObservation.present
            ? uuidObservation.value
            : this.uuidObservation,
      );
  TObservation copyWithCompanion(TObservationsCompanion data) {
    return TObservation(
      idObservation: data.idObservation.present
          ? data.idObservation.value
          : this.idObservation,
      idBaseVisit:
          data.idBaseVisit.present ? data.idBaseVisit.value : this.idBaseVisit,
      cdNom: data.cdNom.present ? data.cdNom.value : this.cdNom,
      comments: data.comments.present ? data.comments.value : this.comments,
      uuidObservation: data.uuidObservation.present
          ? data.uuidObservation.value
          : this.uuidObservation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TObservation(')
          ..write('idObservation: $idObservation, ')
          ..write('idBaseVisit: $idBaseVisit, ')
          ..write('cdNom: $cdNom, ')
          ..write('comments: $comments, ')
          ..write('uuidObservation: $uuidObservation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(idObservation, idBaseVisit, cdNom, comments, uuidObservation);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TObservation &&
          other.idObservation == this.idObservation &&
          other.idBaseVisit == this.idBaseVisit &&
          other.cdNom == this.cdNom &&
          other.comments == this.comments &&
          other.uuidObservation == this.uuidObservation);
}

class TObservationsCompanion extends UpdateCompanion<TObservation> {
  final Value<int> idObservation;
  final Value<int?> idBaseVisit;
  final Value<int?> cdNom;
  final Value<String?> comments;
  final Value<String?> uuidObservation;
  const TObservationsCompanion({
    this.idObservation = const Value.absent(),
    this.idBaseVisit = const Value.absent(),
    this.cdNom = const Value.absent(),
    this.comments = const Value.absent(),
    this.uuidObservation = const Value.absent(),
  });
  TObservationsCompanion.insert({
    this.idObservation = const Value.absent(),
    this.idBaseVisit = const Value.absent(),
    this.cdNom = const Value.absent(),
    this.comments = const Value.absent(),
    this.uuidObservation = const Value.absent(),
  });
  static Insertable<TObservation> custom({
    Expression<int>? idObservation,
    Expression<int>? idBaseVisit,
    Expression<int>? cdNom,
    Expression<String>? comments,
    Expression<String>? uuidObservation,
  }) {
    return RawValuesInsertable({
      if (idObservation != null) 'id_observation': idObservation,
      if (idBaseVisit != null) 'id_base_visit': idBaseVisit,
      if (cdNom != null) 'cd_nom': cdNom,
      if (comments != null) 'comments': comments,
      if (uuidObservation != null) 'uuid_observation': uuidObservation,
    });
  }

  TObservationsCompanion copyWith(
      {Value<int>? idObservation,
      Value<int?>? idBaseVisit,
      Value<int?>? cdNom,
      Value<String?>? comments,
      Value<String?>? uuidObservation}) {
    return TObservationsCompanion(
      idObservation: idObservation ?? this.idObservation,
      idBaseVisit: idBaseVisit ?? this.idBaseVisit,
      cdNom: cdNom ?? this.cdNom,
      comments: comments ?? this.comments,
      uuidObservation: uuidObservation ?? this.uuidObservation,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idObservation.present) {
      map['id_observation'] = Variable<int>(idObservation.value);
    }
    if (idBaseVisit.present) {
      map['id_base_visit'] = Variable<int>(idBaseVisit.value);
    }
    if (cdNom.present) {
      map['cd_nom'] = Variable<int>(cdNom.value);
    }
    if (comments.present) {
      map['comments'] = Variable<String>(comments.value);
    }
    if (uuidObservation.present) {
      map['uuid_observation'] = Variable<String>(uuidObservation.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TObservationsCompanion(')
          ..write('idObservation: $idObservation, ')
          ..write('idBaseVisit: $idBaseVisit, ')
          ..write('cdNom: $cdNom, ')
          ..write('comments: $comments, ')
          ..write('uuidObservation: $uuidObservation')
          ..write(')'))
        .toString();
  }
}

class $TObservationComplementsTable extends TObservationComplements
    with TableInfo<$TObservationComplementsTable, TObservationComplement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TObservationComplementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idObservationMeta =
      const VerificationMeta('idObservation');
  @override
  late final GeneratedColumn<int> idObservation = GeneratedColumn<int>(
      'id_observation', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [idObservation, data];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 't_observation_complements';
  @override
  VerificationContext validateIntegrity(
      Insertable<TObservationComplement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_observation')) {
      context.handle(
          _idObservationMeta,
          idObservation.isAcceptableOrUnknown(
              data['id_observation']!, _idObservationMeta));
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idObservation};
  @override
  TObservationComplement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TObservationComplement(
      idObservation: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_observation'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data']),
    );
  }

  @override
  $TObservationComplementsTable createAlias(String alias) {
    return $TObservationComplementsTable(attachedDatabase, alias);
  }
}

class TObservationComplement extends DataClass
    implements Insertable<TObservationComplement> {
  final int idObservation;
  final String? data;
  const TObservationComplement({required this.idObservation, this.data});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_observation'] = Variable<int>(idObservation);
    if (!nullToAbsent || data != null) {
      map['data'] = Variable<String>(data);
    }
    return map;
  }

  TObservationComplementsCompanion toCompanion(bool nullToAbsent) {
    return TObservationComplementsCompanion(
      idObservation: Value(idObservation),
      data: data == null && nullToAbsent ? const Value.absent() : Value(data),
    );
  }

  factory TObservationComplement.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TObservationComplement(
      idObservation: serializer.fromJson<int>(json['idObservation']),
      data: serializer.fromJson<String?>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idObservation': serializer.toJson<int>(idObservation),
      'data': serializer.toJson<String?>(data),
    };
  }

  TObservationComplement copyWith(
          {int? idObservation, Value<String?> data = const Value.absent()}) =>
      TObservationComplement(
        idObservation: idObservation ?? this.idObservation,
        data: data.present ? data.value : this.data,
      );
  TObservationComplement copyWithCompanion(
      TObservationComplementsCompanion data) {
    return TObservationComplement(
      idObservation: data.idObservation.present
          ? data.idObservation.value
          : this.idObservation,
      data: data.data.present ? data.data.value : this.data,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TObservationComplement(')
          ..write('idObservation: $idObservation, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(idObservation, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TObservationComplement &&
          other.idObservation == this.idObservation &&
          other.data == this.data);
}

class TObservationComplementsCompanion
    extends UpdateCompanion<TObservationComplement> {
  final Value<int> idObservation;
  final Value<String?> data;
  const TObservationComplementsCompanion({
    this.idObservation = const Value.absent(),
    this.data = const Value.absent(),
  });
  TObservationComplementsCompanion.insert({
    this.idObservation = const Value.absent(),
    this.data = const Value.absent(),
  });
  static Insertable<TObservationComplement> custom({
    Expression<int>? idObservation,
    Expression<String>? data,
  }) {
    return RawValuesInsertable({
      if (idObservation != null) 'id_observation': idObservation,
      if (data != null) 'data': data,
    });
  }

  TObservationComplementsCompanion copyWith(
      {Value<int>? idObservation, Value<String?>? data}) {
    return TObservationComplementsCompanion(
      idObservation: idObservation ?? this.idObservation,
      data: data ?? this.data,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idObservation.present) {
      map['id_observation'] = Variable<int>(idObservation.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TObservationComplementsCompanion(')
          ..write('idObservation: $idObservation, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }
}

class $TObservationDetailsTable extends TObservationDetails
    with TableInfo<$TObservationDetailsTable, TObservationDetail> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TObservationDetailsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idObservationDetailMeta =
      const VerificationMeta('idObservationDetail');
  @override
  late final GeneratedColumn<int> idObservationDetail = GeneratedColumn<int>(
      'id_observation_detail', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _idObservationMeta =
      const VerificationMeta('idObservation');
  @override
  late final GeneratedColumn<int> idObservation = GeneratedColumn<int>(
      'id_observation', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _uuidObservationDetailMeta =
      const VerificationMeta('uuidObservationDetail');
  @override
  late final GeneratedColumn<String> uuidObservationDetail =
      GeneratedColumn<String>('uuid_observation_detail', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
          defaultValue: const Constant('randomblob(16)'));
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [idObservationDetail, idObservation, uuidObservationDetail, data];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 't_observation_details';
  @override
  VerificationContext validateIntegrity(Insertable<TObservationDetail> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_observation_detail')) {
      context.handle(
          _idObservationDetailMeta,
          idObservationDetail.isAcceptableOrUnknown(
              data['id_observation_detail']!, _idObservationDetailMeta));
    }
    if (data.containsKey('id_observation')) {
      context.handle(
          _idObservationMeta,
          idObservation.isAcceptableOrUnknown(
              data['id_observation']!, _idObservationMeta));
    }
    if (data.containsKey('uuid_observation_detail')) {
      context.handle(
          _uuidObservationDetailMeta,
          uuidObservationDetail.isAcceptableOrUnknown(
              data['uuid_observation_detail']!, _uuidObservationDetailMeta));
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idObservationDetail};
  @override
  TObservationDetail map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TObservationDetail(
      idObservationDetail: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}id_observation_detail'])!,
      idObservation: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_observation']),
      uuidObservationDetail: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}uuid_observation_detail'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data']),
    );
  }

  @override
  $TObservationDetailsTable createAlias(String alias) {
    return $TObservationDetailsTable(attachedDatabase, alias);
  }
}

class TObservationDetail extends DataClass
    implements Insertable<TObservationDetail> {
  final int idObservationDetail;
  final int? idObservation;
  final String uuidObservationDetail;
  final String? data;
  const TObservationDetail(
      {required this.idObservationDetail,
      this.idObservation,
      required this.uuidObservationDetail,
      this.data});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_observation_detail'] = Variable<int>(idObservationDetail);
    if (!nullToAbsent || idObservation != null) {
      map['id_observation'] = Variable<int>(idObservation);
    }
    map['uuid_observation_detail'] = Variable<String>(uuidObservationDetail);
    if (!nullToAbsent || data != null) {
      map['data'] = Variable<String>(data);
    }
    return map;
  }

  TObservationDetailsCompanion toCompanion(bool nullToAbsent) {
    return TObservationDetailsCompanion(
      idObservationDetail: Value(idObservationDetail),
      idObservation: idObservation == null && nullToAbsent
          ? const Value.absent()
          : Value(idObservation),
      uuidObservationDetail: Value(uuidObservationDetail),
      data: data == null && nullToAbsent ? const Value.absent() : Value(data),
    );
  }

  factory TObservationDetail.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TObservationDetail(
      idObservationDetail:
          serializer.fromJson<int>(json['idObservationDetail']),
      idObservation: serializer.fromJson<int?>(json['idObservation']),
      uuidObservationDetail:
          serializer.fromJson<String>(json['uuidObservationDetail']),
      data: serializer.fromJson<String?>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idObservationDetail': serializer.toJson<int>(idObservationDetail),
      'idObservation': serializer.toJson<int?>(idObservation),
      'uuidObservationDetail': serializer.toJson<String>(uuidObservationDetail),
      'data': serializer.toJson<String?>(data),
    };
  }

  TObservationDetail copyWith(
          {int? idObservationDetail,
          Value<int?> idObservation = const Value.absent(),
          String? uuidObservationDetail,
          Value<String?> data = const Value.absent()}) =>
      TObservationDetail(
        idObservationDetail: idObservationDetail ?? this.idObservationDetail,
        idObservation:
            idObservation.present ? idObservation.value : this.idObservation,
        uuidObservationDetail:
            uuidObservationDetail ?? this.uuidObservationDetail,
        data: data.present ? data.value : this.data,
      );
  TObservationDetail copyWithCompanion(TObservationDetailsCompanion data) {
    return TObservationDetail(
      idObservationDetail: data.idObservationDetail.present
          ? data.idObservationDetail.value
          : this.idObservationDetail,
      idObservation: data.idObservation.present
          ? data.idObservation.value
          : this.idObservation,
      uuidObservationDetail: data.uuidObservationDetail.present
          ? data.uuidObservationDetail.value
          : this.uuidObservationDetail,
      data: data.data.present ? data.data.value : this.data,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TObservationDetail(')
          ..write('idObservationDetail: $idObservationDetail, ')
          ..write('idObservation: $idObservation, ')
          ..write('uuidObservationDetail: $uuidObservationDetail, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      idObservationDetail, idObservation, uuidObservationDetail, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TObservationDetail &&
          other.idObservationDetail == this.idObservationDetail &&
          other.idObservation == this.idObservation &&
          other.uuidObservationDetail == this.uuidObservationDetail &&
          other.data == this.data);
}

class TObservationDetailsCompanion extends UpdateCompanion<TObservationDetail> {
  final Value<int> idObservationDetail;
  final Value<int?> idObservation;
  final Value<String> uuidObservationDetail;
  final Value<String?> data;
  const TObservationDetailsCompanion({
    this.idObservationDetail = const Value.absent(),
    this.idObservation = const Value.absent(),
    this.uuidObservationDetail = const Value.absent(),
    this.data = const Value.absent(),
  });
  TObservationDetailsCompanion.insert({
    this.idObservationDetail = const Value.absent(),
    this.idObservation = const Value.absent(),
    this.uuidObservationDetail = const Value.absent(),
    this.data = const Value.absent(),
  });
  static Insertable<TObservationDetail> custom({
    Expression<int>? idObservationDetail,
    Expression<int>? idObservation,
    Expression<String>? uuidObservationDetail,
    Expression<String>? data,
  }) {
    return RawValuesInsertable({
      if (idObservationDetail != null)
        'id_observation_detail': idObservationDetail,
      if (idObservation != null) 'id_observation': idObservation,
      if (uuidObservationDetail != null)
        'uuid_observation_detail': uuidObservationDetail,
      if (data != null) 'data': data,
    });
  }

  TObservationDetailsCompanion copyWith(
      {Value<int>? idObservationDetail,
      Value<int?>? idObservation,
      Value<String>? uuidObservationDetail,
      Value<String?>? data}) {
    return TObservationDetailsCompanion(
      idObservationDetail: idObservationDetail ?? this.idObservationDetail,
      idObservation: idObservation ?? this.idObservation,
      uuidObservationDetail:
          uuidObservationDetail ?? this.uuidObservationDetail,
      data: data ?? this.data,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idObservationDetail.present) {
      map['id_observation_detail'] = Variable<int>(idObservationDetail.value);
    }
    if (idObservation.present) {
      map['id_observation'] = Variable<int>(idObservation.value);
    }
    if (uuidObservationDetail.present) {
      map['uuid_observation_detail'] =
          Variable<String>(uuidObservationDetail.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TObservationDetailsCompanion(')
          ..write('idObservationDetail: $idObservationDetail, ')
          ..write('idObservation: $idObservation, ')
          ..write('uuidObservationDetail: $uuidObservationDetail, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }
}

class $BibTablesLocationsTable extends BibTablesLocations
    with TableInfo<$BibTablesLocationsTable, BibTablesLocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BibTablesLocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idTableLocationMeta =
      const VerificationMeta('idTableLocation');
  @override
  late final GeneratedColumn<int> idTableLocation = GeneratedColumn<int>(
      'id_table_location', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _tableDescMeta =
      const VerificationMeta('tableDesc');
  @override
  late final GeneratedColumn<String> tableDesc = GeneratedColumn<String>(
      'table_desc', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _schemaNameMeta =
      const VerificationMeta('schemaName');
  @override
  late final GeneratedColumn<String> schemaName = GeneratedColumn<String>(
      'schema_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tableNameLabelMeta =
      const VerificationMeta('tableNameLabel');
  @override
  late final GeneratedColumn<String> tableNameLabel = GeneratedColumn<String>(
      'table_name_label', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pkFieldMeta =
      const VerificationMeta('pkField');
  @override
  late final GeneratedColumn<String> pkField = GeneratedColumn<String>(
      'pk_field', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _uuidFieldNameMeta =
      const VerificationMeta('uuidFieldName');
  @override
  late final GeneratedColumn<String> uuidFieldName = GeneratedColumn<String>(
      'uuid_field_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        idTableLocation,
        tableDesc,
        schemaName,
        tableNameLabel,
        pkField,
        uuidFieldName
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bib_tables_locations';
  @override
  VerificationContext validateIntegrity(Insertable<BibTablesLocation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_table_location')) {
      context.handle(
          _idTableLocationMeta,
          idTableLocation.isAcceptableOrUnknown(
              data['id_table_location']!, _idTableLocationMeta));
    }
    if (data.containsKey('table_desc')) {
      context.handle(_tableDescMeta,
          tableDesc.isAcceptableOrUnknown(data['table_desc']!, _tableDescMeta));
    }
    if (data.containsKey('schema_name')) {
      context.handle(
          _schemaNameMeta,
          schemaName.isAcceptableOrUnknown(
              data['schema_name']!, _schemaNameMeta));
    }
    if (data.containsKey('table_name_label')) {
      context.handle(
          _tableNameLabelMeta,
          tableNameLabel.isAcceptableOrUnknown(
              data['table_name_label']!, _tableNameLabelMeta));
    }
    if (data.containsKey('pk_field')) {
      context.handle(_pkFieldMeta,
          pkField.isAcceptableOrUnknown(data['pk_field']!, _pkFieldMeta));
    }
    if (data.containsKey('uuid_field_name')) {
      context.handle(
          _uuidFieldNameMeta,
          uuidFieldName.isAcceptableOrUnknown(
              data['uuid_field_name']!, _uuidFieldNameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idTableLocation};
  @override
  BibTablesLocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BibTablesLocation(
      idTableLocation: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_table_location'])!,
      tableDesc: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}table_desc']),
      schemaName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}schema_name']),
      tableNameLabel: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}table_name_label']),
      pkField: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pk_field']),
      uuidFieldName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid_field_name']),
    );
  }

  @override
  $BibTablesLocationsTable createAlias(String alias) {
    return $BibTablesLocationsTable(attachedDatabase, alias);
  }
}

class BibTablesLocation extends DataClass
    implements Insertable<BibTablesLocation> {
  final int idTableLocation;
  final String? tableDesc;
  final String? schemaName;
  final String? tableNameLabel;
  final String? pkField;
  final String? uuidFieldName;
  const BibTablesLocation(
      {required this.idTableLocation,
      this.tableDesc,
      this.schemaName,
      this.tableNameLabel,
      this.pkField,
      this.uuidFieldName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_table_location'] = Variable<int>(idTableLocation);
    if (!nullToAbsent || tableDesc != null) {
      map['table_desc'] = Variable<String>(tableDesc);
    }
    if (!nullToAbsent || schemaName != null) {
      map['schema_name'] = Variable<String>(schemaName);
    }
    if (!nullToAbsent || tableNameLabel != null) {
      map['table_name_label'] = Variable<String>(tableNameLabel);
    }
    if (!nullToAbsent || pkField != null) {
      map['pk_field'] = Variable<String>(pkField);
    }
    if (!nullToAbsent || uuidFieldName != null) {
      map['uuid_field_name'] = Variable<String>(uuidFieldName);
    }
    return map;
  }

  BibTablesLocationsCompanion toCompanion(bool nullToAbsent) {
    return BibTablesLocationsCompanion(
      idTableLocation: Value(idTableLocation),
      tableDesc: tableDesc == null && nullToAbsent
          ? const Value.absent()
          : Value(tableDesc),
      schemaName: schemaName == null && nullToAbsent
          ? const Value.absent()
          : Value(schemaName),
      tableNameLabel: tableNameLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(tableNameLabel),
      pkField: pkField == null && nullToAbsent
          ? const Value.absent()
          : Value(pkField),
      uuidFieldName: uuidFieldName == null && nullToAbsent
          ? const Value.absent()
          : Value(uuidFieldName),
    );
  }

  factory BibTablesLocation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BibTablesLocation(
      idTableLocation: serializer.fromJson<int>(json['idTableLocation']),
      tableDesc: serializer.fromJson<String?>(json['tableDesc']),
      schemaName: serializer.fromJson<String?>(json['schemaName']),
      tableNameLabel: serializer.fromJson<String?>(json['tableNameLabel']),
      pkField: serializer.fromJson<String?>(json['pkField']),
      uuidFieldName: serializer.fromJson<String?>(json['uuidFieldName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idTableLocation': serializer.toJson<int>(idTableLocation),
      'tableDesc': serializer.toJson<String?>(tableDesc),
      'schemaName': serializer.toJson<String?>(schemaName),
      'tableNameLabel': serializer.toJson<String?>(tableNameLabel),
      'pkField': serializer.toJson<String?>(pkField),
      'uuidFieldName': serializer.toJson<String?>(uuidFieldName),
    };
  }

  BibTablesLocation copyWith(
          {int? idTableLocation,
          Value<String?> tableDesc = const Value.absent(),
          Value<String?> schemaName = const Value.absent(),
          Value<String?> tableNameLabel = const Value.absent(),
          Value<String?> pkField = const Value.absent(),
          Value<String?> uuidFieldName = const Value.absent()}) =>
      BibTablesLocation(
        idTableLocation: idTableLocation ?? this.idTableLocation,
        tableDesc: tableDesc.present ? tableDesc.value : this.tableDesc,
        schemaName: schemaName.present ? schemaName.value : this.schemaName,
        tableNameLabel:
            tableNameLabel.present ? tableNameLabel.value : this.tableNameLabel,
        pkField: pkField.present ? pkField.value : this.pkField,
        uuidFieldName:
            uuidFieldName.present ? uuidFieldName.value : this.uuidFieldName,
      );
  BibTablesLocation copyWithCompanion(BibTablesLocationsCompanion data) {
    return BibTablesLocation(
      idTableLocation: data.idTableLocation.present
          ? data.idTableLocation.value
          : this.idTableLocation,
      tableDesc: data.tableDesc.present ? data.tableDesc.value : this.tableDesc,
      schemaName:
          data.schemaName.present ? data.schemaName.value : this.schemaName,
      tableNameLabel: data.tableNameLabel.present
          ? data.tableNameLabel.value
          : this.tableNameLabel,
      pkField: data.pkField.present ? data.pkField.value : this.pkField,
      uuidFieldName: data.uuidFieldName.present
          ? data.uuidFieldName.value
          : this.uuidFieldName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BibTablesLocation(')
          ..write('idTableLocation: $idTableLocation, ')
          ..write('tableDesc: $tableDesc, ')
          ..write('schemaName: $schemaName, ')
          ..write('tableNameLabel: $tableNameLabel, ')
          ..write('pkField: $pkField, ')
          ..write('uuidFieldName: $uuidFieldName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(idTableLocation, tableDesc, schemaName,
      tableNameLabel, pkField, uuidFieldName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BibTablesLocation &&
          other.idTableLocation == this.idTableLocation &&
          other.tableDesc == this.tableDesc &&
          other.schemaName == this.schemaName &&
          other.tableNameLabel == this.tableNameLabel &&
          other.pkField == this.pkField &&
          other.uuidFieldName == this.uuidFieldName);
}

class BibTablesLocationsCompanion extends UpdateCompanion<BibTablesLocation> {
  final Value<int> idTableLocation;
  final Value<String?> tableDesc;
  final Value<String?> schemaName;
  final Value<String?> tableNameLabel;
  final Value<String?> pkField;
  final Value<String?> uuidFieldName;
  const BibTablesLocationsCompanion({
    this.idTableLocation = const Value.absent(),
    this.tableDesc = const Value.absent(),
    this.schemaName = const Value.absent(),
    this.tableNameLabel = const Value.absent(),
    this.pkField = const Value.absent(),
    this.uuidFieldName = const Value.absent(),
  });
  BibTablesLocationsCompanion.insert({
    this.idTableLocation = const Value.absent(),
    this.tableDesc = const Value.absent(),
    this.schemaName = const Value.absent(),
    this.tableNameLabel = const Value.absent(),
    this.pkField = const Value.absent(),
    this.uuidFieldName = const Value.absent(),
  });
  static Insertable<BibTablesLocation> custom({
    Expression<int>? idTableLocation,
    Expression<String>? tableDesc,
    Expression<String>? schemaName,
    Expression<String>? tableNameLabel,
    Expression<String>? pkField,
    Expression<String>? uuidFieldName,
  }) {
    return RawValuesInsertable({
      if (idTableLocation != null) 'id_table_location': idTableLocation,
      if (tableDesc != null) 'table_desc': tableDesc,
      if (schemaName != null) 'schema_name': schemaName,
      if (tableNameLabel != null) 'table_name_label': tableNameLabel,
      if (pkField != null) 'pk_field': pkField,
      if (uuidFieldName != null) 'uuid_field_name': uuidFieldName,
    });
  }

  BibTablesLocationsCompanion copyWith(
      {Value<int>? idTableLocation,
      Value<String?>? tableDesc,
      Value<String?>? schemaName,
      Value<String?>? tableNameLabel,
      Value<String?>? pkField,
      Value<String?>? uuidFieldName}) {
    return BibTablesLocationsCompanion(
      idTableLocation: idTableLocation ?? this.idTableLocation,
      tableDesc: tableDesc ?? this.tableDesc,
      schemaName: schemaName ?? this.schemaName,
      tableNameLabel: tableNameLabel ?? this.tableNameLabel,
      pkField: pkField ?? this.pkField,
      uuidFieldName: uuidFieldName ?? this.uuidFieldName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idTableLocation.present) {
      map['id_table_location'] = Variable<int>(idTableLocation.value);
    }
    if (tableDesc.present) {
      map['table_desc'] = Variable<String>(tableDesc.value);
    }
    if (schemaName.present) {
      map['schema_name'] = Variable<String>(schemaName.value);
    }
    if (tableNameLabel.present) {
      map['table_name_label'] = Variable<String>(tableNameLabel.value);
    }
    if (pkField.present) {
      map['pk_field'] = Variable<String>(pkField.value);
    }
    if (uuidFieldName.present) {
      map['uuid_field_name'] = Variable<String>(uuidFieldName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BibTablesLocationsCompanion(')
          ..write('idTableLocation: $idTableLocation, ')
          ..write('tableDesc: $tableDesc, ')
          ..write('schemaName: $schemaName, ')
          ..write('tableNameLabel: $tableNameLabel, ')
          ..write('pkField: $pkField, ')
          ..write('uuidFieldName: $uuidFieldName')
          ..write(')'))
        .toString();
  }
}

class $BibNomenclaturesTypesTableTable extends BibNomenclaturesTypesTable
    with TableInfo<$BibNomenclaturesTypesTableTable, BibNomenclatureType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BibNomenclaturesTypesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idTypeMeta = const VerificationMeta('idType');
  @override
  late final GeneratedColumn<int> idType = GeneratedColumn<int>(
      'id_type', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _mnemoniqueMeta =
      const VerificationMeta('mnemonique');
  @override
  late final GeneratedColumn<String> mnemonique = GeneratedColumn<String>(
      'mnemonique', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _labelDefaultMeta =
      const VerificationMeta('labelDefault');
  @override
  late final GeneratedColumn<String> labelDefault = GeneratedColumn<String>(
      'label_default', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _definitionDefaultMeta =
      const VerificationMeta('definitionDefault');
  @override
  late final GeneratedColumn<String> definitionDefault =
      GeneratedColumn<String>('definition_default', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _labelFrMeta =
      const VerificationMeta('labelFr');
  @override
  late final GeneratedColumn<String> labelFr = GeneratedColumn<String>(
      'label_fr', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _definitionFrMeta =
      const VerificationMeta('definitionFr');
  @override
  late final GeneratedColumn<String> definitionFr = GeneratedColumn<String>(
      'definition_fr', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _labelEnMeta =
      const VerificationMeta('labelEn');
  @override
  late final GeneratedColumn<String> labelEn = GeneratedColumn<String>(
      'label_en', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _definitionEnMeta =
      const VerificationMeta('definitionEn');
  @override
  late final GeneratedColumn<String> definitionEn = GeneratedColumn<String>(
      'definition_en', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _labelEsMeta =
      const VerificationMeta('labelEs');
  @override
  late final GeneratedColumn<String> labelEs = GeneratedColumn<String>(
      'label_es', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _definitionEsMeta =
      const VerificationMeta('definitionEs');
  @override
  late final GeneratedColumn<String> definitionEs = GeneratedColumn<String>(
      'definition_es', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _labelDeMeta =
      const VerificationMeta('labelDe');
  @override
  late final GeneratedColumn<String> labelDe = GeneratedColumn<String>(
      'label_de', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _definitionDeMeta =
      const VerificationMeta('definitionDe');
  @override
  late final GeneratedColumn<String> definitionDe = GeneratedColumn<String>(
      'definition_de', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _labelItMeta =
      const VerificationMeta('labelIt');
  @override
  late final GeneratedColumn<String> labelIt = GeneratedColumn<String>(
      'label_it', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _definitionItMeta =
      const VerificationMeta('definitionIt');
  @override
  late final GeneratedColumn<String> definitionIt = GeneratedColumn<String>(
      'definition_it', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statutMeta = const VerificationMeta('statut');
  @override
  late final GeneratedColumn<String> statut = GeneratedColumn<String>(
      'statut', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _metaCreateDateMeta =
      const VerificationMeta('metaCreateDate');
  @override
  late final GeneratedColumn<DateTime> metaCreateDate =
      GeneratedColumn<DateTime>('meta_create_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _metaUpdateDateMeta =
      const VerificationMeta('metaUpdateDate');
  @override
  late final GeneratedColumn<DateTime> metaUpdateDate =
      GeneratedColumn<DateTime>('meta_update_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        idType,
        mnemonique,
        labelDefault,
        definitionDefault,
        labelFr,
        definitionFr,
        labelEn,
        definitionEn,
        labelEs,
        definitionEs,
        labelDe,
        definitionDe,
        labelIt,
        definitionIt,
        source,
        statut,
        metaCreateDate,
        metaUpdateDate
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bib_nomenclatures_types_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<BibNomenclatureType> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_type')) {
      context.handle(_idTypeMeta,
          idType.isAcceptableOrUnknown(data['id_type']!, _idTypeMeta));
    }
    if (data.containsKey('mnemonique')) {
      context.handle(
          _mnemoniqueMeta,
          mnemonique.isAcceptableOrUnknown(
              data['mnemonique']!, _mnemoniqueMeta));
    }
    if (data.containsKey('label_default')) {
      context.handle(
          _labelDefaultMeta,
          labelDefault.isAcceptableOrUnknown(
              data['label_default']!, _labelDefaultMeta));
    }
    if (data.containsKey('definition_default')) {
      context.handle(
          _definitionDefaultMeta,
          definitionDefault.isAcceptableOrUnknown(
              data['definition_default']!, _definitionDefaultMeta));
    }
    if (data.containsKey('label_fr')) {
      context.handle(_labelFrMeta,
          labelFr.isAcceptableOrUnknown(data['label_fr']!, _labelFrMeta));
    }
    if (data.containsKey('definition_fr')) {
      context.handle(
          _definitionFrMeta,
          definitionFr.isAcceptableOrUnknown(
              data['definition_fr']!, _definitionFrMeta));
    }
    if (data.containsKey('label_en')) {
      context.handle(_labelEnMeta,
          labelEn.isAcceptableOrUnknown(data['label_en']!, _labelEnMeta));
    }
    if (data.containsKey('definition_en')) {
      context.handle(
          _definitionEnMeta,
          definitionEn.isAcceptableOrUnknown(
              data['definition_en']!, _definitionEnMeta));
    }
    if (data.containsKey('label_es')) {
      context.handle(_labelEsMeta,
          labelEs.isAcceptableOrUnknown(data['label_es']!, _labelEsMeta));
    }
    if (data.containsKey('definition_es')) {
      context.handle(
          _definitionEsMeta,
          definitionEs.isAcceptableOrUnknown(
              data['definition_es']!, _definitionEsMeta));
    }
    if (data.containsKey('label_de')) {
      context.handle(_labelDeMeta,
          labelDe.isAcceptableOrUnknown(data['label_de']!, _labelDeMeta));
    }
    if (data.containsKey('definition_de')) {
      context.handle(
          _definitionDeMeta,
          definitionDe.isAcceptableOrUnknown(
              data['definition_de']!, _definitionDeMeta));
    }
    if (data.containsKey('label_it')) {
      context.handle(_labelItMeta,
          labelIt.isAcceptableOrUnknown(data['label_it']!, _labelItMeta));
    }
    if (data.containsKey('definition_it')) {
      context.handle(
          _definitionItMeta,
          definitionIt.isAcceptableOrUnknown(
              data['definition_it']!, _definitionItMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('statut')) {
      context.handle(_statutMeta,
          statut.isAcceptableOrUnknown(data['statut']!, _statutMeta));
    }
    if (data.containsKey('meta_create_date')) {
      context.handle(
          _metaCreateDateMeta,
          metaCreateDate.isAcceptableOrUnknown(
              data['meta_create_date']!, _metaCreateDateMeta));
    }
    if (data.containsKey('meta_update_date')) {
      context.handle(
          _metaUpdateDateMeta,
          metaUpdateDate.isAcceptableOrUnknown(
              data['meta_update_date']!, _metaUpdateDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idType};
  @override
  BibNomenclatureType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BibNomenclatureType(
      idType: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_type'])!,
      mnemonique: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mnemonique']),
      labelDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label_default']),
      definitionDefault: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}definition_default']),
      labelFr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label_fr']),
      definitionFr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}definition_fr']),
      labelEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label_en']),
      definitionEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}definition_en']),
      labelEs: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label_es']),
      definitionEs: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}definition_es']),
      labelDe: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label_de']),
      definitionDe: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}definition_de']),
      labelIt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label_it']),
      definitionIt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}definition_it']),
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source']),
      statut: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}statut']),
      metaCreateDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}meta_create_date']),
      metaUpdateDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}meta_update_date']),
    );
  }

  @override
  $BibNomenclaturesTypesTableTable createAlias(String alias) {
    return $BibNomenclaturesTypesTableTable(attachedDatabase, alias);
  }
}

class BibNomenclatureType extends DataClass
    implements Insertable<BibNomenclatureType> {
  final int idType;
  final String? mnemonique;
  final String? labelDefault;
  final String? definitionDefault;
  final String? labelFr;
  final String? definitionFr;
  final String? labelEn;
  final String? definitionEn;
  final String? labelEs;
  final String? definitionEs;
  final String? labelDe;
  final String? definitionDe;
  final String? labelIt;
  final String? definitionIt;
  final String? source;
  final String? statut;
  final DateTime? metaCreateDate;
  final DateTime? metaUpdateDate;
  const BibNomenclatureType(
      {required this.idType,
      this.mnemonique,
      this.labelDefault,
      this.definitionDefault,
      this.labelFr,
      this.definitionFr,
      this.labelEn,
      this.definitionEn,
      this.labelEs,
      this.definitionEs,
      this.labelDe,
      this.definitionDe,
      this.labelIt,
      this.definitionIt,
      this.source,
      this.statut,
      this.metaCreateDate,
      this.metaUpdateDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_type'] = Variable<int>(idType);
    if (!nullToAbsent || mnemonique != null) {
      map['mnemonique'] = Variable<String>(mnemonique);
    }
    if (!nullToAbsent || labelDefault != null) {
      map['label_default'] = Variable<String>(labelDefault);
    }
    if (!nullToAbsent || definitionDefault != null) {
      map['definition_default'] = Variable<String>(definitionDefault);
    }
    if (!nullToAbsent || labelFr != null) {
      map['label_fr'] = Variable<String>(labelFr);
    }
    if (!nullToAbsent || definitionFr != null) {
      map['definition_fr'] = Variable<String>(definitionFr);
    }
    if (!nullToAbsent || labelEn != null) {
      map['label_en'] = Variable<String>(labelEn);
    }
    if (!nullToAbsent || definitionEn != null) {
      map['definition_en'] = Variable<String>(definitionEn);
    }
    if (!nullToAbsent || labelEs != null) {
      map['label_es'] = Variable<String>(labelEs);
    }
    if (!nullToAbsent || definitionEs != null) {
      map['definition_es'] = Variable<String>(definitionEs);
    }
    if (!nullToAbsent || labelDe != null) {
      map['label_de'] = Variable<String>(labelDe);
    }
    if (!nullToAbsent || definitionDe != null) {
      map['definition_de'] = Variable<String>(definitionDe);
    }
    if (!nullToAbsent || labelIt != null) {
      map['label_it'] = Variable<String>(labelIt);
    }
    if (!nullToAbsent || definitionIt != null) {
      map['definition_it'] = Variable<String>(definitionIt);
    }
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    if (!nullToAbsent || statut != null) {
      map['statut'] = Variable<String>(statut);
    }
    if (!nullToAbsent || metaCreateDate != null) {
      map['meta_create_date'] = Variable<DateTime>(metaCreateDate);
    }
    if (!nullToAbsent || metaUpdateDate != null) {
      map['meta_update_date'] = Variable<DateTime>(metaUpdateDate);
    }
    return map;
  }

  BibNomenclaturesTypesTableCompanion toCompanion(bool nullToAbsent) {
    return BibNomenclaturesTypesTableCompanion(
      idType: Value(idType),
      mnemonique: mnemonique == null && nullToAbsent
          ? const Value.absent()
          : Value(mnemonique),
      labelDefault: labelDefault == null && nullToAbsent
          ? const Value.absent()
          : Value(labelDefault),
      definitionDefault: definitionDefault == null && nullToAbsent
          ? const Value.absent()
          : Value(definitionDefault),
      labelFr: labelFr == null && nullToAbsent
          ? const Value.absent()
          : Value(labelFr),
      definitionFr: definitionFr == null && nullToAbsent
          ? const Value.absent()
          : Value(definitionFr),
      labelEn: labelEn == null && nullToAbsent
          ? const Value.absent()
          : Value(labelEn),
      definitionEn: definitionEn == null && nullToAbsent
          ? const Value.absent()
          : Value(definitionEn),
      labelEs: labelEs == null && nullToAbsent
          ? const Value.absent()
          : Value(labelEs),
      definitionEs: definitionEs == null && nullToAbsent
          ? const Value.absent()
          : Value(definitionEs),
      labelDe: labelDe == null && nullToAbsent
          ? const Value.absent()
          : Value(labelDe),
      definitionDe: definitionDe == null && nullToAbsent
          ? const Value.absent()
          : Value(definitionDe),
      labelIt: labelIt == null && nullToAbsent
          ? const Value.absent()
          : Value(labelIt),
      definitionIt: definitionIt == null && nullToAbsent
          ? const Value.absent()
          : Value(definitionIt),
      source:
          source == null && nullToAbsent ? const Value.absent() : Value(source),
      statut:
          statut == null && nullToAbsent ? const Value.absent() : Value(statut),
      metaCreateDate: metaCreateDate == null && nullToAbsent
          ? const Value.absent()
          : Value(metaCreateDate),
      metaUpdateDate: metaUpdateDate == null && nullToAbsent
          ? const Value.absent()
          : Value(metaUpdateDate),
    );
  }

  factory BibNomenclatureType.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BibNomenclatureType(
      idType: serializer.fromJson<int>(json['idType']),
      mnemonique: serializer.fromJson<String?>(json['mnemonique']),
      labelDefault: serializer.fromJson<String?>(json['labelDefault']),
      definitionDefault:
          serializer.fromJson<String?>(json['definitionDefault']),
      labelFr: serializer.fromJson<String?>(json['labelFr']),
      definitionFr: serializer.fromJson<String?>(json['definitionFr']),
      labelEn: serializer.fromJson<String?>(json['labelEn']),
      definitionEn: serializer.fromJson<String?>(json['definitionEn']),
      labelEs: serializer.fromJson<String?>(json['labelEs']),
      definitionEs: serializer.fromJson<String?>(json['definitionEs']),
      labelDe: serializer.fromJson<String?>(json['labelDe']),
      definitionDe: serializer.fromJson<String?>(json['definitionDe']),
      labelIt: serializer.fromJson<String?>(json['labelIt']),
      definitionIt: serializer.fromJson<String?>(json['definitionIt']),
      source: serializer.fromJson<String?>(json['source']),
      statut: serializer.fromJson<String?>(json['statut']),
      metaCreateDate: serializer.fromJson<DateTime?>(json['metaCreateDate']),
      metaUpdateDate: serializer.fromJson<DateTime?>(json['metaUpdateDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idType': serializer.toJson<int>(idType),
      'mnemonique': serializer.toJson<String?>(mnemonique),
      'labelDefault': serializer.toJson<String?>(labelDefault),
      'definitionDefault': serializer.toJson<String?>(definitionDefault),
      'labelFr': serializer.toJson<String?>(labelFr),
      'definitionFr': serializer.toJson<String?>(definitionFr),
      'labelEn': serializer.toJson<String?>(labelEn),
      'definitionEn': serializer.toJson<String?>(definitionEn),
      'labelEs': serializer.toJson<String?>(labelEs),
      'definitionEs': serializer.toJson<String?>(definitionEs),
      'labelDe': serializer.toJson<String?>(labelDe),
      'definitionDe': serializer.toJson<String?>(definitionDe),
      'labelIt': serializer.toJson<String?>(labelIt),
      'definitionIt': serializer.toJson<String?>(definitionIt),
      'source': serializer.toJson<String?>(source),
      'statut': serializer.toJson<String?>(statut),
      'metaCreateDate': serializer.toJson<DateTime?>(metaCreateDate),
      'metaUpdateDate': serializer.toJson<DateTime?>(metaUpdateDate),
    };
  }

  BibNomenclatureType copyWith(
          {int? idType,
          Value<String?> mnemonique = const Value.absent(),
          Value<String?> labelDefault = const Value.absent(),
          Value<String?> definitionDefault = const Value.absent(),
          Value<String?> labelFr = const Value.absent(),
          Value<String?> definitionFr = const Value.absent(),
          Value<String?> labelEn = const Value.absent(),
          Value<String?> definitionEn = const Value.absent(),
          Value<String?> labelEs = const Value.absent(),
          Value<String?> definitionEs = const Value.absent(),
          Value<String?> labelDe = const Value.absent(),
          Value<String?> definitionDe = const Value.absent(),
          Value<String?> labelIt = const Value.absent(),
          Value<String?> definitionIt = const Value.absent(),
          Value<String?> source = const Value.absent(),
          Value<String?> statut = const Value.absent(),
          Value<DateTime?> metaCreateDate = const Value.absent(),
          Value<DateTime?> metaUpdateDate = const Value.absent()}) =>
      BibNomenclatureType(
        idType: idType ?? this.idType,
        mnemonique: mnemonique.present ? mnemonique.value : this.mnemonique,
        labelDefault:
            labelDefault.present ? labelDefault.value : this.labelDefault,
        definitionDefault: definitionDefault.present
            ? definitionDefault.value
            : this.definitionDefault,
        labelFr: labelFr.present ? labelFr.value : this.labelFr,
        definitionFr:
            definitionFr.present ? definitionFr.value : this.definitionFr,
        labelEn: labelEn.present ? labelEn.value : this.labelEn,
        definitionEn:
            definitionEn.present ? definitionEn.value : this.definitionEn,
        labelEs: labelEs.present ? labelEs.value : this.labelEs,
        definitionEs:
            definitionEs.present ? definitionEs.value : this.definitionEs,
        labelDe: labelDe.present ? labelDe.value : this.labelDe,
        definitionDe:
            definitionDe.present ? definitionDe.value : this.definitionDe,
        labelIt: labelIt.present ? labelIt.value : this.labelIt,
        definitionIt:
            definitionIt.present ? definitionIt.value : this.definitionIt,
        source: source.present ? source.value : this.source,
        statut: statut.present ? statut.value : this.statut,
        metaCreateDate:
            metaCreateDate.present ? metaCreateDate.value : this.metaCreateDate,
        metaUpdateDate:
            metaUpdateDate.present ? metaUpdateDate.value : this.metaUpdateDate,
      );
  BibNomenclatureType copyWithCompanion(
      BibNomenclaturesTypesTableCompanion data) {
    return BibNomenclatureType(
      idType: data.idType.present ? data.idType.value : this.idType,
      mnemonique:
          data.mnemonique.present ? data.mnemonique.value : this.mnemonique,
      labelDefault: data.labelDefault.present
          ? data.labelDefault.value
          : this.labelDefault,
      definitionDefault: data.definitionDefault.present
          ? data.definitionDefault.value
          : this.definitionDefault,
      labelFr: data.labelFr.present ? data.labelFr.value : this.labelFr,
      definitionFr: data.definitionFr.present
          ? data.definitionFr.value
          : this.definitionFr,
      labelEn: data.labelEn.present ? data.labelEn.value : this.labelEn,
      definitionEn: data.definitionEn.present
          ? data.definitionEn.value
          : this.definitionEn,
      labelEs: data.labelEs.present ? data.labelEs.value : this.labelEs,
      definitionEs: data.definitionEs.present
          ? data.definitionEs.value
          : this.definitionEs,
      labelDe: data.labelDe.present ? data.labelDe.value : this.labelDe,
      definitionDe: data.definitionDe.present
          ? data.definitionDe.value
          : this.definitionDe,
      labelIt: data.labelIt.present ? data.labelIt.value : this.labelIt,
      definitionIt: data.definitionIt.present
          ? data.definitionIt.value
          : this.definitionIt,
      source: data.source.present ? data.source.value : this.source,
      statut: data.statut.present ? data.statut.value : this.statut,
      metaCreateDate: data.metaCreateDate.present
          ? data.metaCreateDate.value
          : this.metaCreateDate,
      metaUpdateDate: data.metaUpdateDate.present
          ? data.metaUpdateDate.value
          : this.metaUpdateDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BibNomenclatureType(')
          ..write('idType: $idType, ')
          ..write('mnemonique: $mnemonique, ')
          ..write('labelDefault: $labelDefault, ')
          ..write('definitionDefault: $definitionDefault, ')
          ..write('labelFr: $labelFr, ')
          ..write('definitionFr: $definitionFr, ')
          ..write('labelEn: $labelEn, ')
          ..write('definitionEn: $definitionEn, ')
          ..write('labelEs: $labelEs, ')
          ..write('definitionEs: $definitionEs, ')
          ..write('labelDe: $labelDe, ')
          ..write('definitionDe: $definitionDe, ')
          ..write('labelIt: $labelIt, ')
          ..write('definitionIt: $definitionIt, ')
          ..write('source: $source, ')
          ..write('statut: $statut, ')
          ..write('metaCreateDate: $metaCreateDate, ')
          ..write('metaUpdateDate: $metaUpdateDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      idType,
      mnemonique,
      labelDefault,
      definitionDefault,
      labelFr,
      definitionFr,
      labelEn,
      definitionEn,
      labelEs,
      definitionEs,
      labelDe,
      definitionDe,
      labelIt,
      definitionIt,
      source,
      statut,
      metaCreateDate,
      metaUpdateDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BibNomenclatureType &&
          other.idType == this.idType &&
          other.mnemonique == this.mnemonique &&
          other.labelDefault == this.labelDefault &&
          other.definitionDefault == this.definitionDefault &&
          other.labelFr == this.labelFr &&
          other.definitionFr == this.definitionFr &&
          other.labelEn == this.labelEn &&
          other.definitionEn == this.definitionEn &&
          other.labelEs == this.labelEs &&
          other.definitionEs == this.definitionEs &&
          other.labelDe == this.labelDe &&
          other.definitionDe == this.definitionDe &&
          other.labelIt == this.labelIt &&
          other.definitionIt == this.definitionIt &&
          other.source == this.source &&
          other.statut == this.statut &&
          other.metaCreateDate == this.metaCreateDate &&
          other.metaUpdateDate == this.metaUpdateDate);
}

class BibNomenclaturesTypesTableCompanion
    extends UpdateCompanion<BibNomenclatureType> {
  final Value<int> idType;
  final Value<String?> mnemonique;
  final Value<String?> labelDefault;
  final Value<String?> definitionDefault;
  final Value<String?> labelFr;
  final Value<String?> definitionFr;
  final Value<String?> labelEn;
  final Value<String?> definitionEn;
  final Value<String?> labelEs;
  final Value<String?> definitionEs;
  final Value<String?> labelDe;
  final Value<String?> definitionDe;
  final Value<String?> labelIt;
  final Value<String?> definitionIt;
  final Value<String?> source;
  final Value<String?> statut;
  final Value<DateTime?> metaCreateDate;
  final Value<DateTime?> metaUpdateDate;
  const BibNomenclaturesTypesTableCompanion({
    this.idType = const Value.absent(),
    this.mnemonique = const Value.absent(),
    this.labelDefault = const Value.absent(),
    this.definitionDefault = const Value.absent(),
    this.labelFr = const Value.absent(),
    this.definitionFr = const Value.absent(),
    this.labelEn = const Value.absent(),
    this.definitionEn = const Value.absent(),
    this.labelEs = const Value.absent(),
    this.definitionEs = const Value.absent(),
    this.labelDe = const Value.absent(),
    this.definitionDe = const Value.absent(),
    this.labelIt = const Value.absent(),
    this.definitionIt = const Value.absent(),
    this.source = const Value.absent(),
    this.statut = const Value.absent(),
    this.metaCreateDate = const Value.absent(),
    this.metaUpdateDate = const Value.absent(),
  });
  BibNomenclaturesTypesTableCompanion.insert({
    this.idType = const Value.absent(),
    this.mnemonique = const Value.absent(),
    this.labelDefault = const Value.absent(),
    this.definitionDefault = const Value.absent(),
    this.labelFr = const Value.absent(),
    this.definitionFr = const Value.absent(),
    this.labelEn = const Value.absent(),
    this.definitionEn = const Value.absent(),
    this.labelEs = const Value.absent(),
    this.definitionEs = const Value.absent(),
    this.labelDe = const Value.absent(),
    this.definitionDe = const Value.absent(),
    this.labelIt = const Value.absent(),
    this.definitionIt = const Value.absent(),
    this.source = const Value.absent(),
    this.statut = const Value.absent(),
    this.metaCreateDate = const Value.absent(),
    this.metaUpdateDate = const Value.absent(),
  });
  static Insertable<BibNomenclatureType> custom({
    Expression<int>? idType,
    Expression<String>? mnemonique,
    Expression<String>? labelDefault,
    Expression<String>? definitionDefault,
    Expression<String>? labelFr,
    Expression<String>? definitionFr,
    Expression<String>? labelEn,
    Expression<String>? definitionEn,
    Expression<String>? labelEs,
    Expression<String>? definitionEs,
    Expression<String>? labelDe,
    Expression<String>? definitionDe,
    Expression<String>? labelIt,
    Expression<String>? definitionIt,
    Expression<String>? source,
    Expression<String>? statut,
    Expression<DateTime>? metaCreateDate,
    Expression<DateTime>? metaUpdateDate,
  }) {
    return RawValuesInsertable({
      if (idType != null) 'id_type': idType,
      if (mnemonique != null) 'mnemonique': mnemonique,
      if (labelDefault != null) 'label_default': labelDefault,
      if (definitionDefault != null) 'definition_default': definitionDefault,
      if (labelFr != null) 'label_fr': labelFr,
      if (definitionFr != null) 'definition_fr': definitionFr,
      if (labelEn != null) 'label_en': labelEn,
      if (definitionEn != null) 'definition_en': definitionEn,
      if (labelEs != null) 'label_es': labelEs,
      if (definitionEs != null) 'definition_es': definitionEs,
      if (labelDe != null) 'label_de': labelDe,
      if (definitionDe != null) 'definition_de': definitionDe,
      if (labelIt != null) 'label_it': labelIt,
      if (definitionIt != null) 'definition_it': definitionIt,
      if (source != null) 'source': source,
      if (statut != null) 'statut': statut,
      if (metaCreateDate != null) 'meta_create_date': metaCreateDate,
      if (metaUpdateDate != null) 'meta_update_date': metaUpdateDate,
    });
  }

  BibNomenclaturesTypesTableCompanion copyWith(
      {Value<int>? idType,
      Value<String?>? mnemonique,
      Value<String?>? labelDefault,
      Value<String?>? definitionDefault,
      Value<String?>? labelFr,
      Value<String?>? definitionFr,
      Value<String?>? labelEn,
      Value<String?>? definitionEn,
      Value<String?>? labelEs,
      Value<String?>? definitionEs,
      Value<String?>? labelDe,
      Value<String?>? definitionDe,
      Value<String?>? labelIt,
      Value<String?>? definitionIt,
      Value<String?>? source,
      Value<String?>? statut,
      Value<DateTime?>? metaCreateDate,
      Value<DateTime?>? metaUpdateDate}) {
    return BibNomenclaturesTypesTableCompanion(
      idType: idType ?? this.idType,
      mnemonique: mnemonique ?? this.mnemonique,
      labelDefault: labelDefault ?? this.labelDefault,
      definitionDefault: definitionDefault ?? this.definitionDefault,
      labelFr: labelFr ?? this.labelFr,
      definitionFr: definitionFr ?? this.definitionFr,
      labelEn: labelEn ?? this.labelEn,
      definitionEn: definitionEn ?? this.definitionEn,
      labelEs: labelEs ?? this.labelEs,
      definitionEs: definitionEs ?? this.definitionEs,
      labelDe: labelDe ?? this.labelDe,
      definitionDe: definitionDe ?? this.definitionDe,
      labelIt: labelIt ?? this.labelIt,
      definitionIt: definitionIt ?? this.definitionIt,
      source: source ?? this.source,
      statut: statut ?? this.statut,
      metaCreateDate: metaCreateDate ?? this.metaCreateDate,
      metaUpdateDate: metaUpdateDate ?? this.metaUpdateDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idType.present) {
      map['id_type'] = Variable<int>(idType.value);
    }
    if (mnemonique.present) {
      map['mnemonique'] = Variable<String>(mnemonique.value);
    }
    if (labelDefault.present) {
      map['label_default'] = Variable<String>(labelDefault.value);
    }
    if (definitionDefault.present) {
      map['definition_default'] = Variable<String>(definitionDefault.value);
    }
    if (labelFr.present) {
      map['label_fr'] = Variable<String>(labelFr.value);
    }
    if (definitionFr.present) {
      map['definition_fr'] = Variable<String>(definitionFr.value);
    }
    if (labelEn.present) {
      map['label_en'] = Variable<String>(labelEn.value);
    }
    if (definitionEn.present) {
      map['definition_en'] = Variable<String>(definitionEn.value);
    }
    if (labelEs.present) {
      map['label_es'] = Variable<String>(labelEs.value);
    }
    if (definitionEs.present) {
      map['definition_es'] = Variable<String>(definitionEs.value);
    }
    if (labelDe.present) {
      map['label_de'] = Variable<String>(labelDe.value);
    }
    if (definitionDe.present) {
      map['definition_de'] = Variable<String>(definitionDe.value);
    }
    if (labelIt.present) {
      map['label_it'] = Variable<String>(labelIt.value);
    }
    if (definitionIt.present) {
      map['definition_it'] = Variable<String>(definitionIt.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (statut.present) {
      map['statut'] = Variable<String>(statut.value);
    }
    if (metaCreateDate.present) {
      map['meta_create_date'] = Variable<DateTime>(metaCreateDate.value);
    }
    if (metaUpdateDate.present) {
      map['meta_update_date'] = Variable<DateTime>(metaUpdateDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BibNomenclaturesTypesTableCompanion(')
          ..write('idType: $idType, ')
          ..write('mnemonique: $mnemonique, ')
          ..write('labelDefault: $labelDefault, ')
          ..write('definitionDefault: $definitionDefault, ')
          ..write('labelFr: $labelFr, ')
          ..write('definitionFr: $definitionFr, ')
          ..write('labelEn: $labelEn, ')
          ..write('definitionEn: $definitionEn, ')
          ..write('labelEs: $labelEs, ')
          ..write('definitionEs: $definitionEs, ')
          ..write('labelDe: $labelDe, ')
          ..write('definitionDe: $definitionDe, ')
          ..write('labelIt: $labelIt, ')
          ..write('definitionIt: $definitionIt, ')
          ..write('source: $source, ')
          ..write('statut: $statut, ')
          ..write('metaCreateDate: $metaCreateDate, ')
          ..write('metaUpdateDate: $metaUpdateDate')
          ..write(')'))
        .toString();
  }
}

class $BibTypeSitesTableTable extends BibTypeSitesTable
    with TableInfo<$BibTypeSitesTableTable, BibTypeSite> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BibTypeSitesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idNomenclatureTypeSiteMeta =
      const VerificationMeta('idNomenclatureTypeSite');
  @override
  late final GeneratedColumn<int> idNomenclatureTypeSite = GeneratedColumn<int>(
      'id_nomenclature_type_site', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _configMeta = const VerificationMeta('config');
  @override
  late final GeneratedColumn<String> config = GeneratedColumn<String>(
      'config', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [idNomenclatureTypeSite, config];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bib_type_sites_table';
  @override
  VerificationContext validateIntegrity(Insertable<BibTypeSite> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_nomenclature_type_site')) {
      context.handle(
          _idNomenclatureTypeSiteMeta,
          idNomenclatureTypeSite.isAcceptableOrUnknown(
              data['id_nomenclature_type_site']!, _idNomenclatureTypeSiteMeta));
    }
    if (data.containsKey('config')) {
      context.handle(_configMeta,
          config.isAcceptableOrUnknown(data['config']!, _configMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idNomenclatureTypeSite};
  @override
  BibTypeSite map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BibTypeSite(
      idNomenclatureTypeSite: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}id_nomenclature_type_site'])!,
      config: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}config']),
    );
  }

  @override
  $BibTypeSitesTableTable createAlias(String alias) {
    return $BibTypeSitesTableTable(attachedDatabase, alias);
  }
}

class BibTypeSite extends DataClass implements Insertable<BibTypeSite> {
  final int idNomenclatureTypeSite;
  final String? config;
  const BibTypeSite({required this.idNomenclatureTypeSite, this.config});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_nomenclature_type_site'] = Variable<int>(idNomenclatureTypeSite);
    if (!nullToAbsent || config != null) {
      map['config'] = Variable<String>(config);
    }
    return map;
  }

  BibTypeSitesTableCompanion toCompanion(bool nullToAbsent) {
    return BibTypeSitesTableCompanion(
      idNomenclatureTypeSite: Value(idNomenclatureTypeSite),
      config:
          config == null && nullToAbsent ? const Value.absent() : Value(config),
    );
  }

  factory BibTypeSite.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BibTypeSite(
      idNomenclatureTypeSite:
          serializer.fromJson<int>(json['idNomenclatureTypeSite']),
      config: serializer.fromJson<String?>(json['config']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idNomenclatureTypeSite': serializer.toJson<int>(idNomenclatureTypeSite),
      'config': serializer.toJson<String?>(config),
    };
  }

  BibTypeSite copyWith(
          {int? idNomenclatureTypeSite,
          Value<String?> config = const Value.absent()}) =>
      BibTypeSite(
        idNomenclatureTypeSite:
            idNomenclatureTypeSite ?? this.idNomenclatureTypeSite,
        config: config.present ? config.value : this.config,
      );
  BibTypeSite copyWithCompanion(BibTypeSitesTableCompanion data) {
    return BibTypeSite(
      idNomenclatureTypeSite: data.idNomenclatureTypeSite.present
          ? data.idNomenclatureTypeSite.value
          : this.idNomenclatureTypeSite,
      config: data.config.present ? data.config.value : this.config,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BibTypeSite(')
          ..write('idNomenclatureTypeSite: $idNomenclatureTypeSite, ')
          ..write('config: $config')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(idNomenclatureTypeSite, config);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BibTypeSite &&
          other.idNomenclatureTypeSite == this.idNomenclatureTypeSite &&
          other.config == this.config);
}

class BibTypeSitesTableCompanion extends UpdateCompanion<BibTypeSite> {
  final Value<int> idNomenclatureTypeSite;
  final Value<String?> config;
  const BibTypeSitesTableCompanion({
    this.idNomenclatureTypeSite = const Value.absent(),
    this.config = const Value.absent(),
  });
  BibTypeSitesTableCompanion.insert({
    this.idNomenclatureTypeSite = const Value.absent(),
    this.config = const Value.absent(),
  });
  static Insertable<BibTypeSite> custom({
    Expression<int>? idNomenclatureTypeSite,
    Expression<String>? config,
  }) {
    return RawValuesInsertable({
      if (idNomenclatureTypeSite != null)
        'id_nomenclature_type_site': idNomenclatureTypeSite,
      if (config != null) 'config': config,
    });
  }

  BibTypeSitesTableCompanion copyWith(
      {Value<int>? idNomenclatureTypeSite, Value<String?>? config}) {
    return BibTypeSitesTableCompanion(
      idNomenclatureTypeSite:
          idNomenclatureTypeSite ?? this.idNomenclatureTypeSite,
      config: config ?? this.config,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idNomenclatureTypeSite.present) {
      map['id_nomenclature_type_site'] =
          Variable<int>(idNomenclatureTypeSite.value);
    }
    if (config.present) {
      map['config'] = Variable<String>(config.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BibTypeSitesTableCompanion(')
          ..write('idNomenclatureTypeSite: $idNomenclatureTypeSite, ')
          ..write('config: $config')
          ..write(')'))
        .toString();
  }
}

class $TObjectsTable extends TObjects with TableInfo<$TObjectsTable, TObject> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TObjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idObjectMeta =
      const VerificationMeta('idObject');
  @override
  late final GeneratedColumn<int> idObject = GeneratedColumn<int>(
      'id_object', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _codeObjectMeta =
      const VerificationMeta('codeObject');
  @override
  late final GeneratedColumn<String> codeObject = GeneratedColumn<String>(
      'code_object', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _descriptionObjectMeta =
      const VerificationMeta('descriptionObject');
  @override
  late final GeneratedColumn<String> descriptionObject =
      GeneratedColumn<String>('description_object', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [idObject, codeObject, descriptionObject];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 't_objects';
  @override
  VerificationContext validateIntegrity(Insertable<TObject> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_object')) {
      context.handle(_idObjectMeta,
          idObject.isAcceptableOrUnknown(data['id_object']!, _idObjectMeta));
    }
    if (data.containsKey('code_object')) {
      context.handle(
          _codeObjectMeta,
          codeObject.isAcceptableOrUnknown(
              data['code_object']!, _codeObjectMeta));
    } else if (isInserting) {
      context.missing(_codeObjectMeta);
    }
    if (data.containsKey('description_object')) {
      context.handle(
          _descriptionObjectMeta,
          descriptionObject.isAcceptableOrUnknown(
              data['description_object']!, _descriptionObjectMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idObject};
  @override
  TObject map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TObject(
      idObject: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_object'])!,
      codeObject: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code_object'])!,
      descriptionObject: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}description_object']),
    );
  }

  @override
  $TObjectsTable createAlias(String alias) {
    return $TObjectsTable(attachedDatabase, alias);
  }
}

class TObject extends DataClass implements Insertable<TObject> {
  final int idObject;
  final String codeObject;
  final String? descriptionObject;
  const TObject(
      {required this.idObject,
      required this.codeObject,
      this.descriptionObject});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_object'] = Variable<int>(idObject);
    map['code_object'] = Variable<String>(codeObject);
    if (!nullToAbsent || descriptionObject != null) {
      map['description_object'] = Variable<String>(descriptionObject);
    }
    return map;
  }

  TObjectsCompanion toCompanion(bool nullToAbsent) {
    return TObjectsCompanion(
      idObject: Value(idObject),
      codeObject: Value(codeObject),
      descriptionObject: descriptionObject == null && nullToAbsent
          ? const Value.absent()
          : Value(descriptionObject),
    );
  }

  factory TObject.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TObject(
      idObject: serializer.fromJson<int>(json['idObject']),
      codeObject: serializer.fromJson<String>(json['codeObject']),
      descriptionObject:
          serializer.fromJson<String?>(json['descriptionObject']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idObject': serializer.toJson<int>(idObject),
      'codeObject': serializer.toJson<String>(codeObject),
      'descriptionObject': serializer.toJson<String?>(descriptionObject),
    };
  }

  TObject copyWith(
          {int? idObject,
          String? codeObject,
          Value<String?> descriptionObject = const Value.absent()}) =>
      TObject(
        idObject: idObject ?? this.idObject,
        codeObject: codeObject ?? this.codeObject,
        descriptionObject: descriptionObject.present
            ? descriptionObject.value
            : this.descriptionObject,
      );
  TObject copyWithCompanion(TObjectsCompanion data) {
    return TObject(
      idObject: data.idObject.present ? data.idObject.value : this.idObject,
      codeObject:
          data.codeObject.present ? data.codeObject.value : this.codeObject,
      descriptionObject: data.descriptionObject.present
          ? data.descriptionObject.value
          : this.descriptionObject,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TObject(')
          ..write('idObject: $idObject, ')
          ..write('codeObject: $codeObject, ')
          ..write('descriptionObject: $descriptionObject')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(idObject, codeObject, descriptionObject);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TObject &&
          other.idObject == this.idObject &&
          other.codeObject == this.codeObject &&
          other.descriptionObject == this.descriptionObject);
}

class TObjectsCompanion extends UpdateCompanion<TObject> {
  final Value<int> idObject;
  final Value<String> codeObject;
  final Value<String?> descriptionObject;
  const TObjectsCompanion({
    this.idObject = const Value.absent(),
    this.codeObject = const Value.absent(),
    this.descriptionObject = const Value.absent(),
  });
  TObjectsCompanion.insert({
    this.idObject = const Value.absent(),
    required String codeObject,
    this.descriptionObject = const Value.absent(),
  }) : codeObject = Value(codeObject);
  static Insertable<TObject> custom({
    Expression<int>? idObject,
    Expression<String>? codeObject,
    Expression<String>? descriptionObject,
  }) {
    return RawValuesInsertable({
      if (idObject != null) 'id_object': idObject,
      if (codeObject != null) 'code_object': codeObject,
      if (descriptionObject != null) 'description_object': descriptionObject,
    });
  }

  TObjectsCompanion copyWith(
      {Value<int>? idObject,
      Value<String>? codeObject,
      Value<String?>? descriptionObject}) {
    return TObjectsCompanion(
      idObject: idObject ?? this.idObject,
      codeObject: codeObject ?? this.codeObject,
      descriptionObject: descriptionObject ?? this.descriptionObject,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idObject.present) {
      map['id_object'] = Variable<int>(idObject.value);
    }
    if (codeObject.present) {
      map['code_object'] = Variable<String>(codeObject.value);
    }
    if (descriptionObject.present) {
      map['description_object'] = Variable<String>(descriptionObject.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TObjectsCompanion(')
          ..write('idObject: $idObject, ')
          ..write('codeObject: $codeObject, ')
          ..write('descriptionObject: $descriptionObject')
          ..write(')'))
        .toString();
  }
}

class $TActionsTable extends TActions with TableInfo<$TActionsTable, TAction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TActionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idActionMeta =
      const VerificationMeta('idAction');
  @override
  late final GeneratedColumn<int> idAction = GeneratedColumn<int>(
      'id_action', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _codeActionMeta =
      const VerificationMeta('codeAction');
  @override
  late final GeneratedColumn<String> codeAction = GeneratedColumn<String>(
      'code_action', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionActionMeta =
      const VerificationMeta('descriptionAction');
  @override
  late final GeneratedColumn<String> descriptionAction =
      GeneratedColumn<String>('description_action', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [idAction, codeAction, descriptionAction];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 't_actions';
  @override
  VerificationContext validateIntegrity(Insertable<TAction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_action')) {
      context.handle(_idActionMeta,
          idAction.isAcceptableOrUnknown(data['id_action']!, _idActionMeta));
    }
    if (data.containsKey('code_action')) {
      context.handle(
          _codeActionMeta,
          codeAction.isAcceptableOrUnknown(
              data['code_action']!, _codeActionMeta));
    }
    if (data.containsKey('description_action')) {
      context.handle(
          _descriptionActionMeta,
          descriptionAction.isAcceptableOrUnknown(
              data['description_action']!, _descriptionActionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idAction};
  @override
  TAction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TAction(
      idAction: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_action'])!,
      codeAction: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code_action']),
      descriptionAction: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}description_action']),
    );
  }

  @override
  $TActionsTable createAlias(String alias) {
    return $TActionsTable(attachedDatabase, alias);
  }
}

class TAction extends DataClass implements Insertable<TAction> {
  final int idAction;
  final String? codeAction;
  final String? descriptionAction;
  const TAction(
      {required this.idAction, this.codeAction, this.descriptionAction});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_action'] = Variable<int>(idAction);
    if (!nullToAbsent || codeAction != null) {
      map['code_action'] = Variable<String>(codeAction);
    }
    if (!nullToAbsent || descriptionAction != null) {
      map['description_action'] = Variable<String>(descriptionAction);
    }
    return map;
  }

  TActionsCompanion toCompanion(bool nullToAbsent) {
    return TActionsCompanion(
      idAction: Value(idAction),
      codeAction: codeAction == null && nullToAbsent
          ? const Value.absent()
          : Value(codeAction),
      descriptionAction: descriptionAction == null && nullToAbsent
          ? const Value.absent()
          : Value(descriptionAction),
    );
  }

  factory TAction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TAction(
      idAction: serializer.fromJson<int>(json['idAction']),
      codeAction: serializer.fromJson<String?>(json['codeAction']),
      descriptionAction:
          serializer.fromJson<String?>(json['descriptionAction']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idAction': serializer.toJson<int>(idAction),
      'codeAction': serializer.toJson<String?>(codeAction),
      'descriptionAction': serializer.toJson<String?>(descriptionAction),
    };
  }

  TAction copyWith(
          {int? idAction,
          Value<String?> codeAction = const Value.absent(),
          Value<String?> descriptionAction = const Value.absent()}) =>
      TAction(
        idAction: idAction ?? this.idAction,
        codeAction: codeAction.present ? codeAction.value : this.codeAction,
        descriptionAction: descriptionAction.present
            ? descriptionAction.value
            : this.descriptionAction,
      );
  TAction copyWithCompanion(TActionsCompanion data) {
    return TAction(
      idAction: data.idAction.present ? data.idAction.value : this.idAction,
      codeAction:
          data.codeAction.present ? data.codeAction.value : this.codeAction,
      descriptionAction: data.descriptionAction.present
          ? data.descriptionAction.value
          : this.descriptionAction,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TAction(')
          ..write('idAction: $idAction, ')
          ..write('codeAction: $codeAction, ')
          ..write('descriptionAction: $descriptionAction')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(idAction, codeAction, descriptionAction);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TAction &&
          other.idAction == this.idAction &&
          other.codeAction == this.codeAction &&
          other.descriptionAction == this.descriptionAction);
}

class TActionsCompanion extends UpdateCompanion<TAction> {
  final Value<int> idAction;
  final Value<String?> codeAction;
  final Value<String?> descriptionAction;
  const TActionsCompanion({
    this.idAction = const Value.absent(),
    this.codeAction = const Value.absent(),
    this.descriptionAction = const Value.absent(),
  });
  TActionsCompanion.insert({
    this.idAction = const Value.absent(),
    this.codeAction = const Value.absent(),
    this.descriptionAction = const Value.absent(),
  });
  static Insertable<TAction> custom({
    Expression<int>? idAction,
    Expression<String>? codeAction,
    Expression<String>? descriptionAction,
  }) {
    return RawValuesInsertable({
      if (idAction != null) 'id_action': idAction,
      if (codeAction != null) 'code_action': codeAction,
      if (descriptionAction != null) 'description_action': descriptionAction,
    });
  }

  TActionsCompanion copyWith(
      {Value<int>? idAction,
      Value<String?>? codeAction,
      Value<String?>? descriptionAction}) {
    return TActionsCompanion(
      idAction: idAction ?? this.idAction,
      codeAction: codeAction ?? this.codeAction,
      descriptionAction: descriptionAction ?? this.descriptionAction,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idAction.present) {
      map['id_action'] = Variable<int>(idAction.value);
    }
    if (codeAction.present) {
      map['code_action'] = Variable<String>(codeAction.value);
    }
    if (descriptionAction.present) {
      map['description_action'] = Variable<String>(descriptionAction.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TActionsCompanion(')
          ..write('idAction: $idAction, ')
          ..write('codeAction: $codeAction, ')
          ..write('descriptionAction: $descriptionAction')
          ..write(')'))
        .toString();
  }
}

class $TPermissionsAvailableTable extends TPermissionsAvailable
    with TableInfo<$TPermissionsAvailableTable, TPermissionAvailable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TPermissionsAvailableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idModuleMeta =
      const VerificationMeta('idModule');
  @override
  late final GeneratedColumn<int> idModule = GeneratedColumn<int>(
      'id_module', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _idObjectMeta =
      const VerificationMeta('idObject');
  @override
  late final GeneratedColumn<int> idObject = GeneratedColumn<int>(
      'id_object', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _idActionMeta =
      const VerificationMeta('idAction');
  @override
  late final GeneratedColumn<int> idAction = GeneratedColumn<int>(
      'id_action', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _scopeFilterMeta =
      const VerificationMeta('scopeFilter');
  @override
  late final GeneratedColumn<bool> scopeFilter = GeneratedColumn<bool>(
      'scope_filter', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("scope_filter" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _sensitivityFilterMeta =
      const VerificationMeta('sensitivityFilter');
  @override
  late final GeneratedColumn<bool> sensitivityFilter = GeneratedColumn<bool>(
      'sensitivity_filter', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("sensitivity_filter" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [idModule, idObject, idAction, label, scopeFilter, sensitivityFilter];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 't_permissions_available';
  @override
  VerificationContext validateIntegrity(
      Insertable<TPermissionAvailable> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_module')) {
      context.handle(_idModuleMeta,
          idModule.isAcceptableOrUnknown(data['id_module']!, _idModuleMeta));
    } else if (isInserting) {
      context.missing(_idModuleMeta);
    }
    if (data.containsKey('id_object')) {
      context.handle(_idObjectMeta,
          idObject.isAcceptableOrUnknown(data['id_object']!, _idObjectMeta));
    } else if (isInserting) {
      context.missing(_idObjectMeta);
    }
    if (data.containsKey('id_action')) {
      context.handle(_idActionMeta,
          idAction.isAcceptableOrUnknown(data['id_action']!, _idActionMeta));
    } else if (isInserting) {
      context.missing(_idActionMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    }
    if (data.containsKey('scope_filter')) {
      context.handle(
          _scopeFilterMeta,
          scopeFilter.isAcceptableOrUnknown(
              data['scope_filter']!, _scopeFilterMeta));
    }
    if (data.containsKey('sensitivity_filter')) {
      context.handle(
          _sensitivityFilterMeta,
          sensitivityFilter.isAcceptableOrUnknown(
              data['sensitivity_filter']!, _sensitivityFilterMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idModule, idObject, idAction};
  @override
  TPermissionAvailable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TPermissionAvailable(
      idModule: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_module'])!,
      idObject: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_object'])!,
      idAction: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_action'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label']),
      scopeFilter: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}scope_filter'])!,
      sensitivityFilter: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}sensitivity_filter'])!,
    );
  }

  @override
  $TPermissionsAvailableTable createAlias(String alias) {
    return $TPermissionsAvailableTable(attachedDatabase, alias);
  }
}

class TPermissionAvailable extends DataClass
    implements Insertable<TPermissionAvailable> {
  final int idModule;
  final int idObject;
  final int idAction;
  final String? label;
  final bool scopeFilter;
  final bool sensitivityFilter;
  const TPermissionAvailable(
      {required this.idModule,
      required this.idObject,
      required this.idAction,
      this.label,
      required this.scopeFilter,
      required this.sensitivityFilter});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_module'] = Variable<int>(idModule);
    map['id_object'] = Variable<int>(idObject);
    map['id_action'] = Variable<int>(idAction);
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    map['scope_filter'] = Variable<bool>(scopeFilter);
    map['sensitivity_filter'] = Variable<bool>(sensitivityFilter);
    return map;
  }

  TPermissionsAvailableCompanion toCompanion(bool nullToAbsent) {
    return TPermissionsAvailableCompanion(
      idModule: Value(idModule),
      idObject: Value(idObject),
      idAction: Value(idAction),
      label:
          label == null && nullToAbsent ? const Value.absent() : Value(label),
      scopeFilter: Value(scopeFilter),
      sensitivityFilter: Value(sensitivityFilter),
    );
  }

  factory TPermissionAvailable.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TPermissionAvailable(
      idModule: serializer.fromJson<int>(json['idModule']),
      idObject: serializer.fromJson<int>(json['idObject']),
      idAction: serializer.fromJson<int>(json['idAction']),
      label: serializer.fromJson<String?>(json['label']),
      scopeFilter: serializer.fromJson<bool>(json['scopeFilter']),
      sensitivityFilter: serializer.fromJson<bool>(json['sensitivityFilter']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idModule': serializer.toJson<int>(idModule),
      'idObject': serializer.toJson<int>(idObject),
      'idAction': serializer.toJson<int>(idAction),
      'label': serializer.toJson<String?>(label),
      'scopeFilter': serializer.toJson<bool>(scopeFilter),
      'sensitivityFilter': serializer.toJson<bool>(sensitivityFilter),
    };
  }

  TPermissionAvailable copyWith(
          {int? idModule,
          int? idObject,
          int? idAction,
          Value<String?> label = const Value.absent(),
          bool? scopeFilter,
          bool? sensitivityFilter}) =>
      TPermissionAvailable(
        idModule: idModule ?? this.idModule,
        idObject: idObject ?? this.idObject,
        idAction: idAction ?? this.idAction,
        label: label.present ? label.value : this.label,
        scopeFilter: scopeFilter ?? this.scopeFilter,
        sensitivityFilter: sensitivityFilter ?? this.sensitivityFilter,
      );
  TPermissionAvailable copyWithCompanion(TPermissionsAvailableCompanion data) {
    return TPermissionAvailable(
      idModule: data.idModule.present ? data.idModule.value : this.idModule,
      idObject: data.idObject.present ? data.idObject.value : this.idObject,
      idAction: data.idAction.present ? data.idAction.value : this.idAction,
      label: data.label.present ? data.label.value : this.label,
      scopeFilter:
          data.scopeFilter.present ? data.scopeFilter.value : this.scopeFilter,
      sensitivityFilter: data.sensitivityFilter.present
          ? data.sensitivityFilter.value
          : this.sensitivityFilter,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TPermissionAvailable(')
          ..write('idModule: $idModule, ')
          ..write('idObject: $idObject, ')
          ..write('idAction: $idAction, ')
          ..write('label: $label, ')
          ..write('scopeFilter: $scopeFilter, ')
          ..write('sensitivityFilter: $sensitivityFilter')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      idModule, idObject, idAction, label, scopeFilter, sensitivityFilter);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TPermissionAvailable &&
          other.idModule == this.idModule &&
          other.idObject == this.idObject &&
          other.idAction == this.idAction &&
          other.label == this.label &&
          other.scopeFilter == this.scopeFilter &&
          other.sensitivityFilter == this.sensitivityFilter);
}

class TPermissionsAvailableCompanion
    extends UpdateCompanion<TPermissionAvailable> {
  final Value<int> idModule;
  final Value<int> idObject;
  final Value<int> idAction;
  final Value<String?> label;
  final Value<bool> scopeFilter;
  final Value<bool> sensitivityFilter;
  final Value<int> rowid;
  const TPermissionsAvailableCompanion({
    this.idModule = const Value.absent(),
    this.idObject = const Value.absent(),
    this.idAction = const Value.absent(),
    this.label = const Value.absent(),
    this.scopeFilter = const Value.absent(),
    this.sensitivityFilter = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TPermissionsAvailableCompanion.insert({
    required int idModule,
    required int idObject,
    required int idAction,
    this.label = const Value.absent(),
    this.scopeFilter = const Value.absent(),
    this.sensitivityFilter = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : idModule = Value(idModule),
        idObject = Value(idObject),
        idAction = Value(idAction);
  static Insertable<TPermissionAvailable> custom({
    Expression<int>? idModule,
    Expression<int>? idObject,
    Expression<int>? idAction,
    Expression<String>? label,
    Expression<bool>? scopeFilter,
    Expression<bool>? sensitivityFilter,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (idModule != null) 'id_module': idModule,
      if (idObject != null) 'id_object': idObject,
      if (idAction != null) 'id_action': idAction,
      if (label != null) 'label': label,
      if (scopeFilter != null) 'scope_filter': scopeFilter,
      if (sensitivityFilter != null) 'sensitivity_filter': sensitivityFilter,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TPermissionsAvailableCompanion copyWith(
      {Value<int>? idModule,
      Value<int>? idObject,
      Value<int>? idAction,
      Value<String?>? label,
      Value<bool>? scopeFilter,
      Value<bool>? sensitivityFilter,
      Value<int>? rowid}) {
    return TPermissionsAvailableCompanion(
      idModule: idModule ?? this.idModule,
      idObject: idObject ?? this.idObject,
      idAction: idAction ?? this.idAction,
      label: label ?? this.label,
      scopeFilter: scopeFilter ?? this.scopeFilter,
      sensitivityFilter: sensitivityFilter ?? this.sensitivityFilter,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idModule.present) {
      map['id_module'] = Variable<int>(idModule.value);
    }
    if (idObject.present) {
      map['id_object'] = Variable<int>(idObject.value);
    }
    if (idAction.present) {
      map['id_action'] = Variable<int>(idAction.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (scopeFilter.present) {
      map['scope_filter'] = Variable<bool>(scopeFilter.value);
    }
    if (sensitivityFilter.present) {
      map['sensitivity_filter'] = Variable<bool>(sensitivityFilter.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TPermissionsAvailableCompanion(')
          ..write('idModule: $idModule, ')
          ..write('idObject: $idObject, ')
          ..write('idAction: $idAction, ')
          ..write('label: $label, ')
          ..write('scopeFilter: $scopeFilter, ')
          ..write('sensitivityFilter: $sensitivityFilter, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TPermissionsTable extends TPermissions
    with TableInfo<$TPermissionsTable, TPermission> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TPermissionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idPermissionMeta =
      const VerificationMeta('idPermission');
  @override
  late final GeneratedColumn<int> idPermission = GeneratedColumn<int>(
      'id_permission', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _idRoleMeta = const VerificationMeta('idRole');
  @override
  late final GeneratedColumn<int> idRole = GeneratedColumn<int>(
      'id_role', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _idActionMeta =
      const VerificationMeta('idAction');
  @override
  late final GeneratedColumn<int> idAction = GeneratedColumn<int>(
      'id_action', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _idModuleMeta =
      const VerificationMeta('idModule');
  @override
  late final GeneratedColumn<int> idModule = GeneratedColumn<int>(
      'id_module', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _idObjectMeta =
      const VerificationMeta('idObject');
  @override
  late final GeneratedColumn<int> idObject = GeneratedColumn<int>(
      'id_object', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _scopeValueMeta =
      const VerificationMeta('scopeValue');
  @override
  late final GeneratedColumn<int> scopeValue = GeneratedColumn<int>(
      'scope_value', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _sensitivityFilterMeta =
      const VerificationMeta('sensitivityFilter');
  @override
  late final GeneratedColumn<bool> sensitivityFilter = GeneratedColumn<bool>(
      'sensitivity_filter', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("sensitivity_filter" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        idPermission,
        idRole,
        idAction,
        idModule,
        idObject,
        scopeValue,
        sensitivityFilter
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 't_permissions';
  @override
  VerificationContext validateIntegrity(Insertable<TPermission> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_permission')) {
      context.handle(
          _idPermissionMeta,
          idPermission.isAcceptableOrUnknown(
              data['id_permission']!, _idPermissionMeta));
    }
    if (data.containsKey('id_role')) {
      context.handle(_idRoleMeta,
          idRole.isAcceptableOrUnknown(data['id_role']!, _idRoleMeta));
    } else if (isInserting) {
      context.missing(_idRoleMeta);
    }
    if (data.containsKey('id_action')) {
      context.handle(_idActionMeta,
          idAction.isAcceptableOrUnknown(data['id_action']!, _idActionMeta));
    } else if (isInserting) {
      context.missing(_idActionMeta);
    }
    if (data.containsKey('id_module')) {
      context.handle(_idModuleMeta,
          idModule.isAcceptableOrUnknown(data['id_module']!, _idModuleMeta));
    } else if (isInserting) {
      context.missing(_idModuleMeta);
    }
    if (data.containsKey('id_object')) {
      context.handle(_idObjectMeta,
          idObject.isAcceptableOrUnknown(data['id_object']!, _idObjectMeta));
    } else if (isInserting) {
      context.missing(_idObjectMeta);
    }
    if (data.containsKey('scope_value')) {
      context.handle(
          _scopeValueMeta,
          scopeValue.isAcceptableOrUnknown(
              data['scope_value']!, _scopeValueMeta));
    }
    if (data.containsKey('sensitivity_filter')) {
      context.handle(
          _sensitivityFilterMeta,
          sensitivityFilter.isAcceptableOrUnknown(
              data['sensitivity_filter']!, _sensitivityFilterMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idPermission};
  @override
  TPermission map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TPermission(
      idPermission: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_permission'])!,
      idRole: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_role'])!,
      idAction: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_action'])!,
      idModule: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_module'])!,
      idObject: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_object'])!,
      scopeValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}scope_value']),
      sensitivityFilter: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}sensitivity_filter'])!,
    );
  }

  @override
  $TPermissionsTable createAlias(String alias) {
    return $TPermissionsTable(attachedDatabase, alias);
  }
}

class TPermission extends DataClass implements Insertable<TPermission> {
  final int idPermission;
  final int idRole;
  final int idAction;
  final int idModule;
  final int idObject;
  final int? scopeValue;
  final bool sensitivityFilter;
  const TPermission(
      {required this.idPermission,
      required this.idRole,
      required this.idAction,
      required this.idModule,
      required this.idObject,
      this.scopeValue,
      required this.sensitivityFilter});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_permission'] = Variable<int>(idPermission);
    map['id_role'] = Variable<int>(idRole);
    map['id_action'] = Variable<int>(idAction);
    map['id_module'] = Variable<int>(idModule);
    map['id_object'] = Variable<int>(idObject);
    if (!nullToAbsent || scopeValue != null) {
      map['scope_value'] = Variable<int>(scopeValue);
    }
    map['sensitivity_filter'] = Variable<bool>(sensitivityFilter);
    return map;
  }

  TPermissionsCompanion toCompanion(bool nullToAbsent) {
    return TPermissionsCompanion(
      idPermission: Value(idPermission),
      idRole: Value(idRole),
      idAction: Value(idAction),
      idModule: Value(idModule),
      idObject: Value(idObject),
      scopeValue: scopeValue == null && nullToAbsent
          ? const Value.absent()
          : Value(scopeValue),
      sensitivityFilter: Value(sensitivityFilter),
    );
  }

  factory TPermission.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TPermission(
      idPermission: serializer.fromJson<int>(json['idPermission']),
      idRole: serializer.fromJson<int>(json['idRole']),
      idAction: serializer.fromJson<int>(json['idAction']),
      idModule: serializer.fromJson<int>(json['idModule']),
      idObject: serializer.fromJson<int>(json['idObject']),
      scopeValue: serializer.fromJson<int?>(json['scopeValue']),
      sensitivityFilter: serializer.fromJson<bool>(json['sensitivityFilter']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idPermission': serializer.toJson<int>(idPermission),
      'idRole': serializer.toJson<int>(idRole),
      'idAction': serializer.toJson<int>(idAction),
      'idModule': serializer.toJson<int>(idModule),
      'idObject': serializer.toJson<int>(idObject),
      'scopeValue': serializer.toJson<int?>(scopeValue),
      'sensitivityFilter': serializer.toJson<bool>(sensitivityFilter),
    };
  }

  TPermission copyWith(
          {int? idPermission,
          int? idRole,
          int? idAction,
          int? idModule,
          int? idObject,
          Value<int?> scopeValue = const Value.absent(),
          bool? sensitivityFilter}) =>
      TPermission(
        idPermission: idPermission ?? this.idPermission,
        idRole: idRole ?? this.idRole,
        idAction: idAction ?? this.idAction,
        idModule: idModule ?? this.idModule,
        idObject: idObject ?? this.idObject,
        scopeValue: scopeValue.present ? scopeValue.value : this.scopeValue,
        sensitivityFilter: sensitivityFilter ?? this.sensitivityFilter,
      );
  TPermission copyWithCompanion(TPermissionsCompanion data) {
    return TPermission(
      idPermission: data.idPermission.present
          ? data.idPermission.value
          : this.idPermission,
      idRole: data.idRole.present ? data.idRole.value : this.idRole,
      idAction: data.idAction.present ? data.idAction.value : this.idAction,
      idModule: data.idModule.present ? data.idModule.value : this.idModule,
      idObject: data.idObject.present ? data.idObject.value : this.idObject,
      scopeValue:
          data.scopeValue.present ? data.scopeValue.value : this.scopeValue,
      sensitivityFilter: data.sensitivityFilter.present
          ? data.sensitivityFilter.value
          : this.sensitivityFilter,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TPermission(')
          ..write('idPermission: $idPermission, ')
          ..write('idRole: $idRole, ')
          ..write('idAction: $idAction, ')
          ..write('idModule: $idModule, ')
          ..write('idObject: $idObject, ')
          ..write('scopeValue: $scopeValue, ')
          ..write('sensitivityFilter: $sensitivityFilter')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(idPermission, idRole, idAction, idModule,
      idObject, scopeValue, sensitivityFilter);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TPermission &&
          other.idPermission == this.idPermission &&
          other.idRole == this.idRole &&
          other.idAction == this.idAction &&
          other.idModule == this.idModule &&
          other.idObject == this.idObject &&
          other.scopeValue == this.scopeValue &&
          other.sensitivityFilter == this.sensitivityFilter);
}

class TPermissionsCompanion extends UpdateCompanion<TPermission> {
  final Value<int> idPermission;
  final Value<int> idRole;
  final Value<int> idAction;
  final Value<int> idModule;
  final Value<int> idObject;
  final Value<int?> scopeValue;
  final Value<bool> sensitivityFilter;
  const TPermissionsCompanion({
    this.idPermission = const Value.absent(),
    this.idRole = const Value.absent(),
    this.idAction = const Value.absent(),
    this.idModule = const Value.absent(),
    this.idObject = const Value.absent(),
    this.scopeValue = const Value.absent(),
    this.sensitivityFilter = const Value.absent(),
  });
  TPermissionsCompanion.insert({
    this.idPermission = const Value.absent(),
    required int idRole,
    required int idAction,
    required int idModule,
    required int idObject,
    this.scopeValue = const Value.absent(),
    this.sensitivityFilter = const Value.absent(),
  })  : idRole = Value(idRole),
        idAction = Value(idAction),
        idModule = Value(idModule),
        idObject = Value(idObject);
  static Insertable<TPermission> custom({
    Expression<int>? idPermission,
    Expression<int>? idRole,
    Expression<int>? idAction,
    Expression<int>? idModule,
    Expression<int>? idObject,
    Expression<int>? scopeValue,
    Expression<bool>? sensitivityFilter,
  }) {
    return RawValuesInsertable({
      if (idPermission != null) 'id_permission': idPermission,
      if (idRole != null) 'id_role': idRole,
      if (idAction != null) 'id_action': idAction,
      if (idModule != null) 'id_module': idModule,
      if (idObject != null) 'id_object': idObject,
      if (scopeValue != null) 'scope_value': scopeValue,
      if (sensitivityFilter != null) 'sensitivity_filter': sensitivityFilter,
    });
  }

  TPermissionsCompanion copyWith(
      {Value<int>? idPermission,
      Value<int>? idRole,
      Value<int>? idAction,
      Value<int>? idModule,
      Value<int>? idObject,
      Value<int?>? scopeValue,
      Value<bool>? sensitivityFilter}) {
    return TPermissionsCompanion(
      idPermission: idPermission ?? this.idPermission,
      idRole: idRole ?? this.idRole,
      idAction: idAction ?? this.idAction,
      idModule: idModule ?? this.idModule,
      idObject: idObject ?? this.idObject,
      scopeValue: scopeValue ?? this.scopeValue,
      sensitivityFilter: sensitivityFilter ?? this.sensitivityFilter,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idPermission.present) {
      map['id_permission'] = Variable<int>(idPermission.value);
    }
    if (idRole.present) {
      map['id_role'] = Variable<int>(idRole.value);
    }
    if (idAction.present) {
      map['id_action'] = Variable<int>(idAction.value);
    }
    if (idModule.present) {
      map['id_module'] = Variable<int>(idModule.value);
    }
    if (idObject.present) {
      map['id_object'] = Variable<int>(idObject.value);
    }
    if (scopeValue.present) {
      map['scope_value'] = Variable<int>(scopeValue.value);
    }
    if (sensitivityFilter.present) {
      map['sensitivity_filter'] = Variable<bool>(sensitivityFilter.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TPermissionsCompanion(')
          ..write('idPermission: $idPermission, ')
          ..write('idRole: $idRole, ')
          ..write('idAction: $idAction, ')
          ..write('idModule: $idModule, ')
          ..write('idObject: $idObject, ')
          ..write('scopeValue: $scopeValue, ')
          ..write('sensitivityFilter: $sensitivityFilter')
          ..write(')'))
        .toString();
  }
}

class $CorSiteModuleTableTable extends CorSiteModuleTable
    with TableInfo<$CorSiteModuleTableTable, CorSiteModule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CorSiteModuleTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idBaseSiteMeta =
      const VerificationMeta('idBaseSite');
  @override
  late final GeneratedColumn<int> idBaseSite = GeneratedColumn<int>(
      'id_base_site', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _idModuleMeta =
      const VerificationMeta('idModule');
  @override
  late final GeneratedColumn<int> idModule = GeneratedColumn<int>(
      'id_module', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [idBaseSite, idModule];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cor_site_module_table';
  @override
  VerificationContext validateIntegrity(Insertable<CorSiteModule> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_base_site')) {
      context.handle(
          _idBaseSiteMeta,
          idBaseSite.isAcceptableOrUnknown(
              data['id_base_site']!, _idBaseSiteMeta));
    } else if (isInserting) {
      context.missing(_idBaseSiteMeta);
    }
    if (data.containsKey('id_module')) {
      context.handle(_idModuleMeta,
          idModule.isAcceptableOrUnknown(data['id_module']!, _idModuleMeta));
    } else if (isInserting) {
      context.missing(_idModuleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idBaseSite, idModule};
  @override
  CorSiteModule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CorSiteModule(
      idBaseSite: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_base_site'])!,
      idModule: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_module'])!,
    );
  }

  @override
  $CorSiteModuleTableTable createAlias(String alias) {
    return $CorSiteModuleTableTable(attachedDatabase, alias);
  }
}

class CorSiteModule extends DataClass implements Insertable<CorSiteModule> {
  final int idBaseSite;
  final int idModule;
  const CorSiteModule({required this.idBaseSite, required this.idModule});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_base_site'] = Variable<int>(idBaseSite);
    map['id_module'] = Variable<int>(idModule);
    return map;
  }

  CorSiteModuleTableCompanion toCompanion(bool nullToAbsent) {
    return CorSiteModuleTableCompanion(
      idBaseSite: Value(idBaseSite),
      idModule: Value(idModule),
    );
  }

  factory CorSiteModule.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CorSiteModule(
      idBaseSite: serializer.fromJson<int>(json['idBaseSite']),
      idModule: serializer.fromJson<int>(json['idModule']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idBaseSite': serializer.toJson<int>(idBaseSite),
      'idModule': serializer.toJson<int>(idModule),
    };
  }

  CorSiteModule copyWith({int? idBaseSite, int? idModule}) => CorSiteModule(
        idBaseSite: idBaseSite ?? this.idBaseSite,
        idModule: idModule ?? this.idModule,
      );
  CorSiteModule copyWithCompanion(CorSiteModuleTableCompanion data) {
    return CorSiteModule(
      idBaseSite:
          data.idBaseSite.present ? data.idBaseSite.value : this.idBaseSite,
      idModule: data.idModule.present ? data.idModule.value : this.idModule,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CorSiteModule(')
          ..write('idBaseSite: $idBaseSite, ')
          ..write('idModule: $idModule')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(idBaseSite, idModule);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CorSiteModule &&
          other.idBaseSite == this.idBaseSite &&
          other.idModule == this.idModule);
}

class CorSiteModuleTableCompanion extends UpdateCompanion<CorSiteModule> {
  final Value<int> idBaseSite;
  final Value<int> idModule;
  final Value<int> rowid;
  const CorSiteModuleTableCompanion({
    this.idBaseSite = const Value.absent(),
    this.idModule = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CorSiteModuleTableCompanion.insert({
    required int idBaseSite,
    required int idModule,
    this.rowid = const Value.absent(),
  })  : idBaseSite = Value(idBaseSite),
        idModule = Value(idModule);
  static Insertable<CorSiteModule> custom({
    Expression<int>? idBaseSite,
    Expression<int>? idModule,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (idBaseSite != null) 'id_base_site': idBaseSite,
      if (idModule != null) 'id_module': idModule,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CorSiteModuleTableCompanion copyWith(
      {Value<int>? idBaseSite, Value<int>? idModule, Value<int>? rowid}) {
    return CorSiteModuleTableCompanion(
      idBaseSite: idBaseSite ?? this.idBaseSite,
      idModule: idModule ?? this.idModule,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idBaseSite.present) {
      map['id_base_site'] = Variable<int>(idBaseSite.value);
    }
    if (idModule.present) {
      map['id_module'] = Variable<int>(idModule.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CorSiteModuleTableCompanion(')
          ..write('idBaseSite: $idBaseSite, ')
          ..write('idModule: $idModule, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CorSitesGroupModuleTableTable extends CorSitesGroupModuleTable
    with TableInfo<$CorSitesGroupModuleTableTable, CorSitesGroupModule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CorSitesGroupModuleTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idSitesGroupMeta =
      const VerificationMeta('idSitesGroup');
  @override
  late final GeneratedColumn<int> idSitesGroup = GeneratedColumn<int>(
      'id_sites_group', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _idModuleMeta =
      const VerificationMeta('idModule');
  @override
  late final GeneratedColumn<int> idModule = GeneratedColumn<int>(
      'id_module', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [idSitesGroup, idModule];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cor_sites_group_module_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<CorSitesGroupModule> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_sites_group')) {
      context.handle(
          _idSitesGroupMeta,
          idSitesGroup.isAcceptableOrUnknown(
              data['id_sites_group']!, _idSitesGroupMeta));
    } else if (isInserting) {
      context.missing(_idSitesGroupMeta);
    }
    if (data.containsKey('id_module')) {
      context.handle(_idModuleMeta,
          idModule.isAcceptableOrUnknown(data['id_module']!, _idModuleMeta));
    } else if (isInserting) {
      context.missing(_idModuleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idSitesGroup, idModule};
  @override
  CorSitesGroupModule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CorSitesGroupModule(
      idSitesGroup: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_sites_group'])!,
      idModule: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_module'])!,
    );
  }

  @override
  $CorSitesGroupModuleTableTable createAlias(String alias) {
    return $CorSitesGroupModuleTableTable(attachedDatabase, alias);
  }
}

class CorSitesGroupModule extends DataClass
    implements Insertable<CorSitesGroupModule> {
  final int idSitesGroup;
  final int idModule;
  const CorSitesGroupModule(
      {required this.idSitesGroup, required this.idModule});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_sites_group'] = Variable<int>(idSitesGroup);
    map['id_module'] = Variable<int>(idModule);
    return map;
  }

  CorSitesGroupModuleTableCompanion toCompanion(bool nullToAbsent) {
    return CorSitesGroupModuleTableCompanion(
      idSitesGroup: Value(idSitesGroup),
      idModule: Value(idModule),
    );
  }

  factory CorSitesGroupModule.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CorSitesGroupModule(
      idSitesGroup: serializer.fromJson<int>(json['idSitesGroup']),
      idModule: serializer.fromJson<int>(json['idModule']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idSitesGroup': serializer.toJson<int>(idSitesGroup),
      'idModule': serializer.toJson<int>(idModule),
    };
  }

  CorSitesGroupModule copyWith({int? idSitesGroup, int? idModule}) =>
      CorSitesGroupModule(
        idSitesGroup: idSitesGroup ?? this.idSitesGroup,
        idModule: idModule ?? this.idModule,
      );
  CorSitesGroupModule copyWithCompanion(
      CorSitesGroupModuleTableCompanion data) {
    return CorSitesGroupModule(
      idSitesGroup: data.idSitesGroup.present
          ? data.idSitesGroup.value
          : this.idSitesGroup,
      idModule: data.idModule.present ? data.idModule.value : this.idModule,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CorSitesGroupModule(')
          ..write('idSitesGroup: $idSitesGroup, ')
          ..write('idModule: $idModule')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(idSitesGroup, idModule);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CorSitesGroupModule &&
          other.idSitesGroup == this.idSitesGroup &&
          other.idModule == this.idModule);
}

class CorSitesGroupModuleTableCompanion
    extends UpdateCompanion<CorSitesGroupModule> {
  final Value<int> idSitesGroup;
  final Value<int> idModule;
  final Value<int> rowid;
  const CorSitesGroupModuleTableCompanion({
    this.idSitesGroup = const Value.absent(),
    this.idModule = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CorSitesGroupModuleTableCompanion.insert({
    required int idSitesGroup,
    required int idModule,
    this.rowid = const Value.absent(),
  })  : idSitesGroup = Value(idSitesGroup),
        idModule = Value(idModule);
  static Insertable<CorSitesGroupModule> custom({
    Expression<int>? idSitesGroup,
    Expression<int>? idModule,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (idSitesGroup != null) 'id_sites_group': idSitesGroup,
      if (idModule != null) 'id_module': idModule,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CorSitesGroupModuleTableCompanion copyWith(
      {Value<int>? idSitesGroup, Value<int>? idModule, Value<int>? rowid}) {
    return CorSitesGroupModuleTableCompanion(
      idSitesGroup: idSitesGroup ?? this.idSitesGroup,
      idModule: idModule ?? this.idModule,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idSitesGroup.present) {
      map['id_sites_group'] = Variable<int>(idSitesGroup.value);
    }
    if (idModule.present) {
      map['id_module'] = Variable<int>(idModule.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CorSitesGroupModuleTableCompanion(')
          ..write('idSitesGroup: $idSitesGroup, ')
          ..write('idModule: $idModule, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CorObjectModuleTableTable extends CorObjectModuleTable
    with TableInfo<$CorObjectModuleTableTable, CorObjectModule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CorObjectModuleTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idCorObjectModuleMeta =
      const VerificationMeta('idCorObjectModule');
  @override
  late final GeneratedColumn<int> idCorObjectModule = GeneratedColumn<int>(
      'id_cor_object_module', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _idObjectMeta =
      const VerificationMeta('idObject');
  @override
  late final GeneratedColumn<int> idObject = GeneratedColumn<int>(
      'id_object', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _idModuleMeta =
      const VerificationMeta('idModule');
  @override
  late final GeneratedColumn<int> idModule = GeneratedColumn<int>(
      'id_module', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [idCorObjectModule, idObject, idModule];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cor_object_module_table';
  @override
  VerificationContext validateIntegrity(Insertable<CorObjectModule> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_cor_object_module')) {
      context.handle(
          _idCorObjectModuleMeta,
          idCorObjectModule.isAcceptableOrUnknown(
              data['id_cor_object_module']!, _idCorObjectModuleMeta));
    }
    if (data.containsKey('id_object')) {
      context.handle(_idObjectMeta,
          idObject.isAcceptableOrUnknown(data['id_object']!, _idObjectMeta));
    } else if (isInserting) {
      context.missing(_idObjectMeta);
    }
    if (data.containsKey('id_module')) {
      context.handle(_idModuleMeta,
          idModule.isAcceptableOrUnknown(data['id_module']!, _idModuleMeta));
    } else if (isInserting) {
      context.missing(_idModuleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idCorObjectModule};
  @override
  CorObjectModule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CorObjectModule(
      idCorObjectModule: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}id_cor_object_module'])!,
      idObject: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_object'])!,
      idModule: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_module'])!,
    );
  }

  @override
  $CorObjectModuleTableTable createAlias(String alias) {
    return $CorObjectModuleTableTable(attachedDatabase, alias);
  }
}

class CorObjectModule extends DataClass implements Insertable<CorObjectModule> {
  final int idCorObjectModule;
  final int idObject;
  final int idModule;
  const CorObjectModule(
      {required this.idCorObjectModule,
      required this.idObject,
      required this.idModule});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_cor_object_module'] = Variable<int>(idCorObjectModule);
    map['id_object'] = Variable<int>(idObject);
    map['id_module'] = Variable<int>(idModule);
    return map;
  }

  CorObjectModuleTableCompanion toCompanion(bool nullToAbsent) {
    return CorObjectModuleTableCompanion(
      idCorObjectModule: Value(idCorObjectModule),
      idObject: Value(idObject),
      idModule: Value(idModule),
    );
  }

  factory CorObjectModule.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CorObjectModule(
      idCorObjectModule: serializer.fromJson<int>(json['idCorObjectModule']),
      idObject: serializer.fromJson<int>(json['idObject']),
      idModule: serializer.fromJson<int>(json['idModule']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idCorObjectModule': serializer.toJson<int>(idCorObjectModule),
      'idObject': serializer.toJson<int>(idObject),
      'idModule': serializer.toJson<int>(idModule),
    };
  }

  CorObjectModule copyWith(
          {int? idCorObjectModule, int? idObject, int? idModule}) =>
      CorObjectModule(
        idCorObjectModule: idCorObjectModule ?? this.idCorObjectModule,
        idObject: idObject ?? this.idObject,
        idModule: idModule ?? this.idModule,
      );
  CorObjectModule copyWithCompanion(CorObjectModuleTableCompanion data) {
    return CorObjectModule(
      idCorObjectModule: data.idCorObjectModule.present
          ? data.idCorObjectModule.value
          : this.idCorObjectModule,
      idObject: data.idObject.present ? data.idObject.value : this.idObject,
      idModule: data.idModule.present ? data.idModule.value : this.idModule,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CorObjectModule(')
          ..write('idCorObjectModule: $idCorObjectModule, ')
          ..write('idObject: $idObject, ')
          ..write('idModule: $idModule')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(idCorObjectModule, idObject, idModule);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CorObjectModule &&
          other.idCorObjectModule == this.idCorObjectModule &&
          other.idObject == this.idObject &&
          other.idModule == this.idModule);
}

class CorObjectModuleTableCompanion extends UpdateCompanion<CorObjectModule> {
  final Value<int> idCorObjectModule;
  final Value<int> idObject;
  final Value<int> idModule;
  const CorObjectModuleTableCompanion({
    this.idCorObjectModule = const Value.absent(),
    this.idObject = const Value.absent(),
    this.idModule = const Value.absent(),
  });
  CorObjectModuleTableCompanion.insert({
    this.idCorObjectModule = const Value.absent(),
    required int idObject,
    required int idModule,
  })  : idObject = Value(idObject),
        idModule = Value(idModule);
  static Insertable<CorObjectModule> custom({
    Expression<int>? idCorObjectModule,
    Expression<int>? idObject,
    Expression<int>? idModule,
  }) {
    return RawValuesInsertable({
      if (idCorObjectModule != null) 'id_cor_object_module': idCorObjectModule,
      if (idObject != null) 'id_object': idObject,
      if (idModule != null) 'id_module': idModule,
    });
  }

  CorObjectModuleTableCompanion copyWith(
      {Value<int>? idCorObjectModule,
      Value<int>? idObject,
      Value<int>? idModule}) {
    return CorObjectModuleTableCompanion(
      idCorObjectModule: idCorObjectModule ?? this.idCorObjectModule,
      idObject: idObject ?? this.idObject,
      idModule: idModule ?? this.idModule,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idCorObjectModule.present) {
      map['id_cor_object_module'] = Variable<int>(idCorObjectModule.value);
    }
    if (idObject.present) {
      map['id_object'] = Variable<int>(idObject.value);
    }
    if (idModule.present) {
      map['id_module'] = Variable<int>(idModule.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CorObjectModuleTableCompanion(')
          ..write('idCorObjectModule: $idCorObjectModule, ')
          ..write('idObject: $idObject, ')
          ..write('idModule: $idModule')
          ..write(')'))
        .toString();
  }
}

class $TBaseVisitsTable extends TBaseVisits
    with TableInfo<$TBaseVisitsTable, TBaseVisit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TBaseVisitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idBaseVisitMeta =
      const VerificationMeta('idBaseVisit');
  @override
  late final GeneratedColumn<int> idBaseVisit = GeneratedColumn<int>(
      'id_base_visit', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _idBaseSiteMeta =
      const VerificationMeta('idBaseSite');
  @override
  late final GeneratedColumn<int> idBaseSite = GeneratedColumn<int>(
      'id_base_site', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _idDatasetMeta =
      const VerificationMeta('idDataset');
  @override
  late final GeneratedColumn<int> idDataset = GeneratedColumn<int>(
      'id_dataset', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _idModuleMeta =
      const VerificationMeta('idModule');
  @override
  late final GeneratedColumn<int> idModule = GeneratedColumn<int>(
      'id_module', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _idDigitiserMeta =
      const VerificationMeta('idDigitiser');
  @override
  late final GeneratedColumn<int> idDigitiser = GeneratedColumn<int>(
      'id_digitiser', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _visitDateMinMeta =
      const VerificationMeta('visitDateMin');
  @override
  late final GeneratedColumn<String> visitDateMin = GeneratedColumn<String>(
      'visit_date_min', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _visitDateMaxMeta =
      const VerificationMeta('visitDateMax');
  @override
  late final GeneratedColumn<String> visitDateMax = GeneratedColumn<String>(
      'visit_date_max', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _idNomenclatureTechCollectCampanuleMeta =
      const VerificationMeta('idNomenclatureTechCollectCampanule');
  @override
  late final GeneratedColumn<int> idNomenclatureTechCollectCampanule =
      GeneratedColumn<int>(
          'id_nomenclature_tech_collect_campanule', aliasedName, true,
          type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _idNomenclatureGrpTypMeta =
      const VerificationMeta('idNomenclatureGrpTyp');
  @override
  late final GeneratedColumn<int> idNomenclatureGrpTyp = GeneratedColumn<int>(
      'id_nomenclature_grp_typ', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _commentsMeta =
      const VerificationMeta('comments');
  @override
  late final GeneratedColumn<String> comments = GeneratedColumn<String>(
      'comments', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _uuidBaseVisitMeta =
      const VerificationMeta('uuidBaseVisit');
  @override
  late final GeneratedColumn<String> uuidBaseVisit = GeneratedColumn<String>(
      'uuid_base_visit', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _metaCreateDateMeta =
      const VerificationMeta('metaCreateDate');
  @override
  late final GeneratedColumn<String> metaCreateDate = GeneratedColumn<String>(
      'meta_create_date', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('CURRENT_TIMESTAMP'));
  static const VerificationMeta _metaUpdateDateMeta =
      const VerificationMeta('metaUpdateDate');
  @override
  late final GeneratedColumn<String> metaUpdateDate = GeneratedColumn<String>(
      'meta_update_date', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('CURRENT_TIMESTAMP'));
  @override
  List<GeneratedColumn> get $columns => [
        idBaseVisit,
        idBaseSite,
        idDataset,
        idModule,
        idDigitiser,
        visitDateMin,
        visitDateMax,
        idNomenclatureTechCollectCampanule,
        idNomenclatureGrpTyp,
        comments,
        uuidBaseVisit,
        metaCreateDate,
        metaUpdateDate
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 't_base_visits';
  @override
  VerificationContext validateIntegrity(Insertable<TBaseVisit> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_base_visit')) {
      context.handle(
          _idBaseVisitMeta,
          idBaseVisit.isAcceptableOrUnknown(
              data['id_base_visit']!, _idBaseVisitMeta));
    }
    if (data.containsKey('id_base_site')) {
      context.handle(
          _idBaseSiteMeta,
          idBaseSite.isAcceptableOrUnknown(
              data['id_base_site']!, _idBaseSiteMeta));
    }
    if (data.containsKey('id_dataset')) {
      context.handle(_idDatasetMeta,
          idDataset.isAcceptableOrUnknown(data['id_dataset']!, _idDatasetMeta));
    } else if (isInserting) {
      context.missing(_idDatasetMeta);
    }
    if (data.containsKey('id_module')) {
      context.handle(_idModuleMeta,
          idModule.isAcceptableOrUnknown(data['id_module']!, _idModuleMeta));
    } else if (isInserting) {
      context.missing(_idModuleMeta);
    }
    if (data.containsKey('id_digitiser')) {
      context.handle(
          _idDigitiserMeta,
          idDigitiser.isAcceptableOrUnknown(
              data['id_digitiser']!, _idDigitiserMeta));
    }
    if (data.containsKey('visit_date_min')) {
      context.handle(
          _visitDateMinMeta,
          visitDateMin.isAcceptableOrUnknown(
              data['visit_date_min']!, _visitDateMinMeta));
    } else if (isInserting) {
      context.missing(_visitDateMinMeta);
    }
    if (data.containsKey('visit_date_max')) {
      context.handle(
          _visitDateMaxMeta,
          visitDateMax.isAcceptableOrUnknown(
              data['visit_date_max']!, _visitDateMaxMeta));
    }
    if (data.containsKey('id_nomenclature_tech_collect_campanule')) {
      context.handle(
          _idNomenclatureTechCollectCampanuleMeta,
          idNomenclatureTechCollectCampanule.isAcceptableOrUnknown(
              data['id_nomenclature_tech_collect_campanule']!,
              _idNomenclatureTechCollectCampanuleMeta));
    }
    if (data.containsKey('id_nomenclature_grp_typ')) {
      context.handle(
          _idNomenclatureGrpTypMeta,
          idNomenclatureGrpTyp.isAcceptableOrUnknown(
              data['id_nomenclature_grp_typ']!, _idNomenclatureGrpTypMeta));
    }
    if (data.containsKey('comments')) {
      context.handle(_commentsMeta,
          comments.isAcceptableOrUnknown(data['comments']!, _commentsMeta));
    }
    if (data.containsKey('uuid_base_visit')) {
      context.handle(
          _uuidBaseVisitMeta,
          uuidBaseVisit.isAcceptableOrUnknown(
              data['uuid_base_visit']!, _uuidBaseVisitMeta));
    }
    if (data.containsKey('meta_create_date')) {
      context.handle(
          _metaCreateDateMeta,
          metaCreateDate.isAcceptableOrUnknown(
              data['meta_create_date']!, _metaCreateDateMeta));
    }
    if (data.containsKey('meta_update_date')) {
      context.handle(
          _metaUpdateDateMeta,
          metaUpdateDate.isAcceptableOrUnknown(
              data['meta_update_date']!, _metaUpdateDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idBaseVisit};
  @override
  TBaseVisit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TBaseVisit(
      idBaseVisit: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_base_visit'])!,
      idBaseSite: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_base_site']),
      idDataset: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_dataset'])!,
      idModule: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_module'])!,
      idDigitiser: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_digitiser']),
      visitDateMin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}visit_date_min'])!,
      visitDateMax: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}visit_date_max']),
      idNomenclatureTechCollectCampanule: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}id_nomenclature_tech_collect_campanule']),
      idNomenclatureGrpTyp: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}id_nomenclature_grp_typ']),
      comments: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}comments']),
      uuidBaseVisit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid_base_visit']),
      metaCreateDate: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}meta_create_date'])!,
      metaUpdateDate: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}meta_update_date'])!,
    );
  }

  @override
  $TBaseVisitsTable createAlias(String alias) {
    return $TBaseVisitsTable(attachedDatabase, alias);
  }
}

class TBaseVisit extends DataClass implements Insertable<TBaseVisit> {
  final int idBaseVisit;
  final int? idBaseSite;
  final int idDataset;
  final int idModule;
  final int? idDigitiser;
  final String visitDateMin;
  final String? visitDateMax;
  final int? idNomenclatureTechCollectCampanule;
  final int? idNomenclatureGrpTyp;
  final String? comments;
  final String? uuidBaseVisit;
  final String metaCreateDate;
  final String metaUpdateDate;
  const TBaseVisit(
      {required this.idBaseVisit,
      this.idBaseSite,
      required this.idDataset,
      required this.idModule,
      this.idDigitiser,
      required this.visitDateMin,
      this.visitDateMax,
      this.idNomenclatureTechCollectCampanule,
      this.idNomenclatureGrpTyp,
      this.comments,
      this.uuidBaseVisit,
      required this.metaCreateDate,
      required this.metaUpdateDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_base_visit'] = Variable<int>(idBaseVisit);
    if (!nullToAbsent || idBaseSite != null) {
      map['id_base_site'] = Variable<int>(idBaseSite);
    }
    map['id_dataset'] = Variable<int>(idDataset);
    map['id_module'] = Variable<int>(idModule);
    if (!nullToAbsent || idDigitiser != null) {
      map['id_digitiser'] = Variable<int>(idDigitiser);
    }
    map['visit_date_min'] = Variable<String>(visitDateMin);
    if (!nullToAbsent || visitDateMax != null) {
      map['visit_date_max'] = Variable<String>(visitDateMax);
    }
    if (!nullToAbsent || idNomenclatureTechCollectCampanule != null) {
      map['id_nomenclature_tech_collect_campanule'] =
          Variable<int>(idNomenclatureTechCollectCampanule);
    }
    if (!nullToAbsent || idNomenclatureGrpTyp != null) {
      map['id_nomenclature_grp_typ'] = Variable<int>(idNomenclatureGrpTyp);
    }
    if (!nullToAbsent || comments != null) {
      map['comments'] = Variable<String>(comments);
    }
    if (!nullToAbsent || uuidBaseVisit != null) {
      map['uuid_base_visit'] = Variable<String>(uuidBaseVisit);
    }
    map['meta_create_date'] = Variable<String>(metaCreateDate);
    map['meta_update_date'] = Variable<String>(metaUpdateDate);
    return map;
  }

  TBaseVisitsCompanion toCompanion(bool nullToAbsent) {
    return TBaseVisitsCompanion(
      idBaseVisit: Value(idBaseVisit),
      idBaseSite: idBaseSite == null && nullToAbsent
          ? const Value.absent()
          : Value(idBaseSite),
      idDataset: Value(idDataset),
      idModule: Value(idModule),
      idDigitiser: idDigitiser == null && nullToAbsent
          ? const Value.absent()
          : Value(idDigitiser),
      visitDateMin: Value(visitDateMin),
      visitDateMax: visitDateMax == null && nullToAbsent
          ? const Value.absent()
          : Value(visitDateMax),
      idNomenclatureTechCollectCampanule:
          idNomenclatureTechCollectCampanule == null && nullToAbsent
              ? const Value.absent()
              : Value(idNomenclatureTechCollectCampanule),
      idNomenclatureGrpTyp: idNomenclatureGrpTyp == null && nullToAbsent
          ? const Value.absent()
          : Value(idNomenclatureGrpTyp),
      comments: comments == null && nullToAbsent
          ? const Value.absent()
          : Value(comments),
      uuidBaseVisit: uuidBaseVisit == null && nullToAbsent
          ? const Value.absent()
          : Value(uuidBaseVisit),
      metaCreateDate: Value(metaCreateDate),
      metaUpdateDate: Value(metaUpdateDate),
    );
  }

  factory TBaseVisit.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TBaseVisit(
      idBaseVisit: serializer.fromJson<int>(json['idBaseVisit']),
      idBaseSite: serializer.fromJson<int?>(json['idBaseSite']),
      idDataset: serializer.fromJson<int>(json['idDataset']),
      idModule: serializer.fromJson<int>(json['idModule']),
      idDigitiser: serializer.fromJson<int?>(json['idDigitiser']),
      visitDateMin: serializer.fromJson<String>(json['visitDateMin']),
      visitDateMax: serializer.fromJson<String?>(json['visitDateMax']),
      idNomenclatureTechCollectCampanule:
          serializer.fromJson<int?>(json['idNomenclatureTechCollectCampanule']),
      idNomenclatureGrpTyp:
          serializer.fromJson<int?>(json['idNomenclatureGrpTyp']),
      comments: serializer.fromJson<String?>(json['comments']),
      uuidBaseVisit: serializer.fromJson<String?>(json['uuidBaseVisit']),
      metaCreateDate: serializer.fromJson<String>(json['metaCreateDate']),
      metaUpdateDate: serializer.fromJson<String>(json['metaUpdateDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idBaseVisit': serializer.toJson<int>(idBaseVisit),
      'idBaseSite': serializer.toJson<int?>(idBaseSite),
      'idDataset': serializer.toJson<int>(idDataset),
      'idModule': serializer.toJson<int>(idModule),
      'idDigitiser': serializer.toJson<int?>(idDigitiser),
      'visitDateMin': serializer.toJson<String>(visitDateMin),
      'visitDateMax': serializer.toJson<String?>(visitDateMax),
      'idNomenclatureTechCollectCampanule':
          serializer.toJson<int?>(idNomenclatureTechCollectCampanule),
      'idNomenclatureGrpTyp': serializer.toJson<int?>(idNomenclatureGrpTyp),
      'comments': serializer.toJson<String?>(comments),
      'uuidBaseVisit': serializer.toJson<String?>(uuidBaseVisit),
      'metaCreateDate': serializer.toJson<String>(metaCreateDate),
      'metaUpdateDate': serializer.toJson<String>(metaUpdateDate),
    };
  }

  TBaseVisit copyWith(
          {int? idBaseVisit,
          Value<int?> idBaseSite = const Value.absent(),
          int? idDataset,
          int? idModule,
          Value<int?> idDigitiser = const Value.absent(),
          String? visitDateMin,
          Value<String?> visitDateMax = const Value.absent(),
          Value<int?> idNomenclatureTechCollectCampanule = const Value.absent(),
          Value<int?> idNomenclatureGrpTyp = const Value.absent(),
          Value<String?> comments = const Value.absent(),
          Value<String?> uuidBaseVisit = const Value.absent(),
          String? metaCreateDate,
          String? metaUpdateDate}) =>
      TBaseVisit(
        idBaseVisit: idBaseVisit ?? this.idBaseVisit,
        idBaseSite: idBaseSite.present ? idBaseSite.value : this.idBaseSite,
        idDataset: idDataset ?? this.idDataset,
        idModule: idModule ?? this.idModule,
        idDigitiser: idDigitiser.present ? idDigitiser.value : this.idDigitiser,
        visitDateMin: visitDateMin ?? this.visitDateMin,
        visitDateMax:
            visitDateMax.present ? visitDateMax.value : this.visitDateMax,
        idNomenclatureTechCollectCampanule:
            idNomenclatureTechCollectCampanule.present
                ? idNomenclatureTechCollectCampanule.value
                : this.idNomenclatureTechCollectCampanule,
        idNomenclatureGrpTyp: idNomenclatureGrpTyp.present
            ? idNomenclatureGrpTyp.value
            : this.idNomenclatureGrpTyp,
        comments: comments.present ? comments.value : this.comments,
        uuidBaseVisit:
            uuidBaseVisit.present ? uuidBaseVisit.value : this.uuidBaseVisit,
        metaCreateDate: metaCreateDate ?? this.metaCreateDate,
        metaUpdateDate: metaUpdateDate ?? this.metaUpdateDate,
      );
  TBaseVisit copyWithCompanion(TBaseVisitsCompanion data) {
    return TBaseVisit(
      idBaseVisit:
          data.idBaseVisit.present ? data.idBaseVisit.value : this.idBaseVisit,
      idBaseSite:
          data.idBaseSite.present ? data.idBaseSite.value : this.idBaseSite,
      idDataset: data.idDataset.present ? data.idDataset.value : this.idDataset,
      idModule: data.idModule.present ? data.idModule.value : this.idModule,
      idDigitiser:
          data.idDigitiser.present ? data.idDigitiser.value : this.idDigitiser,
      visitDateMin: data.visitDateMin.present
          ? data.visitDateMin.value
          : this.visitDateMin,
      visitDateMax: data.visitDateMax.present
          ? data.visitDateMax.value
          : this.visitDateMax,
      idNomenclatureTechCollectCampanule:
          data.idNomenclatureTechCollectCampanule.present
              ? data.idNomenclatureTechCollectCampanule.value
              : this.idNomenclatureTechCollectCampanule,
      idNomenclatureGrpTyp: data.idNomenclatureGrpTyp.present
          ? data.idNomenclatureGrpTyp.value
          : this.idNomenclatureGrpTyp,
      comments: data.comments.present ? data.comments.value : this.comments,
      uuidBaseVisit: data.uuidBaseVisit.present
          ? data.uuidBaseVisit.value
          : this.uuidBaseVisit,
      metaCreateDate: data.metaCreateDate.present
          ? data.metaCreateDate.value
          : this.metaCreateDate,
      metaUpdateDate: data.metaUpdateDate.present
          ? data.metaUpdateDate.value
          : this.metaUpdateDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TBaseVisit(')
          ..write('idBaseVisit: $idBaseVisit, ')
          ..write('idBaseSite: $idBaseSite, ')
          ..write('idDataset: $idDataset, ')
          ..write('idModule: $idModule, ')
          ..write('idDigitiser: $idDigitiser, ')
          ..write('visitDateMin: $visitDateMin, ')
          ..write('visitDateMax: $visitDateMax, ')
          ..write(
              'idNomenclatureTechCollectCampanule: $idNomenclatureTechCollectCampanule, ')
          ..write('idNomenclatureGrpTyp: $idNomenclatureGrpTyp, ')
          ..write('comments: $comments, ')
          ..write('uuidBaseVisit: $uuidBaseVisit, ')
          ..write('metaCreateDate: $metaCreateDate, ')
          ..write('metaUpdateDate: $metaUpdateDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      idBaseVisit,
      idBaseSite,
      idDataset,
      idModule,
      idDigitiser,
      visitDateMin,
      visitDateMax,
      idNomenclatureTechCollectCampanule,
      idNomenclatureGrpTyp,
      comments,
      uuidBaseVisit,
      metaCreateDate,
      metaUpdateDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TBaseVisit &&
          other.idBaseVisit == this.idBaseVisit &&
          other.idBaseSite == this.idBaseSite &&
          other.idDataset == this.idDataset &&
          other.idModule == this.idModule &&
          other.idDigitiser == this.idDigitiser &&
          other.visitDateMin == this.visitDateMin &&
          other.visitDateMax == this.visitDateMax &&
          other.idNomenclatureTechCollectCampanule ==
              this.idNomenclatureTechCollectCampanule &&
          other.idNomenclatureGrpTyp == this.idNomenclatureGrpTyp &&
          other.comments == this.comments &&
          other.uuidBaseVisit == this.uuidBaseVisit &&
          other.metaCreateDate == this.metaCreateDate &&
          other.metaUpdateDate == this.metaUpdateDate);
}

class TBaseVisitsCompanion extends UpdateCompanion<TBaseVisit> {
  final Value<int> idBaseVisit;
  final Value<int?> idBaseSite;
  final Value<int> idDataset;
  final Value<int> idModule;
  final Value<int?> idDigitiser;
  final Value<String> visitDateMin;
  final Value<String?> visitDateMax;
  final Value<int?> idNomenclatureTechCollectCampanule;
  final Value<int?> idNomenclatureGrpTyp;
  final Value<String?> comments;
  final Value<String?> uuidBaseVisit;
  final Value<String> metaCreateDate;
  final Value<String> metaUpdateDate;
  const TBaseVisitsCompanion({
    this.idBaseVisit = const Value.absent(),
    this.idBaseSite = const Value.absent(),
    this.idDataset = const Value.absent(),
    this.idModule = const Value.absent(),
    this.idDigitiser = const Value.absent(),
    this.visitDateMin = const Value.absent(),
    this.visitDateMax = const Value.absent(),
    this.idNomenclatureTechCollectCampanule = const Value.absent(),
    this.idNomenclatureGrpTyp = const Value.absent(),
    this.comments = const Value.absent(),
    this.uuidBaseVisit = const Value.absent(),
    this.metaCreateDate = const Value.absent(),
    this.metaUpdateDate = const Value.absent(),
  });
  TBaseVisitsCompanion.insert({
    this.idBaseVisit = const Value.absent(),
    this.idBaseSite = const Value.absent(),
    required int idDataset,
    required int idModule,
    this.idDigitiser = const Value.absent(),
    required String visitDateMin,
    this.visitDateMax = const Value.absent(),
    this.idNomenclatureTechCollectCampanule = const Value.absent(),
    this.idNomenclatureGrpTyp = const Value.absent(),
    this.comments = const Value.absent(),
    this.uuidBaseVisit = const Value.absent(),
    this.metaCreateDate = const Value.absent(),
    this.metaUpdateDate = const Value.absent(),
  })  : idDataset = Value(idDataset),
        idModule = Value(idModule),
        visitDateMin = Value(visitDateMin);
  static Insertable<TBaseVisit> custom({
    Expression<int>? idBaseVisit,
    Expression<int>? idBaseSite,
    Expression<int>? idDataset,
    Expression<int>? idModule,
    Expression<int>? idDigitiser,
    Expression<String>? visitDateMin,
    Expression<String>? visitDateMax,
    Expression<int>? idNomenclatureTechCollectCampanule,
    Expression<int>? idNomenclatureGrpTyp,
    Expression<String>? comments,
    Expression<String>? uuidBaseVisit,
    Expression<String>? metaCreateDate,
    Expression<String>? metaUpdateDate,
  }) {
    return RawValuesInsertable({
      if (idBaseVisit != null) 'id_base_visit': idBaseVisit,
      if (idBaseSite != null) 'id_base_site': idBaseSite,
      if (idDataset != null) 'id_dataset': idDataset,
      if (idModule != null) 'id_module': idModule,
      if (idDigitiser != null) 'id_digitiser': idDigitiser,
      if (visitDateMin != null) 'visit_date_min': visitDateMin,
      if (visitDateMax != null) 'visit_date_max': visitDateMax,
      if (idNomenclatureTechCollectCampanule != null)
        'id_nomenclature_tech_collect_campanule':
            idNomenclatureTechCollectCampanule,
      if (idNomenclatureGrpTyp != null)
        'id_nomenclature_grp_typ': idNomenclatureGrpTyp,
      if (comments != null) 'comments': comments,
      if (uuidBaseVisit != null) 'uuid_base_visit': uuidBaseVisit,
      if (metaCreateDate != null) 'meta_create_date': metaCreateDate,
      if (metaUpdateDate != null) 'meta_update_date': metaUpdateDate,
    });
  }

  TBaseVisitsCompanion copyWith(
      {Value<int>? idBaseVisit,
      Value<int?>? idBaseSite,
      Value<int>? idDataset,
      Value<int>? idModule,
      Value<int?>? idDigitiser,
      Value<String>? visitDateMin,
      Value<String?>? visitDateMax,
      Value<int?>? idNomenclatureTechCollectCampanule,
      Value<int?>? idNomenclatureGrpTyp,
      Value<String?>? comments,
      Value<String?>? uuidBaseVisit,
      Value<String>? metaCreateDate,
      Value<String>? metaUpdateDate}) {
    return TBaseVisitsCompanion(
      idBaseVisit: idBaseVisit ?? this.idBaseVisit,
      idBaseSite: idBaseSite ?? this.idBaseSite,
      idDataset: idDataset ?? this.idDataset,
      idModule: idModule ?? this.idModule,
      idDigitiser: idDigitiser ?? this.idDigitiser,
      visitDateMin: visitDateMin ?? this.visitDateMin,
      visitDateMax: visitDateMax ?? this.visitDateMax,
      idNomenclatureTechCollectCampanule: idNomenclatureTechCollectCampanule ??
          this.idNomenclatureTechCollectCampanule,
      idNomenclatureGrpTyp: idNomenclatureGrpTyp ?? this.idNomenclatureGrpTyp,
      comments: comments ?? this.comments,
      uuidBaseVisit: uuidBaseVisit ?? this.uuidBaseVisit,
      metaCreateDate: metaCreateDate ?? this.metaCreateDate,
      metaUpdateDate: metaUpdateDate ?? this.metaUpdateDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idBaseVisit.present) {
      map['id_base_visit'] = Variable<int>(idBaseVisit.value);
    }
    if (idBaseSite.present) {
      map['id_base_site'] = Variable<int>(idBaseSite.value);
    }
    if (idDataset.present) {
      map['id_dataset'] = Variable<int>(idDataset.value);
    }
    if (idModule.present) {
      map['id_module'] = Variable<int>(idModule.value);
    }
    if (idDigitiser.present) {
      map['id_digitiser'] = Variable<int>(idDigitiser.value);
    }
    if (visitDateMin.present) {
      map['visit_date_min'] = Variable<String>(visitDateMin.value);
    }
    if (visitDateMax.present) {
      map['visit_date_max'] = Variable<String>(visitDateMax.value);
    }
    if (idNomenclatureTechCollectCampanule.present) {
      map['id_nomenclature_tech_collect_campanule'] =
          Variable<int>(idNomenclatureTechCollectCampanule.value);
    }
    if (idNomenclatureGrpTyp.present) {
      map['id_nomenclature_grp_typ'] =
          Variable<int>(idNomenclatureGrpTyp.value);
    }
    if (comments.present) {
      map['comments'] = Variable<String>(comments.value);
    }
    if (uuidBaseVisit.present) {
      map['uuid_base_visit'] = Variable<String>(uuidBaseVisit.value);
    }
    if (metaCreateDate.present) {
      map['meta_create_date'] = Variable<String>(metaCreateDate.value);
    }
    if (metaUpdateDate.present) {
      map['meta_update_date'] = Variable<String>(metaUpdateDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TBaseVisitsCompanion(')
          ..write('idBaseVisit: $idBaseVisit, ')
          ..write('idBaseSite: $idBaseSite, ')
          ..write('idDataset: $idDataset, ')
          ..write('idModule: $idModule, ')
          ..write('idDigitiser: $idDigitiser, ')
          ..write('visitDateMin: $visitDateMin, ')
          ..write('visitDateMax: $visitDateMax, ')
          ..write(
              'idNomenclatureTechCollectCampanule: $idNomenclatureTechCollectCampanule, ')
          ..write('idNomenclatureGrpTyp: $idNomenclatureGrpTyp, ')
          ..write('comments: $comments, ')
          ..write('uuidBaseVisit: $uuidBaseVisit, ')
          ..write('metaCreateDate: $metaCreateDate, ')
          ..write('metaUpdateDate: $metaUpdateDate')
          ..write(')'))
        .toString();
  }
}

class $CorVisitObserverTable extends CorVisitObserver
    with TableInfo<$CorVisitObserverTable, CorVisitObserverData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CorVisitObserverTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idBaseVisitMeta =
      const VerificationMeta('idBaseVisit');
  @override
  late final GeneratedColumn<int> idBaseVisit = GeneratedColumn<int>(
      'id_base_visit', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES t_base_visits (id_base_visit)'));
  static const VerificationMeta _idRoleMeta = const VerificationMeta('idRole');
  @override
  late final GeneratedColumn<int> idRole = GeneratedColumn<int>(
      'id_role', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _uniqueIdCoreVisitObserverMeta =
      const VerificationMeta('uniqueIdCoreVisitObserver');
  @override
  late final GeneratedColumn<
      String> uniqueIdCoreVisitObserver = GeneratedColumn<
          String>('unique_id_core_visit_observer', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression(
          "lower(hex(randomblob(4))) || '-' || lower(hex(randomblob(2))) || '-4' || substr(lower(hex(randomblob(2))),2) || '-' || substr('89ab',abs(random()) % 4 + 1, 1) || substr(lower(hex(randomblob(2))),2) || '-' || lower(hex(randomblob(6)))"));
  @override
  List<GeneratedColumn> get $columns =>
      [idBaseVisit, idRole, uniqueIdCoreVisitObserver];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cor_visit_observer';
  @override
  VerificationContext validateIntegrity(
      Insertable<CorVisitObserverData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_base_visit')) {
      context.handle(
          _idBaseVisitMeta,
          idBaseVisit.isAcceptableOrUnknown(
              data['id_base_visit']!, _idBaseVisitMeta));
    } else if (isInserting) {
      context.missing(_idBaseVisitMeta);
    }
    if (data.containsKey('id_role')) {
      context.handle(_idRoleMeta,
          idRole.isAcceptableOrUnknown(data['id_role']!, _idRoleMeta));
    } else if (isInserting) {
      context.missing(_idRoleMeta);
    }
    if (data.containsKey('unique_id_core_visit_observer')) {
      context.handle(
          _uniqueIdCoreVisitObserverMeta,
          uniqueIdCoreVisitObserver.isAcceptableOrUnknown(
              data['unique_id_core_visit_observer']!,
              _uniqueIdCoreVisitObserverMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idBaseVisit, idRole};
  @override
  CorVisitObserverData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CorVisitObserverData(
      idBaseVisit: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_base_visit'])!,
      idRole: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_role'])!,
      uniqueIdCoreVisitObserver: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}unique_id_core_visit_observer'])!,
    );
  }

  @override
  $CorVisitObserverTable createAlias(String alias) {
    return $CorVisitObserverTable(attachedDatabase, alias);
  }
}

class CorVisitObserverData extends DataClass
    implements Insertable<CorVisitObserverData> {
  final int idBaseVisit;
  final int idRole;
  final String uniqueIdCoreVisitObserver;
  const CorVisitObserverData(
      {required this.idBaseVisit,
      required this.idRole,
      required this.uniqueIdCoreVisitObserver});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_base_visit'] = Variable<int>(idBaseVisit);
    map['id_role'] = Variable<int>(idRole);
    map['unique_id_core_visit_observer'] =
        Variable<String>(uniqueIdCoreVisitObserver);
    return map;
  }

  CorVisitObserverCompanion toCompanion(bool nullToAbsent) {
    return CorVisitObserverCompanion(
      idBaseVisit: Value(idBaseVisit),
      idRole: Value(idRole),
      uniqueIdCoreVisitObserver: Value(uniqueIdCoreVisitObserver),
    );
  }

  factory CorVisitObserverData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CorVisitObserverData(
      idBaseVisit: serializer.fromJson<int>(json['idBaseVisit']),
      idRole: serializer.fromJson<int>(json['idRole']),
      uniqueIdCoreVisitObserver:
          serializer.fromJson<String>(json['uniqueIdCoreVisitObserver']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idBaseVisit': serializer.toJson<int>(idBaseVisit),
      'idRole': serializer.toJson<int>(idRole),
      'uniqueIdCoreVisitObserver':
          serializer.toJson<String>(uniqueIdCoreVisitObserver),
    };
  }

  CorVisitObserverData copyWith(
          {int? idBaseVisit, int? idRole, String? uniqueIdCoreVisitObserver}) =>
      CorVisitObserverData(
        idBaseVisit: idBaseVisit ?? this.idBaseVisit,
        idRole: idRole ?? this.idRole,
        uniqueIdCoreVisitObserver:
            uniqueIdCoreVisitObserver ?? this.uniqueIdCoreVisitObserver,
      );
  CorVisitObserverData copyWithCompanion(CorVisitObserverCompanion data) {
    return CorVisitObserverData(
      idBaseVisit:
          data.idBaseVisit.present ? data.idBaseVisit.value : this.idBaseVisit,
      idRole: data.idRole.present ? data.idRole.value : this.idRole,
      uniqueIdCoreVisitObserver: data.uniqueIdCoreVisitObserver.present
          ? data.uniqueIdCoreVisitObserver.value
          : this.uniqueIdCoreVisitObserver,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CorVisitObserverData(')
          ..write('idBaseVisit: $idBaseVisit, ')
          ..write('idRole: $idRole, ')
          ..write('uniqueIdCoreVisitObserver: $uniqueIdCoreVisitObserver')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(idBaseVisit, idRole, uniqueIdCoreVisitObserver);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CorVisitObserverData &&
          other.idBaseVisit == this.idBaseVisit &&
          other.idRole == this.idRole &&
          other.uniqueIdCoreVisitObserver == this.uniqueIdCoreVisitObserver);
}

class CorVisitObserverCompanion extends UpdateCompanion<CorVisitObserverData> {
  final Value<int> idBaseVisit;
  final Value<int> idRole;
  final Value<String> uniqueIdCoreVisitObserver;
  final Value<int> rowid;
  const CorVisitObserverCompanion({
    this.idBaseVisit = const Value.absent(),
    this.idRole = const Value.absent(),
    this.uniqueIdCoreVisitObserver = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CorVisitObserverCompanion.insert({
    required int idBaseVisit,
    required int idRole,
    this.uniqueIdCoreVisitObserver = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : idBaseVisit = Value(idBaseVisit),
        idRole = Value(idRole);
  static Insertable<CorVisitObserverData> custom({
    Expression<int>? idBaseVisit,
    Expression<int>? idRole,
    Expression<String>? uniqueIdCoreVisitObserver,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (idBaseVisit != null) 'id_base_visit': idBaseVisit,
      if (idRole != null) 'id_role': idRole,
      if (uniqueIdCoreVisitObserver != null)
        'unique_id_core_visit_observer': uniqueIdCoreVisitObserver,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CorVisitObserverCompanion copyWith(
      {Value<int>? idBaseVisit,
      Value<int>? idRole,
      Value<String>? uniqueIdCoreVisitObserver,
      Value<int>? rowid}) {
    return CorVisitObserverCompanion(
      idBaseVisit: idBaseVisit ?? this.idBaseVisit,
      idRole: idRole ?? this.idRole,
      uniqueIdCoreVisitObserver:
          uniqueIdCoreVisitObserver ?? this.uniqueIdCoreVisitObserver,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idBaseVisit.present) {
      map['id_base_visit'] = Variable<int>(idBaseVisit.value);
    }
    if (idRole.present) {
      map['id_role'] = Variable<int>(idRole.value);
    }
    if (uniqueIdCoreVisitObserver.present) {
      map['unique_id_core_visit_observer'] =
          Variable<String>(uniqueIdCoreVisitObserver.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CorVisitObserverCompanion(')
          ..write('idBaseVisit: $idBaseVisit, ')
          ..write('idRole: $idRole, ')
          ..write('uniqueIdCoreVisitObserver: $uniqueIdCoreVisitObserver, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CorSiteTypeTableTable extends CorSiteTypeTable
    with TableInfo<$CorSiteTypeTableTable, CorSiteType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CorSiteTypeTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idBaseSiteMeta =
      const VerificationMeta('idBaseSite');
  @override
  late final GeneratedColumn<int> idBaseSite = GeneratedColumn<int>(
      'id_base_site', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _idNomenclatureTypeSiteMeta =
      const VerificationMeta('idNomenclatureTypeSite');
  @override
  late final GeneratedColumn<int> idNomenclatureTypeSite = GeneratedColumn<int>(
      'id_nomenclature_type_site', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [idBaseSite, idNomenclatureTypeSite];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cor_site_type_table';
  @override
  VerificationContext validateIntegrity(Insertable<CorSiteType> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_base_site')) {
      context.handle(
          _idBaseSiteMeta,
          idBaseSite.isAcceptableOrUnknown(
              data['id_base_site']!, _idBaseSiteMeta));
    } else if (isInserting) {
      context.missing(_idBaseSiteMeta);
    }
    if (data.containsKey('id_nomenclature_type_site')) {
      context.handle(
          _idNomenclatureTypeSiteMeta,
          idNomenclatureTypeSite.isAcceptableOrUnknown(
              data['id_nomenclature_type_site']!, _idNomenclatureTypeSiteMeta));
    } else if (isInserting) {
      context.missing(_idNomenclatureTypeSiteMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idBaseSite, idNomenclatureTypeSite};
  @override
  CorSiteType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CorSiteType(
      idBaseSite: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_base_site'])!,
      idNomenclatureTypeSite: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}id_nomenclature_type_site'])!,
    );
  }

  @override
  $CorSiteTypeTableTable createAlias(String alias) {
    return $CorSiteTypeTableTable(attachedDatabase, alias);
  }
}

class CorSiteType extends DataClass implements Insertable<CorSiteType> {
  final int idBaseSite;
  final int idNomenclatureTypeSite;
  const CorSiteType(
      {required this.idBaseSite, required this.idNomenclatureTypeSite});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_base_site'] = Variable<int>(idBaseSite);
    map['id_nomenclature_type_site'] = Variable<int>(idNomenclatureTypeSite);
    return map;
  }

  CorSiteTypeTableCompanion toCompanion(bool nullToAbsent) {
    return CorSiteTypeTableCompanion(
      idBaseSite: Value(idBaseSite),
      idNomenclatureTypeSite: Value(idNomenclatureTypeSite),
    );
  }

  factory CorSiteType.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CorSiteType(
      idBaseSite: serializer.fromJson<int>(json['idBaseSite']),
      idNomenclatureTypeSite:
          serializer.fromJson<int>(json['idNomenclatureTypeSite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idBaseSite': serializer.toJson<int>(idBaseSite),
      'idNomenclatureTypeSite': serializer.toJson<int>(idNomenclatureTypeSite),
    };
  }

  CorSiteType copyWith({int? idBaseSite, int? idNomenclatureTypeSite}) =>
      CorSiteType(
        idBaseSite: idBaseSite ?? this.idBaseSite,
        idNomenclatureTypeSite:
            idNomenclatureTypeSite ?? this.idNomenclatureTypeSite,
      );
  CorSiteType copyWithCompanion(CorSiteTypeTableCompanion data) {
    return CorSiteType(
      idBaseSite:
          data.idBaseSite.present ? data.idBaseSite.value : this.idBaseSite,
      idNomenclatureTypeSite: data.idNomenclatureTypeSite.present
          ? data.idNomenclatureTypeSite.value
          : this.idNomenclatureTypeSite,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CorSiteType(')
          ..write('idBaseSite: $idBaseSite, ')
          ..write('idNomenclatureTypeSite: $idNomenclatureTypeSite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(idBaseSite, idNomenclatureTypeSite);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CorSiteType &&
          other.idBaseSite == this.idBaseSite &&
          other.idNomenclatureTypeSite == this.idNomenclatureTypeSite);
}

class CorSiteTypeTableCompanion extends UpdateCompanion<CorSiteType> {
  final Value<int> idBaseSite;
  final Value<int> idNomenclatureTypeSite;
  final Value<int> rowid;
  const CorSiteTypeTableCompanion({
    this.idBaseSite = const Value.absent(),
    this.idNomenclatureTypeSite = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CorSiteTypeTableCompanion.insert({
    required int idBaseSite,
    required int idNomenclatureTypeSite,
    this.rowid = const Value.absent(),
  })  : idBaseSite = Value(idBaseSite),
        idNomenclatureTypeSite = Value(idNomenclatureTypeSite);
  static Insertable<CorSiteType> custom({
    Expression<int>? idBaseSite,
    Expression<int>? idNomenclatureTypeSite,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (idBaseSite != null) 'id_base_site': idBaseSite,
      if (idNomenclatureTypeSite != null)
        'id_nomenclature_type_site': idNomenclatureTypeSite,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CorSiteTypeTableCompanion copyWith(
      {Value<int>? idBaseSite,
      Value<int>? idNomenclatureTypeSite,
      Value<int>? rowid}) {
    return CorSiteTypeTableCompanion(
      idBaseSite: idBaseSite ?? this.idBaseSite,
      idNomenclatureTypeSite:
          idNomenclatureTypeSite ?? this.idNomenclatureTypeSite,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idBaseSite.present) {
      map['id_base_site'] = Variable<int>(idBaseSite.value);
    }
    if (idNomenclatureTypeSite.present) {
      map['id_nomenclature_type_site'] =
          Variable<int>(idNomenclatureTypeSite.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CorSiteTypeTableCompanion(')
          ..write('idBaseSite: $idBaseSite, ')
          ..write('idNomenclatureTypeSite: $idNomenclatureTypeSite, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CorModuleDatasetTableTable extends CorModuleDatasetTable
    with TableInfo<$CorModuleDatasetTableTable, CorModuleDataset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CorModuleDatasetTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idModuleMeta =
      const VerificationMeta('idModule');
  @override
  late final GeneratedColumn<int> idModule = GeneratedColumn<int>(
      'id_module', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _idDatasetMeta =
      const VerificationMeta('idDataset');
  @override
  late final GeneratedColumn<int> idDataset = GeneratedColumn<int>(
      'id_dataset', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [idModule, idDataset];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cor_module_dataset_table';
  @override
  VerificationContext validateIntegrity(Insertable<CorModuleDataset> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_module')) {
      context.handle(_idModuleMeta,
          idModule.isAcceptableOrUnknown(data['id_module']!, _idModuleMeta));
    } else if (isInserting) {
      context.missing(_idModuleMeta);
    }
    if (data.containsKey('id_dataset')) {
      context.handle(_idDatasetMeta,
          idDataset.isAcceptableOrUnknown(data['id_dataset']!, _idDatasetMeta));
    } else if (isInserting) {
      context.missing(_idDatasetMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idModule, idDataset};
  @override
  CorModuleDataset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CorModuleDataset(
      idModule: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_module'])!,
      idDataset: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_dataset'])!,
    );
  }

  @override
  $CorModuleDatasetTableTable createAlias(String alias) {
    return $CorModuleDatasetTableTable(attachedDatabase, alias);
  }
}

class CorModuleDataset extends DataClass
    implements Insertable<CorModuleDataset> {
  final int idModule;
  final int idDataset;
  const CorModuleDataset({required this.idModule, required this.idDataset});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_module'] = Variable<int>(idModule);
    map['id_dataset'] = Variable<int>(idDataset);
    return map;
  }

  CorModuleDatasetTableCompanion toCompanion(bool nullToAbsent) {
    return CorModuleDatasetTableCompanion(
      idModule: Value(idModule),
      idDataset: Value(idDataset),
    );
  }

  factory CorModuleDataset.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CorModuleDataset(
      idModule: serializer.fromJson<int>(json['idModule']),
      idDataset: serializer.fromJson<int>(json['idDataset']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idModule': serializer.toJson<int>(idModule),
      'idDataset': serializer.toJson<int>(idDataset),
    };
  }

  CorModuleDataset copyWith({int? idModule, int? idDataset}) =>
      CorModuleDataset(
        idModule: idModule ?? this.idModule,
        idDataset: idDataset ?? this.idDataset,
      );
  CorModuleDataset copyWithCompanion(CorModuleDatasetTableCompanion data) {
    return CorModuleDataset(
      idModule: data.idModule.present ? data.idModule.value : this.idModule,
      idDataset: data.idDataset.present ? data.idDataset.value : this.idDataset,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CorModuleDataset(')
          ..write('idModule: $idModule, ')
          ..write('idDataset: $idDataset')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(idModule, idDataset);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CorModuleDataset &&
          other.idModule == this.idModule &&
          other.idDataset == this.idDataset);
}

class CorModuleDatasetTableCompanion extends UpdateCompanion<CorModuleDataset> {
  final Value<int> idModule;
  final Value<int> idDataset;
  final Value<int> rowid;
  const CorModuleDatasetTableCompanion({
    this.idModule = const Value.absent(),
    this.idDataset = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CorModuleDatasetTableCompanion.insert({
    required int idModule,
    required int idDataset,
    this.rowid = const Value.absent(),
  })  : idModule = Value(idModule),
        idDataset = Value(idDataset);
  static Insertable<CorModuleDataset> custom({
    Expression<int>? idModule,
    Expression<int>? idDataset,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (idModule != null) 'id_module': idModule,
      if (idDataset != null) 'id_dataset': idDataset,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CorModuleDatasetTableCompanion copyWith(
      {Value<int>? idModule, Value<int>? idDataset, Value<int>? rowid}) {
    return CorModuleDatasetTableCompanion(
      idModule: idModule ?? this.idModule,
      idDataset: idDataset ?? this.idDataset,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idModule.present) {
      map['id_module'] = Variable<int>(idModule.value);
    }
    if (idDataset.present) {
      map['id_dataset'] = Variable<int>(idDataset.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CorModuleDatasetTableCompanion(')
          ..write('idModule: $idModule, ')
          ..write('idDataset: $idDataset, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TTaxrefsTable extends TTaxrefs with TableInfo<$TTaxrefsTable, TTaxref> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TTaxrefsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cdNomMeta = const VerificationMeta('cdNom');
  @override
  late final GeneratedColumn<int> cdNom = GeneratedColumn<int>(
      'cd_nom', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _cdRefMeta = const VerificationMeta('cdRef');
  @override
  late final GeneratedColumn<int> cdRef = GeneratedColumn<int>(
      'cd_ref', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _idStatutMeta =
      const VerificationMeta('idStatut');
  @override
  late final GeneratedColumn<String> idStatut = GeneratedColumn<String>(
      'id_statut', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _idHabitatMeta =
      const VerificationMeta('idHabitat');
  @override
  late final GeneratedColumn<int> idHabitat = GeneratedColumn<int>(
      'id_habitat', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _idRangMeta = const VerificationMeta('idRang');
  @override
  late final GeneratedColumn<String> idRang = GeneratedColumn<String>(
      'id_rang', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _regneMeta = const VerificationMeta('regne');
  @override
  late final GeneratedColumn<String> regne = GeneratedColumn<String>(
      'regne', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phylumMeta = const VerificationMeta('phylum');
  @override
  late final GeneratedColumn<String> phylum = GeneratedColumn<String>(
      'phylum', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _classeMeta = const VerificationMeta('classe');
  @override
  late final GeneratedColumn<String> classe = GeneratedColumn<String>(
      'classe', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ordreMeta = const VerificationMeta('ordre');
  @override
  late final GeneratedColumn<String> ordre = GeneratedColumn<String>(
      'ordre', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _familleMeta =
      const VerificationMeta('famille');
  @override
  late final GeneratedColumn<String> famille = GeneratedColumn<String>(
      'famille', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sousFamilleMeta =
      const VerificationMeta('sousFamille');
  @override
  late final GeneratedColumn<String> sousFamille = GeneratedColumn<String>(
      'sous_famille', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tribuMeta = const VerificationMeta('tribu');
  @override
  late final GeneratedColumn<String> tribu = GeneratedColumn<String>(
      'tribu', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cdTaxsupMeta =
      const VerificationMeta('cdTaxsup');
  @override
  late final GeneratedColumn<int> cdTaxsup = GeneratedColumn<int>(
      'cd_taxsup', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _cdSupMeta = const VerificationMeta('cdSup');
  @override
  late final GeneratedColumn<int> cdSup = GeneratedColumn<int>(
      'cd_sup', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _lbNomMeta = const VerificationMeta('lbNom');
  @override
  late final GeneratedColumn<String> lbNom = GeneratedColumn<String>(
      'lb_nom', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lbAuteurMeta =
      const VerificationMeta('lbAuteur');
  @override
  late final GeneratedColumn<String> lbAuteur = GeneratedColumn<String>(
      'lb_auteur', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nomCompletMeta =
      const VerificationMeta('nomComplet');
  @override
  late final GeneratedColumn<String> nomComplet = GeneratedColumn<String>(
      'nom_complet', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nomCompletHtmlMeta =
      const VerificationMeta('nomCompletHtml');
  @override
  late final GeneratedColumn<String> nomCompletHtml = GeneratedColumn<String>(
      'nom_complet_html', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nomVernMeta =
      const VerificationMeta('nomVern');
  @override
  late final GeneratedColumn<String> nomVern = GeneratedColumn<String>(
      'nom_vern', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nomValideMeta =
      const VerificationMeta('nomValide');
  @override
  late final GeneratedColumn<String> nomValide = GeneratedColumn<String>(
      'nom_valide', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nomVernEngMeta =
      const VerificationMeta('nomVernEng');
  @override
  late final GeneratedColumn<String> nomVernEng = GeneratedColumn<String>(
      'nom_vern_eng', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _group1InpnMeta =
      const VerificationMeta('group1Inpn');
  @override
  late final GeneratedColumn<String> group1Inpn = GeneratedColumn<String>(
      'group1_inpn', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _group2InpnMeta =
      const VerificationMeta('group2Inpn');
  @override
  late final GeneratedColumn<String> group2Inpn = GeneratedColumn<String>(
      'group2_inpn', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _group3InpnMeta =
      const VerificationMeta('group3Inpn');
  @override
  late final GeneratedColumn<String> group3Inpn = GeneratedColumn<String>(
      'group3_inpn', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        cdNom,
        cdRef,
        idStatut,
        idHabitat,
        idRang,
        regne,
        phylum,
        classe,
        ordre,
        famille,
        sousFamille,
        tribu,
        cdTaxsup,
        cdSup,
        lbNom,
        lbAuteur,
        nomComplet,
        nomCompletHtml,
        nomVern,
        nomValide,
        nomVernEng,
        group1Inpn,
        group2Inpn,
        group3Inpn,
        url
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 't_taxrefs';
  @override
  VerificationContext validateIntegrity(Insertable<TTaxref> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cd_nom')) {
      context.handle(
          _cdNomMeta, cdNom.isAcceptableOrUnknown(data['cd_nom']!, _cdNomMeta));
    }
    if (data.containsKey('cd_ref')) {
      context.handle(
          _cdRefMeta, cdRef.isAcceptableOrUnknown(data['cd_ref']!, _cdRefMeta));
    }
    if (data.containsKey('id_statut')) {
      context.handle(_idStatutMeta,
          idStatut.isAcceptableOrUnknown(data['id_statut']!, _idStatutMeta));
    }
    if (data.containsKey('id_habitat')) {
      context.handle(_idHabitatMeta,
          idHabitat.isAcceptableOrUnknown(data['id_habitat']!, _idHabitatMeta));
    }
    if (data.containsKey('id_rang')) {
      context.handle(_idRangMeta,
          idRang.isAcceptableOrUnknown(data['id_rang']!, _idRangMeta));
    }
    if (data.containsKey('regne')) {
      context.handle(
          _regneMeta, regne.isAcceptableOrUnknown(data['regne']!, _regneMeta));
    }
    if (data.containsKey('phylum')) {
      context.handle(_phylumMeta,
          phylum.isAcceptableOrUnknown(data['phylum']!, _phylumMeta));
    }
    if (data.containsKey('classe')) {
      context.handle(_classeMeta,
          classe.isAcceptableOrUnknown(data['classe']!, _classeMeta));
    }
    if (data.containsKey('ordre')) {
      context.handle(
          _ordreMeta, ordre.isAcceptableOrUnknown(data['ordre']!, _ordreMeta));
    }
    if (data.containsKey('famille')) {
      context.handle(_familleMeta,
          famille.isAcceptableOrUnknown(data['famille']!, _familleMeta));
    }
    if (data.containsKey('sous_famille')) {
      context.handle(
          _sousFamilleMeta,
          sousFamille.isAcceptableOrUnknown(
              data['sous_famille']!, _sousFamilleMeta));
    }
    if (data.containsKey('tribu')) {
      context.handle(
          _tribuMeta, tribu.isAcceptableOrUnknown(data['tribu']!, _tribuMeta));
    }
    if (data.containsKey('cd_taxsup')) {
      context.handle(_cdTaxsupMeta,
          cdTaxsup.isAcceptableOrUnknown(data['cd_taxsup']!, _cdTaxsupMeta));
    }
    if (data.containsKey('cd_sup')) {
      context.handle(
          _cdSupMeta, cdSup.isAcceptableOrUnknown(data['cd_sup']!, _cdSupMeta));
    }
    if (data.containsKey('lb_nom')) {
      context.handle(
          _lbNomMeta, lbNom.isAcceptableOrUnknown(data['lb_nom']!, _lbNomMeta));
    }
    if (data.containsKey('lb_auteur')) {
      context.handle(_lbAuteurMeta,
          lbAuteur.isAcceptableOrUnknown(data['lb_auteur']!, _lbAuteurMeta));
    }
    if (data.containsKey('nom_complet')) {
      context.handle(
          _nomCompletMeta,
          nomComplet.isAcceptableOrUnknown(
              data['nom_complet']!, _nomCompletMeta));
    } else if (isInserting) {
      context.missing(_nomCompletMeta);
    }
    if (data.containsKey('nom_complet_html')) {
      context.handle(
          _nomCompletHtmlMeta,
          nomCompletHtml.isAcceptableOrUnknown(
              data['nom_complet_html']!, _nomCompletHtmlMeta));
    }
    if (data.containsKey('nom_vern')) {
      context.handle(_nomVernMeta,
          nomVern.isAcceptableOrUnknown(data['nom_vern']!, _nomVernMeta));
    }
    if (data.containsKey('nom_valide')) {
      context.handle(_nomValideMeta,
          nomValide.isAcceptableOrUnknown(data['nom_valide']!, _nomValideMeta));
    }
    if (data.containsKey('nom_vern_eng')) {
      context.handle(
          _nomVernEngMeta,
          nomVernEng.isAcceptableOrUnknown(
              data['nom_vern_eng']!, _nomVernEngMeta));
    }
    if (data.containsKey('group1_inpn')) {
      context.handle(
          _group1InpnMeta,
          group1Inpn.isAcceptableOrUnknown(
              data['group1_inpn']!, _group1InpnMeta));
    }
    if (data.containsKey('group2_inpn')) {
      context.handle(
          _group2InpnMeta,
          group2Inpn.isAcceptableOrUnknown(
              data['group2_inpn']!, _group2InpnMeta));
    }
    if (data.containsKey('group3_inpn')) {
      context.handle(
          _group3InpnMeta,
          group3Inpn.isAcceptableOrUnknown(
              data['group3_inpn']!, _group3InpnMeta));
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cdNom};
  @override
  TTaxref map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TTaxref(
      cdNom: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cd_nom'])!,
      cdRef: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cd_ref']),
      idStatut: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id_statut']),
      idHabitat: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_habitat']),
      idRang: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id_rang']),
      regne: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}regne']),
      phylum: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phylum']),
      classe: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}classe']),
      ordre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ordre']),
      famille: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}famille']),
      sousFamille: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sous_famille']),
      tribu: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tribu']),
      cdTaxsup: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cd_taxsup']),
      cdSup: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cd_sup']),
      lbNom: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lb_nom']),
      lbAuteur: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lb_auteur']),
      nomComplet: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nom_complet'])!,
      nomCompletHtml: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}nom_complet_html']),
      nomVern: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nom_vern']),
      nomValide: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nom_valide']),
      nomVernEng: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nom_vern_eng']),
      group1Inpn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group1_inpn']),
      group2Inpn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group2_inpn']),
      group3Inpn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group3_inpn']),
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url']),
    );
  }

  @override
  $TTaxrefsTable createAlias(String alias) {
    return $TTaxrefsTable(attachedDatabase, alias);
  }
}

class TTaxref extends DataClass implements Insertable<TTaxref> {
  final int cdNom;
  final int? cdRef;
  final String? idStatut;
  final int? idHabitat;
  final String? idRang;
  final String? regne;
  final String? phylum;
  final String? classe;
  final String? ordre;
  final String? famille;
  final String? sousFamille;
  final String? tribu;
  final int? cdTaxsup;
  final int? cdSup;
  final String? lbNom;
  final String? lbAuteur;
  final String nomComplet;
  final String? nomCompletHtml;
  final String? nomVern;
  final String? nomValide;
  final String? nomVernEng;
  final String? group1Inpn;
  final String? group2Inpn;
  final String? group3Inpn;
  final String? url;
  const TTaxref(
      {required this.cdNom,
      this.cdRef,
      this.idStatut,
      this.idHabitat,
      this.idRang,
      this.regne,
      this.phylum,
      this.classe,
      this.ordre,
      this.famille,
      this.sousFamille,
      this.tribu,
      this.cdTaxsup,
      this.cdSup,
      this.lbNom,
      this.lbAuteur,
      required this.nomComplet,
      this.nomCompletHtml,
      this.nomVern,
      this.nomValide,
      this.nomVernEng,
      this.group1Inpn,
      this.group2Inpn,
      this.group3Inpn,
      this.url});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cd_nom'] = Variable<int>(cdNom);
    if (!nullToAbsent || cdRef != null) {
      map['cd_ref'] = Variable<int>(cdRef);
    }
    if (!nullToAbsent || idStatut != null) {
      map['id_statut'] = Variable<String>(idStatut);
    }
    if (!nullToAbsent || idHabitat != null) {
      map['id_habitat'] = Variable<int>(idHabitat);
    }
    if (!nullToAbsent || idRang != null) {
      map['id_rang'] = Variable<String>(idRang);
    }
    if (!nullToAbsent || regne != null) {
      map['regne'] = Variable<String>(regne);
    }
    if (!nullToAbsent || phylum != null) {
      map['phylum'] = Variable<String>(phylum);
    }
    if (!nullToAbsent || classe != null) {
      map['classe'] = Variable<String>(classe);
    }
    if (!nullToAbsent || ordre != null) {
      map['ordre'] = Variable<String>(ordre);
    }
    if (!nullToAbsent || famille != null) {
      map['famille'] = Variable<String>(famille);
    }
    if (!nullToAbsent || sousFamille != null) {
      map['sous_famille'] = Variable<String>(sousFamille);
    }
    if (!nullToAbsent || tribu != null) {
      map['tribu'] = Variable<String>(tribu);
    }
    if (!nullToAbsent || cdTaxsup != null) {
      map['cd_taxsup'] = Variable<int>(cdTaxsup);
    }
    if (!nullToAbsent || cdSup != null) {
      map['cd_sup'] = Variable<int>(cdSup);
    }
    if (!nullToAbsent || lbNom != null) {
      map['lb_nom'] = Variable<String>(lbNom);
    }
    if (!nullToAbsent || lbAuteur != null) {
      map['lb_auteur'] = Variable<String>(lbAuteur);
    }
    map['nom_complet'] = Variable<String>(nomComplet);
    if (!nullToAbsent || nomCompletHtml != null) {
      map['nom_complet_html'] = Variable<String>(nomCompletHtml);
    }
    if (!nullToAbsent || nomVern != null) {
      map['nom_vern'] = Variable<String>(nomVern);
    }
    if (!nullToAbsent || nomValide != null) {
      map['nom_valide'] = Variable<String>(nomValide);
    }
    if (!nullToAbsent || nomVernEng != null) {
      map['nom_vern_eng'] = Variable<String>(nomVernEng);
    }
    if (!nullToAbsent || group1Inpn != null) {
      map['group1_inpn'] = Variable<String>(group1Inpn);
    }
    if (!nullToAbsent || group2Inpn != null) {
      map['group2_inpn'] = Variable<String>(group2Inpn);
    }
    if (!nullToAbsent || group3Inpn != null) {
      map['group3_inpn'] = Variable<String>(group3Inpn);
    }
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    return map;
  }

  TTaxrefsCompanion toCompanion(bool nullToAbsent) {
    return TTaxrefsCompanion(
      cdNom: Value(cdNom),
      cdRef:
          cdRef == null && nullToAbsent ? const Value.absent() : Value(cdRef),
      idStatut: idStatut == null && nullToAbsent
          ? const Value.absent()
          : Value(idStatut),
      idHabitat: idHabitat == null && nullToAbsent
          ? const Value.absent()
          : Value(idHabitat),
      idRang:
          idRang == null && nullToAbsent ? const Value.absent() : Value(idRang),
      regne:
          regne == null && nullToAbsent ? const Value.absent() : Value(regne),
      phylum:
          phylum == null && nullToAbsent ? const Value.absent() : Value(phylum),
      classe:
          classe == null && nullToAbsent ? const Value.absent() : Value(classe),
      ordre:
          ordre == null && nullToAbsent ? const Value.absent() : Value(ordre),
      famille: famille == null && nullToAbsent
          ? const Value.absent()
          : Value(famille),
      sousFamille: sousFamille == null && nullToAbsent
          ? const Value.absent()
          : Value(sousFamille),
      tribu:
          tribu == null && nullToAbsent ? const Value.absent() : Value(tribu),
      cdTaxsup: cdTaxsup == null && nullToAbsent
          ? const Value.absent()
          : Value(cdTaxsup),
      cdSup:
          cdSup == null && nullToAbsent ? const Value.absent() : Value(cdSup),
      lbNom:
          lbNom == null && nullToAbsent ? const Value.absent() : Value(lbNom),
      lbAuteur: lbAuteur == null && nullToAbsent
          ? const Value.absent()
          : Value(lbAuteur),
      nomComplet: Value(nomComplet),
      nomCompletHtml: nomCompletHtml == null && nullToAbsent
          ? const Value.absent()
          : Value(nomCompletHtml),
      nomVern: nomVern == null && nullToAbsent
          ? const Value.absent()
          : Value(nomVern),
      nomValide: nomValide == null && nullToAbsent
          ? const Value.absent()
          : Value(nomValide),
      nomVernEng: nomVernEng == null && nullToAbsent
          ? const Value.absent()
          : Value(nomVernEng),
      group1Inpn: group1Inpn == null && nullToAbsent
          ? const Value.absent()
          : Value(group1Inpn),
      group2Inpn: group2Inpn == null && nullToAbsent
          ? const Value.absent()
          : Value(group2Inpn),
      group3Inpn: group3Inpn == null && nullToAbsent
          ? const Value.absent()
          : Value(group3Inpn),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
    );
  }

  factory TTaxref.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TTaxref(
      cdNom: serializer.fromJson<int>(json['cdNom']),
      cdRef: serializer.fromJson<int?>(json['cdRef']),
      idStatut: serializer.fromJson<String?>(json['idStatut']),
      idHabitat: serializer.fromJson<int?>(json['idHabitat']),
      idRang: serializer.fromJson<String?>(json['idRang']),
      regne: serializer.fromJson<String?>(json['regne']),
      phylum: serializer.fromJson<String?>(json['phylum']),
      classe: serializer.fromJson<String?>(json['classe']),
      ordre: serializer.fromJson<String?>(json['ordre']),
      famille: serializer.fromJson<String?>(json['famille']),
      sousFamille: serializer.fromJson<String?>(json['sousFamille']),
      tribu: serializer.fromJson<String?>(json['tribu']),
      cdTaxsup: serializer.fromJson<int?>(json['cdTaxsup']),
      cdSup: serializer.fromJson<int?>(json['cdSup']),
      lbNom: serializer.fromJson<String?>(json['lbNom']),
      lbAuteur: serializer.fromJson<String?>(json['lbAuteur']),
      nomComplet: serializer.fromJson<String>(json['nomComplet']),
      nomCompletHtml: serializer.fromJson<String?>(json['nomCompletHtml']),
      nomVern: serializer.fromJson<String?>(json['nomVern']),
      nomValide: serializer.fromJson<String?>(json['nomValide']),
      nomVernEng: serializer.fromJson<String?>(json['nomVernEng']),
      group1Inpn: serializer.fromJson<String?>(json['group1Inpn']),
      group2Inpn: serializer.fromJson<String?>(json['group2Inpn']),
      group3Inpn: serializer.fromJson<String?>(json['group3Inpn']),
      url: serializer.fromJson<String?>(json['url']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cdNom': serializer.toJson<int>(cdNom),
      'cdRef': serializer.toJson<int?>(cdRef),
      'idStatut': serializer.toJson<String?>(idStatut),
      'idHabitat': serializer.toJson<int?>(idHabitat),
      'idRang': serializer.toJson<String?>(idRang),
      'regne': serializer.toJson<String?>(regne),
      'phylum': serializer.toJson<String?>(phylum),
      'classe': serializer.toJson<String?>(classe),
      'ordre': serializer.toJson<String?>(ordre),
      'famille': serializer.toJson<String?>(famille),
      'sousFamille': serializer.toJson<String?>(sousFamille),
      'tribu': serializer.toJson<String?>(tribu),
      'cdTaxsup': serializer.toJson<int?>(cdTaxsup),
      'cdSup': serializer.toJson<int?>(cdSup),
      'lbNom': serializer.toJson<String?>(lbNom),
      'lbAuteur': serializer.toJson<String?>(lbAuteur),
      'nomComplet': serializer.toJson<String>(nomComplet),
      'nomCompletHtml': serializer.toJson<String?>(nomCompletHtml),
      'nomVern': serializer.toJson<String?>(nomVern),
      'nomValide': serializer.toJson<String?>(nomValide),
      'nomVernEng': serializer.toJson<String?>(nomVernEng),
      'group1Inpn': serializer.toJson<String?>(group1Inpn),
      'group2Inpn': serializer.toJson<String?>(group2Inpn),
      'group3Inpn': serializer.toJson<String?>(group3Inpn),
      'url': serializer.toJson<String?>(url),
    };
  }

  TTaxref copyWith(
          {int? cdNom,
          Value<int?> cdRef = const Value.absent(),
          Value<String?> idStatut = const Value.absent(),
          Value<int?> idHabitat = const Value.absent(),
          Value<String?> idRang = const Value.absent(),
          Value<String?> regne = const Value.absent(),
          Value<String?> phylum = const Value.absent(),
          Value<String?> classe = const Value.absent(),
          Value<String?> ordre = const Value.absent(),
          Value<String?> famille = const Value.absent(),
          Value<String?> sousFamille = const Value.absent(),
          Value<String?> tribu = const Value.absent(),
          Value<int?> cdTaxsup = const Value.absent(),
          Value<int?> cdSup = const Value.absent(),
          Value<String?> lbNom = const Value.absent(),
          Value<String?> lbAuteur = const Value.absent(),
          String? nomComplet,
          Value<String?> nomCompletHtml = const Value.absent(),
          Value<String?> nomVern = const Value.absent(),
          Value<String?> nomValide = const Value.absent(),
          Value<String?> nomVernEng = const Value.absent(),
          Value<String?> group1Inpn = const Value.absent(),
          Value<String?> group2Inpn = const Value.absent(),
          Value<String?> group3Inpn = const Value.absent(),
          Value<String?> url = const Value.absent()}) =>
      TTaxref(
        cdNom: cdNom ?? this.cdNom,
        cdRef: cdRef.present ? cdRef.value : this.cdRef,
        idStatut: idStatut.present ? idStatut.value : this.idStatut,
        idHabitat: idHabitat.present ? idHabitat.value : this.idHabitat,
        idRang: idRang.present ? idRang.value : this.idRang,
        regne: regne.present ? regne.value : this.regne,
        phylum: phylum.present ? phylum.value : this.phylum,
        classe: classe.present ? classe.value : this.classe,
        ordre: ordre.present ? ordre.value : this.ordre,
        famille: famille.present ? famille.value : this.famille,
        sousFamille: sousFamille.present ? sousFamille.value : this.sousFamille,
        tribu: tribu.present ? tribu.value : this.tribu,
        cdTaxsup: cdTaxsup.present ? cdTaxsup.value : this.cdTaxsup,
        cdSup: cdSup.present ? cdSup.value : this.cdSup,
        lbNom: lbNom.present ? lbNom.value : this.lbNom,
        lbAuteur: lbAuteur.present ? lbAuteur.value : this.lbAuteur,
        nomComplet: nomComplet ?? this.nomComplet,
        nomCompletHtml:
            nomCompletHtml.present ? nomCompletHtml.value : this.nomCompletHtml,
        nomVern: nomVern.present ? nomVern.value : this.nomVern,
        nomValide: nomValide.present ? nomValide.value : this.nomValide,
        nomVernEng: nomVernEng.present ? nomVernEng.value : this.nomVernEng,
        group1Inpn: group1Inpn.present ? group1Inpn.value : this.group1Inpn,
        group2Inpn: group2Inpn.present ? group2Inpn.value : this.group2Inpn,
        group3Inpn: group3Inpn.present ? group3Inpn.value : this.group3Inpn,
        url: url.present ? url.value : this.url,
      );
  TTaxref copyWithCompanion(TTaxrefsCompanion data) {
    return TTaxref(
      cdNom: data.cdNom.present ? data.cdNom.value : this.cdNom,
      cdRef: data.cdRef.present ? data.cdRef.value : this.cdRef,
      idStatut: data.idStatut.present ? data.idStatut.value : this.idStatut,
      idHabitat: data.idHabitat.present ? data.idHabitat.value : this.idHabitat,
      idRang: data.idRang.present ? data.idRang.value : this.idRang,
      regne: data.regne.present ? data.regne.value : this.regne,
      phylum: data.phylum.present ? data.phylum.value : this.phylum,
      classe: data.classe.present ? data.classe.value : this.classe,
      ordre: data.ordre.present ? data.ordre.value : this.ordre,
      famille: data.famille.present ? data.famille.value : this.famille,
      sousFamille:
          data.sousFamille.present ? data.sousFamille.value : this.sousFamille,
      tribu: data.tribu.present ? data.tribu.value : this.tribu,
      cdTaxsup: data.cdTaxsup.present ? data.cdTaxsup.value : this.cdTaxsup,
      cdSup: data.cdSup.present ? data.cdSup.value : this.cdSup,
      lbNom: data.lbNom.present ? data.lbNom.value : this.lbNom,
      lbAuteur: data.lbAuteur.present ? data.lbAuteur.value : this.lbAuteur,
      nomComplet:
          data.nomComplet.present ? data.nomComplet.value : this.nomComplet,
      nomCompletHtml: data.nomCompletHtml.present
          ? data.nomCompletHtml.value
          : this.nomCompletHtml,
      nomVern: data.nomVern.present ? data.nomVern.value : this.nomVern,
      nomValide: data.nomValide.present ? data.nomValide.value : this.nomValide,
      nomVernEng:
          data.nomVernEng.present ? data.nomVernEng.value : this.nomVernEng,
      group1Inpn:
          data.group1Inpn.present ? data.group1Inpn.value : this.group1Inpn,
      group2Inpn:
          data.group2Inpn.present ? data.group2Inpn.value : this.group2Inpn,
      group3Inpn:
          data.group3Inpn.present ? data.group3Inpn.value : this.group3Inpn,
      url: data.url.present ? data.url.value : this.url,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TTaxref(')
          ..write('cdNom: $cdNom, ')
          ..write('cdRef: $cdRef, ')
          ..write('idStatut: $idStatut, ')
          ..write('idHabitat: $idHabitat, ')
          ..write('idRang: $idRang, ')
          ..write('regne: $regne, ')
          ..write('phylum: $phylum, ')
          ..write('classe: $classe, ')
          ..write('ordre: $ordre, ')
          ..write('famille: $famille, ')
          ..write('sousFamille: $sousFamille, ')
          ..write('tribu: $tribu, ')
          ..write('cdTaxsup: $cdTaxsup, ')
          ..write('cdSup: $cdSup, ')
          ..write('lbNom: $lbNom, ')
          ..write('lbAuteur: $lbAuteur, ')
          ..write('nomComplet: $nomComplet, ')
          ..write('nomCompletHtml: $nomCompletHtml, ')
          ..write('nomVern: $nomVern, ')
          ..write('nomValide: $nomValide, ')
          ..write('nomVernEng: $nomVernEng, ')
          ..write('group1Inpn: $group1Inpn, ')
          ..write('group2Inpn: $group2Inpn, ')
          ..write('group3Inpn: $group3Inpn, ')
          ..write('url: $url')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        cdNom,
        cdRef,
        idStatut,
        idHabitat,
        idRang,
        regne,
        phylum,
        classe,
        ordre,
        famille,
        sousFamille,
        tribu,
        cdTaxsup,
        cdSup,
        lbNom,
        lbAuteur,
        nomComplet,
        nomCompletHtml,
        nomVern,
        nomValide,
        nomVernEng,
        group1Inpn,
        group2Inpn,
        group3Inpn,
        url
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TTaxref &&
          other.cdNom == this.cdNom &&
          other.cdRef == this.cdRef &&
          other.idStatut == this.idStatut &&
          other.idHabitat == this.idHabitat &&
          other.idRang == this.idRang &&
          other.regne == this.regne &&
          other.phylum == this.phylum &&
          other.classe == this.classe &&
          other.ordre == this.ordre &&
          other.famille == this.famille &&
          other.sousFamille == this.sousFamille &&
          other.tribu == this.tribu &&
          other.cdTaxsup == this.cdTaxsup &&
          other.cdSup == this.cdSup &&
          other.lbNom == this.lbNom &&
          other.lbAuteur == this.lbAuteur &&
          other.nomComplet == this.nomComplet &&
          other.nomCompletHtml == this.nomCompletHtml &&
          other.nomVern == this.nomVern &&
          other.nomValide == this.nomValide &&
          other.nomVernEng == this.nomVernEng &&
          other.group1Inpn == this.group1Inpn &&
          other.group2Inpn == this.group2Inpn &&
          other.group3Inpn == this.group3Inpn &&
          other.url == this.url);
}

class TTaxrefsCompanion extends UpdateCompanion<TTaxref> {
  final Value<int> cdNom;
  final Value<int?> cdRef;
  final Value<String?> idStatut;
  final Value<int?> idHabitat;
  final Value<String?> idRang;
  final Value<String?> regne;
  final Value<String?> phylum;
  final Value<String?> classe;
  final Value<String?> ordre;
  final Value<String?> famille;
  final Value<String?> sousFamille;
  final Value<String?> tribu;
  final Value<int?> cdTaxsup;
  final Value<int?> cdSup;
  final Value<String?> lbNom;
  final Value<String?> lbAuteur;
  final Value<String> nomComplet;
  final Value<String?> nomCompletHtml;
  final Value<String?> nomVern;
  final Value<String?> nomValide;
  final Value<String?> nomVernEng;
  final Value<String?> group1Inpn;
  final Value<String?> group2Inpn;
  final Value<String?> group3Inpn;
  final Value<String?> url;
  const TTaxrefsCompanion({
    this.cdNom = const Value.absent(),
    this.cdRef = const Value.absent(),
    this.idStatut = const Value.absent(),
    this.idHabitat = const Value.absent(),
    this.idRang = const Value.absent(),
    this.regne = const Value.absent(),
    this.phylum = const Value.absent(),
    this.classe = const Value.absent(),
    this.ordre = const Value.absent(),
    this.famille = const Value.absent(),
    this.sousFamille = const Value.absent(),
    this.tribu = const Value.absent(),
    this.cdTaxsup = const Value.absent(),
    this.cdSup = const Value.absent(),
    this.lbNom = const Value.absent(),
    this.lbAuteur = const Value.absent(),
    this.nomComplet = const Value.absent(),
    this.nomCompletHtml = const Value.absent(),
    this.nomVern = const Value.absent(),
    this.nomValide = const Value.absent(),
    this.nomVernEng = const Value.absent(),
    this.group1Inpn = const Value.absent(),
    this.group2Inpn = const Value.absent(),
    this.group3Inpn = const Value.absent(),
    this.url = const Value.absent(),
  });
  TTaxrefsCompanion.insert({
    this.cdNom = const Value.absent(),
    this.cdRef = const Value.absent(),
    this.idStatut = const Value.absent(),
    this.idHabitat = const Value.absent(),
    this.idRang = const Value.absent(),
    this.regne = const Value.absent(),
    this.phylum = const Value.absent(),
    this.classe = const Value.absent(),
    this.ordre = const Value.absent(),
    this.famille = const Value.absent(),
    this.sousFamille = const Value.absent(),
    this.tribu = const Value.absent(),
    this.cdTaxsup = const Value.absent(),
    this.cdSup = const Value.absent(),
    this.lbNom = const Value.absent(),
    this.lbAuteur = const Value.absent(),
    required String nomComplet,
    this.nomCompletHtml = const Value.absent(),
    this.nomVern = const Value.absent(),
    this.nomValide = const Value.absent(),
    this.nomVernEng = const Value.absent(),
    this.group1Inpn = const Value.absent(),
    this.group2Inpn = const Value.absent(),
    this.group3Inpn = const Value.absent(),
    this.url = const Value.absent(),
  }) : nomComplet = Value(nomComplet);
  static Insertable<TTaxref> custom({
    Expression<int>? cdNom,
    Expression<int>? cdRef,
    Expression<String>? idStatut,
    Expression<int>? idHabitat,
    Expression<String>? idRang,
    Expression<String>? regne,
    Expression<String>? phylum,
    Expression<String>? classe,
    Expression<String>? ordre,
    Expression<String>? famille,
    Expression<String>? sousFamille,
    Expression<String>? tribu,
    Expression<int>? cdTaxsup,
    Expression<int>? cdSup,
    Expression<String>? lbNom,
    Expression<String>? lbAuteur,
    Expression<String>? nomComplet,
    Expression<String>? nomCompletHtml,
    Expression<String>? nomVern,
    Expression<String>? nomValide,
    Expression<String>? nomVernEng,
    Expression<String>? group1Inpn,
    Expression<String>? group2Inpn,
    Expression<String>? group3Inpn,
    Expression<String>? url,
  }) {
    return RawValuesInsertable({
      if (cdNom != null) 'cd_nom': cdNom,
      if (cdRef != null) 'cd_ref': cdRef,
      if (idStatut != null) 'id_statut': idStatut,
      if (idHabitat != null) 'id_habitat': idHabitat,
      if (idRang != null) 'id_rang': idRang,
      if (regne != null) 'regne': regne,
      if (phylum != null) 'phylum': phylum,
      if (classe != null) 'classe': classe,
      if (ordre != null) 'ordre': ordre,
      if (famille != null) 'famille': famille,
      if (sousFamille != null) 'sous_famille': sousFamille,
      if (tribu != null) 'tribu': tribu,
      if (cdTaxsup != null) 'cd_taxsup': cdTaxsup,
      if (cdSup != null) 'cd_sup': cdSup,
      if (lbNom != null) 'lb_nom': lbNom,
      if (lbAuteur != null) 'lb_auteur': lbAuteur,
      if (nomComplet != null) 'nom_complet': nomComplet,
      if (nomCompletHtml != null) 'nom_complet_html': nomCompletHtml,
      if (nomVern != null) 'nom_vern': nomVern,
      if (nomValide != null) 'nom_valide': nomValide,
      if (nomVernEng != null) 'nom_vern_eng': nomVernEng,
      if (group1Inpn != null) 'group1_inpn': group1Inpn,
      if (group2Inpn != null) 'group2_inpn': group2Inpn,
      if (group3Inpn != null) 'group3_inpn': group3Inpn,
      if (url != null) 'url': url,
    });
  }

  TTaxrefsCompanion copyWith(
      {Value<int>? cdNom,
      Value<int?>? cdRef,
      Value<String?>? idStatut,
      Value<int?>? idHabitat,
      Value<String?>? idRang,
      Value<String?>? regne,
      Value<String?>? phylum,
      Value<String?>? classe,
      Value<String?>? ordre,
      Value<String?>? famille,
      Value<String?>? sousFamille,
      Value<String?>? tribu,
      Value<int?>? cdTaxsup,
      Value<int?>? cdSup,
      Value<String?>? lbNom,
      Value<String?>? lbAuteur,
      Value<String>? nomComplet,
      Value<String?>? nomCompletHtml,
      Value<String?>? nomVern,
      Value<String?>? nomValide,
      Value<String?>? nomVernEng,
      Value<String?>? group1Inpn,
      Value<String?>? group2Inpn,
      Value<String?>? group3Inpn,
      Value<String?>? url}) {
    return TTaxrefsCompanion(
      cdNom: cdNom ?? this.cdNom,
      cdRef: cdRef ?? this.cdRef,
      idStatut: idStatut ?? this.idStatut,
      idHabitat: idHabitat ?? this.idHabitat,
      idRang: idRang ?? this.idRang,
      regne: regne ?? this.regne,
      phylum: phylum ?? this.phylum,
      classe: classe ?? this.classe,
      ordre: ordre ?? this.ordre,
      famille: famille ?? this.famille,
      sousFamille: sousFamille ?? this.sousFamille,
      tribu: tribu ?? this.tribu,
      cdTaxsup: cdTaxsup ?? this.cdTaxsup,
      cdSup: cdSup ?? this.cdSup,
      lbNom: lbNom ?? this.lbNom,
      lbAuteur: lbAuteur ?? this.lbAuteur,
      nomComplet: nomComplet ?? this.nomComplet,
      nomCompletHtml: nomCompletHtml ?? this.nomCompletHtml,
      nomVern: nomVern ?? this.nomVern,
      nomValide: nomValide ?? this.nomValide,
      nomVernEng: nomVernEng ?? this.nomVernEng,
      group1Inpn: group1Inpn ?? this.group1Inpn,
      group2Inpn: group2Inpn ?? this.group2Inpn,
      group3Inpn: group3Inpn ?? this.group3Inpn,
      url: url ?? this.url,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cdNom.present) {
      map['cd_nom'] = Variable<int>(cdNom.value);
    }
    if (cdRef.present) {
      map['cd_ref'] = Variable<int>(cdRef.value);
    }
    if (idStatut.present) {
      map['id_statut'] = Variable<String>(idStatut.value);
    }
    if (idHabitat.present) {
      map['id_habitat'] = Variable<int>(idHabitat.value);
    }
    if (idRang.present) {
      map['id_rang'] = Variable<String>(idRang.value);
    }
    if (regne.present) {
      map['regne'] = Variable<String>(regne.value);
    }
    if (phylum.present) {
      map['phylum'] = Variable<String>(phylum.value);
    }
    if (classe.present) {
      map['classe'] = Variable<String>(classe.value);
    }
    if (ordre.present) {
      map['ordre'] = Variable<String>(ordre.value);
    }
    if (famille.present) {
      map['famille'] = Variable<String>(famille.value);
    }
    if (sousFamille.present) {
      map['sous_famille'] = Variable<String>(sousFamille.value);
    }
    if (tribu.present) {
      map['tribu'] = Variable<String>(tribu.value);
    }
    if (cdTaxsup.present) {
      map['cd_taxsup'] = Variable<int>(cdTaxsup.value);
    }
    if (cdSup.present) {
      map['cd_sup'] = Variable<int>(cdSup.value);
    }
    if (lbNom.present) {
      map['lb_nom'] = Variable<String>(lbNom.value);
    }
    if (lbAuteur.present) {
      map['lb_auteur'] = Variable<String>(lbAuteur.value);
    }
    if (nomComplet.present) {
      map['nom_complet'] = Variable<String>(nomComplet.value);
    }
    if (nomCompletHtml.present) {
      map['nom_complet_html'] = Variable<String>(nomCompletHtml.value);
    }
    if (nomVern.present) {
      map['nom_vern'] = Variable<String>(nomVern.value);
    }
    if (nomValide.present) {
      map['nom_valide'] = Variable<String>(nomValide.value);
    }
    if (nomVernEng.present) {
      map['nom_vern_eng'] = Variable<String>(nomVernEng.value);
    }
    if (group1Inpn.present) {
      map['group1_inpn'] = Variable<String>(group1Inpn.value);
    }
    if (group2Inpn.present) {
      map['group2_inpn'] = Variable<String>(group2Inpn.value);
    }
    if (group3Inpn.present) {
      map['group3_inpn'] = Variable<String>(group3Inpn.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TTaxrefsCompanion(')
          ..write('cdNom: $cdNom, ')
          ..write('cdRef: $cdRef, ')
          ..write('idStatut: $idStatut, ')
          ..write('idHabitat: $idHabitat, ')
          ..write('idRang: $idRang, ')
          ..write('regne: $regne, ')
          ..write('phylum: $phylum, ')
          ..write('classe: $classe, ')
          ..write('ordre: $ordre, ')
          ..write('famille: $famille, ')
          ..write('sousFamille: $sousFamille, ')
          ..write('tribu: $tribu, ')
          ..write('cdTaxsup: $cdTaxsup, ')
          ..write('cdSup: $cdSup, ')
          ..write('lbNom: $lbNom, ')
          ..write('lbAuteur: $lbAuteur, ')
          ..write('nomComplet: $nomComplet, ')
          ..write('nomCompletHtml: $nomCompletHtml, ')
          ..write('nomVern: $nomVern, ')
          ..write('nomValide: $nomValide, ')
          ..write('nomVernEng: $nomVernEng, ')
          ..write('group1Inpn: $group1Inpn, ')
          ..write('group2Inpn: $group2Inpn, ')
          ..write('group3Inpn: $group3Inpn, ')
          ..write('url: $url')
          ..write(')'))
        .toString();
  }
}

class $BibListesTableTable extends BibListesTable
    with TableInfo<$BibListesTableTable, TBibListe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BibListesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idListeMeta =
      const VerificationMeta('idListe');
  @override
  late final GeneratedColumn<int> idListe = GeneratedColumn<int>(
      'id_liste', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _codeListeMeta =
      const VerificationMeta('codeListe');
  @override
  late final GeneratedColumn<String> codeListe = GeneratedColumn<String>(
      'code_liste', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nomListeMeta =
      const VerificationMeta('nomListe');
  @override
  late final GeneratedColumn<String> nomListe = GeneratedColumn<String>(
      'nom_liste', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descListeMeta =
      const VerificationMeta('descListe');
  @override
  late final GeneratedColumn<String> descListe = GeneratedColumn<String>(
      'desc_liste', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _regneMeta = const VerificationMeta('regne');
  @override
  late final GeneratedColumn<String> regne = GeneratedColumn<String>(
      'regne', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _group2InpnMeta =
      const VerificationMeta('group2Inpn');
  @override
  late final GeneratedColumn<String> group2Inpn = GeneratedColumn<String>(
      'group2_inpn', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [idListe, codeListe, nomListe, descListe, regne, group2Inpn];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bib_listes_table';
  @override
  VerificationContext validateIntegrity(Insertable<TBibListe> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_liste')) {
      context.handle(_idListeMeta,
          idListe.isAcceptableOrUnknown(data['id_liste']!, _idListeMeta));
    }
    if (data.containsKey('code_liste')) {
      context.handle(_codeListeMeta,
          codeListe.isAcceptableOrUnknown(data['code_liste']!, _codeListeMeta));
    }
    if (data.containsKey('nom_liste')) {
      context.handle(_nomListeMeta,
          nomListe.isAcceptableOrUnknown(data['nom_liste']!, _nomListeMeta));
    } else if (isInserting) {
      context.missing(_nomListeMeta);
    }
    if (data.containsKey('desc_liste')) {
      context.handle(_descListeMeta,
          descListe.isAcceptableOrUnknown(data['desc_liste']!, _descListeMeta));
    }
    if (data.containsKey('regne')) {
      context.handle(
          _regneMeta, regne.isAcceptableOrUnknown(data['regne']!, _regneMeta));
    }
    if (data.containsKey('group2_inpn')) {
      context.handle(
          _group2InpnMeta,
          group2Inpn.isAcceptableOrUnknown(
              data['group2_inpn']!, _group2InpnMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idListe};
  @override
  TBibListe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TBibListe(
      idListe: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_liste'])!,
      codeListe: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code_liste']),
      nomListe: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nom_liste'])!,
      descListe: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}desc_liste']),
      regne: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}regne']),
      group2Inpn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group2_inpn']),
    );
  }

  @override
  $BibListesTableTable createAlias(String alias) {
    return $BibListesTableTable(attachedDatabase, alias);
  }
}

class TBibListe extends DataClass implements Insertable<TBibListe> {
  final int idListe;
  final String? codeListe;
  final String nomListe;
  final String? descListe;
  final String? regne;
  final String? group2Inpn;
  const TBibListe(
      {required this.idListe,
      this.codeListe,
      required this.nomListe,
      this.descListe,
      this.regne,
      this.group2Inpn});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_liste'] = Variable<int>(idListe);
    if (!nullToAbsent || codeListe != null) {
      map['code_liste'] = Variable<String>(codeListe);
    }
    map['nom_liste'] = Variable<String>(nomListe);
    if (!nullToAbsent || descListe != null) {
      map['desc_liste'] = Variable<String>(descListe);
    }
    if (!nullToAbsent || regne != null) {
      map['regne'] = Variable<String>(regne);
    }
    if (!nullToAbsent || group2Inpn != null) {
      map['group2_inpn'] = Variable<String>(group2Inpn);
    }
    return map;
  }

  BibListesTableCompanion toCompanion(bool nullToAbsent) {
    return BibListesTableCompanion(
      idListe: Value(idListe),
      codeListe: codeListe == null && nullToAbsent
          ? const Value.absent()
          : Value(codeListe),
      nomListe: Value(nomListe),
      descListe: descListe == null && nullToAbsent
          ? const Value.absent()
          : Value(descListe),
      regne:
          regne == null && nullToAbsent ? const Value.absent() : Value(regne),
      group2Inpn: group2Inpn == null && nullToAbsent
          ? const Value.absent()
          : Value(group2Inpn),
    );
  }

  factory TBibListe.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TBibListe(
      idListe: serializer.fromJson<int>(json['idListe']),
      codeListe: serializer.fromJson<String?>(json['codeListe']),
      nomListe: serializer.fromJson<String>(json['nomListe']),
      descListe: serializer.fromJson<String?>(json['descListe']),
      regne: serializer.fromJson<String?>(json['regne']),
      group2Inpn: serializer.fromJson<String?>(json['group2Inpn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idListe': serializer.toJson<int>(idListe),
      'codeListe': serializer.toJson<String?>(codeListe),
      'nomListe': serializer.toJson<String>(nomListe),
      'descListe': serializer.toJson<String?>(descListe),
      'regne': serializer.toJson<String?>(regne),
      'group2Inpn': serializer.toJson<String?>(group2Inpn),
    };
  }

  TBibListe copyWith(
          {int? idListe,
          Value<String?> codeListe = const Value.absent(),
          String? nomListe,
          Value<String?> descListe = const Value.absent(),
          Value<String?> regne = const Value.absent(),
          Value<String?> group2Inpn = const Value.absent()}) =>
      TBibListe(
        idListe: idListe ?? this.idListe,
        codeListe: codeListe.present ? codeListe.value : this.codeListe,
        nomListe: nomListe ?? this.nomListe,
        descListe: descListe.present ? descListe.value : this.descListe,
        regne: regne.present ? regne.value : this.regne,
        group2Inpn: group2Inpn.present ? group2Inpn.value : this.group2Inpn,
      );
  TBibListe copyWithCompanion(BibListesTableCompanion data) {
    return TBibListe(
      idListe: data.idListe.present ? data.idListe.value : this.idListe,
      codeListe: data.codeListe.present ? data.codeListe.value : this.codeListe,
      nomListe: data.nomListe.present ? data.nomListe.value : this.nomListe,
      descListe: data.descListe.present ? data.descListe.value : this.descListe,
      regne: data.regne.present ? data.regne.value : this.regne,
      group2Inpn:
          data.group2Inpn.present ? data.group2Inpn.value : this.group2Inpn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TBibListe(')
          ..write('idListe: $idListe, ')
          ..write('codeListe: $codeListe, ')
          ..write('nomListe: $nomListe, ')
          ..write('descListe: $descListe, ')
          ..write('regne: $regne, ')
          ..write('group2Inpn: $group2Inpn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(idListe, codeListe, nomListe, descListe, regne, group2Inpn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TBibListe &&
          other.idListe == this.idListe &&
          other.codeListe == this.codeListe &&
          other.nomListe == this.nomListe &&
          other.descListe == this.descListe &&
          other.regne == this.regne &&
          other.group2Inpn == this.group2Inpn);
}

class BibListesTableCompanion extends UpdateCompanion<TBibListe> {
  final Value<int> idListe;
  final Value<String?> codeListe;
  final Value<String> nomListe;
  final Value<String?> descListe;
  final Value<String?> regne;
  final Value<String?> group2Inpn;
  const BibListesTableCompanion({
    this.idListe = const Value.absent(),
    this.codeListe = const Value.absent(),
    this.nomListe = const Value.absent(),
    this.descListe = const Value.absent(),
    this.regne = const Value.absent(),
    this.group2Inpn = const Value.absent(),
  });
  BibListesTableCompanion.insert({
    this.idListe = const Value.absent(),
    this.codeListe = const Value.absent(),
    required String nomListe,
    this.descListe = const Value.absent(),
    this.regne = const Value.absent(),
    this.group2Inpn = const Value.absent(),
  }) : nomListe = Value(nomListe);
  static Insertable<TBibListe> custom({
    Expression<int>? idListe,
    Expression<String>? codeListe,
    Expression<String>? nomListe,
    Expression<String>? descListe,
    Expression<String>? regne,
    Expression<String>? group2Inpn,
  }) {
    return RawValuesInsertable({
      if (idListe != null) 'id_liste': idListe,
      if (codeListe != null) 'code_liste': codeListe,
      if (nomListe != null) 'nom_liste': nomListe,
      if (descListe != null) 'desc_liste': descListe,
      if (regne != null) 'regne': regne,
      if (group2Inpn != null) 'group2_inpn': group2Inpn,
    });
  }

  BibListesTableCompanion copyWith(
      {Value<int>? idListe,
      Value<String?>? codeListe,
      Value<String>? nomListe,
      Value<String?>? descListe,
      Value<String?>? regne,
      Value<String?>? group2Inpn}) {
    return BibListesTableCompanion(
      idListe: idListe ?? this.idListe,
      codeListe: codeListe ?? this.codeListe,
      nomListe: nomListe ?? this.nomListe,
      descListe: descListe ?? this.descListe,
      regne: regne ?? this.regne,
      group2Inpn: group2Inpn ?? this.group2Inpn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idListe.present) {
      map['id_liste'] = Variable<int>(idListe.value);
    }
    if (codeListe.present) {
      map['code_liste'] = Variable<String>(codeListe.value);
    }
    if (nomListe.present) {
      map['nom_liste'] = Variable<String>(nomListe.value);
    }
    if (descListe.present) {
      map['desc_liste'] = Variable<String>(descListe.value);
    }
    if (regne.present) {
      map['regne'] = Variable<String>(regne.value);
    }
    if (group2Inpn.present) {
      map['group2_inpn'] = Variable<String>(group2Inpn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BibListesTableCompanion(')
          ..write('idListe: $idListe, ')
          ..write('codeListe: $codeListe, ')
          ..write('nomListe: $nomListe, ')
          ..write('descListe: $descListe, ')
          ..write('regne: $regne, ')
          ..write('group2Inpn: $group2Inpn')
          ..write(')'))
        .toString();
  }
}

class $CorTaxonListeTableTable extends CorTaxonListeTable
    with TableInfo<$CorTaxonListeTableTable, CorTaxonListe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CorTaxonListeTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idListeMeta =
      const VerificationMeta('idListe');
  @override
  late final GeneratedColumn<int> idListe = GeneratedColumn<int>(
      'id_liste', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES bib_listes_table (id_liste)'));
  static const VerificationMeta _cdNomMeta = const VerificationMeta('cdNom');
  @override
  late final GeneratedColumn<int> cdNom = GeneratedColumn<int>(
      'cd_nom', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES t_taxrefs (cd_nom)'));
  @override
  List<GeneratedColumn> get $columns => [idListe, cdNom];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cor_taxon_liste_table';
  @override
  VerificationContext validateIntegrity(Insertable<CorTaxonListe> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id_liste')) {
      context.handle(_idListeMeta,
          idListe.isAcceptableOrUnknown(data['id_liste']!, _idListeMeta));
    } else if (isInserting) {
      context.missing(_idListeMeta);
    }
    if (data.containsKey('cd_nom')) {
      context.handle(
          _cdNomMeta, cdNom.isAcceptableOrUnknown(data['cd_nom']!, _cdNomMeta));
    } else if (isInserting) {
      context.missing(_cdNomMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {idListe, cdNom};
  @override
  CorTaxonListe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CorTaxonListe(
      idListe: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_liste'])!,
      cdNom: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cd_nom'])!,
    );
  }

  @override
  $CorTaxonListeTableTable createAlias(String alias) {
    return $CorTaxonListeTableTable(attachedDatabase, alias);
  }
}

class CorTaxonListe extends DataClass implements Insertable<CorTaxonListe> {
  final int idListe;
  final int cdNom;
  const CorTaxonListe({required this.idListe, required this.cdNom});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id_liste'] = Variable<int>(idListe);
    map['cd_nom'] = Variable<int>(cdNom);
    return map;
  }

  CorTaxonListeTableCompanion toCompanion(bool nullToAbsent) {
    return CorTaxonListeTableCompanion(
      idListe: Value(idListe),
      cdNom: Value(cdNom),
    );
  }

  factory CorTaxonListe.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CorTaxonListe(
      idListe: serializer.fromJson<int>(json['idListe']),
      cdNom: serializer.fromJson<int>(json['cdNom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idListe': serializer.toJson<int>(idListe),
      'cdNom': serializer.toJson<int>(cdNom),
    };
  }

  CorTaxonListe copyWith({int? idListe, int? cdNom}) => CorTaxonListe(
        idListe: idListe ?? this.idListe,
        cdNom: cdNom ?? this.cdNom,
      );
  CorTaxonListe copyWithCompanion(CorTaxonListeTableCompanion data) {
    return CorTaxonListe(
      idListe: data.idListe.present ? data.idListe.value : this.idListe,
      cdNom: data.cdNom.present ? data.cdNom.value : this.cdNom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CorTaxonListe(')
          ..write('idListe: $idListe, ')
          ..write('cdNom: $cdNom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(idListe, cdNom);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CorTaxonListe &&
          other.idListe == this.idListe &&
          other.cdNom == this.cdNom);
}

class CorTaxonListeTableCompanion extends UpdateCompanion<CorTaxonListe> {
  final Value<int> idListe;
  final Value<int> cdNom;
  final Value<int> rowid;
  const CorTaxonListeTableCompanion({
    this.idListe = const Value.absent(),
    this.cdNom = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CorTaxonListeTableCompanion.insert({
    required int idListe,
    required int cdNom,
    this.rowid = const Value.absent(),
  })  : idListe = Value(idListe),
        cdNom = Value(cdNom);
  static Insertable<CorTaxonListe> custom({
    Expression<int>? idListe,
    Expression<int>? cdNom,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (idListe != null) 'id_liste': idListe,
      if (cdNom != null) 'cd_nom': cdNom,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CorTaxonListeTableCompanion copyWith(
      {Value<int>? idListe, Value<int>? cdNom, Value<int>? rowid}) {
    return CorTaxonListeTableCompanion(
      idListe: idListe ?? this.idListe,
      cdNom: cdNom ?? this.cdNom,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (idListe.present) {
      map['id_liste'] = Variable<int>(idListe.value);
    }
    if (cdNom.present) {
      map['cd_nom'] = Variable<int>(cdNom.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CorTaxonListeTableCompanion(')
          ..write('idListe: $idListe, ')
          ..write('cdNom: $cdNom, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TModulesTable tModules = $TModulesTable(this);
  late final $TBaseSitesTable tBaseSites = $TBaseSitesTable(this);
  late final $TNomenclaturesTable tNomenclatures = $TNomenclaturesTable(this);
  late final $TDatasetsTable tDatasets = $TDatasetsTable(this);
  late final $TModuleComplementsTable tModuleComplements =
      $TModuleComplementsTable(this);
  late final $TSitesGroupsTable tSitesGroups = $TSitesGroupsTable(this);
  late final $TSiteComplementsTable tSiteComplements =
      $TSiteComplementsTable(this);
  late final $TVisitComplementsTable tVisitComplements =
      $TVisitComplementsTable(this);
  late final $TObservationsTable tObservations = $TObservationsTable(this);
  late final $TObservationComplementsTable tObservationComplements =
      $TObservationComplementsTable(this);
  late final $TObservationDetailsTable tObservationDetails =
      $TObservationDetailsTable(this);
  late final $BibTablesLocationsTable bibTablesLocations =
      $BibTablesLocationsTable(this);
  late final $BibNomenclaturesTypesTableTable bibNomenclaturesTypesTable =
      $BibNomenclaturesTypesTableTable(this);
  late final $BibTypeSitesTableTable bibTypeSitesTable =
      $BibTypeSitesTableTable(this);
  late final $TObjectsTable tObjects = $TObjectsTable(this);
  late final $TActionsTable tActions = $TActionsTable(this);
  late final $TPermissionsAvailableTable tPermissionsAvailable =
      $TPermissionsAvailableTable(this);
  late final $TPermissionsTable tPermissions = $TPermissionsTable(this);
  late final $CorSiteModuleTableTable corSiteModuleTable =
      $CorSiteModuleTableTable(this);
  late final $CorSitesGroupModuleTableTable corSitesGroupModuleTable =
      $CorSitesGroupModuleTableTable(this);
  late final $CorObjectModuleTableTable corObjectModuleTable =
      $CorObjectModuleTableTable(this);
  late final $TBaseVisitsTable tBaseVisits = $TBaseVisitsTable(this);
  late final $CorVisitObserverTable corVisitObserver =
      $CorVisitObserverTable(this);
  late final $CorSiteTypeTableTable corSiteTypeTable =
      $CorSiteTypeTableTable(this);
  late final $CorModuleDatasetTableTable corModuleDatasetTable =
      $CorModuleDatasetTableTable(this);
  late final $TTaxrefsTable tTaxrefs = $TTaxrefsTable(this);
  late final $BibListesTableTable bibListesTable = $BibListesTableTable(this);
  late final $CorTaxonListeTableTable corTaxonListeTable =
      $CorTaxonListeTableTable(this);
  late final ModulesDao modulesDao = ModulesDao(this as AppDatabase);
  late final TNomenclaturesDao tNomenclaturesDao =
      TNomenclaturesDao(this as AppDatabase);
  late final SitesDao sitesDao = SitesDao(this as AppDatabase);
  late final TDatasetsDao tDatasetsDao = TDatasetsDao(this as AppDatabase);
  late final VisitesDao visitesDao = VisitesDao(this as AppDatabase);
  late final ObservationDao observationDao =
      ObservationDao(this as AppDatabase);
  late final ObservationDetailDao observationDetailDao =
      ObservationDetailDao(this as AppDatabase);
  late final BibNomenclaturesTypesDao bibNomenclaturesTypesDao =
      BibNomenclaturesTypesDao(this as AppDatabase);
  late final TaxonDao taxonDao = TaxonDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        tModules,
        tBaseSites,
        tNomenclatures,
        tDatasets,
        tModuleComplements,
        tSitesGroups,
        tSiteComplements,
        tVisitComplements,
        tObservations,
        tObservationComplements,
        tObservationDetails,
        bibTablesLocations,
        bibNomenclaturesTypesTable,
        bibTypeSitesTable,
        tObjects,
        tActions,
        tPermissionsAvailable,
        tPermissions,
        corSiteModuleTable,
        corSitesGroupModuleTable,
        corObjectModuleTable,
        tBaseVisits,
        corVisitObserver,
        corSiteTypeTable,
        corModuleDatasetTable,
        tTaxrefs,
        bibListesTable,
        corTaxonListeTable
      ];
}

typedef $$TModulesTableCreateCompanionBuilder = TModulesCompanion Function({
  Value<int> idModule,
  Value<String?> moduleCode,
  Value<String?> moduleLabel,
  Value<String?> moduleDesc,
  Value<bool?> activeFrontend,
  Value<bool?> activeBackend,
  Value<bool> downloaded,
});
typedef $$TModulesTableUpdateCompanionBuilder = TModulesCompanion Function({
  Value<int> idModule,
  Value<String?> moduleCode,
  Value<String?> moduleLabel,
  Value<String?> moduleDesc,
  Value<bool?> activeFrontend,
  Value<bool?> activeBackend,
  Value<bool> downloaded,
});

class $$TModulesTableFilterComposer
    extends Composer<_$AppDatabase, $TModulesTable> {
  $$TModulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idModule => $composableBuilder(
      column: $table.idModule, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get moduleCode => $composableBuilder(
      column: $table.moduleCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get moduleLabel => $composableBuilder(
      column: $table.moduleLabel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get moduleDesc => $composableBuilder(
      column: $table.moduleDesc, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get activeFrontend => $composableBuilder(
      column: $table.activeFrontend,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get activeBackend => $composableBuilder(
      column: $table.activeBackend, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get downloaded => $composableBuilder(
      column: $table.downloaded, builder: (column) => ColumnFilters(column));
}

class $$TModulesTableOrderingComposer
    extends Composer<_$AppDatabase, $TModulesTable> {
  $$TModulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idModule => $composableBuilder(
      column: $table.idModule, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get moduleCode => $composableBuilder(
      column: $table.moduleCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get moduleLabel => $composableBuilder(
      column: $table.moduleLabel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get moduleDesc => $composableBuilder(
      column: $table.moduleDesc, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get activeFrontend => $composableBuilder(
      column: $table.activeFrontend,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get activeBackend => $composableBuilder(
      column: $table.activeBackend,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get downloaded => $composableBuilder(
      column: $table.downloaded, builder: (column) => ColumnOrderings(column));
}

class $$TModulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TModulesTable> {
  $$TModulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idModule =>
      $composableBuilder(column: $table.idModule, builder: (column) => column);

  GeneratedColumn<String> get moduleCode => $composableBuilder(
      column: $table.moduleCode, builder: (column) => column);

  GeneratedColumn<String> get moduleLabel => $composableBuilder(
      column: $table.moduleLabel, builder: (column) => column);

  GeneratedColumn<String> get moduleDesc => $composableBuilder(
      column: $table.moduleDesc, builder: (column) => column);

  GeneratedColumn<bool> get activeFrontend => $composableBuilder(
      column: $table.activeFrontend, builder: (column) => column);

  GeneratedColumn<bool> get activeBackend => $composableBuilder(
      column: $table.activeBackend, builder: (column) => column);

  GeneratedColumn<bool> get downloaded => $composableBuilder(
      column: $table.downloaded, builder: (column) => column);
}

class $$TModulesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TModulesTable,
    TModule,
    $$TModulesTableFilterComposer,
    $$TModulesTableOrderingComposer,
    $$TModulesTableAnnotationComposer,
    $$TModulesTableCreateCompanionBuilder,
    $$TModulesTableUpdateCompanionBuilder,
    (TModule, BaseReferences<_$AppDatabase, $TModulesTable, TModule>),
    TModule,
    PrefetchHooks Function()> {
  $$TModulesTableTableManager(_$AppDatabase db, $TModulesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TModulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TModulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TModulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> idModule = const Value.absent(),
            Value<String?> moduleCode = const Value.absent(),
            Value<String?> moduleLabel = const Value.absent(),
            Value<String?> moduleDesc = const Value.absent(),
            Value<bool?> activeFrontend = const Value.absent(),
            Value<bool?> activeBackend = const Value.absent(),
            Value<bool> downloaded = const Value.absent(),
          }) =>
              TModulesCompanion(
            idModule: idModule,
            moduleCode: moduleCode,
            moduleLabel: moduleLabel,
            moduleDesc: moduleDesc,
            activeFrontend: activeFrontend,
            activeBackend: activeBackend,
            downloaded: downloaded,
          ),
          createCompanionCallback: ({
            Value<int> idModule = const Value.absent(),
            Value<String?> moduleCode = const Value.absent(),
            Value<String?> moduleLabel = const Value.absent(),
            Value<String?> moduleDesc = const Value.absent(),
            Value<bool?> activeFrontend = const Value.absent(),
            Value<bool?> activeBackend = const Value.absent(),
            Value<bool> downloaded = const Value.absent(),
          }) =>
              TModulesCompanion.insert(
            idModule: idModule,
            moduleCode: moduleCode,
            moduleLabel: moduleLabel,
            moduleDesc: moduleDesc,
            activeFrontend: activeFrontend,
            activeBackend: activeBackend,
            downloaded: downloaded,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TModulesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TModulesTable,
    TModule,
    $$TModulesTableFilterComposer,
    $$TModulesTableOrderingComposer,
    $$TModulesTableAnnotationComposer,
    $$TModulesTableCreateCompanionBuilder,
    $$TModulesTableUpdateCompanionBuilder,
    (TModule, BaseReferences<_$AppDatabase, $TModulesTable, TModule>),
    TModule,
    PrefetchHooks Function()>;
typedef $$TBaseSitesTableCreateCompanionBuilder = TBaseSitesCompanion Function({
  Value<int> idBaseSite,
  Value<int?> idInventor,
  Value<int?> idDigitiser,
  Value<String?> baseSiteName,
  Value<String?> baseSiteDescription,
  Value<String?> baseSiteCode,
  Value<DateTime?> firstUseDate,
  Value<String?> geom,
  Value<String?> uuidBaseSite,
  Value<DateTime?> metaCreateDate,
  Value<DateTime?> metaUpdateDate,
  Value<int?> altitudeMin,
  Value<int?> altitudeMax,
});
typedef $$TBaseSitesTableUpdateCompanionBuilder = TBaseSitesCompanion Function({
  Value<int> idBaseSite,
  Value<int?> idInventor,
  Value<int?> idDigitiser,
  Value<String?> baseSiteName,
  Value<String?> baseSiteDescription,
  Value<String?> baseSiteCode,
  Value<DateTime?> firstUseDate,
  Value<String?> geom,
  Value<String?> uuidBaseSite,
  Value<DateTime?> metaCreateDate,
  Value<DateTime?> metaUpdateDate,
  Value<int?> altitudeMin,
  Value<int?> altitudeMax,
});

class $$TBaseSitesTableFilterComposer
    extends Composer<_$AppDatabase, $TBaseSitesTable> {
  $$TBaseSitesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idBaseSite => $composableBuilder(
      column: $table.idBaseSite, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idInventor => $composableBuilder(
      column: $table.idInventor, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idDigitiser => $composableBuilder(
      column: $table.idDigitiser, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get baseSiteName => $composableBuilder(
      column: $table.baseSiteName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get baseSiteDescription => $composableBuilder(
      column: $table.baseSiteDescription,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get baseSiteCode => $composableBuilder(
      column: $table.baseSiteCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get firstUseDate => $composableBuilder(
      column: $table.firstUseDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get geom => $composableBuilder(
      column: $table.geom, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuidBaseSite => $composableBuilder(
      column: $table.uuidBaseSite, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get metaCreateDate => $composableBuilder(
      column: $table.metaCreateDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get metaUpdateDate => $composableBuilder(
      column: $table.metaUpdateDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get altitudeMin => $composableBuilder(
      column: $table.altitudeMin, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get altitudeMax => $composableBuilder(
      column: $table.altitudeMax, builder: (column) => ColumnFilters(column));
}

class $$TBaseSitesTableOrderingComposer
    extends Composer<_$AppDatabase, $TBaseSitesTable> {
  $$TBaseSitesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idBaseSite => $composableBuilder(
      column: $table.idBaseSite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idInventor => $composableBuilder(
      column: $table.idInventor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idDigitiser => $composableBuilder(
      column: $table.idDigitiser, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get baseSiteName => $composableBuilder(
      column: $table.baseSiteName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get baseSiteDescription => $composableBuilder(
      column: $table.baseSiteDescription,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get baseSiteCode => $composableBuilder(
      column: $table.baseSiteCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get firstUseDate => $composableBuilder(
      column: $table.firstUseDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get geom => $composableBuilder(
      column: $table.geom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuidBaseSite => $composableBuilder(
      column: $table.uuidBaseSite,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get metaCreateDate => $composableBuilder(
      column: $table.metaCreateDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get metaUpdateDate => $composableBuilder(
      column: $table.metaUpdateDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get altitudeMin => $composableBuilder(
      column: $table.altitudeMin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get altitudeMax => $composableBuilder(
      column: $table.altitudeMax, builder: (column) => ColumnOrderings(column));
}

class $$TBaseSitesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TBaseSitesTable> {
  $$TBaseSitesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idBaseSite => $composableBuilder(
      column: $table.idBaseSite, builder: (column) => column);

  GeneratedColumn<int> get idInventor => $composableBuilder(
      column: $table.idInventor, builder: (column) => column);

  GeneratedColumn<int> get idDigitiser => $composableBuilder(
      column: $table.idDigitiser, builder: (column) => column);

  GeneratedColumn<String> get baseSiteName => $composableBuilder(
      column: $table.baseSiteName, builder: (column) => column);

  GeneratedColumn<String> get baseSiteDescription => $composableBuilder(
      column: $table.baseSiteDescription, builder: (column) => column);

  GeneratedColumn<String> get baseSiteCode => $composableBuilder(
      column: $table.baseSiteCode, builder: (column) => column);

  GeneratedColumn<DateTime> get firstUseDate => $composableBuilder(
      column: $table.firstUseDate, builder: (column) => column);

  GeneratedColumn<String> get geom =>
      $composableBuilder(column: $table.geom, builder: (column) => column);

  GeneratedColumn<String> get uuidBaseSite => $composableBuilder(
      column: $table.uuidBaseSite, builder: (column) => column);

  GeneratedColumn<DateTime> get metaCreateDate => $composableBuilder(
      column: $table.metaCreateDate, builder: (column) => column);

  GeneratedColumn<DateTime> get metaUpdateDate => $composableBuilder(
      column: $table.metaUpdateDate, builder: (column) => column);

  GeneratedColumn<int> get altitudeMin => $composableBuilder(
      column: $table.altitudeMin, builder: (column) => column);

  GeneratedColumn<int> get altitudeMax => $composableBuilder(
      column: $table.altitudeMax, builder: (column) => column);
}

class $$TBaseSitesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TBaseSitesTable,
    TBaseSite,
    $$TBaseSitesTableFilterComposer,
    $$TBaseSitesTableOrderingComposer,
    $$TBaseSitesTableAnnotationComposer,
    $$TBaseSitesTableCreateCompanionBuilder,
    $$TBaseSitesTableUpdateCompanionBuilder,
    (TBaseSite, BaseReferences<_$AppDatabase, $TBaseSitesTable, TBaseSite>),
    TBaseSite,
    PrefetchHooks Function()> {
  $$TBaseSitesTableTableManager(_$AppDatabase db, $TBaseSitesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TBaseSitesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TBaseSitesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TBaseSitesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> idBaseSite = const Value.absent(),
            Value<int?> idInventor = const Value.absent(),
            Value<int?> idDigitiser = const Value.absent(),
            Value<String?> baseSiteName = const Value.absent(),
            Value<String?> baseSiteDescription = const Value.absent(),
            Value<String?> baseSiteCode = const Value.absent(),
            Value<DateTime?> firstUseDate = const Value.absent(),
            Value<String?> geom = const Value.absent(),
            Value<String?> uuidBaseSite = const Value.absent(),
            Value<DateTime?> metaCreateDate = const Value.absent(),
            Value<DateTime?> metaUpdateDate = const Value.absent(),
            Value<int?> altitudeMin = const Value.absent(),
            Value<int?> altitudeMax = const Value.absent(),
          }) =>
              TBaseSitesCompanion(
            idBaseSite: idBaseSite,
            idInventor: idInventor,
            idDigitiser: idDigitiser,
            baseSiteName: baseSiteName,
            baseSiteDescription: baseSiteDescription,
            baseSiteCode: baseSiteCode,
            firstUseDate: firstUseDate,
            geom: geom,
            uuidBaseSite: uuidBaseSite,
            metaCreateDate: metaCreateDate,
            metaUpdateDate: metaUpdateDate,
            altitudeMin: altitudeMin,
            altitudeMax: altitudeMax,
          ),
          createCompanionCallback: ({
            Value<int> idBaseSite = const Value.absent(),
            Value<int?> idInventor = const Value.absent(),
            Value<int?> idDigitiser = const Value.absent(),
            Value<String?> baseSiteName = const Value.absent(),
            Value<String?> baseSiteDescription = const Value.absent(),
            Value<String?> baseSiteCode = const Value.absent(),
            Value<DateTime?> firstUseDate = const Value.absent(),
            Value<String?> geom = const Value.absent(),
            Value<String?> uuidBaseSite = const Value.absent(),
            Value<DateTime?> metaCreateDate = const Value.absent(),
            Value<DateTime?> metaUpdateDate = const Value.absent(),
            Value<int?> altitudeMin = const Value.absent(),
            Value<int?> altitudeMax = const Value.absent(),
          }) =>
              TBaseSitesCompanion.insert(
            idBaseSite: idBaseSite,
            idInventor: idInventor,
            idDigitiser: idDigitiser,
            baseSiteName: baseSiteName,
            baseSiteDescription: baseSiteDescription,
            baseSiteCode: baseSiteCode,
            firstUseDate: firstUseDate,
            geom: geom,
            uuidBaseSite: uuidBaseSite,
            metaCreateDate: metaCreateDate,
            metaUpdateDate: metaUpdateDate,
            altitudeMin: altitudeMin,
            altitudeMax: altitudeMax,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TBaseSitesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TBaseSitesTable,
    TBaseSite,
    $$TBaseSitesTableFilterComposer,
    $$TBaseSitesTableOrderingComposer,
    $$TBaseSitesTableAnnotationComposer,
    $$TBaseSitesTableCreateCompanionBuilder,
    $$TBaseSitesTableUpdateCompanionBuilder,
    (TBaseSite, BaseReferences<_$AppDatabase, $TBaseSitesTable, TBaseSite>),
    TBaseSite,
    PrefetchHooks Function()>;
typedef $$TNomenclaturesTableCreateCompanionBuilder = TNomenclaturesCompanion
    Function({
  Value<int> idNomenclature,
  required int idType,
  required String cdNomenclature,
  Value<String?> mnemonique,
  Value<String?> codeType,
  Value<String?> labelDefault,
  Value<String?> definitionDefault,
  Value<String?> labelFr,
  Value<String?> definitionFr,
  Value<String?> labelEn,
  Value<String?> definitionEn,
  Value<String?> labelEs,
  Value<String?> definitionEs,
  Value<String?> labelDe,
  Value<String?> definitionDe,
  Value<String?> labelIt,
  Value<String?> definitionIt,
  Value<String?> source,
  Value<String?> statut,
  Value<int?> idBroader,
  Value<String?> hierarchy,
  Value<bool> active,
  Value<DateTime?> metaCreateDate,
  Value<DateTime?> metaUpdateDate,
});
typedef $$TNomenclaturesTableUpdateCompanionBuilder = TNomenclaturesCompanion
    Function({
  Value<int> idNomenclature,
  Value<int> idType,
  Value<String> cdNomenclature,
  Value<String?> mnemonique,
  Value<String?> codeType,
  Value<String?> labelDefault,
  Value<String?> definitionDefault,
  Value<String?> labelFr,
  Value<String?> definitionFr,
  Value<String?> labelEn,
  Value<String?> definitionEn,
  Value<String?> labelEs,
  Value<String?> definitionEs,
  Value<String?> labelDe,
  Value<String?> definitionDe,
  Value<String?> labelIt,
  Value<String?> definitionIt,
  Value<String?> source,
  Value<String?> statut,
  Value<int?> idBroader,
  Value<String?> hierarchy,
  Value<bool> active,
  Value<DateTime?> metaCreateDate,
  Value<DateTime?> metaUpdateDate,
});

class $$TNomenclaturesTableFilterComposer
    extends Composer<_$AppDatabase, $TNomenclaturesTable> {
  $$TNomenclaturesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idNomenclature => $composableBuilder(
      column: $table.idNomenclature,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idType => $composableBuilder(
      column: $table.idType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cdNomenclature => $composableBuilder(
      column: $table.cdNomenclature,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mnemonique => $composableBuilder(
      column: $table.mnemonique, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get codeType => $composableBuilder(
      column: $table.codeType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get labelDefault => $composableBuilder(
      column: $table.labelDefault, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get definitionDefault => $composableBuilder(
      column: $table.definitionDefault,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get labelFr => $composableBuilder(
      column: $table.labelFr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get definitionFr => $composableBuilder(
      column: $table.definitionFr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get labelEn => $composableBuilder(
      column: $table.labelEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get definitionEn => $composableBuilder(
      column: $table.definitionEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get labelEs => $composableBuilder(
      column: $table.labelEs, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get definitionEs => $composableBuilder(
      column: $table.definitionEs, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get labelDe => $composableBuilder(
      column: $table.labelDe, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get definitionDe => $composableBuilder(
      column: $table.definitionDe, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get labelIt => $composableBuilder(
      column: $table.labelIt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get definitionIt => $composableBuilder(
      column: $table.definitionIt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get statut => $composableBuilder(
      column: $table.statut, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idBroader => $composableBuilder(
      column: $table.idBroader, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hierarchy => $composableBuilder(
      column: $table.hierarchy, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get metaCreateDate => $composableBuilder(
      column: $table.metaCreateDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get metaUpdateDate => $composableBuilder(
      column: $table.metaUpdateDate,
      builder: (column) => ColumnFilters(column));
}

class $$TNomenclaturesTableOrderingComposer
    extends Composer<_$AppDatabase, $TNomenclaturesTable> {
  $$TNomenclaturesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idNomenclature => $composableBuilder(
      column: $table.idNomenclature,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idType => $composableBuilder(
      column: $table.idType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cdNomenclature => $composableBuilder(
      column: $table.cdNomenclature,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mnemonique => $composableBuilder(
      column: $table.mnemonique, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get codeType => $composableBuilder(
      column: $table.codeType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get labelDefault => $composableBuilder(
      column: $table.labelDefault,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get definitionDefault => $composableBuilder(
      column: $table.definitionDefault,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get labelFr => $composableBuilder(
      column: $table.labelFr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get definitionFr => $composableBuilder(
      column: $table.definitionFr,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get labelEn => $composableBuilder(
      column: $table.labelEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get definitionEn => $composableBuilder(
      column: $table.definitionEn,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get labelEs => $composableBuilder(
      column: $table.labelEs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get definitionEs => $composableBuilder(
      column: $table.definitionEs,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get labelDe => $composableBuilder(
      column: $table.labelDe, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get definitionDe => $composableBuilder(
      column: $table.definitionDe,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get labelIt => $composableBuilder(
      column: $table.labelIt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get definitionIt => $composableBuilder(
      column: $table.definitionIt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get statut => $composableBuilder(
      column: $table.statut, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idBroader => $composableBuilder(
      column: $table.idBroader, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hierarchy => $composableBuilder(
      column: $table.hierarchy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get metaCreateDate => $composableBuilder(
      column: $table.metaCreateDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get metaUpdateDate => $composableBuilder(
      column: $table.metaUpdateDate,
      builder: (column) => ColumnOrderings(column));
}

class $$TNomenclaturesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TNomenclaturesTable> {
  $$TNomenclaturesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idNomenclature => $composableBuilder(
      column: $table.idNomenclature, builder: (column) => column);

  GeneratedColumn<int> get idType =>
      $composableBuilder(column: $table.idType, builder: (column) => column);

  GeneratedColumn<String> get cdNomenclature => $composableBuilder(
      column: $table.cdNomenclature, builder: (column) => column);

  GeneratedColumn<String> get mnemonique => $composableBuilder(
      column: $table.mnemonique, builder: (column) => column);

  GeneratedColumn<String> get codeType =>
      $composableBuilder(column: $table.codeType, builder: (column) => column);

  GeneratedColumn<String> get labelDefault => $composableBuilder(
      column: $table.labelDefault, builder: (column) => column);

  GeneratedColumn<String> get definitionDefault => $composableBuilder(
      column: $table.definitionDefault, builder: (column) => column);

  GeneratedColumn<String> get labelFr =>
      $composableBuilder(column: $table.labelFr, builder: (column) => column);

  GeneratedColumn<String> get definitionFr => $composableBuilder(
      column: $table.definitionFr, builder: (column) => column);

  GeneratedColumn<String> get labelEn =>
      $composableBuilder(column: $table.labelEn, builder: (column) => column);

  GeneratedColumn<String> get definitionEn => $composableBuilder(
      column: $table.definitionEn, builder: (column) => column);

  GeneratedColumn<String> get labelEs =>
      $composableBuilder(column: $table.labelEs, builder: (column) => column);

  GeneratedColumn<String> get definitionEs => $composableBuilder(
      column: $table.definitionEs, builder: (column) => column);

  GeneratedColumn<String> get labelDe =>
      $composableBuilder(column: $table.labelDe, builder: (column) => column);

  GeneratedColumn<String> get definitionDe => $composableBuilder(
      column: $table.definitionDe, builder: (column) => column);

  GeneratedColumn<String> get labelIt =>
      $composableBuilder(column: $table.labelIt, builder: (column) => column);

  GeneratedColumn<String> get definitionIt => $composableBuilder(
      column: $table.definitionIt, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get statut =>
      $composableBuilder(column: $table.statut, builder: (column) => column);

  GeneratedColumn<int> get idBroader =>
      $composableBuilder(column: $table.idBroader, builder: (column) => column);

  GeneratedColumn<String> get hierarchy =>
      $composableBuilder(column: $table.hierarchy, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<DateTime> get metaCreateDate => $composableBuilder(
      column: $table.metaCreateDate, builder: (column) => column);

  GeneratedColumn<DateTime> get metaUpdateDate => $composableBuilder(
      column: $table.metaUpdateDate, builder: (column) => column);
}

class $$TNomenclaturesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TNomenclaturesTable,
    TNomenclature,
    $$TNomenclaturesTableFilterComposer,
    $$TNomenclaturesTableOrderingComposer,
    $$TNomenclaturesTableAnnotationComposer,
    $$TNomenclaturesTableCreateCompanionBuilder,
    $$TNomenclaturesTableUpdateCompanionBuilder,
    (
      TNomenclature,
      BaseReferences<_$AppDatabase, $TNomenclaturesTable, TNomenclature>
    ),
    TNomenclature,
    PrefetchHooks Function()> {
  $$TNomenclaturesTableTableManager(
      _$AppDatabase db, $TNomenclaturesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TNomenclaturesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TNomenclaturesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TNomenclaturesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> idNomenclature = const Value.absent(),
            Value<int> idType = const Value.absent(),
            Value<String> cdNomenclature = const Value.absent(),
            Value<String?> mnemonique = const Value.absent(),
            Value<String?> codeType = const Value.absent(),
            Value<String?> labelDefault = const Value.absent(),
            Value<String?> definitionDefault = const Value.absent(),
            Value<String?> labelFr = const Value.absent(),
            Value<String?> definitionFr = const Value.absent(),
            Value<String?> labelEn = const Value.absent(),
            Value<String?> definitionEn = const Value.absent(),
            Value<String?> labelEs = const Value.absent(),
            Value<String?> definitionEs = const Value.absent(),
            Value<String?> labelDe = const Value.absent(),
            Value<String?> definitionDe = const Value.absent(),
            Value<String?> labelIt = const Value.absent(),
            Value<String?> definitionIt = const Value.absent(),
            Value<String?> source = const Value.absent(),
            Value<String?> statut = const Value.absent(),
            Value<int?> idBroader = const Value.absent(),
            Value<String?> hierarchy = const Value.absent(),
            Value<bool> active = const Value.absent(),
            Value<DateTime?> metaCreateDate = const Value.absent(),
            Value<DateTime?> metaUpdateDate = const Value.absent(),
          }) =>
              TNomenclaturesCompanion(
            idNomenclature: idNomenclature,
            idType: idType,
            cdNomenclature: cdNomenclature,
            mnemonique: mnemonique,
            codeType: codeType,
            labelDefault: labelDefault,
            definitionDefault: definitionDefault,
            labelFr: labelFr,
            definitionFr: definitionFr,
            labelEn: labelEn,
            definitionEn: definitionEn,
            labelEs: labelEs,
            definitionEs: definitionEs,
            labelDe: labelDe,
            definitionDe: definitionDe,
            labelIt: labelIt,
            definitionIt: definitionIt,
            source: source,
            statut: statut,
            idBroader: idBroader,
            hierarchy: hierarchy,
            active: active,
            metaCreateDate: metaCreateDate,
            metaUpdateDate: metaUpdateDate,
          ),
          createCompanionCallback: ({
            Value<int> idNomenclature = const Value.absent(),
            required int idType,
            required String cdNomenclature,
            Value<String?> mnemonique = const Value.absent(),
            Value<String?> codeType = const Value.absent(),
            Value<String?> labelDefault = const Value.absent(),
            Value<String?> definitionDefault = const Value.absent(),
            Value<String?> labelFr = const Value.absent(),
            Value<String?> definitionFr = const Value.absent(),
            Value<String?> labelEn = const Value.absent(),
            Value<String?> definitionEn = const Value.absent(),
            Value<String?> labelEs = const Value.absent(),
            Value<String?> definitionEs = const Value.absent(),
            Value<String?> labelDe = const Value.absent(),
            Value<String?> definitionDe = const Value.absent(),
            Value<String?> labelIt = const Value.absent(),
            Value<String?> definitionIt = const Value.absent(),
            Value<String?> source = const Value.absent(),
            Value<String?> statut = const Value.absent(),
            Value<int?> idBroader = const Value.absent(),
            Value<String?> hierarchy = const Value.absent(),
            Value<bool> active = const Value.absent(),
            Value<DateTime?> metaCreateDate = const Value.absent(),
            Value<DateTime?> metaUpdateDate = const Value.absent(),
          }) =>
              TNomenclaturesCompanion.insert(
            idNomenclature: idNomenclature,
            idType: idType,
            cdNomenclature: cdNomenclature,
            mnemonique: mnemonique,
            codeType: codeType,
            labelDefault: labelDefault,
            definitionDefault: definitionDefault,
            labelFr: labelFr,
            definitionFr: definitionFr,
            labelEn: labelEn,
            definitionEn: definitionEn,
            labelEs: labelEs,
            definitionEs: definitionEs,
            labelDe: labelDe,
            definitionDe: definitionDe,
            labelIt: labelIt,
            definitionIt: definitionIt,
            source: source,
            statut: statut,
            idBroader: idBroader,
            hierarchy: hierarchy,
            active: active,
            metaCreateDate: metaCreateDate,
            metaUpdateDate: metaUpdateDate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TNomenclaturesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TNomenclaturesTable,
    TNomenclature,
    $$TNomenclaturesTableFilterComposer,
    $$TNomenclaturesTableOrderingComposer,
    $$TNomenclaturesTableAnnotationComposer,
    $$TNomenclaturesTableCreateCompanionBuilder,
    $$TNomenclaturesTableUpdateCompanionBuilder,
    (
      TNomenclature,
      BaseReferences<_$AppDatabase, $TNomenclaturesTable, TNomenclature>
    ),
    TNomenclature,
    PrefetchHooks Function()>;
typedef $$TDatasetsTableCreateCompanionBuilder = TDatasetsCompanion Function({
  Value<int> idDataset,
  required String uniqueDatasetId,
  required int idAcquisitionFramework,
  required String datasetName,
  required String datasetShortname,
  required String datasetDesc,
  required int idNomenclatureDataType,
  Value<String?> keywords,
  required bool marineDomain,
  required bool terrestrialDomain,
  required int idNomenclatureDatasetObjectif,
  Value<double?> bboxWest,
  Value<double?> bboxEast,
  Value<double?> bboxSouth,
  Value<double?> bboxNorth,
  required int idNomenclatureCollectingMethod,
  required int idNomenclatureDataOrigin,
  required int idNomenclatureSourceStatus,
  required int idNomenclatureResourceType,
  Value<bool> active,
  Value<bool?> validable,
  Value<int?> idDigitizer,
  Value<int?> idTaxaList,
  Value<DateTime?> metaCreateDate,
  Value<DateTime?> metaUpdateDate,
});
typedef $$TDatasetsTableUpdateCompanionBuilder = TDatasetsCompanion Function({
  Value<int> idDataset,
  Value<String> uniqueDatasetId,
  Value<int> idAcquisitionFramework,
  Value<String> datasetName,
  Value<String> datasetShortname,
  Value<String> datasetDesc,
  Value<int> idNomenclatureDataType,
  Value<String?> keywords,
  Value<bool> marineDomain,
  Value<bool> terrestrialDomain,
  Value<int> idNomenclatureDatasetObjectif,
  Value<double?> bboxWest,
  Value<double?> bboxEast,
  Value<double?> bboxSouth,
  Value<double?> bboxNorth,
  Value<int> idNomenclatureCollectingMethod,
  Value<int> idNomenclatureDataOrigin,
  Value<int> idNomenclatureSourceStatus,
  Value<int> idNomenclatureResourceType,
  Value<bool> active,
  Value<bool?> validable,
  Value<int?> idDigitizer,
  Value<int?> idTaxaList,
  Value<DateTime?> metaCreateDate,
  Value<DateTime?> metaUpdateDate,
});

class $$TDatasetsTableFilterComposer
    extends Composer<_$AppDatabase, $TDatasetsTable> {
  $$TDatasetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idDataset => $composableBuilder(
      column: $table.idDataset, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uniqueDatasetId => $composableBuilder(
      column: $table.uniqueDatasetId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idAcquisitionFramework => $composableBuilder(
      column: $table.idAcquisitionFramework,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get datasetName => $composableBuilder(
      column: $table.datasetName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get datasetShortname => $composableBuilder(
      column: $table.datasetShortname,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get datasetDesc => $composableBuilder(
      column: $table.datasetDesc, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idNomenclatureDataType => $composableBuilder(
      column: $table.idNomenclatureDataType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get keywords => $composableBuilder(
      column: $table.keywords, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get marineDomain => $composableBuilder(
      column: $table.marineDomain, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get terrestrialDomain => $composableBuilder(
      column: $table.terrestrialDomain,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idNomenclatureDatasetObjectif => $composableBuilder(
      column: $table.idNomenclatureDatasetObjectif,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bboxWest => $composableBuilder(
      column: $table.bboxWest, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bboxEast => $composableBuilder(
      column: $table.bboxEast, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bboxSouth => $composableBuilder(
      column: $table.bboxSouth, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bboxNorth => $composableBuilder(
      column: $table.bboxNorth, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idNomenclatureCollectingMethod => $composableBuilder(
      column: $table.idNomenclatureCollectingMethod,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idNomenclatureDataOrigin => $composableBuilder(
      column: $table.idNomenclatureDataOrigin,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idNomenclatureSourceStatus => $composableBuilder(
      column: $table.idNomenclatureSourceStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idNomenclatureResourceType => $composableBuilder(
      column: $table.idNomenclatureResourceType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get validable => $composableBuilder(
      column: $table.validable, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idDigitizer => $composableBuilder(
      column: $table.idDigitizer, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idTaxaList => $composableBuilder(
      column: $table.idTaxaList, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get metaCreateDate => $composableBuilder(
      column: $table.metaCreateDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get metaUpdateDate => $composableBuilder(
      column: $table.metaUpdateDate,
      builder: (column) => ColumnFilters(column));
}

class $$TDatasetsTableOrderingComposer
    extends Composer<_$AppDatabase, $TDatasetsTable> {
  $$TDatasetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idDataset => $composableBuilder(
      column: $table.idDataset, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uniqueDatasetId => $composableBuilder(
      column: $table.uniqueDatasetId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idAcquisitionFramework => $composableBuilder(
      column: $table.idAcquisitionFramework,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get datasetName => $composableBuilder(
      column: $table.datasetName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get datasetShortname => $composableBuilder(
      column: $table.datasetShortname,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get datasetDesc => $composableBuilder(
      column: $table.datasetDesc, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idNomenclatureDataType => $composableBuilder(
      column: $table.idNomenclatureDataType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get keywords => $composableBuilder(
      column: $table.keywords, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get marineDomain => $composableBuilder(
      column: $table.marineDomain,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get terrestrialDomain => $composableBuilder(
      column: $table.terrestrialDomain,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idNomenclatureDatasetObjectif => $composableBuilder(
      column: $table.idNomenclatureDatasetObjectif,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bboxWest => $composableBuilder(
      column: $table.bboxWest, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bboxEast => $composableBuilder(
      column: $table.bboxEast, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bboxSouth => $composableBuilder(
      column: $table.bboxSouth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bboxNorth => $composableBuilder(
      column: $table.bboxNorth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idNomenclatureCollectingMethod => $composableBuilder(
      column: $table.idNomenclatureCollectingMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idNomenclatureDataOrigin => $composableBuilder(
      column: $table.idNomenclatureDataOrigin,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idNomenclatureSourceStatus => $composableBuilder(
      column: $table.idNomenclatureSourceStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idNomenclatureResourceType => $composableBuilder(
      column: $table.idNomenclatureResourceType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get validable => $composableBuilder(
      column: $table.validable, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idDigitizer => $composableBuilder(
      column: $table.idDigitizer, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idTaxaList => $composableBuilder(
      column: $table.idTaxaList, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get metaCreateDate => $composableBuilder(
      column: $table.metaCreateDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get metaUpdateDate => $composableBuilder(
      column: $table.metaUpdateDate,
      builder: (column) => ColumnOrderings(column));
}

class $$TDatasetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TDatasetsTable> {
  $$TDatasetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idDataset =>
      $composableBuilder(column: $table.idDataset, builder: (column) => column);

  GeneratedColumn<String> get uniqueDatasetId => $composableBuilder(
      column: $table.uniqueDatasetId, builder: (column) => column);

  GeneratedColumn<int> get idAcquisitionFramework => $composableBuilder(
      column: $table.idAcquisitionFramework, builder: (column) => column);

  GeneratedColumn<String> get datasetName => $composableBuilder(
      column: $table.datasetName, builder: (column) => column);

  GeneratedColumn<String> get datasetShortname => $composableBuilder(
      column: $table.datasetShortname, builder: (column) => column);

  GeneratedColumn<String> get datasetDesc => $composableBuilder(
      column: $table.datasetDesc, builder: (column) => column);

  GeneratedColumn<int> get idNomenclatureDataType => $composableBuilder(
      column: $table.idNomenclatureDataType, builder: (column) => column);

  GeneratedColumn<String> get keywords =>
      $composableBuilder(column: $table.keywords, builder: (column) => column);

  GeneratedColumn<bool> get marineDomain => $composableBuilder(
      column: $table.marineDomain, builder: (column) => column);

  GeneratedColumn<bool> get terrestrialDomain => $composableBuilder(
      column: $table.terrestrialDomain, builder: (column) => column);

  GeneratedColumn<int> get idNomenclatureDatasetObjectif => $composableBuilder(
      column: $table.idNomenclatureDatasetObjectif,
      builder: (column) => column);

  GeneratedColumn<double> get bboxWest =>
      $composableBuilder(column: $table.bboxWest, builder: (column) => column);

  GeneratedColumn<double> get bboxEast =>
      $composableBuilder(column: $table.bboxEast, builder: (column) => column);

  GeneratedColumn<double> get bboxSouth =>
      $composableBuilder(column: $table.bboxSouth, builder: (column) => column);

  GeneratedColumn<double> get bboxNorth =>
      $composableBuilder(column: $table.bboxNorth, builder: (column) => column);

  GeneratedColumn<int> get idNomenclatureCollectingMethod => $composableBuilder(
      column: $table.idNomenclatureCollectingMethod,
      builder: (column) => column);

  GeneratedColumn<int> get idNomenclatureDataOrigin => $composableBuilder(
      column: $table.idNomenclatureDataOrigin, builder: (column) => column);

  GeneratedColumn<int> get idNomenclatureSourceStatus => $composableBuilder(
      column: $table.idNomenclatureSourceStatus, builder: (column) => column);

  GeneratedColumn<int> get idNomenclatureResourceType => $composableBuilder(
      column: $table.idNomenclatureResourceType, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<bool> get validable =>
      $composableBuilder(column: $table.validable, builder: (column) => column);

  GeneratedColumn<int> get idDigitizer => $composableBuilder(
      column: $table.idDigitizer, builder: (column) => column);

  GeneratedColumn<int> get idTaxaList => $composableBuilder(
      column: $table.idTaxaList, builder: (column) => column);

  GeneratedColumn<DateTime> get metaCreateDate => $composableBuilder(
      column: $table.metaCreateDate, builder: (column) => column);

  GeneratedColumn<DateTime> get metaUpdateDate => $composableBuilder(
      column: $table.metaUpdateDate, builder: (column) => column);
}

class $$TDatasetsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TDatasetsTable,
    TDataset,
    $$TDatasetsTableFilterComposer,
    $$TDatasetsTableOrderingComposer,
    $$TDatasetsTableAnnotationComposer,
    $$TDatasetsTableCreateCompanionBuilder,
    $$TDatasetsTableUpdateCompanionBuilder,
    (TDataset, BaseReferences<_$AppDatabase, $TDatasetsTable, TDataset>),
    TDataset,
    PrefetchHooks Function()> {
  $$TDatasetsTableTableManager(_$AppDatabase db, $TDatasetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TDatasetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TDatasetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TDatasetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> idDataset = const Value.absent(),
            Value<String> uniqueDatasetId = const Value.absent(),
            Value<int> idAcquisitionFramework = const Value.absent(),
            Value<String> datasetName = const Value.absent(),
            Value<String> datasetShortname = const Value.absent(),
            Value<String> datasetDesc = const Value.absent(),
            Value<int> idNomenclatureDataType = const Value.absent(),
            Value<String?> keywords = const Value.absent(),
            Value<bool> marineDomain = const Value.absent(),
            Value<bool> terrestrialDomain = const Value.absent(),
            Value<int> idNomenclatureDatasetObjectif = const Value.absent(),
            Value<double?> bboxWest = const Value.absent(),
            Value<double?> bboxEast = const Value.absent(),
            Value<double?> bboxSouth = const Value.absent(),
            Value<double?> bboxNorth = const Value.absent(),
            Value<int> idNomenclatureCollectingMethod = const Value.absent(),
            Value<int> idNomenclatureDataOrigin = const Value.absent(),
            Value<int> idNomenclatureSourceStatus = const Value.absent(),
            Value<int> idNomenclatureResourceType = const Value.absent(),
            Value<bool> active = const Value.absent(),
            Value<bool?> validable = const Value.absent(),
            Value<int?> idDigitizer = const Value.absent(),
            Value<int?> idTaxaList = const Value.absent(),
            Value<DateTime?> metaCreateDate = const Value.absent(),
            Value<DateTime?> metaUpdateDate = const Value.absent(),
          }) =>
              TDatasetsCompanion(
            idDataset: idDataset,
            uniqueDatasetId: uniqueDatasetId,
            idAcquisitionFramework: idAcquisitionFramework,
            datasetName: datasetName,
            datasetShortname: datasetShortname,
            datasetDesc: datasetDesc,
            idNomenclatureDataType: idNomenclatureDataType,
            keywords: keywords,
            marineDomain: marineDomain,
            terrestrialDomain: terrestrialDomain,
            idNomenclatureDatasetObjectif: idNomenclatureDatasetObjectif,
            bboxWest: bboxWest,
            bboxEast: bboxEast,
            bboxSouth: bboxSouth,
            bboxNorth: bboxNorth,
            idNomenclatureCollectingMethod: idNomenclatureCollectingMethod,
            idNomenclatureDataOrigin: idNomenclatureDataOrigin,
            idNomenclatureSourceStatus: idNomenclatureSourceStatus,
            idNomenclatureResourceType: idNomenclatureResourceType,
            active: active,
            validable: validable,
            idDigitizer: idDigitizer,
            idTaxaList: idTaxaList,
            metaCreateDate: metaCreateDate,
            metaUpdateDate: metaUpdateDate,
          ),
          createCompanionCallback: ({
            Value<int> idDataset = const Value.absent(),
            required String uniqueDatasetId,
            required int idAcquisitionFramework,
            required String datasetName,
            required String datasetShortname,
            required String datasetDesc,
            required int idNomenclatureDataType,
            Value<String?> keywords = const Value.absent(),
            required bool marineDomain,
            required bool terrestrialDomain,
            required int idNomenclatureDatasetObjectif,
            Value<double?> bboxWest = const Value.absent(),
            Value<double?> bboxEast = const Value.absent(),
            Value<double?> bboxSouth = const Value.absent(),
            Value<double?> bboxNorth = const Value.absent(),
            required int idNomenclatureCollectingMethod,
            required int idNomenclatureDataOrigin,
            required int idNomenclatureSourceStatus,
            required int idNomenclatureResourceType,
            Value<bool> active = const Value.absent(),
            Value<bool?> validable = const Value.absent(),
            Value<int?> idDigitizer = const Value.absent(),
            Value<int?> idTaxaList = const Value.absent(),
            Value<DateTime?> metaCreateDate = const Value.absent(),
            Value<DateTime?> metaUpdateDate = const Value.absent(),
          }) =>
              TDatasetsCompanion.insert(
            idDataset: idDataset,
            uniqueDatasetId: uniqueDatasetId,
            idAcquisitionFramework: idAcquisitionFramework,
            datasetName: datasetName,
            datasetShortname: datasetShortname,
            datasetDesc: datasetDesc,
            idNomenclatureDataType: idNomenclatureDataType,
            keywords: keywords,
            marineDomain: marineDomain,
            terrestrialDomain: terrestrialDomain,
            idNomenclatureDatasetObjectif: idNomenclatureDatasetObjectif,
            bboxWest: bboxWest,
            bboxEast: bboxEast,
            bboxSouth: bboxSouth,
            bboxNorth: bboxNorth,
            idNomenclatureCollectingMethod: idNomenclatureCollectingMethod,
            idNomenclatureDataOrigin: idNomenclatureDataOrigin,
            idNomenclatureSourceStatus: idNomenclatureSourceStatus,
            idNomenclatureResourceType: idNomenclatureResourceType,
            active: active,
            validable: validable,
            idDigitizer: idDigitizer,
            idTaxaList: idTaxaList,
            metaCreateDate: metaCreateDate,
            metaUpdateDate: metaUpdateDate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TDatasetsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TDatasetsTable,
    TDataset,
    $$TDatasetsTableFilterComposer,
    $$TDatasetsTableOrderingComposer,
    $$TDatasetsTableAnnotationComposer,
    $$TDatasetsTableCreateCompanionBuilder,
    $$TDatasetsTableUpdateCompanionBuilder,
    (TDataset, BaseReferences<_$AppDatabase, $TDatasetsTable, TDataset>),
    TDataset,
    PrefetchHooks Function()>;
typedef $$TModuleComplementsTableCreateCompanionBuilder
    = TModuleComplementsCompanion Function({
  Value<int> idModule,
  Value<String?> uuidModuleComplement,
  Value<int?> idListObserver,
  Value<int?> idListTaxonomy,
  Value<bool> bSynthese,
  Value<String> taxonomyDisplayFieldName,
  Value<bool?> bDrawSitesGroup,
  Value<String?> data,
  Value<String?> configuration,
});
typedef $$TModuleComplementsTableUpdateCompanionBuilder
    = TModuleComplementsCompanion Function({
  Value<int> idModule,
  Value<String?> uuidModuleComplement,
  Value<int?> idListObserver,
  Value<int?> idListTaxonomy,
  Value<bool> bSynthese,
  Value<String> taxonomyDisplayFieldName,
  Value<bool?> bDrawSitesGroup,
  Value<String?> data,
  Value<String?> configuration,
});

class $$TModuleComplementsTableFilterComposer
    extends Composer<_$AppDatabase, $TModuleComplementsTable> {
  $$TModuleComplementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idModule => $composableBuilder(
      column: $table.idModule, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuidModuleComplement => $composableBuilder(
      column: $table.uuidModuleComplement,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idListObserver => $composableBuilder(
      column: $table.idListObserver,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idListTaxonomy => $composableBuilder(
      column: $table.idListTaxonomy,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get bSynthese => $composableBuilder(
      column: $table.bSynthese, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get taxonomyDisplayFieldName => $composableBuilder(
      column: $table.taxonomyDisplayFieldName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get bDrawSitesGroup => $composableBuilder(
      column: $table.bDrawSitesGroup,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get configuration => $composableBuilder(
      column: $table.configuration, builder: (column) => ColumnFilters(column));
}

class $$TModuleComplementsTableOrderingComposer
    extends Composer<_$AppDatabase, $TModuleComplementsTable> {
  $$TModuleComplementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idModule => $composableBuilder(
      column: $table.idModule, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuidModuleComplement => $composableBuilder(
      column: $table.uuidModuleComplement,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idListObserver => $composableBuilder(
      column: $table.idListObserver,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idListTaxonomy => $composableBuilder(
      column: $table.idListTaxonomy,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get bSynthese => $composableBuilder(
      column: $table.bSynthese, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get taxonomyDisplayFieldName => $composableBuilder(
      column: $table.taxonomyDisplayFieldName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get bDrawSitesGroup => $composableBuilder(
      column: $table.bDrawSitesGroup,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get configuration => $composableBuilder(
      column: $table.configuration,
      builder: (column) => ColumnOrderings(column));
}

class $$TModuleComplementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TModuleComplementsTable> {
  $$TModuleComplementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idModule =>
      $composableBuilder(column: $table.idModule, builder: (column) => column);

  GeneratedColumn<String> get uuidModuleComplement => $composableBuilder(
      column: $table.uuidModuleComplement, builder: (column) => column);

  GeneratedColumn<int> get idListObserver => $composableBuilder(
      column: $table.idListObserver, builder: (column) => column);

  GeneratedColumn<int> get idListTaxonomy => $composableBuilder(
      column: $table.idListTaxonomy, builder: (column) => column);

  GeneratedColumn<bool> get bSynthese =>
      $composableBuilder(column: $table.bSynthese, builder: (column) => column);

  GeneratedColumn<String> get taxonomyDisplayFieldName => $composableBuilder(
      column: $table.taxonomyDisplayFieldName, builder: (column) => column);

  GeneratedColumn<bool> get bDrawSitesGroup => $composableBuilder(
      column: $table.bDrawSitesGroup, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<String> get configuration => $composableBuilder(
      column: $table.configuration, builder: (column) => column);
}

class $$TModuleComplementsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TModuleComplementsTable,
    TModuleComplement,
    $$TModuleComplementsTableFilterComposer,
    $$TModuleComplementsTableOrderingComposer,
    $$TModuleComplementsTableAnnotationComposer,
    $$TModuleComplementsTableCreateCompanionBuilder,
    $$TModuleComplementsTableUpdateCompanionBuilder,
    (
      TModuleComplement,
      BaseReferences<_$AppDatabase, $TModuleComplementsTable, TModuleComplement>
    ),
    TModuleComplement,
    PrefetchHooks Function()> {
  $$TModuleComplementsTableTableManager(
      _$AppDatabase db, $TModuleComplementsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TModuleComplementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TModuleComplementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TModuleComplementsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> idModule = const Value.absent(),
            Value<String?> uuidModuleComplement = const Value.absent(),
            Value<int?> idListObserver = const Value.absent(),
            Value<int?> idListTaxonomy = const Value.absent(),
            Value<bool> bSynthese = const Value.absent(),
            Value<String> taxonomyDisplayFieldName = const Value.absent(),
            Value<bool?> bDrawSitesGroup = const Value.absent(),
            Value<String?> data = const Value.absent(),
            Value<String?> configuration = const Value.absent(),
          }) =>
              TModuleComplementsCompanion(
            idModule: idModule,
            uuidModuleComplement: uuidModuleComplement,
            idListObserver: idListObserver,
            idListTaxonomy: idListTaxonomy,
            bSynthese: bSynthese,
            taxonomyDisplayFieldName: taxonomyDisplayFieldName,
            bDrawSitesGroup: bDrawSitesGroup,
            data: data,
            configuration: configuration,
          ),
          createCompanionCallback: ({
            Value<int> idModule = const Value.absent(),
            Value<String?> uuidModuleComplement = const Value.absent(),
            Value<int?> idListObserver = const Value.absent(),
            Value<int?> idListTaxonomy = const Value.absent(),
            Value<bool> bSynthese = const Value.absent(),
            Value<String> taxonomyDisplayFieldName = const Value.absent(),
            Value<bool?> bDrawSitesGroup = const Value.absent(),
            Value<String?> data = const Value.absent(),
            Value<String?> configuration = const Value.absent(),
          }) =>
              TModuleComplementsCompanion.insert(
            idModule: idModule,
            uuidModuleComplement: uuidModuleComplement,
            idListObserver: idListObserver,
            idListTaxonomy: idListTaxonomy,
            bSynthese: bSynthese,
            taxonomyDisplayFieldName: taxonomyDisplayFieldName,
            bDrawSitesGroup: bDrawSitesGroup,
            data: data,
            configuration: configuration,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TModuleComplementsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TModuleComplementsTable,
    TModuleComplement,
    $$TModuleComplementsTableFilterComposer,
    $$TModuleComplementsTableOrderingComposer,
    $$TModuleComplementsTableAnnotationComposer,
    $$TModuleComplementsTableCreateCompanionBuilder,
    $$TModuleComplementsTableUpdateCompanionBuilder,
    (
      TModuleComplement,
      BaseReferences<_$AppDatabase, $TModuleComplementsTable, TModuleComplement>
    ),
    TModuleComplement,
    PrefetchHooks Function()>;
typedef $$TSitesGroupsTableCreateCompanionBuilder = TSitesGroupsCompanion
    Function({
  Value<int> idSitesGroup,
  Value<String?> sitesGroupName,
  Value<String?> sitesGroupCode,
  Value<String?> sitesGroupDescription,
  Value<String?> uuidSitesGroup,
  Value<String?> comments,
  Value<String?> data,
  Value<DateTime?> metaCreateDate,
  Value<DateTime?> metaUpdateDate,
  Value<int?> idDigitiser,
  Value<String?> geom,
  Value<int?> altitudeMin,
  Value<int?> altitudeMax,
});
typedef $$TSitesGroupsTableUpdateCompanionBuilder = TSitesGroupsCompanion
    Function({
  Value<int> idSitesGroup,
  Value<String?> sitesGroupName,
  Value<String?> sitesGroupCode,
  Value<String?> sitesGroupDescription,
  Value<String?> uuidSitesGroup,
  Value<String?> comments,
  Value<String?> data,
  Value<DateTime?> metaCreateDate,
  Value<DateTime?> metaUpdateDate,
  Value<int?> idDigitiser,
  Value<String?> geom,
  Value<int?> altitudeMin,
  Value<int?> altitudeMax,
});

class $$TSitesGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $TSitesGroupsTable> {
  $$TSitesGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idSitesGroup => $composableBuilder(
      column: $table.idSitesGroup, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sitesGroupName => $composableBuilder(
      column: $table.sitesGroupName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sitesGroupCode => $composableBuilder(
      column: $table.sitesGroupCode,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sitesGroupDescription => $composableBuilder(
      column: $table.sitesGroupDescription,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuidSitesGroup => $composableBuilder(
      column: $table.uuidSitesGroup,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get comments => $composableBuilder(
      column: $table.comments, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get metaCreateDate => $composableBuilder(
      column: $table.metaCreateDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get metaUpdateDate => $composableBuilder(
      column: $table.metaUpdateDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idDigitiser => $composableBuilder(
      column: $table.idDigitiser, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get geom => $composableBuilder(
      column: $table.geom, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get altitudeMin => $composableBuilder(
      column: $table.altitudeMin, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get altitudeMax => $composableBuilder(
      column: $table.altitudeMax, builder: (column) => ColumnFilters(column));
}

class $$TSitesGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $TSitesGroupsTable> {
  $$TSitesGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idSitesGroup => $composableBuilder(
      column: $table.idSitesGroup,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sitesGroupName => $composableBuilder(
      column: $table.sitesGroupName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sitesGroupCode => $composableBuilder(
      column: $table.sitesGroupCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sitesGroupDescription => $composableBuilder(
      column: $table.sitesGroupDescription,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuidSitesGroup => $composableBuilder(
      column: $table.uuidSitesGroup,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get comments => $composableBuilder(
      column: $table.comments, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get metaCreateDate => $composableBuilder(
      column: $table.metaCreateDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get metaUpdateDate => $composableBuilder(
      column: $table.metaUpdateDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idDigitiser => $composableBuilder(
      column: $table.idDigitiser, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get geom => $composableBuilder(
      column: $table.geom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get altitudeMin => $composableBuilder(
      column: $table.altitudeMin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get altitudeMax => $composableBuilder(
      column: $table.altitudeMax, builder: (column) => ColumnOrderings(column));
}

class $$TSitesGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TSitesGroupsTable> {
  $$TSitesGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idSitesGroup => $composableBuilder(
      column: $table.idSitesGroup, builder: (column) => column);

  GeneratedColumn<String> get sitesGroupName => $composableBuilder(
      column: $table.sitesGroupName, builder: (column) => column);

  GeneratedColumn<String> get sitesGroupCode => $composableBuilder(
      column: $table.sitesGroupCode, builder: (column) => column);

  GeneratedColumn<String> get sitesGroupDescription => $composableBuilder(
      column: $table.sitesGroupDescription, builder: (column) => column);

  GeneratedColumn<String> get uuidSitesGroup => $composableBuilder(
      column: $table.uuidSitesGroup, builder: (column) => column);

  GeneratedColumn<String> get comments =>
      $composableBuilder(column: $table.comments, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<DateTime> get metaCreateDate => $composableBuilder(
      column: $table.metaCreateDate, builder: (column) => column);

  GeneratedColumn<DateTime> get metaUpdateDate => $composableBuilder(
      column: $table.metaUpdateDate, builder: (column) => column);

  GeneratedColumn<int> get idDigitiser => $composableBuilder(
      column: $table.idDigitiser, builder: (column) => column);

  GeneratedColumn<String> get geom =>
      $composableBuilder(column: $table.geom, builder: (column) => column);

  GeneratedColumn<int> get altitudeMin => $composableBuilder(
      column: $table.altitudeMin, builder: (column) => column);

  GeneratedColumn<int> get altitudeMax => $composableBuilder(
      column: $table.altitudeMax, builder: (column) => column);
}

class $$TSitesGroupsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TSitesGroupsTable,
    TSitesGroup,
    $$TSitesGroupsTableFilterComposer,
    $$TSitesGroupsTableOrderingComposer,
    $$TSitesGroupsTableAnnotationComposer,
    $$TSitesGroupsTableCreateCompanionBuilder,
    $$TSitesGroupsTableUpdateCompanionBuilder,
    (
      TSitesGroup,
      BaseReferences<_$AppDatabase, $TSitesGroupsTable, TSitesGroup>
    ),
    TSitesGroup,
    PrefetchHooks Function()> {
  $$TSitesGroupsTableTableManager(_$AppDatabase db, $TSitesGroupsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TSitesGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TSitesGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TSitesGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> idSitesGroup = const Value.absent(),
            Value<String?> sitesGroupName = const Value.absent(),
            Value<String?> sitesGroupCode = const Value.absent(),
            Value<String?> sitesGroupDescription = const Value.absent(),
            Value<String?> uuidSitesGroup = const Value.absent(),
            Value<String?> comments = const Value.absent(),
            Value<String?> data = const Value.absent(),
            Value<DateTime?> metaCreateDate = const Value.absent(),
            Value<DateTime?> metaUpdateDate = const Value.absent(),
            Value<int?> idDigitiser = const Value.absent(),
            Value<String?> geom = const Value.absent(),
            Value<int?> altitudeMin = const Value.absent(),
            Value<int?> altitudeMax = const Value.absent(),
          }) =>
              TSitesGroupsCompanion(
            idSitesGroup: idSitesGroup,
            sitesGroupName: sitesGroupName,
            sitesGroupCode: sitesGroupCode,
            sitesGroupDescription: sitesGroupDescription,
            uuidSitesGroup: uuidSitesGroup,
            comments: comments,
            data: data,
            metaCreateDate: metaCreateDate,
            metaUpdateDate: metaUpdateDate,
            idDigitiser: idDigitiser,
            geom: geom,
            altitudeMin: altitudeMin,
            altitudeMax: altitudeMax,
          ),
          createCompanionCallback: ({
            Value<int> idSitesGroup = const Value.absent(),
            Value<String?> sitesGroupName = const Value.absent(),
            Value<String?> sitesGroupCode = const Value.absent(),
            Value<String?> sitesGroupDescription = const Value.absent(),
            Value<String?> uuidSitesGroup = const Value.absent(),
            Value<String?> comments = const Value.absent(),
            Value<String?> data = const Value.absent(),
            Value<DateTime?> metaCreateDate = const Value.absent(),
            Value<DateTime?> metaUpdateDate = const Value.absent(),
            Value<int?> idDigitiser = const Value.absent(),
            Value<String?> geom = const Value.absent(),
            Value<int?> altitudeMin = const Value.absent(),
            Value<int?> altitudeMax = const Value.absent(),
          }) =>
              TSitesGroupsCompanion.insert(
            idSitesGroup: idSitesGroup,
            sitesGroupName: sitesGroupName,
            sitesGroupCode: sitesGroupCode,
            sitesGroupDescription: sitesGroupDescription,
            uuidSitesGroup: uuidSitesGroup,
            comments: comments,
            data: data,
            metaCreateDate: metaCreateDate,
            metaUpdateDate: metaUpdateDate,
            idDigitiser: idDigitiser,
            geom: geom,
            altitudeMin: altitudeMin,
            altitudeMax: altitudeMax,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TSitesGroupsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TSitesGroupsTable,
    TSitesGroup,
    $$TSitesGroupsTableFilterComposer,
    $$TSitesGroupsTableOrderingComposer,
    $$TSitesGroupsTableAnnotationComposer,
    $$TSitesGroupsTableCreateCompanionBuilder,
    $$TSitesGroupsTableUpdateCompanionBuilder,
    (
      TSitesGroup,
      BaseReferences<_$AppDatabase, $TSitesGroupsTable, TSitesGroup>
    ),
    TSitesGroup,
    PrefetchHooks Function()>;
typedef $$TSiteComplementsTableCreateCompanionBuilder
    = TSiteComplementsCompanion Function({
  Value<int> idBaseSite,
  Value<int?> idSitesGroup,
  Value<String?> data,
});
typedef $$TSiteComplementsTableUpdateCompanionBuilder
    = TSiteComplementsCompanion Function({
  Value<int> idBaseSite,
  Value<int?> idSitesGroup,
  Value<String?> data,
});

class $$TSiteComplementsTableFilterComposer
    extends Composer<_$AppDatabase, $TSiteComplementsTable> {
  $$TSiteComplementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idBaseSite => $composableBuilder(
      column: $table.idBaseSite, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idSitesGroup => $composableBuilder(
      column: $table.idSitesGroup, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnFilters(column));
}

class $$TSiteComplementsTableOrderingComposer
    extends Composer<_$AppDatabase, $TSiteComplementsTable> {
  $$TSiteComplementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idBaseSite => $composableBuilder(
      column: $table.idBaseSite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idSitesGroup => $composableBuilder(
      column: $table.idSitesGroup,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnOrderings(column));
}

class $$TSiteComplementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TSiteComplementsTable> {
  $$TSiteComplementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idBaseSite => $composableBuilder(
      column: $table.idBaseSite, builder: (column) => column);

  GeneratedColumn<int> get idSitesGroup => $composableBuilder(
      column: $table.idSitesGroup, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);
}

class $$TSiteComplementsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TSiteComplementsTable,
    TSiteComplement,
    $$TSiteComplementsTableFilterComposer,
    $$TSiteComplementsTableOrderingComposer,
    $$TSiteComplementsTableAnnotationComposer,
    $$TSiteComplementsTableCreateCompanionBuilder,
    $$TSiteComplementsTableUpdateCompanionBuilder,
    (
      TSiteComplement,
      BaseReferences<_$AppDatabase, $TSiteComplementsTable, TSiteComplement>
    ),
    TSiteComplement,
    PrefetchHooks Function()> {
  $$TSiteComplementsTableTableManager(
      _$AppDatabase db, $TSiteComplementsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TSiteComplementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TSiteComplementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TSiteComplementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> idBaseSite = const Value.absent(),
            Value<int?> idSitesGroup = const Value.absent(),
            Value<String?> data = const Value.absent(),
          }) =>
              TSiteComplementsCompanion(
            idBaseSite: idBaseSite,
            idSitesGroup: idSitesGroup,
            data: data,
          ),
          createCompanionCallback: ({
            Value<int> idBaseSite = const Value.absent(),
            Value<int?> idSitesGroup = const Value.absent(),
            Value<String?> data = const Value.absent(),
          }) =>
              TSiteComplementsCompanion.insert(
            idBaseSite: idBaseSite,
            idSitesGroup: idSitesGroup,
            data: data,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TSiteComplementsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TSiteComplementsTable,
    TSiteComplement,
    $$TSiteComplementsTableFilterComposer,
    $$TSiteComplementsTableOrderingComposer,
    $$TSiteComplementsTableAnnotationComposer,
    $$TSiteComplementsTableCreateCompanionBuilder,
    $$TSiteComplementsTableUpdateCompanionBuilder,
    (
      TSiteComplement,
      BaseReferences<_$AppDatabase, $TSiteComplementsTable, TSiteComplement>
    ),
    TSiteComplement,
    PrefetchHooks Function()>;
typedef $$TVisitComplementsTableCreateCompanionBuilder
    = TVisitComplementsCompanion Function({
  Value<int> idBaseVisit,
  Value<String?> data,
});
typedef $$TVisitComplementsTableUpdateCompanionBuilder
    = TVisitComplementsCompanion Function({
  Value<int> idBaseVisit,
  Value<String?> data,
});

class $$TVisitComplementsTableFilterComposer
    extends Composer<_$AppDatabase, $TVisitComplementsTable> {
  $$TVisitComplementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idBaseVisit => $composableBuilder(
      column: $table.idBaseVisit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnFilters(column));
}

class $$TVisitComplementsTableOrderingComposer
    extends Composer<_$AppDatabase, $TVisitComplementsTable> {
  $$TVisitComplementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idBaseVisit => $composableBuilder(
      column: $table.idBaseVisit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnOrderings(column));
}

class $$TVisitComplementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TVisitComplementsTable> {
  $$TVisitComplementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idBaseVisit => $composableBuilder(
      column: $table.idBaseVisit, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);
}

class $$TVisitComplementsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TVisitComplementsTable,
    TVisitComplement,
    $$TVisitComplementsTableFilterComposer,
    $$TVisitComplementsTableOrderingComposer,
    $$TVisitComplementsTableAnnotationComposer,
    $$TVisitComplementsTableCreateCompanionBuilder,
    $$TVisitComplementsTableUpdateCompanionBuilder,
    (
      TVisitComplement,
      BaseReferences<_$AppDatabase, $TVisitComplementsTable, TVisitComplement>
    ),
    TVisitComplement,
    PrefetchHooks Function()> {
  $$TVisitComplementsTableTableManager(
      _$AppDatabase db, $TVisitComplementsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TVisitComplementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TVisitComplementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TVisitComplementsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> idBaseVisit = const Value.absent(),
            Value<String?> data = const Value.absent(),
          }) =>
              TVisitComplementsCompanion(
            idBaseVisit: idBaseVisit,
            data: data,
          ),
          createCompanionCallback: ({
            Value<int> idBaseVisit = const Value.absent(),
            Value<String?> data = const Value.absent(),
          }) =>
              TVisitComplementsCompanion.insert(
            idBaseVisit: idBaseVisit,
            data: data,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TVisitComplementsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TVisitComplementsTable,
    TVisitComplement,
    $$TVisitComplementsTableFilterComposer,
    $$TVisitComplementsTableOrderingComposer,
    $$TVisitComplementsTableAnnotationComposer,
    $$TVisitComplementsTableCreateCompanionBuilder,
    $$TVisitComplementsTableUpdateCompanionBuilder,
    (
      TVisitComplement,
      BaseReferences<_$AppDatabase, $TVisitComplementsTable, TVisitComplement>
    ),
    TVisitComplement,
    PrefetchHooks Function()>;
typedef $$TObservationsTableCreateCompanionBuilder = TObservationsCompanion
    Function({
  Value<int> idObservation,
  Value<int?> idBaseVisit,
  Value<int?> cdNom,
  Value<String?> comments,
  Value<String?> uuidObservation,
});
typedef $$TObservationsTableUpdateCompanionBuilder = TObservationsCompanion
    Function({
  Value<int> idObservation,
  Value<int?> idBaseVisit,
  Value<int?> cdNom,
  Value<String?> comments,
  Value<String?> uuidObservation,
});

class $$TObservationsTableFilterComposer
    extends Composer<_$AppDatabase, $TObservationsTable> {
  $$TObservationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idObservation => $composableBuilder(
      column: $table.idObservation, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idBaseVisit => $composableBuilder(
      column: $table.idBaseVisit, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cdNom => $composableBuilder(
      column: $table.cdNom, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get comments => $composableBuilder(
      column: $table.comments, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuidObservation => $composableBuilder(
      column: $table.uuidObservation,
      builder: (column) => ColumnFilters(column));
}

class $$TObservationsTableOrderingComposer
    extends Composer<_$AppDatabase, $TObservationsTable> {
  $$TObservationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idObservation => $composableBuilder(
      column: $table.idObservation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idBaseVisit => $composableBuilder(
      column: $table.idBaseVisit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cdNom => $composableBuilder(
      column: $table.cdNom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get comments => $composableBuilder(
      column: $table.comments, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuidObservation => $composableBuilder(
      column: $table.uuidObservation,
      builder: (column) => ColumnOrderings(column));
}

class $$TObservationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TObservationsTable> {
  $$TObservationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idObservation => $composableBuilder(
      column: $table.idObservation, builder: (column) => column);

  GeneratedColumn<int> get idBaseVisit => $composableBuilder(
      column: $table.idBaseVisit, builder: (column) => column);

  GeneratedColumn<int> get cdNom =>
      $composableBuilder(column: $table.cdNom, builder: (column) => column);

  GeneratedColumn<String> get comments =>
      $composableBuilder(column: $table.comments, builder: (column) => column);

  GeneratedColumn<String> get uuidObservation => $composableBuilder(
      column: $table.uuidObservation, builder: (column) => column);
}

class $$TObservationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TObservationsTable,
    TObservation,
    $$TObservationsTableFilterComposer,
    $$TObservationsTableOrderingComposer,
    $$TObservationsTableAnnotationComposer,
    $$TObservationsTableCreateCompanionBuilder,
    $$TObservationsTableUpdateCompanionBuilder,
    (
      TObservation,
      BaseReferences<_$AppDatabase, $TObservationsTable, TObservation>
    ),
    TObservation,
    PrefetchHooks Function()> {
  $$TObservationsTableTableManager(_$AppDatabase db, $TObservationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TObservationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TObservationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TObservationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> idObservation = const Value.absent(),
            Value<int?> idBaseVisit = const Value.absent(),
            Value<int?> cdNom = const Value.absent(),
            Value<String?> comments = const Value.absent(),
            Value<String?> uuidObservation = const Value.absent(),
          }) =>
              TObservationsCompanion(
            idObservation: idObservation,
            idBaseVisit: idBaseVisit,
            cdNom: cdNom,
            comments: comments,
            uuidObservation: uuidObservation,
          ),
          createCompanionCallback: ({
            Value<int> idObservation = const Value.absent(),
            Value<int?> idBaseVisit = const Value.absent(),
            Value<int?> cdNom = const Value.absent(),
            Value<String?> comments = const Value.absent(),
            Value<String?> uuidObservation = const Value.absent(),
          }) =>
              TObservationsCompanion.insert(
            idObservation: idObservation,
            idBaseVisit: idBaseVisit,
            cdNom: cdNom,
            comments: comments,
            uuidObservation: uuidObservation,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TObservationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TObservationsTable,
    TObservation,
    $$TObservationsTableFilterComposer,
    $$TObservationsTableOrderingComposer,
    $$TObservationsTableAnnotationComposer,
    $$TObservationsTableCreateCompanionBuilder,
    $$TObservationsTableUpdateCompanionBuilder,
    (
      TObservation,
      BaseReferences<_$AppDatabase, $TObservationsTable, TObservation>
    ),
    TObservation,
    PrefetchHooks Function()>;
typedef $$TObservationComplementsTableCreateCompanionBuilder
    = TObservationComplementsCompanion Function({
  Value<int> idObservation,
  Value<String?> data,
});
typedef $$TObservationComplementsTableUpdateCompanionBuilder
    = TObservationComplementsCompanion Function({
  Value<int> idObservation,
  Value<String?> data,
});

class $$TObservationComplementsTableFilterComposer
    extends Composer<_$AppDatabase, $TObservationComplementsTable> {
  $$TObservationComplementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idObservation => $composableBuilder(
      column: $table.idObservation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnFilters(column));
}

class $$TObservationComplementsTableOrderingComposer
    extends Composer<_$AppDatabase, $TObservationComplementsTable> {
  $$TObservationComplementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idObservation => $composableBuilder(
      column: $table.idObservation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnOrderings(column));
}

class $$TObservationComplementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TObservationComplementsTable> {
  $$TObservationComplementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idObservation => $composableBuilder(
      column: $table.idObservation, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);
}

class $$TObservationComplementsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TObservationComplementsTable,
    TObservationComplement,
    $$TObservationComplementsTableFilterComposer,
    $$TObservationComplementsTableOrderingComposer,
    $$TObservationComplementsTableAnnotationComposer,
    $$TObservationComplementsTableCreateCompanionBuilder,
    $$TObservationComplementsTableUpdateCompanionBuilder,
    (
      TObservationComplement,
      BaseReferences<_$AppDatabase, $TObservationComplementsTable,
          TObservationComplement>
    ),
    TObservationComplement,
    PrefetchHooks Function()> {
  $$TObservationComplementsTableTableManager(
      _$AppDatabase db, $TObservationComplementsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TObservationComplementsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$TObservationComplementsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TObservationComplementsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> idObservation = const Value.absent(),
            Value<String?> data = const Value.absent(),
          }) =>
              TObservationComplementsCompanion(
            idObservation: idObservation,
            data: data,
          ),
          createCompanionCallback: ({
            Value<int> idObservation = const Value.absent(),
            Value<String?> data = const Value.absent(),
          }) =>
              TObservationComplementsCompanion.insert(
            idObservation: idObservation,
            data: data,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TObservationComplementsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $TObservationComplementsTable,
        TObservationComplement,
        $$TObservationComplementsTableFilterComposer,
        $$TObservationComplementsTableOrderingComposer,
        $$TObservationComplementsTableAnnotationComposer,
        $$TObservationComplementsTableCreateCompanionBuilder,
        $$TObservationComplementsTableUpdateCompanionBuilder,
        (
          TObservationComplement,
          BaseReferences<_$AppDatabase, $TObservationComplementsTable,
              TObservationComplement>
        ),
        TObservationComplement,
        PrefetchHooks Function()>;
typedef $$TObservationDetailsTableCreateCompanionBuilder
    = TObservationDetailsCompanion Function({
  Value<int> idObservationDetail,
  Value<int?> idObservation,
  Value<String> uuidObservationDetail,
  Value<String?> data,
});
typedef $$TObservationDetailsTableUpdateCompanionBuilder
    = TObservationDetailsCompanion Function({
  Value<int> idObservationDetail,
  Value<int?> idObservation,
  Value<String> uuidObservationDetail,
  Value<String?> data,
});

class $$TObservationDetailsTableFilterComposer
    extends Composer<_$AppDatabase, $TObservationDetailsTable> {
  $$TObservationDetailsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idObservationDetail => $composableBuilder(
      column: $table.idObservationDetail,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idObservation => $composableBuilder(
      column: $table.idObservation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuidObservationDetail => $composableBuilder(
      column: $table.uuidObservationDetail,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnFilters(column));
}

class $$TObservationDetailsTableOrderingComposer
    extends Composer<_$AppDatabase, $TObservationDetailsTable> {
  $$TObservationDetailsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idObservationDetail => $composableBuilder(
      column: $table.idObservationDetail,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idObservation => $composableBuilder(
      column: $table.idObservation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuidObservationDetail => $composableBuilder(
      column: $table.uuidObservationDetail,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnOrderings(column));
}

class $$TObservationDetailsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TObservationDetailsTable> {
  $$TObservationDetailsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idObservationDetail => $composableBuilder(
      column: $table.idObservationDetail, builder: (column) => column);

  GeneratedColumn<int> get idObservation => $composableBuilder(
      column: $table.idObservation, builder: (column) => column);

  GeneratedColumn<String> get uuidObservationDetail => $composableBuilder(
      column: $table.uuidObservationDetail, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);
}

class $$TObservationDetailsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TObservationDetailsTable,
    TObservationDetail,
    $$TObservationDetailsTableFilterComposer,
    $$TObservationDetailsTableOrderingComposer,
    $$TObservationDetailsTableAnnotationComposer,
    $$TObservationDetailsTableCreateCompanionBuilder,
    $$TObservationDetailsTableUpdateCompanionBuilder,
    (
      TObservationDetail,
      BaseReferences<_$AppDatabase, $TObservationDetailsTable,
          TObservationDetail>
    ),
    TObservationDetail,
    PrefetchHooks Function()> {
  $$TObservationDetailsTableTableManager(
      _$AppDatabase db, $TObservationDetailsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TObservationDetailsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TObservationDetailsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TObservationDetailsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> idObservationDetail = const Value.absent(),
            Value<int?> idObservation = const Value.absent(),
            Value<String> uuidObservationDetail = const Value.absent(),
            Value<String?> data = const Value.absent(),
          }) =>
              TObservationDetailsCompanion(
            idObservationDetail: idObservationDetail,
            idObservation: idObservation,
            uuidObservationDetail: uuidObservationDetail,
            data: data,
          ),
          createCompanionCallback: ({
            Value<int> idObservationDetail = const Value.absent(),
            Value<int?> idObservation = const Value.absent(),
            Value<String> uuidObservationDetail = const Value.absent(),
            Value<String?> data = const Value.absent(),
          }) =>
              TObservationDetailsCompanion.insert(
            idObservationDetail: idObservationDetail,
            idObservation: idObservation,
            uuidObservationDetail: uuidObservationDetail,
            data: data,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TObservationDetailsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TObservationDetailsTable,
    TObservationDetail,
    $$TObservationDetailsTableFilterComposer,
    $$TObservationDetailsTableOrderingComposer,
    $$TObservationDetailsTableAnnotationComposer,
    $$TObservationDetailsTableCreateCompanionBuilder,
    $$TObservationDetailsTableUpdateCompanionBuilder,
    (
      TObservationDetail,
      BaseReferences<_$AppDatabase, $TObservationDetailsTable,
          TObservationDetail>
    ),
    TObservationDetail,
    PrefetchHooks Function()>;
typedef $$BibTablesLocationsTableCreateCompanionBuilder
    = BibTablesLocationsCompanion Function({
  Value<int> idTableLocation,
  Value<String?> tableDesc,
  Value<String?> schemaName,
  Value<String?> tableNameLabel,
  Value<String?> pkField,
  Value<String?> uuidFieldName,
});
typedef $$BibTablesLocationsTableUpdateCompanionBuilder
    = BibTablesLocationsCompanion Function({
  Value<int> idTableLocation,
  Value<String?> tableDesc,
  Value<String?> schemaName,
  Value<String?> tableNameLabel,
  Value<String?> pkField,
  Value<String?> uuidFieldName,
});

class $$BibTablesLocationsTableFilterComposer
    extends Composer<_$AppDatabase, $BibTablesLocationsTable> {
  $$BibTablesLocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idTableLocation => $composableBuilder(
      column: $table.idTableLocation,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tableDesc => $composableBuilder(
      column: $table.tableDesc, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get schemaName => $composableBuilder(
      column: $table.schemaName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tableNameLabel => $composableBuilder(
      column: $table.tableNameLabel,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pkField => $composableBuilder(
      column: $table.pkField, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuidFieldName => $composableBuilder(
      column: $table.uuidFieldName, builder: (column) => ColumnFilters(column));
}

class $$BibTablesLocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $BibTablesLocationsTable> {
  $$BibTablesLocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idTableLocation => $composableBuilder(
      column: $table.idTableLocation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tableDesc => $composableBuilder(
      column: $table.tableDesc, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get schemaName => $composableBuilder(
      column: $table.schemaName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tableNameLabel => $composableBuilder(
      column: $table.tableNameLabel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pkField => $composableBuilder(
      column: $table.pkField, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuidFieldName => $composableBuilder(
      column: $table.uuidFieldName,
      builder: (column) => ColumnOrderings(column));
}

class $$BibTablesLocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BibTablesLocationsTable> {
  $$BibTablesLocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idTableLocation => $composableBuilder(
      column: $table.idTableLocation, builder: (column) => column);

  GeneratedColumn<String> get tableDesc =>
      $composableBuilder(column: $table.tableDesc, builder: (column) => column);

  GeneratedColumn<String> get schemaName => $composableBuilder(
      column: $table.schemaName, builder: (column) => column);

  GeneratedColumn<String> get tableNameLabel => $composableBuilder(
      column: $table.tableNameLabel, builder: (column) => column);

  GeneratedColumn<String> get pkField =>
      $composableBuilder(column: $table.pkField, builder: (column) => column);

  GeneratedColumn<String> get uuidFieldName => $composableBuilder(
      column: $table.uuidFieldName, builder: (column) => column);
}

class $$BibTablesLocationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BibTablesLocationsTable,
    BibTablesLocation,
    $$BibTablesLocationsTableFilterComposer,
    $$BibTablesLocationsTableOrderingComposer,
    $$BibTablesLocationsTableAnnotationComposer,
    $$BibTablesLocationsTableCreateCompanionBuilder,
    $$BibTablesLocationsTableUpdateCompanionBuilder,
    (
      BibTablesLocation,
      BaseReferences<_$AppDatabase, $BibTablesLocationsTable, BibTablesLocation>
    ),
    BibTablesLocation,
    PrefetchHooks Function()> {
  $$BibTablesLocationsTableTableManager(
      _$AppDatabase db, $BibTablesLocationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BibTablesLocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BibTablesLocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BibTablesLocationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> idTableLocation = const Value.absent(),
            Value<String?> tableDesc = const Value.absent(),
            Value<String?> schemaName = const Value.absent(),
            Value<String?> tableNameLabel = const Value.absent(),
            Value<String?> pkField = const Value.absent(),
            Value<String?> uuidFieldName = const Value.absent(),
          }) =>
              BibTablesLocationsCompanion(
            idTableLocation: idTableLocation,
            tableDesc: tableDesc,
            schemaName: schemaName,
            tableNameLabel: tableNameLabel,
            pkField: pkField,
            uuidFieldName: uuidFieldName,
          ),
          createCompanionCallback: ({
            Value<int> idTableLocation = const Value.absent(),
            Value<String?> tableDesc = const Value.absent(),
            Value<String?> schemaName = const Value.absent(),
            Value<String?> tableNameLabel = const Value.absent(),
            Value<String?> pkField = const Value.absent(),
            Value<String?> uuidFieldName = const Value.absent(),
          }) =>
              BibTablesLocationsCompanion.insert(
            idTableLocation: idTableLocation,
            tableDesc: tableDesc,
            schemaName: schemaName,
            tableNameLabel: tableNameLabel,
            pkField: pkField,
            uuidFieldName: uuidFieldName,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BibTablesLocationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BibTablesLocationsTable,
    BibTablesLocation,
    $$BibTablesLocationsTableFilterComposer,
    $$BibTablesLocationsTableOrderingComposer,
    $$BibTablesLocationsTableAnnotationComposer,
    $$BibTablesLocationsTableCreateCompanionBuilder,
    $$BibTablesLocationsTableUpdateCompanionBuilder,
    (
      BibTablesLocation,
      BaseReferences<_$AppDatabase, $BibTablesLocationsTable, BibTablesLocation>
    ),
    BibTablesLocation,
    PrefetchHooks Function()>;
typedef $$BibNomenclaturesTypesTableTableCreateCompanionBuilder
    = BibNomenclaturesTypesTableCompanion Function({
  Value<int> idType,
  Value<String?> mnemonique,
  Value<String?> labelDefault,
  Value<String?> definitionDefault,
  Value<String?> labelFr,
  Value<String?> definitionFr,
  Value<String?> labelEn,
  Value<String?> definitionEn,
  Value<String?> labelEs,
  Value<String?> definitionEs,
  Value<String?> labelDe,
  Value<String?> definitionDe,
  Value<String?> labelIt,
  Value<String?> definitionIt,
  Value<String?> source,
  Value<String?> statut,
  Value<DateTime?> metaCreateDate,
  Value<DateTime?> metaUpdateDate,
});
typedef $$BibNomenclaturesTypesTableTableUpdateCompanionBuilder
    = BibNomenclaturesTypesTableCompanion Function({
  Value<int> idType,
  Value<String?> mnemonique,
  Value<String?> labelDefault,
  Value<String?> definitionDefault,
  Value<String?> labelFr,
  Value<String?> definitionFr,
  Value<String?> labelEn,
  Value<String?> definitionEn,
  Value<String?> labelEs,
  Value<String?> definitionEs,
  Value<String?> labelDe,
  Value<String?> definitionDe,
  Value<String?> labelIt,
  Value<String?> definitionIt,
  Value<String?> source,
  Value<String?> statut,
  Value<DateTime?> metaCreateDate,
  Value<DateTime?> metaUpdateDate,
});

class $$BibNomenclaturesTypesTableTableFilterComposer
    extends Composer<_$AppDatabase, $BibNomenclaturesTypesTableTable> {
  $$BibNomenclaturesTypesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idType => $composableBuilder(
      column: $table.idType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mnemonique => $composableBuilder(
      column: $table.mnemonique, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get labelDefault => $composableBuilder(
      column: $table.labelDefault, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get definitionDefault => $composableBuilder(
      column: $table.definitionDefault,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get labelFr => $composableBuilder(
      column: $table.labelFr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get definitionFr => $composableBuilder(
      column: $table.definitionFr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get labelEn => $composableBuilder(
      column: $table.labelEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get definitionEn => $composableBuilder(
      column: $table.definitionEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get labelEs => $composableBuilder(
      column: $table.labelEs, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get definitionEs => $composableBuilder(
      column: $table.definitionEs, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get labelDe => $composableBuilder(
      column: $table.labelDe, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get definitionDe => $composableBuilder(
      column: $table.definitionDe, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get labelIt => $composableBuilder(
      column: $table.labelIt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get definitionIt => $composableBuilder(
      column: $table.definitionIt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get statut => $composableBuilder(
      column: $table.statut, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get metaCreateDate => $composableBuilder(
      column: $table.metaCreateDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get metaUpdateDate => $composableBuilder(
      column: $table.metaUpdateDate,
      builder: (column) => ColumnFilters(column));
}

class $$BibNomenclaturesTypesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BibNomenclaturesTypesTableTable> {
  $$BibNomenclaturesTypesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idType => $composableBuilder(
      column: $table.idType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mnemonique => $composableBuilder(
      column: $table.mnemonique, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get labelDefault => $composableBuilder(
      column: $table.labelDefault,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get definitionDefault => $composableBuilder(
      column: $table.definitionDefault,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get labelFr => $composableBuilder(
      column: $table.labelFr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get definitionFr => $composableBuilder(
      column: $table.definitionFr,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get labelEn => $composableBuilder(
      column: $table.labelEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get definitionEn => $composableBuilder(
      column: $table.definitionEn,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get labelEs => $composableBuilder(
      column: $table.labelEs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get definitionEs => $composableBuilder(
      column: $table.definitionEs,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get labelDe => $composableBuilder(
      column: $table.labelDe, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get definitionDe => $composableBuilder(
      column: $table.definitionDe,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get labelIt => $composableBuilder(
      column: $table.labelIt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get definitionIt => $composableBuilder(
      column: $table.definitionIt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get statut => $composableBuilder(
      column: $table.statut, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get metaCreateDate => $composableBuilder(
      column: $table.metaCreateDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get metaUpdateDate => $composableBuilder(
      column: $table.metaUpdateDate,
      builder: (column) => ColumnOrderings(column));
}

class $$BibNomenclaturesTypesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BibNomenclaturesTypesTableTable> {
  $$BibNomenclaturesTypesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idType =>
      $composableBuilder(column: $table.idType, builder: (column) => column);

  GeneratedColumn<String> get mnemonique => $composableBuilder(
      column: $table.mnemonique, builder: (column) => column);

  GeneratedColumn<String> get labelDefault => $composableBuilder(
      column: $table.labelDefault, builder: (column) => column);

  GeneratedColumn<String> get definitionDefault => $composableBuilder(
      column: $table.definitionDefault, builder: (column) => column);

  GeneratedColumn<String> get labelFr =>
      $composableBuilder(column: $table.labelFr, builder: (column) => column);

  GeneratedColumn<String> get definitionFr => $composableBuilder(
      column: $table.definitionFr, builder: (column) => column);

  GeneratedColumn<String> get labelEn =>
      $composableBuilder(column: $table.labelEn, builder: (column) => column);

  GeneratedColumn<String> get definitionEn => $composableBuilder(
      column: $table.definitionEn, builder: (column) => column);

  GeneratedColumn<String> get labelEs =>
      $composableBuilder(column: $table.labelEs, builder: (column) => column);

  GeneratedColumn<String> get definitionEs => $composableBuilder(
      column: $table.definitionEs, builder: (column) => column);

  GeneratedColumn<String> get labelDe =>
      $composableBuilder(column: $table.labelDe, builder: (column) => column);

  GeneratedColumn<String> get definitionDe => $composableBuilder(
      column: $table.definitionDe, builder: (column) => column);

  GeneratedColumn<String> get labelIt =>
      $composableBuilder(column: $table.labelIt, builder: (column) => column);

  GeneratedColumn<String> get definitionIt => $composableBuilder(
      column: $table.definitionIt, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get statut =>
      $composableBuilder(column: $table.statut, builder: (column) => column);

  GeneratedColumn<DateTime> get metaCreateDate => $composableBuilder(
      column: $table.metaCreateDate, builder: (column) => column);

  GeneratedColumn<DateTime> get metaUpdateDate => $composableBuilder(
      column: $table.metaUpdateDate, builder: (column) => column);
}

class $$BibNomenclaturesTypesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BibNomenclaturesTypesTableTable,
    BibNomenclatureType,
    $$BibNomenclaturesTypesTableTableFilterComposer,
    $$BibNomenclaturesTypesTableTableOrderingComposer,
    $$BibNomenclaturesTypesTableTableAnnotationComposer,
    $$BibNomenclaturesTypesTableTableCreateCompanionBuilder,
    $$BibNomenclaturesTypesTableTableUpdateCompanionBuilder,
    (
      BibNomenclatureType,
      BaseReferences<_$AppDatabase, $BibNomenclaturesTypesTableTable,
          BibNomenclatureType>
    ),
    BibNomenclatureType,
    PrefetchHooks Function()> {
  $$BibNomenclaturesTypesTableTableTableManager(
      _$AppDatabase db, $BibNomenclaturesTypesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BibNomenclaturesTypesTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$BibNomenclaturesTypesTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BibNomenclaturesTypesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> idType = const Value.absent(),
            Value<String?> mnemonique = const Value.absent(),
            Value<String?> labelDefault = const Value.absent(),
            Value<String?> definitionDefault = const Value.absent(),
            Value<String?> labelFr = const Value.absent(),
            Value<String?> definitionFr = const Value.absent(),
            Value<String?> labelEn = const Value.absent(),
            Value<String?> definitionEn = const Value.absent(),
            Value<String?> labelEs = const Value.absent(),
            Value<String?> definitionEs = const Value.absent(),
            Value<String?> labelDe = const Value.absent(),
            Value<String?> definitionDe = const Value.absent(),
            Value<String?> labelIt = const Value.absent(),
            Value<String?> definitionIt = const Value.absent(),
            Value<String?> source = const Value.absent(),
            Value<String?> statut = const Value.absent(),
            Value<DateTime?> metaCreateDate = const Value.absent(),
            Value<DateTime?> metaUpdateDate = const Value.absent(),
          }) =>
              BibNomenclaturesTypesTableCompanion(
            idType: idType,
            mnemonique: mnemonique,
            labelDefault: labelDefault,
            definitionDefault: definitionDefault,
            labelFr: labelFr,
            definitionFr: definitionFr,
            labelEn: labelEn,
            definitionEn: definitionEn,
            labelEs: labelEs,
            definitionEs: definitionEs,
            labelDe: labelDe,
            definitionDe: definitionDe,
            labelIt: labelIt,
            definitionIt: definitionIt,
            source: source,
            statut: statut,
            metaCreateDate: metaCreateDate,
            metaUpdateDate: metaUpdateDate,
          ),
          createCompanionCallback: ({
            Value<int> idType = const Value.absent(),
            Value<String?> mnemonique = const Value.absent(),
            Value<String?> labelDefault = const Value.absent(),
            Value<String?> definitionDefault = const Value.absent(),
            Value<String?> labelFr = const Value.absent(),
            Value<String?> definitionFr = const Value.absent(),
            Value<String?> labelEn = const Value.absent(),
            Value<String?> definitionEn = const Value.absent(),
            Value<String?> labelEs = const Value.absent(),
            Value<String?> definitionEs = const Value.absent(),
            Value<String?> labelDe = const Value.absent(),
            Value<String?> definitionDe = const Value.absent(),
            Value<String?> labelIt = const Value.absent(),
            Value<String?> definitionIt = const Value.absent(),
            Value<String?> source = const Value.absent(),
            Value<String?> statut = const Value.absent(),
            Value<DateTime?> metaCreateDate = const Value.absent(),
            Value<DateTime?> metaUpdateDate = const Value.absent(),
          }) =>
              BibNomenclaturesTypesTableCompanion.insert(
            idType: idType,
            mnemonique: mnemonique,
            labelDefault: labelDefault,
            definitionDefault: definitionDefault,
            labelFr: labelFr,
            definitionFr: definitionFr,
            labelEn: labelEn,
            definitionEn: definitionEn,
            labelEs: labelEs,
            definitionEs: definitionEs,
            labelDe: labelDe,
            definitionDe: definitionDe,
            labelIt: labelIt,
            definitionIt: definitionIt,
            source: source,
            statut: statut,
            metaCreateDate: metaCreateDate,
            metaUpdateDate: metaUpdateDate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BibNomenclaturesTypesTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $BibNomenclaturesTypesTableTable,
        BibNomenclatureType,
        $$BibNomenclaturesTypesTableTableFilterComposer,
        $$BibNomenclaturesTypesTableTableOrderingComposer,
        $$BibNomenclaturesTypesTableTableAnnotationComposer,
        $$BibNomenclaturesTypesTableTableCreateCompanionBuilder,
        $$BibNomenclaturesTypesTableTableUpdateCompanionBuilder,
        (
          BibNomenclatureType,
          BaseReferences<_$AppDatabase, $BibNomenclaturesTypesTableTable,
              BibNomenclatureType>
        ),
        BibNomenclatureType,
        PrefetchHooks Function()>;
typedef $$BibTypeSitesTableTableCreateCompanionBuilder
    = BibTypeSitesTableCompanion Function({
  Value<int> idNomenclatureTypeSite,
  Value<String?> config,
});
typedef $$BibTypeSitesTableTableUpdateCompanionBuilder
    = BibTypeSitesTableCompanion Function({
  Value<int> idNomenclatureTypeSite,
  Value<String?> config,
});

class $$BibTypeSitesTableTableFilterComposer
    extends Composer<_$AppDatabase, $BibTypeSitesTableTable> {
  $$BibTypeSitesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idNomenclatureTypeSite => $composableBuilder(
      column: $table.idNomenclatureTypeSite,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get config => $composableBuilder(
      column: $table.config, builder: (column) => ColumnFilters(column));
}

class $$BibTypeSitesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BibTypeSitesTableTable> {
  $$BibTypeSitesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idNomenclatureTypeSite => $composableBuilder(
      column: $table.idNomenclatureTypeSite,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get config => $composableBuilder(
      column: $table.config, builder: (column) => ColumnOrderings(column));
}

class $$BibTypeSitesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BibTypeSitesTableTable> {
  $$BibTypeSitesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idNomenclatureTypeSite => $composableBuilder(
      column: $table.idNomenclatureTypeSite, builder: (column) => column);

  GeneratedColumn<String> get config =>
      $composableBuilder(column: $table.config, builder: (column) => column);
}

class $$BibTypeSitesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BibTypeSitesTableTable,
    BibTypeSite,
    $$BibTypeSitesTableTableFilterComposer,
    $$BibTypeSitesTableTableOrderingComposer,
    $$BibTypeSitesTableTableAnnotationComposer,
    $$BibTypeSitesTableTableCreateCompanionBuilder,
    $$BibTypeSitesTableTableUpdateCompanionBuilder,
    (
      BibTypeSite,
      BaseReferences<_$AppDatabase, $BibTypeSitesTableTable, BibTypeSite>
    ),
    BibTypeSite,
    PrefetchHooks Function()> {
  $$BibTypeSitesTableTableTableManager(
      _$AppDatabase db, $BibTypeSitesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BibTypeSitesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BibTypeSitesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BibTypeSitesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> idNomenclatureTypeSite = const Value.absent(),
            Value<String?> config = const Value.absent(),
          }) =>
              BibTypeSitesTableCompanion(
            idNomenclatureTypeSite: idNomenclatureTypeSite,
            config: config,
          ),
          createCompanionCallback: ({
            Value<int> idNomenclatureTypeSite = const Value.absent(),
            Value<String?> config = const Value.absent(),
          }) =>
              BibTypeSitesTableCompanion.insert(
            idNomenclatureTypeSite: idNomenclatureTypeSite,
            config: config,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BibTypeSitesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BibTypeSitesTableTable,
    BibTypeSite,
    $$BibTypeSitesTableTableFilterComposer,
    $$BibTypeSitesTableTableOrderingComposer,
    $$BibTypeSitesTableTableAnnotationComposer,
    $$BibTypeSitesTableTableCreateCompanionBuilder,
    $$BibTypeSitesTableTableUpdateCompanionBuilder,
    (
      BibTypeSite,
      BaseReferences<_$AppDatabase, $BibTypeSitesTableTable, BibTypeSite>
    ),
    BibTypeSite,
    PrefetchHooks Function()>;
typedef $$TObjectsTableCreateCompanionBuilder = TObjectsCompanion Function({
  Value<int> idObject,
  required String codeObject,
  Value<String?> descriptionObject,
});
typedef $$TObjectsTableUpdateCompanionBuilder = TObjectsCompanion Function({
  Value<int> idObject,
  Value<String> codeObject,
  Value<String?> descriptionObject,
});

class $$TObjectsTableFilterComposer
    extends Composer<_$AppDatabase, $TObjectsTable> {
  $$TObjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idObject => $composableBuilder(
      column: $table.idObject, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get codeObject => $composableBuilder(
      column: $table.codeObject, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descriptionObject => $composableBuilder(
      column: $table.descriptionObject,
      builder: (column) => ColumnFilters(column));
}

class $$TObjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $TObjectsTable> {
  $$TObjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idObject => $composableBuilder(
      column: $table.idObject, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get codeObject => $composableBuilder(
      column: $table.codeObject, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descriptionObject => $composableBuilder(
      column: $table.descriptionObject,
      builder: (column) => ColumnOrderings(column));
}

class $$TObjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TObjectsTable> {
  $$TObjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idObject =>
      $composableBuilder(column: $table.idObject, builder: (column) => column);

  GeneratedColumn<String> get codeObject => $composableBuilder(
      column: $table.codeObject, builder: (column) => column);

  GeneratedColumn<String> get descriptionObject => $composableBuilder(
      column: $table.descriptionObject, builder: (column) => column);
}

class $$TObjectsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TObjectsTable,
    TObject,
    $$TObjectsTableFilterComposer,
    $$TObjectsTableOrderingComposer,
    $$TObjectsTableAnnotationComposer,
    $$TObjectsTableCreateCompanionBuilder,
    $$TObjectsTableUpdateCompanionBuilder,
    (TObject, BaseReferences<_$AppDatabase, $TObjectsTable, TObject>),
    TObject,
    PrefetchHooks Function()> {
  $$TObjectsTableTableManager(_$AppDatabase db, $TObjectsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TObjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TObjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TObjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> idObject = const Value.absent(),
            Value<String> codeObject = const Value.absent(),
            Value<String?> descriptionObject = const Value.absent(),
          }) =>
              TObjectsCompanion(
            idObject: idObject,
            codeObject: codeObject,
            descriptionObject: descriptionObject,
          ),
          createCompanionCallback: ({
            Value<int> idObject = const Value.absent(),
            required String codeObject,
            Value<String?> descriptionObject = const Value.absent(),
          }) =>
              TObjectsCompanion.insert(
            idObject: idObject,
            codeObject: codeObject,
            descriptionObject: descriptionObject,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TObjectsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TObjectsTable,
    TObject,
    $$TObjectsTableFilterComposer,
    $$TObjectsTableOrderingComposer,
    $$TObjectsTableAnnotationComposer,
    $$TObjectsTableCreateCompanionBuilder,
    $$TObjectsTableUpdateCompanionBuilder,
    (TObject, BaseReferences<_$AppDatabase, $TObjectsTable, TObject>),
    TObject,
    PrefetchHooks Function()>;
typedef $$TActionsTableCreateCompanionBuilder = TActionsCompanion Function({
  Value<int> idAction,
  Value<String?> codeAction,
  Value<String?> descriptionAction,
});
typedef $$TActionsTableUpdateCompanionBuilder = TActionsCompanion Function({
  Value<int> idAction,
  Value<String?> codeAction,
  Value<String?> descriptionAction,
});

class $$TActionsTableFilterComposer
    extends Composer<_$AppDatabase, $TActionsTable> {
  $$TActionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idAction => $composableBuilder(
      column: $table.idAction, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get codeAction => $composableBuilder(
      column: $table.codeAction, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descriptionAction => $composableBuilder(
      column: $table.descriptionAction,
      builder: (column) => ColumnFilters(column));
}

class $$TActionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TActionsTable> {
  $$TActionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idAction => $composableBuilder(
      column: $table.idAction, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get codeAction => $composableBuilder(
      column: $table.codeAction, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descriptionAction => $composableBuilder(
      column: $table.descriptionAction,
      builder: (column) => ColumnOrderings(column));
}

class $$TActionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TActionsTable> {
  $$TActionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idAction =>
      $composableBuilder(column: $table.idAction, builder: (column) => column);

  GeneratedColumn<String> get codeAction => $composableBuilder(
      column: $table.codeAction, builder: (column) => column);

  GeneratedColumn<String> get descriptionAction => $composableBuilder(
      column: $table.descriptionAction, builder: (column) => column);
}

class $$TActionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TActionsTable,
    TAction,
    $$TActionsTableFilterComposer,
    $$TActionsTableOrderingComposer,
    $$TActionsTableAnnotationComposer,
    $$TActionsTableCreateCompanionBuilder,
    $$TActionsTableUpdateCompanionBuilder,
    (TAction, BaseReferences<_$AppDatabase, $TActionsTable, TAction>),
    TAction,
    PrefetchHooks Function()> {
  $$TActionsTableTableManager(_$AppDatabase db, $TActionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TActionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TActionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TActionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> idAction = const Value.absent(),
            Value<String?> codeAction = const Value.absent(),
            Value<String?> descriptionAction = const Value.absent(),
          }) =>
              TActionsCompanion(
            idAction: idAction,
            codeAction: codeAction,
            descriptionAction: descriptionAction,
          ),
          createCompanionCallback: ({
            Value<int> idAction = const Value.absent(),
            Value<String?> codeAction = const Value.absent(),
            Value<String?> descriptionAction = const Value.absent(),
          }) =>
              TActionsCompanion.insert(
            idAction: idAction,
            codeAction: codeAction,
            descriptionAction: descriptionAction,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TActionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TActionsTable,
    TAction,
    $$TActionsTableFilterComposer,
    $$TActionsTableOrderingComposer,
    $$TActionsTableAnnotationComposer,
    $$TActionsTableCreateCompanionBuilder,
    $$TActionsTableUpdateCompanionBuilder,
    (TAction, BaseReferences<_$AppDatabase, $TActionsTable, TAction>),
    TAction,
    PrefetchHooks Function()>;
typedef $$TPermissionsAvailableTableCreateCompanionBuilder
    = TPermissionsAvailableCompanion Function({
  required int idModule,
  required int idObject,
  required int idAction,
  Value<String?> label,
  Value<bool> scopeFilter,
  Value<bool> sensitivityFilter,
  Value<int> rowid,
});
typedef $$TPermissionsAvailableTableUpdateCompanionBuilder
    = TPermissionsAvailableCompanion Function({
  Value<int> idModule,
  Value<int> idObject,
  Value<int> idAction,
  Value<String?> label,
  Value<bool> scopeFilter,
  Value<bool> sensitivityFilter,
  Value<int> rowid,
});

class $$TPermissionsAvailableTableFilterComposer
    extends Composer<_$AppDatabase, $TPermissionsAvailableTable> {
  $$TPermissionsAvailableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idModule => $composableBuilder(
      column: $table.idModule, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idObject => $composableBuilder(
      column: $table.idObject, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idAction => $composableBuilder(
      column: $table.idAction, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get scopeFilter => $composableBuilder(
      column: $table.scopeFilter, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get sensitivityFilter => $composableBuilder(
      column: $table.sensitivityFilter,
      builder: (column) => ColumnFilters(column));
}

class $$TPermissionsAvailableTableOrderingComposer
    extends Composer<_$AppDatabase, $TPermissionsAvailableTable> {
  $$TPermissionsAvailableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idModule => $composableBuilder(
      column: $table.idModule, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idObject => $composableBuilder(
      column: $table.idObject, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idAction => $composableBuilder(
      column: $table.idAction, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get scopeFilter => $composableBuilder(
      column: $table.scopeFilter, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get sensitivityFilter => $composableBuilder(
      column: $table.sensitivityFilter,
      builder: (column) => ColumnOrderings(column));
}

class $$TPermissionsAvailableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TPermissionsAvailableTable> {
  $$TPermissionsAvailableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idModule =>
      $composableBuilder(column: $table.idModule, builder: (column) => column);

  GeneratedColumn<int> get idObject =>
      $composableBuilder(column: $table.idObject, builder: (column) => column);

  GeneratedColumn<int> get idAction =>
      $composableBuilder(column: $table.idAction, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<bool> get scopeFilter => $composableBuilder(
      column: $table.scopeFilter, builder: (column) => column);

  GeneratedColumn<bool> get sensitivityFilter => $composableBuilder(
      column: $table.sensitivityFilter, builder: (column) => column);
}

class $$TPermissionsAvailableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TPermissionsAvailableTable,
    TPermissionAvailable,
    $$TPermissionsAvailableTableFilterComposer,
    $$TPermissionsAvailableTableOrderingComposer,
    $$TPermissionsAvailableTableAnnotationComposer,
    $$TPermissionsAvailableTableCreateCompanionBuilder,
    $$TPermissionsAvailableTableUpdateCompanionBuilder,
    (
      TPermissionAvailable,
      BaseReferences<_$AppDatabase, $TPermissionsAvailableTable,
          TPermissionAvailable>
    ),
    TPermissionAvailable,
    PrefetchHooks Function()> {
  $$TPermissionsAvailableTableTableManager(
      _$AppDatabase db, $TPermissionsAvailableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TPermissionsAvailableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$TPermissionsAvailableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TPermissionsAvailableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> idModule = const Value.absent(),
            Value<int> idObject = const Value.absent(),
            Value<int> idAction = const Value.absent(),
            Value<String?> label = const Value.absent(),
            Value<bool> scopeFilter = const Value.absent(),
            Value<bool> sensitivityFilter = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TPermissionsAvailableCompanion(
            idModule: idModule,
            idObject: idObject,
            idAction: idAction,
            label: label,
            scopeFilter: scopeFilter,
            sensitivityFilter: sensitivityFilter,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int idModule,
            required int idObject,
            required int idAction,
            Value<String?> label = const Value.absent(),
            Value<bool> scopeFilter = const Value.absent(),
            Value<bool> sensitivityFilter = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TPermissionsAvailableCompanion.insert(
            idModule: idModule,
            idObject: idObject,
            idAction: idAction,
            label: label,
            scopeFilter: scopeFilter,
            sensitivityFilter: sensitivityFilter,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TPermissionsAvailableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $TPermissionsAvailableTable,
        TPermissionAvailable,
        $$TPermissionsAvailableTableFilterComposer,
        $$TPermissionsAvailableTableOrderingComposer,
        $$TPermissionsAvailableTableAnnotationComposer,
        $$TPermissionsAvailableTableCreateCompanionBuilder,
        $$TPermissionsAvailableTableUpdateCompanionBuilder,
        (
          TPermissionAvailable,
          BaseReferences<_$AppDatabase, $TPermissionsAvailableTable,
              TPermissionAvailable>
        ),
        TPermissionAvailable,
        PrefetchHooks Function()>;
typedef $$TPermissionsTableCreateCompanionBuilder = TPermissionsCompanion
    Function({
  Value<int> idPermission,
  required int idRole,
  required int idAction,
  required int idModule,
  required int idObject,
  Value<int?> scopeValue,
  Value<bool> sensitivityFilter,
});
typedef $$TPermissionsTableUpdateCompanionBuilder = TPermissionsCompanion
    Function({
  Value<int> idPermission,
  Value<int> idRole,
  Value<int> idAction,
  Value<int> idModule,
  Value<int> idObject,
  Value<int?> scopeValue,
  Value<bool> sensitivityFilter,
});

class $$TPermissionsTableFilterComposer
    extends Composer<_$AppDatabase, $TPermissionsTable> {
  $$TPermissionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idPermission => $composableBuilder(
      column: $table.idPermission, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idRole => $composableBuilder(
      column: $table.idRole, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idAction => $composableBuilder(
      column: $table.idAction, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idModule => $composableBuilder(
      column: $table.idModule, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idObject => $composableBuilder(
      column: $table.idObject, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get scopeValue => $composableBuilder(
      column: $table.scopeValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get sensitivityFilter => $composableBuilder(
      column: $table.sensitivityFilter,
      builder: (column) => ColumnFilters(column));
}

class $$TPermissionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TPermissionsTable> {
  $$TPermissionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idPermission => $composableBuilder(
      column: $table.idPermission,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idRole => $composableBuilder(
      column: $table.idRole, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idAction => $composableBuilder(
      column: $table.idAction, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idModule => $composableBuilder(
      column: $table.idModule, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idObject => $composableBuilder(
      column: $table.idObject, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get scopeValue => $composableBuilder(
      column: $table.scopeValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get sensitivityFilter => $composableBuilder(
      column: $table.sensitivityFilter,
      builder: (column) => ColumnOrderings(column));
}

class $$TPermissionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TPermissionsTable> {
  $$TPermissionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idPermission => $composableBuilder(
      column: $table.idPermission, builder: (column) => column);

  GeneratedColumn<int> get idRole =>
      $composableBuilder(column: $table.idRole, builder: (column) => column);

  GeneratedColumn<int> get idAction =>
      $composableBuilder(column: $table.idAction, builder: (column) => column);

  GeneratedColumn<int> get idModule =>
      $composableBuilder(column: $table.idModule, builder: (column) => column);

  GeneratedColumn<int> get idObject =>
      $composableBuilder(column: $table.idObject, builder: (column) => column);

  GeneratedColumn<int> get scopeValue => $composableBuilder(
      column: $table.scopeValue, builder: (column) => column);

  GeneratedColumn<bool> get sensitivityFilter => $composableBuilder(
      column: $table.sensitivityFilter, builder: (column) => column);
}

class $$TPermissionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TPermissionsTable,
    TPermission,
    $$TPermissionsTableFilterComposer,
    $$TPermissionsTableOrderingComposer,
    $$TPermissionsTableAnnotationComposer,
    $$TPermissionsTableCreateCompanionBuilder,
    $$TPermissionsTableUpdateCompanionBuilder,
    (
      TPermission,
      BaseReferences<_$AppDatabase, $TPermissionsTable, TPermission>
    ),
    TPermission,
    PrefetchHooks Function()> {
  $$TPermissionsTableTableManager(_$AppDatabase db, $TPermissionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TPermissionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TPermissionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TPermissionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> idPermission = const Value.absent(),
            Value<int> idRole = const Value.absent(),
            Value<int> idAction = const Value.absent(),
            Value<int> idModule = const Value.absent(),
            Value<int> idObject = const Value.absent(),
            Value<int?> scopeValue = const Value.absent(),
            Value<bool> sensitivityFilter = const Value.absent(),
          }) =>
              TPermissionsCompanion(
            idPermission: idPermission,
            idRole: idRole,
            idAction: idAction,
            idModule: idModule,
            idObject: idObject,
            scopeValue: scopeValue,
            sensitivityFilter: sensitivityFilter,
          ),
          createCompanionCallback: ({
            Value<int> idPermission = const Value.absent(),
            required int idRole,
            required int idAction,
            required int idModule,
            required int idObject,
            Value<int?> scopeValue = const Value.absent(),
            Value<bool> sensitivityFilter = const Value.absent(),
          }) =>
              TPermissionsCompanion.insert(
            idPermission: idPermission,
            idRole: idRole,
            idAction: idAction,
            idModule: idModule,
            idObject: idObject,
            scopeValue: scopeValue,
            sensitivityFilter: sensitivityFilter,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TPermissionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TPermissionsTable,
    TPermission,
    $$TPermissionsTableFilterComposer,
    $$TPermissionsTableOrderingComposer,
    $$TPermissionsTableAnnotationComposer,
    $$TPermissionsTableCreateCompanionBuilder,
    $$TPermissionsTableUpdateCompanionBuilder,
    (
      TPermission,
      BaseReferences<_$AppDatabase, $TPermissionsTable, TPermission>
    ),
    TPermission,
    PrefetchHooks Function()>;
typedef $$CorSiteModuleTableTableCreateCompanionBuilder
    = CorSiteModuleTableCompanion Function({
  required int idBaseSite,
  required int idModule,
  Value<int> rowid,
});
typedef $$CorSiteModuleTableTableUpdateCompanionBuilder
    = CorSiteModuleTableCompanion Function({
  Value<int> idBaseSite,
  Value<int> idModule,
  Value<int> rowid,
});

class $$CorSiteModuleTableTableFilterComposer
    extends Composer<_$AppDatabase, $CorSiteModuleTableTable> {
  $$CorSiteModuleTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idBaseSite => $composableBuilder(
      column: $table.idBaseSite, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idModule => $composableBuilder(
      column: $table.idModule, builder: (column) => ColumnFilters(column));
}

class $$CorSiteModuleTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CorSiteModuleTableTable> {
  $$CorSiteModuleTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idBaseSite => $composableBuilder(
      column: $table.idBaseSite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idModule => $composableBuilder(
      column: $table.idModule, builder: (column) => ColumnOrderings(column));
}

class $$CorSiteModuleTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CorSiteModuleTableTable> {
  $$CorSiteModuleTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idBaseSite => $composableBuilder(
      column: $table.idBaseSite, builder: (column) => column);

  GeneratedColumn<int> get idModule =>
      $composableBuilder(column: $table.idModule, builder: (column) => column);
}

class $$CorSiteModuleTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CorSiteModuleTableTable,
    CorSiteModule,
    $$CorSiteModuleTableTableFilterComposer,
    $$CorSiteModuleTableTableOrderingComposer,
    $$CorSiteModuleTableTableAnnotationComposer,
    $$CorSiteModuleTableTableCreateCompanionBuilder,
    $$CorSiteModuleTableTableUpdateCompanionBuilder,
    (
      CorSiteModule,
      BaseReferences<_$AppDatabase, $CorSiteModuleTableTable, CorSiteModule>
    ),
    CorSiteModule,
    PrefetchHooks Function()> {
  $$CorSiteModuleTableTableTableManager(
      _$AppDatabase db, $CorSiteModuleTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CorSiteModuleTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CorSiteModuleTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CorSiteModuleTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> idBaseSite = const Value.absent(),
            Value<int> idModule = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CorSiteModuleTableCompanion(
            idBaseSite: idBaseSite,
            idModule: idModule,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int idBaseSite,
            required int idModule,
            Value<int> rowid = const Value.absent(),
          }) =>
              CorSiteModuleTableCompanion.insert(
            idBaseSite: idBaseSite,
            idModule: idModule,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CorSiteModuleTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CorSiteModuleTableTable,
    CorSiteModule,
    $$CorSiteModuleTableTableFilterComposer,
    $$CorSiteModuleTableTableOrderingComposer,
    $$CorSiteModuleTableTableAnnotationComposer,
    $$CorSiteModuleTableTableCreateCompanionBuilder,
    $$CorSiteModuleTableTableUpdateCompanionBuilder,
    (
      CorSiteModule,
      BaseReferences<_$AppDatabase, $CorSiteModuleTableTable, CorSiteModule>
    ),
    CorSiteModule,
    PrefetchHooks Function()>;
typedef $$CorSitesGroupModuleTableTableCreateCompanionBuilder
    = CorSitesGroupModuleTableCompanion Function({
  required int idSitesGroup,
  required int idModule,
  Value<int> rowid,
});
typedef $$CorSitesGroupModuleTableTableUpdateCompanionBuilder
    = CorSitesGroupModuleTableCompanion Function({
  Value<int> idSitesGroup,
  Value<int> idModule,
  Value<int> rowid,
});

class $$CorSitesGroupModuleTableTableFilterComposer
    extends Composer<_$AppDatabase, $CorSitesGroupModuleTableTable> {
  $$CorSitesGroupModuleTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idSitesGroup => $composableBuilder(
      column: $table.idSitesGroup, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idModule => $composableBuilder(
      column: $table.idModule, builder: (column) => ColumnFilters(column));
}

class $$CorSitesGroupModuleTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CorSitesGroupModuleTableTable> {
  $$CorSitesGroupModuleTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idSitesGroup => $composableBuilder(
      column: $table.idSitesGroup,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idModule => $composableBuilder(
      column: $table.idModule, builder: (column) => ColumnOrderings(column));
}

class $$CorSitesGroupModuleTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CorSitesGroupModuleTableTable> {
  $$CorSitesGroupModuleTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idSitesGroup => $composableBuilder(
      column: $table.idSitesGroup, builder: (column) => column);

  GeneratedColumn<int> get idModule =>
      $composableBuilder(column: $table.idModule, builder: (column) => column);
}

class $$CorSitesGroupModuleTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CorSitesGroupModuleTableTable,
    CorSitesGroupModule,
    $$CorSitesGroupModuleTableTableFilterComposer,
    $$CorSitesGroupModuleTableTableOrderingComposer,
    $$CorSitesGroupModuleTableTableAnnotationComposer,
    $$CorSitesGroupModuleTableTableCreateCompanionBuilder,
    $$CorSitesGroupModuleTableTableUpdateCompanionBuilder,
    (
      CorSitesGroupModule,
      BaseReferences<_$AppDatabase, $CorSitesGroupModuleTableTable,
          CorSitesGroupModule>
    ),
    CorSitesGroupModule,
    PrefetchHooks Function()> {
  $$CorSitesGroupModuleTableTableTableManager(
      _$AppDatabase db, $CorSitesGroupModuleTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CorSitesGroupModuleTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$CorSitesGroupModuleTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CorSitesGroupModuleTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> idSitesGroup = const Value.absent(),
            Value<int> idModule = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CorSitesGroupModuleTableCompanion(
            idSitesGroup: idSitesGroup,
            idModule: idModule,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int idSitesGroup,
            required int idModule,
            Value<int> rowid = const Value.absent(),
          }) =>
              CorSitesGroupModuleTableCompanion.insert(
            idSitesGroup: idSitesGroup,
            idModule: idModule,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CorSitesGroupModuleTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $CorSitesGroupModuleTableTable,
        CorSitesGroupModule,
        $$CorSitesGroupModuleTableTableFilterComposer,
        $$CorSitesGroupModuleTableTableOrderingComposer,
        $$CorSitesGroupModuleTableTableAnnotationComposer,
        $$CorSitesGroupModuleTableTableCreateCompanionBuilder,
        $$CorSitesGroupModuleTableTableUpdateCompanionBuilder,
        (
          CorSitesGroupModule,
          BaseReferences<_$AppDatabase, $CorSitesGroupModuleTableTable,
              CorSitesGroupModule>
        ),
        CorSitesGroupModule,
        PrefetchHooks Function()>;
typedef $$CorObjectModuleTableTableCreateCompanionBuilder
    = CorObjectModuleTableCompanion Function({
  Value<int> idCorObjectModule,
  required int idObject,
  required int idModule,
});
typedef $$CorObjectModuleTableTableUpdateCompanionBuilder
    = CorObjectModuleTableCompanion Function({
  Value<int> idCorObjectModule,
  Value<int> idObject,
  Value<int> idModule,
});

class $$CorObjectModuleTableTableFilterComposer
    extends Composer<_$AppDatabase, $CorObjectModuleTableTable> {
  $$CorObjectModuleTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idCorObjectModule => $composableBuilder(
      column: $table.idCorObjectModule,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idObject => $composableBuilder(
      column: $table.idObject, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idModule => $composableBuilder(
      column: $table.idModule, builder: (column) => ColumnFilters(column));
}

class $$CorObjectModuleTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CorObjectModuleTableTable> {
  $$CorObjectModuleTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idCorObjectModule => $composableBuilder(
      column: $table.idCorObjectModule,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idObject => $composableBuilder(
      column: $table.idObject, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idModule => $composableBuilder(
      column: $table.idModule, builder: (column) => ColumnOrderings(column));
}

class $$CorObjectModuleTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CorObjectModuleTableTable> {
  $$CorObjectModuleTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idCorObjectModule => $composableBuilder(
      column: $table.idCorObjectModule, builder: (column) => column);

  GeneratedColumn<int> get idObject =>
      $composableBuilder(column: $table.idObject, builder: (column) => column);

  GeneratedColumn<int> get idModule =>
      $composableBuilder(column: $table.idModule, builder: (column) => column);
}

class $$CorObjectModuleTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CorObjectModuleTableTable,
    CorObjectModule,
    $$CorObjectModuleTableTableFilterComposer,
    $$CorObjectModuleTableTableOrderingComposer,
    $$CorObjectModuleTableTableAnnotationComposer,
    $$CorObjectModuleTableTableCreateCompanionBuilder,
    $$CorObjectModuleTableTableUpdateCompanionBuilder,
    (
      CorObjectModule,
      BaseReferences<_$AppDatabase, $CorObjectModuleTableTable, CorObjectModule>
    ),
    CorObjectModule,
    PrefetchHooks Function()> {
  $$CorObjectModuleTableTableTableManager(
      _$AppDatabase db, $CorObjectModuleTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CorObjectModuleTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CorObjectModuleTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CorObjectModuleTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> idCorObjectModule = const Value.absent(),
            Value<int> idObject = const Value.absent(),
            Value<int> idModule = const Value.absent(),
          }) =>
              CorObjectModuleTableCompanion(
            idCorObjectModule: idCorObjectModule,
            idObject: idObject,
            idModule: idModule,
          ),
          createCompanionCallback: ({
            Value<int> idCorObjectModule = const Value.absent(),
            required int idObject,
            required int idModule,
          }) =>
              CorObjectModuleTableCompanion.insert(
            idCorObjectModule: idCorObjectModule,
            idObject: idObject,
            idModule: idModule,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CorObjectModuleTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $CorObjectModuleTableTable,
        CorObjectModule,
        $$CorObjectModuleTableTableFilterComposer,
        $$CorObjectModuleTableTableOrderingComposer,
        $$CorObjectModuleTableTableAnnotationComposer,
        $$CorObjectModuleTableTableCreateCompanionBuilder,
        $$CorObjectModuleTableTableUpdateCompanionBuilder,
        (
          CorObjectModule,
          BaseReferences<_$AppDatabase, $CorObjectModuleTableTable,
              CorObjectModule>
        ),
        CorObjectModule,
        PrefetchHooks Function()>;
typedef $$TBaseVisitsTableCreateCompanionBuilder = TBaseVisitsCompanion
    Function({
  Value<int> idBaseVisit,
  Value<int?> idBaseSite,
  required int idDataset,
  required int idModule,
  Value<int?> idDigitiser,
  required String visitDateMin,
  Value<String?> visitDateMax,
  Value<int?> idNomenclatureTechCollectCampanule,
  Value<int?> idNomenclatureGrpTyp,
  Value<String?> comments,
  Value<String?> uuidBaseVisit,
  Value<String> metaCreateDate,
  Value<String> metaUpdateDate,
});
typedef $$TBaseVisitsTableUpdateCompanionBuilder = TBaseVisitsCompanion
    Function({
  Value<int> idBaseVisit,
  Value<int?> idBaseSite,
  Value<int> idDataset,
  Value<int> idModule,
  Value<int?> idDigitiser,
  Value<String> visitDateMin,
  Value<String?> visitDateMax,
  Value<int?> idNomenclatureTechCollectCampanule,
  Value<int?> idNomenclatureGrpTyp,
  Value<String?> comments,
  Value<String?> uuidBaseVisit,
  Value<String> metaCreateDate,
  Value<String> metaUpdateDate,
});

final class $$TBaseVisitsTableReferences
    extends BaseReferences<_$AppDatabase, $TBaseVisitsTable, TBaseVisit> {
  $$TBaseVisitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CorVisitObserverTable, List<CorVisitObserverData>>
      _corVisitObserverRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.corVisitObserver,
              aliasName: $_aliasNameGenerator(
                  db.tBaseVisits.idBaseVisit, db.corVisitObserver.idBaseVisit));

  $$CorVisitObserverTableProcessedTableManager get corVisitObserverRefs {
    final manager =
        $$CorVisitObserverTableTableManager($_db, $_db.corVisitObserver)
            .filter((f) => f.idBaseVisit.idBaseVisit($_item.idBaseVisit));

    final cache =
        $_typedResult.readTableOrNull(_corVisitObserverRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TBaseVisitsTableFilterComposer
    extends Composer<_$AppDatabase, $TBaseVisitsTable> {
  $$TBaseVisitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idBaseVisit => $composableBuilder(
      column: $table.idBaseVisit, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idBaseSite => $composableBuilder(
      column: $table.idBaseSite, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idDataset => $composableBuilder(
      column: $table.idDataset, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idModule => $composableBuilder(
      column: $table.idModule, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idDigitiser => $composableBuilder(
      column: $table.idDigitiser, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get visitDateMin => $composableBuilder(
      column: $table.visitDateMin, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get visitDateMax => $composableBuilder(
      column: $table.visitDateMax, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idNomenclatureTechCollectCampanule =>
      $composableBuilder(
          column: $table.idNomenclatureTechCollectCampanule,
          builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idNomenclatureGrpTyp => $composableBuilder(
      column: $table.idNomenclatureGrpTyp,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get comments => $composableBuilder(
      column: $table.comments, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuidBaseVisit => $composableBuilder(
      column: $table.uuidBaseVisit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metaCreateDate => $composableBuilder(
      column: $table.metaCreateDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metaUpdateDate => $composableBuilder(
      column: $table.metaUpdateDate,
      builder: (column) => ColumnFilters(column));

  Expression<bool> corVisitObserverRefs(
      Expression<bool> Function($$CorVisitObserverTableFilterComposer f) f) {
    final $$CorVisitObserverTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.idBaseVisit,
        referencedTable: $db.corVisitObserver,
        getReferencedColumn: (t) => t.idBaseVisit,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CorVisitObserverTableFilterComposer(
              $db: $db,
              $table: $db.corVisitObserver,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TBaseVisitsTableOrderingComposer
    extends Composer<_$AppDatabase, $TBaseVisitsTable> {
  $$TBaseVisitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idBaseVisit => $composableBuilder(
      column: $table.idBaseVisit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idBaseSite => $composableBuilder(
      column: $table.idBaseSite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idDataset => $composableBuilder(
      column: $table.idDataset, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idModule => $composableBuilder(
      column: $table.idModule, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idDigitiser => $composableBuilder(
      column: $table.idDigitiser, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get visitDateMin => $composableBuilder(
      column: $table.visitDateMin,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get visitDateMax => $composableBuilder(
      column: $table.visitDateMax,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idNomenclatureTechCollectCampanule =>
      $composableBuilder(
          column: $table.idNomenclatureTechCollectCampanule,
          builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idNomenclatureGrpTyp => $composableBuilder(
      column: $table.idNomenclatureGrpTyp,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get comments => $composableBuilder(
      column: $table.comments, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuidBaseVisit => $composableBuilder(
      column: $table.uuidBaseVisit,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metaCreateDate => $composableBuilder(
      column: $table.metaCreateDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metaUpdateDate => $composableBuilder(
      column: $table.metaUpdateDate,
      builder: (column) => ColumnOrderings(column));
}

class $$TBaseVisitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TBaseVisitsTable> {
  $$TBaseVisitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idBaseVisit => $composableBuilder(
      column: $table.idBaseVisit, builder: (column) => column);

  GeneratedColumn<int> get idBaseSite => $composableBuilder(
      column: $table.idBaseSite, builder: (column) => column);

  GeneratedColumn<int> get idDataset =>
      $composableBuilder(column: $table.idDataset, builder: (column) => column);

  GeneratedColumn<int> get idModule =>
      $composableBuilder(column: $table.idModule, builder: (column) => column);

  GeneratedColumn<int> get idDigitiser => $composableBuilder(
      column: $table.idDigitiser, builder: (column) => column);

  GeneratedColumn<String> get visitDateMin => $composableBuilder(
      column: $table.visitDateMin, builder: (column) => column);

  GeneratedColumn<String> get visitDateMax => $composableBuilder(
      column: $table.visitDateMax, builder: (column) => column);

  GeneratedColumn<int> get idNomenclatureTechCollectCampanule =>
      $composableBuilder(
          column: $table.idNomenclatureTechCollectCampanule,
          builder: (column) => column);

  GeneratedColumn<int> get idNomenclatureGrpTyp => $composableBuilder(
      column: $table.idNomenclatureGrpTyp, builder: (column) => column);

  GeneratedColumn<String> get comments =>
      $composableBuilder(column: $table.comments, builder: (column) => column);

  GeneratedColumn<String> get uuidBaseVisit => $composableBuilder(
      column: $table.uuidBaseVisit, builder: (column) => column);

  GeneratedColumn<String> get metaCreateDate => $composableBuilder(
      column: $table.metaCreateDate, builder: (column) => column);

  GeneratedColumn<String> get metaUpdateDate => $composableBuilder(
      column: $table.metaUpdateDate, builder: (column) => column);

  Expression<T> corVisitObserverRefs<T extends Object>(
      Expression<T> Function($$CorVisitObserverTableAnnotationComposer a) f) {
    final $$CorVisitObserverTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.idBaseVisit,
        referencedTable: $db.corVisitObserver,
        getReferencedColumn: (t) => t.idBaseVisit,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CorVisitObserverTableAnnotationComposer(
              $db: $db,
              $table: $db.corVisitObserver,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TBaseVisitsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TBaseVisitsTable,
    TBaseVisit,
    $$TBaseVisitsTableFilterComposer,
    $$TBaseVisitsTableOrderingComposer,
    $$TBaseVisitsTableAnnotationComposer,
    $$TBaseVisitsTableCreateCompanionBuilder,
    $$TBaseVisitsTableUpdateCompanionBuilder,
    (TBaseVisit, $$TBaseVisitsTableReferences),
    TBaseVisit,
    PrefetchHooks Function({bool corVisitObserverRefs})> {
  $$TBaseVisitsTableTableManager(_$AppDatabase db, $TBaseVisitsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TBaseVisitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TBaseVisitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TBaseVisitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> idBaseVisit = const Value.absent(),
            Value<int?> idBaseSite = const Value.absent(),
            Value<int> idDataset = const Value.absent(),
            Value<int> idModule = const Value.absent(),
            Value<int?> idDigitiser = const Value.absent(),
            Value<String> visitDateMin = const Value.absent(),
            Value<String?> visitDateMax = const Value.absent(),
            Value<int?> idNomenclatureTechCollectCampanule =
                const Value.absent(),
            Value<int?> idNomenclatureGrpTyp = const Value.absent(),
            Value<String?> comments = const Value.absent(),
            Value<String?> uuidBaseVisit = const Value.absent(),
            Value<String> metaCreateDate = const Value.absent(),
            Value<String> metaUpdateDate = const Value.absent(),
          }) =>
              TBaseVisitsCompanion(
            idBaseVisit: idBaseVisit,
            idBaseSite: idBaseSite,
            idDataset: idDataset,
            idModule: idModule,
            idDigitiser: idDigitiser,
            visitDateMin: visitDateMin,
            visitDateMax: visitDateMax,
            idNomenclatureTechCollectCampanule:
                idNomenclatureTechCollectCampanule,
            idNomenclatureGrpTyp: idNomenclatureGrpTyp,
            comments: comments,
            uuidBaseVisit: uuidBaseVisit,
            metaCreateDate: metaCreateDate,
            metaUpdateDate: metaUpdateDate,
          ),
          createCompanionCallback: ({
            Value<int> idBaseVisit = const Value.absent(),
            Value<int?> idBaseSite = const Value.absent(),
            required int idDataset,
            required int idModule,
            Value<int?> idDigitiser = const Value.absent(),
            required String visitDateMin,
            Value<String?> visitDateMax = const Value.absent(),
            Value<int?> idNomenclatureTechCollectCampanule =
                const Value.absent(),
            Value<int?> idNomenclatureGrpTyp = const Value.absent(),
            Value<String?> comments = const Value.absent(),
            Value<String?> uuidBaseVisit = const Value.absent(),
            Value<String> metaCreateDate = const Value.absent(),
            Value<String> metaUpdateDate = const Value.absent(),
          }) =>
              TBaseVisitsCompanion.insert(
            idBaseVisit: idBaseVisit,
            idBaseSite: idBaseSite,
            idDataset: idDataset,
            idModule: idModule,
            idDigitiser: idDigitiser,
            visitDateMin: visitDateMin,
            visitDateMax: visitDateMax,
            idNomenclatureTechCollectCampanule:
                idNomenclatureTechCollectCampanule,
            idNomenclatureGrpTyp: idNomenclatureGrpTyp,
            comments: comments,
            uuidBaseVisit: uuidBaseVisit,
            metaCreateDate: metaCreateDate,
            metaUpdateDate: metaUpdateDate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TBaseVisitsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({corVisitObserverRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (corVisitObserverRefs) db.corVisitObserver
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (corVisitObserverRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$TBaseVisitsTableReferences
                            ._corVisitObserverRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TBaseVisitsTableReferences(db, table, p0)
                                .corVisitObserverRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems.where(
                                (e) => e.idBaseVisit == item.idBaseVisit),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TBaseVisitsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TBaseVisitsTable,
    TBaseVisit,
    $$TBaseVisitsTableFilterComposer,
    $$TBaseVisitsTableOrderingComposer,
    $$TBaseVisitsTableAnnotationComposer,
    $$TBaseVisitsTableCreateCompanionBuilder,
    $$TBaseVisitsTableUpdateCompanionBuilder,
    (TBaseVisit, $$TBaseVisitsTableReferences),
    TBaseVisit,
    PrefetchHooks Function({bool corVisitObserverRefs})>;
typedef $$CorVisitObserverTableCreateCompanionBuilder
    = CorVisitObserverCompanion Function({
  required int idBaseVisit,
  required int idRole,
  Value<String> uniqueIdCoreVisitObserver,
  Value<int> rowid,
});
typedef $$CorVisitObserverTableUpdateCompanionBuilder
    = CorVisitObserverCompanion Function({
  Value<int> idBaseVisit,
  Value<int> idRole,
  Value<String> uniqueIdCoreVisitObserver,
  Value<int> rowid,
});

final class $$CorVisitObserverTableReferences extends BaseReferences<
    _$AppDatabase, $CorVisitObserverTable, CorVisitObserverData> {
  $$CorVisitObserverTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $TBaseVisitsTable _idBaseVisitTable(_$AppDatabase db) =>
      db.tBaseVisits.createAlias($_aliasNameGenerator(
          db.corVisitObserver.idBaseVisit, db.tBaseVisits.idBaseVisit));

  $$TBaseVisitsTableProcessedTableManager get idBaseVisit {
    final manager = $$TBaseVisitsTableTableManager($_db, $_db.tBaseVisits)
        .filter((f) => f.idBaseVisit($_item.idBaseVisit));
    final item = $_typedResult.readTableOrNull(_idBaseVisitTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$CorVisitObserverTableFilterComposer
    extends Composer<_$AppDatabase, $CorVisitObserverTable> {
  $$CorVisitObserverTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idRole => $composableBuilder(
      column: $table.idRole, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uniqueIdCoreVisitObserver => $composableBuilder(
      column: $table.uniqueIdCoreVisitObserver,
      builder: (column) => ColumnFilters(column));

  $$TBaseVisitsTableFilterComposer get idBaseVisit {
    final $$TBaseVisitsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.idBaseVisit,
        referencedTable: $db.tBaseVisits,
        getReferencedColumn: (t) => t.idBaseVisit,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TBaseVisitsTableFilterComposer(
              $db: $db,
              $table: $db.tBaseVisits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CorVisitObserverTableOrderingComposer
    extends Composer<_$AppDatabase, $CorVisitObserverTable> {
  $$CorVisitObserverTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idRole => $composableBuilder(
      column: $table.idRole, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uniqueIdCoreVisitObserver => $composableBuilder(
      column: $table.uniqueIdCoreVisitObserver,
      builder: (column) => ColumnOrderings(column));

  $$TBaseVisitsTableOrderingComposer get idBaseVisit {
    final $$TBaseVisitsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.idBaseVisit,
        referencedTable: $db.tBaseVisits,
        getReferencedColumn: (t) => t.idBaseVisit,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TBaseVisitsTableOrderingComposer(
              $db: $db,
              $table: $db.tBaseVisits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CorVisitObserverTableAnnotationComposer
    extends Composer<_$AppDatabase, $CorVisitObserverTable> {
  $$CorVisitObserverTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idRole =>
      $composableBuilder(column: $table.idRole, builder: (column) => column);

  GeneratedColumn<String> get uniqueIdCoreVisitObserver => $composableBuilder(
      column: $table.uniqueIdCoreVisitObserver, builder: (column) => column);

  $$TBaseVisitsTableAnnotationComposer get idBaseVisit {
    final $$TBaseVisitsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.idBaseVisit,
        referencedTable: $db.tBaseVisits,
        getReferencedColumn: (t) => t.idBaseVisit,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TBaseVisitsTableAnnotationComposer(
              $db: $db,
              $table: $db.tBaseVisits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CorVisitObserverTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CorVisitObserverTable,
    CorVisitObserverData,
    $$CorVisitObserverTableFilterComposer,
    $$CorVisitObserverTableOrderingComposer,
    $$CorVisitObserverTableAnnotationComposer,
    $$CorVisitObserverTableCreateCompanionBuilder,
    $$CorVisitObserverTableUpdateCompanionBuilder,
    (CorVisitObserverData, $$CorVisitObserverTableReferences),
    CorVisitObserverData,
    PrefetchHooks Function({bool idBaseVisit})> {
  $$CorVisitObserverTableTableManager(
      _$AppDatabase db, $CorVisitObserverTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CorVisitObserverTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CorVisitObserverTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CorVisitObserverTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> idBaseVisit = const Value.absent(),
            Value<int> idRole = const Value.absent(),
            Value<String> uniqueIdCoreVisitObserver = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CorVisitObserverCompanion(
            idBaseVisit: idBaseVisit,
            idRole: idRole,
            uniqueIdCoreVisitObserver: uniqueIdCoreVisitObserver,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int idBaseVisit,
            required int idRole,
            Value<String> uniqueIdCoreVisitObserver = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CorVisitObserverCompanion.insert(
            idBaseVisit: idBaseVisit,
            idRole: idRole,
            uniqueIdCoreVisitObserver: uniqueIdCoreVisitObserver,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CorVisitObserverTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({idBaseVisit = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (idBaseVisit) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.idBaseVisit,
                    referencedTable:
                        $$CorVisitObserverTableReferences._idBaseVisitTable(db),
                    referencedColumn: $$CorVisitObserverTableReferences
                        ._idBaseVisitTable(db)
                        .idBaseVisit,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$CorVisitObserverTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CorVisitObserverTable,
    CorVisitObserverData,
    $$CorVisitObserverTableFilterComposer,
    $$CorVisitObserverTableOrderingComposer,
    $$CorVisitObserverTableAnnotationComposer,
    $$CorVisitObserverTableCreateCompanionBuilder,
    $$CorVisitObserverTableUpdateCompanionBuilder,
    (CorVisitObserverData, $$CorVisitObserverTableReferences),
    CorVisitObserverData,
    PrefetchHooks Function({bool idBaseVisit})>;
typedef $$CorSiteTypeTableTableCreateCompanionBuilder
    = CorSiteTypeTableCompanion Function({
  required int idBaseSite,
  required int idNomenclatureTypeSite,
  Value<int> rowid,
});
typedef $$CorSiteTypeTableTableUpdateCompanionBuilder
    = CorSiteTypeTableCompanion Function({
  Value<int> idBaseSite,
  Value<int> idNomenclatureTypeSite,
  Value<int> rowid,
});

class $$CorSiteTypeTableTableFilterComposer
    extends Composer<_$AppDatabase, $CorSiteTypeTableTable> {
  $$CorSiteTypeTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idBaseSite => $composableBuilder(
      column: $table.idBaseSite, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idNomenclatureTypeSite => $composableBuilder(
      column: $table.idNomenclatureTypeSite,
      builder: (column) => ColumnFilters(column));
}

class $$CorSiteTypeTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CorSiteTypeTableTable> {
  $$CorSiteTypeTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idBaseSite => $composableBuilder(
      column: $table.idBaseSite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idNomenclatureTypeSite => $composableBuilder(
      column: $table.idNomenclatureTypeSite,
      builder: (column) => ColumnOrderings(column));
}

class $$CorSiteTypeTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CorSiteTypeTableTable> {
  $$CorSiteTypeTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idBaseSite => $composableBuilder(
      column: $table.idBaseSite, builder: (column) => column);

  GeneratedColumn<int> get idNomenclatureTypeSite => $composableBuilder(
      column: $table.idNomenclatureTypeSite, builder: (column) => column);
}

class $$CorSiteTypeTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CorSiteTypeTableTable,
    CorSiteType,
    $$CorSiteTypeTableTableFilterComposer,
    $$CorSiteTypeTableTableOrderingComposer,
    $$CorSiteTypeTableTableAnnotationComposer,
    $$CorSiteTypeTableTableCreateCompanionBuilder,
    $$CorSiteTypeTableTableUpdateCompanionBuilder,
    (
      CorSiteType,
      BaseReferences<_$AppDatabase, $CorSiteTypeTableTable, CorSiteType>
    ),
    CorSiteType,
    PrefetchHooks Function()> {
  $$CorSiteTypeTableTableTableManager(
      _$AppDatabase db, $CorSiteTypeTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CorSiteTypeTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CorSiteTypeTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CorSiteTypeTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> idBaseSite = const Value.absent(),
            Value<int> idNomenclatureTypeSite = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CorSiteTypeTableCompanion(
            idBaseSite: idBaseSite,
            idNomenclatureTypeSite: idNomenclatureTypeSite,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int idBaseSite,
            required int idNomenclatureTypeSite,
            Value<int> rowid = const Value.absent(),
          }) =>
              CorSiteTypeTableCompanion.insert(
            idBaseSite: idBaseSite,
            idNomenclatureTypeSite: idNomenclatureTypeSite,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CorSiteTypeTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CorSiteTypeTableTable,
    CorSiteType,
    $$CorSiteTypeTableTableFilterComposer,
    $$CorSiteTypeTableTableOrderingComposer,
    $$CorSiteTypeTableTableAnnotationComposer,
    $$CorSiteTypeTableTableCreateCompanionBuilder,
    $$CorSiteTypeTableTableUpdateCompanionBuilder,
    (
      CorSiteType,
      BaseReferences<_$AppDatabase, $CorSiteTypeTableTable, CorSiteType>
    ),
    CorSiteType,
    PrefetchHooks Function()>;
typedef $$CorModuleDatasetTableTableCreateCompanionBuilder
    = CorModuleDatasetTableCompanion Function({
  required int idModule,
  required int idDataset,
  Value<int> rowid,
});
typedef $$CorModuleDatasetTableTableUpdateCompanionBuilder
    = CorModuleDatasetTableCompanion Function({
  Value<int> idModule,
  Value<int> idDataset,
  Value<int> rowid,
});

class $$CorModuleDatasetTableTableFilterComposer
    extends Composer<_$AppDatabase, $CorModuleDatasetTableTable> {
  $$CorModuleDatasetTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idModule => $composableBuilder(
      column: $table.idModule, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idDataset => $composableBuilder(
      column: $table.idDataset, builder: (column) => ColumnFilters(column));
}

class $$CorModuleDatasetTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CorModuleDatasetTableTable> {
  $$CorModuleDatasetTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idModule => $composableBuilder(
      column: $table.idModule, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idDataset => $composableBuilder(
      column: $table.idDataset, builder: (column) => ColumnOrderings(column));
}

class $$CorModuleDatasetTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CorModuleDatasetTableTable> {
  $$CorModuleDatasetTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idModule =>
      $composableBuilder(column: $table.idModule, builder: (column) => column);

  GeneratedColumn<int> get idDataset =>
      $composableBuilder(column: $table.idDataset, builder: (column) => column);
}

class $$CorModuleDatasetTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CorModuleDatasetTableTable,
    CorModuleDataset,
    $$CorModuleDatasetTableTableFilterComposer,
    $$CorModuleDatasetTableTableOrderingComposer,
    $$CorModuleDatasetTableTableAnnotationComposer,
    $$CorModuleDatasetTableTableCreateCompanionBuilder,
    $$CorModuleDatasetTableTableUpdateCompanionBuilder,
    (
      CorModuleDataset,
      BaseReferences<_$AppDatabase, $CorModuleDatasetTableTable,
          CorModuleDataset>
    ),
    CorModuleDataset,
    PrefetchHooks Function()> {
  $$CorModuleDatasetTableTableTableManager(
      _$AppDatabase db, $CorModuleDatasetTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CorModuleDatasetTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$CorModuleDatasetTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CorModuleDatasetTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> idModule = const Value.absent(),
            Value<int> idDataset = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CorModuleDatasetTableCompanion(
            idModule: idModule,
            idDataset: idDataset,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int idModule,
            required int idDataset,
            Value<int> rowid = const Value.absent(),
          }) =>
              CorModuleDatasetTableCompanion.insert(
            idModule: idModule,
            idDataset: idDataset,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CorModuleDatasetTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $CorModuleDatasetTableTable,
        CorModuleDataset,
        $$CorModuleDatasetTableTableFilterComposer,
        $$CorModuleDatasetTableTableOrderingComposer,
        $$CorModuleDatasetTableTableAnnotationComposer,
        $$CorModuleDatasetTableTableCreateCompanionBuilder,
        $$CorModuleDatasetTableTableUpdateCompanionBuilder,
        (
          CorModuleDataset,
          BaseReferences<_$AppDatabase, $CorModuleDatasetTableTable,
              CorModuleDataset>
        ),
        CorModuleDataset,
        PrefetchHooks Function()>;
typedef $$TTaxrefsTableCreateCompanionBuilder = TTaxrefsCompanion Function({
  Value<int> cdNom,
  Value<int?> cdRef,
  Value<String?> idStatut,
  Value<int?> idHabitat,
  Value<String?> idRang,
  Value<String?> regne,
  Value<String?> phylum,
  Value<String?> classe,
  Value<String?> ordre,
  Value<String?> famille,
  Value<String?> sousFamille,
  Value<String?> tribu,
  Value<int?> cdTaxsup,
  Value<int?> cdSup,
  Value<String?> lbNom,
  Value<String?> lbAuteur,
  required String nomComplet,
  Value<String?> nomCompletHtml,
  Value<String?> nomVern,
  Value<String?> nomValide,
  Value<String?> nomVernEng,
  Value<String?> group1Inpn,
  Value<String?> group2Inpn,
  Value<String?> group3Inpn,
  Value<String?> url,
});
typedef $$TTaxrefsTableUpdateCompanionBuilder = TTaxrefsCompanion Function({
  Value<int> cdNom,
  Value<int?> cdRef,
  Value<String?> idStatut,
  Value<int?> idHabitat,
  Value<String?> idRang,
  Value<String?> regne,
  Value<String?> phylum,
  Value<String?> classe,
  Value<String?> ordre,
  Value<String?> famille,
  Value<String?> sousFamille,
  Value<String?> tribu,
  Value<int?> cdTaxsup,
  Value<int?> cdSup,
  Value<String?> lbNom,
  Value<String?> lbAuteur,
  Value<String> nomComplet,
  Value<String?> nomCompletHtml,
  Value<String?> nomVern,
  Value<String?> nomValide,
  Value<String?> nomVernEng,
  Value<String?> group1Inpn,
  Value<String?> group2Inpn,
  Value<String?> group3Inpn,
  Value<String?> url,
});

final class $$TTaxrefsTableReferences
    extends BaseReferences<_$AppDatabase, $TTaxrefsTable, TTaxref> {
  $$TTaxrefsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CorTaxonListeTableTable, List<CorTaxonListe>>
      _corTaxonListeTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.corTaxonListeTable,
              aliasName: $_aliasNameGenerator(
                  db.tTaxrefs.cdNom, db.corTaxonListeTable.cdNom));

  $$CorTaxonListeTableTableProcessedTableManager get corTaxonListeTableRefs {
    final manager =
        $$CorTaxonListeTableTableTableManager($_db, $_db.corTaxonListeTable)
            .filter((f) => f.cdNom.cdNom($_item.cdNom));

    final cache =
        $_typedResult.readTableOrNull(_corTaxonListeTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TTaxrefsTableFilterComposer
    extends Composer<_$AppDatabase, $TTaxrefsTable> {
  $$TTaxrefsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get cdNom => $composableBuilder(
      column: $table.cdNom, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cdRef => $composableBuilder(
      column: $table.cdRef, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get idStatut => $composableBuilder(
      column: $table.idStatut, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get idHabitat => $composableBuilder(
      column: $table.idHabitat, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get idRang => $composableBuilder(
      column: $table.idRang, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get regne => $composableBuilder(
      column: $table.regne, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phylum => $composableBuilder(
      column: $table.phylum, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get classe => $composableBuilder(
      column: $table.classe, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ordre => $composableBuilder(
      column: $table.ordre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get famille => $composableBuilder(
      column: $table.famille, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sousFamille => $composableBuilder(
      column: $table.sousFamille, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tribu => $composableBuilder(
      column: $table.tribu, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cdTaxsup => $composableBuilder(
      column: $table.cdTaxsup, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cdSup => $composableBuilder(
      column: $table.cdSup, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lbNom => $composableBuilder(
      column: $table.lbNom, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lbAuteur => $composableBuilder(
      column: $table.lbAuteur, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nomComplet => $composableBuilder(
      column: $table.nomComplet, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nomCompletHtml => $composableBuilder(
      column: $table.nomCompletHtml,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nomVern => $composableBuilder(
      column: $table.nomVern, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nomValide => $composableBuilder(
      column: $table.nomValide, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nomVernEng => $composableBuilder(
      column: $table.nomVernEng, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get group1Inpn => $composableBuilder(
      column: $table.group1Inpn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get group2Inpn => $composableBuilder(
      column: $table.group2Inpn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get group3Inpn => $composableBuilder(
      column: $table.group3Inpn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnFilters(column));

  Expression<bool> corTaxonListeTableRefs(
      Expression<bool> Function($$CorTaxonListeTableTableFilterComposer f) f) {
    final $$CorTaxonListeTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cdNom,
        referencedTable: $db.corTaxonListeTable,
        getReferencedColumn: (t) => t.cdNom,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CorTaxonListeTableTableFilterComposer(
              $db: $db,
              $table: $db.corTaxonListeTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TTaxrefsTableOrderingComposer
    extends Composer<_$AppDatabase, $TTaxrefsTable> {
  $$TTaxrefsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get cdNom => $composableBuilder(
      column: $table.cdNom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cdRef => $composableBuilder(
      column: $table.cdRef, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get idStatut => $composableBuilder(
      column: $table.idStatut, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get idHabitat => $composableBuilder(
      column: $table.idHabitat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get idRang => $composableBuilder(
      column: $table.idRang, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get regne => $composableBuilder(
      column: $table.regne, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phylum => $composableBuilder(
      column: $table.phylum, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get classe => $composableBuilder(
      column: $table.classe, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ordre => $composableBuilder(
      column: $table.ordre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get famille => $composableBuilder(
      column: $table.famille, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sousFamille => $composableBuilder(
      column: $table.sousFamille, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tribu => $composableBuilder(
      column: $table.tribu, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cdTaxsup => $composableBuilder(
      column: $table.cdTaxsup, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cdSup => $composableBuilder(
      column: $table.cdSup, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lbNom => $composableBuilder(
      column: $table.lbNom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lbAuteur => $composableBuilder(
      column: $table.lbAuteur, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nomComplet => $composableBuilder(
      column: $table.nomComplet, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nomCompletHtml => $composableBuilder(
      column: $table.nomCompletHtml,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nomVern => $composableBuilder(
      column: $table.nomVern, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nomValide => $composableBuilder(
      column: $table.nomValide, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nomVernEng => $composableBuilder(
      column: $table.nomVernEng, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get group1Inpn => $composableBuilder(
      column: $table.group1Inpn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get group2Inpn => $composableBuilder(
      column: $table.group2Inpn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get group3Inpn => $composableBuilder(
      column: $table.group3Inpn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnOrderings(column));
}

class $$TTaxrefsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TTaxrefsTable> {
  $$TTaxrefsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get cdNom =>
      $composableBuilder(column: $table.cdNom, builder: (column) => column);

  GeneratedColumn<int> get cdRef =>
      $composableBuilder(column: $table.cdRef, builder: (column) => column);

  GeneratedColumn<String> get idStatut =>
      $composableBuilder(column: $table.idStatut, builder: (column) => column);

  GeneratedColumn<int> get idHabitat =>
      $composableBuilder(column: $table.idHabitat, builder: (column) => column);

  GeneratedColumn<String> get idRang =>
      $composableBuilder(column: $table.idRang, builder: (column) => column);

  GeneratedColumn<String> get regne =>
      $composableBuilder(column: $table.regne, builder: (column) => column);

  GeneratedColumn<String> get phylum =>
      $composableBuilder(column: $table.phylum, builder: (column) => column);

  GeneratedColumn<String> get classe =>
      $composableBuilder(column: $table.classe, builder: (column) => column);

  GeneratedColumn<String> get ordre =>
      $composableBuilder(column: $table.ordre, builder: (column) => column);

  GeneratedColumn<String> get famille =>
      $composableBuilder(column: $table.famille, builder: (column) => column);

  GeneratedColumn<String> get sousFamille => $composableBuilder(
      column: $table.sousFamille, builder: (column) => column);

  GeneratedColumn<String> get tribu =>
      $composableBuilder(column: $table.tribu, builder: (column) => column);

  GeneratedColumn<int> get cdTaxsup =>
      $composableBuilder(column: $table.cdTaxsup, builder: (column) => column);

  GeneratedColumn<int> get cdSup =>
      $composableBuilder(column: $table.cdSup, builder: (column) => column);

  GeneratedColumn<String> get lbNom =>
      $composableBuilder(column: $table.lbNom, builder: (column) => column);

  GeneratedColumn<String> get lbAuteur =>
      $composableBuilder(column: $table.lbAuteur, builder: (column) => column);

  GeneratedColumn<String> get nomComplet => $composableBuilder(
      column: $table.nomComplet, builder: (column) => column);

  GeneratedColumn<String> get nomCompletHtml => $composableBuilder(
      column: $table.nomCompletHtml, builder: (column) => column);

  GeneratedColumn<String> get nomVern =>
      $composableBuilder(column: $table.nomVern, builder: (column) => column);

  GeneratedColumn<String> get nomValide =>
      $composableBuilder(column: $table.nomValide, builder: (column) => column);

  GeneratedColumn<String> get nomVernEng => $composableBuilder(
      column: $table.nomVernEng, builder: (column) => column);

  GeneratedColumn<String> get group1Inpn => $composableBuilder(
      column: $table.group1Inpn, builder: (column) => column);

  GeneratedColumn<String> get group2Inpn => $composableBuilder(
      column: $table.group2Inpn, builder: (column) => column);

  GeneratedColumn<String> get group3Inpn => $composableBuilder(
      column: $table.group3Inpn, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  Expression<T> corTaxonListeTableRefs<T extends Object>(
      Expression<T> Function($$CorTaxonListeTableTableAnnotationComposer a) f) {
    final $$CorTaxonListeTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.cdNom,
            referencedTable: $db.corTaxonListeTable,
            getReferencedColumn: (t) => t.cdNom,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CorTaxonListeTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.corTaxonListeTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$TTaxrefsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TTaxrefsTable,
    TTaxref,
    $$TTaxrefsTableFilterComposer,
    $$TTaxrefsTableOrderingComposer,
    $$TTaxrefsTableAnnotationComposer,
    $$TTaxrefsTableCreateCompanionBuilder,
    $$TTaxrefsTableUpdateCompanionBuilder,
    (TTaxref, $$TTaxrefsTableReferences),
    TTaxref,
    PrefetchHooks Function({bool corTaxonListeTableRefs})> {
  $$TTaxrefsTableTableManager(_$AppDatabase db, $TTaxrefsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TTaxrefsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TTaxrefsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TTaxrefsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> cdNom = const Value.absent(),
            Value<int?> cdRef = const Value.absent(),
            Value<String?> idStatut = const Value.absent(),
            Value<int?> idHabitat = const Value.absent(),
            Value<String?> idRang = const Value.absent(),
            Value<String?> regne = const Value.absent(),
            Value<String?> phylum = const Value.absent(),
            Value<String?> classe = const Value.absent(),
            Value<String?> ordre = const Value.absent(),
            Value<String?> famille = const Value.absent(),
            Value<String?> sousFamille = const Value.absent(),
            Value<String?> tribu = const Value.absent(),
            Value<int?> cdTaxsup = const Value.absent(),
            Value<int?> cdSup = const Value.absent(),
            Value<String?> lbNom = const Value.absent(),
            Value<String?> lbAuteur = const Value.absent(),
            Value<String> nomComplet = const Value.absent(),
            Value<String?> nomCompletHtml = const Value.absent(),
            Value<String?> nomVern = const Value.absent(),
            Value<String?> nomValide = const Value.absent(),
            Value<String?> nomVernEng = const Value.absent(),
            Value<String?> group1Inpn = const Value.absent(),
            Value<String?> group2Inpn = const Value.absent(),
            Value<String?> group3Inpn = const Value.absent(),
            Value<String?> url = const Value.absent(),
          }) =>
              TTaxrefsCompanion(
            cdNom: cdNom,
            cdRef: cdRef,
            idStatut: idStatut,
            idHabitat: idHabitat,
            idRang: idRang,
            regne: regne,
            phylum: phylum,
            classe: classe,
            ordre: ordre,
            famille: famille,
            sousFamille: sousFamille,
            tribu: tribu,
            cdTaxsup: cdTaxsup,
            cdSup: cdSup,
            lbNom: lbNom,
            lbAuteur: lbAuteur,
            nomComplet: nomComplet,
            nomCompletHtml: nomCompletHtml,
            nomVern: nomVern,
            nomValide: nomValide,
            nomVernEng: nomVernEng,
            group1Inpn: group1Inpn,
            group2Inpn: group2Inpn,
            group3Inpn: group3Inpn,
            url: url,
          ),
          createCompanionCallback: ({
            Value<int> cdNom = const Value.absent(),
            Value<int?> cdRef = const Value.absent(),
            Value<String?> idStatut = const Value.absent(),
            Value<int?> idHabitat = const Value.absent(),
            Value<String?> idRang = const Value.absent(),
            Value<String?> regne = const Value.absent(),
            Value<String?> phylum = const Value.absent(),
            Value<String?> classe = const Value.absent(),
            Value<String?> ordre = const Value.absent(),
            Value<String?> famille = const Value.absent(),
            Value<String?> sousFamille = const Value.absent(),
            Value<String?> tribu = const Value.absent(),
            Value<int?> cdTaxsup = const Value.absent(),
            Value<int?> cdSup = const Value.absent(),
            Value<String?> lbNom = const Value.absent(),
            Value<String?> lbAuteur = const Value.absent(),
            required String nomComplet,
            Value<String?> nomCompletHtml = const Value.absent(),
            Value<String?> nomVern = const Value.absent(),
            Value<String?> nomValide = const Value.absent(),
            Value<String?> nomVernEng = const Value.absent(),
            Value<String?> group1Inpn = const Value.absent(),
            Value<String?> group2Inpn = const Value.absent(),
            Value<String?> group3Inpn = const Value.absent(),
            Value<String?> url = const Value.absent(),
          }) =>
              TTaxrefsCompanion.insert(
            cdNom: cdNom,
            cdRef: cdRef,
            idStatut: idStatut,
            idHabitat: idHabitat,
            idRang: idRang,
            regne: regne,
            phylum: phylum,
            classe: classe,
            ordre: ordre,
            famille: famille,
            sousFamille: sousFamille,
            tribu: tribu,
            cdTaxsup: cdTaxsup,
            cdSup: cdSup,
            lbNom: lbNom,
            lbAuteur: lbAuteur,
            nomComplet: nomComplet,
            nomCompletHtml: nomCompletHtml,
            nomVern: nomVern,
            nomValide: nomValide,
            nomVernEng: nomVernEng,
            group1Inpn: group1Inpn,
            group2Inpn: group2Inpn,
            group3Inpn: group3Inpn,
            url: url,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$TTaxrefsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({corTaxonListeTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (corTaxonListeTableRefs) db.corTaxonListeTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (corTaxonListeTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$TTaxrefsTableReferences
                            ._corTaxonListeTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TTaxrefsTableReferences(db, table, p0)
                                .corTaxonListeTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.cdNom == item.cdNom),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TTaxrefsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TTaxrefsTable,
    TTaxref,
    $$TTaxrefsTableFilterComposer,
    $$TTaxrefsTableOrderingComposer,
    $$TTaxrefsTableAnnotationComposer,
    $$TTaxrefsTableCreateCompanionBuilder,
    $$TTaxrefsTableUpdateCompanionBuilder,
    (TTaxref, $$TTaxrefsTableReferences),
    TTaxref,
    PrefetchHooks Function({bool corTaxonListeTableRefs})>;
typedef $$BibListesTableTableCreateCompanionBuilder = BibListesTableCompanion
    Function({
  Value<int> idListe,
  Value<String?> codeListe,
  required String nomListe,
  Value<String?> descListe,
  Value<String?> regne,
  Value<String?> group2Inpn,
});
typedef $$BibListesTableTableUpdateCompanionBuilder = BibListesTableCompanion
    Function({
  Value<int> idListe,
  Value<String?> codeListe,
  Value<String> nomListe,
  Value<String?> descListe,
  Value<String?> regne,
  Value<String?> group2Inpn,
});

final class $$BibListesTableTableReferences
    extends BaseReferences<_$AppDatabase, $BibListesTableTable, TBibListe> {
  $$BibListesTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CorTaxonListeTableTable, List<CorTaxonListe>>
      _corTaxonListeTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.corTaxonListeTable,
              aliasName: $_aliasNameGenerator(
                  db.bibListesTable.idListe, db.corTaxonListeTable.idListe));

  $$CorTaxonListeTableTableProcessedTableManager get corTaxonListeTableRefs {
    final manager =
        $$CorTaxonListeTableTableTableManager($_db, $_db.corTaxonListeTable)
            .filter((f) => f.idListe.idListe($_item.idListe));

    final cache =
        $_typedResult.readTableOrNull(_corTaxonListeTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$BibListesTableTableFilterComposer
    extends Composer<_$AppDatabase, $BibListesTableTable> {
  $$BibListesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get idListe => $composableBuilder(
      column: $table.idListe, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get codeListe => $composableBuilder(
      column: $table.codeListe, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nomListe => $composableBuilder(
      column: $table.nomListe, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descListe => $composableBuilder(
      column: $table.descListe, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get regne => $composableBuilder(
      column: $table.regne, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get group2Inpn => $composableBuilder(
      column: $table.group2Inpn, builder: (column) => ColumnFilters(column));

  Expression<bool> corTaxonListeTableRefs(
      Expression<bool> Function($$CorTaxonListeTableTableFilterComposer f) f) {
    final $$CorTaxonListeTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.idListe,
        referencedTable: $db.corTaxonListeTable,
        getReferencedColumn: (t) => t.idListe,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CorTaxonListeTableTableFilterComposer(
              $db: $db,
              $table: $db.corTaxonListeTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BibListesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BibListesTableTable> {
  $$BibListesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get idListe => $composableBuilder(
      column: $table.idListe, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get codeListe => $composableBuilder(
      column: $table.codeListe, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nomListe => $composableBuilder(
      column: $table.nomListe, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descListe => $composableBuilder(
      column: $table.descListe, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get regne => $composableBuilder(
      column: $table.regne, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get group2Inpn => $composableBuilder(
      column: $table.group2Inpn, builder: (column) => ColumnOrderings(column));
}

class $$BibListesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BibListesTableTable> {
  $$BibListesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get idListe =>
      $composableBuilder(column: $table.idListe, builder: (column) => column);

  GeneratedColumn<String> get codeListe =>
      $composableBuilder(column: $table.codeListe, builder: (column) => column);

  GeneratedColumn<String> get nomListe =>
      $composableBuilder(column: $table.nomListe, builder: (column) => column);

  GeneratedColumn<String> get descListe =>
      $composableBuilder(column: $table.descListe, builder: (column) => column);

  GeneratedColumn<String> get regne =>
      $composableBuilder(column: $table.regne, builder: (column) => column);

  GeneratedColumn<String> get group2Inpn => $composableBuilder(
      column: $table.group2Inpn, builder: (column) => column);

  Expression<T> corTaxonListeTableRefs<T extends Object>(
      Expression<T> Function($$CorTaxonListeTableTableAnnotationComposer a) f) {
    final $$CorTaxonListeTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.idListe,
            referencedTable: $db.corTaxonListeTable,
            getReferencedColumn: (t) => t.idListe,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CorTaxonListeTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.corTaxonListeTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$BibListesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BibListesTableTable,
    TBibListe,
    $$BibListesTableTableFilterComposer,
    $$BibListesTableTableOrderingComposer,
    $$BibListesTableTableAnnotationComposer,
    $$BibListesTableTableCreateCompanionBuilder,
    $$BibListesTableTableUpdateCompanionBuilder,
    (TBibListe, $$BibListesTableTableReferences),
    TBibListe,
    PrefetchHooks Function({bool corTaxonListeTableRefs})> {
  $$BibListesTableTableTableManager(
      _$AppDatabase db, $BibListesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BibListesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BibListesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BibListesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> idListe = const Value.absent(),
            Value<String?> codeListe = const Value.absent(),
            Value<String> nomListe = const Value.absent(),
            Value<String?> descListe = const Value.absent(),
            Value<String?> regne = const Value.absent(),
            Value<String?> group2Inpn = const Value.absent(),
          }) =>
              BibListesTableCompanion(
            idListe: idListe,
            codeListe: codeListe,
            nomListe: nomListe,
            descListe: descListe,
            regne: regne,
            group2Inpn: group2Inpn,
          ),
          createCompanionCallback: ({
            Value<int> idListe = const Value.absent(),
            Value<String?> codeListe = const Value.absent(),
            required String nomListe,
            Value<String?> descListe = const Value.absent(),
            Value<String?> regne = const Value.absent(),
            Value<String?> group2Inpn = const Value.absent(),
          }) =>
              BibListesTableCompanion.insert(
            idListe: idListe,
            codeListe: codeListe,
            nomListe: nomListe,
            descListe: descListe,
            regne: regne,
            group2Inpn: group2Inpn,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$BibListesTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({corTaxonListeTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (corTaxonListeTableRefs) db.corTaxonListeTable
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (corTaxonListeTableRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$BibListesTableTableReferences
                            ._corTaxonListeTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$BibListesTableTableReferences(db, table, p0)
                                .corTaxonListeTableRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.idListe == item.idListe),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$BibListesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BibListesTableTable,
    TBibListe,
    $$BibListesTableTableFilterComposer,
    $$BibListesTableTableOrderingComposer,
    $$BibListesTableTableAnnotationComposer,
    $$BibListesTableTableCreateCompanionBuilder,
    $$BibListesTableTableUpdateCompanionBuilder,
    (TBibListe, $$BibListesTableTableReferences),
    TBibListe,
    PrefetchHooks Function({bool corTaxonListeTableRefs})>;
typedef $$CorTaxonListeTableTableCreateCompanionBuilder
    = CorTaxonListeTableCompanion Function({
  required int idListe,
  required int cdNom,
  Value<int> rowid,
});
typedef $$CorTaxonListeTableTableUpdateCompanionBuilder
    = CorTaxonListeTableCompanion Function({
  Value<int> idListe,
  Value<int> cdNom,
  Value<int> rowid,
});

final class $$CorTaxonListeTableTableReferences extends BaseReferences<
    _$AppDatabase, $CorTaxonListeTableTable, CorTaxonListe> {
  $$CorTaxonListeTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $BibListesTableTable _idListeTable(_$AppDatabase db) =>
      db.bibListesTable.createAlias($_aliasNameGenerator(
          db.corTaxonListeTable.idListe, db.bibListesTable.idListe));

  $$BibListesTableTableProcessedTableManager get idListe {
    final manager = $$BibListesTableTableTableManager($_db, $_db.bibListesTable)
        .filter((f) => f.idListe($_item.idListe));
    final item = $_typedResult.readTableOrNull(_idListeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $TTaxrefsTable _cdNomTable(_$AppDatabase db) =>
      db.tTaxrefs.createAlias(
          $_aliasNameGenerator(db.corTaxonListeTable.cdNom, db.tTaxrefs.cdNom));

  $$TTaxrefsTableProcessedTableManager get cdNom {
    final manager = $$TTaxrefsTableTableManager($_db, $_db.tTaxrefs)
        .filter((f) => f.cdNom($_item.cdNom));
    final item = $_typedResult.readTableOrNull(_cdNomTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$CorTaxonListeTableTableFilterComposer
    extends Composer<_$AppDatabase, $CorTaxonListeTableTable> {
  $$CorTaxonListeTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$BibListesTableTableFilterComposer get idListe {
    final $$BibListesTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.idListe,
        referencedTable: $db.bibListesTable,
        getReferencedColumn: (t) => t.idListe,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BibListesTableTableFilterComposer(
              $db: $db,
              $table: $db.bibListesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TTaxrefsTableFilterComposer get cdNom {
    final $$TTaxrefsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cdNom,
        referencedTable: $db.tTaxrefs,
        getReferencedColumn: (t) => t.cdNom,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TTaxrefsTableFilterComposer(
              $db: $db,
              $table: $db.tTaxrefs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CorTaxonListeTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CorTaxonListeTableTable> {
  $$CorTaxonListeTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$BibListesTableTableOrderingComposer get idListe {
    final $$BibListesTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.idListe,
        referencedTable: $db.bibListesTable,
        getReferencedColumn: (t) => t.idListe,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BibListesTableTableOrderingComposer(
              $db: $db,
              $table: $db.bibListesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TTaxrefsTableOrderingComposer get cdNom {
    final $$TTaxrefsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cdNom,
        referencedTable: $db.tTaxrefs,
        getReferencedColumn: (t) => t.cdNom,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TTaxrefsTableOrderingComposer(
              $db: $db,
              $table: $db.tTaxrefs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CorTaxonListeTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CorTaxonListeTableTable> {
  $$CorTaxonListeTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$BibListesTableTableAnnotationComposer get idListe {
    final $$BibListesTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.idListe,
        referencedTable: $db.bibListesTable,
        getReferencedColumn: (t) => t.idListe,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BibListesTableTableAnnotationComposer(
              $db: $db,
              $table: $db.bibListesTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TTaxrefsTableAnnotationComposer get cdNom {
    final $$TTaxrefsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cdNom,
        referencedTable: $db.tTaxrefs,
        getReferencedColumn: (t) => t.cdNom,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TTaxrefsTableAnnotationComposer(
              $db: $db,
              $table: $db.tTaxrefs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CorTaxonListeTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CorTaxonListeTableTable,
    CorTaxonListe,
    $$CorTaxonListeTableTableFilterComposer,
    $$CorTaxonListeTableTableOrderingComposer,
    $$CorTaxonListeTableTableAnnotationComposer,
    $$CorTaxonListeTableTableCreateCompanionBuilder,
    $$CorTaxonListeTableTableUpdateCompanionBuilder,
    (CorTaxonListe, $$CorTaxonListeTableTableReferences),
    CorTaxonListe,
    PrefetchHooks Function({bool idListe, bool cdNom})> {
  $$CorTaxonListeTableTableTableManager(
      _$AppDatabase db, $CorTaxonListeTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CorTaxonListeTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CorTaxonListeTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CorTaxonListeTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> idListe = const Value.absent(),
            Value<int> cdNom = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CorTaxonListeTableCompanion(
            idListe: idListe,
            cdNom: cdNom,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int idListe,
            required int cdNom,
            Value<int> rowid = const Value.absent(),
          }) =>
              CorTaxonListeTableCompanion.insert(
            idListe: idListe,
            cdNom: cdNom,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CorTaxonListeTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({idListe = false, cdNom = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (idListe) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.idListe,
                    referencedTable:
                        $$CorTaxonListeTableTableReferences._idListeTable(db),
                    referencedColumn: $$CorTaxonListeTableTableReferences
                        ._idListeTable(db)
                        .idListe,
                  ) as T;
                }
                if (cdNom) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.cdNom,
                    referencedTable:
                        $$CorTaxonListeTableTableReferences._cdNomTable(db),
                    referencedColumn: $$CorTaxonListeTableTableReferences
                        ._cdNomTable(db)
                        .cdNom,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$CorTaxonListeTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CorTaxonListeTableTable,
    CorTaxonListe,
    $$CorTaxonListeTableTableFilterComposer,
    $$CorTaxonListeTableTableOrderingComposer,
    $$CorTaxonListeTableTableAnnotationComposer,
    $$CorTaxonListeTableTableCreateCompanionBuilder,
    $$CorTaxonListeTableTableUpdateCompanionBuilder,
    (CorTaxonListe, $$CorTaxonListeTableTableReferences),
    CorTaxonListe,
    PrefetchHooks Function({bool idListe, bool cdNom})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TModulesTableTableManager get tModules =>
      $$TModulesTableTableManager(_db, _db.tModules);
  $$TBaseSitesTableTableManager get tBaseSites =>
      $$TBaseSitesTableTableManager(_db, _db.tBaseSites);
  $$TNomenclaturesTableTableManager get tNomenclatures =>
      $$TNomenclaturesTableTableManager(_db, _db.tNomenclatures);
  $$TDatasetsTableTableManager get tDatasets =>
      $$TDatasetsTableTableManager(_db, _db.tDatasets);
  $$TModuleComplementsTableTableManager get tModuleComplements =>
      $$TModuleComplementsTableTableManager(_db, _db.tModuleComplements);
  $$TSitesGroupsTableTableManager get tSitesGroups =>
      $$TSitesGroupsTableTableManager(_db, _db.tSitesGroups);
  $$TSiteComplementsTableTableManager get tSiteComplements =>
      $$TSiteComplementsTableTableManager(_db, _db.tSiteComplements);
  $$TVisitComplementsTableTableManager get tVisitComplements =>
      $$TVisitComplementsTableTableManager(_db, _db.tVisitComplements);
  $$TObservationsTableTableManager get tObservations =>
      $$TObservationsTableTableManager(_db, _db.tObservations);
  $$TObservationComplementsTableTableManager get tObservationComplements =>
      $$TObservationComplementsTableTableManager(
          _db, _db.tObservationComplements);
  $$TObservationDetailsTableTableManager get tObservationDetails =>
      $$TObservationDetailsTableTableManager(_db, _db.tObservationDetails);
  $$BibTablesLocationsTableTableManager get bibTablesLocations =>
      $$BibTablesLocationsTableTableManager(_db, _db.bibTablesLocations);
  $$BibNomenclaturesTypesTableTableTableManager
      get bibNomenclaturesTypesTable =>
          $$BibNomenclaturesTypesTableTableTableManager(
              _db, _db.bibNomenclaturesTypesTable);
  $$BibTypeSitesTableTableTableManager get bibTypeSitesTable =>
      $$BibTypeSitesTableTableTableManager(_db, _db.bibTypeSitesTable);
  $$TObjectsTableTableManager get tObjects =>
      $$TObjectsTableTableManager(_db, _db.tObjects);
  $$TActionsTableTableManager get tActions =>
      $$TActionsTableTableManager(_db, _db.tActions);
  $$TPermissionsAvailableTableTableManager get tPermissionsAvailable =>
      $$TPermissionsAvailableTableTableManager(_db, _db.tPermissionsAvailable);
  $$TPermissionsTableTableManager get tPermissions =>
      $$TPermissionsTableTableManager(_db, _db.tPermissions);
  $$CorSiteModuleTableTableTableManager get corSiteModuleTable =>
      $$CorSiteModuleTableTableTableManager(_db, _db.corSiteModuleTable);
  $$CorSitesGroupModuleTableTableTableManager get corSitesGroupModuleTable =>
      $$CorSitesGroupModuleTableTableTableManager(
          _db, _db.corSitesGroupModuleTable);
  $$CorObjectModuleTableTableTableManager get corObjectModuleTable =>
      $$CorObjectModuleTableTableTableManager(_db, _db.corObjectModuleTable);
  $$TBaseVisitsTableTableManager get tBaseVisits =>
      $$TBaseVisitsTableTableManager(_db, _db.tBaseVisits);
  $$CorVisitObserverTableTableManager get corVisitObserver =>
      $$CorVisitObserverTableTableManager(_db, _db.corVisitObserver);
  $$CorSiteTypeTableTableTableManager get corSiteTypeTable =>
      $$CorSiteTypeTableTableTableManager(_db, _db.corSiteTypeTable);
  $$CorModuleDatasetTableTableTableManager get corModuleDatasetTable =>
      $$CorModuleDatasetTableTableTableManager(_db, _db.corModuleDatasetTable);
  $$TTaxrefsTableTableManager get tTaxrefs =>
      $$TTaxrefsTableTableManager(_db, _db.tTaxrefs);
  $$BibListesTableTableTableManager get bibListesTable =>
      $$BibListesTableTableTableManager(_db, _db.bibListesTable);
  $$CorTaxonListeTableTableTableManager get corTaxonListeTable =>
      $$CorTaxonListeTableTableTableManager(_db, _db.corTaxonListeTable);
}
