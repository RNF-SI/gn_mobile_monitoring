// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'module.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Module {

 int get id; String? get moduleCode; String? get moduleLabel; String? get modulePicto; String? get moduleDesc; String? get moduleGroup; String? get modulePath; String? get moduleExternalUrl; String? get moduleTarget; String? get moduleComment; bool? get activeFrontend; bool? get activeBackend; String? get moduleDocUrl; int? get moduleOrder; String? get ngModule; DateTime? get metaCreateDate; DateTime? get metaUpdateDate; bool? get downloaded; ModuleComplement? get complement; List<SiteGroup>? get sitesGroup; List<BaseSite>? get sites;
/// Create a copy of Module
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModuleCopyWith<Module> get copyWith => _$ModuleCopyWithImpl<Module>(this as Module, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Module&&(identical(other.id, id) || other.id == id)&&(identical(other.moduleCode, moduleCode) || other.moduleCode == moduleCode)&&(identical(other.moduleLabel, moduleLabel) || other.moduleLabel == moduleLabel)&&(identical(other.modulePicto, modulePicto) || other.modulePicto == modulePicto)&&(identical(other.moduleDesc, moduleDesc) || other.moduleDesc == moduleDesc)&&(identical(other.moduleGroup, moduleGroup) || other.moduleGroup == moduleGroup)&&(identical(other.modulePath, modulePath) || other.modulePath == modulePath)&&(identical(other.moduleExternalUrl, moduleExternalUrl) || other.moduleExternalUrl == moduleExternalUrl)&&(identical(other.moduleTarget, moduleTarget) || other.moduleTarget == moduleTarget)&&(identical(other.moduleComment, moduleComment) || other.moduleComment == moduleComment)&&(identical(other.activeFrontend, activeFrontend) || other.activeFrontend == activeFrontend)&&(identical(other.activeBackend, activeBackend) || other.activeBackend == activeBackend)&&(identical(other.moduleDocUrl, moduleDocUrl) || other.moduleDocUrl == moduleDocUrl)&&(identical(other.moduleOrder, moduleOrder) || other.moduleOrder == moduleOrder)&&(identical(other.ngModule, ngModule) || other.ngModule == ngModule)&&(identical(other.metaCreateDate, metaCreateDate) || other.metaCreateDate == metaCreateDate)&&(identical(other.metaUpdateDate, metaUpdateDate) || other.metaUpdateDate == metaUpdateDate)&&(identical(other.downloaded, downloaded) || other.downloaded == downloaded)&&(identical(other.complement, complement) || other.complement == complement)&&const DeepCollectionEquality().equals(other.sitesGroup, sitesGroup)&&const DeepCollectionEquality().equals(other.sites, sites));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,moduleCode,moduleLabel,modulePicto,moduleDesc,moduleGroup,modulePath,moduleExternalUrl,moduleTarget,moduleComment,activeFrontend,activeBackend,moduleDocUrl,moduleOrder,ngModule,metaCreateDate,metaUpdateDate,downloaded,complement,const DeepCollectionEquality().hash(sitesGroup),const DeepCollectionEquality().hash(sites)]);

@override
String toString() {
  return 'Module(id: $id, moduleCode: $moduleCode, moduleLabel: $moduleLabel, modulePicto: $modulePicto, moduleDesc: $moduleDesc, moduleGroup: $moduleGroup, modulePath: $modulePath, moduleExternalUrl: $moduleExternalUrl, moduleTarget: $moduleTarget, moduleComment: $moduleComment, activeFrontend: $activeFrontend, activeBackend: $activeBackend, moduleDocUrl: $moduleDocUrl, moduleOrder: $moduleOrder, ngModule: $ngModule, metaCreateDate: $metaCreateDate, metaUpdateDate: $metaUpdateDate, downloaded: $downloaded, complement: $complement, sitesGroup: $sitesGroup, sites: $sites)';
}


}

/// @nodoc
abstract mixin class $ModuleCopyWith<$Res>  {
  factory $ModuleCopyWith(Module value, $Res Function(Module) _then) = _$ModuleCopyWithImpl;
@useResult
$Res call({
 int id, String? moduleCode, String? moduleLabel, String? modulePicto, String? moduleDesc, String? moduleGroup, String? modulePath, String? moduleExternalUrl, String? moduleTarget, String? moduleComment, bool? activeFrontend, bool? activeBackend, String? moduleDocUrl, int? moduleOrder, String? ngModule, DateTime? metaCreateDate, DateTime? metaUpdateDate, bool? downloaded, ModuleComplement? complement, List<SiteGroup>? sitesGroup, List<BaseSite>? sites
});


$ModuleComplementCopyWith<$Res>? get complement;

}
/// @nodoc
class _$ModuleCopyWithImpl<$Res>
    implements $ModuleCopyWith<$Res> {
  _$ModuleCopyWithImpl(this._self, this._then);

  final Module _self;
  final $Res Function(Module) _then;

/// Create a copy of Module
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? moduleCode = freezed,Object? moduleLabel = freezed,Object? modulePicto = freezed,Object? moduleDesc = freezed,Object? moduleGroup = freezed,Object? modulePath = freezed,Object? moduleExternalUrl = freezed,Object? moduleTarget = freezed,Object? moduleComment = freezed,Object? activeFrontend = freezed,Object? activeBackend = freezed,Object? moduleDocUrl = freezed,Object? moduleOrder = freezed,Object? ngModule = freezed,Object? metaCreateDate = freezed,Object? metaUpdateDate = freezed,Object? downloaded = freezed,Object? complement = freezed,Object? sitesGroup = freezed,Object? sites = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,moduleCode: freezed == moduleCode ? _self.moduleCode : moduleCode // ignore: cast_nullable_to_non_nullable
as String?,moduleLabel: freezed == moduleLabel ? _self.moduleLabel : moduleLabel // ignore: cast_nullable_to_non_nullable
as String?,modulePicto: freezed == modulePicto ? _self.modulePicto : modulePicto // ignore: cast_nullable_to_non_nullable
as String?,moduleDesc: freezed == moduleDesc ? _self.moduleDesc : moduleDesc // ignore: cast_nullable_to_non_nullable
as String?,moduleGroup: freezed == moduleGroup ? _self.moduleGroup : moduleGroup // ignore: cast_nullable_to_non_nullable
as String?,modulePath: freezed == modulePath ? _self.modulePath : modulePath // ignore: cast_nullable_to_non_nullable
as String?,moduleExternalUrl: freezed == moduleExternalUrl ? _self.moduleExternalUrl : moduleExternalUrl // ignore: cast_nullable_to_non_nullable
as String?,moduleTarget: freezed == moduleTarget ? _self.moduleTarget : moduleTarget // ignore: cast_nullable_to_non_nullable
as String?,moduleComment: freezed == moduleComment ? _self.moduleComment : moduleComment // ignore: cast_nullable_to_non_nullable
as String?,activeFrontend: freezed == activeFrontend ? _self.activeFrontend : activeFrontend // ignore: cast_nullable_to_non_nullable
as bool?,activeBackend: freezed == activeBackend ? _self.activeBackend : activeBackend // ignore: cast_nullable_to_non_nullable
as bool?,moduleDocUrl: freezed == moduleDocUrl ? _self.moduleDocUrl : moduleDocUrl // ignore: cast_nullable_to_non_nullable
as String?,moduleOrder: freezed == moduleOrder ? _self.moduleOrder : moduleOrder // ignore: cast_nullable_to_non_nullable
as int?,ngModule: freezed == ngModule ? _self.ngModule : ngModule // ignore: cast_nullable_to_non_nullable
as String?,metaCreateDate: freezed == metaCreateDate ? _self.metaCreateDate : metaCreateDate // ignore: cast_nullable_to_non_nullable
as DateTime?,metaUpdateDate: freezed == metaUpdateDate ? _self.metaUpdateDate : metaUpdateDate // ignore: cast_nullable_to_non_nullable
as DateTime?,downloaded: freezed == downloaded ? _self.downloaded : downloaded // ignore: cast_nullable_to_non_nullable
as bool?,complement: freezed == complement ? _self.complement : complement // ignore: cast_nullable_to_non_nullable
as ModuleComplement?,sitesGroup: freezed == sitesGroup ? _self.sitesGroup : sitesGroup // ignore: cast_nullable_to_non_nullable
as List<SiteGroup>?,sites: freezed == sites ? _self.sites : sites // ignore: cast_nullable_to_non_nullable
as List<BaseSite>?,
  ));
}
/// Create a copy of Module
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModuleComplementCopyWith<$Res>? get complement {
    if (_self.complement == null) {
    return null;
  }

  return $ModuleComplementCopyWith<$Res>(_self.complement!, (value) {
    return _then(_self.copyWith(complement: value));
  });
}
}


/// Adds pattern-matching-related methods to [Module].
extension ModulePatterns on Module {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Module value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Module() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Module value)  $default,){
final _that = this;
switch (_that) {
case _Module():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Module value)?  $default,){
final _that = this;
switch (_that) {
case _Module() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? moduleCode,  String? moduleLabel,  String? modulePicto,  String? moduleDesc,  String? moduleGroup,  String? modulePath,  String? moduleExternalUrl,  String? moduleTarget,  String? moduleComment,  bool? activeFrontend,  bool? activeBackend,  String? moduleDocUrl,  int? moduleOrder,  String? ngModule,  DateTime? metaCreateDate,  DateTime? metaUpdateDate,  bool? downloaded,  ModuleComplement? complement,  List<SiteGroup>? sitesGroup,  List<BaseSite>? sites)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Module() when $default != null:
return $default(_that.id,_that.moduleCode,_that.moduleLabel,_that.modulePicto,_that.moduleDesc,_that.moduleGroup,_that.modulePath,_that.moduleExternalUrl,_that.moduleTarget,_that.moduleComment,_that.activeFrontend,_that.activeBackend,_that.moduleDocUrl,_that.moduleOrder,_that.ngModule,_that.metaCreateDate,_that.metaUpdateDate,_that.downloaded,_that.complement,_that.sitesGroup,_that.sites);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? moduleCode,  String? moduleLabel,  String? modulePicto,  String? moduleDesc,  String? moduleGroup,  String? modulePath,  String? moduleExternalUrl,  String? moduleTarget,  String? moduleComment,  bool? activeFrontend,  bool? activeBackend,  String? moduleDocUrl,  int? moduleOrder,  String? ngModule,  DateTime? metaCreateDate,  DateTime? metaUpdateDate,  bool? downloaded,  ModuleComplement? complement,  List<SiteGroup>? sitesGroup,  List<BaseSite>? sites)  $default,) {final _that = this;
switch (_that) {
case _Module():
return $default(_that.id,_that.moduleCode,_that.moduleLabel,_that.modulePicto,_that.moduleDesc,_that.moduleGroup,_that.modulePath,_that.moduleExternalUrl,_that.moduleTarget,_that.moduleComment,_that.activeFrontend,_that.activeBackend,_that.moduleDocUrl,_that.moduleOrder,_that.ngModule,_that.metaCreateDate,_that.metaUpdateDate,_that.downloaded,_that.complement,_that.sitesGroup,_that.sites);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? moduleCode,  String? moduleLabel,  String? modulePicto,  String? moduleDesc,  String? moduleGroup,  String? modulePath,  String? moduleExternalUrl,  String? moduleTarget,  String? moduleComment,  bool? activeFrontend,  bool? activeBackend,  String? moduleDocUrl,  int? moduleOrder,  String? ngModule,  DateTime? metaCreateDate,  DateTime? metaUpdateDate,  bool? downloaded,  ModuleComplement? complement,  List<SiteGroup>? sitesGroup,  List<BaseSite>? sites)?  $default,) {final _that = this;
switch (_that) {
case _Module() when $default != null:
return $default(_that.id,_that.moduleCode,_that.moduleLabel,_that.modulePicto,_that.moduleDesc,_that.moduleGroup,_that.modulePath,_that.moduleExternalUrl,_that.moduleTarget,_that.moduleComment,_that.activeFrontend,_that.activeBackend,_that.moduleDocUrl,_that.moduleOrder,_that.ngModule,_that.metaCreateDate,_that.metaUpdateDate,_that.downloaded,_that.complement,_that.sitesGroup,_that.sites);case _:
  return null;

}
}

}

/// @nodoc


class _Module implements Module {
  const _Module({required this.id, this.moduleCode, this.moduleLabel, this.modulePicto, this.moduleDesc, this.moduleGroup, this.modulePath, this.moduleExternalUrl, this.moduleTarget, this.moduleComment, this.activeFrontend, this.activeBackend, this.moduleDocUrl, this.moduleOrder, this.ngModule, this.metaCreateDate, this.metaUpdateDate, this.downloaded, this.complement, final  List<SiteGroup>? sitesGroup, final  List<BaseSite>? sites}): _sitesGroup = sitesGroup,_sites = sites;
  

@override final  int id;
@override final  String? moduleCode;
@override final  String? moduleLabel;
@override final  String? modulePicto;
@override final  String? moduleDesc;
@override final  String? moduleGroup;
@override final  String? modulePath;
@override final  String? moduleExternalUrl;
@override final  String? moduleTarget;
@override final  String? moduleComment;
@override final  bool? activeFrontend;
@override final  bool? activeBackend;
@override final  String? moduleDocUrl;
@override final  int? moduleOrder;
@override final  String? ngModule;
@override final  DateTime? metaCreateDate;
@override final  DateTime? metaUpdateDate;
@override final  bool? downloaded;
@override final  ModuleComplement? complement;
 final  List<SiteGroup>? _sitesGroup;
@override List<SiteGroup>? get sitesGroup {
  final value = _sitesGroup;
  if (value == null) return null;
  if (_sitesGroup is EqualUnmodifiableListView) return _sitesGroup;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<BaseSite>? _sites;
@override List<BaseSite>? get sites {
  final value = _sites;
  if (value == null) return null;
  if (_sites is EqualUnmodifiableListView) return _sites;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of Module
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModuleCopyWith<_Module> get copyWith => __$ModuleCopyWithImpl<_Module>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Module&&(identical(other.id, id) || other.id == id)&&(identical(other.moduleCode, moduleCode) || other.moduleCode == moduleCode)&&(identical(other.moduleLabel, moduleLabel) || other.moduleLabel == moduleLabel)&&(identical(other.modulePicto, modulePicto) || other.modulePicto == modulePicto)&&(identical(other.moduleDesc, moduleDesc) || other.moduleDesc == moduleDesc)&&(identical(other.moduleGroup, moduleGroup) || other.moduleGroup == moduleGroup)&&(identical(other.modulePath, modulePath) || other.modulePath == modulePath)&&(identical(other.moduleExternalUrl, moduleExternalUrl) || other.moduleExternalUrl == moduleExternalUrl)&&(identical(other.moduleTarget, moduleTarget) || other.moduleTarget == moduleTarget)&&(identical(other.moduleComment, moduleComment) || other.moduleComment == moduleComment)&&(identical(other.activeFrontend, activeFrontend) || other.activeFrontend == activeFrontend)&&(identical(other.activeBackend, activeBackend) || other.activeBackend == activeBackend)&&(identical(other.moduleDocUrl, moduleDocUrl) || other.moduleDocUrl == moduleDocUrl)&&(identical(other.moduleOrder, moduleOrder) || other.moduleOrder == moduleOrder)&&(identical(other.ngModule, ngModule) || other.ngModule == ngModule)&&(identical(other.metaCreateDate, metaCreateDate) || other.metaCreateDate == metaCreateDate)&&(identical(other.metaUpdateDate, metaUpdateDate) || other.metaUpdateDate == metaUpdateDate)&&(identical(other.downloaded, downloaded) || other.downloaded == downloaded)&&(identical(other.complement, complement) || other.complement == complement)&&const DeepCollectionEquality().equals(other._sitesGroup, _sitesGroup)&&const DeepCollectionEquality().equals(other._sites, _sites));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,moduleCode,moduleLabel,modulePicto,moduleDesc,moduleGroup,modulePath,moduleExternalUrl,moduleTarget,moduleComment,activeFrontend,activeBackend,moduleDocUrl,moduleOrder,ngModule,metaCreateDate,metaUpdateDate,downloaded,complement,const DeepCollectionEquality().hash(_sitesGroup),const DeepCollectionEquality().hash(_sites)]);

@override
String toString() {
  return 'Module(id: $id, moduleCode: $moduleCode, moduleLabel: $moduleLabel, modulePicto: $modulePicto, moduleDesc: $moduleDesc, moduleGroup: $moduleGroup, modulePath: $modulePath, moduleExternalUrl: $moduleExternalUrl, moduleTarget: $moduleTarget, moduleComment: $moduleComment, activeFrontend: $activeFrontend, activeBackend: $activeBackend, moduleDocUrl: $moduleDocUrl, moduleOrder: $moduleOrder, ngModule: $ngModule, metaCreateDate: $metaCreateDate, metaUpdateDate: $metaUpdateDate, downloaded: $downloaded, complement: $complement, sitesGroup: $sitesGroup, sites: $sites)';
}


}

/// @nodoc
abstract mixin class _$ModuleCopyWith<$Res> implements $ModuleCopyWith<$Res> {
  factory _$ModuleCopyWith(_Module value, $Res Function(_Module) _then) = __$ModuleCopyWithImpl;
@override @useResult
$Res call({
 int id, String? moduleCode, String? moduleLabel, String? modulePicto, String? moduleDesc, String? moduleGroup, String? modulePath, String? moduleExternalUrl, String? moduleTarget, String? moduleComment, bool? activeFrontend, bool? activeBackend, String? moduleDocUrl, int? moduleOrder, String? ngModule, DateTime? metaCreateDate, DateTime? metaUpdateDate, bool? downloaded, ModuleComplement? complement, List<SiteGroup>? sitesGroup, List<BaseSite>? sites
});


@override $ModuleComplementCopyWith<$Res>? get complement;

}
/// @nodoc
class __$ModuleCopyWithImpl<$Res>
    implements _$ModuleCopyWith<$Res> {
  __$ModuleCopyWithImpl(this._self, this._then);

  final _Module _self;
  final $Res Function(_Module) _then;

/// Create a copy of Module
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? moduleCode = freezed,Object? moduleLabel = freezed,Object? modulePicto = freezed,Object? moduleDesc = freezed,Object? moduleGroup = freezed,Object? modulePath = freezed,Object? moduleExternalUrl = freezed,Object? moduleTarget = freezed,Object? moduleComment = freezed,Object? activeFrontend = freezed,Object? activeBackend = freezed,Object? moduleDocUrl = freezed,Object? moduleOrder = freezed,Object? ngModule = freezed,Object? metaCreateDate = freezed,Object? metaUpdateDate = freezed,Object? downloaded = freezed,Object? complement = freezed,Object? sitesGroup = freezed,Object? sites = freezed,}) {
  return _then(_Module(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,moduleCode: freezed == moduleCode ? _self.moduleCode : moduleCode // ignore: cast_nullable_to_non_nullable
as String?,moduleLabel: freezed == moduleLabel ? _self.moduleLabel : moduleLabel // ignore: cast_nullable_to_non_nullable
as String?,modulePicto: freezed == modulePicto ? _self.modulePicto : modulePicto // ignore: cast_nullable_to_non_nullable
as String?,moduleDesc: freezed == moduleDesc ? _self.moduleDesc : moduleDesc // ignore: cast_nullable_to_non_nullable
as String?,moduleGroup: freezed == moduleGroup ? _self.moduleGroup : moduleGroup // ignore: cast_nullable_to_non_nullable
as String?,modulePath: freezed == modulePath ? _self.modulePath : modulePath // ignore: cast_nullable_to_non_nullable
as String?,moduleExternalUrl: freezed == moduleExternalUrl ? _self.moduleExternalUrl : moduleExternalUrl // ignore: cast_nullable_to_non_nullable
as String?,moduleTarget: freezed == moduleTarget ? _self.moduleTarget : moduleTarget // ignore: cast_nullable_to_non_nullable
as String?,moduleComment: freezed == moduleComment ? _self.moduleComment : moduleComment // ignore: cast_nullable_to_non_nullable
as String?,activeFrontend: freezed == activeFrontend ? _self.activeFrontend : activeFrontend // ignore: cast_nullable_to_non_nullable
as bool?,activeBackend: freezed == activeBackend ? _self.activeBackend : activeBackend // ignore: cast_nullable_to_non_nullable
as bool?,moduleDocUrl: freezed == moduleDocUrl ? _self.moduleDocUrl : moduleDocUrl // ignore: cast_nullable_to_non_nullable
as String?,moduleOrder: freezed == moduleOrder ? _self.moduleOrder : moduleOrder // ignore: cast_nullable_to_non_nullable
as int?,ngModule: freezed == ngModule ? _self.ngModule : ngModule // ignore: cast_nullable_to_non_nullable
as String?,metaCreateDate: freezed == metaCreateDate ? _self.metaCreateDate : metaCreateDate // ignore: cast_nullable_to_non_nullable
as DateTime?,metaUpdateDate: freezed == metaUpdateDate ? _self.metaUpdateDate : metaUpdateDate // ignore: cast_nullable_to_non_nullable
as DateTime?,downloaded: freezed == downloaded ? _self.downloaded : downloaded // ignore: cast_nullable_to_non_nullable
as bool?,complement: freezed == complement ? _self.complement : complement // ignore: cast_nullable_to_non_nullable
as ModuleComplement?,sitesGroup: freezed == sitesGroup ? _self._sitesGroup : sitesGroup // ignore: cast_nullable_to_non_nullable
as List<SiteGroup>?,sites: freezed == sites ? _self._sites : sites // ignore: cast_nullable_to_non_nullable
as List<BaseSite>?,
  ));
}

/// Create a copy of Module
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModuleComplementCopyWith<$Res>? get complement {
    if (_self.complement == null) {
    return null;
  }

  return $ModuleComplementCopyWith<$Res>(_self.complement!, (value) {
    return _then(_self.copyWith(complement: value));
  });
}
}

// dart format on
