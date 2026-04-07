// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mobile_app_version.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MobileAppVersion {
  int get idMobileApp => throw _privateConstructorUsedError;
  String get appCode => throw _privateConstructorUsedError;
  String? get package => throw _privateConstructorUsedError;
  String get versionCode => throw _privateConstructorUsedError;
  String? get urlApk => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MobileAppVersionCopyWith<MobileAppVersion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MobileAppVersionCopyWith<$Res> {
  factory $MobileAppVersionCopyWith(
          MobileAppVersion value, $Res Function(MobileAppVersion) then) =
      _$MobileAppVersionCopyWithImpl<$Res, MobileAppVersion>;
  @useResult
  $Res call(
      {int idMobileApp,
      String appCode,
      String? package,
      String versionCode,
      String? urlApk});
}

/// @nodoc
class _$MobileAppVersionCopyWithImpl<$Res, $Val extends MobileAppVersion>
    implements $MobileAppVersionCopyWith<$Res> {
  _$MobileAppVersionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idMobileApp = null,
    Object? appCode = null,
    Object? package = freezed,
    Object? versionCode = null,
    Object? urlApk = freezed,
  }) {
    return _then(_value.copyWith(
      idMobileApp: null == idMobileApp
          ? _value.idMobileApp
          : idMobileApp // ignore: cast_nullable_to_non_nullable
              as int,
      appCode: null == appCode
          ? _value.appCode
          : appCode // ignore: cast_nullable_to_non_nullable
              as String,
      package: freezed == package
          ? _value.package
          : package // ignore: cast_nullable_to_non_nullable
              as String?,
      versionCode: null == versionCode
          ? _value.versionCode
          : versionCode // ignore: cast_nullable_to_non_nullable
              as String,
      urlApk: freezed == urlApk
          ? _value.urlApk
          : urlApk // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MobileAppVersionImplCopyWith<$Res>
    implements $MobileAppVersionCopyWith<$Res> {
  factory _$$MobileAppVersionImplCopyWith(_$MobileAppVersionImpl value,
          $Res Function(_$MobileAppVersionImpl) then) =
      __$$MobileAppVersionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int idMobileApp,
      String appCode,
      String? package,
      String versionCode,
      String? urlApk});
}

/// @nodoc
class __$$MobileAppVersionImplCopyWithImpl<$Res>
    extends _$MobileAppVersionCopyWithImpl<$Res, _$MobileAppVersionImpl>
    implements _$$MobileAppVersionImplCopyWith<$Res> {
  __$$MobileAppVersionImplCopyWithImpl(_$MobileAppVersionImpl _value,
      $Res Function(_$MobileAppVersionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idMobileApp = null,
    Object? appCode = null,
    Object? package = freezed,
    Object? versionCode = null,
    Object? urlApk = freezed,
  }) {
    return _then(_$MobileAppVersionImpl(
      idMobileApp: null == idMobileApp
          ? _value.idMobileApp
          : idMobileApp // ignore: cast_nullable_to_non_nullable
              as int,
      appCode: null == appCode
          ? _value.appCode
          : appCode // ignore: cast_nullable_to_non_nullable
              as String,
      package: freezed == package
          ? _value.package
          : package // ignore: cast_nullable_to_non_nullable
              as String?,
      versionCode: null == versionCode
          ? _value.versionCode
          : versionCode // ignore: cast_nullable_to_non_nullable
              as String,
      urlApk: freezed == urlApk
          ? _value.urlApk
          : urlApk // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$MobileAppVersionImpl implements _MobileAppVersion {
  const _$MobileAppVersionImpl(
      {required this.idMobileApp,
      required this.appCode,
      this.package,
      required this.versionCode,
      this.urlApk});

  @override
  final int idMobileApp;
  @override
  final String appCode;
  @override
  final String? package;
  @override
  final String versionCode;
  @override
  final String? urlApk;

  @override
  String toString() {
    return 'MobileAppVersion(idMobileApp: $idMobileApp, appCode: $appCode, package: $package, versionCode: $versionCode, urlApk: $urlApk)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MobileAppVersionImpl &&
            (identical(other.idMobileApp, idMobileApp) ||
                other.idMobileApp == idMobileApp) &&
            (identical(other.appCode, appCode) || other.appCode == appCode) &&
            (identical(other.package, package) || other.package == package) &&
            (identical(other.versionCode, versionCode) ||
                other.versionCode == versionCode) &&
            (identical(other.urlApk, urlApk) || other.urlApk == urlApk));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, idMobileApp, appCode, package, versionCode, urlApk);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MobileAppVersionImplCopyWith<_$MobileAppVersionImpl> get copyWith =>
      __$$MobileAppVersionImplCopyWithImpl<_$MobileAppVersionImpl>(
          this, _$identity);
}

abstract class _MobileAppVersion implements MobileAppVersion {
  const factory _MobileAppVersion(
      {required final int idMobileApp,
      required final String appCode,
      final String? package,
      required final String versionCode,
      final String? urlApk}) = _$MobileAppVersionImpl;

  @override
  int get idMobileApp;
  @override
  String get appCode;
  @override
  String? get package;
  @override
  String get versionCode;
  @override
  String? get urlApk;
  @override
  @JsonKey(ignore: true)
  _$$MobileAppVersionImplCopyWith<_$MobileAppVersionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
