// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'module_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ModuleInfo {
  Module get module => throw _privateConstructorUsedError;
  ModuleDownloadStatus get downloadStatus => throw _privateConstructorUsedError;
  double get downloadProgress =>
      throw _privateConstructorUsedError; // Default to 0.0, indicating no progress
  String get currentStep => throw _privateConstructorUsedError;

  /// Create a copy of ModuleInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ModuleInfoCopyWith<ModuleInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModuleInfoCopyWith<$Res> {
  factory $ModuleInfoCopyWith(
          ModuleInfo value, $Res Function(ModuleInfo) then) =
      _$ModuleInfoCopyWithImpl<$Res, ModuleInfo>;
  @useResult
  $Res call(
      {Module module,
      ModuleDownloadStatus downloadStatus,
      double downloadProgress,
      String currentStep});

  $ModuleCopyWith<$Res> get module;
}

/// @nodoc
class _$ModuleInfoCopyWithImpl<$Res, $Val extends ModuleInfo>
    implements $ModuleInfoCopyWith<$Res> {
  _$ModuleInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ModuleInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? module = null,
    Object? downloadStatus = null,
    Object? downloadProgress = null,
    Object? currentStep = null,
  }) {
    return _then(_value.copyWith(
      module: null == module
          ? _value.module
          : module // ignore: cast_nullable_to_non_nullable
              as Module,
      downloadStatus: null == downloadStatus
          ? _value.downloadStatus
          : downloadStatus // ignore: cast_nullable_to_non_nullable
              as ModuleDownloadStatus,
      downloadProgress: null == downloadProgress
          ? _value.downloadProgress
          : downloadProgress // ignore: cast_nullable_to_non_nullable
              as double,
      currentStep: null == currentStep
          ? _value.currentStep
          : currentStep // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of ModuleInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ModuleCopyWith<$Res> get module {
    return $ModuleCopyWith<$Res>(_value.module, (value) {
      return _then(_value.copyWith(module: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ModuleInfoImplCopyWith<$Res>
    implements $ModuleInfoCopyWith<$Res> {
  factory _$$ModuleInfoImplCopyWith(
          _$ModuleInfoImpl value, $Res Function(_$ModuleInfoImpl) then) =
      __$$ModuleInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Module module,
      ModuleDownloadStatus downloadStatus,
      double downloadProgress,
      String currentStep});

  @override
  $ModuleCopyWith<$Res> get module;
}

/// @nodoc
class __$$ModuleInfoImplCopyWithImpl<$Res>
    extends _$ModuleInfoCopyWithImpl<$Res, _$ModuleInfoImpl>
    implements _$$ModuleInfoImplCopyWith<$Res> {
  __$$ModuleInfoImplCopyWithImpl(
      _$ModuleInfoImpl _value, $Res Function(_$ModuleInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ModuleInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? module = null,
    Object? downloadStatus = null,
    Object? downloadProgress = null,
    Object? currentStep = null,
  }) {
    return _then(_$ModuleInfoImpl(
      module: null == module
          ? _value.module
          : module // ignore: cast_nullable_to_non_nullable
              as Module,
      downloadStatus: null == downloadStatus
          ? _value.downloadStatus
          : downloadStatus // ignore: cast_nullable_to_non_nullable
              as ModuleDownloadStatus,
      downloadProgress: null == downloadProgress
          ? _value.downloadProgress
          : downloadProgress // ignore: cast_nullable_to_non_nullable
              as double,
      currentStep: null == currentStep
          ? _value.currentStep
          : currentStep // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ModuleInfoImpl extends _ModuleInfo {
  const _$ModuleInfoImpl(
      {required this.module,
      required this.downloadStatus,
      this.downloadProgress = 0.0,
      this.currentStep = ""})
      : super._();

  @override
  final Module module;
  @override
  final ModuleDownloadStatus downloadStatus;
  @override
  @JsonKey()
  final double downloadProgress;
// Default to 0.0, indicating no progress
  @override
  @JsonKey()
  final String currentStep;

  @override
  String toString() {
    return 'ModuleInfo(module: $module, downloadStatus: $downloadStatus, downloadProgress: $downloadProgress, currentStep: $currentStep)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModuleInfoImpl &&
            (identical(other.module, module) || other.module == module) &&
            (identical(other.downloadStatus, downloadStatus) ||
                other.downloadStatus == downloadStatus) &&
            (identical(other.downloadProgress, downloadProgress) ||
                other.downloadProgress == downloadProgress) &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, module, downloadStatus, downloadProgress, currentStep);

  /// Create a copy of ModuleInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ModuleInfoImplCopyWith<_$ModuleInfoImpl> get copyWith =>
      __$$ModuleInfoImplCopyWithImpl<_$ModuleInfoImpl>(this, _$identity);
}

abstract class _ModuleInfo extends ModuleInfo {
  const factory _ModuleInfo(
      {required final Module module,
      required final ModuleDownloadStatus downloadStatus,
      final double downloadProgress,
      final String currentStep}) = _$ModuleInfoImpl;
  const _ModuleInfo._() : super._();

  @override
  Module get module;
  @override
  ModuleDownloadStatus get downloadStatus;
  @override
  double get downloadProgress; // Default to 0.0, indicating no progress
  @override
  String get currentStep;

  /// Create a copy of ModuleInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ModuleInfoImplCopyWith<_$ModuleInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
