// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'visit_observer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VisitObserver _$VisitObserverFromJson(Map<String, dynamic> json) {
  return _VisitObserver.fromJson(json);
}

/// @nodoc
mixin _$VisitObserver {
  int get idBaseVisit => throw _privateConstructorUsedError;
  int get idRole => throw _privateConstructorUsedError;
  String get uniqueId => throw _privateConstructorUsedError;

  /// Serializes this VisitObserver to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VisitObserver
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VisitObserverCopyWith<VisitObserver> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VisitObserverCopyWith<$Res> {
  factory $VisitObserverCopyWith(
          VisitObserver value, $Res Function(VisitObserver) then) =
      _$VisitObserverCopyWithImpl<$Res, VisitObserver>;
  @useResult
  $Res call({int idBaseVisit, int idRole, String uniqueId});
}

/// @nodoc
class _$VisitObserverCopyWithImpl<$Res, $Val extends VisitObserver>
    implements $VisitObserverCopyWith<$Res> {
  _$VisitObserverCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VisitObserver
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idBaseVisit = null,
    Object? idRole = null,
    Object? uniqueId = null,
  }) {
    return _then(_value.copyWith(
      idBaseVisit: null == idBaseVisit
          ? _value.idBaseVisit
          : idBaseVisit // ignore: cast_nullable_to_non_nullable
              as int,
      idRole: null == idRole
          ? _value.idRole
          : idRole // ignore: cast_nullable_to_non_nullable
              as int,
      uniqueId: null == uniqueId
          ? _value.uniqueId
          : uniqueId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VisitObserverImplCopyWith<$Res>
    implements $VisitObserverCopyWith<$Res> {
  factory _$$VisitObserverImplCopyWith(
          _$VisitObserverImpl value, $Res Function(_$VisitObserverImpl) then) =
      __$$VisitObserverImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int idBaseVisit, int idRole, String uniqueId});
}

/// @nodoc
class __$$VisitObserverImplCopyWithImpl<$Res>
    extends _$VisitObserverCopyWithImpl<$Res, _$VisitObserverImpl>
    implements _$$VisitObserverImplCopyWith<$Res> {
  __$$VisitObserverImplCopyWithImpl(
      _$VisitObserverImpl _value, $Res Function(_$VisitObserverImpl) _then)
      : super(_value, _then);

  /// Create a copy of VisitObserver
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idBaseVisit = null,
    Object? idRole = null,
    Object? uniqueId = null,
  }) {
    return _then(_$VisitObserverImpl(
      idBaseVisit: null == idBaseVisit
          ? _value.idBaseVisit
          : idBaseVisit // ignore: cast_nullable_to_non_nullable
              as int,
      idRole: null == idRole
          ? _value.idRole
          : idRole // ignore: cast_nullable_to_non_nullable
              as int,
      uniqueId: null == uniqueId
          ? _value.uniqueId
          : uniqueId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VisitObserverImpl implements _VisitObserver {
  const _$VisitObserverImpl(
      {required this.idBaseVisit,
      required this.idRole,
      required this.uniqueId});

  factory _$VisitObserverImpl.fromJson(Map<String, dynamic> json) =>
      _$$VisitObserverImplFromJson(json);

  @override
  final int idBaseVisit;
  @override
  final int idRole;
  @override
  final String uniqueId;

  @override
  String toString() {
    return 'VisitObserver(idBaseVisit: $idBaseVisit, idRole: $idRole, uniqueId: $uniqueId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VisitObserverImpl &&
            (identical(other.idBaseVisit, idBaseVisit) ||
                other.idBaseVisit == idBaseVisit) &&
            (identical(other.idRole, idRole) || other.idRole == idRole) &&
            (identical(other.uniqueId, uniqueId) ||
                other.uniqueId == uniqueId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, idBaseVisit, idRole, uniqueId);

  /// Create a copy of VisitObserver
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VisitObserverImplCopyWith<_$VisitObserverImpl> get copyWith =>
      __$$VisitObserverImplCopyWithImpl<_$VisitObserverImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VisitObserverImplToJson(
      this,
    );
  }
}

abstract class _VisitObserver implements VisitObserver {
  const factory _VisitObserver(
      {required final int idBaseVisit,
      required final int idRole,
      required final String uniqueId}) = _$VisitObserverImpl;

  factory _VisitObserver.fromJson(Map<String, dynamic> json) =
      _$VisitObserverImpl.fromJson;

  @override
  int get idBaseVisit;
  @override
  int get idRole;
  @override
  String get uniqueId;

  /// Create a copy of VisitObserver
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VisitObserverImplCopyWith<_$VisitObserverImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
