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
  int get idPermission => throw _privateConstructorUsedError;
  int get idRole => throw _privateConstructorUsedError;
  int get idAction => throw _privateConstructorUsedError;
  int get idModule => throw _privateConstructorUsedError;
  int get idObject => throw _privateConstructorUsedError;
  int? get scopeValue => throw _privateConstructorUsedError;
  bool get sensitivityFilter => throw _privateConstructorUsedError;

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
      {int idPermission,
      int idRole,
      int idAction,
      int idModule,
      int idObject,
      int? scopeValue,
      bool sensitivityFilter});
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
    Object? idPermission = null,
    Object? idRole = null,
    Object? idAction = null,
    Object? idModule = null,
    Object? idObject = null,
    Object? scopeValue = freezed,
    Object? sensitivityFilter = null,
  }) {
    return _then(_value.copyWith(
      idPermission: null == idPermission
          ? _value.idPermission
          : idPermission // ignore: cast_nullable_to_non_nullable
              as int,
      idRole: null == idRole
          ? _value.idRole
          : idRole // ignore: cast_nullable_to_non_nullable
              as int,
      idAction: null == idAction
          ? _value.idAction
          : idAction // ignore: cast_nullable_to_non_nullable
              as int,
      idModule: null == idModule
          ? _value.idModule
          : idModule // ignore: cast_nullable_to_non_nullable
              as int,
      idObject: null == idObject
          ? _value.idObject
          : idObject // ignore: cast_nullable_to_non_nullable
              as int,
      scopeValue: freezed == scopeValue
          ? _value.scopeValue
          : scopeValue // ignore: cast_nullable_to_non_nullable
              as int?,
      sensitivityFilter: null == sensitivityFilter
          ? _value.sensitivityFilter
          : sensitivityFilter // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
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
      {int idPermission,
      int idRole,
      int idAction,
      int idModule,
      int idObject,
      int? scopeValue,
      bool sensitivityFilter});
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
    Object? idPermission = null,
    Object? idRole = null,
    Object? idAction = null,
    Object? idModule = null,
    Object? idObject = null,
    Object? scopeValue = freezed,
    Object? sensitivityFilter = null,
  }) {
    return _then(_$PermissionImpl(
      idPermission: null == idPermission
          ? _value.idPermission
          : idPermission // ignore: cast_nullable_to_non_nullable
              as int,
      idRole: null == idRole
          ? _value.idRole
          : idRole // ignore: cast_nullable_to_non_nullable
              as int,
      idAction: null == idAction
          ? _value.idAction
          : idAction // ignore: cast_nullable_to_non_nullable
              as int,
      idModule: null == idModule
          ? _value.idModule
          : idModule // ignore: cast_nullable_to_non_nullable
              as int,
      idObject: null == idObject
          ? _value.idObject
          : idObject // ignore: cast_nullable_to_non_nullable
              as int,
      scopeValue: freezed == scopeValue
          ? _value.scopeValue
          : scopeValue // ignore: cast_nullable_to_non_nullable
              as int?,
      sensitivityFilter: null == sensitivityFilter
          ? _value.sensitivityFilter
          : sensitivityFilter // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PermissionImpl implements _Permission {
  const _$PermissionImpl(
      {required this.idPermission,
      required this.idRole,
      required this.idAction,
      required this.idModule,
      required this.idObject,
      this.scopeValue,
      this.sensitivityFilter = false});

  factory _$PermissionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PermissionImplFromJson(json);

  @override
  final int idPermission;
  @override
  final int idRole;
  @override
  final int idAction;
  @override
  final int idModule;
  @override
  final int idObject;
  @override
  final int? scopeValue;
  @override
  @JsonKey()
  final bool sensitivityFilter;

  @override
  String toString() {
    return 'Permission(idPermission: $idPermission, idRole: $idRole, idAction: $idAction, idModule: $idModule, idObject: $idObject, scopeValue: $scopeValue, sensitivityFilter: $sensitivityFilter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PermissionImpl &&
            (identical(other.idPermission, idPermission) ||
                other.idPermission == idPermission) &&
            (identical(other.idRole, idRole) || other.idRole == idRole) &&
            (identical(other.idAction, idAction) ||
                other.idAction == idAction) &&
            (identical(other.idModule, idModule) ||
                other.idModule == idModule) &&
            (identical(other.idObject, idObject) ||
                other.idObject == idObject) &&
            (identical(other.scopeValue, scopeValue) ||
                other.scopeValue == scopeValue) &&
            (identical(other.sensitivityFilter, sensitivityFilter) ||
                other.sensitivityFilter == sensitivityFilter));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, idPermission, idRole, idAction,
      idModule, idObject, scopeValue, sensitivityFilter);

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
      {required final int idPermission,
      required final int idRole,
      required final int idAction,
      required final int idModule,
      required final int idObject,
      final int? scopeValue,
      final bool sensitivityFilter}) = _$PermissionImpl;

  factory _Permission.fromJson(Map<String, dynamic> json) =
      _$PermissionImpl.fromJson;

  @override
  int get idPermission;
  @override
  int get idRole;
  @override
  int get idAction;
  @override
  int get idModule;
  @override
  int get idObject;
  @override
  int? get scopeValue;
  @override
  bool get sensitivityFilter;

  /// Create a copy of Permission
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PermissionImplCopyWith<_$PermissionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PermissionObject _$PermissionObjectFromJson(Map<String, dynamic> json) {
  return _PermissionObject.fromJson(json);
}

/// @nodoc
mixin _$PermissionObject {
  int get idObject => throw _privateConstructorUsedError;
  String get codeObject => throw _privateConstructorUsedError;
  String? get descriptionObject => throw _privateConstructorUsedError;

  /// Serializes this PermissionObject to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PermissionObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PermissionObjectCopyWith<PermissionObject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PermissionObjectCopyWith<$Res> {
  factory $PermissionObjectCopyWith(
          PermissionObject value, $Res Function(PermissionObject) then) =
      _$PermissionObjectCopyWithImpl<$Res, PermissionObject>;
  @useResult
  $Res call({int idObject, String codeObject, String? descriptionObject});
}

/// @nodoc
class _$PermissionObjectCopyWithImpl<$Res, $Val extends PermissionObject>
    implements $PermissionObjectCopyWith<$Res> {
  _$PermissionObjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PermissionObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idObject = null,
    Object? codeObject = null,
    Object? descriptionObject = freezed,
  }) {
    return _then(_value.copyWith(
      idObject: null == idObject
          ? _value.idObject
          : idObject // ignore: cast_nullable_to_non_nullable
              as int,
      codeObject: null == codeObject
          ? _value.codeObject
          : codeObject // ignore: cast_nullable_to_non_nullable
              as String,
      descriptionObject: freezed == descriptionObject
          ? _value.descriptionObject
          : descriptionObject // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PermissionObjectImplCopyWith<$Res>
    implements $PermissionObjectCopyWith<$Res> {
  factory _$$PermissionObjectImplCopyWith(_$PermissionObjectImpl value,
          $Res Function(_$PermissionObjectImpl) then) =
      __$$PermissionObjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int idObject, String codeObject, String? descriptionObject});
}

/// @nodoc
class __$$PermissionObjectImplCopyWithImpl<$Res>
    extends _$PermissionObjectCopyWithImpl<$Res, _$PermissionObjectImpl>
    implements _$$PermissionObjectImplCopyWith<$Res> {
  __$$PermissionObjectImplCopyWithImpl(_$PermissionObjectImpl _value,
      $Res Function(_$PermissionObjectImpl) _then)
      : super(_value, _then);

  /// Create a copy of PermissionObject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idObject = null,
    Object? codeObject = null,
    Object? descriptionObject = freezed,
  }) {
    return _then(_$PermissionObjectImpl(
      idObject: null == idObject
          ? _value.idObject
          : idObject // ignore: cast_nullable_to_non_nullable
              as int,
      codeObject: null == codeObject
          ? _value.codeObject
          : codeObject // ignore: cast_nullable_to_non_nullable
              as String,
      descriptionObject: freezed == descriptionObject
          ? _value.descriptionObject
          : descriptionObject // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PermissionObjectImpl implements _PermissionObject {
  const _$PermissionObjectImpl(
      {required this.idObject,
      required this.codeObject,
      this.descriptionObject});

  factory _$PermissionObjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$PermissionObjectImplFromJson(json);

  @override
  final int idObject;
  @override
  final String codeObject;
  @override
  final String? descriptionObject;

  @override
  String toString() {
    return 'PermissionObject(idObject: $idObject, codeObject: $codeObject, descriptionObject: $descriptionObject)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PermissionObjectImpl &&
            (identical(other.idObject, idObject) ||
                other.idObject == idObject) &&
            (identical(other.codeObject, codeObject) ||
                other.codeObject == codeObject) &&
            (identical(other.descriptionObject, descriptionObject) ||
                other.descriptionObject == descriptionObject));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, idObject, codeObject, descriptionObject);

  /// Create a copy of PermissionObject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PermissionObjectImplCopyWith<_$PermissionObjectImpl> get copyWith =>
      __$$PermissionObjectImplCopyWithImpl<_$PermissionObjectImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PermissionObjectImplToJson(
      this,
    );
  }
}

abstract class _PermissionObject implements PermissionObject {
  const factory _PermissionObject(
      {required final int idObject,
      required final String codeObject,
      final String? descriptionObject}) = _$PermissionObjectImpl;

  factory _PermissionObject.fromJson(Map<String, dynamic> json) =
      _$PermissionObjectImpl.fromJson;

  @override
  int get idObject;
  @override
  String get codeObject;
  @override
  String? get descriptionObject;

  /// Create a copy of PermissionObject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PermissionObjectImplCopyWith<_$PermissionObjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PermissionAction _$PermissionActionFromJson(Map<String, dynamic> json) {
  return _PermissionAction.fromJson(json);
}

/// @nodoc
mixin _$PermissionAction {
  int get idAction => throw _privateConstructorUsedError;
  String? get codeAction => throw _privateConstructorUsedError;
  String? get descriptionAction => throw _privateConstructorUsedError;

  /// Serializes this PermissionAction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PermissionAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PermissionActionCopyWith<PermissionAction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PermissionActionCopyWith<$Res> {
  factory $PermissionActionCopyWith(
          PermissionAction value, $Res Function(PermissionAction) then) =
      _$PermissionActionCopyWithImpl<$Res, PermissionAction>;
  @useResult
  $Res call({int idAction, String? codeAction, String? descriptionAction});
}

/// @nodoc
class _$PermissionActionCopyWithImpl<$Res, $Val extends PermissionAction>
    implements $PermissionActionCopyWith<$Res> {
  _$PermissionActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PermissionAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idAction = null,
    Object? codeAction = freezed,
    Object? descriptionAction = freezed,
  }) {
    return _then(_value.copyWith(
      idAction: null == idAction
          ? _value.idAction
          : idAction // ignore: cast_nullable_to_non_nullable
              as int,
      codeAction: freezed == codeAction
          ? _value.codeAction
          : codeAction // ignore: cast_nullable_to_non_nullable
              as String?,
      descriptionAction: freezed == descriptionAction
          ? _value.descriptionAction
          : descriptionAction // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PermissionActionImplCopyWith<$Res>
    implements $PermissionActionCopyWith<$Res> {
  factory _$$PermissionActionImplCopyWith(_$PermissionActionImpl value,
          $Res Function(_$PermissionActionImpl) then) =
      __$$PermissionActionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int idAction, String? codeAction, String? descriptionAction});
}

/// @nodoc
class __$$PermissionActionImplCopyWithImpl<$Res>
    extends _$PermissionActionCopyWithImpl<$Res, _$PermissionActionImpl>
    implements _$$PermissionActionImplCopyWith<$Res> {
  __$$PermissionActionImplCopyWithImpl(_$PermissionActionImpl _value,
      $Res Function(_$PermissionActionImpl) _then)
      : super(_value, _then);

  /// Create a copy of PermissionAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idAction = null,
    Object? codeAction = freezed,
    Object? descriptionAction = freezed,
  }) {
    return _then(_$PermissionActionImpl(
      idAction: null == idAction
          ? _value.idAction
          : idAction // ignore: cast_nullable_to_non_nullable
              as int,
      codeAction: freezed == codeAction
          ? _value.codeAction
          : codeAction // ignore: cast_nullable_to_non_nullable
              as String?,
      descriptionAction: freezed == descriptionAction
          ? _value.descriptionAction
          : descriptionAction // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PermissionActionImpl implements _PermissionAction {
  const _$PermissionActionImpl(
      {required this.idAction, this.codeAction, this.descriptionAction});

  factory _$PermissionActionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PermissionActionImplFromJson(json);

  @override
  final int idAction;
  @override
  final String? codeAction;
  @override
  final String? descriptionAction;

  @override
  String toString() {
    return 'PermissionAction(idAction: $idAction, codeAction: $codeAction, descriptionAction: $descriptionAction)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PermissionActionImpl &&
            (identical(other.idAction, idAction) ||
                other.idAction == idAction) &&
            (identical(other.codeAction, codeAction) ||
                other.codeAction == codeAction) &&
            (identical(other.descriptionAction, descriptionAction) ||
                other.descriptionAction == descriptionAction));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, idAction, codeAction, descriptionAction);

  /// Create a copy of PermissionAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PermissionActionImplCopyWith<_$PermissionActionImpl> get copyWith =>
      __$$PermissionActionImplCopyWithImpl<_$PermissionActionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PermissionActionImplToJson(
      this,
    );
  }
}

abstract class _PermissionAction implements PermissionAction {
  const factory _PermissionAction(
      {required final int idAction,
      final String? codeAction,
      final String? descriptionAction}) = _$PermissionActionImpl;

  factory _PermissionAction.fromJson(Map<String, dynamic> json) =
      _$PermissionActionImpl.fromJson;

  @override
  int get idAction;
  @override
  String? get codeAction;
  @override
  String? get descriptionAction;

  /// Create a copy of PermissionAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PermissionActionImplCopyWith<_$PermissionActionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
