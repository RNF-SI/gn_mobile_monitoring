// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nomenclature.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Nomenclature {

 int get id; int get idType; String get cdNomenclature; String? get mnemonique; String? get codeType;// Ajout du champ code_type
 String? get labelDefault; String? get definitionDefault; String? get labelFr; String? get definitionFr; String? get labelEn; String? get definitionEn; String? get labelEs; String? get definitionEs; String? get labelDe; String? get definitionDe; String? get labelIt; String? get definitionIt; String? get source; String? get statut; int? get idBroader; String? get hierarchy; bool? get active; DateTime? get metaCreateDate; DateTime? get metaUpdateDate;
/// Create a copy of Nomenclature
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NomenclatureCopyWith<Nomenclature> get copyWith => _$NomenclatureCopyWithImpl<Nomenclature>(this as Nomenclature, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Nomenclature&&(identical(other.id, id) || other.id == id)&&(identical(other.idType, idType) || other.idType == idType)&&(identical(other.cdNomenclature, cdNomenclature) || other.cdNomenclature == cdNomenclature)&&(identical(other.mnemonique, mnemonique) || other.mnemonique == mnemonique)&&(identical(other.codeType, codeType) || other.codeType == codeType)&&(identical(other.labelDefault, labelDefault) || other.labelDefault == labelDefault)&&(identical(other.definitionDefault, definitionDefault) || other.definitionDefault == definitionDefault)&&(identical(other.labelFr, labelFr) || other.labelFr == labelFr)&&(identical(other.definitionFr, definitionFr) || other.definitionFr == definitionFr)&&(identical(other.labelEn, labelEn) || other.labelEn == labelEn)&&(identical(other.definitionEn, definitionEn) || other.definitionEn == definitionEn)&&(identical(other.labelEs, labelEs) || other.labelEs == labelEs)&&(identical(other.definitionEs, definitionEs) || other.definitionEs == definitionEs)&&(identical(other.labelDe, labelDe) || other.labelDe == labelDe)&&(identical(other.definitionDe, definitionDe) || other.definitionDe == definitionDe)&&(identical(other.labelIt, labelIt) || other.labelIt == labelIt)&&(identical(other.definitionIt, definitionIt) || other.definitionIt == definitionIt)&&(identical(other.source, source) || other.source == source)&&(identical(other.statut, statut) || other.statut == statut)&&(identical(other.idBroader, idBroader) || other.idBroader == idBroader)&&(identical(other.hierarchy, hierarchy) || other.hierarchy == hierarchy)&&(identical(other.active, active) || other.active == active)&&(identical(other.metaCreateDate, metaCreateDate) || other.metaCreateDate == metaCreateDate)&&(identical(other.metaUpdateDate, metaUpdateDate) || other.metaUpdateDate == metaUpdateDate));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,idType,cdNomenclature,mnemonique,codeType,labelDefault,definitionDefault,labelFr,definitionFr,labelEn,definitionEn,labelEs,definitionEs,labelDe,definitionDe,labelIt,definitionIt,source,statut,idBroader,hierarchy,active,metaCreateDate,metaUpdateDate]);

@override
String toString() {
  return 'Nomenclature(id: $id, idType: $idType, cdNomenclature: $cdNomenclature, mnemonique: $mnemonique, codeType: $codeType, labelDefault: $labelDefault, definitionDefault: $definitionDefault, labelFr: $labelFr, definitionFr: $definitionFr, labelEn: $labelEn, definitionEn: $definitionEn, labelEs: $labelEs, definitionEs: $definitionEs, labelDe: $labelDe, definitionDe: $definitionDe, labelIt: $labelIt, definitionIt: $definitionIt, source: $source, statut: $statut, idBroader: $idBroader, hierarchy: $hierarchy, active: $active, metaCreateDate: $metaCreateDate, metaUpdateDate: $metaUpdateDate)';
}


}

/// @nodoc
abstract mixin class $NomenclatureCopyWith<$Res>  {
  factory $NomenclatureCopyWith(Nomenclature value, $Res Function(Nomenclature) _then) = _$NomenclatureCopyWithImpl;
@useResult
$Res call({
 int id, int idType, String cdNomenclature, String? mnemonique, String? codeType, String? labelDefault, String? definitionDefault, String? labelFr, String? definitionFr, String? labelEn, String? definitionEn, String? labelEs, String? definitionEs, String? labelDe, String? definitionDe, String? labelIt, String? definitionIt, String? source, String? statut, int? idBroader, String? hierarchy, bool? active, DateTime? metaCreateDate, DateTime? metaUpdateDate
});




}
/// @nodoc
class _$NomenclatureCopyWithImpl<$Res>
    implements $NomenclatureCopyWith<$Res> {
  _$NomenclatureCopyWithImpl(this._self, this._then);

  final Nomenclature _self;
  final $Res Function(Nomenclature) _then;

/// Create a copy of Nomenclature
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? idType = null,Object? cdNomenclature = null,Object? mnemonique = freezed,Object? codeType = freezed,Object? labelDefault = freezed,Object? definitionDefault = freezed,Object? labelFr = freezed,Object? definitionFr = freezed,Object? labelEn = freezed,Object? definitionEn = freezed,Object? labelEs = freezed,Object? definitionEs = freezed,Object? labelDe = freezed,Object? definitionDe = freezed,Object? labelIt = freezed,Object? definitionIt = freezed,Object? source = freezed,Object? statut = freezed,Object? idBroader = freezed,Object? hierarchy = freezed,Object? active = freezed,Object? metaCreateDate = freezed,Object? metaUpdateDate = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,idType: null == idType ? _self.idType : idType // ignore: cast_nullable_to_non_nullable
as int,cdNomenclature: null == cdNomenclature ? _self.cdNomenclature : cdNomenclature // ignore: cast_nullable_to_non_nullable
as String,mnemonique: freezed == mnemonique ? _self.mnemonique : mnemonique // ignore: cast_nullable_to_non_nullable
as String?,codeType: freezed == codeType ? _self.codeType : codeType // ignore: cast_nullable_to_non_nullable
as String?,labelDefault: freezed == labelDefault ? _self.labelDefault : labelDefault // ignore: cast_nullable_to_non_nullable
as String?,definitionDefault: freezed == definitionDefault ? _self.definitionDefault : definitionDefault // ignore: cast_nullable_to_non_nullable
as String?,labelFr: freezed == labelFr ? _self.labelFr : labelFr // ignore: cast_nullable_to_non_nullable
as String?,definitionFr: freezed == definitionFr ? _self.definitionFr : definitionFr // ignore: cast_nullable_to_non_nullable
as String?,labelEn: freezed == labelEn ? _self.labelEn : labelEn // ignore: cast_nullable_to_non_nullable
as String?,definitionEn: freezed == definitionEn ? _self.definitionEn : definitionEn // ignore: cast_nullable_to_non_nullable
as String?,labelEs: freezed == labelEs ? _self.labelEs : labelEs // ignore: cast_nullable_to_non_nullable
as String?,definitionEs: freezed == definitionEs ? _self.definitionEs : definitionEs // ignore: cast_nullable_to_non_nullable
as String?,labelDe: freezed == labelDe ? _self.labelDe : labelDe // ignore: cast_nullable_to_non_nullable
as String?,definitionDe: freezed == definitionDe ? _self.definitionDe : definitionDe // ignore: cast_nullable_to_non_nullable
as String?,labelIt: freezed == labelIt ? _self.labelIt : labelIt // ignore: cast_nullable_to_non_nullable
as String?,definitionIt: freezed == definitionIt ? _self.definitionIt : definitionIt // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,statut: freezed == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String?,idBroader: freezed == idBroader ? _self.idBroader : idBroader // ignore: cast_nullable_to_non_nullable
as int?,hierarchy: freezed == hierarchy ? _self.hierarchy : hierarchy // ignore: cast_nullable_to_non_nullable
as String?,active: freezed == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool?,metaCreateDate: freezed == metaCreateDate ? _self.metaCreateDate : metaCreateDate // ignore: cast_nullable_to_non_nullable
as DateTime?,metaUpdateDate: freezed == metaUpdateDate ? _self.metaUpdateDate : metaUpdateDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Nomenclature].
extension NomenclaturePatterns on Nomenclature {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Nomenclature value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Nomenclature() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Nomenclature value)  $default,){
final _that = this;
switch (_that) {
case _Nomenclature():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Nomenclature value)?  $default,){
final _that = this;
switch (_that) {
case _Nomenclature() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int idType,  String cdNomenclature,  String? mnemonique,  String? codeType,  String? labelDefault,  String? definitionDefault,  String? labelFr,  String? definitionFr,  String? labelEn,  String? definitionEn,  String? labelEs,  String? definitionEs,  String? labelDe,  String? definitionDe,  String? labelIt,  String? definitionIt,  String? source,  String? statut,  int? idBroader,  String? hierarchy,  bool? active,  DateTime? metaCreateDate,  DateTime? metaUpdateDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Nomenclature() when $default != null:
return $default(_that.id,_that.idType,_that.cdNomenclature,_that.mnemonique,_that.codeType,_that.labelDefault,_that.definitionDefault,_that.labelFr,_that.definitionFr,_that.labelEn,_that.definitionEn,_that.labelEs,_that.definitionEs,_that.labelDe,_that.definitionDe,_that.labelIt,_that.definitionIt,_that.source,_that.statut,_that.idBroader,_that.hierarchy,_that.active,_that.metaCreateDate,_that.metaUpdateDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int idType,  String cdNomenclature,  String? mnemonique,  String? codeType,  String? labelDefault,  String? definitionDefault,  String? labelFr,  String? definitionFr,  String? labelEn,  String? definitionEn,  String? labelEs,  String? definitionEs,  String? labelDe,  String? definitionDe,  String? labelIt,  String? definitionIt,  String? source,  String? statut,  int? idBroader,  String? hierarchy,  bool? active,  DateTime? metaCreateDate,  DateTime? metaUpdateDate)  $default,) {final _that = this;
switch (_that) {
case _Nomenclature():
return $default(_that.id,_that.idType,_that.cdNomenclature,_that.mnemonique,_that.codeType,_that.labelDefault,_that.definitionDefault,_that.labelFr,_that.definitionFr,_that.labelEn,_that.definitionEn,_that.labelEs,_that.definitionEs,_that.labelDe,_that.definitionDe,_that.labelIt,_that.definitionIt,_that.source,_that.statut,_that.idBroader,_that.hierarchy,_that.active,_that.metaCreateDate,_that.metaUpdateDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int idType,  String cdNomenclature,  String? mnemonique,  String? codeType,  String? labelDefault,  String? definitionDefault,  String? labelFr,  String? definitionFr,  String? labelEn,  String? definitionEn,  String? labelEs,  String? definitionEs,  String? labelDe,  String? definitionDe,  String? labelIt,  String? definitionIt,  String? source,  String? statut,  int? idBroader,  String? hierarchy,  bool? active,  DateTime? metaCreateDate,  DateTime? metaUpdateDate)?  $default,) {final _that = this;
switch (_that) {
case _Nomenclature() when $default != null:
return $default(_that.id,_that.idType,_that.cdNomenclature,_that.mnemonique,_that.codeType,_that.labelDefault,_that.definitionDefault,_that.labelFr,_that.definitionFr,_that.labelEn,_that.definitionEn,_that.labelEs,_that.definitionEs,_that.labelDe,_that.definitionDe,_that.labelIt,_that.definitionIt,_that.source,_that.statut,_that.idBroader,_that.hierarchy,_that.active,_that.metaCreateDate,_that.metaUpdateDate);case _:
  return null;

}
}

}

/// @nodoc


class _Nomenclature implements Nomenclature {
  const _Nomenclature({required this.id, required this.idType, required this.cdNomenclature, this.mnemonique, this.codeType, this.labelDefault, this.definitionDefault, this.labelFr, this.definitionFr, this.labelEn, this.definitionEn, this.labelEs, this.definitionEs, this.labelDe, this.definitionDe, this.labelIt, this.definitionIt, this.source, this.statut, this.idBroader, this.hierarchy, this.active, this.metaCreateDate, this.metaUpdateDate});
  

@override final  int id;
@override final  int idType;
@override final  String cdNomenclature;
@override final  String? mnemonique;
@override final  String? codeType;
// Ajout du champ code_type
@override final  String? labelDefault;
@override final  String? definitionDefault;
@override final  String? labelFr;
@override final  String? definitionFr;
@override final  String? labelEn;
@override final  String? definitionEn;
@override final  String? labelEs;
@override final  String? definitionEs;
@override final  String? labelDe;
@override final  String? definitionDe;
@override final  String? labelIt;
@override final  String? definitionIt;
@override final  String? source;
@override final  String? statut;
@override final  int? idBroader;
@override final  String? hierarchy;
@override final  bool? active;
@override final  DateTime? metaCreateDate;
@override final  DateTime? metaUpdateDate;

/// Create a copy of Nomenclature
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NomenclatureCopyWith<_Nomenclature> get copyWith => __$NomenclatureCopyWithImpl<_Nomenclature>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Nomenclature&&(identical(other.id, id) || other.id == id)&&(identical(other.idType, idType) || other.idType == idType)&&(identical(other.cdNomenclature, cdNomenclature) || other.cdNomenclature == cdNomenclature)&&(identical(other.mnemonique, mnemonique) || other.mnemonique == mnemonique)&&(identical(other.codeType, codeType) || other.codeType == codeType)&&(identical(other.labelDefault, labelDefault) || other.labelDefault == labelDefault)&&(identical(other.definitionDefault, definitionDefault) || other.definitionDefault == definitionDefault)&&(identical(other.labelFr, labelFr) || other.labelFr == labelFr)&&(identical(other.definitionFr, definitionFr) || other.definitionFr == definitionFr)&&(identical(other.labelEn, labelEn) || other.labelEn == labelEn)&&(identical(other.definitionEn, definitionEn) || other.definitionEn == definitionEn)&&(identical(other.labelEs, labelEs) || other.labelEs == labelEs)&&(identical(other.definitionEs, definitionEs) || other.definitionEs == definitionEs)&&(identical(other.labelDe, labelDe) || other.labelDe == labelDe)&&(identical(other.definitionDe, definitionDe) || other.definitionDe == definitionDe)&&(identical(other.labelIt, labelIt) || other.labelIt == labelIt)&&(identical(other.definitionIt, definitionIt) || other.definitionIt == definitionIt)&&(identical(other.source, source) || other.source == source)&&(identical(other.statut, statut) || other.statut == statut)&&(identical(other.idBroader, idBroader) || other.idBroader == idBroader)&&(identical(other.hierarchy, hierarchy) || other.hierarchy == hierarchy)&&(identical(other.active, active) || other.active == active)&&(identical(other.metaCreateDate, metaCreateDate) || other.metaCreateDate == metaCreateDate)&&(identical(other.metaUpdateDate, metaUpdateDate) || other.metaUpdateDate == metaUpdateDate));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,idType,cdNomenclature,mnemonique,codeType,labelDefault,definitionDefault,labelFr,definitionFr,labelEn,definitionEn,labelEs,definitionEs,labelDe,definitionDe,labelIt,definitionIt,source,statut,idBroader,hierarchy,active,metaCreateDate,metaUpdateDate]);

@override
String toString() {
  return 'Nomenclature(id: $id, idType: $idType, cdNomenclature: $cdNomenclature, mnemonique: $mnemonique, codeType: $codeType, labelDefault: $labelDefault, definitionDefault: $definitionDefault, labelFr: $labelFr, definitionFr: $definitionFr, labelEn: $labelEn, definitionEn: $definitionEn, labelEs: $labelEs, definitionEs: $definitionEs, labelDe: $labelDe, definitionDe: $definitionDe, labelIt: $labelIt, definitionIt: $definitionIt, source: $source, statut: $statut, idBroader: $idBroader, hierarchy: $hierarchy, active: $active, metaCreateDate: $metaCreateDate, metaUpdateDate: $metaUpdateDate)';
}


}

/// @nodoc
abstract mixin class _$NomenclatureCopyWith<$Res> implements $NomenclatureCopyWith<$Res> {
  factory _$NomenclatureCopyWith(_Nomenclature value, $Res Function(_Nomenclature) _then) = __$NomenclatureCopyWithImpl;
@override @useResult
$Res call({
 int id, int idType, String cdNomenclature, String? mnemonique, String? codeType, String? labelDefault, String? definitionDefault, String? labelFr, String? definitionFr, String? labelEn, String? definitionEn, String? labelEs, String? definitionEs, String? labelDe, String? definitionDe, String? labelIt, String? definitionIt, String? source, String? statut, int? idBroader, String? hierarchy, bool? active, DateTime? metaCreateDate, DateTime? metaUpdateDate
});




}
/// @nodoc
class __$NomenclatureCopyWithImpl<$Res>
    implements _$NomenclatureCopyWith<$Res> {
  __$NomenclatureCopyWithImpl(this._self, this._then);

  final _Nomenclature _self;
  final $Res Function(_Nomenclature) _then;

/// Create a copy of Nomenclature
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? idType = null,Object? cdNomenclature = null,Object? mnemonique = freezed,Object? codeType = freezed,Object? labelDefault = freezed,Object? definitionDefault = freezed,Object? labelFr = freezed,Object? definitionFr = freezed,Object? labelEn = freezed,Object? definitionEn = freezed,Object? labelEs = freezed,Object? definitionEs = freezed,Object? labelDe = freezed,Object? definitionDe = freezed,Object? labelIt = freezed,Object? definitionIt = freezed,Object? source = freezed,Object? statut = freezed,Object? idBroader = freezed,Object? hierarchy = freezed,Object? active = freezed,Object? metaCreateDate = freezed,Object? metaUpdateDate = freezed,}) {
  return _then(_Nomenclature(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,idType: null == idType ? _self.idType : idType // ignore: cast_nullable_to_non_nullable
as int,cdNomenclature: null == cdNomenclature ? _self.cdNomenclature : cdNomenclature // ignore: cast_nullable_to_non_nullable
as String,mnemonique: freezed == mnemonique ? _self.mnemonique : mnemonique // ignore: cast_nullable_to_non_nullable
as String?,codeType: freezed == codeType ? _self.codeType : codeType // ignore: cast_nullable_to_non_nullable
as String?,labelDefault: freezed == labelDefault ? _self.labelDefault : labelDefault // ignore: cast_nullable_to_non_nullable
as String?,definitionDefault: freezed == definitionDefault ? _self.definitionDefault : definitionDefault // ignore: cast_nullable_to_non_nullable
as String?,labelFr: freezed == labelFr ? _self.labelFr : labelFr // ignore: cast_nullable_to_non_nullable
as String?,definitionFr: freezed == definitionFr ? _self.definitionFr : definitionFr // ignore: cast_nullable_to_non_nullable
as String?,labelEn: freezed == labelEn ? _self.labelEn : labelEn // ignore: cast_nullable_to_non_nullable
as String?,definitionEn: freezed == definitionEn ? _self.definitionEn : definitionEn // ignore: cast_nullable_to_non_nullable
as String?,labelEs: freezed == labelEs ? _self.labelEs : labelEs // ignore: cast_nullable_to_non_nullable
as String?,definitionEs: freezed == definitionEs ? _self.definitionEs : definitionEs // ignore: cast_nullable_to_non_nullable
as String?,labelDe: freezed == labelDe ? _self.labelDe : labelDe // ignore: cast_nullable_to_non_nullable
as String?,definitionDe: freezed == definitionDe ? _self.definitionDe : definitionDe // ignore: cast_nullable_to_non_nullable
as String?,labelIt: freezed == labelIt ? _self.labelIt : labelIt // ignore: cast_nullable_to_non_nullable
as String?,definitionIt: freezed == definitionIt ? _self.definitionIt : definitionIt // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,statut: freezed == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String?,idBroader: freezed == idBroader ? _self.idBroader : idBroader // ignore: cast_nullable_to_non_nullable
as int?,hierarchy: freezed == hierarchy ? _self.hierarchy : hierarchy // ignore: cast_nullable_to_non_nullable
as String?,active: freezed == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool?,metaCreateDate: freezed == metaCreateDate ? _self.metaCreateDate : metaCreateDate // ignore: cast_nullable_to_non_nullable
as DateTime?,metaUpdateDate: freezed == metaUpdateDate ? _self.metaUpdateDate : metaUpdateDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
