// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_feature.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MapFeature {

 Map<String, dynamic> get properties; int? get siteId;
/// Create a copy of MapFeature
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapFeatureCopyWith<MapFeature> get copyWith => _$MapFeatureCopyWithImpl<MapFeature>(this as MapFeature, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapFeature&&const DeepCollectionEquality().equals(other.properties, properties)&&(identical(other.siteId, siteId) || other.siteId == siteId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(properties),siteId);

@override
String toString() {
  return 'MapFeature(properties: $properties, siteId: $siteId)';
}


}

/// @nodoc
abstract mixin class $MapFeatureCopyWith<$Res>  {
  factory $MapFeatureCopyWith(MapFeature value, $Res Function(MapFeature) _then) = _$MapFeatureCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic> properties, int? siteId
});




}
/// @nodoc
class _$MapFeatureCopyWithImpl<$Res>
    implements $MapFeatureCopyWith<$Res> {
  _$MapFeatureCopyWithImpl(this._self, this._then);

  final MapFeature _self;
  final $Res Function(MapFeature) _then;

/// Create a copy of MapFeature
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? properties = null,Object? siteId = freezed,}) {
  return _then(_self.copyWith(
properties: null == properties ? _self.properties : properties // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,siteId: freezed == siteId ? _self.siteId : siteId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MapFeature].
extension MapFeaturePatterns on MapFeature {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MapPointFeature value)?  point,TResult Function( MapPolylineFeature value)?  polyline,TResult Function( MapPolygonFeature value)?  polygon,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MapPointFeature() when point != null:
return point(_that);case MapPolylineFeature() when polyline != null:
return polyline(_that);case MapPolygonFeature() when polygon != null:
return polygon(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MapPointFeature value)  point,required TResult Function( MapPolylineFeature value)  polyline,required TResult Function( MapPolygonFeature value)  polygon,}){
final _that = this;
switch (_that) {
case MapPointFeature():
return point(_that);case MapPolylineFeature():
return polyline(_that);case MapPolygonFeature():
return polygon(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MapPointFeature value)?  point,TResult? Function( MapPolylineFeature value)?  polyline,TResult? Function( MapPolygonFeature value)?  polygon,}){
final _that = this;
switch (_that) {
case MapPointFeature() when point != null:
return point(_that);case MapPolylineFeature() when polyline != null:
return polyline(_that);case MapPolygonFeature() when polygon != null:
return polygon(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( LatLng point,  Map<String, dynamic> properties,  int? siteId)?  point,TResult Function( List<LatLng> points,  Map<String, dynamic> properties,  int? siteId)?  polyline,TResult Function( List<LatLng> points,  Map<String, dynamic> properties,  int? siteId)?  polygon,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MapPointFeature() when point != null:
return point(_that.point,_that.properties,_that.siteId);case MapPolylineFeature() when polyline != null:
return polyline(_that.points,_that.properties,_that.siteId);case MapPolygonFeature() when polygon != null:
return polygon(_that.points,_that.properties,_that.siteId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( LatLng point,  Map<String, dynamic> properties,  int? siteId)  point,required TResult Function( List<LatLng> points,  Map<String, dynamic> properties,  int? siteId)  polyline,required TResult Function( List<LatLng> points,  Map<String, dynamic> properties,  int? siteId)  polygon,}) {final _that = this;
switch (_that) {
case MapPointFeature():
return point(_that.point,_that.properties,_that.siteId);case MapPolylineFeature():
return polyline(_that.points,_that.properties,_that.siteId);case MapPolygonFeature():
return polygon(_that.points,_that.properties,_that.siteId);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( LatLng point,  Map<String, dynamic> properties,  int? siteId)?  point,TResult? Function( List<LatLng> points,  Map<String, dynamic> properties,  int? siteId)?  polyline,TResult? Function( List<LatLng> points,  Map<String, dynamic> properties,  int? siteId)?  polygon,}) {final _that = this;
switch (_that) {
case MapPointFeature() when point != null:
return point(_that.point,_that.properties,_that.siteId);case MapPolylineFeature() when polyline != null:
return polyline(_that.points,_that.properties,_that.siteId);case MapPolygonFeature() when polygon != null:
return polygon(_that.points,_that.properties,_that.siteId);case _:
  return null;

}
}

}

/// @nodoc


class MapPointFeature implements MapFeature {
  const MapPointFeature({required this.point, required final  Map<String, dynamic> properties, this.siteId}): _properties = properties;
  

 final  LatLng point;
 final  Map<String, dynamic> _properties;
@override Map<String, dynamic> get properties {
  if (_properties is EqualUnmodifiableMapView) return _properties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_properties);
}

@override final  int? siteId;

/// Create a copy of MapFeature
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapPointFeatureCopyWith<MapPointFeature> get copyWith => _$MapPointFeatureCopyWithImpl<MapPointFeature>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapPointFeature&&(identical(other.point, point) || other.point == point)&&const DeepCollectionEquality().equals(other._properties, _properties)&&(identical(other.siteId, siteId) || other.siteId == siteId));
}


@override
int get hashCode => Object.hash(runtimeType,point,const DeepCollectionEquality().hash(_properties),siteId);

@override
String toString() {
  return 'MapFeature.point(point: $point, properties: $properties, siteId: $siteId)';
}


}

/// @nodoc
abstract mixin class $MapPointFeatureCopyWith<$Res> implements $MapFeatureCopyWith<$Res> {
  factory $MapPointFeatureCopyWith(MapPointFeature value, $Res Function(MapPointFeature) _then) = _$MapPointFeatureCopyWithImpl;
@override @useResult
$Res call({
 LatLng point, Map<String, dynamic> properties, int? siteId
});




}
/// @nodoc
class _$MapPointFeatureCopyWithImpl<$Res>
    implements $MapPointFeatureCopyWith<$Res> {
  _$MapPointFeatureCopyWithImpl(this._self, this._then);

  final MapPointFeature _self;
  final $Res Function(MapPointFeature) _then;

/// Create a copy of MapFeature
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? point = null,Object? properties = null,Object? siteId = freezed,}) {
  return _then(MapPointFeature(
point: null == point ? _self.point : point // ignore: cast_nullable_to_non_nullable
as LatLng,properties: null == properties ? _self._properties : properties // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,siteId: freezed == siteId ? _self.siteId : siteId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class MapPolylineFeature implements MapFeature {
  const MapPolylineFeature({required final  List<LatLng> points, required final  Map<String, dynamic> properties, this.siteId}): _points = points,_properties = properties;
  

 final  List<LatLng> _points;
 List<LatLng> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}

 final  Map<String, dynamic> _properties;
@override Map<String, dynamic> get properties {
  if (_properties is EqualUnmodifiableMapView) return _properties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_properties);
}

@override final  int? siteId;

/// Create a copy of MapFeature
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapPolylineFeatureCopyWith<MapPolylineFeature> get copyWith => _$MapPolylineFeatureCopyWithImpl<MapPolylineFeature>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapPolylineFeature&&const DeepCollectionEquality().equals(other._points, _points)&&const DeepCollectionEquality().equals(other._properties, _properties)&&(identical(other.siteId, siteId) || other.siteId == siteId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_points),const DeepCollectionEquality().hash(_properties),siteId);

@override
String toString() {
  return 'MapFeature.polyline(points: $points, properties: $properties, siteId: $siteId)';
}


}

/// @nodoc
abstract mixin class $MapPolylineFeatureCopyWith<$Res> implements $MapFeatureCopyWith<$Res> {
  factory $MapPolylineFeatureCopyWith(MapPolylineFeature value, $Res Function(MapPolylineFeature) _then) = _$MapPolylineFeatureCopyWithImpl;
@override @useResult
$Res call({
 List<LatLng> points, Map<String, dynamic> properties, int? siteId
});




}
/// @nodoc
class _$MapPolylineFeatureCopyWithImpl<$Res>
    implements $MapPolylineFeatureCopyWith<$Res> {
  _$MapPolylineFeatureCopyWithImpl(this._self, this._then);

  final MapPolylineFeature _self;
  final $Res Function(MapPolylineFeature) _then;

/// Create a copy of MapFeature
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? points = null,Object? properties = null,Object? siteId = freezed,}) {
  return _then(MapPolylineFeature(
points: null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<LatLng>,properties: null == properties ? _self._properties : properties // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,siteId: freezed == siteId ? _self.siteId : siteId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class MapPolygonFeature implements MapFeature {
  const MapPolygonFeature({required final  List<LatLng> points, required final  Map<String, dynamic> properties, this.siteId}): _points = points,_properties = properties;
  

 final  List<LatLng> _points;
 List<LatLng> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}

 final  Map<String, dynamic> _properties;
@override Map<String, dynamic> get properties {
  if (_properties is EqualUnmodifiableMapView) return _properties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_properties);
}

@override final  int? siteId;

/// Create a copy of MapFeature
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapPolygonFeatureCopyWith<MapPolygonFeature> get copyWith => _$MapPolygonFeatureCopyWithImpl<MapPolygonFeature>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapPolygonFeature&&const DeepCollectionEquality().equals(other._points, _points)&&const DeepCollectionEquality().equals(other._properties, _properties)&&(identical(other.siteId, siteId) || other.siteId == siteId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_points),const DeepCollectionEquality().hash(_properties),siteId);

@override
String toString() {
  return 'MapFeature.polygon(points: $points, properties: $properties, siteId: $siteId)';
}


}

/// @nodoc
abstract mixin class $MapPolygonFeatureCopyWith<$Res> implements $MapFeatureCopyWith<$Res> {
  factory $MapPolygonFeatureCopyWith(MapPolygonFeature value, $Res Function(MapPolygonFeature) _then) = _$MapPolygonFeatureCopyWithImpl;
@override @useResult
$Res call({
 List<LatLng> points, Map<String, dynamic> properties, int? siteId
});




}
/// @nodoc
class _$MapPolygonFeatureCopyWithImpl<$Res>
    implements $MapPolygonFeatureCopyWith<$Res> {
  _$MapPolygonFeatureCopyWithImpl(this._self, this._then);

  final MapPolygonFeature _self;
  final $Res Function(MapPolygonFeature) _then;

/// Create a copy of MapFeature
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? points = null,Object? properties = null,Object? siteId = freezed,}) {
  return _then(MapPolygonFeature(
points: null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<LatLng>,properties: null == properties ? _self._properties : properties // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,siteId: freezed == siteId ? _self.siteId : siteId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
