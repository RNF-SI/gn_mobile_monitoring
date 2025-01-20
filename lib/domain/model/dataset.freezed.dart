// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dataset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Dataset {
  int get id => throw _privateConstructorUsedError; // idDataset
  String get uniqueDatasetId => throw _privateConstructorUsedError; // UUID
  int get idAcquisitionFramework => throw _privateConstructorUsedError;
  String get datasetName => throw _privateConstructorUsedError;
  String get datasetShortname => throw _privateConstructorUsedError;
  String get datasetDesc => throw _privateConstructorUsedError;
  int get idNomenclatureDataType => throw _privateConstructorUsedError;
  String? get keywords => throw _privateConstructorUsedError;
  bool get marineDomain => throw _privateConstructorUsedError;
  bool get terrestrialDomain => throw _privateConstructorUsedError;
  int get idNomenclatureDatasetObjectif => throw _privateConstructorUsedError;
  double? get bboxWest => throw _privateConstructorUsedError;
  double? get bboxEast => throw _privateConstructorUsedError;
  double? get bboxSouth => throw _privateConstructorUsedError;
  double? get bboxNorth => throw _privateConstructorUsedError;
  int get idNomenclatureCollectingMethod => throw _privateConstructorUsedError;
  int get idNomenclatureDataOrigin => throw _privateConstructorUsedError;
  int get idNomenclatureSourceStatus => throw _privateConstructorUsedError;
  int get idNomenclatureResourceType => throw _privateConstructorUsedError;
  bool? get active => throw _privateConstructorUsedError;
  bool? get validable => throw _privateConstructorUsedError;
  int? get idDigitizer => throw _privateConstructorUsedError;
  int? get idTaxaList => throw _privateConstructorUsedError;
  DateTime? get metaCreateDate => throw _privateConstructorUsedError;
  DateTime? get metaUpdateDate => throw _privateConstructorUsedError;

  /// Create a copy of Dataset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DatasetCopyWith<Dataset> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DatasetCopyWith<$Res> {
  factory $DatasetCopyWith(Dataset value, $Res Function(Dataset) then) =
      _$DatasetCopyWithImpl<$Res, Dataset>;
  @useResult
  $Res call(
      {int id,
      String uniqueDatasetId,
      int idAcquisitionFramework,
      String datasetName,
      String datasetShortname,
      String datasetDesc,
      int idNomenclatureDataType,
      String? keywords,
      bool marineDomain,
      bool terrestrialDomain,
      int idNomenclatureDatasetObjectif,
      double? bboxWest,
      double? bboxEast,
      double? bboxSouth,
      double? bboxNorth,
      int idNomenclatureCollectingMethod,
      int idNomenclatureDataOrigin,
      int idNomenclatureSourceStatus,
      int idNomenclatureResourceType,
      bool? active,
      bool? validable,
      int? idDigitizer,
      int? idTaxaList,
      DateTime? metaCreateDate,
      DateTime? metaUpdateDate});
}

/// @nodoc
class _$DatasetCopyWithImpl<$Res, $Val extends Dataset>
    implements $DatasetCopyWith<$Res> {
  _$DatasetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Dataset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uniqueDatasetId = null,
    Object? idAcquisitionFramework = null,
    Object? datasetName = null,
    Object? datasetShortname = null,
    Object? datasetDesc = null,
    Object? idNomenclatureDataType = null,
    Object? keywords = freezed,
    Object? marineDomain = null,
    Object? terrestrialDomain = null,
    Object? idNomenclatureDatasetObjectif = null,
    Object? bboxWest = freezed,
    Object? bboxEast = freezed,
    Object? bboxSouth = freezed,
    Object? bboxNorth = freezed,
    Object? idNomenclatureCollectingMethod = null,
    Object? idNomenclatureDataOrigin = null,
    Object? idNomenclatureSourceStatus = null,
    Object? idNomenclatureResourceType = null,
    Object? active = freezed,
    Object? validable = freezed,
    Object? idDigitizer = freezed,
    Object? idTaxaList = freezed,
    Object? metaCreateDate = freezed,
    Object? metaUpdateDate = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      uniqueDatasetId: null == uniqueDatasetId
          ? _value.uniqueDatasetId
          : uniqueDatasetId // ignore: cast_nullable_to_non_nullable
              as String,
      idAcquisitionFramework: null == idAcquisitionFramework
          ? _value.idAcquisitionFramework
          : idAcquisitionFramework // ignore: cast_nullable_to_non_nullable
              as int,
      datasetName: null == datasetName
          ? _value.datasetName
          : datasetName // ignore: cast_nullable_to_non_nullable
              as String,
      datasetShortname: null == datasetShortname
          ? _value.datasetShortname
          : datasetShortname // ignore: cast_nullable_to_non_nullable
              as String,
      datasetDesc: null == datasetDesc
          ? _value.datasetDesc
          : datasetDesc // ignore: cast_nullable_to_non_nullable
              as String,
      idNomenclatureDataType: null == idNomenclatureDataType
          ? _value.idNomenclatureDataType
          : idNomenclatureDataType // ignore: cast_nullable_to_non_nullable
              as int,
      keywords: freezed == keywords
          ? _value.keywords
          : keywords // ignore: cast_nullable_to_non_nullable
              as String?,
      marineDomain: null == marineDomain
          ? _value.marineDomain
          : marineDomain // ignore: cast_nullable_to_non_nullable
              as bool,
      terrestrialDomain: null == terrestrialDomain
          ? _value.terrestrialDomain
          : terrestrialDomain // ignore: cast_nullable_to_non_nullable
              as bool,
      idNomenclatureDatasetObjectif: null == idNomenclatureDatasetObjectif
          ? _value.idNomenclatureDatasetObjectif
          : idNomenclatureDatasetObjectif // ignore: cast_nullable_to_non_nullable
              as int,
      bboxWest: freezed == bboxWest
          ? _value.bboxWest
          : bboxWest // ignore: cast_nullable_to_non_nullable
              as double?,
      bboxEast: freezed == bboxEast
          ? _value.bboxEast
          : bboxEast // ignore: cast_nullable_to_non_nullable
              as double?,
      bboxSouth: freezed == bboxSouth
          ? _value.bboxSouth
          : bboxSouth // ignore: cast_nullable_to_non_nullable
              as double?,
      bboxNorth: freezed == bboxNorth
          ? _value.bboxNorth
          : bboxNorth // ignore: cast_nullable_to_non_nullable
              as double?,
      idNomenclatureCollectingMethod: null == idNomenclatureCollectingMethod
          ? _value.idNomenclatureCollectingMethod
          : idNomenclatureCollectingMethod // ignore: cast_nullable_to_non_nullable
              as int,
      idNomenclatureDataOrigin: null == idNomenclatureDataOrigin
          ? _value.idNomenclatureDataOrigin
          : idNomenclatureDataOrigin // ignore: cast_nullable_to_non_nullable
              as int,
      idNomenclatureSourceStatus: null == idNomenclatureSourceStatus
          ? _value.idNomenclatureSourceStatus
          : idNomenclatureSourceStatus // ignore: cast_nullable_to_non_nullable
              as int,
      idNomenclatureResourceType: null == idNomenclatureResourceType
          ? _value.idNomenclatureResourceType
          : idNomenclatureResourceType // ignore: cast_nullable_to_non_nullable
              as int,
      active: freezed == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool?,
      validable: freezed == validable
          ? _value.validable
          : validable // ignore: cast_nullable_to_non_nullable
              as bool?,
      idDigitizer: freezed == idDigitizer
          ? _value.idDigitizer
          : idDigitizer // ignore: cast_nullable_to_non_nullable
              as int?,
      idTaxaList: freezed == idTaxaList
          ? _value.idTaxaList
          : idTaxaList // ignore: cast_nullable_to_non_nullable
              as int?,
      metaCreateDate: freezed == metaCreateDate
          ? _value.metaCreateDate
          : metaCreateDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metaUpdateDate: freezed == metaUpdateDate
          ? _value.metaUpdateDate
          : metaUpdateDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DatasetImplCopyWith<$Res> implements $DatasetCopyWith<$Res> {
  factory _$$DatasetImplCopyWith(
          _$DatasetImpl value, $Res Function(_$DatasetImpl) then) =
      __$$DatasetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String uniqueDatasetId,
      int idAcquisitionFramework,
      String datasetName,
      String datasetShortname,
      String datasetDesc,
      int idNomenclatureDataType,
      String? keywords,
      bool marineDomain,
      bool terrestrialDomain,
      int idNomenclatureDatasetObjectif,
      double? bboxWest,
      double? bboxEast,
      double? bboxSouth,
      double? bboxNorth,
      int idNomenclatureCollectingMethod,
      int idNomenclatureDataOrigin,
      int idNomenclatureSourceStatus,
      int idNomenclatureResourceType,
      bool? active,
      bool? validable,
      int? idDigitizer,
      int? idTaxaList,
      DateTime? metaCreateDate,
      DateTime? metaUpdateDate});
}

/// @nodoc
class __$$DatasetImplCopyWithImpl<$Res>
    extends _$DatasetCopyWithImpl<$Res, _$DatasetImpl>
    implements _$$DatasetImplCopyWith<$Res> {
  __$$DatasetImplCopyWithImpl(
      _$DatasetImpl _value, $Res Function(_$DatasetImpl) _then)
      : super(_value, _then);

  /// Create a copy of Dataset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uniqueDatasetId = null,
    Object? idAcquisitionFramework = null,
    Object? datasetName = null,
    Object? datasetShortname = null,
    Object? datasetDesc = null,
    Object? idNomenclatureDataType = null,
    Object? keywords = freezed,
    Object? marineDomain = null,
    Object? terrestrialDomain = null,
    Object? idNomenclatureDatasetObjectif = null,
    Object? bboxWest = freezed,
    Object? bboxEast = freezed,
    Object? bboxSouth = freezed,
    Object? bboxNorth = freezed,
    Object? idNomenclatureCollectingMethod = null,
    Object? idNomenclatureDataOrigin = null,
    Object? idNomenclatureSourceStatus = null,
    Object? idNomenclatureResourceType = null,
    Object? active = freezed,
    Object? validable = freezed,
    Object? idDigitizer = freezed,
    Object? idTaxaList = freezed,
    Object? metaCreateDate = freezed,
    Object? metaUpdateDate = freezed,
  }) {
    return _then(_$DatasetImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      uniqueDatasetId: null == uniqueDatasetId
          ? _value.uniqueDatasetId
          : uniqueDatasetId // ignore: cast_nullable_to_non_nullable
              as String,
      idAcquisitionFramework: null == idAcquisitionFramework
          ? _value.idAcquisitionFramework
          : idAcquisitionFramework // ignore: cast_nullable_to_non_nullable
              as int,
      datasetName: null == datasetName
          ? _value.datasetName
          : datasetName // ignore: cast_nullable_to_non_nullable
              as String,
      datasetShortname: null == datasetShortname
          ? _value.datasetShortname
          : datasetShortname // ignore: cast_nullable_to_non_nullable
              as String,
      datasetDesc: null == datasetDesc
          ? _value.datasetDesc
          : datasetDesc // ignore: cast_nullable_to_non_nullable
              as String,
      idNomenclatureDataType: null == idNomenclatureDataType
          ? _value.idNomenclatureDataType
          : idNomenclatureDataType // ignore: cast_nullable_to_non_nullable
              as int,
      keywords: freezed == keywords
          ? _value.keywords
          : keywords // ignore: cast_nullable_to_non_nullable
              as String?,
      marineDomain: null == marineDomain
          ? _value.marineDomain
          : marineDomain // ignore: cast_nullable_to_non_nullable
              as bool,
      terrestrialDomain: null == terrestrialDomain
          ? _value.terrestrialDomain
          : terrestrialDomain // ignore: cast_nullable_to_non_nullable
              as bool,
      idNomenclatureDatasetObjectif: null == idNomenclatureDatasetObjectif
          ? _value.idNomenclatureDatasetObjectif
          : idNomenclatureDatasetObjectif // ignore: cast_nullable_to_non_nullable
              as int,
      bboxWest: freezed == bboxWest
          ? _value.bboxWest
          : bboxWest // ignore: cast_nullable_to_non_nullable
              as double?,
      bboxEast: freezed == bboxEast
          ? _value.bboxEast
          : bboxEast // ignore: cast_nullable_to_non_nullable
              as double?,
      bboxSouth: freezed == bboxSouth
          ? _value.bboxSouth
          : bboxSouth // ignore: cast_nullable_to_non_nullable
              as double?,
      bboxNorth: freezed == bboxNorth
          ? _value.bboxNorth
          : bboxNorth // ignore: cast_nullable_to_non_nullable
              as double?,
      idNomenclatureCollectingMethod: null == idNomenclatureCollectingMethod
          ? _value.idNomenclatureCollectingMethod
          : idNomenclatureCollectingMethod // ignore: cast_nullable_to_non_nullable
              as int,
      idNomenclatureDataOrigin: null == idNomenclatureDataOrigin
          ? _value.idNomenclatureDataOrigin
          : idNomenclatureDataOrigin // ignore: cast_nullable_to_non_nullable
              as int,
      idNomenclatureSourceStatus: null == idNomenclatureSourceStatus
          ? _value.idNomenclatureSourceStatus
          : idNomenclatureSourceStatus // ignore: cast_nullable_to_non_nullable
              as int,
      idNomenclatureResourceType: null == idNomenclatureResourceType
          ? _value.idNomenclatureResourceType
          : idNomenclatureResourceType // ignore: cast_nullable_to_non_nullable
              as int,
      active: freezed == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool?,
      validable: freezed == validable
          ? _value.validable
          : validable // ignore: cast_nullable_to_non_nullable
              as bool?,
      idDigitizer: freezed == idDigitizer
          ? _value.idDigitizer
          : idDigitizer // ignore: cast_nullable_to_non_nullable
              as int?,
      idTaxaList: freezed == idTaxaList
          ? _value.idTaxaList
          : idTaxaList // ignore: cast_nullable_to_non_nullable
              as int?,
      metaCreateDate: freezed == metaCreateDate
          ? _value.metaCreateDate
          : metaCreateDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metaUpdateDate: freezed == metaUpdateDate
          ? _value.metaUpdateDate
          : metaUpdateDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$DatasetImpl implements _Dataset {
  const _$DatasetImpl(
      {required this.id,
      required this.uniqueDatasetId,
      required this.idAcquisitionFramework,
      required this.datasetName,
      required this.datasetShortname,
      required this.datasetDesc,
      required this.idNomenclatureDataType,
      this.keywords,
      required this.marineDomain,
      required this.terrestrialDomain,
      required this.idNomenclatureDatasetObjectif,
      this.bboxWest,
      this.bboxEast,
      this.bboxSouth,
      this.bboxNorth,
      required this.idNomenclatureCollectingMethod,
      required this.idNomenclatureDataOrigin,
      required this.idNomenclatureSourceStatus,
      required this.idNomenclatureResourceType,
      this.active,
      this.validable,
      this.idDigitizer,
      this.idTaxaList,
      this.metaCreateDate,
      this.metaUpdateDate});

  @override
  final int id;
// idDataset
  @override
  final String uniqueDatasetId;
// UUID
  @override
  final int idAcquisitionFramework;
  @override
  final String datasetName;
  @override
  final String datasetShortname;
  @override
  final String datasetDesc;
  @override
  final int idNomenclatureDataType;
  @override
  final String? keywords;
  @override
  final bool marineDomain;
  @override
  final bool terrestrialDomain;
  @override
  final int idNomenclatureDatasetObjectif;
  @override
  final double? bboxWest;
  @override
  final double? bboxEast;
  @override
  final double? bboxSouth;
  @override
  final double? bboxNorth;
  @override
  final int idNomenclatureCollectingMethod;
  @override
  final int idNomenclatureDataOrigin;
  @override
  final int idNomenclatureSourceStatus;
  @override
  final int idNomenclatureResourceType;
  @override
  final bool? active;
  @override
  final bool? validable;
  @override
  final int? idDigitizer;
  @override
  final int? idTaxaList;
  @override
  final DateTime? metaCreateDate;
  @override
  final DateTime? metaUpdateDate;

  @override
  String toString() {
    return 'Dataset(id: $id, uniqueDatasetId: $uniqueDatasetId, idAcquisitionFramework: $idAcquisitionFramework, datasetName: $datasetName, datasetShortname: $datasetShortname, datasetDesc: $datasetDesc, idNomenclatureDataType: $idNomenclatureDataType, keywords: $keywords, marineDomain: $marineDomain, terrestrialDomain: $terrestrialDomain, idNomenclatureDatasetObjectif: $idNomenclatureDatasetObjectif, bboxWest: $bboxWest, bboxEast: $bboxEast, bboxSouth: $bboxSouth, bboxNorth: $bboxNorth, idNomenclatureCollectingMethod: $idNomenclatureCollectingMethod, idNomenclatureDataOrigin: $idNomenclatureDataOrigin, idNomenclatureSourceStatus: $idNomenclatureSourceStatus, idNomenclatureResourceType: $idNomenclatureResourceType, active: $active, validable: $validable, idDigitizer: $idDigitizer, idTaxaList: $idTaxaList, metaCreateDate: $metaCreateDate, metaUpdateDate: $metaUpdateDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DatasetImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uniqueDatasetId, uniqueDatasetId) ||
                other.uniqueDatasetId == uniqueDatasetId) &&
            (identical(other.idAcquisitionFramework, idAcquisitionFramework) ||
                other.idAcquisitionFramework == idAcquisitionFramework) &&
            (identical(other.datasetName, datasetName) ||
                other.datasetName == datasetName) &&
            (identical(other.datasetShortname, datasetShortname) ||
                other.datasetShortname == datasetShortname) &&
            (identical(other.datasetDesc, datasetDesc) ||
                other.datasetDesc == datasetDesc) &&
            (identical(other.idNomenclatureDataType, idNomenclatureDataType) ||
                other.idNomenclatureDataType == idNomenclatureDataType) &&
            (identical(other.keywords, keywords) ||
                other.keywords == keywords) &&
            (identical(other.marineDomain, marineDomain) ||
                other.marineDomain == marineDomain) &&
            (identical(other.terrestrialDomain, terrestrialDomain) ||
                other.terrestrialDomain == terrestrialDomain) &&
            (identical(other.idNomenclatureDatasetObjectif, idNomenclatureDatasetObjectif) ||
                other.idNomenclatureDatasetObjectif ==
                    idNomenclatureDatasetObjectif) &&
            (identical(other.bboxWest, bboxWest) ||
                other.bboxWest == bboxWest) &&
            (identical(other.bboxEast, bboxEast) ||
                other.bboxEast == bboxEast) &&
            (identical(other.bboxSouth, bboxSouth) ||
                other.bboxSouth == bboxSouth) &&
            (identical(other.bboxNorth, bboxNorth) ||
                other.bboxNorth == bboxNorth) &&
            (identical(other.idNomenclatureCollectingMethod,
                    idNomenclatureCollectingMethod) ||
                other.idNomenclatureCollectingMethod ==
                    idNomenclatureCollectingMethod) &&
            (identical(
                    other.idNomenclatureDataOrigin, idNomenclatureDataOrigin) ||
                other.idNomenclatureDataOrigin == idNomenclatureDataOrigin) &&
            (identical(other.idNomenclatureSourceStatus, idNomenclatureSourceStatus) ||
                other.idNomenclatureSourceStatus ==
                    idNomenclatureSourceStatus) &&
            (identical(other.idNomenclatureResourceType, idNomenclatureResourceType) ||
                other.idNomenclatureResourceType ==
                    idNomenclatureResourceType) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.validable, validable) ||
                other.validable == validable) &&
            (identical(other.idDigitizer, idDigitizer) ||
                other.idDigitizer == idDigitizer) &&
            (identical(other.idTaxaList, idTaxaList) ||
                other.idTaxaList == idTaxaList) &&
            (identical(other.metaCreateDate, metaCreateDate) ||
                other.metaCreateDate == metaCreateDate) &&
            (identical(other.metaUpdateDate, metaUpdateDate) ||
                other.metaUpdateDate == metaUpdateDate));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        uniqueDatasetId,
        idAcquisitionFramework,
        datasetName,
        datasetShortname,
        datasetDesc,
        idNomenclatureDataType,
        keywords,
        marineDomain,
        terrestrialDomain,
        idNomenclatureDatasetObjectif,
        bboxWest,
        bboxEast,
        bboxSouth,
        bboxNorth,
        idNomenclatureCollectingMethod,
        idNomenclatureDataOrigin,
        idNomenclatureSourceStatus,
        idNomenclatureResourceType,
        active,
        validable,
        idDigitizer,
        idTaxaList,
        metaCreateDate,
        metaUpdateDate
      ]);

  /// Create a copy of Dataset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DatasetImplCopyWith<_$DatasetImpl> get copyWith =>
      __$$DatasetImplCopyWithImpl<_$DatasetImpl>(this, _$identity);
}

abstract class _Dataset implements Dataset {
  const factory _Dataset(
      {required final int id,
      required final String uniqueDatasetId,
      required final int idAcquisitionFramework,
      required final String datasetName,
      required final String datasetShortname,
      required final String datasetDesc,
      required final int idNomenclatureDataType,
      final String? keywords,
      required final bool marineDomain,
      required final bool terrestrialDomain,
      required final int idNomenclatureDatasetObjectif,
      final double? bboxWest,
      final double? bboxEast,
      final double? bboxSouth,
      final double? bboxNorth,
      required final int idNomenclatureCollectingMethod,
      required final int idNomenclatureDataOrigin,
      required final int idNomenclatureSourceStatus,
      required final int idNomenclatureResourceType,
      final bool? active,
      final bool? validable,
      final int? idDigitizer,
      final int? idTaxaList,
      final DateTime? metaCreateDate,
      final DateTime? metaUpdateDate}) = _$DatasetImpl;

  @override
  int get id; // idDataset
  @override
  String get uniqueDatasetId; // UUID
  @override
  int get idAcquisitionFramework;
  @override
  String get datasetName;
  @override
  String get datasetShortname;
  @override
  String get datasetDesc;
  @override
  int get idNomenclatureDataType;
  @override
  String? get keywords;
  @override
  bool get marineDomain;
  @override
  bool get terrestrialDomain;
  @override
  int get idNomenclatureDatasetObjectif;
  @override
  double? get bboxWest;
  @override
  double? get bboxEast;
  @override
  double? get bboxSouth;
  @override
  double? get bboxNorth;
  @override
  int get idNomenclatureCollectingMethod;
  @override
  int get idNomenclatureDataOrigin;
  @override
  int get idNomenclatureSourceStatus;
  @override
  int get idNomenclatureResourceType;
  @override
  bool? get active;
  @override
  bool? get validable;
  @override
  int? get idDigitizer;
  @override
  int? get idTaxaList;
  @override
  DateTime? get metaCreateDate;
  @override
  DateTime? get metaUpdateDate;

  /// Create a copy of Dataset
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DatasetImplCopyWith<_$DatasetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
