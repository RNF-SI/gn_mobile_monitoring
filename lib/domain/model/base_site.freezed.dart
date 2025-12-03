// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'base_site.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BaseSite {
  int get idBaseSite => throw _privateConstructorUsedError;
  String? get baseSiteName => throw _privateConstructorUsedError;
  String? get baseSiteDescription => throw _privateConstructorUsedError;
  String? get baseSiteCode => throw _privateConstructorUsedError;
  DateTime? get firstUseDate => throw _privateConstructorUsedError;
  String? get geom =>
      throw _privateConstructorUsedError; // GeoJSON representation
  String? get uuidBaseSite => throw _privateConstructorUsedError;
  int? get altitudeMin => throw _privateConstructorUsedError;
  int? get altitudeMax => throw _privateConstructorUsedError;
  DateTime? get metaCreateDate => throw _privateConstructorUsedError;
  DateTime? get metaUpdateDate => throw _privateConstructorUsedError;
  int? get idDigitiser => throw _privateConstructorUsedError;
  int? get idInventor => throw _privateConstructorUsedError;
  List<int> get organismeActors =>
      throw _privateConstructorUsedError; // Permissions CRUVED pour ce site spécifique (pattern monitoring web)
  CruvedResponse? get cruved => throw _privateConstructorUsedError;

  /// Create a copy of BaseSite
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BaseSiteCopyWith<BaseSite> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BaseSiteCopyWith<$Res> {
  factory $BaseSiteCopyWith(BaseSite value, $Res Function(BaseSite) then) =
      _$BaseSiteCopyWithImpl<$Res, BaseSite>;
  @useResult
  $Res call(
      {int idBaseSite,
      String? baseSiteName,
      String? baseSiteDescription,
      String? baseSiteCode,
      DateTime? firstUseDate,
      String? geom,
      String? uuidBaseSite,
      int? altitudeMin,
      int? altitudeMax,
      DateTime? metaCreateDate,
      DateTime? metaUpdateDate,
      int? idDigitiser,
      int? idInventor,
      List<int> organismeActors,
      CruvedResponse? cruved});

  $CruvedResponseCopyWith<$Res>? get cruved;
}

/// @nodoc
class _$BaseSiteCopyWithImpl<$Res, $Val extends BaseSite>
    implements $BaseSiteCopyWith<$Res> {
  _$BaseSiteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BaseSite
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idBaseSite = null,
    Object? baseSiteName = freezed,
    Object? baseSiteDescription = freezed,
    Object? baseSiteCode = freezed,
    Object? firstUseDate = freezed,
    Object? geom = freezed,
    Object? uuidBaseSite = freezed,
    Object? altitudeMin = freezed,
    Object? altitudeMax = freezed,
    Object? metaCreateDate = freezed,
    Object? metaUpdateDate = freezed,
    Object? idDigitiser = freezed,
    Object? idInventor = freezed,
    Object? organismeActors = null,
    Object? cruved = freezed,
  }) {
    return _then(_value.copyWith(
      idBaseSite: null == idBaseSite
          ? _value.idBaseSite
          : idBaseSite // ignore: cast_nullable_to_non_nullable
              as int,
      baseSiteName: freezed == baseSiteName
          ? _value.baseSiteName
          : baseSiteName // ignore: cast_nullable_to_non_nullable
              as String?,
      baseSiteDescription: freezed == baseSiteDescription
          ? _value.baseSiteDescription
          : baseSiteDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      baseSiteCode: freezed == baseSiteCode
          ? _value.baseSiteCode
          : baseSiteCode // ignore: cast_nullable_to_non_nullable
              as String?,
      firstUseDate: freezed == firstUseDate
          ? _value.firstUseDate
          : firstUseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      geom: freezed == geom
          ? _value.geom
          : geom // ignore: cast_nullable_to_non_nullable
              as String?,
      uuidBaseSite: freezed == uuidBaseSite
          ? _value.uuidBaseSite
          : uuidBaseSite // ignore: cast_nullable_to_non_nullable
              as String?,
      altitudeMin: freezed == altitudeMin
          ? _value.altitudeMin
          : altitudeMin // ignore: cast_nullable_to_non_nullable
              as int?,
      altitudeMax: freezed == altitudeMax
          ? _value.altitudeMax
          : altitudeMax // ignore: cast_nullable_to_non_nullable
              as int?,
      metaCreateDate: freezed == metaCreateDate
          ? _value.metaCreateDate
          : metaCreateDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metaUpdateDate: freezed == metaUpdateDate
          ? _value.metaUpdateDate
          : metaUpdateDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      idDigitiser: freezed == idDigitiser
          ? _value.idDigitiser
          : idDigitiser // ignore: cast_nullable_to_non_nullable
              as int?,
      idInventor: freezed == idInventor
          ? _value.idInventor
          : idInventor // ignore: cast_nullable_to_non_nullable
              as int?,
      organismeActors: null == organismeActors
          ? _value.organismeActors
          : organismeActors // ignore: cast_nullable_to_non_nullable
              as List<int>,
      cruved: freezed == cruved
          ? _value.cruved
          : cruved // ignore: cast_nullable_to_non_nullable
              as CruvedResponse?,
    ) as $Val);
  }

  /// Create a copy of BaseSite
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CruvedResponseCopyWith<$Res>? get cruved {
    if (_value.cruved == null) {
      return null;
    }

    return $CruvedResponseCopyWith<$Res>(_value.cruved!, (value) {
      return _then(_value.copyWith(cruved: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BaseSiteImplCopyWith<$Res>
    implements $BaseSiteCopyWith<$Res> {
  factory _$$BaseSiteImplCopyWith(
          _$BaseSiteImpl value, $Res Function(_$BaseSiteImpl) then) =
      __$$BaseSiteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int idBaseSite,
      String? baseSiteName,
      String? baseSiteDescription,
      String? baseSiteCode,
      DateTime? firstUseDate,
      String? geom,
      String? uuidBaseSite,
      int? altitudeMin,
      int? altitudeMax,
      DateTime? metaCreateDate,
      DateTime? metaUpdateDate,
      int? idDigitiser,
      int? idInventor,
      List<int> organismeActors,
      CruvedResponse? cruved});

  @override
  $CruvedResponseCopyWith<$Res>? get cruved;
}

/// @nodoc
class __$$BaseSiteImplCopyWithImpl<$Res>
    extends _$BaseSiteCopyWithImpl<$Res, _$BaseSiteImpl>
    implements _$$BaseSiteImplCopyWith<$Res> {
  __$$BaseSiteImplCopyWithImpl(
      _$BaseSiteImpl _value, $Res Function(_$BaseSiteImpl) _then)
      : super(_value, _then);

  /// Create a copy of BaseSite
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idBaseSite = null,
    Object? baseSiteName = freezed,
    Object? baseSiteDescription = freezed,
    Object? baseSiteCode = freezed,
    Object? firstUseDate = freezed,
    Object? geom = freezed,
    Object? uuidBaseSite = freezed,
    Object? altitudeMin = freezed,
    Object? altitudeMax = freezed,
    Object? metaCreateDate = freezed,
    Object? metaUpdateDate = freezed,
    Object? idDigitiser = freezed,
    Object? idInventor = freezed,
    Object? organismeActors = null,
    Object? cruved = freezed,
  }) {
    return _then(_$BaseSiteImpl(
      idBaseSite: null == idBaseSite
          ? _value.idBaseSite
          : idBaseSite // ignore: cast_nullable_to_non_nullable
              as int,
      baseSiteName: freezed == baseSiteName
          ? _value.baseSiteName
          : baseSiteName // ignore: cast_nullable_to_non_nullable
              as String?,
      baseSiteDescription: freezed == baseSiteDescription
          ? _value.baseSiteDescription
          : baseSiteDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      baseSiteCode: freezed == baseSiteCode
          ? _value.baseSiteCode
          : baseSiteCode // ignore: cast_nullable_to_non_nullable
              as String?,
      firstUseDate: freezed == firstUseDate
          ? _value.firstUseDate
          : firstUseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      geom: freezed == geom
          ? _value.geom
          : geom // ignore: cast_nullable_to_non_nullable
              as String?,
      uuidBaseSite: freezed == uuidBaseSite
          ? _value.uuidBaseSite
          : uuidBaseSite // ignore: cast_nullable_to_non_nullable
              as String?,
      altitudeMin: freezed == altitudeMin
          ? _value.altitudeMin
          : altitudeMin // ignore: cast_nullable_to_non_nullable
              as int?,
      altitudeMax: freezed == altitudeMax
          ? _value.altitudeMax
          : altitudeMax // ignore: cast_nullable_to_non_nullable
              as int?,
      metaCreateDate: freezed == metaCreateDate
          ? _value.metaCreateDate
          : metaCreateDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metaUpdateDate: freezed == metaUpdateDate
          ? _value.metaUpdateDate
          : metaUpdateDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      idDigitiser: freezed == idDigitiser
          ? _value.idDigitiser
          : idDigitiser // ignore: cast_nullable_to_non_nullable
              as int?,
      idInventor: freezed == idInventor
          ? _value.idInventor
          : idInventor // ignore: cast_nullable_to_non_nullable
              as int?,
      organismeActors: null == organismeActors
          ? _value._organismeActors
          : organismeActors // ignore: cast_nullable_to_non_nullable
              as List<int>,
      cruved: freezed == cruved
          ? _value.cruved
          : cruved // ignore: cast_nullable_to_non_nullable
              as CruvedResponse?,
    ));
  }
}

/// @nodoc

class _$BaseSiteImpl extends _BaseSite {
  const _$BaseSiteImpl(
      {required this.idBaseSite,
      this.baseSiteName,
      this.baseSiteDescription,
      this.baseSiteCode,
      this.firstUseDate,
      this.geom,
      this.uuidBaseSite,
      this.altitudeMin,
      this.altitudeMax,
      this.metaCreateDate,
      this.metaUpdateDate,
      this.idDigitiser,
      this.idInventor,
      final List<int> organismeActors = const [],
      this.cruved})
      : _organismeActors = organismeActors,
        super._();

  @override
  final int idBaseSite;
  @override
  final String? baseSiteName;
  @override
  final String? baseSiteDescription;
  @override
  final String? baseSiteCode;
  @override
  final DateTime? firstUseDate;
  @override
  final String? geom;
// GeoJSON representation
  @override
  final String? uuidBaseSite;
  @override
  final int? altitudeMin;
  @override
  final int? altitudeMax;
  @override
  final DateTime? metaCreateDate;
  @override
  final DateTime? metaUpdateDate;
  @override
  final int? idDigitiser;
  @override
  final int? idInventor;
  final List<int> _organismeActors;
  @override
  @JsonKey()
  List<int> get organismeActors {
    if (_organismeActors is EqualUnmodifiableListView) return _organismeActors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_organismeActors);
  }

// Permissions CRUVED pour ce site spécifique (pattern monitoring web)
  @override
  final CruvedResponse? cruved;

  @override
  String toString() {
    return 'BaseSite(idBaseSite: $idBaseSite, baseSiteName: $baseSiteName, baseSiteDescription: $baseSiteDescription, baseSiteCode: $baseSiteCode, firstUseDate: $firstUseDate, geom: $geom, uuidBaseSite: $uuidBaseSite, altitudeMin: $altitudeMin, altitudeMax: $altitudeMax, metaCreateDate: $metaCreateDate, metaUpdateDate: $metaUpdateDate, idDigitiser: $idDigitiser, idInventor: $idInventor, organismeActors: $organismeActors, cruved: $cruved)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BaseSiteImpl &&
            (identical(other.idBaseSite, idBaseSite) ||
                other.idBaseSite == idBaseSite) &&
            (identical(other.baseSiteName, baseSiteName) ||
                other.baseSiteName == baseSiteName) &&
            (identical(other.baseSiteDescription, baseSiteDescription) ||
                other.baseSiteDescription == baseSiteDescription) &&
            (identical(other.baseSiteCode, baseSiteCode) ||
                other.baseSiteCode == baseSiteCode) &&
            (identical(other.firstUseDate, firstUseDate) ||
                other.firstUseDate == firstUseDate) &&
            (identical(other.geom, geom) || other.geom == geom) &&
            (identical(other.uuidBaseSite, uuidBaseSite) ||
                other.uuidBaseSite == uuidBaseSite) &&
            (identical(other.altitudeMin, altitudeMin) ||
                other.altitudeMin == altitudeMin) &&
            (identical(other.altitudeMax, altitudeMax) ||
                other.altitudeMax == altitudeMax) &&
            (identical(other.metaCreateDate, metaCreateDate) ||
                other.metaCreateDate == metaCreateDate) &&
            (identical(other.metaUpdateDate, metaUpdateDate) ||
                other.metaUpdateDate == metaUpdateDate) &&
            (identical(other.idDigitiser, idDigitiser) ||
                other.idDigitiser == idDigitiser) &&
            (identical(other.idInventor, idInventor) ||
                other.idInventor == idInventor) &&
            const DeepCollectionEquality()
                .equals(other._organismeActors, _organismeActors) &&
            (identical(other.cruved, cruved) || other.cruved == cruved));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      idBaseSite,
      baseSiteName,
      baseSiteDescription,
      baseSiteCode,
      firstUseDate,
      geom,
      uuidBaseSite,
      altitudeMin,
      altitudeMax,
      metaCreateDate,
      metaUpdateDate,
      idDigitiser,
      idInventor,
      const DeepCollectionEquality().hash(_organismeActors),
      cruved);

  /// Create a copy of BaseSite
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BaseSiteImplCopyWith<_$BaseSiteImpl> get copyWith =>
      __$$BaseSiteImplCopyWithImpl<_$BaseSiteImpl>(this, _$identity);
}

abstract class _BaseSite extends BaseSite {
  const factory _BaseSite(
      {required final int idBaseSite,
      final String? baseSiteName,
      final String? baseSiteDescription,
      final String? baseSiteCode,
      final DateTime? firstUseDate,
      final String? geom,
      final String? uuidBaseSite,
      final int? altitudeMin,
      final int? altitudeMax,
      final DateTime? metaCreateDate,
      final DateTime? metaUpdateDate,
      final int? idDigitiser,
      final int? idInventor,
      final List<int> organismeActors,
      final CruvedResponse? cruved}) = _$BaseSiteImpl;
  const _BaseSite._() : super._();

  @override
  int get idBaseSite;
  @override
  String? get baseSiteName;
  @override
  String? get baseSiteDescription;
  @override
  String? get baseSiteCode;
  @override
  DateTime? get firstUseDate;
  @override
  String? get geom; // GeoJSON representation
  @override
  String? get uuidBaseSite;
  @override
  int? get altitudeMin;
  @override
  int? get altitudeMax;
  @override
  DateTime? get metaCreateDate;
  @override
  DateTime? get metaUpdateDate;
  @override
  int? get idDigitiser;
  @override
  int? get idInventor;
  @override
  List<int>
      get organismeActors; // Permissions CRUVED pour ce site spécifique (pattern monitoring web)
  @override
  CruvedResponse? get cruved;

  /// Create a copy of BaseSite
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BaseSiteImplCopyWith<_$BaseSiteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
