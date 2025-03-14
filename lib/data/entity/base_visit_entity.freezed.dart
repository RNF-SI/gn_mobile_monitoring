// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'base_visit_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BaseVisitEntity _$BaseVisitEntityFromJson(Map<String, dynamic> json) {
  return _BaseVisitEntity.fromJson(json);
}

/// @nodoc
mixin _$BaseVisitEntity {
  int get idBaseVisit => throw _privateConstructorUsedError;
  int? get idBaseSite => throw _privateConstructorUsedError;
  int get idDataset => throw _privateConstructorUsedError;
  int get idModule => throw _privateConstructorUsedError;
  int? get idDigitiser => throw _privateConstructorUsedError;
  String get visitDateMin => throw _privateConstructorUsedError;
  String? get visitDateMax => throw _privateConstructorUsedError;
  int? get idNomenclatureTechCollectCampanule =>
      throw _privateConstructorUsedError;
  int? get idNomenclatureGrpTyp => throw _privateConstructorUsedError;
  String? get comments => throw _privateConstructorUsedError;
  String? get uuidBaseVisit => throw _privateConstructorUsedError;
  String? get metaCreateDate => throw _privateConstructorUsedError;
  String? get metaUpdateDate => throw _privateConstructorUsedError;
  List<int>? get observers =>
      throw _privateConstructorUsedError; // Liste des ID des observateurs
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;

  /// Serializes this BaseVisitEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BaseVisitEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BaseVisitEntityCopyWith<BaseVisitEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BaseVisitEntityCopyWith<$Res> {
  factory $BaseVisitEntityCopyWith(
          BaseVisitEntity value, $Res Function(BaseVisitEntity) then) =
      _$BaseVisitEntityCopyWithImpl<$Res, BaseVisitEntity>;
  @useResult
  $Res call(
      {int idBaseVisit,
      int? idBaseSite,
      int idDataset,
      int idModule,
      int? idDigitiser,
      String visitDateMin,
      String? visitDateMax,
      int? idNomenclatureTechCollectCampanule,
      int? idNomenclatureGrpTyp,
      String? comments,
      String? uuidBaseVisit,
      String? metaCreateDate,
      String? metaUpdateDate,
      List<int>? observers,
      Map<String, dynamic>? data});
}

/// @nodoc
class _$BaseVisitEntityCopyWithImpl<$Res, $Val extends BaseVisitEntity>
    implements $BaseVisitEntityCopyWith<$Res> {
  _$BaseVisitEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BaseVisitEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idBaseVisit = null,
    Object? idBaseSite = freezed,
    Object? idDataset = null,
    Object? idModule = null,
    Object? idDigitiser = freezed,
    Object? visitDateMin = null,
    Object? visitDateMax = freezed,
    Object? idNomenclatureTechCollectCampanule = freezed,
    Object? idNomenclatureGrpTyp = freezed,
    Object? comments = freezed,
    Object? uuidBaseVisit = freezed,
    Object? metaCreateDate = freezed,
    Object? metaUpdateDate = freezed,
    Object? observers = freezed,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      idBaseVisit: null == idBaseVisit
          ? _value.idBaseVisit
          : idBaseVisit // ignore: cast_nullable_to_non_nullable
              as int,
      idBaseSite: freezed == idBaseSite
          ? _value.idBaseSite
          : idBaseSite // ignore: cast_nullable_to_non_nullable
              as int?,
      idDataset: null == idDataset
          ? _value.idDataset
          : idDataset // ignore: cast_nullable_to_non_nullable
              as int,
      idModule: null == idModule
          ? _value.idModule
          : idModule // ignore: cast_nullable_to_non_nullable
              as int,
      idDigitiser: freezed == idDigitiser
          ? _value.idDigitiser
          : idDigitiser // ignore: cast_nullable_to_non_nullable
              as int?,
      visitDateMin: null == visitDateMin
          ? _value.visitDateMin
          : visitDateMin // ignore: cast_nullable_to_non_nullable
              as String,
      visitDateMax: freezed == visitDateMax
          ? _value.visitDateMax
          : visitDateMax // ignore: cast_nullable_to_non_nullable
              as String?,
      idNomenclatureTechCollectCampanule: freezed ==
              idNomenclatureTechCollectCampanule
          ? _value.idNomenclatureTechCollectCampanule
          : idNomenclatureTechCollectCampanule // ignore: cast_nullable_to_non_nullable
              as int?,
      idNomenclatureGrpTyp: freezed == idNomenclatureGrpTyp
          ? _value.idNomenclatureGrpTyp
          : idNomenclatureGrpTyp // ignore: cast_nullable_to_non_nullable
              as int?,
      comments: freezed == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as String?,
      uuidBaseVisit: freezed == uuidBaseVisit
          ? _value.uuidBaseVisit
          : uuidBaseVisit // ignore: cast_nullable_to_non_nullable
              as String?,
      metaCreateDate: freezed == metaCreateDate
          ? _value.metaCreateDate
          : metaCreateDate // ignore: cast_nullable_to_non_nullable
              as String?,
      metaUpdateDate: freezed == metaUpdateDate
          ? _value.metaUpdateDate
          : metaUpdateDate // ignore: cast_nullable_to_non_nullable
              as String?,
      observers: freezed == observers
          ? _value.observers
          : observers // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BaseVisitEntityImplCopyWith<$Res>
    implements $BaseVisitEntityCopyWith<$Res> {
  factory _$$BaseVisitEntityImplCopyWith(_$BaseVisitEntityImpl value,
          $Res Function(_$BaseVisitEntityImpl) then) =
      __$$BaseVisitEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int idBaseVisit,
      int? idBaseSite,
      int idDataset,
      int idModule,
      int? idDigitiser,
      String visitDateMin,
      String? visitDateMax,
      int? idNomenclatureTechCollectCampanule,
      int? idNomenclatureGrpTyp,
      String? comments,
      String? uuidBaseVisit,
      String? metaCreateDate,
      String? metaUpdateDate,
      List<int>? observers,
      Map<String, dynamic>? data});
}

/// @nodoc
class __$$BaseVisitEntityImplCopyWithImpl<$Res>
    extends _$BaseVisitEntityCopyWithImpl<$Res, _$BaseVisitEntityImpl>
    implements _$$BaseVisitEntityImplCopyWith<$Res> {
  __$$BaseVisitEntityImplCopyWithImpl(
      _$BaseVisitEntityImpl _value, $Res Function(_$BaseVisitEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of BaseVisitEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idBaseVisit = null,
    Object? idBaseSite = freezed,
    Object? idDataset = null,
    Object? idModule = null,
    Object? idDigitiser = freezed,
    Object? visitDateMin = null,
    Object? visitDateMax = freezed,
    Object? idNomenclatureTechCollectCampanule = freezed,
    Object? idNomenclatureGrpTyp = freezed,
    Object? comments = freezed,
    Object? uuidBaseVisit = freezed,
    Object? metaCreateDate = freezed,
    Object? metaUpdateDate = freezed,
    Object? observers = freezed,
    Object? data = freezed,
  }) {
    return _then(_$BaseVisitEntityImpl(
      idBaseVisit: null == idBaseVisit
          ? _value.idBaseVisit
          : idBaseVisit // ignore: cast_nullable_to_non_nullable
              as int,
      idBaseSite: freezed == idBaseSite
          ? _value.idBaseSite
          : idBaseSite // ignore: cast_nullable_to_non_nullable
              as int?,
      idDataset: null == idDataset
          ? _value.idDataset
          : idDataset // ignore: cast_nullable_to_non_nullable
              as int,
      idModule: null == idModule
          ? _value.idModule
          : idModule // ignore: cast_nullable_to_non_nullable
              as int,
      idDigitiser: freezed == idDigitiser
          ? _value.idDigitiser
          : idDigitiser // ignore: cast_nullable_to_non_nullable
              as int?,
      visitDateMin: null == visitDateMin
          ? _value.visitDateMin
          : visitDateMin // ignore: cast_nullable_to_non_nullable
              as String,
      visitDateMax: freezed == visitDateMax
          ? _value.visitDateMax
          : visitDateMax // ignore: cast_nullable_to_non_nullable
              as String?,
      idNomenclatureTechCollectCampanule: freezed ==
              idNomenclatureTechCollectCampanule
          ? _value.idNomenclatureTechCollectCampanule
          : idNomenclatureTechCollectCampanule // ignore: cast_nullable_to_non_nullable
              as int?,
      idNomenclatureGrpTyp: freezed == idNomenclatureGrpTyp
          ? _value.idNomenclatureGrpTyp
          : idNomenclatureGrpTyp // ignore: cast_nullable_to_non_nullable
              as int?,
      comments: freezed == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as String?,
      uuidBaseVisit: freezed == uuidBaseVisit
          ? _value.uuidBaseVisit
          : uuidBaseVisit // ignore: cast_nullable_to_non_nullable
              as String?,
      metaCreateDate: freezed == metaCreateDate
          ? _value.metaCreateDate
          : metaCreateDate // ignore: cast_nullable_to_non_nullable
              as String?,
      metaUpdateDate: freezed == metaUpdateDate
          ? _value.metaUpdateDate
          : metaUpdateDate // ignore: cast_nullable_to_non_nullable
              as String?,
      observers: freezed == observers
          ? _value._observers
          : observers // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BaseVisitEntityImpl implements _BaseVisitEntity {
  const _$BaseVisitEntityImpl(
      {required this.idBaseVisit,
      this.idBaseSite,
      required this.idDataset,
      required this.idModule,
      this.idDigitiser,
      required this.visitDateMin,
      this.visitDateMax,
      this.idNomenclatureTechCollectCampanule,
      this.idNomenclatureGrpTyp,
      this.comments,
      this.uuidBaseVisit,
      this.metaCreateDate,
      this.metaUpdateDate,
      final List<int>? observers,
      final Map<String, dynamic>? data})
      : _observers = observers,
        _data = data;

  factory _$BaseVisitEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$BaseVisitEntityImplFromJson(json);

  @override
  final int idBaseVisit;
  @override
  final int? idBaseSite;
  @override
  final int idDataset;
  @override
  final int idModule;
  @override
  final int? idDigitiser;
  @override
  final String visitDateMin;
  @override
  final String? visitDateMax;
  @override
  final int? idNomenclatureTechCollectCampanule;
  @override
  final int? idNomenclatureGrpTyp;
  @override
  final String? comments;
  @override
  final String? uuidBaseVisit;
  @override
  final String? metaCreateDate;
  @override
  final String? metaUpdateDate;
  final List<int>? _observers;
  @override
  List<int>? get observers {
    final value = _observers;
    if (value == null) return null;
    if (_observers is EqualUnmodifiableListView) return _observers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Liste des ID des observateurs
  final Map<String, dynamic>? _data;
// Liste des ID des observateurs
  @override
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'BaseVisitEntity(idBaseVisit: $idBaseVisit, idBaseSite: $idBaseSite, idDataset: $idDataset, idModule: $idModule, idDigitiser: $idDigitiser, visitDateMin: $visitDateMin, visitDateMax: $visitDateMax, idNomenclatureTechCollectCampanule: $idNomenclatureTechCollectCampanule, idNomenclatureGrpTyp: $idNomenclatureGrpTyp, comments: $comments, uuidBaseVisit: $uuidBaseVisit, metaCreateDate: $metaCreateDate, metaUpdateDate: $metaUpdateDate, observers: $observers, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BaseVisitEntityImpl &&
            (identical(other.idBaseVisit, idBaseVisit) ||
                other.idBaseVisit == idBaseVisit) &&
            (identical(other.idBaseSite, idBaseSite) ||
                other.idBaseSite == idBaseSite) &&
            (identical(other.idDataset, idDataset) ||
                other.idDataset == idDataset) &&
            (identical(other.idModule, idModule) ||
                other.idModule == idModule) &&
            (identical(other.idDigitiser, idDigitiser) ||
                other.idDigitiser == idDigitiser) &&
            (identical(other.visitDateMin, visitDateMin) ||
                other.visitDateMin == visitDateMin) &&
            (identical(other.visitDateMax, visitDateMax) ||
                other.visitDateMax == visitDateMax) &&
            (identical(other.idNomenclatureTechCollectCampanule,
                    idNomenclatureTechCollectCampanule) ||
                other.idNomenclatureTechCollectCampanule ==
                    idNomenclatureTechCollectCampanule) &&
            (identical(other.idNomenclatureGrpTyp, idNomenclatureGrpTyp) ||
                other.idNomenclatureGrpTyp == idNomenclatureGrpTyp) &&
            (identical(other.comments, comments) ||
                other.comments == comments) &&
            (identical(other.uuidBaseVisit, uuidBaseVisit) ||
                other.uuidBaseVisit == uuidBaseVisit) &&
            (identical(other.metaCreateDate, metaCreateDate) ||
                other.metaCreateDate == metaCreateDate) &&
            (identical(other.metaUpdateDate, metaUpdateDate) ||
                other.metaUpdateDate == metaUpdateDate) &&
            const DeepCollectionEquality()
                .equals(other._observers, _observers) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      idBaseVisit,
      idBaseSite,
      idDataset,
      idModule,
      idDigitiser,
      visitDateMin,
      visitDateMax,
      idNomenclatureTechCollectCampanule,
      idNomenclatureGrpTyp,
      comments,
      uuidBaseVisit,
      metaCreateDate,
      metaUpdateDate,
      const DeepCollectionEquality().hash(_observers),
      const DeepCollectionEquality().hash(_data));

  /// Create a copy of BaseVisitEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BaseVisitEntityImplCopyWith<_$BaseVisitEntityImpl> get copyWith =>
      __$$BaseVisitEntityImplCopyWithImpl<_$BaseVisitEntityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BaseVisitEntityImplToJson(
      this,
    );
  }
}

abstract class _BaseVisitEntity implements BaseVisitEntity {
  const factory _BaseVisitEntity(
      {required final int idBaseVisit,
      final int? idBaseSite,
      required final int idDataset,
      required final int idModule,
      final int? idDigitiser,
      required final String visitDateMin,
      final String? visitDateMax,
      final int? idNomenclatureTechCollectCampanule,
      final int? idNomenclatureGrpTyp,
      final String? comments,
      final String? uuidBaseVisit,
      final String? metaCreateDate,
      final String? metaUpdateDate,
      final List<int>? observers,
      final Map<String, dynamic>? data}) = _$BaseVisitEntityImpl;

  factory _BaseVisitEntity.fromJson(Map<String, dynamic> json) =
      _$BaseVisitEntityImpl.fromJson;

  @override
  int get idBaseVisit;
  @override
  int? get idBaseSite;
  @override
  int get idDataset;
  @override
  int get idModule;
  @override
  int? get idDigitiser;
  @override
  String get visitDateMin;
  @override
  String? get visitDateMax;
  @override
  int? get idNomenclatureTechCollectCampanule;
  @override
  int? get idNomenclatureGrpTyp;
  @override
  String? get comments;
  @override
  String? get uuidBaseVisit;
  @override
  String? get metaCreateDate;
  @override
  String? get metaUpdateDate;
  @override
  List<int>? get observers; // Liste des ID des observateurs
  @override
  Map<String, dynamic>? get data;

  /// Create a copy of BaseVisitEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BaseVisitEntityImplCopyWith<_$BaseVisitEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
