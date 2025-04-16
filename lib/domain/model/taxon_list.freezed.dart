// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'taxon_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TaxonList {
  int get idListe => throw _privateConstructorUsedError;
  String? get codeListe => throw _privateConstructorUsedError;
  String get nomListe => throw _privateConstructorUsedError;
  String? get descListe => throw _privateConstructorUsedError;
  String? get regne => throw _privateConstructorUsedError;
  String? get group2Inpn => throw _privateConstructorUsedError;

  /// Create a copy of TaxonList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaxonListCopyWith<TaxonList> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaxonListCopyWith<$Res> {
  factory $TaxonListCopyWith(TaxonList value, $Res Function(TaxonList) then) =
      _$TaxonListCopyWithImpl<$Res, TaxonList>;
  @useResult
  $Res call(
      {int idListe,
      String? codeListe,
      String nomListe,
      String? descListe,
      String? regne,
      String? group2Inpn});
}

/// @nodoc
class _$TaxonListCopyWithImpl<$Res, $Val extends TaxonList>
    implements $TaxonListCopyWith<$Res> {
  _$TaxonListCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaxonList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idListe = null,
    Object? codeListe = freezed,
    Object? nomListe = null,
    Object? descListe = freezed,
    Object? regne = freezed,
    Object? group2Inpn = freezed,
  }) {
    return _then(_value.copyWith(
      idListe: null == idListe
          ? _value.idListe
          : idListe // ignore: cast_nullable_to_non_nullable
              as int,
      codeListe: freezed == codeListe
          ? _value.codeListe
          : codeListe // ignore: cast_nullable_to_non_nullable
              as String?,
      nomListe: null == nomListe
          ? _value.nomListe
          : nomListe // ignore: cast_nullable_to_non_nullable
              as String,
      descListe: freezed == descListe
          ? _value.descListe
          : descListe // ignore: cast_nullable_to_non_nullable
              as String?,
      regne: freezed == regne
          ? _value.regne
          : regne // ignore: cast_nullable_to_non_nullable
              as String?,
      group2Inpn: freezed == group2Inpn
          ? _value.group2Inpn
          : group2Inpn // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaxonListImplCopyWith<$Res>
    implements $TaxonListCopyWith<$Res> {
  factory _$$TaxonListImplCopyWith(
          _$TaxonListImpl value, $Res Function(_$TaxonListImpl) then) =
      __$$TaxonListImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int idListe,
      String? codeListe,
      String nomListe,
      String? descListe,
      String? regne,
      String? group2Inpn});
}

/// @nodoc
class __$$TaxonListImplCopyWithImpl<$Res>
    extends _$TaxonListCopyWithImpl<$Res, _$TaxonListImpl>
    implements _$$TaxonListImplCopyWith<$Res> {
  __$$TaxonListImplCopyWithImpl(
      _$TaxonListImpl _value, $Res Function(_$TaxonListImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaxonList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idListe = null,
    Object? codeListe = freezed,
    Object? nomListe = null,
    Object? descListe = freezed,
    Object? regne = freezed,
    Object? group2Inpn = freezed,
  }) {
    return _then(_$TaxonListImpl(
      idListe: null == idListe
          ? _value.idListe
          : idListe // ignore: cast_nullable_to_non_nullable
              as int,
      codeListe: freezed == codeListe
          ? _value.codeListe
          : codeListe // ignore: cast_nullable_to_non_nullable
              as String?,
      nomListe: null == nomListe
          ? _value.nomListe
          : nomListe // ignore: cast_nullable_to_non_nullable
              as String,
      descListe: freezed == descListe
          ? _value.descListe
          : descListe // ignore: cast_nullable_to_non_nullable
              as String?,
      regne: freezed == regne
          ? _value.regne
          : regne // ignore: cast_nullable_to_non_nullable
              as String?,
      group2Inpn: freezed == group2Inpn
          ? _value.group2Inpn
          : group2Inpn // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$TaxonListImpl implements _TaxonList {
  const _$TaxonListImpl(
      {required this.idListe,
      this.codeListe,
      required this.nomListe,
      this.descListe,
      this.regne,
      this.group2Inpn});

  @override
  final int idListe;
  @override
  final String? codeListe;
  @override
  final String nomListe;
  @override
  final String? descListe;
  @override
  final String? regne;
  @override
  final String? group2Inpn;

  @override
  String toString() {
    return 'TaxonList(idListe: $idListe, codeListe: $codeListe, nomListe: $nomListe, descListe: $descListe, regne: $regne, group2Inpn: $group2Inpn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaxonListImpl &&
            (identical(other.idListe, idListe) || other.idListe == idListe) &&
            (identical(other.codeListe, codeListe) ||
                other.codeListe == codeListe) &&
            (identical(other.nomListe, nomListe) ||
                other.nomListe == nomListe) &&
            (identical(other.descListe, descListe) ||
                other.descListe == descListe) &&
            (identical(other.regne, regne) || other.regne == regne) &&
            (identical(other.group2Inpn, group2Inpn) ||
                other.group2Inpn == group2Inpn));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, idListe, codeListe, nomListe, descListe, regne, group2Inpn);

  /// Create a copy of TaxonList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaxonListImplCopyWith<_$TaxonListImpl> get copyWith =>
      __$$TaxonListImplCopyWithImpl<_$TaxonListImpl>(this, _$identity);
}

abstract class _TaxonList implements TaxonList {
  const factory _TaxonList(
      {required final int idListe,
      final String? codeListe,
      required final String nomListe,
      final String? descListe,
      final String? regne,
      final String? group2Inpn}) = _$TaxonListImpl;

  @override
  int get idListe;
  @override
  String? get codeListe;
  @override
  String get nomListe;
  @override
  String? get descListe;
  @override
  String? get regne;
  @override
  String? get group2Inpn;

  /// Create a copy of TaxonList
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaxonListImplCopyWith<_$TaxonListImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
