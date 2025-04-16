// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bib_type_site.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BibTypeSite {
  int get idNomenclatureTypeSite => throw _privateConstructorUsedError;
  Map<String, dynamic>? get config => throw _privateConstructorUsedError;

  /// Create a copy of BibTypeSite
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BibTypeSiteCopyWith<BibTypeSite> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BibTypeSiteCopyWith<$Res> {
  factory $BibTypeSiteCopyWith(
          BibTypeSite value, $Res Function(BibTypeSite) then) =
      _$BibTypeSiteCopyWithImpl<$Res, BibTypeSite>;
  @useResult
  $Res call({int idNomenclatureTypeSite, Map<String, dynamic>? config});
}

/// @nodoc
class _$BibTypeSiteCopyWithImpl<$Res, $Val extends BibTypeSite>
    implements $BibTypeSiteCopyWith<$Res> {
  _$BibTypeSiteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BibTypeSite
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idNomenclatureTypeSite = null,
    Object? config = freezed,
  }) {
    return _then(_value.copyWith(
      idNomenclatureTypeSite: null == idNomenclatureTypeSite
          ? _value.idNomenclatureTypeSite
          : idNomenclatureTypeSite // ignore: cast_nullable_to_non_nullable
              as int,
      config: freezed == config
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BibTypeSiteImplCopyWith<$Res>
    implements $BibTypeSiteCopyWith<$Res> {
  factory _$$BibTypeSiteImplCopyWith(
          _$BibTypeSiteImpl value, $Res Function(_$BibTypeSiteImpl) then) =
      __$$BibTypeSiteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int idNomenclatureTypeSite, Map<String, dynamic>? config});
}

/// @nodoc
class __$$BibTypeSiteImplCopyWithImpl<$Res>
    extends _$BibTypeSiteCopyWithImpl<$Res, _$BibTypeSiteImpl>
    implements _$$BibTypeSiteImplCopyWith<$Res> {
  __$$BibTypeSiteImplCopyWithImpl(
      _$BibTypeSiteImpl _value, $Res Function(_$BibTypeSiteImpl) _then)
      : super(_value, _then);

  /// Create a copy of BibTypeSite
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idNomenclatureTypeSite = null,
    Object? config = freezed,
  }) {
    return _then(_$BibTypeSiteImpl(
      idNomenclatureTypeSite: null == idNomenclatureTypeSite
          ? _value.idNomenclatureTypeSite
          : idNomenclatureTypeSite // ignore: cast_nullable_to_non_nullable
              as int,
      config: freezed == config
          ? _value._config
          : config // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$BibTypeSiteImpl implements _BibTypeSite {
  const _$BibTypeSiteImpl(
      {required this.idNomenclatureTypeSite,
      final Map<String, dynamic>? config})
      : _config = config;

  @override
  final int idNomenclatureTypeSite;
  final Map<String, dynamic>? _config;
  @override
  Map<String, dynamic>? get config {
    final value = _config;
    if (value == null) return null;
    if (_config is EqualUnmodifiableMapView) return _config;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'BibTypeSite(idNomenclatureTypeSite: $idNomenclatureTypeSite, config: $config)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BibTypeSiteImpl &&
            (identical(other.idNomenclatureTypeSite, idNomenclatureTypeSite) ||
                other.idNomenclatureTypeSite == idNomenclatureTypeSite) &&
            const DeepCollectionEquality().equals(other._config, _config));
  }

  @override
  int get hashCode => Object.hash(runtimeType, idNomenclatureTypeSite,
      const DeepCollectionEquality().hash(_config));

  /// Create a copy of BibTypeSite
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BibTypeSiteImplCopyWith<_$BibTypeSiteImpl> get copyWith =>
      __$$BibTypeSiteImplCopyWithImpl<_$BibTypeSiteImpl>(this, _$identity);
}

abstract class _BibTypeSite implements BibTypeSite {
  const factory _BibTypeSite(
      {required final int idNomenclatureTypeSite,
      final Map<String, dynamic>? config}) = _$BibTypeSiteImpl;

  @override
  int get idNomenclatureTypeSite;
  @override
  Map<String, dynamic>? get config;

  /// Create a copy of BibTypeSite
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BibTypeSiteImplCopyWith<_$BibTypeSiteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
