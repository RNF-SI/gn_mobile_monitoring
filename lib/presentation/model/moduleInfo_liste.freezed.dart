// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'moduleInfo_liste.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ModuleInfoListe {
  List<ModuleInfo> get values => throw _privateConstructorUsedError;

  /// Create a copy of ModuleInfoListe
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ModuleInfoListeCopyWith<ModuleInfoListe> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModuleInfoListeCopyWith<$Res> {
  factory $ModuleInfoListeCopyWith(
          ModuleInfoListe value, $Res Function(ModuleInfoListe) then) =
      _$ModuleInfoListeCopyWithImpl<$Res, ModuleInfoListe>;
  @useResult
  $Res call({List<ModuleInfo> values});
}

/// @nodoc
class _$ModuleInfoListeCopyWithImpl<$Res, $Val extends ModuleInfoListe>
    implements $ModuleInfoListeCopyWith<$Res> {
  _$ModuleInfoListeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ModuleInfoListe
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? values = null,
  }) {
    return _then(_value.copyWith(
      values: null == values
          ? _value.values
          : values // ignore: cast_nullable_to_non_nullable
              as List<ModuleInfo>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ModuleInfoListeImplCopyWith<$Res>
    implements $ModuleInfoListeCopyWith<$Res> {
  factory _$$ModuleInfoListeImplCopyWith(_$ModuleInfoListeImpl value,
          $Res Function(_$ModuleInfoListeImpl) then) =
      __$$ModuleInfoListeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ModuleInfo> values});
}

/// @nodoc
class __$$ModuleInfoListeImplCopyWithImpl<$Res>
    extends _$ModuleInfoListeCopyWithImpl<$Res, _$ModuleInfoListeImpl>
    implements _$$ModuleInfoListeImplCopyWith<$Res> {
  __$$ModuleInfoListeImplCopyWithImpl(
      _$ModuleInfoListeImpl _value, $Res Function(_$ModuleInfoListeImpl) _then)
      : super(_value, _then);

  /// Create a copy of ModuleInfoListe
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? values = null,
  }) {
    return _then(_$ModuleInfoListeImpl(
      values: null == values
          ? _value._values
          : values // ignore: cast_nullable_to_non_nullable
              as List<ModuleInfo>,
    ));
  }
}

/// @nodoc

class _$ModuleInfoListeImpl extends _ModuleInfoListe {
  const _$ModuleInfoListeImpl({required final List<ModuleInfo> values})
      : _values = values,
        super._();

  final List<ModuleInfo> _values;
  @override
  List<ModuleInfo> get values {
    if (_values is EqualUnmodifiableListView) return _values;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_values);
  }

  @override
  String toString() {
    return 'ModuleInfoListe(values: $values)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModuleInfoListeImpl &&
            const DeepCollectionEquality().equals(other._values, _values));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_values));

  /// Create a copy of ModuleInfoListe
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ModuleInfoListeImplCopyWith<_$ModuleInfoListeImpl> get copyWith =>
      __$$ModuleInfoListeImplCopyWithImpl<_$ModuleInfoListeImpl>(
          this, _$identity);
}

abstract class _ModuleInfoListe extends ModuleInfoListe {
  const factory _ModuleInfoListe({required final List<ModuleInfo> values}) =
      _$ModuleInfoListeImpl;
  const _ModuleInfoListe._() : super._();

  @override
  List<ModuleInfo> get values;

  /// Create a copy of ModuleInfoListe
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ModuleInfoListeImplCopyWith<_$ModuleInfoListeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
