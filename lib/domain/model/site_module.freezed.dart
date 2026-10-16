// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'site_module.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SiteModule {

 int get idSite; int get idModule;
/// Create a copy of SiteModule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SiteModuleCopyWith<SiteModule> get copyWith => _$SiteModuleCopyWithImpl<SiteModule>(this as SiteModule, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SiteModule&&(identical(other.idSite, idSite) || other.idSite == idSite)&&(identical(other.idModule, idModule) || other.idModule == idModule));
}


@override
int get hashCode => Object.hash(runtimeType,idSite,idModule);

@override
String toString() {
  return 'SiteModule(idSite: $idSite, idModule: $idModule)';
}


}

/// @nodoc
abstract mixin class $SiteModuleCopyWith<$Res>  {
  factory $SiteModuleCopyWith(SiteModule value, $Res Function(SiteModule) _then) = _$SiteModuleCopyWithImpl;
@useResult
$Res call({
 int idSite, int idModule
});




}
/// @nodoc
class _$SiteModuleCopyWithImpl<$Res>
    implements $SiteModuleCopyWith<$Res> {
  _$SiteModuleCopyWithImpl(this._self, this._then);

  final SiteModule _self;
  final $Res Function(SiteModule) _then;

/// Create a copy of SiteModule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idSite = null,Object? idModule = null,}) {
  return _then(_self.copyWith(
idSite: null == idSite ? _self.idSite : idSite // ignore: cast_nullable_to_non_nullable
as int,idModule: null == idModule ? _self.idModule : idModule // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SiteModule].
extension SiteModulePatterns on SiteModule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SiteModule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SiteModule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SiteModule value)  $default,){
final _that = this;
switch (_that) {
case _SiteModule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SiteModule value)?  $default,){
final _that = this;
switch (_that) {
case _SiteModule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int idSite,  int idModule)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SiteModule() when $default != null:
return $default(_that.idSite,_that.idModule);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int idSite,  int idModule)  $default,) {final _that = this;
switch (_that) {
case _SiteModule():
return $default(_that.idSite,_that.idModule);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int idSite,  int idModule)?  $default,) {final _that = this;
switch (_that) {
case _SiteModule() when $default != null:
return $default(_that.idSite,_that.idModule);case _:
  return null;

}
}

}

/// @nodoc


class _SiteModule implements SiteModule {
  const _SiteModule({required this.idSite, required this.idModule});
  

@override final  int idSite;
@override final  int idModule;

/// Create a copy of SiteModule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SiteModuleCopyWith<_SiteModule> get copyWith => __$SiteModuleCopyWithImpl<_SiteModule>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SiteModule&&(identical(other.idSite, idSite) || other.idSite == idSite)&&(identical(other.idModule, idModule) || other.idModule == idModule));
}


@override
int get hashCode => Object.hash(runtimeType,idSite,idModule);

@override
String toString() {
  return 'SiteModule(idSite: $idSite, idModule: $idModule)';
}


}

/// @nodoc
abstract mixin class _$SiteModuleCopyWith<$Res> implements $SiteModuleCopyWith<$Res> {
  factory _$SiteModuleCopyWith(_SiteModule value, $Res Function(_SiteModule) _then) = __$SiteModuleCopyWithImpl;
@override @useResult
$Res call({
 int idSite, int idModule
});




}
/// @nodoc
class __$SiteModuleCopyWithImpl<$Res>
    implements _$SiteModuleCopyWith<$Res> {
  __$SiteModuleCopyWithImpl(this._self, this._then);

  final _SiteModule _self;
  final $Res Function(_SiteModule) _then;

/// Create a copy of SiteModule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idSite = null,Object? idModule = null,}) {
  return _then(_SiteModule(
idSite: null == idSite ? _self.idSite : idSite // ignore: cast_nullable_to_non_nullable
as int,idModule: null == idModule ? _self.idModule : idModule // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
