// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'observation_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ObservationDetail {
  /// Identifiant unique du détail d'observation
  int? get idObservationDetail => throw _privateConstructorUsedError;

  /// Identifiant de l'observation parente
  int? get idObservation => throw _privateConstructorUsedError;

  /// UUID unique du détail d'observation
  String? get uuidObservationDetail => throw _privateConstructorUsedError;

  /// Données sous forme de Map
  Map<String, dynamic> get data => throw _privateConstructorUsedError;

  /// Create a copy of ObservationDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ObservationDetailCopyWith<ObservationDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ObservationDetailCopyWith<$Res> {
  factory $ObservationDetailCopyWith(
          ObservationDetail value, $Res Function(ObservationDetail) then) =
      _$ObservationDetailCopyWithImpl<$Res, ObservationDetail>;
  @useResult
  $Res call(
      {int? idObservationDetail,
      int? idObservation,
      String? uuidObservationDetail,
      Map<String, dynamic> data});
}

/// @nodoc
class _$ObservationDetailCopyWithImpl<$Res, $Val extends ObservationDetail>
    implements $ObservationDetailCopyWith<$Res> {
  _$ObservationDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ObservationDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idObservationDetail = freezed,
    Object? idObservation = freezed,
    Object? uuidObservationDetail = freezed,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      idObservationDetail: freezed == idObservationDetail
          ? _value.idObservationDetail
          : idObservationDetail // ignore: cast_nullable_to_non_nullable
              as int?,
      idObservation: freezed == idObservation
          ? _value.idObservation
          : idObservation // ignore: cast_nullable_to_non_nullable
              as int?,
      uuidObservationDetail: freezed == uuidObservationDetail
          ? _value.uuidObservationDetail
          : uuidObservationDetail // ignore: cast_nullable_to_non_nullable
              as String?,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ObservationDetailImplCopyWith<$Res>
    implements $ObservationDetailCopyWith<$Res> {
  factory _$$ObservationDetailImplCopyWith(_$ObservationDetailImpl value,
          $Res Function(_$ObservationDetailImpl) then) =
      __$$ObservationDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? idObservationDetail,
      int? idObservation,
      String? uuidObservationDetail,
      Map<String, dynamic> data});
}

/// @nodoc
class __$$ObservationDetailImplCopyWithImpl<$Res>
    extends _$ObservationDetailCopyWithImpl<$Res, _$ObservationDetailImpl>
    implements _$$ObservationDetailImplCopyWith<$Res> {
  __$$ObservationDetailImplCopyWithImpl(_$ObservationDetailImpl _value,
      $Res Function(_$ObservationDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of ObservationDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idObservationDetail = freezed,
    Object? idObservation = freezed,
    Object? uuidObservationDetail = freezed,
    Object? data = null,
  }) {
    return _then(_$ObservationDetailImpl(
      idObservationDetail: freezed == idObservationDetail
          ? _value.idObservationDetail
          : idObservationDetail // ignore: cast_nullable_to_non_nullable
              as int?,
      idObservation: freezed == idObservation
          ? _value.idObservation
          : idObservation // ignore: cast_nullable_to_non_nullable
              as int?,
      uuidObservationDetail: freezed == uuidObservationDetail
          ? _value.uuidObservationDetail
          : uuidObservationDetail // ignore: cast_nullable_to_non_nullable
              as String?,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc

class _$ObservationDetailImpl implements _ObservationDetail {
  const _$ObservationDetailImpl(
      {this.idObservationDetail,
      this.idObservation,
      this.uuidObservationDetail,
      final Map<String, dynamic> data = const {}})
      : _data = data;

  /// Identifiant unique du détail d'observation
  @override
  final int? idObservationDetail;

  /// Identifiant de l'observation parente
  @override
  final int? idObservation;

  /// UUID unique du détail d'observation
  @override
  final String? uuidObservationDetail;

  /// Données sous forme de Map
  final Map<String, dynamic> _data;

  /// Données sous forme de Map
  @override
  @JsonKey()
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  String toString() {
    return 'ObservationDetail(idObservationDetail: $idObservationDetail, idObservation: $idObservation, uuidObservationDetail: $uuidObservationDetail, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ObservationDetailImpl &&
            (identical(other.idObservationDetail, idObservationDetail) ||
                other.idObservationDetail == idObservationDetail) &&
            (identical(other.idObservation, idObservation) ||
                other.idObservation == idObservation) &&
            (identical(other.uuidObservationDetail, uuidObservationDetail) ||
                other.uuidObservationDetail == uuidObservationDetail) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      idObservationDetail,
      idObservation,
      uuidObservationDetail,
      const DeepCollectionEquality().hash(_data));

  /// Create a copy of ObservationDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ObservationDetailImplCopyWith<_$ObservationDetailImpl> get copyWith =>
      __$$ObservationDetailImplCopyWithImpl<_$ObservationDetailImpl>(
          this, _$identity);
}

abstract class _ObservationDetail implements ObservationDetail {
  const factory _ObservationDetail(
      {final int? idObservationDetail,
      final int? idObservation,
      final String? uuidObservationDetail,
      final Map<String, dynamic> data}) = _$ObservationDetailImpl;

  /// Identifiant unique du détail d'observation
  @override
  int? get idObservationDetail;

  /// Identifiant de l'observation parente
  @override
  int? get idObservation;

  /// UUID unique du détail d'observation
  @override
  String? get uuidObservationDetail;

  /// Données sous forme de Map
  @override
  Map<String, dynamic> get data;

  /// Create a copy of ObservationDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ObservationDetailImplCopyWith<_$ObservationDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
