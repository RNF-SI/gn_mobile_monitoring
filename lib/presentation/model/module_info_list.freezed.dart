// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'module_info_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ModuleInfoList {
  List<ModuleInfo> get values => throw _privateConstructorUsedError;

  /// Create a copy of ModuleInfoList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ModuleInfoListCopyWith<ModuleInfoList> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModuleInfoListCopyWith<$Res> {
  factory $ModuleInfoListCopyWith(
          ModuleInfoList value, $Res Function(ModuleInfoList) then) =
      _$ModuleInfoListCopyWithImpl<$Res, ModuleInfoList>;
  @useResult
  $Res call({List<ModuleInfo> values});
}

/// @nodoc
class _$ModuleInfoListCopyWithImpl<$Res, $Val extends ModuleInfoList>
    implements $ModuleInfoListCopyWith<$Res> {
  _$ModuleInfoListCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ModuleInfoList
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
abstract class _$$ModuleInfoListImplCopyWith<$Res>
    implements $ModuleInfoListCopyWith<$Res> {
  factory _$$ModuleInfoListImplCopyWith(_$ModuleInfoListImpl value,
          $Res Function(_$ModuleInfoListImpl) then) =
      __$$ModuleInfoListImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ModuleInfo> values});
}

/// @nodoc
class __$$ModuleInfoListImplCopyWithImpl<$Res>
    extends _$ModuleInfoListCopyWithImpl<$Res, _$ModuleInfoListImpl>
    implements _$$ModuleInfoListImplCopyWith<$Res> {
  __$$ModuleInfoListImplCopyWithImpl(
      _$ModuleInfoListImpl _value, $Res Function(_$ModuleInfoListImpl) _then)
      : super(_value, _then);

  /// Create a copy of ModuleInfoList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? values = null,
  }) {
    return _then(_$ModuleInfoListImpl(
      values: null == values
          ? _value._values
          : values // ignore: cast_nullable_to_non_nullable
              as List<ModuleInfo>,
    ));
  }
}

/// @nodoc

class _$ModuleInfoListImpl extends _ModuleInfoList {
  const _$ModuleInfoListImpl({required final List<ModuleInfo> values})
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
    return 'ModuleInfoList(values: $values)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModuleInfoListImpl &&
            const DeepCollectionEquality().equals(other._values, _values));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_values));

  /// Create a copy of ModuleInfoList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ModuleInfoListImplCopyWith<_$ModuleInfoListImpl> get copyWith =>
      __$$ModuleInfoListImplCopyWithImpl<_$ModuleInfoListImpl>(
          this, _$identity);
}

abstract class _ModuleInfoList extends ModuleInfoList {
  const factory _ModuleInfoList({required final List<ModuleInfo> values}) =
      _$ModuleInfoListImpl;
  const _ModuleInfoList._() : super._();

  @override
  List<ModuleInfo> get values;

  /// Create a copy of ModuleInfoList
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ModuleInfoListImplCopyWith<_$ModuleInfoListImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
