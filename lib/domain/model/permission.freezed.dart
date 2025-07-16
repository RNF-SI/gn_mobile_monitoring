// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'permission.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Permission _$PermissionFromJson(Map<String, dynamic> json) {
  return _Permission.fromJson(json);
}

/// @nodoc
mixin _$Permission {
  String get moduleCode => throw _privateConstructorUsedError;
  PermissionLevel get visits => throw _privateConstructorUsedError;
  PermissionLevel get sites => throw _privateConstructorUsedError;
  DateTime get lastSync => throw _privateConstructorUsedError;

  /// Serializes this Permission to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Permission
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PermissionCopyWith<Permission> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PermissionCopyWith<$Res> {
  factory $PermissionCopyWith(
          Permission value, $Res Function(Permission) then) =
      _$PermissionCopyWithImpl<$Res, Permission>;
  @useResult
  $Res call(
      {String moduleCode,
      PermissionLevel visits,
      PermissionLevel sites,
      DateTime lastSync});

  $PermissionLevelCopyWith<$Res> get visits;
  $PermissionLevelCopyWith<$Res> get sites;
}

/// @nodoc
class _$PermissionCopyWithImpl<$Res, $Val extends Permission>
    implements $PermissionCopyWith<$Res> {
  _$PermissionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Permission
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? moduleCode = null,
    Object? visits = null,
    Object? sites = null,
    Object? lastSync = null,
  }) {
    return _then(_value.copyWith(
      moduleCode: null == moduleCode
          ? _value.moduleCode
          : moduleCode // ignore: cast_nullable_to_non_nullable
              as String,
      visits: null == visits
          ? _value.visits
          : visits // ignore: cast_nullable_to_non_nullable
              as PermissionLevel,
      sites: null == sites
          ? _value.sites
          : sites // ignore: cast_nullable_to_non_nullable
              as PermissionLevel,
      lastSync: null == lastSync
          ? _value.lastSync
          : lastSync // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of Permission
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PermissionLevelCopyWith<$Res> get visits {
    return $PermissionLevelCopyWith<$Res>(_value.visits, (value) {
      return _then(_value.copyWith(visits: value) as $Val);
    });
  }

  /// Create a copy of Permission
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PermissionLevelCopyWith<$Res> get sites {
    return $PermissionLevelCopyWith<$Res>(_value.sites, (value) {
      return _then(_value.copyWith(sites: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PermissionImplCopyWith<$Res>
    implements $PermissionCopyWith<$Res> {
  factory _$$PermissionImplCopyWith(
          _$PermissionImpl value, $Res Function(_$PermissionImpl) then) =
      __$$PermissionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String moduleCode,
      PermissionLevel visits,
      PermissionLevel sites,
      DateTime lastSync});

  @override
  $PermissionLevelCopyWith<$Res> get visits;
  @override
  $PermissionLevelCopyWith<$Res> get sites;
}

/// @nodoc
class __$$PermissionImplCopyWithImpl<$Res>
    extends _$PermissionCopyWithImpl<$Res, _$PermissionImpl>
    implements _$$PermissionImplCopyWith<$Res> {
  __$$PermissionImplCopyWithImpl(
      _$PermissionImpl _value, $Res Function(_$PermissionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Permission
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? moduleCode = null,
    Object? visits = null,
    Object? sites = null,
    Object? lastSync = null,
  }) {
    return _then(_$PermissionImpl(
      moduleCode: null == moduleCode
          ? _value.moduleCode
          : moduleCode // ignore: cast_nullable_to_non_nullable
              as String,
      visits: null == visits
          ? _value.visits
          : visits // ignore: cast_nullable_to_non_nullable
              as PermissionLevel,
      sites: null == sites
          ? _value.sites
          : sites // ignore: cast_nullable_to_non_nullable
              as PermissionLevel,
      lastSync: null == lastSync
          ? _value.lastSync
          : lastSync // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PermissionImpl implements _Permission {
  const _$PermissionImpl(
      {required this.moduleCode,
      required this.visits,
      required this.sites,
      required this.lastSync});

  factory _$PermissionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PermissionImplFromJson(json);

  @override
  final String moduleCode;
  @override
  final PermissionLevel visits;
  @override
  final PermissionLevel sites;
  @override
  final DateTime lastSync;

  @override
  String toString() {
    return 'Permission(moduleCode: $moduleCode, visits: $visits, sites: $sites, lastSync: $lastSync)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PermissionImpl &&
            (identical(other.moduleCode, moduleCode) ||
                other.moduleCode == moduleCode) &&
            (identical(other.visits, visits) || other.visits == visits) &&
            (identical(other.sites, sites) || other.sites == sites) &&
            (identical(other.lastSync, lastSync) ||
                other.lastSync == lastSync));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, moduleCode, visits, sites, lastSync);

  /// Create a copy of Permission
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PermissionImplCopyWith<_$PermissionImpl> get copyWith =>
      __$$PermissionImplCopyWithImpl<_$PermissionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PermissionImplToJson(
      this,
    );
  }
}

abstract class _Permission implements Permission {
  const factory _Permission(
      {required final String moduleCode,
      required final PermissionLevel visits,
      required final PermissionLevel sites,
      required final DateTime lastSync}) = _$PermissionImpl;

  factory _Permission.fromJson(Map<String, dynamic> json) =
      _$PermissionImpl.fromJson;

  @override
  String get moduleCode;
  @override
  PermissionLevel get visits;
  @override
  PermissionLevel get sites;
  @override
  DateTime get lastSync;

  /// Create a copy of Permission
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PermissionImplCopyWith<_$PermissionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PermissionLevel _$PermissionLevelFromJson(Map<String, dynamic> json) {
  return _PermissionLevel.fromJson(json);
}

/// @nodoc
mixin _$PermissionLevel {
  int get create => throw _privateConstructorUsedError;
  int get read => throw _privateConstructorUsedError;
  int get update => throw _privateConstructorUsedError;
  int get delete => throw _privateConstructorUsedError;

  /// Serializes this PermissionLevel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PermissionLevel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PermissionLevelCopyWith<PermissionLevel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PermissionLevelCopyWith<$Res> {
  factory $PermissionLevelCopyWith(
          PermissionLevel value, $Res Function(PermissionLevel) then) =
      _$PermissionLevelCopyWithImpl<$Res, PermissionLevel>;
  @useResult
  $Res call({int create, int read, int update, int delete});
}

/// @nodoc
class _$PermissionLevelCopyWithImpl<$Res, $Val extends PermissionLevel>
    implements $PermissionLevelCopyWith<$Res> {
  _$PermissionLevelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PermissionLevel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? create = null,
    Object? read = null,
    Object? update = null,
    Object? delete = null,
  }) {
    return _then(_value.copyWith(
      create: null == create
          ? _value.create
          : create // ignore: cast_nullable_to_non_nullable
              as int,
      read: null == read
          ? _value.read
          : read // ignore: cast_nullable_to_non_nullable
              as int,
      update: null == update
          ? _value.update
          : update // ignore: cast_nullable_to_non_nullable
              as int,
      delete: null == delete
          ? _value.delete
          : delete // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PermissionLevelImplCopyWith<$Res>
    implements $PermissionLevelCopyWith<$Res> {
  factory _$$PermissionLevelImplCopyWith(_$PermissionLevelImpl value,
          $Res Function(_$PermissionLevelImpl) then) =
      __$$PermissionLevelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int create, int read, int update, int delete});
}

/// @nodoc
class __$$PermissionLevelImplCopyWithImpl<$Res>
    extends _$PermissionLevelCopyWithImpl<$Res, _$PermissionLevelImpl>
    implements _$$PermissionLevelImplCopyWith<$Res> {
  __$$PermissionLevelImplCopyWithImpl(
      _$PermissionLevelImpl _value, $Res Function(_$PermissionLevelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PermissionLevel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? create = null,
    Object? read = null,
    Object? update = null,
    Object? delete = null,
  }) {
    return _then(_$PermissionLevelImpl(
      create: null == create
          ? _value.create
          : create // ignore: cast_nullable_to_non_nullable
              as int,
      read: null == read
          ? _value.read
          : read // ignore: cast_nullable_to_non_nullable
              as int,
      update: null == update
          ? _value.update
          : update // ignore: cast_nullable_to_non_nullable
              as int,
      delete: null == delete
          ? _value.delete
          : delete // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PermissionLevelImpl implements _PermissionLevel {
  const _$PermissionLevelImpl(
      {this.create = 0, this.read = 0, this.update = 0, this.delete = 0});

  factory _$PermissionLevelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PermissionLevelImplFromJson(json);

  @override
  @JsonKey()
  final int create;
  @override
  @JsonKey()
  final int read;
  @override
  @JsonKey()
  final int update;
  @override
  @JsonKey()
  final int delete;

  @override
  String toString() {
    return 'PermissionLevel(create: $create, read: $read, update: $update, delete: $delete)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PermissionLevelImpl &&
            (identical(other.create, create) || other.create == create) &&
            (identical(other.read, read) || other.read == read) &&
            (identical(other.update, update) || other.update == update) &&
            (identical(other.delete, delete) || other.delete == delete));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, create, read, update, delete);

  /// Create a copy of PermissionLevel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PermissionLevelImplCopyWith<_$PermissionLevelImpl> get copyWith =>
      __$$PermissionLevelImplCopyWithImpl<_$PermissionLevelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PermissionLevelImplToJson(
      this,
    );
  }
}

abstract class _PermissionLevel implements PermissionLevel {
  const factory _PermissionLevel(
      {final int create,
      final int read,
      final int update,
      final int delete}) = _$PermissionLevelImpl;

  factory _PermissionLevel.fromJson(Map<String, dynamic> json) =
      _$PermissionLevelImpl.fromJson;

  @override
  int get create;
  @override
  int get read;
  @override
  int get update;
  @override
  int get delete;

  /// Create a copy of PermissionLevel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PermissionLevelImplCopyWith<_$PermissionLevelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PermissionScope {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function() personal,
    required TResult Function() organization,
    required TResult Function() all,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? none,
    TResult? Function()? personal,
    TResult? Function()? organization,
    TResult? Function()? all,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function()? personal,
    TResult Function()? organization,
    TResult Function()? all,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PermissionScopeNone value) none,
    required TResult Function(_PermissionScopePersonal value) personal,
    required TResult Function(_PermissionScopeOrganization value) organization,
    required TResult Function(_PermissionScopeAll value) all,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PermissionScopeNone value)? none,
    TResult? Function(_PermissionScopePersonal value)? personal,
    TResult? Function(_PermissionScopeOrganization value)? organization,
    TResult? Function(_PermissionScopeAll value)? all,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PermissionScopeNone value)? none,
    TResult Function(_PermissionScopePersonal value)? personal,
    TResult Function(_PermissionScopeOrganization value)? organization,
    TResult Function(_PermissionScopeAll value)? all,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PermissionScopeCopyWith<$Res> {
  factory $PermissionScopeCopyWith(
          PermissionScope value, $Res Function(PermissionScope) then) =
      _$PermissionScopeCopyWithImpl<$Res, PermissionScope>;
}

/// @nodoc
class _$PermissionScopeCopyWithImpl<$Res, $Val extends PermissionScope>
    implements $PermissionScopeCopyWith<$Res> {
  _$PermissionScopeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PermissionScope
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$PermissionScopeNoneImplCopyWith<$Res> {
  factory _$$PermissionScopeNoneImplCopyWith(_$PermissionScopeNoneImpl value,
          $Res Function(_$PermissionScopeNoneImpl) then) =
      __$$PermissionScopeNoneImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PermissionScopeNoneImplCopyWithImpl<$Res>
    extends _$PermissionScopeCopyWithImpl<$Res, _$PermissionScopeNoneImpl>
    implements _$$PermissionScopeNoneImplCopyWith<$Res> {
  __$$PermissionScopeNoneImplCopyWithImpl(_$PermissionScopeNoneImpl _value,
      $Res Function(_$PermissionScopeNoneImpl) _then)
      : super(_value, _then);

  /// Create a copy of PermissionScope
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PermissionScopeNoneImpl implements _PermissionScopeNone {
  const _$PermissionScopeNoneImpl();

  @override
  String toString() {
    return 'PermissionScope.none()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PermissionScopeNoneImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function() personal,
    required TResult Function() organization,
    required TResult Function() all,
  }) {
    return none();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? none,
    TResult? Function()? personal,
    TResult? Function()? organization,
    TResult? Function()? all,
  }) {
    return none?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function()? personal,
    TResult Function()? organization,
    TResult Function()? all,
    required TResult orElse(),
  }) {
    if (none != null) {
      return none();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PermissionScopeNone value) none,
    required TResult Function(_PermissionScopePersonal value) personal,
    required TResult Function(_PermissionScopeOrganization value) organization,
    required TResult Function(_PermissionScopeAll value) all,
  }) {
    return none(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PermissionScopeNone value)? none,
    TResult? Function(_PermissionScopePersonal value)? personal,
    TResult? Function(_PermissionScopeOrganization value)? organization,
    TResult? Function(_PermissionScopeAll value)? all,
  }) {
    return none?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PermissionScopeNone value)? none,
    TResult Function(_PermissionScopePersonal value)? personal,
    TResult Function(_PermissionScopeOrganization value)? organization,
    TResult Function(_PermissionScopeAll value)? all,
    required TResult orElse(),
  }) {
    if (none != null) {
      return none(this);
    }
    return orElse();
  }
}

abstract class _PermissionScopeNone implements PermissionScope {
  const factory _PermissionScopeNone() = _$PermissionScopeNoneImpl;
}

/// @nodoc
abstract class _$$PermissionScopePersonalImplCopyWith<$Res> {
  factory _$$PermissionScopePersonalImplCopyWith(
          _$PermissionScopePersonalImpl value,
          $Res Function(_$PermissionScopePersonalImpl) then) =
      __$$PermissionScopePersonalImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PermissionScopePersonalImplCopyWithImpl<$Res>
    extends _$PermissionScopeCopyWithImpl<$Res, _$PermissionScopePersonalImpl>
    implements _$$PermissionScopePersonalImplCopyWith<$Res> {
  __$$PermissionScopePersonalImplCopyWithImpl(
      _$PermissionScopePersonalImpl _value,
      $Res Function(_$PermissionScopePersonalImpl) _then)
      : super(_value, _then);

  /// Create a copy of PermissionScope
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PermissionScopePersonalImpl implements _PermissionScopePersonal {
  const _$PermissionScopePersonalImpl();

  @override
  String toString() {
    return 'PermissionScope.personal()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PermissionScopePersonalImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function() personal,
    required TResult Function() organization,
    required TResult Function() all,
  }) {
    return personal();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? none,
    TResult? Function()? personal,
    TResult? Function()? organization,
    TResult? Function()? all,
  }) {
    return personal?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function()? personal,
    TResult Function()? organization,
    TResult Function()? all,
    required TResult orElse(),
  }) {
    if (personal != null) {
      return personal();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PermissionScopeNone value) none,
    required TResult Function(_PermissionScopePersonal value) personal,
    required TResult Function(_PermissionScopeOrganization value) organization,
    required TResult Function(_PermissionScopeAll value) all,
  }) {
    return personal(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PermissionScopeNone value)? none,
    TResult? Function(_PermissionScopePersonal value)? personal,
    TResult? Function(_PermissionScopeOrganization value)? organization,
    TResult? Function(_PermissionScopeAll value)? all,
  }) {
    return personal?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PermissionScopeNone value)? none,
    TResult Function(_PermissionScopePersonal value)? personal,
    TResult Function(_PermissionScopeOrganization value)? organization,
    TResult Function(_PermissionScopeAll value)? all,
    required TResult orElse(),
  }) {
    if (personal != null) {
      return personal(this);
    }
    return orElse();
  }
}

abstract class _PermissionScopePersonal implements PermissionScope {
  const factory _PermissionScopePersonal() = _$PermissionScopePersonalImpl;
}

/// @nodoc
abstract class _$$PermissionScopeOrganizationImplCopyWith<$Res> {
  factory _$$PermissionScopeOrganizationImplCopyWith(
          _$PermissionScopeOrganizationImpl value,
          $Res Function(_$PermissionScopeOrganizationImpl) then) =
      __$$PermissionScopeOrganizationImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PermissionScopeOrganizationImplCopyWithImpl<$Res>
    extends _$PermissionScopeCopyWithImpl<$Res,
        _$PermissionScopeOrganizationImpl>
    implements _$$PermissionScopeOrganizationImplCopyWith<$Res> {
  __$$PermissionScopeOrganizationImplCopyWithImpl(
      _$PermissionScopeOrganizationImpl _value,
      $Res Function(_$PermissionScopeOrganizationImpl) _then)
      : super(_value, _then);

  /// Create a copy of PermissionScope
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PermissionScopeOrganizationImpl
    implements _PermissionScopeOrganization {
  const _$PermissionScopeOrganizationImpl();

  @override
  String toString() {
    return 'PermissionScope.organization()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PermissionScopeOrganizationImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function() personal,
    required TResult Function() organization,
    required TResult Function() all,
  }) {
    return organization();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? none,
    TResult? Function()? personal,
    TResult? Function()? organization,
    TResult? Function()? all,
  }) {
    return organization?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function()? personal,
    TResult Function()? organization,
    TResult Function()? all,
    required TResult orElse(),
  }) {
    if (organization != null) {
      return organization();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PermissionScopeNone value) none,
    required TResult Function(_PermissionScopePersonal value) personal,
    required TResult Function(_PermissionScopeOrganization value) organization,
    required TResult Function(_PermissionScopeAll value) all,
  }) {
    return organization(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PermissionScopeNone value)? none,
    TResult? Function(_PermissionScopePersonal value)? personal,
    TResult? Function(_PermissionScopeOrganization value)? organization,
    TResult? Function(_PermissionScopeAll value)? all,
  }) {
    return organization?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PermissionScopeNone value)? none,
    TResult Function(_PermissionScopePersonal value)? personal,
    TResult Function(_PermissionScopeOrganization value)? organization,
    TResult Function(_PermissionScopeAll value)? all,
    required TResult orElse(),
  }) {
    if (organization != null) {
      return organization(this);
    }
    return orElse();
  }
}

abstract class _PermissionScopeOrganization implements PermissionScope {
  const factory _PermissionScopeOrganization() =
      _$PermissionScopeOrganizationImpl;
}

/// @nodoc
abstract class _$$PermissionScopeAllImplCopyWith<$Res> {
  factory _$$PermissionScopeAllImplCopyWith(_$PermissionScopeAllImpl value,
          $Res Function(_$PermissionScopeAllImpl) then) =
      __$$PermissionScopeAllImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PermissionScopeAllImplCopyWithImpl<$Res>
    extends _$PermissionScopeCopyWithImpl<$Res, _$PermissionScopeAllImpl>
    implements _$$PermissionScopeAllImplCopyWith<$Res> {
  __$$PermissionScopeAllImplCopyWithImpl(_$PermissionScopeAllImpl _value,
      $Res Function(_$PermissionScopeAllImpl) _then)
      : super(_value, _then);

  /// Create a copy of PermissionScope
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PermissionScopeAllImpl implements _PermissionScopeAll {
  const _$PermissionScopeAllImpl();

  @override
  String toString() {
    return 'PermissionScope.all()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PermissionScopeAllImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function() personal,
    required TResult Function() organization,
    required TResult Function() all,
  }) {
    return all();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? none,
    TResult? Function()? personal,
    TResult? Function()? organization,
    TResult? Function()? all,
  }) {
    return all?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function()? personal,
    TResult Function()? organization,
    TResult Function()? all,
    required TResult orElse(),
  }) {
    if (all != null) {
      return all();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_PermissionScopeNone value) none,
    required TResult Function(_PermissionScopePersonal value) personal,
    required TResult Function(_PermissionScopeOrganization value) organization,
    required TResult Function(_PermissionScopeAll value) all,
  }) {
    return all(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PermissionScopeNone value)? none,
    TResult? Function(_PermissionScopePersonal value)? personal,
    TResult? Function(_PermissionScopeOrganization value)? organization,
    TResult? Function(_PermissionScopeAll value)? all,
  }) {
    return all?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PermissionScopeNone value)? none,
    TResult Function(_PermissionScopePersonal value)? personal,
    TResult Function(_PermissionScopeOrganization value)? organization,
    TResult Function(_PermissionScopeAll value)? all,
    required TResult orElse(),
  }) {
    if (all != null) {
      return all(this);
    }
    return orElse();
  }
}

abstract class _PermissionScopeAll implements PermissionScope {
  const factory _PermissionScopeAll() = _$PermissionScopeAllImpl;
}
