// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'module.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Module {
  int get idModule => throw _privateConstructorUsedError;
  String get moduleCode => throw _privateConstructorUsedError;
  String get moduleLabel => throw _privateConstructorUsedError;
  String get data => throw _privateConstructorUsedError;

  /// Create a copy of Module
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ModuleCopyWith<Module> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModuleCopyWith<$Res> {
  factory $ModuleCopyWith(Module value, $Res Function(Module) then) =
      _$ModuleCopyWithImpl<$Res, Module>;
  @useResult
  $Res call({int idModule, String moduleCode, String moduleLabel, String data});
}

/// @nodoc
class _$ModuleCopyWithImpl<$Res, $Val extends Module>
    implements $ModuleCopyWith<$Res> {
  _$ModuleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Module
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idModule = null,
    Object? moduleCode = null,
    Object? moduleLabel = null,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      idModule: null == idModule
          ? _value.idModule
          : idModule // ignore: cast_nullable_to_non_nullable
              as int,
      moduleCode: null == moduleCode
          ? _value.moduleCode
          : moduleCode // ignore: cast_nullable_to_non_nullable
              as String,
      moduleLabel: null == moduleLabel
          ? _value.moduleLabel
          : moduleLabel // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ModuleImplCopyWith<$Res> implements $ModuleCopyWith<$Res> {
  factory _$$ModuleImplCopyWith(
          _$ModuleImpl value, $Res Function(_$ModuleImpl) then) =
      __$$ModuleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int idModule, String moduleCode, String moduleLabel, String data});
}

/// @nodoc
class __$$ModuleImplCopyWithImpl<$Res>
    extends _$ModuleCopyWithImpl<$Res, _$ModuleImpl>
    implements _$$ModuleImplCopyWith<$Res> {
  __$$ModuleImplCopyWithImpl(
      _$ModuleImpl _value, $Res Function(_$ModuleImpl) _then)
      : super(_value, _then);

  /// Create a copy of Module
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idModule = null,
    Object? moduleCode = null,
    Object? moduleLabel = null,
    Object? data = null,
  }) {
    return _then(_$ModuleImpl(
      idModule: null == idModule
          ? _value.idModule
          : idModule // ignore: cast_nullable_to_non_nullable
              as int,
      moduleCode: null == moduleCode
          ? _value.moduleCode
          : moduleCode // ignore: cast_nullable_to_non_nullable
              as String,
      moduleLabel: null == moduleLabel
          ? _value.moduleLabel
          : moduleLabel // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ModuleImpl extends _Module {
  const _$ModuleImpl(
      {required this.idModule,
      required this.moduleCode,
      required this.moduleLabel,
      required this.data})
      : super._();

  @override
  final int idModule;
  @override
  final String moduleCode;
  @override
  final String moduleLabel;
  @override
  final String data;

  @override
  String toString() {
    return 'Module(idModule: $idModule, moduleCode: $moduleCode, moduleLabel: $moduleLabel, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModuleImpl &&
            (identical(other.idModule, idModule) ||
                other.idModule == idModule) &&
            (identical(other.moduleCode, moduleCode) ||
                other.moduleCode == moduleCode) &&
            (identical(other.moduleLabel, moduleLabel) ||
                other.moduleLabel == moduleLabel) &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, idModule, moduleCode, moduleLabel, data);

  /// Create a copy of Module
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ModuleImplCopyWith<_$ModuleImpl> get copyWith =>
      __$$ModuleImplCopyWithImpl<_$ModuleImpl>(this, _$identity);
}

abstract class _Module extends Module {
  const factory _Module(
      {required final int idModule,
      required final String moduleCode,
      required final String moduleLabel,
      required final String data}) = _$ModuleImpl;
  const _Module._() : super._();

  @override
  int get idModule;
  @override
  String get moduleCode;
  @override
  String get moduleLabel;
  @override
  String get data;

  /// Create a copy of Module
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ModuleImplCopyWith<_$ModuleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
