// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_feature.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MapFeature {
  Map<String, dynamic> get properties => throw _privateConstructorUsedError;
  int? get siteId => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            LatLng point, Map<String, dynamic> properties, int? siteId)
        point,
    required TResult Function(
            List<LatLng> points, Map<String, dynamic> properties, int? siteId)
        polyline,
    required TResult Function(
            List<LatLng> points, Map<String, dynamic> properties, int? siteId)
        polygon,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            LatLng point, Map<String, dynamic> properties, int? siteId)?
        point,
    TResult? Function(
            List<LatLng> points, Map<String, dynamic> properties, int? siteId)?
        polyline,
    TResult? Function(
            List<LatLng> points, Map<String, dynamic> properties, int? siteId)?
        polygon,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            LatLng point, Map<String, dynamic> properties, int? siteId)?
        point,
    TResult Function(
            List<LatLng> points, Map<String, dynamic> properties, int? siteId)?
        polyline,
    TResult Function(
            List<LatLng> points, Map<String, dynamic> properties, int? siteId)?
        polygon,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MapPointFeature value) point,
    required TResult Function(MapPolylineFeature value) polyline,
    required TResult Function(MapPolygonFeature value) polygon,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MapPointFeature value)? point,
    TResult? Function(MapPolylineFeature value)? polyline,
    TResult? Function(MapPolygonFeature value)? polygon,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MapPointFeature value)? point,
    TResult Function(MapPolylineFeature value)? polyline,
    TResult Function(MapPolygonFeature value)? polygon,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MapFeatureCopyWith<MapFeature> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapFeatureCopyWith<$Res> {
  factory $MapFeatureCopyWith(
          MapFeature value, $Res Function(MapFeature) then) =
      _$MapFeatureCopyWithImpl<$Res, MapFeature>;
  @useResult
  $Res call({Map<String, dynamic> properties, int? siteId});
}

/// @nodoc
class _$MapFeatureCopyWithImpl<$Res, $Val extends MapFeature>
    implements $MapFeatureCopyWith<$Res> {
  _$MapFeatureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? properties = null,
    Object? siteId = freezed,
  }) {
    return _then(_value.copyWith(
      properties: null == properties
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      siteId: freezed == siteId
          ? _value.siteId
          : siteId // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MapPointFeatureImplCopyWith<$Res>
    implements $MapFeatureCopyWith<$Res> {
  factory _$$MapPointFeatureImplCopyWith(_$MapPointFeatureImpl value,
          $Res Function(_$MapPointFeatureImpl) then) =
      __$$MapPointFeatureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LatLng point, Map<String, dynamic> properties, int? siteId});
}

/// @nodoc
class __$$MapPointFeatureImplCopyWithImpl<$Res>
    extends _$MapFeatureCopyWithImpl<$Res, _$MapPointFeatureImpl>
    implements _$$MapPointFeatureImplCopyWith<$Res> {
  __$$MapPointFeatureImplCopyWithImpl(
      _$MapPointFeatureImpl _value, $Res Function(_$MapPointFeatureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? point = null,
    Object? properties = null,
    Object? siteId = freezed,
  }) {
    return _then(_$MapPointFeatureImpl(
      point: null == point
          ? _value.point
          : point // ignore: cast_nullable_to_non_nullable
              as LatLng,
      properties: null == properties
          ? _value._properties
          : properties // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      siteId: freezed == siteId
          ? _value.siteId
          : siteId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$MapPointFeatureImpl implements MapPointFeature {
  const _$MapPointFeatureImpl(
      {required this.point,
      required final Map<String, dynamic> properties,
      this.siteId})
      : _properties = properties;

  @override
  final LatLng point;
  final Map<String, dynamic> _properties;
  @override
  Map<String, dynamic> get properties {
    if (_properties is EqualUnmodifiableMapView) return _properties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_properties);
  }

  @override
  final int? siteId;

  @override
  String toString() {
    return 'MapFeature.point(point: $point, properties: $properties, siteId: $siteId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MapPointFeatureImpl &&
            (identical(other.point, point) || other.point == point) &&
            const DeepCollectionEquality()
                .equals(other._properties, _properties) &&
            (identical(other.siteId, siteId) || other.siteId == siteId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, point,
      const DeepCollectionEquality().hash(_properties), siteId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MapPointFeatureImplCopyWith<_$MapPointFeatureImpl> get copyWith =>
      __$$MapPointFeatureImplCopyWithImpl<_$MapPointFeatureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            LatLng point, Map<String, dynamic> properties, int? siteId)
        point,
    required TResult Function(
            List<LatLng> points, Map<String, dynamic> properties, int? siteId)
        polyline,
    required TResult Function(
            List<LatLng> points, Map<String, dynamic> properties, int? siteId)
        polygon,
  }) {
    return point(this.point, properties, siteId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            LatLng point, Map<String, dynamic> properties, int? siteId)?
        point,
    TResult? Function(
            List<LatLng> points, Map<String, dynamic> properties, int? siteId)?
        polyline,
    TResult? Function(
            List<LatLng> points, Map<String, dynamic> properties, int? siteId)?
        polygon,
  }) {
    return point?.call(this.point, properties, siteId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            LatLng point, Map<String, dynamic> properties, int? siteId)?
        point,
    TResult Function(
            List<LatLng> points, Map<String, dynamic> properties, int? siteId)?
        polyline,
    TResult Function(
            List<LatLng> points, Map<String, dynamic> properties, int? siteId)?
        polygon,
    required TResult orElse(),
  }) {
    if (point != null) {
      return point(this.point, properties, siteId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MapPointFeature value) point,
    required TResult Function(MapPolylineFeature value) polyline,
    required TResult Function(MapPolygonFeature value) polygon,
  }) {
    return point(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MapPointFeature value)? point,
    TResult? Function(MapPolylineFeature value)? polyline,
    TResult? Function(MapPolygonFeature value)? polygon,
  }) {
    return point?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MapPointFeature value)? point,
    TResult Function(MapPolylineFeature value)? polyline,
    TResult Function(MapPolygonFeature value)? polygon,
    required TResult orElse(),
  }) {
    if (point != null) {
      return point(this);
    }
    return orElse();
  }
}

abstract class MapPointFeature implements MapFeature {
  const factory MapPointFeature(
      {required final LatLng point,
      required final Map<String, dynamic> properties,
      final int? siteId}) = _$MapPointFeatureImpl;

  LatLng get point;
  @override
  Map<String, dynamic> get properties;
  @override
  int? get siteId;
  @override
  @JsonKey(ignore: true)
  _$$MapPointFeatureImplCopyWith<_$MapPointFeatureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MapPolylineFeatureImplCopyWith<$Res>
    implements $MapFeatureCopyWith<$Res> {
  factory _$$MapPolylineFeatureImplCopyWith(_$MapPolylineFeatureImpl value,
          $Res Function(_$MapPolylineFeatureImpl) then) =
      __$$MapPolylineFeatureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<LatLng> points, Map<String, dynamic> properties, int? siteId});
}

/// @nodoc
class __$$MapPolylineFeatureImplCopyWithImpl<$Res>
    extends _$MapFeatureCopyWithImpl<$Res, _$MapPolylineFeatureImpl>
    implements _$$MapPolylineFeatureImplCopyWith<$Res> {
  __$$MapPolylineFeatureImplCopyWithImpl(_$MapPolylineFeatureImpl _value,
      $Res Function(_$MapPolylineFeatureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? points = null,
    Object? properties = null,
    Object? siteId = freezed,
  }) {
    return _then(_$MapPolylineFeatureImpl(
      points: null == points
          ? _value._points
          : points // ignore: cast_nullable_to_non_nullable
              as List<LatLng>,
      properties: null == properties
          ? _value._properties
          : properties // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      siteId: freezed == siteId
          ? _value.siteId
          : siteId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$MapPolylineFeatureImpl implements MapPolylineFeature {
  const _$MapPolylineFeatureImpl(
      {required final List<LatLng> points,
      required final Map<String, dynamic> properties,
      this.siteId})
      : _points = points,
        _properties = properties;

  final List<LatLng> _points;
  @override
  List<LatLng> get points {
    if (_points is EqualUnmodifiableListView) return _points;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_points);
  }

  final Map<String, dynamic> _properties;
  @override
  Map<String, dynamic> get properties {
    if (_properties is EqualUnmodifiableMapView) return _properties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_properties);
  }

  @override
  final int? siteId;

  @override
  String toString() {
    return 'MapFeature.polyline(points: $points, properties: $properties, siteId: $siteId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MapPolylineFeatureImpl &&
            const DeepCollectionEquality().equals(other._points, _points) &&
            const DeepCollectionEquality()
                .equals(other._properties, _properties) &&
            (identical(other.siteId, siteId) || other.siteId == siteId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_points),
      const DeepCollectionEquality().hash(_properties),
      siteId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MapPolylineFeatureImplCopyWith<_$MapPolylineFeatureImpl> get copyWith =>
      __$$MapPolylineFeatureImplCopyWithImpl<_$MapPolylineFeatureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            LatLng point, Map<String, dynamic> properties, int? siteId)
        point,
    required TResult Function(
            List<LatLng> points, Map<String, dynamic> properties, int? siteId)
        polyline,
    required TResult Function(
            List<LatLng> points, Map<String, dynamic> properties, int? siteId)
        polygon,
  }) {
    return polyline(points, properties, siteId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            LatLng point, Map<String, dynamic> properties, int? siteId)?
        point,
    TResult? Function(
            List<LatLng> points, Map<String, dynamic> properties, int? siteId)?
        polyline,
    TResult? Function(
            List<LatLng> points, Map<String, dynamic> properties, int? siteId)?
        polygon,
  }) {
    return polyline?.call(points, properties, siteId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            LatLng point, Map<String, dynamic> properties, int? siteId)?
        point,
    TResult Function(
            List<LatLng> points, Map<String, dynamic> properties, int? siteId)?
        polyline,
    TResult Function(
            List<LatLng> points, Map<String, dynamic> properties, int? siteId)?
        polygon,
    required TResult orElse(),
  }) {
    if (polyline != null) {
      return polyline(points, properties, siteId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MapPointFeature value) point,
    required TResult Function(MapPolylineFeature value) polyline,
    required TResult Function(MapPolygonFeature value) polygon,
  }) {
    return polyline(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MapPointFeature value)? point,
    TResult? Function(MapPolylineFeature value)? polyline,
    TResult? Function(MapPolygonFeature value)? polygon,
  }) {
    return polyline?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MapPointFeature value)? point,
    TResult Function(MapPolylineFeature value)? polyline,
    TResult Function(MapPolygonFeature value)? polygon,
    required TResult orElse(),
  }) {
    if (polyline != null) {
      return polyline(this);
    }
    return orElse();
  }
}

abstract class MapPolylineFeature implements MapFeature {
  const factory MapPolylineFeature(
      {required final List<LatLng> points,
      required final Map<String, dynamic> properties,
      final int? siteId}) = _$MapPolylineFeatureImpl;

  List<LatLng> get points;
  @override
  Map<String, dynamic> get properties;
  @override
  int? get siteId;
  @override
  @JsonKey(ignore: true)
  _$$MapPolylineFeatureImplCopyWith<_$MapPolylineFeatureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MapPolygonFeatureImplCopyWith<$Res>
    implements $MapFeatureCopyWith<$Res> {
  factory _$$MapPolygonFeatureImplCopyWith(_$MapPolygonFeatureImpl value,
          $Res Function(_$MapPolygonFeatureImpl) then) =
      __$$MapPolygonFeatureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<LatLng> points, Map<String, dynamic> properties, int? siteId});
}

/// @nodoc
class __$$MapPolygonFeatureImplCopyWithImpl<$Res>
    extends _$MapFeatureCopyWithImpl<$Res, _$MapPolygonFeatureImpl>
    implements _$$MapPolygonFeatureImplCopyWith<$Res> {
  __$$MapPolygonFeatureImplCopyWithImpl(_$MapPolygonFeatureImpl _value,
      $Res Function(_$MapPolygonFeatureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? points = null,
    Object? properties = null,
    Object? siteId = freezed,
  }) {
    return _then(_$MapPolygonFeatureImpl(
      points: null == points
          ? _value._points
          : points // ignore: cast_nullable_to_non_nullable
              as List<LatLng>,
      properties: null == properties
          ? _value._properties
          : properties // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      siteId: freezed == siteId
          ? _value.siteId
          : siteId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$MapPolygonFeatureImpl implements MapPolygonFeature {
  const _$MapPolygonFeatureImpl(
      {required final List<LatLng> points,
      required final Map<String, dynamic> properties,
      this.siteId})
      : _points = points,
        _properties = properties;

  final List<LatLng> _points;
  @override
  List<LatLng> get points {
    if (_points is EqualUnmodifiableListView) return _points;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_points);
  }

  final Map<String, dynamic> _properties;
  @override
  Map<String, dynamic> get properties {
    if (_properties is EqualUnmodifiableMapView) return _properties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_properties);
  }

  @override
  final int? siteId;

  @override
  String toString() {
    return 'MapFeature.polygon(points: $points, properties: $properties, siteId: $siteId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MapPolygonFeatureImpl &&
            const DeepCollectionEquality().equals(other._points, _points) &&
            const DeepCollectionEquality()
                .equals(other._properties, _properties) &&
            (identical(other.siteId, siteId) || other.siteId == siteId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_points),
      const DeepCollectionEquality().hash(_properties),
      siteId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MapPolygonFeatureImplCopyWith<_$MapPolygonFeatureImpl> get copyWith =>
      __$$MapPolygonFeatureImplCopyWithImpl<_$MapPolygonFeatureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            LatLng point, Map<String, dynamic> properties, int? siteId)
        point,
    required TResult Function(
            List<LatLng> points, Map<String, dynamic> properties, int? siteId)
        polyline,
    required TResult Function(
            List<LatLng> points, Map<String, dynamic> properties, int? siteId)
        polygon,
  }) {
    return polygon(points, properties, siteId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            LatLng point, Map<String, dynamic> properties, int? siteId)?
        point,
    TResult? Function(
            List<LatLng> points, Map<String, dynamic> properties, int? siteId)?
        polyline,
    TResult? Function(
            List<LatLng> points, Map<String, dynamic> properties, int? siteId)?
        polygon,
  }) {
    return polygon?.call(points, properties, siteId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            LatLng point, Map<String, dynamic> properties, int? siteId)?
        point,
    TResult Function(
            List<LatLng> points, Map<String, dynamic> properties, int? siteId)?
        polyline,
    TResult Function(
            List<LatLng> points, Map<String, dynamic> properties, int? siteId)?
        polygon,
    required TResult orElse(),
  }) {
    if (polygon != null) {
      return polygon(points, properties, siteId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MapPointFeature value) point,
    required TResult Function(MapPolylineFeature value) polyline,
    required TResult Function(MapPolygonFeature value) polygon,
  }) {
    return polygon(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MapPointFeature value)? point,
    TResult? Function(MapPolylineFeature value)? polyline,
    TResult? Function(MapPolygonFeature value)? polygon,
  }) {
    return polygon?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MapPointFeature value)? point,
    TResult Function(MapPolylineFeature value)? polyline,
    TResult Function(MapPolygonFeature value)? polygon,
    required TResult orElse(),
  }) {
    if (polygon != null) {
      return polygon(this);
    }
    return orElse();
  }
}

abstract class MapPolygonFeature implements MapFeature {
  const factory MapPolygonFeature(
      {required final List<LatLng> points,
      required final Map<String, dynamic> properties,
      final int? siteId}) = _$MapPolygonFeatureImpl;

  List<LatLng> get points;
  @override
  Map<String, dynamic> get properties;
  @override
  int? get siteId;
  @override
  @JsonKey(ignore: true)
  _$$MapPolygonFeatureImplCopyWith<_$MapPolygonFeatureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
