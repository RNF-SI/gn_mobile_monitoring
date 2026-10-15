// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'module_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ModuleInfo {

 Module get module; ModuleDownloadStatus get downloadStatus; double get downloadProgress;// Default to 0.0, indicating no progress
 String get currentStep;
/// Create a copy of ModuleInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModuleInfoCopyWith<ModuleInfo> get copyWith => _$ModuleInfoCopyWithImpl<ModuleInfo>(this as ModuleInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModuleInfo&&(identical(other.module, module) || other.module == module)&&(identical(other.downloadStatus, downloadStatus) || other.downloadStatus == downloadStatus)&&(identical(other.downloadProgress, downloadProgress) || other.downloadProgress == downloadProgress)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep));
}


@override
int get hashCode => Object.hash(runtimeType,module,downloadStatus,downloadProgress,currentStep);

@override
String toString() {
  return 'ModuleInfo(module: $module, downloadStatus: $downloadStatus, downloadProgress: $downloadProgress, currentStep: $currentStep)';
}


}

/// @nodoc
abstract mixin class $ModuleInfoCopyWith<$Res>  {
  factory $ModuleInfoCopyWith(ModuleInfo value, $Res Function(ModuleInfo) _then) = _$ModuleInfoCopyWithImpl;
@useResult
$Res call({
 Module module, ModuleDownloadStatus downloadStatus, double downloadProgress, String currentStep
});


$ModuleCopyWith<$Res> get module;

}
/// @nodoc
class _$ModuleInfoCopyWithImpl<$Res>
    implements $ModuleInfoCopyWith<$Res> {
  _$ModuleInfoCopyWithImpl(this._self, this._then);

  final ModuleInfo _self;
  final $Res Function(ModuleInfo) _then;

/// Create a copy of ModuleInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? module = null,Object? downloadStatus = null,Object? downloadProgress = null,Object? currentStep = null,}) {
  return _then(_self.copyWith(
module: null == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as Module,downloadStatus: null == downloadStatus ? _self.downloadStatus : downloadStatus // ignore: cast_nullable_to_non_nullable
as ModuleDownloadStatus,downloadProgress: null == downloadProgress ? _self.downloadProgress : downloadProgress // ignore: cast_nullable_to_non_nullable
as double,currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of ModuleInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModuleCopyWith<$Res> get module {
  
  return $ModuleCopyWith<$Res>(_self.module, (value) {
    return _then(_self.copyWith(module: value));
  });
}
}


/// Adds pattern-matching-related methods to [ModuleInfo].
extension ModuleInfoPatterns on ModuleInfo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModuleInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModuleInfo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModuleInfo value)  $default,){
final _that = this;
switch (_that) {
case _ModuleInfo():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModuleInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ModuleInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Module module,  ModuleDownloadStatus downloadStatus,  double downloadProgress,  String currentStep)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModuleInfo() when $default != null:
return $default(_that.module,_that.downloadStatus,_that.downloadProgress,_that.currentStep);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Module module,  ModuleDownloadStatus downloadStatus,  double downloadProgress,  String currentStep)  $default,) {final _that = this;
switch (_that) {
case _ModuleInfo():
return $default(_that.module,_that.downloadStatus,_that.downloadProgress,_that.currentStep);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Module module,  ModuleDownloadStatus downloadStatus,  double downloadProgress,  String currentStep)?  $default,) {final _that = this;
switch (_that) {
case _ModuleInfo() when $default != null:
return $default(_that.module,_that.downloadStatus,_that.downloadProgress,_that.currentStep);case _:
  return null;

}
}

}

/// @nodoc


class _ModuleInfo extends ModuleInfo {
  const _ModuleInfo({required this.module, required this.downloadStatus, this.downloadProgress = 0.0, this.currentStep = ""}): super._();
  

@override final  Module module;
@override final  ModuleDownloadStatus downloadStatus;
@override@JsonKey() final  double downloadProgress;
// Default to 0.0, indicating no progress
@override@JsonKey() final  String currentStep;

/// Create a copy of ModuleInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModuleInfoCopyWith<_ModuleInfo> get copyWith => __$ModuleInfoCopyWithImpl<_ModuleInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModuleInfo&&(identical(other.module, module) || other.module == module)&&(identical(other.downloadStatus, downloadStatus) || other.downloadStatus == downloadStatus)&&(identical(other.downloadProgress, downloadProgress) || other.downloadProgress == downloadProgress)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep));
}


@override
int get hashCode => Object.hash(runtimeType,module,downloadStatus,downloadProgress,currentStep);

@override
String toString() {
  return 'ModuleInfo(module: $module, downloadStatus: $downloadStatus, downloadProgress: $downloadProgress, currentStep: $currentStep)';
}


}

/// @nodoc
abstract mixin class _$ModuleInfoCopyWith<$Res> implements $ModuleInfoCopyWith<$Res> {
  factory _$ModuleInfoCopyWith(_ModuleInfo value, $Res Function(_ModuleInfo) _then) = __$ModuleInfoCopyWithImpl;
@override @useResult
$Res call({
 Module module, ModuleDownloadStatus downloadStatus, double downloadProgress, String currentStep
});


@override $ModuleCopyWith<$Res> get module;

}
/// @nodoc
class __$ModuleInfoCopyWithImpl<$Res>
    implements _$ModuleInfoCopyWith<$Res> {
  __$ModuleInfoCopyWithImpl(this._self, this._then);

  final _ModuleInfo _self;
  final $Res Function(_ModuleInfo) _then;

/// Create a copy of ModuleInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? module = null,Object? downloadStatus = null,Object? downloadProgress = null,Object? currentStep = null,}) {
  return _then(_ModuleInfo(
module: null == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as Module,downloadStatus: null == downloadStatus ? _self.downloadStatus : downloadStatus // ignore: cast_nullable_to_non_nullable
as ModuleDownloadStatus,downloadProgress: null == downloadProgress ? _self.downloadProgress : downloadProgress // ignore: cast_nullable_to_non_nullable
as double,currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of ModuleInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModuleCopyWith<$Res> get module {
  
  return $ModuleCopyWith<$Res>(_self.module, (value) {
    return _then(_self.copyWith(module: value));
  });
}
}

// dart format on
