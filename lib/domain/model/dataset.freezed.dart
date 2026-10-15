// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dataset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Dataset {

 int get id;// idDataset
 String get uniqueDatasetId;// UUID
 int get idAcquisitionFramework; String get datasetName; String get datasetShortname; String get datasetDesc; int get idNomenclatureDataType; String? get keywords; bool get marineDomain; bool get terrestrialDomain; int? get idNomenclatureDatasetObjectif;// absent depuis GeoNature 2.18 (#4103)
 double? get bboxWest; double? get bboxEast; double? get bboxSouth; double? get bboxNorth; int get idNomenclatureCollectingMethod; int get idNomenclatureDataOrigin; int get idNomenclatureSourceStatus; int get idNomenclatureResourceType; bool? get active; bool? get validable; int? get idDigitizer; int? get idTaxaList; DateTime? get metaCreateDate; DateTime? get metaUpdateDate;
/// Create a copy of Dataset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DatasetCopyWith<Dataset> get copyWith => _$DatasetCopyWithImpl<Dataset>(this as Dataset, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Dataset&&(identical(other.id, id) || other.id == id)&&(identical(other.uniqueDatasetId, uniqueDatasetId) || other.uniqueDatasetId == uniqueDatasetId)&&(identical(other.idAcquisitionFramework, idAcquisitionFramework) || other.idAcquisitionFramework == idAcquisitionFramework)&&(identical(other.datasetName, datasetName) || other.datasetName == datasetName)&&(identical(other.datasetShortname, datasetShortname) || other.datasetShortname == datasetShortname)&&(identical(other.datasetDesc, datasetDesc) || other.datasetDesc == datasetDesc)&&(identical(other.idNomenclatureDataType, idNomenclatureDataType) || other.idNomenclatureDataType == idNomenclatureDataType)&&(identical(other.keywords, keywords) || other.keywords == keywords)&&(identical(other.marineDomain, marineDomain) || other.marineDomain == marineDomain)&&(identical(other.terrestrialDomain, terrestrialDomain) || other.terrestrialDomain == terrestrialDomain)&&(identical(other.idNomenclatureDatasetObjectif, idNomenclatureDatasetObjectif) || other.idNomenclatureDatasetObjectif == idNomenclatureDatasetObjectif)&&(identical(other.bboxWest, bboxWest) || other.bboxWest == bboxWest)&&(identical(other.bboxEast, bboxEast) || other.bboxEast == bboxEast)&&(identical(other.bboxSouth, bboxSouth) || other.bboxSouth == bboxSouth)&&(identical(other.bboxNorth, bboxNorth) || other.bboxNorth == bboxNorth)&&(identical(other.idNomenclatureCollectingMethod, idNomenclatureCollectingMethod) || other.idNomenclatureCollectingMethod == idNomenclatureCollectingMethod)&&(identical(other.idNomenclatureDataOrigin, idNomenclatureDataOrigin) || other.idNomenclatureDataOrigin == idNomenclatureDataOrigin)&&(identical(other.idNomenclatureSourceStatus, idNomenclatureSourceStatus) || other.idNomenclatureSourceStatus == idNomenclatureSourceStatus)&&(identical(other.idNomenclatureResourceType, idNomenclatureResourceType) || other.idNomenclatureResourceType == idNomenclatureResourceType)&&(identical(other.active, active) || other.active == active)&&(identical(other.validable, validable) || other.validable == validable)&&(identical(other.idDigitizer, idDigitizer) || other.idDigitizer == idDigitizer)&&(identical(other.idTaxaList, idTaxaList) || other.idTaxaList == idTaxaList)&&(identical(other.metaCreateDate, metaCreateDate) || other.metaCreateDate == metaCreateDate)&&(identical(other.metaUpdateDate, metaUpdateDate) || other.metaUpdateDate == metaUpdateDate));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,uniqueDatasetId,idAcquisitionFramework,datasetName,datasetShortname,datasetDesc,idNomenclatureDataType,keywords,marineDomain,terrestrialDomain,idNomenclatureDatasetObjectif,bboxWest,bboxEast,bboxSouth,bboxNorth,idNomenclatureCollectingMethod,idNomenclatureDataOrigin,idNomenclatureSourceStatus,idNomenclatureResourceType,active,validable,idDigitizer,idTaxaList,metaCreateDate,metaUpdateDate]);

@override
String toString() {
  return 'Dataset(id: $id, uniqueDatasetId: $uniqueDatasetId, idAcquisitionFramework: $idAcquisitionFramework, datasetName: $datasetName, datasetShortname: $datasetShortname, datasetDesc: $datasetDesc, idNomenclatureDataType: $idNomenclatureDataType, keywords: $keywords, marineDomain: $marineDomain, terrestrialDomain: $terrestrialDomain, idNomenclatureDatasetObjectif: $idNomenclatureDatasetObjectif, bboxWest: $bboxWest, bboxEast: $bboxEast, bboxSouth: $bboxSouth, bboxNorth: $bboxNorth, idNomenclatureCollectingMethod: $idNomenclatureCollectingMethod, idNomenclatureDataOrigin: $idNomenclatureDataOrigin, idNomenclatureSourceStatus: $idNomenclatureSourceStatus, idNomenclatureResourceType: $idNomenclatureResourceType, active: $active, validable: $validable, idDigitizer: $idDigitizer, idTaxaList: $idTaxaList, metaCreateDate: $metaCreateDate, metaUpdateDate: $metaUpdateDate)';
}


}

/// @nodoc
abstract mixin class $DatasetCopyWith<$Res>  {
  factory $DatasetCopyWith(Dataset value, $Res Function(Dataset) _then) = _$DatasetCopyWithImpl;
@useResult
$Res call({
 int id, String uniqueDatasetId, int idAcquisitionFramework, String datasetName, String datasetShortname, String datasetDesc, int idNomenclatureDataType, String? keywords, bool marineDomain, bool terrestrialDomain, int? idNomenclatureDatasetObjectif, double? bboxWest, double? bboxEast, double? bboxSouth, double? bboxNorth, int idNomenclatureCollectingMethod, int idNomenclatureDataOrigin, int idNomenclatureSourceStatus, int idNomenclatureResourceType, bool? active, bool? validable, int? idDigitizer, int? idTaxaList, DateTime? metaCreateDate, DateTime? metaUpdateDate
});




}
/// @nodoc
class _$DatasetCopyWithImpl<$Res>
    implements $DatasetCopyWith<$Res> {
  _$DatasetCopyWithImpl(this._self, this._then);

  final Dataset _self;
  final $Res Function(Dataset) _then;

/// Create a copy of Dataset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? uniqueDatasetId = null,Object? idAcquisitionFramework = null,Object? datasetName = null,Object? datasetShortname = null,Object? datasetDesc = null,Object? idNomenclatureDataType = null,Object? keywords = freezed,Object? marineDomain = null,Object? terrestrialDomain = null,Object? idNomenclatureDatasetObjectif = freezed,Object? bboxWest = freezed,Object? bboxEast = freezed,Object? bboxSouth = freezed,Object? bboxNorth = freezed,Object? idNomenclatureCollectingMethod = null,Object? idNomenclatureDataOrigin = null,Object? idNomenclatureSourceStatus = null,Object? idNomenclatureResourceType = null,Object? active = freezed,Object? validable = freezed,Object? idDigitizer = freezed,Object? idTaxaList = freezed,Object? metaCreateDate = freezed,Object? metaUpdateDate = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,uniqueDatasetId: null == uniqueDatasetId ? _self.uniqueDatasetId : uniqueDatasetId // ignore: cast_nullable_to_non_nullable
as String,idAcquisitionFramework: null == idAcquisitionFramework ? _self.idAcquisitionFramework : idAcquisitionFramework // ignore: cast_nullable_to_non_nullable
as int,datasetName: null == datasetName ? _self.datasetName : datasetName // ignore: cast_nullable_to_non_nullable
as String,datasetShortname: null == datasetShortname ? _self.datasetShortname : datasetShortname // ignore: cast_nullable_to_non_nullable
as String,datasetDesc: null == datasetDesc ? _self.datasetDesc : datasetDesc // ignore: cast_nullable_to_non_nullable
as String,idNomenclatureDataType: null == idNomenclatureDataType ? _self.idNomenclatureDataType : idNomenclatureDataType // ignore: cast_nullable_to_non_nullable
as int,keywords: freezed == keywords ? _self.keywords : keywords // ignore: cast_nullable_to_non_nullable
as String?,marineDomain: null == marineDomain ? _self.marineDomain : marineDomain // ignore: cast_nullable_to_non_nullable
as bool,terrestrialDomain: null == terrestrialDomain ? _self.terrestrialDomain : terrestrialDomain // ignore: cast_nullable_to_non_nullable
as bool,idNomenclatureDatasetObjectif: freezed == idNomenclatureDatasetObjectif ? _self.idNomenclatureDatasetObjectif : idNomenclatureDatasetObjectif // ignore: cast_nullable_to_non_nullable
as int?,bboxWest: freezed == bboxWest ? _self.bboxWest : bboxWest // ignore: cast_nullable_to_non_nullable
as double?,bboxEast: freezed == bboxEast ? _self.bboxEast : bboxEast // ignore: cast_nullable_to_non_nullable
as double?,bboxSouth: freezed == bboxSouth ? _self.bboxSouth : bboxSouth // ignore: cast_nullable_to_non_nullable
as double?,bboxNorth: freezed == bboxNorth ? _self.bboxNorth : bboxNorth // ignore: cast_nullable_to_non_nullable
as double?,idNomenclatureCollectingMethod: null == idNomenclatureCollectingMethod ? _self.idNomenclatureCollectingMethod : idNomenclatureCollectingMethod // ignore: cast_nullable_to_non_nullable
as int,idNomenclatureDataOrigin: null == idNomenclatureDataOrigin ? _self.idNomenclatureDataOrigin : idNomenclatureDataOrigin // ignore: cast_nullable_to_non_nullable
as int,idNomenclatureSourceStatus: null == idNomenclatureSourceStatus ? _self.idNomenclatureSourceStatus : idNomenclatureSourceStatus // ignore: cast_nullable_to_non_nullable
as int,idNomenclatureResourceType: null == idNomenclatureResourceType ? _self.idNomenclatureResourceType : idNomenclatureResourceType // ignore: cast_nullable_to_non_nullable
as int,active: freezed == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool?,validable: freezed == validable ? _self.validable : validable // ignore: cast_nullable_to_non_nullable
as bool?,idDigitizer: freezed == idDigitizer ? _self.idDigitizer : idDigitizer // ignore: cast_nullable_to_non_nullable
as int?,idTaxaList: freezed == idTaxaList ? _self.idTaxaList : idTaxaList // ignore: cast_nullable_to_non_nullable
as int?,metaCreateDate: freezed == metaCreateDate ? _self.metaCreateDate : metaCreateDate // ignore: cast_nullable_to_non_nullable
as DateTime?,metaUpdateDate: freezed == metaUpdateDate ? _self.metaUpdateDate : metaUpdateDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Dataset].
extension DatasetPatterns on Dataset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Dataset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Dataset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Dataset value)  $default,){
final _that = this;
switch (_that) {
case _Dataset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Dataset value)?  $default,){
final _that = this;
switch (_that) {
case _Dataset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String uniqueDatasetId,  int idAcquisitionFramework,  String datasetName,  String datasetShortname,  String datasetDesc,  int idNomenclatureDataType,  String? keywords,  bool marineDomain,  bool terrestrialDomain,  int? idNomenclatureDatasetObjectif,  double? bboxWest,  double? bboxEast,  double? bboxSouth,  double? bboxNorth,  int idNomenclatureCollectingMethod,  int idNomenclatureDataOrigin,  int idNomenclatureSourceStatus,  int idNomenclatureResourceType,  bool? active,  bool? validable,  int? idDigitizer,  int? idTaxaList,  DateTime? metaCreateDate,  DateTime? metaUpdateDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Dataset() when $default != null:
return $default(_that.id,_that.uniqueDatasetId,_that.idAcquisitionFramework,_that.datasetName,_that.datasetShortname,_that.datasetDesc,_that.idNomenclatureDataType,_that.keywords,_that.marineDomain,_that.terrestrialDomain,_that.idNomenclatureDatasetObjectif,_that.bboxWest,_that.bboxEast,_that.bboxSouth,_that.bboxNorth,_that.idNomenclatureCollectingMethod,_that.idNomenclatureDataOrigin,_that.idNomenclatureSourceStatus,_that.idNomenclatureResourceType,_that.active,_that.validable,_that.idDigitizer,_that.idTaxaList,_that.metaCreateDate,_that.metaUpdateDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String uniqueDatasetId,  int idAcquisitionFramework,  String datasetName,  String datasetShortname,  String datasetDesc,  int idNomenclatureDataType,  String? keywords,  bool marineDomain,  bool terrestrialDomain,  int? idNomenclatureDatasetObjectif,  double? bboxWest,  double? bboxEast,  double? bboxSouth,  double? bboxNorth,  int idNomenclatureCollectingMethod,  int idNomenclatureDataOrigin,  int idNomenclatureSourceStatus,  int idNomenclatureResourceType,  bool? active,  bool? validable,  int? idDigitizer,  int? idTaxaList,  DateTime? metaCreateDate,  DateTime? metaUpdateDate)  $default,) {final _that = this;
switch (_that) {
case _Dataset():
return $default(_that.id,_that.uniqueDatasetId,_that.idAcquisitionFramework,_that.datasetName,_that.datasetShortname,_that.datasetDesc,_that.idNomenclatureDataType,_that.keywords,_that.marineDomain,_that.terrestrialDomain,_that.idNomenclatureDatasetObjectif,_that.bboxWest,_that.bboxEast,_that.bboxSouth,_that.bboxNorth,_that.idNomenclatureCollectingMethod,_that.idNomenclatureDataOrigin,_that.idNomenclatureSourceStatus,_that.idNomenclatureResourceType,_that.active,_that.validable,_that.idDigitizer,_that.idTaxaList,_that.metaCreateDate,_that.metaUpdateDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String uniqueDatasetId,  int idAcquisitionFramework,  String datasetName,  String datasetShortname,  String datasetDesc,  int idNomenclatureDataType,  String? keywords,  bool marineDomain,  bool terrestrialDomain,  int? idNomenclatureDatasetObjectif,  double? bboxWest,  double? bboxEast,  double? bboxSouth,  double? bboxNorth,  int idNomenclatureCollectingMethod,  int idNomenclatureDataOrigin,  int idNomenclatureSourceStatus,  int idNomenclatureResourceType,  bool? active,  bool? validable,  int? idDigitizer,  int? idTaxaList,  DateTime? metaCreateDate,  DateTime? metaUpdateDate)?  $default,) {final _that = this;
switch (_that) {
case _Dataset() when $default != null:
return $default(_that.id,_that.uniqueDatasetId,_that.idAcquisitionFramework,_that.datasetName,_that.datasetShortname,_that.datasetDesc,_that.idNomenclatureDataType,_that.keywords,_that.marineDomain,_that.terrestrialDomain,_that.idNomenclatureDatasetObjectif,_that.bboxWest,_that.bboxEast,_that.bboxSouth,_that.bboxNorth,_that.idNomenclatureCollectingMethod,_that.idNomenclatureDataOrigin,_that.idNomenclatureSourceStatus,_that.idNomenclatureResourceType,_that.active,_that.validable,_that.idDigitizer,_that.idTaxaList,_that.metaCreateDate,_that.metaUpdateDate);case _:
  return null;

}
}

}

/// @nodoc


class _Dataset implements Dataset {
  const _Dataset({required this.id, required this.uniqueDatasetId, required this.idAcquisitionFramework, required this.datasetName, required this.datasetShortname, required this.datasetDesc, required this.idNomenclatureDataType, this.keywords, required this.marineDomain, required this.terrestrialDomain, this.idNomenclatureDatasetObjectif, this.bboxWest, this.bboxEast, this.bboxSouth, this.bboxNorth, required this.idNomenclatureCollectingMethod, required this.idNomenclatureDataOrigin, required this.idNomenclatureSourceStatus, required this.idNomenclatureResourceType, this.active, this.validable, this.idDigitizer, this.idTaxaList, this.metaCreateDate, this.metaUpdateDate});
  

@override final  int id;
// idDataset
@override final  String uniqueDatasetId;
// UUID
@override final  int idAcquisitionFramework;
@override final  String datasetName;
@override final  String datasetShortname;
@override final  String datasetDesc;
@override final  int idNomenclatureDataType;
@override final  String? keywords;
@override final  bool marineDomain;
@override final  bool terrestrialDomain;
@override final  int? idNomenclatureDatasetObjectif;
// absent depuis GeoNature 2.18 (#4103)
@override final  double? bboxWest;
@override final  double? bboxEast;
@override final  double? bboxSouth;
@override final  double? bboxNorth;
@override final  int idNomenclatureCollectingMethod;
@override final  int idNomenclatureDataOrigin;
@override final  int idNomenclatureSourceStatus;
@override final  int idNomenclatureResourceType;
@override final  bool? active;
@override final  bool? validable;
@override final  int? idDigitizer;
@override final  int? idTaxaList;
@override final  DateTime? metaCreateDate;
@override final  DateTime? metaUpdateDate;

/// Create a copy of Dataset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DatasetCopyWith<_Dataset> get copyWith => __$DatasetCopyWithImpl<_Dataset>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Dataset&&(identical(other.id, id) || other.id == id)&&(identical(other.uniqueDatasetId, uniqueDatasetId) || other.uniqueDatasetId == uniqueDatasetId)&&(identical(other.idAcquisitionFramework, idAcquisitionFramework) || other.idAcquisitionFramework == idAcquisitionFramework)&&(identical(other.datasetName, datasetName) || other.datasetName == datasetName)&&(identical(other.datasetShortname, datasetShortname) || other.datasetShortname == datasetShortname)&&(identical(other.datasetDesc, datasetDesc) || other.datasetDesc == datasetDesc)&&(identical(other.idNomenclatureDataType, idNomenclatureDataType) || other.idNomenclatureDataType == idNomenclatureDataType)&&(identical(other.keywords, keywords) || other.keywords == keywords)&&(identical(other.marineDomain, marineDomain) || other.marineDomain == marineDomain)&&(identical(other.terrestrialDomain, terrestrialDomain) || other.terrestrialDomain == terrestrialDomain)&&(identical(other.idNomenclatureDatasetObjectif, idNomenclatureDatasetObjectif) || other.idNomenclatureDatasetObjectif == idNomenclatureDatasetObjectif)&&(identical(other.bboxWest, bboxWest) || other.bboxWest == bboxWest)&&(identical(other.bboxEast, bboxEast) || other.bboxEast == bboxEast)&&(identical(other.bboxSouth, bboxSouth) || other.bboxSouth == bboxSouth)&&(identical(other.bboxNorth, bboxNorth) || other.bboxNorth == bboxNorth)&&(identical(other.idNomenclatureCollectingMethod, idNomenclatureCollectingMethod) || other.idNomenclatureCollectingMethod == idNomenclatureCollectingMethod)&&(identical(other.idNomenclatureDataOrigin, idNomenclatureDataOrigin) || other.idNomenclatureDataOrigin == idNomenclatureDataOrigin)&&(identical(other.idNomenclatureSourceStatus, idNomenclatureSourceStatus) || other.idNomenclatureSourceStatus == idNomenclatureSourceStatus)&&(identical(other.idNomenclatureResourceType, idNomenclatureResourceType) || other.idNomenclatureResourceType == idNomenclatureResourceType)&&(identical(other.active, active) || other.active == active)&&(identical(other.validable, validable) || other.validable == validable)&&(identical(other.idDigitizer, idDigitizer) || other.idDigitizer == idDigitizer)&&(identical(other.idTaxaList, idTaxaList) || other.idTaxaList == idTaxaList)&&(identical(other.metaCreateDate, metaCreateDate) || other.metaCreateDate == metaCreateDate)&&(identical(other.metaUpdateDate, metaUpdateDate) || other.metaUpdateDate == metaUpdateDate));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,uniqueDatasetId,idAcquisitionFramework,datasetName,datasetShortname,datasetDesc,idNomenclatureDataType,keywords,marineDomain,terrestrialDomain,idNomenclatureDatasetObjectif,bboxWest,bboxEast,bboxSouth,bboxNorth,idNomenclatureCollectingMethod,idNomenclatureDataOrigin,idNomenclatureSourceStatus,idNomenclatureResourceType,active,validable,idDigitizer,idTaxaList,metaCreateDate,metaUpdateDate]);

@override
String toString() {
  return 'Dataset(id: $id, uniqueDatasetId: $uniqueDatasetId, idAcquisitionFramework: $idAcquisitionFramework, datasetName: $datasetName, datasetShortname: $datasetShortname, datasetDesc: $datasetDesc, idNomenclatureDataType: $idNomenclatureDataType, keywords: $keywords, marineDomain: $marineDomain, terrestrialDomain: $terrestrialDomain, idNomenclatureDatasetObjectif: $idNomenclatureDatasetObjectif, bboxWest: $bboxWest, bboxEast: $bboxEast, bboxSouth: $bboxSouth, bboxNorth: $bboxNorth, idNomenclatureCollectingMethod: $idNomenclatureCollectingMethod, idNomenclatureDataOrigin: $idNomenclatureDataOrigin, idNomenclatureSourceStatus: $idNomenclatureSourceStatus, idNomenclatureResourceType: $idNomenclatureResourceType, active: $active, validable: $validable, idDigitizer: $idDigitizer, idTaxaList: $idTaxaList, metaCreateDate: $metaCreateDate, metaUpdateDate: $metaUpdateDate)';
}


}

/// @nodoc
abstract mixin class _$DatasetCopyWith<$Res> implements $DatasetCopyWith<$Res> {
  factory _$DatasetCopyWith(_Dataset value, $Res Function(_Dataset) _then) = __$DatasetCopyWithImpl;
@override @useResult
$Res call({
 int id, String uniqueDatasetId, int idAcquisitionFramework, String datasetName, String datasetShortname, String datasetDesc, int idNomenclatureDataType, String? keywords, bool marineDomain, bool terrestrialDomain, int? idNomenclatureDatasetObjectif, double? bboxWest, double? bboxEast, double? bboxSouth, double? bboxNorth, int idNomenclatureCollectingMethod, int idNomenclatureDataOrigin, int idNomenclatureSourceStatus, int idNomenclatureResourceType, bool? active, bool? validable, int? idDigitizer, int? idTaxaList, DateTime? metaCreateDate, DateTime? metaUpdateDate
});




}
/// @nodoc
class __$DatasetCopyWithImpl<$Res>
    implements _$DatasetCopyWith<$Res> {
  __$DatasetCopyWithImpl(this._self, this._then);

  final _Dataset _self;
  final $Res Function(_Dataset) _then;

/// Create a copy of Dataset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? uniqueDatasetId = null,Object? idAcquisitionFramework = null,Object? datasetName = null,Object? datasetShortname = null,Object? datasetDesc = null,Object? idNomenclatureDataType = null,Object? keywords = freezed,Object? marineDomain = null,Object? terrestrialDomain = null,Object? idNomenclatureDatasetObjectif = freezed,Object? bboxWest = freezed,Object? bboxEast = freezed,Object? bboxSouth = freezed,Object? bboxNorth = freezed,Object? idNomenclatureCollectingMethod = null,Object? idNomenclatureDataOrigin = null,Object? idNomenclatureSourceStatus = null,Object? idNomenclatureResourceType = null,Object? active = freezed,Object? validable = freezed,Object? idDigitizer = freezed,Object? idTaxaList = freezed,Object? metaCreateDate = freezed,Object? metaUpdateDate = freezed,}) {
  return _then(_Dataset(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,uniqueDatasetId: null == uniqueDatasetId ? _self.uniqueDatasetId : uniqueDatasetId // ignore: cast_nullable_to_non_nullable
as String,idAcquisitionFramework: null == idAcquisitionFramework ? _self.idAcquisitionFramework : idAcquisitionFramework // ignore: cast_nullable_to_non_nullable
as int,datasetName: null == datasetName ? _self.datasetName : datasetName // ignore: cast_nullable_to_non_nullable
as String,datasetShortname: null == datasetShortname ? _self.datasetShortname : datasetShortname // ignore: cast_nullable_to_non_nullable
as String,datasetDesc: null == datasetDesc ? _self.datasetDesc : datasetDesc // ignore: cast_nullable_to_non_nullable
as String,idNomenclatureDataType: null == idNomenclatureDataType ? _self.idNomenclatureDataType : idNomenclatureDataType // ignore: cast_nullable_to_non_nullable
as int,keywords: freezed == keywords ? _self.keywords : keywords // ignore: cast_nullable_to_non_nullable
as String?,marineDomain: null == marineDomain ? _self.marineDomain : marineDomain // ignore: cast_nullable_to_non_nullable
as bool,terrestrialDomain: null == terrestrialDomain ? _self.terrestrialDomain : terrestrialDomain // ignore: cast_nullable_to_non_nullable
as bool,idNomenclatureDatasetObjectif: freezed == idNomenclatureDatasetObjectif ? _self.idNomenclatureDatasetObjectif : idNomenclatureDatasetObjectif // ignore: cast_nullable_to_non_nullable
as int?,bboxWest: freezed == bboxWest ? _self.bboxWest : bboxWest // ignore: cast_nullable_to_non_nullable
as double?,bboxEast: freezed == bboxEast ? _self.bboxEast : bboxEast // ignore: cast_nullable_to_non_nullable
as double?,bboxSouth: freezed == bboxSouth ? _self.bboxSouth : bboxSouth // ignore: cast_nullable_to_non_nullable
as double?,bboxNorth: freezed == bboxNorth ? _self.bboxNorth : bboxNorth // ignore: cast_nullable_to_non_nullable
as double?,idNomenclatureCollectingMethod: null == idNomenclatureCollectingMethod ? _self.idNomenclatureCollectingMethod : idNomenclatureCollectingMethod // ignore: cast_nullable_to_non_nullable
as int,idNomenclatureDataOrigin: null == idNomenclatureDataOrigin ? _self.idNomenclatureDataOrigin : idNomenclatureDataOrigin // ignore: cast_nullable_to_non_nullable
as int,idNomenclatureSourceStatus: null == idNomenclatureSourceStatus ? _self.idNomenclatureSourceStatus : idNomenclatureSourceStatus // ignore: cast_nullable_to_non_nullable
as int,idNomenclatureResourceType: null == idNomenclatureResourceType ? _self.idNomenclatureResourceType : idNomenclatureResourceType // ignore: cast_nullable_to_non_nullable
as int,active: freezed == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool?,validable: freezed == validable ? _self.validable : validable // ignore: cast_nullable_to_non_nullable
as bool?,idDigitizer: freezed == idDigitizer ? _self.idDigitizer : idDigitizer // ignore: cast_nullable_to_non_nullable
as int?,idTaxaList: freezed == idTaxaList ? _self.idTaxaList : idTaxaList // ignore: cast_nullable_to_non_nullable
as int?,metaCreateDate: freezed == metaCreateDate ? _self.metaCreateDate : metaCreateDate // ignore: cast_nullable_to_non_nullable
as DateTime?,metaUpdateDate: freezed == metaUpdateDate ? _self.metaUpdateDate : metaUpdateDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
