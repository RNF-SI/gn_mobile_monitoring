// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'module_liste.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ModuleListe {
  List<Module> get values => throw _privateConstructorUsedError;

  /// Create a copy of ModuleListe
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ModuleListeCopyWith<ModuleListe> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModuleListeCopyWith<$Res> {
  factory $ModuleListeCopyWith(
          ModuleListe value, $Res Function(ModuleListe) then) =
      _$ModuleListeCopyWithImpl<$Res, ModuleListe>;
  @useResult
  $Res call({List<Module> values});
}

/// @nodoc
class _$ModuleListeCopyWithImpl<$Res, $Val extends ModuleListe>
    implements $ModuleListeCopyWith<$Res> {
  _$ModuleListeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ModuleListe
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
              as List<Module>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ModuleListeImplCopyWith<$Res>
    implements $ModuleListeCopyWith<$Res> {
  factory _$$ModuleListeImplCopyWith(
          _$ModuleListeImpl value, $Res Function(_$ModuleListeImpl) then) =
      __$$ModuleListeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Module> values});
}

/// @nodoc
class __$$ModuleListeImplCopyWithImpl<$Res>
    extends _$ModuleListeCopyWithImpl<$Res, _$ModuleListeImpl>
    implements _$$ModuleListeImplCopyWith<$Res> {
  __$$ModuleListeImplCopyWithImpl(
      _$ModuleListeImpl _value, $Res Function(_$ModuleListeImpl) _then)
      : super(_value, _then);

  /// Create a copy of ModuleListe
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? values = null,
  }) {
    return _then(_$ModuleListeImpl(
      values: null == values
          ? _value._values
          : values // ignore: cast_nullable_to_non_nullable
              as List<Module>,
    ));
  }
}

/// @nodoc

class _$ModuleListeImpl extends _ModuleListe {
  const _$ModuleListeImpl({required final List<Module> values})
      : _values = values,
        super._();

  final List<Module> _values;
  @override
  List<Module> get values {
    if (_values is EqualUnmodifiableListView) return _values;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_values);
  }

  @override
  String toString() {
    return 'ModuleListe(values: $values)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModuleListeImpl &&
            const DeepCollectionEquality().equals(other._values, _values));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_values));

  /// Create a copy of ModuleListe
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ModuleListeImplCopyWith<_$ModuleListeImpl> get copyWith =>
      __$$ModuleListeImplCopyWithImpl<_$ModuleListeImpl>(this, _$identity);
}

abstract class _ModuleListe extends ModuleListe {
  const factory _ModuleListe({required final List<Module> values}) =
      _$ModuleListeImpl;
  const _ModuleListe._() : super._();

  @override
  List<Module> get values;

  /// Create a copy of ModuleListe
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ModuleListeImplCopyWith<_$ModuleListeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
