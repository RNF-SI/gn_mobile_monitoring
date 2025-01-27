// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'site_module.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SiteModule {
  int get idSite => throw _privateConstructorUsedError;
  int get idModule => throw _privateConstructorUsedError;

  /// Create a copy of SiteModule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SiteModuleCopyWith<SiteModule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SiteModuleCopyWith<$Res> {
  factory $SiteModuleCopyWith(
          SiteModule value, $Res Function(SiteModule) then) =
      _$SiteModuleCopyWithImpl<$Res, SiteModule>;
  @useResult
  $Res call({int idSite, int idModule});
}

/// @nodoc
class _$SiteModuleCopyWithImpl<$Res, $Val extends SiteModule>
    implements $SiteModuleCopyWith<$Res> {
  _$SiteModuleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SiteModule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idSite = null,
    Object? idModule = null,
  }) {
    return _then(_value.copyWith(
      idSite: null == idSite
          ? _value.idSite
          : idSite // ignore: cast_nullable_to_non_nullable
              as int,
      idModule: null == idModule
          ? _value.idModule
          : idModule // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SiteModuleImplCopyWith<$Res>
    implements $SiteModuleCopyWith<$Res> {
  factory _$$SiteModuleImplCopyWith(
          _$SiteModuleImpl value, $Res Function(_$SiteModuleImpl) then) =
      __$$SiteModuleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int idSite, int idModule});
}

/// @nodoc
class __$$SiteModuleImplCopyWithImpl<$Res>
    extends _$SiteModuleCopyWithImpl<$Res, _$SiteModuleImpl>
    implements _$$SiteModuleImplCopyWith<$Res> {
  __$$SiteModuleImplCopyWithImpl(
      _$SiteModuleImpl _value, $Res Function(_$SiteModuleImpl) _then)
      : super(_value, _then);

  /// Create a copy of SiteModule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idSite = null,
    Object? idModule = null,
  }) {
    return _then(_$SiteModuleImpl(
      idSite: null == idSite
          ? _value.idSite
          : idSite // ignore: cast_nullable_to_non_nullable
              as int,
      idModule: null == idModule
          ? _value.idModule
          : idModule // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$SiteModuleImpl implements _SiteModule {
  const _$SiteModuleImpl({required this.idSite, required this.idModule});

  @override
  final int idSite;
  @override
  final int idModule;

  @override
  String toString() {
    return 'SiteModule(idSite: $idSite, idModule: $idModule)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SiteModuleImpl &&
            (identical(other.idSite, idSite) || other.idSite == idSite) &&
            (identical(other.idModule, idModule) ||
                other.idModule == idModule));
  }

  @override
  int get hashCode => Object.hash(runtimeType, idSite, idModule);

  /// Create a copy of SiteModule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SiteModuleImplCopyWith<_$SiteModuleImpl> get copyWith =>
      __$$SiteModuleImplCopyWithImpl<_$SiteModuleImpl>(this, _$identity);
}

abstract class _SiteModule implements SiteModule {
  const factory _SiteModule(
      {required final int idSite,
      required final int idModule}) = _$SiteModuleImpl;

  @override
  int get idSite;
  @override
  int get idModule;

  /// Create a copy of SiteModule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SiteModuleImplCopyWith<_$SiteModuleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
