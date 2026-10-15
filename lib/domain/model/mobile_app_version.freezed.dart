// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mobile_app_version.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MobileAppVersion {

 int get idMobileApp; String get appCode; String? get package; String get versionCode; String? get urlApk;
/// Create a copy of MobileAppVersion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MobileAppVersionCopyWith<MobileAppVersion> get copyWith => _$MobileAppVersionCopyWithImpl<MobileAppVersion>(this as MobileAppVersion, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MobileAppVersion&&(identical(other.idMobileApp, idMobileApp) || other.idMobileApp == idMobileApp)&&(identical(other.appCode, appCode) || other.appCode == appCode)&&(identical(other.package, package) || other.package == package)&&(identical(other.versionCode, versionCode) || other.versionCode == versionCode)&&(identical(other.urlApk, urlApk) || other.urlApk == urlApk));
}


@override
int get hashCode => Object.hash(runtimeType,idMobileApp,appCode,package,versionCode,urlApk);

@override
String toString() {
  return 'MobileAppVersion(idMobileApp: $idMobileApp, appCode: $appCode, package: $package, versionCode: $versionCode, urlApk: $urlApk)';
}


}

/// @nodoc
abstract mixin class $MobileAppVersionCopyWith<$Res>  {
  factory $MobileAppVersionCopyWith(MobileAppVersion value, $Res Function(MobileAppVersion) _then) = _$MobileAppVersionCopyWithImpl;
@useResult
$Res call({
 int idMobileApp, String appCode, String? package, String versionCode, String? urlApk
});




}
/// @nodoc
class _$MobileAppVersionCopyWithImpl<$Res>
    implements $MobileAppVersionCopyWith<$Res> {
  _$MobileAppVersionCopyWithImpl(this._self, this._then);

  final MobileAppVersion _self;
  final $Res Function(MobileAppVersion) _then;

/// Create a copy of MobileAppVersion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idMobileApp = null,Object? appCode = null,Object? package = freezed,Object? versionCode = null,Object? urlApk = freezed,}) {
  return _then(_self.copyWith(
idMobileApp: null == idMobileApp ? _self.idMobileApp : idMobileApp // ignore: cast_nullable_to_non_nullable
as int,appCode: null == appCode ? _self.appCode : appCode // ignore: cast_nullable_to_non_nullable
as String,package: freezed == package ? _self.package : package // ignore: cast_nullable_to_non_nullable
as String?,versionCode: null == versionCode ? _self.versionCode : versionCode // ignore: cast_nullable_to_non_nullable
as String,urlApk: freezed == urlApk ? _self.urlApk : urlApk // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MobileAppVersion].
extension MobileAppVersionPatterns on MobileAppVersion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MobileAppVersion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MobileAppVersion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MobileAppVersion value)  $default,){
final _that = this;
switch (_that) {
case _MobileAppVersion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MobileAppVersion value)?  $default,){
final _that = this;
switch (_that) {
case _MobileAppVersion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int idMobileApp,  String appCode,  String? package,  String versionCode,  String? urlApk)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MobileAppVersion() when $default != null:
return $default(_that.idMobileApp,_that.appCode,_that.package,_that.versionCode,_that.urlApk);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int idMobileApp,  String appCode,  String? package,  String versionCode,  String? urlApk)  $default,) {final _that = this;
switch (_that) {
case _MobileAppVersion():
return $default(_that.idMobileApp,_that.appCode,_that.package,_that.versionCode,_that.urlApk);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int idMobileApp,  String appCode,  String? package,  String versionCode,  String? urlApk)?  $default,) {final _that = this;
switch (_that) {
case _MobileAppVersion() when $default != null:
return $default(_that.idMobileApp,_that.appCode,_that.package,_that.versionCode,_that.urlApk);case _:
  return null;

}
}

}

/// @nodoc


class _MobileAppVersion implements MobileAppVersion {
  const _MobileAppVersion({required this.idMobileApp, required this.appCode, this.package, required this.versionCode, this.urlApk});
  

@override final  int idMobileApp;
@override final  String appCode;
@override final  String? package;
@override final  String versionCode;
@override final  String? urlApk;

/// Create a copy of MobileAppVersion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MobileAppVersionCopyWith<_MobileAppVersion> get copyWith => __$MobileAppVersionCopyWithImpl<_MobileAppVersion>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MobileAppVersion&&(identical(other.idMobileApp, idMobileApp) || other.idMobileApp == idMobileApp)&&(identical(other.appCode, appCode) || other.appCode == appCode)&&(identical(other.package, package) || other.package == package)&&(identical(other.versionCode, versionCode) || other.versionCode == versionCode)&&(identical(other.urlApk, urlApk) || other.urlApk == urlApk));
}


@override
int get hashCode => Object.hash(runtimeType,idMobileApp,appCode,package,versionCode,urlApk);

@override
String toString() {
  return 'MobileAppVersion(idMobileApp: $idMobileApp, appCode: $appCode, package: $package, versionCode: $versionCode, urlApk: $urlApk)';
}


}

/// @nodoc
abstract mixin class _$MobileAppVersionCopyWith<$Res> implements $MobileAppVersionCopyWith<$Res> {
  factory _$MobileAppVersionCopyWith(_MobileAppVersion value, $Res Function(_MobileAppVersion) _then) = __$MobileAppVersionCopyWithImpl;
@override @useResult
$Res call({
 int idMobileApp, String appCode, String? package, String versionCode, String? urlApk
});




}
/// @nodoc
class __$MobileAppVersionCopyWithImpl<$Res>
    implements _$MobileAppVersionCopyWith<$Res> {
  __$MobileAppVersionCopyWithImpl(this._self, this._then);

  final _MobileAppVersion _self;
  final $Res Function(_MobileAppVersion) _then;

/// Create a copy of MobileAppVersion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idMobileApp = null,Object? appCode = null,Object? package = freezed,Object? versionCode = null,Object? urlApk = freezed,}) {
  return _then(_MobileAppVersion(
idMobileApp: null == idMobileApp ? _self.idMobileApp : idMobileApp // ignore: cast_nullable_to_non_nullable
as int,appCode: null == appCode ? _self.appCode : appCode // ignore: cast_nullable_to_non_nullable
as String,package: freezed == package ? _self.package : package // ignore: cast_nullable_to_non_nullable
as String?,versionCode: null == versionCode ? _self.versionCode : versionCode // ignore: cast_nullable_to_non_nullable
as String,urlApk: freezed == urlApk ? _self.urlApk : urlApk // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
