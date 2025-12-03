// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_role.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserRole _$UserRoleFromJson(Map<String, dynamic> json) {
  return _UserRole.fromJson(json);
}

/// @nodoc
mixin _$UserRole {
  int get idRole => throw _privateConstructorUsedError;
  String get identifiant => throw _privateConstructorUsedError;
  String get nomRole => throw _privateConstructorUsedError;
  String get prenomRole => throw _privateConstructorUsedError;
  int? get idOrganisme => throw _privateConstructorUsedError;
  bool get active => throw _privateConstructorUsedError;

  /// Serializes this UserRole to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserRole
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserRoleCopyWith<UserRole> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserRoleCopyWith<$Res> {
  factory $UserRoleCopyWith(UserRole value, $Res Function(UserRole) then) =
      _$UserRoleCopyWithImpl<$Res, UserRole>;
  @useResult
  $Res call(
      {int idRole,
      String identifiant,
      String nomRole,
      String prenomRole,
      int? idOrganisme,
      bool active});
}

/// @nodoc
class _$UserRoleCopyWithImpl<$Res, $Val extends UserRole>
    implements $UserRoleCopyWith<$Res> {
  _$UserRoleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserRole
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idRole = null,
    Object? identifiant = null,
    Object? nomRole = null,
    Object? prenomRole = null,
    Object? idOrganisme = freezed,
    Object? active = null,
  }) {
    return _then(_value.copyWith(
      idRole: null == idRole
          ? _value.idRole
          : idRole // ignore: cast_nullable_to_non_nullable
              as int,
      identifiant: null == identifiant
          ? _value.identifiant
          : identifiant // ignore: cast_nullable_to_non_nullable
              as String,
      nomRole: null == nomRole
          ? _value.nomRole
          : nomRole // ignore: cast_nullable_to_non_nullable
              as String,
      prenomRole: null == prenomRole
          ? _value.prenomRole
          : prenomRole // ignore: cast_nullable_to_non_nullable
              as String,
      idOrganisme: freezed == idOrganisme
          ? _value.idOrganisme
          : idOrganisme // ignore: cast_nullable_to_non_nullable
              as int?,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserRoleImplCopyWith<$Res>
    implements $UserRoleCopyWith<$Res> {
  factory _$$UserRoleImplCopyWith(
          _$UserRoleImpl value, $Res Function(_$UserRoleImpl) then) =
      __$$UserRoleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int idRole,
      String identifiant,
      String nomRole,
      String prenomRole,
      int? idOrganisme,
      bool active});
}

/// @nodoc
class __$$UserRoleImplCopyWithImpl<$Res>
    extends _$UserRoleCopyWithImpl<$Res, _$UserRoleImpl>
    implements _$$UserRoleImplCopyWith<$Res> {
  __$$UserRoleImplCopyWithImpl(
      _$UserRoleImpl _value, $Res Function(_$UserRoleImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserRole
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idRole = null,
    Object? identifiant = null,
    Object? nomRole = null,
    Object? prenomRole = null,
    Object? idOrganisme = freezed,
    Object? active = null,
  }) {
    return _then(_$UserRoleImpl(
      idRole: null == idRole
          ? _value.idRole
          : idRole // ignore: cast_nullable_to_non_nullable
              as int,
      identifiant: null == identifiant
          ? _value.identifiant
          : identifiant // ignore: cast_nullable_to_non_nullable
              as String,
      nomRole: null == nomRole
          ? _value.nomRole
          : nomRole // ignore: cast_nullable_to_non_nullable
              as String,
      prenomRole: null == prenomRole
          ? _value.prenomRole
          : prenomRole // ignore: cast_nullable_to_non_nullable
              as String,
      idOrganisme: freezed == idOrganisme
          ? _value.idOrganisme
          : idOrganisme // ignore: cast_nullable_to_non_nullable
              as int?,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserRoleImpl implements _UserRole {
  const _$UserRoleImpl(
      {required this.idRole,
      required this.identifiant,
      required this.nomRole,
      required this.prenomRole,
      this.idOrganisme,
      this.active = true});

  factory _$UserRoleImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserRoleImplFromJson(json);

  @override
  final int idRole;
  @override
  final String identifiant;
  @override
  final String nomRole;
  @override
  final String prenomRole;
  @override
  final int? idOrganisme;
  @override
  @JsonKey()
  final bool active;

  @override
  String toString() {
    return 'UserRole(idRole: $idRole, identifiant: $identifiant, nomRole: $nomRole, prenomRole: $prenomRole, idOrganisme: $idOrganisme, active: $active)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserRoleImpl &&
            (identical(other.idRole, idRole) || other.idRole == idRole) &&
            (identical(other.identifiant, identifiant) ||
                other.identifiant == identifiant) &&
            (identical(other.nomRole, nomRole) || other.nomRole == nomRole) &&
            (identical(other.prenomRole, prenomRole) ||
                other.prenomRole == prenomRole) &&
            (identical(other.idOrganisme, idOrganisme) ||
                other.idOrganisme == idOrganisme) &&
            (identical(other.active, active) || other.active == active));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, idRole, identifiant, nomRole,
      prenomRole, idOrganisme, active);

  /// Create a copy of UserRole
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserRoleImplCopyWith<_$UserRoleImpl> get copyWith =>
      __$$UserRoleImplCopyWithImpl<_$UserRoleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserRoleImplToJson(
      this,
    );
  }
}

abstract class _UserRole implements UserRole {
  const factory _UserRole(
      {required final int idRole,
      required final String identifiant,
      required final String nomRole,
      required final String prenomRole,
      final int? idOrganisme,
      final bool active}) = _$UserRoleImpl;

  factory _UserRole.fromJson(Map<String, dynamic> json) =
      _$UserRoleImpl.fromJson;

  @override
  int get idRole;
  @override
  String get identifiant;
  @override
  String get nomRole;
  @override
  String get prenomRole;
  @override
  int? get idOrganisme;
  @override
  bool get active;

  /// Create a copy of UserRole
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserRoleImplCopyWith<_$UserRoleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
