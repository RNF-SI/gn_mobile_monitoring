// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sites_group_module.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SitesGroupModule {
  int get idSitesGroup => throw _privateConstructorUsedError;
  int get idModule => throw _privateConstructorUsedError;

  /// Create a copy of SitesGroupModule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SitesGroupModuleCopyWith<SitesGroupModule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SitesGroupModuleCopyWith<$Res> {
  factory $SitesGroupModuleCopyWith(
          SitesGroupModule value, $Res Function(SitesGroupModule) then) =
      _$SitesGroupModuleCopyWithImpl<$Res, SitesGroupModule>;
  @useResult
  $Res call({int idSitesGroup, int idModule});
}

/// @nodoc
class _$SitesGroupModuleCopyWithImpl<$Res, $Val extends SitesGroupModule>
    implements $SitesGroupModuleCopyWith<$Res> {
  _$SitesGroupModuleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SitesGroupModule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idSitesGroup = null,
    Object? idModule = null,
  }) {
    return _then(_value.copyWith(
      idSitesGroup: null == idSitesGroup
          ? _value.idSitesGroup
          : idSitesGroup // ignore: cast_nullable_to_non_nullable
              as int,
      idModule: null == idModule
          ? _value.idModule
          : idModule // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SitesGroupModuleImplCopyWith<$Res>
    implements $SitesGroupModuleCopyWith<$Res> {
  factory _$$SitesGroupModuleImplCopyWith(_$SitesGroupModuleImpl value,
          $Res Function(_$SitesGroupModuleImpl) then) =
      __$$SitesGroupModuleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int idSitesGroup, int idModule});
}

/// @nodoc
class __$$SitesGroupModuleImplCopyWithImpl<$Res>
    extends _$SitesGroupModuleCopyWithImpl<$Res, _$SitesGroupModuleImpl>
    implements _$$SitesGroupModuleImplCopyWith<$Res> {
  __$$SitesGroupModuleImplCopyWithImpl(_$SitesGroupModuleImpl _value,
      $Res Function(_$SitesGroupModuleImpl) _then)
      : super(_value, _then);

  /// Create a copy of SitesGroupModule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idSitesGroup = null,
    Object? idModule = null,
  }) {
    return _then(_$SitesGroupModuleImpl(
      idSitesGroup: null == idSitesGroup
          ? _value.idSitesGroup
          : idSitesGroup // ignore: cast_nullable_to_non_nullable
              as int,
      idModule: null == idModule
          ? _value.idModule
          : idModule // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$SitesGroupModuleImpl implements _SitesGroupModule {
  const _$SitesGroupModuleImpl(
      {required this.idSitesGroup, required this.idModule});

  @override
  final int idSitesGroup;
  @override
  final int idModule;

  @override
  String toString() {
    return 'SitesGroupModule(idSitesGroup: $idSitesGroup, idModule: $idModule)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SitesGroupModuleImpl &&
            (identical(other.idSitesGroup, idSitesGroup) ||
                other.idSitesGroup == idSitesGroup) &&
            (identical(other.idModule, idModule) ||
                other.idModule == idModule));
  }

  @override
  int get hashCode => Object.hash(runtimeType, idSitesGroup, idModule);

  /// Create a copy of SitesGroupModule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SitesGroupModuleImplCopyWith<_$SitesGroupModuleImpl> get copyWith =>
      __$$SitesGroupModuleImplCopyWithImpl<_$SitesGroupModuleImpl>(
          this, _$identity);
}

abstract class _SitesGroupModule implements SitesGroupModule {
  const factory _SitesGroupModule(
      {required final int idSitesGroup,
      required final int idModule}) = _$SitesGroupModuleImpl;

  @override
  int get idSitesGroup;
  @override
  int get idModule;

  /// Create a copy of SitesGroupModule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SitesGroupModuleImplCopyWith<_$SitesGroupModuleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
