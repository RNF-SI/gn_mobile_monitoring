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
  static const VerificationMeta _modulePictoMeta =
      const VerificationMeta('modulePicto');
  @override
  late final GeneratedColumn<String> modulePicto = GeneratedColumn<String>(
      'module_picto', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _moduleDescMeta =
      const VerificationMeta('moduleDesc');
  @override
  late final GeneratedColumn<String> moduleDesc = GeneratedColumn<String>(
      'module_desc', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _moduleGroupMeta =
      const VerificationMeta('moduleGroup');
  @override
  late final GeneratedColumn<String> moduleGroup = GeneratedColumn<String>(
      'module_group', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _modulePathMeta =
      const VerificationMeta('modulePath');
  @override
  late final GeneratedColumn<String> modulePath = GeneratedColumn<String>(
      'module_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _moduleExternalUrlMeta =
      const VerificationMeta('moduleExternalUrl');
  @override
  late final GeneratedColumn<String> moduleExternalUrl =
      GeneratedColumn<String>('module_external_url', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _moduleTargetMeta =
      const VerificationMeta('moduleTarget');
  @override
  late final GeneratedColumn<String> moduleTarget = GeneratedColumn<String>(
      'module_target', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _moduleCommentMeta =
      const VerificationMeta('moduleComment');
  @override
  late final GeneratedColumn<String> moduleComment = GeneratedColumn<String>(
      'module_comment', aliasedName, true,
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
  static const VerificationMeta _moduleDocUrlMeta =
      const VerificationMeta('moduleDocUrl');
  @override
  late final GeneratedColumn<String> moduleDocUrl = GeneratedColumn<String>(
      'module_doc_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _moduleOrderMeta =
      const VerificationMeta('moduleOrder');
  @override
  late final GeneratedColumn<int> moduleOrder = GeneratedColumn<int>(
      'module_order', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _ngModuleMeta =
      const VerificationMeta('ngModule');
  @override
  late final GeneratedColumn<String> ngModule = GeneratedColumn<String>(
      'ng_module', aliasedName, true,
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
        idModule,
        moduleCode,
        moduleLabel,
        modulePicto,
        moduleDesc,
        moduleGroup,
        modulePath,
        moduleExternalUrl,
        moduleTarget,
        moduleComment,
        activeFrontend,
        activeBackend,
        moduleDocUrl,
        moduleOrder,
        ngModule,
        metaCreateDate,
        metaUpdateDate
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
    if (data.containsKey('module_picto')) {
      context.handle(
          _modulePictoMeta,
          modulePicto.isAcceptableOrUnknown(
              data['module_picto']!, _modulePictoMeta));
    }
    if (data.containsKey('module_desc')) {
      context.handle(
          _moduleDescMeta,
          moduleDesc.isAcceptableOrUnknown(
              data['module_desc']!, _moduleDescMeta));
    }
    if (data.containsKey('module_group')) {
      context.handle(
          _moduleGroupMeta,
          moduleGroup.isAcceptableOrUnknown(
              data['module_group']!, _moduleGroupMeta));
    }
    if (data.containsKey('module_path')) {
      context.handle(
          _modulePathMeta,
          modulePath.isAcceptableOrUnknown(
              data['module_path']!, _modulePathMeta));
    }
    if (data.containsKey('module_external_url')) {
      context.handle(
          _moduleExternalUrlMeta,
          moduleExternalUrl.isAcceptableOrUnknown(
              data['module_external_url']!, _moduleExternalUrlMeta));
    }
    if (data.containsKey('module_target')) {
      context.handle(
          _moduleTargetMeta,
          moduleTarget.isAcceptableOrUnknown(
              data['module_target']!, _moduleTargetMeta));
    }
    if (data.containsKey('module_comment')) {
      context.handle(
          _moduleCommentMeta,
          moduleComment.isAcceptableOrUnknown(
              data['module_comment']!, _moduleCommentMeta));
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
    if (data.containsKey('module_doc_url')) {
      context.handle(
          _moduleDocUrlMeta,
          moduleDocUrl.isAcceptableOrUnknown(
              data['module_doc_url']!, _moduleDocUrlMeta));
    }
    if (data.containsKey('module_order')) {
      context.handle(
          _moduleOrderMeta,
          moduleOrder.isAcceptableOrUnknown(
              data['module_order']!, _moduleOrderMeta));
    }
    if (data.containsKey('ng_module')) {
      context.handle(_ngModuleMeta,
          ngModule.isAcceptableOrUnknown(data['ng_module']!, _ngModuleMeta));
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
      modulePicto: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}module_picto']),
      moduleDesc: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}module_desc']),
      moduleGroup: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}module_group']),
      modulePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}module_path']),
      moduleExternalUrl: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}module_external_url']),
      moduleTarget: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}module_target']),
      moduleComment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}module_comment']),
      activeFrontend: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}active_frontend']),
      activeBackend: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}active_backend']),
      moduleDocUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}module_doc_url']),
      moduleOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}module_order']),
      ngModule: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ng_module']),
      metaCreateDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}meta_create_date']),
      metaUpdateDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}meta_update_date']),
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
  final String? modulePicto;
  final String? moduleDesc;
  final String? moduleGroup;
  final String? modulePath;
  final String? moduleExternalUrl;
  final String? moduleTarget;
  final String? moduleComment;
  final bool? activeFrontend;
  final bool? activeBackend;
  final String? moduleDocUrl;
  final int? moduleOrder;
  final String? ngModule;
  final DateTime? metaCreateDate;
  final DateTime? metaUpdateDate;
  const TModule(
      {required this.idModule,
      this.moduleCode,
      this.moduleLabel,
      this.modulePicto,
      this.moduleDesc,
      this.moduleGroup,
      this.modulePath,
      this.moduleExternalUrl,
      this.moduleTarget,
      this.moduleComment,
      this.activeFrontend,
      this.activeBackend,
      this.moduleDocUrl,
      this.moduleOrder,
      this.ngModule,
      this.metaCreateDate,
      this.metaUpdateDate});
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
    if (!nullToAbsent || modulePicto != null) {
      map['module_picto'] = Variable<String>(modulePicto);
    }
    if (!nullToAbsent || moduleDesc != null) {
      map['module_desc'] = Variable<String>(moduleDesc);
    }
    if (!nullToAbsent || moduleGroup != null) {
      map['module_group'] = Variable<String>(moduleGroup);
    }
    if (!nullToAbsent || modulePath != null) {
      map['module_path'] = Variable<String>(modulePath);
    }
    if (!nullToAbsent || moduleExternalUrl != null) {
      map['module_external_url'] = Variable<String>(moduleExternalUrl);
    }
    if (!nullToAbsent || moduleTarget != null) {
      map['module_target'] = Variable<String>(moduleTarget);
    }
    if (!nullToAbsent || moduleComment != null) {
      map['module_comment'] = Variable<String>(moduleComment);
    }
    if (!nullToAbsent || activeFrontend != null) {
      map['active_frontend'] = Variable<bool>(activeFrontend);
    }
    if (!nullToAbsent || activeBackend != null) {
      map['active_backend'] = Variable<bool>(activeBackend);
    }
    if (!nullToAbsent || moduleDocUrl != null) {
      map['module_doc_url'] = Variable<String>(moduleDocUrl);
    }
    if (!nullToAbsent || moduleOrder != null) {
      map['module_order'] = Variable<int>(moduleOrder);
    }
    if (!nullToAbsent || ngModule != null) {
      map['ng_module'] = Variable<String>(ngModule);
    }
    if (!nullToAbsent || metaCreateDate != null) {
      map['meta_create_date'] = Variable<DateTime>(metaCreateDate);
    }
    if (!nullToAbsent || metaUpdateDate != null) {
      map['meta_update_date'] = Variable<DateTime>(metaUpdateDate);
    }
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
      modulePicto: modulePicto == null && nullToAbsent
          ? const Value.absent()
          : Value(modulePicto),
      moduleDesc: moduleDesc == null && nullToAbsent
          ? const Value.absent()
          : Value(moduleDesc),
      moduleGroup: moduleGroup == null && nullToAbsent
          ? const Value.absent()
          : Value(moduleGroup),
      modulePath: modulePath == null && nullToAbsent
          ? const Value.absent()
          : Value(modulePath),
      moduleExternalUrl: moduleExternalUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(moduleExternalUrl),
      moduleTarget: moduleTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(moduleTarget),
      moduleComment: moduleComment == null && nullToAbsent
          ? const Value.absent()
          : Value(moduleComment),
      activeFrontend: activeFrontend == null && nullToAbsent
          ? const Value.absent()
          : Value(activeFrontend),
      activeBackend: activeBackend == null && nullToAbsent
          ? const Value.absent()
          : Value(activeBackend),
      moduleDocUrl: moduleDocUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(moduleDocUrl),
      moduleOrder: moduleOrder == null && nullToAbsent
          ? const Value.absent()
          : Value(moduleOrder),
      ngModule: ngModule == null && nullToAbsent
          ? const Value.absent()
          : Value(ngModule),
      metaCreateDate: metaCreateDate == null && nullToAbsent
          ? const Value.absent()
          : Value(metaCreateDate),
      metaUpdateDate: metaUpdateDate == null && nullToAbsent
          ? const Value.absent()
          : Value(metaUpdateDate),
    );
  }

  factory TModule.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TModule(
      idModule: serializer.fromJson<int>(json['idModule']),
      moduleCode: serializer.fromJson<String?>(json['moduleCode']),
      moduleLabel: serializer.fromJson<String?>(json['moduleLabel']),
      modulePicto: serializer.fromJson<String?>(json['modulePicto']),
      moduleDesc: serializer.fromJson<String?>(json['moduleDesc']),
      moduleGroup: serializer.fromJson<String?>(json['moduleGroup']),
      modulePath: serializer.fromJson<String?>(json['modulePath']),
      moduleExternalUrl:
          serializer.fromJson<String?>(json['moduleExternalUrl']),
      moduleTarget: serializer.fromJson<String?>(json['moduleTarget']),
      moduleComment: serializer.fromJson<String?>(json['moduleComment']),
      activeFrontend: serializer.fromJson<bool?>(json['activeFrontend']),
      activeBackend: serializer.fromJson<bool?>(json['activeBackend']),
      moduleDocUrl: serializer.fromJson<String?>(json['moduleDocUrl']),
      moduleOrder: serializer.fromJson<int?>(json['moduleOrder']),
      ngModule: serializer.fromJson<String?>(json['ngModule']),
      metaCreateDate: serializer.fromJson<DateTime?>(json['metaCreateDate']),
      metaUpdateDate: serializer.fromJson<DateTime?>(json['metaUpdateDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'idModule': serializer.toJson<int>(idModule),
      'moduleCode': serializer.toJson<String?>(moduleCode),
      'moduleLabel': serializer.toJson<String?>(moduleLabel),
      'modulePicto': serializer.toJson<String?>(modulePicto),
      'moduleDesc': serializer.toJson<String?>(moduleDesc),
      'moduleGroup': serializer.toJson<String?>(moduleGroup),
      'modulePath': serializer.toJson<String?>(modulePath),
      'moduleExternalUrl': serializer.toJson<String?>(moduleExternalUrl),
      'moduleTarget': serializer.toJson<String?>(moduleTarget),
      'moduleComment': serializer.toJson<String?>(moduleComment),
      'activeFrontend': serializer.toJson<bool?>(activeFrontend),
      'activeBackend': serializer.toJson<bool?>(activeBackend),
      'moduleDocUrl': serializer.toJson<String?>(moduleDocUrl),
      'moduleOrder': serializer.toJson<int?>(moduleOrder),
      'ngModule': serializer.toJson<String?>(ngModule),
      'metaCreateDate': serializer.toJson<DateTime?>(metaCreateDate),
      'metaUpdateDate': serializer.toJson<DateTime?>(metaUpdateDate),
    };
  }

  TModule copyWith(
          {int? idModule,
          Value<String?> moduleCode = const Value.absent(),
          Value<String?> moduleLabel = const Value.absent(),
          Value<String?> modulePicto = const Value.absent(),
          Value<String?> moduleDesc = const Value.absent(),
          Value<String?> moduleGroup = const Value.absent(),
          Value<String?> modulePath = const Value.absent(),
          Value<String?> moduleExternalUrl = const Value.absent(),
          Value<String?> moduleTarget = const Value.absent(),
          Value<String?> moduleComment = const Value.absent(),
          Value<bool?> activeFrontend = const Value.absent(),
          Value<bool?> activeBackend = const Value.absent(),
          Value<String?> moduleDocUrl = const Value.absent(),
          Value<int?> moduleOrder = const Value.absent(),
          Value<String?> ngModule = const Value.absent(),
          Value<DateTime?> metaCreateDate = const Value.absent(),
          Value<DateTime?> metaUpdateDate = const Value.absent()}) =>
      TModule(
        idModule: idModule ?? this.idModule,
        moduleCode: moduleCode.present ? moduleCode.value : this.moduleCode,
        moduleLabel: moduleLabel.present ? moduleLabel.value : this.moduleLabel,
        modulePicto: modulePicto.present ? modulePicto.value : this.modulePicto,
        moduleDesc: moduleDesc.present ? moduleDesc.value : this.moduleDesc,
        moduleGroup: moduleGroup.present ? moduleGroup.value : this.moduleGroup,
        modulePath: modulePath.present ? modulePath.value : this.modulePath,
        moduleExternalUrl: moduleExternalUrl.present
            ? moduleExternalUrl.value
            : this.moduleExternalUrl,
        moduleTarget:
            moduleTarget.present ? moduleTarget.value : this.moduleTarget,
        moduleComment:
            moduleComment.present ? moduleComment.value : this.moduleComment,
        activeFrontend:
            activeFrontend.present ? activeFrontend.value : this.activeFrontend,
        activeBackend:
            activeBackend.present ? activeBackend.value : this.activeBackend,
        moduleDocUrl:
            moduleDocUrl.present ? moduleDocUrl.value : this.moduleDocUrl,
        moduleOrder: moduleOrder.present ? moduleOrder.value : this.moduleOrder,
        ngModule: ngModule.present ? ngModule.value : this.ngModule,
        metaCreateDate:
            metaCreateDate.present ? metaCreateDate.value : this.metaCreateDate,
        metaUpdateDate:
            metaUpdateDate.present ? metaUpdateDate.value : this.metaUpdateDate,
      );
  TModule copyWithCompanion(TModulesCompanion data) {
    return TModule(
      idModule: data.idModule.present ? data.idModule.value : this.idModule,
      moduleCode:
          data.moduleCode.present ? data.moduleCode.value : this.moduleCode,
      moduleLabel:
          data.moduleLabel.present ? data.moduleLabel.value : this.moduleLabel,
      modulePicto:
          data.modulePicto.present ? data.modulePicto.value : this.modulePicto,
      moduleDesc:
          data.moduleDesc.present ? data.moduleDesc.value : this.moduleDesc,
      moduleGroup:
          data.moduleGroup.present ? data.moduleGroup.value : this.moduleGroup,
      modulePath:
          data.modulePath.present ? data.modulePath.value : this.modulePath,
      moduleExternalUrl: data.moduleExternalUrl.present
          ? data.moduleExternalUrl.value
          : this.moduleExternalUrl,
      moduleTarget: data.moduleTarget.present
          ? data.moduleTarget.value
          : this.moduleTarget,
      moduleComment: data.moduleComment.present
          ? data.moduleComment.value
          : this.moduleComment,
      activeFrontend: data.activeFrontend.present
          ? data.activeFrontend.value
          : this.activeFrontend,
      activeBackend: data.activeBackend.present
          ? data.activeBackend.value
          : this.activeBackend,
      moduleDocUrl: data.moduleDocUrl.present
          ? data.moduleDocUrl.value
          : this.moduleDocUrl,
      moduleOrder:
          data.moduleOrder.present ? data.moduleOrder.value : this.moduleOrder,
      ngModule: data.ngModule.present ? data.ngModule.value : this.ngModule,
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
    return (StringBuffer('TModule(')
          ..write('idModule: $idModule, ')
          ..write('moduleCode: $moduleCode, ')
          ..write('moduleLabel: $moduleLabel, ')
          ..write('modulePicto: $modulePicto, ')
          ..write('moduleDesc: $moduleDesc, ')
          ..write('moduleGroup: $moduleGroup, ')
          ..write('modulePath: $modulePath, ')
          ..write('moduleExternalUrl: $moduleExternalUrl, ')
          ..write('moduleTarget: $moduleTarget, ')
          ..write('moduleComment: $moduleComment, ')
          ..write('activeFrontend: $activeFrontend, ')
          ..write('activeBackend: $activeBackend, ')
          ..write('moduleDocUrl: $moduleDocUrl, ')
          ..write('moduleOrder: $moduleOrder, ')
          ..write('ngModule: $ngModule, ')
          ..write('metaCreateDate: $metaCreateDate, ')
          ..write('metaUpdateDate: $metaUpdateDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      idModule,
      moduleCode,
      moduleLabel,
      modulePicto,
      moduleDesc,
      moduleGroup,
      modulePath,
      moduleExternalUrl,
      moduleTarget,
      moduleComment,
      activeFrontend,
      activeBackend,
      moduleDocUrl,
      moduleOrder,
      ngModule,
      metaCreateDate,
      metaUpdateDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TModule &&
          other.idModule == this.idModule &&
          other.moduleCode == this.moduleCode &&
          other.moduleLabel == this.moduleLabel &&
          other.modulePicto == this.modulePicto &&
          other.moduleDesc == this.moduleDesc &&
          other.moduleGroup == this.moduleGroup &&
          other.modulePath == this.modulePath &&
          other.moduleExternalUrl == this.moduleExternalUrl &&
          other.moduleTarget == this.moduleTarget &&
          other.moduleComment == this.moduleComment &&
          other.activeFrontend == this.activeFrontend &&
          other.activeBackend == this.activeBackend &&
          other.moduleDocUrl == this.moduleDocUrl &&
          other.moduleOrder == this.moduleOrder &&
          other.ngModule == this.ngModule &&
          other.metaCreateDate == this.metaCreateDate &&
          other.metaUpdateDate == this.metaUpdateDate);
}

class TModulesCompanion extends UpdateCompanion<TModule> {
  final Value<int> idModule;
  final Value<String?> moduleCode;
  final Value<String?> moduleLabel;
  final Value<String?> modulePicto;
  final Value<String?> moduleDesc;
  final Value<String?> moduleGroup;
  final Value<String?> modulePath;
  final Value<String?> moduleExternalUrl;
  final Value<String?> moduleTarget;
  final Value<String?> moduleComment;
  final Value<bool?> activeFrontend;
  final Value<bool?> activeBackend;
  final Value<String?> moduleDocUrl;
  final Value<int?> moduleOrder;
  final Value<String?> ngModule;
  final Value<DateTime?> metaCreateDate;
  final Value<DateTime?> metaUpdateDate;
  const TModulesCompanion({
    this.idModule = const Value.absent(),
    this.moduleCode = const Value.absent(),
    this.moduleLabel = const Value.absent(),
    this.modulePicto = const Value.absent(),
    this.moduleDesc = const Value.absent(),
    this.moduleGroup = const Value.absent(),
    this.modulePath = const Value.absent(),
    this.moduleExternalUrl = const Value.absent(),
    this.moduleTarget = const Value.absent(),
    this.moduleComment = const Value.absent(),
    this.activeFrontend = const Value.absent(),
    this.activeBackend = const Value.absent(),
    this.moduleDocUrl = const Value.absent(),
    this.moduleOrder = const Value.absent(),
    this.ngModule = const Value.absent(),
    this.metaCreateDate = const Value.absent(),
    this.metaUpdateDate = const Value.absent(),
  });
  TModulesCompanion.insert({
    this.idModule = const Value.absent(),
    this.moduleCode = const Value.absent(),
    this.moduleLabel = const Value.absent(),
    this.modulePicto = const Value.absent(),
    this.moduleDesc = const Value.absent(),
    this.moduleGroup = const Value.absent(),
    this.modulePath = const Value.absent(),
    this.moduleExternalUrl = const Value.absent(),
    this.moduleTarget = const Value.absent(),
    this.moduleComment = const Value.absent(),
    this.activeFrontend = const Value.absent(),
    this.activeBackend = const Value.absent(),
    this.moduleDocUrl = const Value.absent(),
    this.moduleOrder = const Value.absent(),
    this.ngModule = const Value.absent(),
    this.metaCreateDate = const Value.absent(),
    this.metaUpdateDate = const Value.absent(),
  });
  static Insertable<TModule> custom({
    Expression<int>? idModule,
    Expression<String>? moduleCode,
    Expression<String>? moduleLabel,
    Expression<String>? modulePicto,
    Expression<String>? moduleDesc,
    Expression<String>? moduleGroup,
    Expression<String>? modulePath,
    Expression<String>? moduleExternalUrl,
    Expression<String>? moduleTarget,
    Expression<String>? moduleComment,
    Expression<bool>? activeFrontend,
    Expression<bool>? activeBackend,
    Expression<String>? moduleDocUrl,
    Expression<int>? moduleOrder,
    Expression<String>? ngModule,
    Expression<DateTime>? metaCreateDate,
    Expression<DateTime>? metaUpdateDate,
  }) {
    return RawValuesInsertable({
      if (idModule != null) 'id_module': idModule,
      if (moduleCode != null) 'module_code': moduleCode,
      if (moduleLabel != null) 'module_label': moduleLabel,
      if (modulePicto != null) 'module_picto': modulePicto,
      if (moduleDesc != null) 'module_desc': moduleDesc,
      if (moduleGroup != null) 'module_group': moduleGroup,
      if (modulePath != null) 'module_path': modulePath,
      if (moduleExternalUrl != null) 'module_external_url': moduleExternalUrl,
      if (moduleTarget != null) 'module_target': moduleTarget,
      if (moduleComment != null) 'module_comment': moduleComment,
      if (activeFrontend != null) 'active_frontend': activeFrontend,
      if (activeBackend != null) 'active_backend': activeBackend,
      if (moduleDocUrl != null) 'module_doc_url': moduleDocUrl,
      if (moduleOrder != null) 'module_order': moduleOrder,
      if (ngModule != null) 'ng_module': ngModule,
      if (metaCreateDate != null) 'meta_create_date': metaCreateDate,
      if (metaUpdateDate != null) 'meta_update_date': metaUpdateDate,
    });
  }

  TModulesCompanion copyWith(
      {Value<int>? idModule,
      Value<String?>? moduleCode,
      Value<String?>? moduleLabel,
      Value<String?>? modulePicto,
      Value<String?>? moduleDesc,
      Value<String?>? moduleGroup,
      Value<String?>? modulePath,
      Value<String?>? moduleExternalUrl,
      Value<String?>? moduleTarget,
      Value<String?>? moduleComment,
      Value<bool?>? activeFrontend,
      Value<bool?>? activeBackend,
      Value<String?>? moduleDocUrl,
      Value<int?>? moduleOrder,
      Value<String?>? ngModule,
      Value<DateTime?>? metaCreateDate,
      Value<DateTime?>? metaUpdateDate}) {
    return TModulesCompanion(
      idModule: idModule ?? this.idModule,
      moduleCode: moduleCode ?? this.moduleCode,
      moduleLabel: moduleLabel ?? this.moduleLabel,
      modulePicto: modulePicto ?? this.modulePicto,
      moduleDesc: moduleDesc ?? this.moduleDesc,
      moduleGroup: moduleGroup ?? this.moduleGroup,
      modulePath: modulePath ?? this.modulePath,
      moduleExternalUrl: moduleExternalUrl ?? this.moduleExternalUrl,
      moduleTarget: moduleTarget ?? this.moduleTarget,
      moduleComment: moduleComment ?? this.moduleComment,
      activeFrontend: activeFrontend ?? this.activeFrontend,
      activeBackend: activeBackend ?? this.activeBackend,
      moduleDocUrl: moduleDocUrl ?? this.moduleDocUrl,
      moduleOrder: moduleOrder ?? this.moduleOrder,
      ngModule: ngModule ?? this.ngModule,
      metaCreateDate: metaCreateDate ?? this.metaCreateDate,
      metaUpdateDate: metaUpdateDate ?? this.metaUpdateDate,
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
    if (modulePicto.present) {
      map['module_picto'] = Variable<String>(modulePicto.value);
    }
    if (moduleDesc.present) {
      map['module_desc'] = Variable<String>(moduleDesc.value);
    }
    if (moduleGroup.present) {
      map['module_group'] = Variable<String>(moduleGroup.value);
    }
    if (modulePath.present) {
      map['module_path'] = Variable<String>(modulePath.value);
    }
    if (moduleExternalUrl.present) {
      map['module_external_url'] = Variable<String>(moduleExternalUrl.value);
    }
    if (moduleTarget.present) {
      map['module_target'] = Variable<String>(moduleTarget.value);
    }
    if (moduleComment.present) {
      map['module_comment'] = Variable<String>(moduleComment.value);
    }
    if (activeFrontend.present) {
      map['active_frontend'] = Variable<bool>(activeFrontend.value);
    }
    if (activeBackend.present) {
      map['active_backend'] = Variable<bool>(activeBackend.value);
    }
    if (moduleDocUrl.present) {
      map['module_doc_url'] = Variable<String>(moduleDocUrl.value);
    }
    if (moduleOrder.present) {
      map['module_order'] = Variable<int>(moduleOrder.value);
    }
    if (ngModule.present) {
      map['ng_module'] = Variable<String>(ngModule.value);
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
    return (StringBuffer('TModulesCompanion(')
          ..write('idModule: $idModule, ')
          ..write('moduleCode: $moduleCode, ')
          ..write('moduleLabel: $moduleLabel, ')
          ..write('modulePicto: $modulePicto, ')
          ..write('moduleDesc: $moduleDesc, ')
          ..write('moduleGroup: $moduleGroup, ')
          ..write('modulePath: $modulePath, ')
          ..write('moduleExternalUrl: $moduleExternalUrl, ')
          ..write('moduleTarget: $moduleTarget, ')
          ..write('moduleComment: $moduleComment, ')
          ..write('activeFrontend: $activeFrontend, ')
          ..write('activeBackend: $activeBackend, ')
          ..write('moduleDocUrl: $moduleDocUrl, ')
          ..write('moduleOrder: $moduleOrder, ')
          ..write('ngModule: $ngModule, ')
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
          defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
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
  @override
  List<GeneratedColumn> get $columns => [
        idModule,
        uuidModuleComplement,
        idListObserver,
        idListTaxonomy,
        bSynthese,
        taxonomyDisplayFieldName,
        bDrawSitesGroup,
        data
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
  const TModuleComplement(
      {required this.idModule,
      this.uuidModuleComplement,
      this.idListObserver,
      this.idListTaxonomy,
      required this.bSynthese,
      required this.taxonomyDisplayFieldName,
      this.bDrawSitesGroup,
      this.data});
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
          Value<String?> data = const Value.absent()}) =>
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
          ..write('data: $data')
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
      data);
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
          other.data == this.data);
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
  const TModuleComplementsCompanion({
    this.idModule = const Value.absent(),
    this.uuidModuleComplement = const Value.absent(),
    this.idListObserver = const Value.absent(),
    this.idListTaxonomy = const Value.absent(),
    this.bSynthese = const Value.absent(),
    this.taxonomyDisplayFieldName = const Value.absent(),
    this.bDrawSitesGroup = const Value.absent(),
    this.data = const Value.absent(),
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
      Value<String?>? data}) {
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
          ..write('data: $data')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TModulesTable tModules = $TModulesTable(this);
  late final $TModuleComplementsTable tModuleComplements =
      $TModuleComplementsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [tModules, tModuleComplements];
}

typedef $$TModulesTableCreateCompanionBuilder = TModulesCompanion Function({
  Value<int> idModule,
  Value<String?> moduleCode,
  Value<String?> moduleLabel,
  Value<String?> modulePicto,
  Value<String?> moduleDesc,
  Value<String?> moduleGroup,
  Value<String?> modulePath,
  Value<String?> moduleExternalUrl,
  Value<String?> moduleTarget,
  Value<String?> moduleComment,
  Value<bool?> activeFrontend,
  Value<bool?> activeBackend,
  Value<String?> moduleDocUrl,
  Value<int?> moduleOrder,
  Value<String?> ngModule,
  Value<DateTime?> metaCreateDate,
  Value<DateTime?> metaUpdateDate,
});
typedef $$TModulesTableUpdateCompanionBuilder = TModulesCompanion Function({
  Value<int> idModule,
  Value<String?> moduleCode,
  Value<String?> moduleLabel,
  Value<String?> modulePicto,
  Value<String?> moduleDesc,
  Value<String?> moduleGroup,
  Value<String?> modulePath,
  Value<String?> moduleExternalUrl,
  Value<String?> moduleTarget,
  Value<String?> moduleComment,
  Value<bool?> activeFrontend,
  Value<bool?> activeBackend,
  Value<String?> moduleDocUrl,
  Value<int?> moduleOrder,
  Value<String?> ngModule,
  Value<DateTime?> metaCreateDate,
  Value<DateTime?> metaUpdateDate,
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

  ColumnFilters<String> get modulePicto => $composableBuilder(
      column: $table.modulePicto, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get moduleDesc => $composableBuilder(
      column: $table.moduleDesc, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get moduleGroup => $composableBuilder(
      column: $table.moduleGroup, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get modulePath => $composableBuilder(
      column: $table.modulePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get moduleExternalUrl => $composableBuilder(
      column: $table.moduleExternalUrl,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get moduleTarget => $composableBuilder(
      column: $table.moduleTarget, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get moduleComment => $composableBuilder(
      column: $table.moduleComment, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get activeFrontend => $composableBuilder(
      column: $table.activeFrontend,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get activeBackend => $composableBuilder(
      column: $table.activeBackend, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get moduleDocUrl => $composableBuilder(
      column: $table.moduleDocUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get moduleOrder => $composableBuilder(
      column: $table.moduleOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ngModule => $composableBuilder(
      column: $table.ngModule, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get metaCreateDate => $composableBuilder(
      column: $table.metaCreateDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get metaUpdateDate => $composableBuilder(
      column: $table.metaUpdateDate,
      builder: (column) => ColumnFilters(column));
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

  ColumnOrderings<String> get modulePicto => $composableBuilder(
      column: $table.modulePicto, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get moduleDesc => $composableBuilder(
      column: $table.moduleDesc, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get moduleGroup => $composableBuilder(
      column: $table.moduleGroup, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get modulePath => $composableBuilder(
      column: $table.modulePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get moduleExternalUrl => $composableBuilder(
      column: $table.moduleExternalUrl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get moduleTarget => $composableBuilder(
      column: $table.moduleTarget,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get moduleComment => $composableBuilder(
      column: $table.moduleComment,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get activeFrontend => $composableBuilder(
      column: $table.activeFrontend,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get activeBackend => $composableBuilder(
      column: $table.activeBackend,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get moduleDocUrl => $composableBuilder(
      column: $table.moduleDocUrl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get moduleOrder => $composableBuilder(
      column: $table.moduleOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ngModule => $composableBuilder(
      column: $table.ngModule, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get metaCreateDate => $composableBuilder(
      column: $table.metaCreateDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get metaUpdateDate => $composableBuilder(
      column: $table.metaUpdateDate,
      builder: (column) => ColumnOrderings(column));
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

  GeneratedColumn<String> get modulePicto => $composableBuilder(
      column: $table.modulePicto, builder: (column) => column);

  GeneratedColumn<String> get moduleDesc => $composableBuilder(
      column: $table.moduleDesc, builder: (column) => column);

  GeneratedColumn<String> get moduleGroup => $composableBuilder(
      column: $table.moduleGroup, builder: (column) => column);

  GeneratedColumn<String> get modulePath => $composableBuilder(
      column: $table.modulePath, builder: (column) => column);

  GeneratedColumn<String> get moduleExternalUrl => $composableBuilder(
      column: $table.moduleExternalUrl, builder: (column) => column);

  GeneratedColumn<String> get moduleTarget => $composableBuilder(
      column: $table.moduleTarget, builder: (column) => column);

  GeneratedColumn<String> get moduleComment => $composableBuilder(
      column: $table.moduleComment, builder: (column) => column);

  GeneratedColumn<bool> get activeFrontend => $composableBuilder(
      column: $table.activeFrontend, builder: (column) => column);

  GeneratedColumn<bool> get activeBackend => $composableBuilder(
      column: $table.activeBackend, builder: (column) => column);

  GeneratedColumn<String> get moduleDocUrl => $composableBuilder(
      column: $table.moduleDocUrl, builder: (column) => column);

  GeneratedColumn<int> get moduleOrder => $composableBuilder(
      column: $table.moduleOrder, builder: (column) => column);

  GeneratedColumn<String> get ngModule =>
      $composableBuilder(column: $table.ngModule, builder: (column) => column);

  GeneratedColumn<DateTime> get metaCreateDate => $composableBuilder(
      column: $table.metaCreateDate, builder: (column) => column);

  GeneratedColumn<DateTime> get metaUpdateDate => $composableBuilder(
      column: $table.metaUpdateDate, builder: (column) => column);
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
            Value<String?> modulePicto = const Value.absent(),
            Value<String?> moduleDesc = const Value.absent(),
            Value<String?> moduleGroup = const Value.absent(),
            Value<String?> modulePath = const Value.absent(),
            Value<String?> moduleExternalUrl = const Value.absent(),
            Value<String?> moduleTarget = const Value.absent(),
            Value<String?> moduleComment = const Value.absent(),
            Value<bool?> activeFrontend = const Value.absent(),
            Value<bool?> activeBackend = const Value.absent(),
            Value<String?> moduleDocUrl = const Value.absent(),
            Value<int?> moduleOrder = const Value.absent(),
            Value<String?> ngModule = const Value.absent(),
            Value<DateTime?> metaCreateDate = const Value.absent(),
            Value<DateTime?> metaUpdateDate = const Value.absent(),
          }) =>
              TModulesCompanion(
            idModule: idModule,
            moduleCode: moduleCode,
            moduleLabel: moduleLabel,
            modulePicto: modulePicto,
            moduleDesc: moduleDesc,
            moduleGroup: moduleGroup,
            modulePath: modulePath,
            moduleExternalUrl: moduleExternalUrl,
            moduleTarget: moduleTarget,
            moduleComment: moduleComment,
            activeFrontend: activeFrontend,
            activeBackend: activeBackend,
            moduleDocUrl: moduleDocUrl,
            moduleOrder: moduleOrder,
            ngModule: ngModule,
            metaCreateDate: metaCreateDate,
            metaUpdateDate: metaUpdateDate,
          ),
          createCompanionCallback: ({
            Value<int> idModule = const Value.absent(),
            Value<String?> moduleCode = const Value.absent(),
            Value<String?> moduleLabel = const Value.absent(),
            Value<String?> modulePicto = const Value.absent(),
            Value<String?> moduleDesc = const Value.absent(),
            Value<String?> moduleGroup = const Value.absent(),
            Value<String?> modulePath = const Value.absent(),
            Value<String?> moduleExternalUrl = const Value.absent(),
            Value<String?> moduleTarget = const Value.absent(),
            Value<String?> moduleComment = const Value.absent(),
            Value<bool?> activeFrontend = const Value.absent(),
            Value<bool?> activeBackend = const Value.absent(),
            Value<String?> moduleDocUrl = const Value.absent(),
            Value<int?> moduleOrder = const Value.absent(),
            Value<String?> ngModule = const Value.absent(),
            Value<DateTime?> metaCreateDate = const Value.absent(),
            Value<DateTime?> metaUpdateDate = const Value.absent(),
          }) =>
              TModulesCompanion.insert(
            idModule: idModule,
            moduleCode: moduleCode,
            moduleLabel: moduleLabel,
            modulePicto: modulePicto,
            moduleDesc: moduleDesc,
            moduleGroup: moduleGroup,
            modulePath: modulePath,
            moduleExternalUrl: moduleExternalUrl,
            moduleTarget: moduleTarget,
            moduleComment: moduleComment,
            activeFrontend: activeFrontend,
            activeBackend: activeBackend,
            moduleDocUrl: moduleDocUrl,
            moduleOrder: moduleOrder,
            ngModule: ngModule,
            metaCreateDate: metaCreateDate,
            metaUpdateDate: metaUpdateDate,
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TModulesTableTableManager get tModules =>
      $$TModulesTableTableManager(_db, _db.tModules);
  $$TModuleComplementsTableTableManager get tModuleComplements =>
      $$TModuleComplementsTableTableManager(_db, _db.tModuleComplements);
}
