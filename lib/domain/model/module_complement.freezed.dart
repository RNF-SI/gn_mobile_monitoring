// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'module_complement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ModuleComplement {

 int get idModule; String? get uuidModuleComplement; int? get idListObserver; int? get idListTaxonomy; bool get bSynthese; String get taxonomyDisplayFieldName; bool? get bDrawSitesGroup; String? get data; ModuleConfiguration? get configuration;
/// Create a copy of ModuleComplement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModuleComplementCopyWith<ModuleComplement> get copyWith => _$ModuleComplementCopyWithImpl<ModuleComplement>(this as ModuleComplement, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModuleComplement&&(identical(other.idModule, idModule) || other.idModule == idModule)&&(identical(other.uuidModuleComplement, uuidModuleComplement) || other.uuidModuleComplement == uuidModuleComplement)&&(identical(other.idListObserver, idListObserver) || other.idListObserver == idListObserver)&&(identical(other.idListTaxonomy, idListTaxonomy) || other.idListTaxonomy == idListTaxonomy)&&(identical(other.bSynthese, bSynthese) || other.bSynthese == bSynthese)&&(identical(other.taxonomyDisplayFieldName, taxonomyDisplayFieldName) || other.taxonomyDisplayFieldName == taxonomyDisplayFieldName)&&(identical(other.bDrawSitesGroup, bDrawSitesGroup) || other.bDrawSitesGroup == bDrawSitesGroup)&&(identical(other.data, data) || other.data == data)&&(identical(other.configuration, configuration) || other.configuration == configuration));
}


@override
int get hashCode => Object.hash(runtimeType,idModule,uuidModuleComplement,idListObserver,idListTaxonomy,bSynthese,taxonomyDisplayFieldName,bDrawSitesGroup,data,configuration);

@override
String toString() {
  return 'ModuleComplement(idModule: $idModule, uuidModuleComplement: $uuidModuleComplement, idListObserver: $idListObserver, idListTaxonomy: $idListTaxonomy, bSynthese: $bSynthese, taxonomyDisplayFieldName: $taxonomyDisplayFieldName, bDrawSitesGroup: $bDrawSitesGroup, data: $data, configuration: $configuration)';
}


}

/// @nodoc
abstract mixin class $ModuleComplementCopyWith<$Res>  {
  factory $ModuleComplementCopyWith(ModuleComplement value, $Res Function(ModuleComplement) _then) = _$ModuleComplementCopyWithImpl;
@useResult
$Res call({
 int idModule, String? uuidModuleComplement, int? idListObserver, int? idListTaxonomy, bool bSynthese, String taxonomyDisplayFieldName, bool? bDrawSitesGroup, String? data, ModuleConfiguration? configuration
});


$ModuleConfigurationCopyWith<$Res>? get configuration;

}
/// @nodoc
class _$ModuleComplementCopyWithImpl<$Res>
    implements $ModuleComplementCopyWith<$Res> {
  _$ModuleComplementCopyWithImpl(this._self, this._then);

  final ModuleComplement _self;
  final $Res Function(ModuleComplement) _then;

/// Create a copy of ModuleComplement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idModule = null,Object? uuidModuleComplement = freezed,Object? idListObserver = freezed,Object? idListTaxonomy = freezed,Object? bSynthese = null,Object? taxonomyDisplayFieldName = null,Object? bDrawSitesGroup = freezed,Object? data = freezed,Object? configuration = freezed,}) {
  return _then(_self.copyWith(
idModule: null == idModule ? _self.idModule : idModule // ignore: cast_nullable_to_non_nullable
as int,uuidModuleComplement: freezed == uuidModuleComplement ? _self.uuidModuleComplement : uuidModuleComplement // ignore: cast_nullable_to_non_nullable
as String?,idListObserver: freezed == idListObserver ? _self.idListObserver : idListObserver // ignore: cast_nullable_to_non_nullable
as int?,idListTaxonomy: freezed == idListTaxonomy ? _self.idListTaxonomy : idListTaxonomy // ignore: cast_nullable_to_non_nullable
as int?,bSynthese: null == bSynthese ? _self.bSynthese : bSynthese // ignore: cast_nullable_to_non_nullable
as bool,taxonomyDisplayFieldName: null == taxonomyDisplayFieldName ? _self.taxonomyDisplayFieldName : taxonomyDisplayFieldName // ignore: cast_nullable_to_non_nullable
as String,bDrawSitesGroup: freezed == bDrawSitesGroup ? _self.bDrawSitesGroup : bDrawSitesGroup // ignore: cast_nullable_to_non_nullable
as bool?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as String?,configuration: freezed == configuration ? _self.configuration : configuration // ignore: cast_nullable_to_non_nullable
as ModuleConfiguration?,
  ));
}
/// Create a copy of ModuleComplement
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModuleConfigurationCopyWith<$Res>? get configuration {
    if (_self.configuration == null) {
    return null;
  }

  return $ModuleConfigurationCopyWith<$Res>(_self.configuration!, (value) {
    return _then(_self.copyWith(configuration: value));
  });
}
}


/// Adds pattern-matching-related methods to [ModuleComplement].
extension ModuleComplementPatterns on ModuleComplement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModuleComplement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModuleComplement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModuleComplement value)  $default,){
final _that = this;
switch (_that) {
case _ModuleComplement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModuleComplement value)?  $default,){
final _that = this;
switch (_that) {
case _ModuleComplement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int idModule,  String? uuidModuleComplement,  int? idListObserver,  int? idListTaxonomy,  bool bSynthese,  String taxonomyDisplayFieldName,  bool? bDrawSitesGroup,  String? data,  ModuleConfiguration? configuration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModuleComplement() when $default != null:
return $default(_that.idModule,_that.uuidModuleComplement,_that.idListObserver,_that.idListTaxonomy,_that.bSynthese,_that.taxonomyDisplayFieldName,_that.bDrawSitesGroup,_that.data,_that.configuration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int idModule,  String? uuidModuleComplement,  int? idListObserver,  int? idListTaxonomy,  bool bSynthese,  String taxonomyDisplayFieldName,  bool? bDrawSitesGroup,  String? data,  ModuleConfiguration? configuration)  $default,) {final _that = this;
switch (_that) {
case _ModuleComplement():
return $default(_that.idModule,_that.uuidModuleComplement,_that.idListObserver,_that.idListTaxonomy,_that.bSynthese,_that.taxonomyDisplayFieldName,_that.bDrawSitesGroup,_that.data,_that.configuration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int idModule,  String? uuidModuleComplement,  int? idListObserver,  int? idListTaxonomy,  bool bSynthese,  String taxonomyDisplayFieldName,  bool? bDrawSitesGroup,  String? data,  ModuleConfiguration? configuration)?  $default,) {final _that = this;
switch (_that) {
case _ModuleComplement() when $default != null:
return $default(_that.idModule,_that.uuidModuleComplement,_that.idListObserver,_that.idListTaxonomy,_that.bSynthese,_that.taxonomyDisplayFieldName,_that.bDrawSitesGroup,_that.data,_that.configuration);case _:
  return null;

}
}

}

/// @nodoc


class _ModuleComplement implements ModuleComplement {
  const _ModuleComplement({required this.idModule, this.uuidModuleComplement, this.idListObserver, this.idListTaxonomy, this.bSynthese = true, this.taxonomyDisplayFieldName = 'nom_vern,lb_nom', this.bDrawSitesGroup, this.data, this.configuration});
  

@override final  int idModule;
@override final  String? uuidModuleComplement;
@override final  int? idListObserver;
@override final  int? idListTaxonomy;
@override@JsonKey() final  bool bSynthese;
@override@JsonKey() final  String taxonomyDisplayFieldName;
@override final  bool? bDrawSitesGroup;
@override final  String? data;
@override final  ModuleConfiguration? configuration;

/// Create a copy of ModuleComplement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModuleComplementCopyWith<_ModuleComplement> get copyWith => __$ModuleComplementCopyWithImpl<_ModuleComplement>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModuleComplement&&(identical(other.idModule, idModule) || other.idModule == idModule)&&(identical(other.uuidModuleComplement, uuidModuleComplement) || other.uuidModuleComplement == uuidModuleComplement)&&(identical(other.idListObserver, idListObserver) || other.idListObserver == idListObserver)&&(identical(other.idListTaxonomy, idListTaxonomy) || other.idListTaxonomy == idListTaxonomy)&&(identical(other.bSynthese, bSynthese) || other.bSynthese == bSynthese)&&(identical(other.taxonomyDisplayFieldName, taxonomyDisplayFieldName) || other.taxonomyDisplayFieldName == taxonomyDisplayFieldName)&&(identical(other.bDrawSitesGroup, bDrawSitesGroup) || other.bDrawSitesGroup == bDrawSitesGroup)&&(identical(other.data, data) || other.data == data)&&(identical(other.configuration, configuration) || other.configuration == configuration));
}


@override
int get hashCode => Object.hash(runtimeType,idModule,uuidModuleComplement,idListObserver,idListTaxonomy,bSynthese,taxonomyDisplayFieldName,bDrawSitesGroup,data,configuration);

@override
String toString() {
  return 'ModuleComplement(idModule: $idModule, uuidModuleComplement: $uuidModuleComplement, idListObserver: $idListObserver, idListTaxonomy: $idListTaxonomy, bSynthese: $bSynthese, taxonomyDisplayFieldName: $taxonomyDisplayFieldName, bDrawSitesGroup: $bDrawSitesGroup, data: $data, configuration: $configuration)';
}


}

/// @nodoc
abstract mixin class _$ModuleComplementCopyWith<$Res> implements $ModuleComplementCopyWith<$Res> {
  factory _$ModuleComplementCopyWith(_ModuleComplement value, $Res Function(_ModuleComplement) _then) = __$ModuleComplementCopyWithImpl;
@override @useResult
$Res call({
 int idModule, String? uuidModuleComplement, int? idListObserver, int? idListTaxonomy, bool bSynthese, String taxonomyDisplayFieldName, bool? bDrawSitesGroup, String? data, ModuleConfiguration? configuration
});


@override $ModuleConfigurationCopyWith<$Res>? get configuration;

}
/// @nodoc
class __$ModuleComplementCopyWithImpl<$Res>
    implements _$ModuleComplementCopyWith<$Res> {
  __$ModuleComplementCopyWithImpl(this._self, this._then);

  final _ModuleComplement _self;
  final $Res Function(_ModuleComplement) _then;

/// Create a copy of ModuleComplement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idModule = null,Object? uuidModuleComplement = freezed,Object? idListObserver = freezed,Object? idListTaxonomy = freezed,Object? bSynthese = null,Object? taxonomyDisplayFieldName = null,Object? bDrawSitesGroup = freezed,Object? data = freezed,Object? configuration = freezed,}) {
  return _then(_ModuleComplement(
idModule: null == idModule ? _self.idModule : idModule // ignore: cast_nullable_to_non_nullable
as int,uuidModuleComplement: freezed == uuidModuleComplement ? _self.uuidModuleComplement : uuidModuleComplement // ignore: cast_nullable_to_non_nullable
as String?,idListObserver: freezed == idListObserver ? _self.idListObserver : idListObserver // ignore: cast_nullable_to_non_nullable
as int?,idListTaxonomy: freezed == idListTaxonomy ? _self.idListTaxonomy : idListTaxonomy // ignore: cast_nullable_to_non_nullable
as int?,bSynthese: null == bSynthese ? _self.bSynthese : bSynthese // ignore: cast_nullable_to_non_nullable
as bool,taxonomyDisplayFieldName: null == taxonomyDisplayFieldName ? _self.taxonomyDisplayFieldName : taxonomyDisplayFieldName // ignore: cast_nullable_to_non_nullable
as String,bDrawSitesGroup: freezed == bDrawSitesGroup ? _self.bDrawSitesGroup : bDrawSitesGroup // ignore: cast_nullable_to_non_nullable
as bool?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as String?,configuration: freezed == configuration ? _self.configuration : configuration // ignore: cast_nullable_to_non_nullable
as ModuleConfiguration?,
  ));
}

/// Create a copy of ModuleComplement
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModuleConfigurationCopyWith<$Res>? get configuration {
    if (_self.configuration == null) {
    return null;
  }

  return $ModuleConfigurationCopyWith<$Res>(_self.configuration!, (value) {
    return _then(_self.copyWith(configuration: value));
  });
}
}

// dart format on
