// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'site_complement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SiteComplement {
  int get idBaseSite => throw _privateConstructorUsedError;
  int? get idSitesGroup => throw _privateConstructorUsedError;
  String? get data => throw _privateConstructorUsedError;

  /// Create a copy of SiteComplement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SiteComplementCopyWith<SiteComplement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SiteComplementCopyWith<$Res> {
  factory $SiteComplementCopyWith(
          SiteComplement value, $Res Function(SiteComplement) then) =
      _$SiteComplementCopyWithImpl<$Res, SiteComplement>;
  @useResult
  $Res call({int idBaseSite, int? idSitesGroup, String? data});
}

/// @nodoc
class _$SiteComplementCopyWithImpl<$Res, $Val extends SiteComplement>
    implements $SiteComplementCopyWith<$Res> {
  _$SiteComplementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SiteComplement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idBaseSite = null,
    Object? idSitesGroup = freezed,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      idBaseSite: null == idBaseSite
          ? _value.idBaseSite
          : idBaseSite // ignore: cast_nullable_to_non_nullable
              as int,
      idSitesGroup: freezed == idSitesGroup
          ? _value.idSitesGroup
          : idSitesGroup // ignore: cast_nullable_to_non_nullable
              as int?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SiteComplementImplCopyWith<$Res>
    implements $SiteComplementCopyWith<$Res> {
  factory _$$SiteComplementImplCopyWith(_$SiteComplementImpl value,
          $Res Function(_$SiteComplementImpl) then) =
      __$$SiteComplementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int idBaseSite, int? idSitesGroup, String? data});
}

/// @nodoc
class __$$SiteComplementImplCopyWithImpl<$Res>
    extends _$SiteComplementCopyWithImpl<$Res, _$SiteComplementImpl>
    implements _$$SiteComplementImplCopyWith<$Res> {
  __$$SiteComplementImplCopyWithImpl(
      _$SiteComplementImpl _value, $Res Function(_$SiteComplementImpl) _then)
      : super(_value, _then);

  /// Create a copy of SiteComplement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idBaseSite = null,
    Object? idSitesGroup = freezed,
    Object? data = freezed,
  }) {
    return _then(_$SiteComplementImpl(
      idBaseSite: null == idBaseSite
          ? _value.idBaseSite
          : idBaseSite // ignore: cast_nullable_to_non_nullable
              as int,
      idSitesGroup: freezed == idSitesGroup
          ? _value.idSitesGroup
          : idSitesGroup // ignore: cast_nullable_to_non_nullable
              as int?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$SiteComplementImpl implements _SiteComplement {
  const _$SiteComplementImpl(
      {required this.idBaseSite, this.idSitesGroup, this.data});

  @override
  final int idBaseSite;
  @override
  final int? idSitesGroup;
  @override
  final String? data;

  @override
  String toString() {
    return 'SiteComplement(idBaseSite: $idBaseSite, idSitesGroup: $idSitesGroup, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SiteComplementImpl &&
            (identical(other.idBaseSite, idBaseSite) ||
                other.idBaseSite == idBaseSite) &&
            (identical(other.idSitesGroup, idSitesGroup) ||
                other.idSitesGroup == idSitesGroup) &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, idBaseSite, idSitesGroup, data);

  /// Create a copy of SiteComplement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SiteComplementImplCopyWith<_$SiteComplementImpl> get copyWith =>
      __$$SiteComplementImplCopyWithImpl<_$SiteComplementImpl>(
          this, _$identity);
}

abstract class _SiteComplement implements SiteComplement {
  const factory _SiteComplement(
      {required final int idBaseSite,
      final int? idSitesGroup,
      final String? data}) = _$SiteComplementImpl;

  @override
  int get idBaseSite;
  @override
  int? get idSitesGroup;
  @override
  String? get data;

  /// Create a copy of SiteComplement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SiteComplementImplCopyWith<_$SiteComplementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
