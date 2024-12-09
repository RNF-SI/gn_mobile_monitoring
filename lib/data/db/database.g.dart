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

class $CorSiteModulesTable extends CorSiteModules
    with TableInfo<$CorSiteModulesTable, CorSiteModule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CorSiteModulesTable(this.attachedDatabase, [this._alias]);
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
  static const String $name = 'cor_site_modules';
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
  $CorSiteModulesTable createAlias(String alias) {
    return $CorSiteModulesTable(attachedDatabase, alias);
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

  CorSiteModulesCompanion toCompanion(bool nullToAbsent) {
    return CorSiteModulesCompanion(
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
  CorSiteModule copyWithCompanion(CorSiteModulesCompanion data) {
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

class CorSiteModulesCompanion extends UpdateCompanion<CorSiteModule> {
  final Value<int> idBaseSite;
  final Value<int> idModule;
  final Value<int> rowid;
  const CorSiteModulesCompanion({
    this.idBaseSite = const Value.absent(),
    this.idModule = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CorSiteModulesCompanion.insert({
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

  CorSiteModulesCompanion copyWith(
      {Value<int>? idBaseSite, Value<int>? idModule, Value<int>? rowid}) {
    return CorSiteModulesCompanion(
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
    return (StringBuffer('CorSiteModulesCompanion(')
          ..write('idBaseSite: $idBaseSite, ')
          ..write('idModule: $idModule, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CorObjectModulesTable extends CorObjectModules
    with TableInfo<$CorObjectModulesTable, CorObjectModule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CorObjectModulesTable(this.attachedDatabase, [this._alias]);
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
  static const String $name = 'cor_object_modules';
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
  $CorObjectModulesTable createAlias(String alias) {
    return $CorObjectModulesTable(attachedDatabase, alias);
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

  CorObjectModulesCompanion toCompanion(bool nullToAbsent) {
    return CorObjectModulesCompanion(
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
  CorObjectModule copyWithCompanion(CorObjectModulesCompanion data) {
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

class CorObjectModulesCompanion extends UpdateCompanion<CorObjectModule> {
  final Value<int> idCorObjectModule;
  final Value<int> idObject;
  final Value<int> idModule;
  const CorObjectModulesCompanion({
    this.idCorObjectModule = const Value.absent(),
    this.idObject = const Value.absent(),
    this.idModule = const Value.absent(),
  });
  CorObjectModulesCompanion.insert({
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

  CorObjectModulesCompanion copyWith(
      {Value<int>? idCorObjectModule,
      Value<int>? idObject,
      Value<int>? idModule}) {
    return CorObjectModulesCompanion(
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
    return (StringBuffer('CorObjectModulesCompanion(')
          ..write('idCorObjectModule: $idCorObjectModule, ')
          ..write('idObject: $idObject, ')
          ..write('idModule: $idModule')
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
  late final $TObjectsTable tObjects = $TObjectsTable(this);
  late final $TActionsTable tActions = $TActionsTable(this);
  late final $TPermissionsAvailableTable tPermissionsAvailable =
      $TPermissionsAvailableTable(this);
  late final $TPermissionsTable tPermissions = $TPermissionsTable(this);
  late final $CorSiteModulesTable corSiteModules = $CorSiteModulesTable(this);
  late final $CorObjectModulesTable corObjectModules =
      $CorObjectModulesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        tModules,
        tModuleComplements,
        tSitesGroups,
        tSiteComplements,
        tVisitComplements,
        tObservations,
        tObservationComplements,
        tObservationDetails,
        bibTablesLocations,
        tObjects,
        tActions,
        tPermissionsAvailable,
        tPermissions,
        corSiteModules,
        corObjectModules
      ];
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
typedef $$CorSiteModulesTableCreateCompanionBuilder = CorSiteModulesCompanion
    Function({
  required int idBaseSite,
  required int idModule,
  Value<int> rowid,
});
typedef $$CorSiteModulesTableUpdateCompanionBuilder = CorSiteModulesCompanion
    Function({
  Value<int> idBaseSite,
  Value<int> idModule,
  Value<int> rowid,
});

class $$CorSiteModulesTableFilterComposer
    extends Composer<_$AppDatabase, $CorSiteModulesTable> {
  $$CorSiteModulesTableFilterComposer({
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

class $$CorSiteModulesTableOrderingComposer
    extends Composer<_$AppDatabase, $CorSiteModulesTable> {
  $$CorSiteModulesTableOrderingComposer({
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

class $$CorSiteModulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CorSiteModulesTable> {
  $$CorSiteModulesTableAnnotationComposer({
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

class $$CorSiteModulesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CorSiteModulesTable,
    CorSiteModule,
    $$CorSiteModulesTableFilterComposer,
    $$CorSiteModulesTableOrderingComposer,
    $$CorSiteModulesTableAnnotationComposer,
    $$CorSiteModulesTableCreateCompanionBuilder,
    $$CorSiteModulesTableUpdateCompanionBuilder,
    (
      CorSiteModule,
      BaseReferences<_$AppDatabase, $CorSiteModulesTable, CorSiteModule>
    ),
    CorSiteModule,
    PrefetchHooks Function()> {
  $$CorSiteModulesTableTableManager(
      _$AppDatabase db, $CorSiteModulesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CorSiteModulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CorSiteModulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CorSiteModulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> idBaseSite = const Value.absent(),
            Value<int> idModule = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CorSiteModulesCompanion(
            idBaseSite: idBaseSite,
            idModule: idModule,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int idBaseSite,
            required int idModule,
            Value<int> rowid = const Value.absent(),
          }) =>
              CorSiteModulesCompanion.insert(
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

typedef $$CorSiteModulesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CorSiteModulesTable,
    CorSiteModule,
    $$CorSiteModulesTableFilterComposer,
    $$CorSiteModulesTableOrderingComposer,
    $$CorSiteModulesTableAnnotationComposer,
    $$CorSiteModulesTableCreateCompanionBuilder,
    $$CorSiteModulesTableUpdateCompanionBuilder,
    (
      CorSiteModule,
      BaseReferences<_$AppDatabase, $CorSiteModulesTable, CorSiteModule>
    ),
    CorSiteModule,
    PrefetchHooks Function()>;
typedef $$CorObjectModulesTableCreateCompanionBuilder
    = CorObjectModulesCompanion Function({
  Value<int> idCorObjectModule,
  required int idObject,
  required int idModule,
});
typedef $$CorObjectModulesTableUpdateCompanionBuilder
    = CorObjectModulesCompanion Function({
  Value<int> idCorObjectModule,
  Value<int> idObject,
  Value<int> idModule,
});

class $$CorObjectModulesTableFilterComposer
    extends Composer<_$AppDatabase, $CorObjectModulesTable> {
  $$CorObjectModulesTableFilterComposer({
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

class $$CorObjectModulesTableOrderingComposer
    extends Composer<_$AppDatabase, $CorObjectModulesTable> {
  $$CorObjectModulesTableOrderingComposer({
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

class $$CorObjectModulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CorObjectModulesTable> {
  $$CorObjectModulesTableAnnotationComposer({
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

class $$CorObjectModulesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CorObjectModulesTable,
    CorObjectModule,
    $$CorObjectModulesTableFilterComposer,
    $$CorObjectModulesTableOrderingComposer,
    $$CorObjectModulesTableAnnotationComposer,
    $$CorObjectModulesTableCreateCompanionBuilder,
    $$CorObjectModulesTableUpdateCompanionBuilder,
    (
      CorObjectModule,
      BaseReferences<_$AppDatabase, $CorObjectModulesTable, CorObjectModule>
    ),
    CorObjectModule,
    PrefetchHooks Function()> {
  $$CorObjectModulesTableTableManager(
      _$AppDatabase db, $CorObjectModulesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CorObjectModulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CorObjectModulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CorObjectModulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> idCorObjectModule = const Value.absent(),
            Value<int> idObject = const Value.absent(),
            Value<int> idModule = const Value.absent(),
          }) =>
              CorObjectModulesCompanion(
            idCorObjectModule: idCorObjectModule,
            idObject: idObject,
            idModule: idModule,
          ),
          createCompanionCallback: ({
            Value<int> idCorObjectModule = const Value.absent(),
            required int idObject,
            required int idModule,
          }) =>
              CorObjectModulesCompanion.insert(
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

typedef $$CorObjectModulesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CorObjectModulesTable,
    CorObjectModule,
    $$CorObjectModulesTableFilterComposer,
    $$CorObjectModulesTableOrderingComposer,
    $$CorObjectModulesTableAnnotationComposer,
    $$CorObjectModulesTableCreateCompanionBuilder,
    $$CorObjectModulesTableUpdateCompanionBuilder,
    (
      CorObjectModule,
      BaseReferences<_$AppDatabase, $CorObjectModulesTable, CorObjectModule>
    ),
    CorObjectModule,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TModulesTableTableManager get tModules =>
      $$TModulesTableTableManager(_db, _db.tModules);
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
  $$TObjectsTableTableManager get tObjects =>
      $$TObjectsTableTableManager(_db, _db.tObjects);
  $$TActionsTableTableManager get tActions =>
      $$TActionsTableTableManager(_db, _db.tActions);
  $$TPermissionsAvailableTableTableManager get tPermissionsAvailable =>
      $$TPermissionsAvailableTableTableManager(_db, _db.tPermissionsAvailable);
  $$TPermissionsTableTableManager get tPermissions =>
      $$TPermissionsTableTableManager(_db, _db.tPermissions);
  $$CorSiteModulesTableTableManager get corSiteModules =>
      $$CorSiteModulesTableTableManager(_db, _db.corSiteModules);
  $$CorObjectModulesTableTableManager get corObjectModules =>
      $$CorObjectModulesTableTableManager(_db, _db.corObjectModules);
}
