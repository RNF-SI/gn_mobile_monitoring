// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'individual_module.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$IndividualModule {
  int get idIndividual => throw _privateConstructorUsedError;
  int get idModule => throw _privateConstructorUsedError;

  /// Create a copy of IndividualModule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IndividualModuleCopyWith<IndividualModule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IndividualModuleCopyWith<$Res> {
  factory $IndividualModuleCopyWith(
          IndividualModule value, $Res Function(IndividualModule) then) =
      _$IndividualModuleCopyWithImpl<$Res, IndividualModule>;
  @useResult
  $Res call({int idIndividual, int idModule});
}

/// @nodoc
class _$IndividualModuleCopyWithImpl<$Res, $Val extends IndividualModule>
    implements $IndividualModuleCopyWith<$Res> {
  _$IndividualModuleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IndividualModule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idIndividual = null,
    Object? idModule = null,
  }) {
    return _then(_value.copyWith(
      idIndividual: null == idIndividual
          ? _value.idIndividual
          : idIndividual // ignore: cast_nullable_to_non_nullable
              as int,
      idModule: null == idModule
          ? _value.idModule
          : idModule // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IndividualModuleImplCopyWith<$Res>
    implements $IndividualModuleCopyWith<$Res> {
  factory _$$IndividualModuleImplCopyWith(
          _$IndividualModuleImpl value, $Res Function(_$IndividualModuleImpl) then) =
      __$$IndividualModuleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int idIndividual, int idModule});
}

/// @nodoc
class __$$IndividualModuleImplCopyWithImpl<$Res>
    extends _$IndividualModuleCopyWithImpl<$Res, _$IndividualModuleImpl>
    implements _$$IndividualModuleImplCopyWith<$Res> {
  __$$IndividualModuleImplCopyWithImpl(
      _$IndividualModuleImpl _value, $Res Function(_$IndividualModuleImpl) _then)
      : super(_value, _then);

  /// Create a copy of IndividualModule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idIndividual = null,
    Object? idModule = null,
  }) {
    return _then(_$IndividualModuleImpl(
      idIndividual: null == idIndividual
          ? _value.idIndividual
          : idIndividual // ignore: cast_nullable_to_non_nullable
              as int,
      idModule: null == idModule
          ? _value.idModule
          : idModule // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$IndividualModuleImpl implements _IndividualModule {
  const _$IndividualModuleImpl({required this.idIndividual, required this.idModule});

  @override
  final int idIndividual;
  @override
  final int idModule;

  @override
  String toString() {
    return 'IndividualModule(idIndividual: $idIndividual, idModule: $idModule)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IndividualModuleImpl &&
            (identical(other.idIndividual, idIndividual) || other.idIndividual == idIndividual) &&
            (identical(other.idModule, idModule) ||
                other.idModule == idModule));
  }

  @override
  int get hashCode => Object.hash(runtimeType, idIndividual, idModule);

  /// Create a copy of IndividualModule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IndividualModuleImplCopyWith<_$IndividualModuleImpl> get copyWith =>
      __$$IndividualModuleImplCopyWithImpl<_$IndividualModuleImpl>(this, _$identity);
}

abstract class _IndividualModule implements IndividualModule {
  const factory _IndividualModule(
      {required final int idIndividual,
      required final int idModule}) = _$IndividualModuleImpl;

  @override
  int get idIndividual;
  @override
  int get idModule;

  /// Create a copy of IndividualModule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IndividualModuleImplCopyWith<_$IndividualModuleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
