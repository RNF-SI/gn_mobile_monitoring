// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_permissions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserPermissions _$UserPermissionsFromJson(Map<String, dynamic> json) {
  return _UserPermissions.fromJson(json);
}

/// @nodoc
mixin _$UserPermissions {
  int get idRole => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  int? get idOrganisme =>
      throw _privateConstructorUsedError; // Permissions CRUVED par objet du monitoring - correspond aux patterns web
  CruvedResponse get monitoringModules =>
      throw _privateConstructorUsedError; // MONITORINGS_MODULES
  CruvedResponse get monitoringSites =>
      throw _privateConstructorUsedError; // MONITORINGS_SITES
  CruvedResponse get monitoringGrpSites =>
      throw _privateConstructorUsedError; // MONITORINGS_GRP_SITES
  CruvedResponse get monitoringVisites =>
      throw _privateConstructorUsedError; // MONITORINGS_VISITES
  CruvedResponse get monitoringIndividuals =>
      throw _privateConstructorUsedError; // MONITORINGS_INDIVIDUALS
  CruvedResponse get monitoringMarkings =>
      throw _privateConstructorUsedError; // MONITORINGS_MARKINGS
  bool get isConnected => throw _privateConstructorUsedError;

  /// Serializes this UserPermissions to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserPermissions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserPermissionsCopyWith<UserPermissions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPermissionsCopyWith<$Res> {
  factory $UserPermissionsCopyWith(
          UserPermissions value, $Res Function(UserPermissions) then) =
      _$UserPermissionsCopyWithImpl<$Res, UserPermissions>;
  @useResult
  $Res call(
      {int idRole,
      String username,
      int? idOrganisme,
      CruvedResponse monitoringModules,
      CruvedResponse monitoringSites,
      CruvedResponse monitoringGrpSites,
      CruvedResponse monitoringVisites,
      CruvedResponse monitoringIndividuals,
      CruvedResponse monitoringMarkings,
      bool isConnected});

  $CruvedResponseCopyWith<$Res> get monitoringModules;
  $CruvedResponseCopyWith<$Res> get monitoringSites;
  $CruvedResponseCopyWith<$Res> get monitoringGrpSites;
  $CruvedResponseCopyWith<$Res> get monitoringVisites;
  $CruvedResponseCopyWith<$Res> get monitoringIndividuals;
  $CruvedResponseCopyWith<$Res> get monitoringMarkings;
}

/// @nodoc
class _$UserPermissionsCopyWithImpl<$Res, $Val extends UserPermissions>
    implements $UserPermissionsCopyWith<$Res> {
  _$UserPermissionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserPermissions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idRole = null,
    Object? username = null,
    Object? idOrganisme = freezed,
    Object? monitoringModules = null,
    Object? monitoringSites = null,
    Object? monitoringGrpSites = null,
    Object? monitoringVisites = null,
    Object? monitoringIndividuals = null,
    Object? monitoringMarkings = null,
    Object? isConnected = null,
  }) {
    return _then(_value.copyWith(
      idRole: null == idRole
          ? _value.idRole
          : idRole // ignore: cast_nullable_to_non_nullable
              as int,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      idOrganisme: freezed == idOrganisme
          ? _value.idOrganisme
          : idOrganisme // ignore: cast_nullable_to_non_nullable
              as int?,
      monitoringModules: null == monitoringModules
          ? _value.monitoringModules
          : monitoringModules // ignore: cast_nullable_to_non_nullable
              as CruvedResponse,
      monitoringSites: null == monitoringSites
          ? _value.monitoringSites
          : monitoringSites // ignore: cast_nullable_to_non_nullable
              as CruvedResponse,
      monitoringGrpSites: null == monitoringGrpSites
          ? _value.monitoringGrpSites
          : monitoringGrpSites // ignore: cast_nullable_to_non_nullable
              as CruvedResponse,
      monitoringVisites: null == monitoringVisites
          ? _value.monitoringVisites
          : monitoringVisites // ignore: cast_nullable_to_non_nullable
              as CruvedResponse,
      monitoringIndividuals: null == monitoringIndividuals
          ? _value.monitoringIndividuals
          : monitoringIndividuals // ignore: cast_nullable_to_non_nullable
              as CruvedResponse,
      monitoringMarkings: null == monitoringMarkings
          ? _value.monitoringMarkings
          : monitoringMarkings // ignore: cast_nullable_to_non_nullable
              as CruvedResponse,
      isConnected: null == isConnected
          ? _value.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of UserPermissions
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CruvedResponseCopyWith<$Res> get monitoringModules {
    return $CruvedResponseCopyWith<$Res>(_value.monitoringModules, (value) {
      return _then(_value.copyWith(monitoringModules: value) as $Val);
    });
  }

  /// Create a copy of UserPermissions
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CruvedResponseCopyWith<$Res> get monitoringSites {
    return $CruvedResponseCopyWith<$Res>(_value.monitoringSites, (value) {
      return _then(_value.copyWith(monitoringSites: value) as $Val);
    });
  }

  /// Create a copy of UserPermissions
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CruvedResponseCopyWith<$Res> get monitoringGrpSites {
    return $CruvedResponseCopyWith<$Res>(_value.monitoringGrpSites, (value) {
      return _then(_value.copyWith(monitoringGrpSites: value) as $Val);
    });
  }

  /// Create a copy of UserPermissions
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CruvedResponseCopyWith<$Res> get monitoringVisites {
    return $CruvedResponseCopyWith<$Res>(_value.monitoringVisites, (value) {
      return _then(_value.copyWith(monitoringVisites: value) as $Val);
    });
  }

  /// Create a copy of UserPermissions
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CruvedResponseCopyWith<$Res> get monitoringIndividuals {
    return $CruvedResponseCopyWith<$Res>(_value.monitoringIndividuals, (value) {
      return _then(_value.copyWith(monitoringIndividuals: value) as $Val);
    });
  }

  /// Create a copy of UserPermissions
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CruvedResponseCopyWith<$Res> get monitoringMarkings {
    return $CruvedResponseCopyWith<$Res>(_value.monitoringMarkings, (value) {
      return _then(_value.copyWith(monitoringMarkings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserPermissionsImplCopyWith<$Res>
    implements $UserPermissionsCopyWith<$Res> {
  factory _$$UserPermissionsImplCopyWith(_$UserPermissionsImpl value,
          $Res Function(_$UserPermissionsImpl) then) =
      __$$UserPermissionsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int idRole,
      String username,
      int? idOrganisme,
      CruvedResponse monitoringModules,
      CruvedResponse monitoringSites,
      CruvedResponse monitoringGrpSites,
      CruvedResponse monitoringVisites,
      CruvedResponse monitoringIndividuals,
      CruvedResponse monitoringMarkings,
      bool isConnected});

  @override
  $CruvedResponseCopyWith<$Res> get monitoringModules;
  @override
  $CruvedResponseCopyWith<$Res> get monitoringSites;
  @override
  $CruvedResponseCopyWith<$Res> get monitoringGrpSites;
  @override
  $CruvedResponseCopyWith<$Res> get monitoringVisites;
  @override
  $CruvedResponseCopyWith<$Res> get monitoringIndividuals;
  @override
  $CruvedResponseCopyWith<$Res> get monitoringMarkings;
}

/// @nodoc
class __$$UserPermissionsImplCopyWithImpl<$Res>
    extends _$UserPermissionsCopyWithImpl<$Res, _$UserPermissionsImpl>
    implements _$$UserPermissionsImplCopyWith<$Res> {
  __$$UserPermissionsImplCopyWithImpl(
      _$UserPermissionsImpl _value, $Res Function(_$UserPermissionsImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserPermissions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idRole = null,
    Object? username = null,
    Object? idOrganisme = freezed,
    Object? monitoringModules = null,
    Object? monitoringSites = null,
    Object? monitoringGrpSites = null,
    Object? monitoringVisites = null,
    Object? monitoringIndividuals = null,
    Object? monitoringMarkings = null,
    Object? isConnected = null,
  }) {
    return _then(_$UserPermissionsImpl(
      idRole: null == idRole
          ? _value.idRole
          : idRole // ignore: cast_nullable_to_non_nullable
              as int,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      idOrganisme: freezed == idOrganisme
          ? _value.idOrganisme
          : idOrganisme // ignore: cast_nullable_to_non_nullable
              as int?,
      monitoringModules: null == monitoringModules
          ? _value.monitoringModules
          : monitoringModules // ignore: cast_nullable_to_non_nullable
              as CruvedResponse,
      monitoringSites: null == monitoringSites
          ? _value.monitoringSites
          : monitoringSites // ignore: cast_nullable_to_non_nullable
              as CruvedResponse,
      monitoringGrpSites: null == monitoringGrpSites
          ? _value.monitoringGrpSites
          : monitoringGrpSites // ignore: cast_nullable_to_non_nullable
              as CruvedResponse,
      monitoringVisites: null == monitoringVisites
          ? _value.monitoringVisites
          : monitoringVisites // ignore: cast_nullable_to_non_nullable
              as CruvedResponse,
      monitoringIndividuals: null == monitoringIndividuals
          ? _value.monitoringIndividuals
          : monitoringIndividuals // ignore: cast_nullable_to_non_nullable
              as CruvedResponse,
      monitoringMarkings: null == monitoringMarkings
          ? _value.monitoringMarkings
          : monitoringMarkings // ignore: cast_nullable_to_non_nullable
              as CruvedResponse,
      isConnected: null == isConnected
          ? _value.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserPermissionsImpl implements _UserPermissions {
  const _$UserPermissionsImpl(
      {required this.idRole,
      required this.username,
      required this.idOrganisme,
      required this.monitoringModules,
      required this.monitoringSites,
      required this.monitoringGrpSites,
      required this.monitoringVisites,
      required this.monitoringIndividuals,
      required this.monitoringMarkings,
      this.isConnected = false});

  factory _$UserPermissionsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserPermissionsImplFromJson(json);

  @override
  final int idRole;
  @override
  final String username;
  @override
  final int? idOrganisme;
// Permissions CRUVED par objet du monitoring - correspond aux patterns web
  @override
  final CruvedResponse monitoringModules;
// MONITORINGS_MODULES
  @override
  final CruvedResponse monitoringSites;
// MONITORINGS_SITES
  @override
  final CruvedResponse monitoringGrpSites;
// MONITORINGS_GRP_SITES
  @override
  final CruvedResponse monitoringVisites;
// MONITORINGS_VISITES
  @override
  final CruvedResponse monitoringIndividuals;
// MONITORINGS_INDIVIDUALS
  @override
  final CruvedResponse monitoringMarkings;
// MONITORINGS_MARKINGS
  @override
  @JsonKey()
  final bool isConnected;

  @override
  String toString() {
    return 'UserPermissions(idRole: $idRole, username: $username, idOrganisme: $idOrganisme, monitoringModules: $monitoringModules, monitoringSites: $monitoringSites, monitoringGrpSites: $monitoringGrpSites, monitoringVisites: $monitoringVisites, monitoringIndividuals: $monitoringIndividuals, monitoringMarkings: $monitoringMarkings, isConnected: $isConnected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPermissionsImpl &&
            (identical(other.idRole, idRole) || other.idRole == idRole) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.idOrganisme, idOrganisme) ||
                other.idOrganisme == idOrganisme) &&
            (identical(other.monitoringModules, monitoringModules) ||
                other.monitoringModules == monitoringModules) &&
            (identical(other.monitoringSites, monitoringSites) ||
                other.monitoringSites == monitoringSites) &&
            (identical(other.monitoringGrpSites, monitoringGrpSites) ||
                other.monitoringGrpSites == monitoringGrpSites) &&
            (identical(other.monitoringVisites, monitoringVisites) ||
                other.monitoringVisites == monitoringVisites) &&
            (identical(other.monitoringIndividuals, monitoringIndividuals) ||
                other.monitoringIndividuals == monitoringIndividuals) &&
            (identical(other.monitoringMarkings, monitoringMarkings) ||
                other.monitoringMarkings == monitoringMarkings) &&
            (identical(other.isConnected, isConnected) ||
                other.isConnected == isConnected));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      idRole,
      username,
      idOrganisme,
      monitoringModules,
      monitoringSites,
      monitoringGrpSites,
      monitoringVisites,
      monitoringIndividuals,
      monitoringMarkings,
      isConnected);

  /// Create a copy of UserPermissions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPermissionsImplCopyWith<_$UserPermissionsImpl> get copyWith =>
      __$$UserPermissionsImplCopyWithImpl<_$UserPermissionsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserPermissionsImplToJson(
      this,
    );
  }
}

abstract class _UserPermissions implements UserPermissions {
  const factory _UserPermissions(
      {required final int idRole,
      required final String username,
      required final int? idOrganisme,
      required final CruvedResponse monitoringModules,
      required final CruvedResponse monitoringSites,
      required final CruvedResponse monitoringGrpSites,
      required final CruvedResponse monitoringVisites,
      required final CruvedResponse monitoringIndividuals,
      required final CruvedResponse monitoringMarkings,
      final bool isConnected}) = _$UserPermissionsImpl;

  factory _UserPermissions.fromJson(Map<String, dynamic> json) =
      _$UserPermissionsImpl.fromJson;

  @override
  int get idRole;
  @override
  String get username;
  @override
  int?
      get idOrganisme; // Permissions CRUVED par objet du monitoring - correspond aux patterns web
  @override
  CruvedResponse get monitoringModules; // MONITORINGS_MODULES
  @override
  CruvedResponse get monitoringSites; // MONITORINGS_SITES
  @override
  CruvedResponse get monitoringGrpSites; // MONITORINGS_GRP_SITES
  @override
  CruvedResponse get monitoringVisites; // MONITORINGS_VISITES
  @override
  CruvedResponse get monitoringIndividuals; // MONITORINGS_INDIVIDUALS
  @override
  CruvedResponse get monitoringMarkings; // MONITORINGS_MARKINGS
  @override
  bool get isConnected;

  /// Create a copy of UserPermissions
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserPermissionsImplCopyWith<_$UserPermissionsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
