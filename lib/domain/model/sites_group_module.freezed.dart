// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sites_group_module.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SitesGroupModule {

 int get idSitesGroup; int get idModule;
/// Create a copy of SitesGroupModule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SitesGroupModuleCopyWith<SitesGroupModule> get copyWith => _$SitesGroupModuleCopyWithImpl<SitesGroupModule>(this as SitesGroupModule, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SitesGroupModule&&(identical(other.idSitesGroup, idSitesGroup) || other.idSitesGroup == idSitesGroup)&&(identical(other.idModule, idModule) || other.idModule == idModule));
}


@override
int get hashCode => Object.hash(runtimeType,idSitesGroup,idModule);

@override
String toString() {
  return 'SitesGroupModule(idSitesGroup: $idSitesGroup, idModule: $idModule)';
}


}

/// @nodoc
abstract mixin class $SitesGroupModuleCopyWith<$Res>  {
  factory $SitesGroupModuleCopyWith(SitesGroupModule value, $Res Function(SitesGroupModule) _then) = _$SitesGroupModuleCopyWithImpl;
@useResult
$Res call({
 int idSitesGroup, int idModule
});




}
/// @nodoc
class _$SitesGroupModuleCopyWithImpl<$Res>
    implements $SitesGroupModuleCopyWith<$Res> {
  _$SitesGroupModuleCopyWithImpl(this._self, this._then);

  final SitesGroupModule _self;
  final $Res Function(SitesGroupModule) _then;

/// Create a copy of SitesGroupModule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idSitesGroup = null,Object? idModule = null,}) {
  return _then(_self.copyWith(
idSitesGroup: null == idSitesGroup ? _self.idSitesGroup : idSitesGroup // ignore: cast_nullable_to_non_nullable
as int,idModule: null == idModule ? _self.idModule : idModule // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SitesGroupModule].
extension SitesGroupModulePatterns on SitesGroupModule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SitesGroupModule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SitesGroupModule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SitesGroupModule value)  $default,){
final _that = this;
switch (_that) {
case _SitesGroupModule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SitesGroupModule value)?  $default,){
final _that = this;
switch (_that) {
case _SitesGroupModule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int idSitesGroup,  int idModule)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SitesGroupModule() when $default != null:
return $default(_that.idSitesGroup,_that.idModule);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int idSitesGroup,  int idModule)  $default,) {final _that = this;
switch (_that) {
case _SitesGroupModule():
return $default(_that.idSitesGroup,_that.idModule);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int idSitesGroup,  int idModule)?  $default,) {final _that = this;
switch (_that) {
case _SitesGroupModule() when $default != null:
return $default(_that.idSitesGroup,_that.idModule);case _:
  return null;

}
}

}

/// @nodoc


class _SitesGroupModule implements SitesGroupModule {
  const _SitesGroupModule({required this.idSitesGroup, required this.idModule});
  

@override final  int idSitesGroup;
@override final  int idModule;

/// Create a copy of SitesGroupModule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SitesGroupModuleCopyWith<_SitesGroupModule> get copyWith => __$SitesGroupModuleCopyWithImpl<_SitesGroupModule>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SitesGroupModule&&(identical(other.idSitesGroup, idSitesGroup) || other.idSitesGroup == idSitesGroup)&&(identical(other.idModule, idModule) || other.idModule == idModule));
}


@override
int get hashCode => Object.hash(runtimeType,idSitesGroup,idModule);

@override
String toString() {
  return 'SitesGroupModule(idSitesGroup: $idSitesGroup, idModule: $idModule)';
}


}

/// @nodoc
abstract mixin class _$SitesGroupModuleCopyWith<$Res> implements $SitesGroupModuleCopyWith<$Res> {
  factory _$SitesGroupModuleCopyWith(_SitesGroupModule value, $Res Function(_SitesGroupModule) _then) = __$SitesGroupModuleCopyWithImpl;
@override @useResult
$Res call({
 int idSitesGroup, int idModule
});




}
/// @nodoc
class __$SitesGroupModuleCopyWithImpl<$Res>
    implements _$SitesGroupModuleCopyWith<$Res> {
  __$SitesGroupModuleCopyWithImpl(this._self, this._then);

  final _SitesGroupModule _self;
  final $Res Function(_SitesGroupModule) _then;

/// Create a copy of SitesGroupModule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idSitesGroup = null,Object? idModule = null,}) {
  return _then(_SitesGroupModule(
idSitesGroup: null == idSitesGroup ? _self.idSitesGroup : idSitesGroup // ignore: cast_nullable_to_non_nullable
as int,idModule: null == idModule ? _self.idModule : idModule // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
