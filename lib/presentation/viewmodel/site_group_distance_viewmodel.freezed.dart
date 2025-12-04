// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'site_group_distance_viewmodel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SiteGroupDistanceState {
  Map<int, double?> get distances => throw _privateConstructorUsedError;
  bool get isCalculating => throw _privateConstructorUsedError;
  Position? get userPosition => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SiteGroupDistanceStateCopyWith<SiteGroupDistanceState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SiteGroupDistanceStateCopyWith<$Res> {
  factory $SiteGroupDistanceStateCopyWith(SiteGroupDistanceState value,
          $Res Function(SiteGroupDistanceState) then) =
      _$SiteGroupDistanceStateCopyWithImpl<$Res, SiteGroupDistanceState>;
  @useResult
  $Res call(
      {Map<int, double?> distances,
      bool isCalculating,
      Position? userPosition,
      String? error});
}

/// @nodoc
class _$SiteGroupDistanceStateCopyWithImpl<$Res,
        $Val extends SiteGroupDistanceState>
    implements $SiteGroupDistanceStateCopyWith<$Res> {
  _$SiteGroupDistanceStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? distances = null,
    Object? isCalculating = null,
    Object? userPosition = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      distances: null == distances
          ? _value.distances
          : distances // ignore: cast_nullable_to_non_nullable
              as Map<int, double?>,
      isCalculating: null == isCalculating
          ? _value.isCalculating
          : isCalculating // ignore: cast_nullable_to_non_nullable
              as bool,
      userPosition: freezed == userPosition
          ? _value.userPosition
          : userPosition // ignore: cast_nullable_to_non_nullable
              as Position?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SiteGroupDistanceStateImplCopyWith<$Res>
    implements $SiteGroupDistanceStateCopyWith<$Res> {
  factory _$$SiteGroupDistanceStateImplCopyWith(
          _$SiteGroupDistanceStateImpl value,
          $Res Function(_$SiteGroupDistanceStateImpl) then) =
      __$$SiteGroupDistanceStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<int, double?> distances,
      bool isCalculating,
      Position? userPosition,
      String? error});
}

/// @nodoc
class __$$SiteGroupDistanceStateImplCopyWithImpl<$Res>
    extends _$SiteGroupDistanceStateCopyWithImpl<$Res,
        _$SiteGroupDistanceStateImpl>
    implements _$$SiteGroupDistanceStateImplCopyWith<$Res> {
  __$$SiteGroupDistanceStateImplCopyWithImpl(
      _$SiteGroupDistanceStateImpl _value,
      $Res Function(_$SiteGroupDistanceStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? distances = null,
    Object? isCalculating = null,
    Object? userPosition = freezed,
    Object? error = freezed,
  }) {
    return _then(_$SiteGroupDistanceStateImpl(
      distances: null == distances
          ? _value._distances
          : distances // ignore: cast_nullable_to_non_nullable
              as Map<int, double?>,
      isCalculating: null == isCalculating
          ? _value.isCalculating
          : isCalculating // ignore: cast_nullable_to_non_nullable
              as bool,
      userPosition: freezed == userPosition
          ? _value.userPosition
          : userPosition // ignore: cast_nullable_to_non_nullable
              as Position?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$SiteGroupDistanceStateImpl
    with DiagnosticableTreeMixin
    implements _SiteGroupDistanceState {
  const _$SiteGroupDistanceStateImpl(
      {final Map<int, double?> distances = const {},
      this.isCalculating = false,
      this.userPosition,
      this.error})
      : _distances = distances;

  final Map<int, double?> _distances;
  @override
  @JsonKey()
  Map<int, double?> get distances {
    if (_distances is EqualUnmodifiableMapView) return _distances;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_distances);
  }

  @override
  @JsonKey()
  final bool isCalculating;
  @override
  final Position? userPosition;
  @override
  final String? error;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SiteGroupDistanceState(distances: $distances, isCalculating: $isCalculating, userPosition: $userPosition, error: $error)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SiteGroupDistanceState'))
      ..add(DiagnosticsProperty('distances', distances))
      ..add(DiagnosticsProperty('isCalculating', isCalculating))
      ..add(DiagnosticsProperty('userPosition', userPosition))
      ..add(DiagnosticsProperty('error', error));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SiteGroupDistanceStateImpl &&
            const DeepCollectionEquality()
                .equals(other._distances, _distances) &&
            (identical(other.isCalculating, isCalculating) ||
                other.isCalculating == isCalculating) &&
            (identical(other.userPosition, userPosition) ||
                other.userPosition == userPosition) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_distances),
      isCalculating,
      userPosition,
      error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SiteGroupDistanceStateImplCopyWith<_$SiteGroupDistanceStateImpl>
      get copyWith => __$$SiteGroupDistanceStateImplCopyWithImpl<
          _$SiteGroupDistanceStateImpl>(this, _$identity);
}

abstract class _SiteGroupDistanceState implements SiteGroupDistanceState {
  const factory _SiteGroupDistanceState(
      {final Map<int, double?> distances,
      final bool isCalculating,
      final Position? userPosition,
      final String? error}) = _$SiteGroupDistanceStateImpl;

  @override
  Map<int, double?> get distances;
  @override
  bool get isCalculating;
  @override
  Position? get userPosition;
  @override
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$SiteGroupDistanceStateImplCopyWith<_$SiteGroupDistanceStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
