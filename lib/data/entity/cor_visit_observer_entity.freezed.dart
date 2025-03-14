// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cor_visit_observer_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CorVisitObserverEntity _$CorVisitObserverEntityFromJson(
    Map<String, dynamic> json) {
  return _CorVisitObserverEntity.fromJson(json);
}

/// @nodoc
mixin _$CorVisitObserverEntity {
  int get idBaseVisit => throw _privateConstructorUsedError;
  int get idRole => throw _privateConstructorUsedError;
  String get uniqueIdCoreVisitObserver => throw _privateConstructorUsedError;

  /// Serializes this CorVisitObserverEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CorVisitObserverEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CorVisitObserverEntityCopyWith<CorVisitObserverEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CorVisitObserverEntityCopyWith<$Res> {
  factory $CorVisitObserverEntityCopyWith(CorVisitObserverEntity value,
          $Res Function(CorVisitObserverEntity) then) =
      _$CorVisitObserverEntityCopyWithImpl<$Res, CorVisitObserverEntity>;
  @useResult
  $Res call({int idBaseVisit, int idRole, String uniqueIdCoreVisitObserver});
}

/// @nodoc
class _$CorVisitObserverEntityCopyWithImpl<$Res,
        $Val extends CorVisitObserverEntity>
    implements $CorVisitObserverEntityCopyWith<$Res> {
  _$CorVisitObserverEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CorVisitObserverEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idBaseVisit = null,
    Object? idRole = null,
    Object? uniqueIdCoreVisitObserver = null,
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
      uniqueIdCoreVisitObserver: null == uniqueIdCoreVisitObserver
          ? _value.uniqueIdCoreVisitObserver
          : uniqueIdCoreVisitObserver // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CorVisitObserverEntityImplCopyWith<$Res>
    implements $CorVisitObserverEntityCopyWith<$Res> {
  factory _$$CorVisitObserverEntityImplCopyWith(
          _$CorVisitObserverEntityImpl value,
          $Res Function(_$CorVisitObserverEntityImpl) then) =
      __$$CorVisitObserverEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int idBaseVisit, int idRole, String uniqueIdCoreVisitObserver});
}

/// @nodoc
class __$$CorVisitObserverEntityImplCopyWithImpl<$Res>
    extends _$CorVisitObserverEntityCopyWithImpl<$Res,
        _$CorVisitObserverEntityImpl>
    implements _$$CorVisitObserverEntityImplCopyWith<$Res> {
  __$$CorVisitObserverEntityImplCopyWithImpl(
      _$CorVisitObserverEntityImpl _value,
      $Res Function(_$CorVisitObserverEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of CorVisitObserverEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idBaseVisit = null,
    Object? idRole = null,
    Object? uniqueIdCoreVisitObserver = null,
  }) {
    return _then(_$CorVisitObserverEntityImpl(
      idBaseVisit: null == idBaseVisit
          ? _value.idBaseVisit
          : idBaseVisit // ignore: cast_nullable_to_non_nullable
              as int,
      idRole: null == idRole
          ? _value.idRole
          : idRole // ignore: cast_nullable_to_non_nullable
              as int,
      uniqueIdCoreVisitObserver: null == uniqueIdCoreVisitObserver
          ? _value.uniqueIdCoreVisitObserver
          : uniqueIdCoreVisitObserver // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CorVisitObserverEntityImpl implements _CorVisitObserverEntity {
  const _$CorVisitObserverEntityImpl(
      {required this.idBaseVisit,
      required this.idRole,
      required this.uniqueIdCoreVisitObserver});

  factory _$CorVisitObserverEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$CorVisitObserverEntityImplFromJson(json);

  @override
  final int idBaseVisit;
  @override
  final int idRole;
  @override
  final String uniqueIdCoreVisitObserver;

  @override
  String toString() {
    return 'CorVisitObserverEntity(idBaseVisit: $idBaseVisit, idRole: $idRole, uniqueIdCoreVisitObserver: $uniqueIdCoreVisitObserver)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CorVisitObserverEntityImpl &&
            (identical(other.idBaseVisit, idBaseVisit) ||
                other.idBaseVisit == idBaseVisit) &&
            (identical(other.idRole, idRole) || other.idRole == idRole) &&
            (identical(other.uniqueIdCoreVisitObserver,
                    uniqueIdCoreVisitObserver) ||
                other.uniqueIdCoreVisitObserver == uniqueIdCoreVisitObserver));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, idBaseVisit, idRole, uniqueIdCoreVisitObserver);

  /// Create a copy of CorVisitObserverEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CorVisitObserverEntityImplCopyWith<_$CorVisitObserverEntityImpl>
      get copyWith => __$$CorVisitObserverEntityImplCopyWithImpl<
          _$CorVisitObserverEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CorVisitObserverEntityImplToJson(
      this,
    );
  }
}

abstract class _CorVisitObserverEntity implements CorVisitObserverEntity {
  const factory _CorVisitObserverEntity(
          {required final int idBaseVisit,
          required final int idRole,
          required final String uniqueIdCoreVisitObserver}) =
      _$CorVisitObserverEntityImpl;

  factory _CorVisitObserverEntity.fromJson(Map<String, dynamic> json) =
      _$CorVisitObserverEntityImpl.fromJson;

  @override
  int get idBaseVisit;
  @override
  int get idRole;
  @override
  String get uniqueIdCoreVisitObserver;

  /// Create a copy of CorVisitObserverEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CorVisitObserverEntityImplCopyWith<_$CorVisitObserverEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}
