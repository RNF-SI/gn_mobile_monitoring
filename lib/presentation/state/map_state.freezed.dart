// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MapState {

/// Liste des features à afficher sur la carte
 List<MapFeature> get features;/// Liste des couches de tuiles disponibles
 List<TileLayerConfig> get tileLayers;/// Couche de tuiles sélectionnée
 TileLayerConfig? get selectedLayer;/// Position GPS de l'utilisateur
 LatLng? get userPosition;/// Précision GPS en mètres
 double? get userAccuracy;/// Indique si les données sont en cours de chargement
 bool get isLoading;/// Indique si le recentrage automatique a déjà été effectué
 bool get hasAutoCentered;/// Indique si l'utilisateur a bougé la carte manuellement
 bool get userMovedMap;/// Message d'erreur éventuel
 String? get errorMessage;/// Compléments de sites chargés (cache)
 Map<int, SiteComplement?> get siteComplements;/// Centroids des labels pour les géométries (polygones/lignes)
 Map<LatLng, MapFeature> get labelCentroids;
/// Create a copy of MapState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapStateCopyWith<MapState> get copyWith => _$MapStateCopyWithImpl<MapState>(this as MapState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapState&&const DeepCollectionEquality().equals(other.features, features)&&const DeepCollectionEquality().equals(other.tileLayers, tileLayers)&&(identical(other.selectedLayer, selectedLayer) || other.selectedLayer == selectedLayer)&&(identical(other.userPosition, userPosition) || other.userPosition == userPosition)&&(identical(other.userAccuracy, userAccuracy) || other.userAccuracy == userAccuracy)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasAutoCentered, hasAutoCentered) || other.hasAutoCentered == hasAutoCentered)&&(identical(other.userMovedMap, userMovedMap) || other.userMovedMap == userMovedMap)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other.siteComplements, siteComplements)&&const DeepCollectionEquality().equals(other.labelCentroids, labelCentroids));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(features),const DeepCollectionEquality().hash(tileLayers),selectedLayer,userPosition,userAccuracy,isLoading,hasAutoCentered,userMovedMap,errorMessage,const DeepCollectionEquality().hash(siteComplements),const DeepCollectionEquality().hash(labelCentroids));

@override
String toString() {
  return 'MapState(features: $features, tileLayers: $tileLayers, selectedLayer: $selectedLayer, userPosition: $userPosition, userAccuracy: $userAccuracy, isLoading: $isLoading, hasAutoCentered: $hasAutoCentered, userMovedMap: $userMovedMap, errorMessage: $errorMessage, siteComplements: $siteComplements, labelCentroids: $labelCentroids)';
}


}

/// @nodoc
abstract mixin class $MapStateCopyWith<$Res>  {
  factory $MapStateCopyWith(MapState value, $Res Function(MapState) _then) = _$MapStateCopyWithImpl;
@useResult
$Res call({
 List<MapFeature> features, List<TileLayerConfig> tileLayers, TileLayerConfig? selectedLayer, LatLng? userPosition, double? userAccuracy, bool isLoading, bool hasAutoCentered, bool userMovedMap, String? errorMessage, Map<int, SiteComplement?> siteComplements, Map<LatLng, MapFeature> labelCentroids
});




}
/// @nodoc
class _$MapStateCopyWithImpl<$Res>
    implements $MapStateCopyWith<$Res> {
  _$MapStateCopyWithImpl(this._self, this._then);

  final MapState _self;
  final $Res Function(MapState) _then;

/// Create a copy of MapState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? features = null,Object? tileLayers = null,Object? selectedLayer = freezed,Object? userPosition = freezed,Object? userAccuracy = freezed,Object? isLoading = null,Object? hasAutoCentered = null,Object? userMovedMap = null,Object? errorMessage = freezed,Object? siteComplements = null,Object? labelCentroids = null,}) {
  return _then(_self.copyWith(
features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as List<MapFeature>,tileLayers: null == tileLayers ? _self.tileLayers : tileLayers // ignore: cast_nullable_to_non_nullable
as List<TileLayerConfig>,selectedLayer: freezed == selectedLayer ? _self.selectedLayer : selectedLayer // ignore: cast_nullable_to_non_nullable
as TileLayerConfig?,userPosition: freezed == userPosition ? _self.userPosition : userPosition // ignore: cast_nullable_to_non_nullable
as LatLng?,userAccuracy: freezed == userAccuracy ? _self.userAccuracy : userAccuracy // ignore: cast_nullable_to_non_nullable
as double?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasAutoCentered: null == hasAutoCentered ? _self.hasAutoCentered : hasAutoCentered // ignore: cast_nullable_to_non_nullable
as bool,userMovedMap: null == userMovedMap ? _self.userMovedMap : userMovedMap // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,siteComplements: null == siteComplements ? _self.siteComplements : siteComplements // ignore: cast_nullable_to_non_nullable
as Map<int, SiteComplement?>,labelCentroids: null == labelCentroids ? _self.labelCentroids : labelCentroids // ignore: cast_nullable_to_non_nullable
as Map<LatLng, MapFeature>,
  ));
}

}


/// Adds pattern-matching-related methods to [MapState].
extension MapStatePatterns on MapState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapState value)  $default,){
final _that = this;
switch (_that) {
case _MapState():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapState value)?  $default,){
final _that = this;
switch (_that) {
case _MapState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MapFeature> features,  List<TileLayerConfig> tileLayers,  TileLayerConfig? selectedLayer,  LatLng? userPosition,  double? userAccuracy,  bool isLoading,  bool hasAutoCentered,  bool userMovedMap,  String? errorMessage,  Map<int, SiteComplement?> siteComplements,  Map<LatLng, MapFeature> labelCentroids)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapState() when $default != null:
return $default(_that.features,_that.tileLayers,_that.selectedLayer,_that.userPosition,_that.userAccuracy,_that.isLoading,_that.hasAutoCentered,_that.userMovedMap,_that.errorMessage,_that.siteComplements,_that.labelCentroids);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MapFeature> features,  List<TileLayerConfig> tileLayers,  TileLayerConfig? selectedLayer,  LatLng? userPosition,  double? userAccuracy,  bool isLoading,  bool hasAutoCentered,  bool userMovedMap,  String? errorMessage,  Map<int, SiteComplement?> siteComplements,  Map<LatLng, MapFeature> labelCentroids)  $default,) {final _that = this;
switch (_that) {
case _MapState():
return $default(_that.features,_that.tileLayers,_that.selectedLayer,_that.userPosition,_that.userAccuracy,_that.isLoading,_that.hasAutoCentered,_that.userMovedMap,_that.errorMessage,_that.siteComplements,_that.labelCentroids);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MapFeature> features,  List<TileLayerConfig> tileLayers,  TileLayerConfig? selectedLayer,  LatLng? userPosition,  double? userAccuracy,  bool isLoading,  bool hasAutoCentered,  bool userMovedMap,  String? errorMessage,  Map<int, SiteComplement?> siteComplements,  Map<LatLng, MapFeature> labelCentroids)?  $default,) {final _that = this;
switch (_that) {
case _MapState() when $default != null:
return $default(_that.features,_that.tileLayers,_that.selectedLayer,_that.userPosition,_that.userAccuracy,_that.isLoading,_that.hasAutoCentered,_that.userMovedMap,_that.errorMessage,_that.siteComplements,_that.labelCentroids);case _:
  return null;

}
}

}

/// @nodoc


class _MapState extends MapState {
  const _MapState({final  List<MapFeature> features = const [], final  List<TileLayerConfig> tileLayers = const [], this.selectedLayer, this.userPosition, this.userAccuracy, this.isLoading = false, this.hasAutoCentered = false, this.userMovedMap = false, this.errorMessage, final  Map<int, SiteComplement?> siteComplements = const {}, final  Map<LatLng, MapFeature> labelCentroids = const {}}): _features = features,_tileLayers = tileLayers,_siteComplements = siteComplements,_labelCentroids = labelCentroids,super._();
  

/// Liste des features à afficher sur la carte
 final  List<MapFeature> _features;
/// Liste des features à afficher sur la carte
@override@JsonKey() List<MapFeature> get features {
  if (_features is EqualUnmodifiableListView) return _features;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_features);
}

/// Liste des couches de tuiles disponibles
 final  List<TileLayerConfig> _tileLayers;
/// Liste des couches de tuiles disponibles
@override@JsonKey() List<TileLayerConfig> get tileLayers {
  if (_tileLayers is EqualUnmodifiableListView) return _tileLayers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tileLayers);
}

/// Couche de tuiles sélectionnée
@override final  TileLayerConfig? selectedLayer;
/// Position GPS de l'utilisateur
@override final  LatLng? userPosition;
/// Précision GPS en mètres
@override final  double? userAccuracy;
/// Indique si les données sont en cours de chargement
@override@JsonKey() final  bool isLoading;
/// Indique si le recentrage automatique a déjà été effectué
@override@JsonKey() final  bool hasAutoCentered;
/// Indique si l'utilisateur a bougé la carte manuellement
@override@JsonKey() final  bool userMovedMap;
/// Message d'erreur éventuel
@override final  String? errorMessage;
/// Compléments de sites chargés (cache)
 final  Map<int, SiteComplement?> _siteComplements;
/// Compléments de sites chargés (cache)
@override@JsonKey() Map<int, SiteComplement?> get siteComplements {
  if (_siteComplements is EqualUnmodifiableMapView) return _siteComplements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_siteComplements);
}

/// Centroids des labels pour les géométries (polygones/lignes)
 final  Map<LatLng, MapFeature> _labelCentroids;
/// Centroids des labels pour les géométries (polygones/lignes)
@override@JsonKey() Map<LatLng, MapFeature> get labelCentroids {
  if (_labelCentroids is EqualUnmodifiableMapView) return _labelCentroids;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_labelCentroids);
}


/// Create a copy of MapState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapStateCopyWith<_MapState> get copyWith => __$MapStateCopyWithImpl<_MapState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapState&&const DeepCollectionEquality().equals(other._features, _features)&&const DeepCollectionEquality().equals(other._tileLayers, _tileLayers)&&(identical(other.selectedLayer, selectedLayer) || other.selectedLayer == selectedLayer)&&(identical(other.userPosition, userPosition) || other.userPosition == userPosition)&&(identical(other.userAccuracy, userAccuracy) || other.userAccuracy == userAccuracy)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasAutoCentered, hasAutoCentered) || other.hasAutoCentered == hasAutoCentered)&&(identical(other.userMovedMap, userMovedMap) || other.userMovedMap == userMovedMap)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other._siteComplements, _siteComplements)&&const DeepCollectionEquality().equals(other._labelCentroids, _labelCentroids));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_features),const DeepCollectionEquality().hash(_tileLayers),selectedLayer,userPosition,userAccuracy,isLoading,hasAutoCentered,userMovedMap,errorMessage,const DeepCollectionEquality().hash(_siteComplements),const DeepCollectionEquality().hash(_labelCentroids));

@override
String toString() {
  return 'MapState(features: $features, tileLayers: $tileLayers, selectedLayer: $selectedLayer, userPosition: $userPosition, userAccuracy: $userAccuracy, isLoading: $isLoading, hasAutoCentered: $hasAutoCentered, userMovedMap: $userMovedMap, errorMessage: $errorMessage, siteComplements: $siteComplements, labelCentroids: $labelCentroids)';
}


}

/// @nodoc
abstract mixin class _$MapStateCopyWith<$Res> implements $MapStateCopyWith<$Res> {
  factory _$MapStateCopyWith(_MapState value, $Res Function(_MapState) _then) = __$MapStateCopyWithImpl;
@override @useResult
$Res call({
 List<MapFeature> features, List<TileLayerConfig> tileLayers, TileLayerConfig? selectedLayer, LatLng? userPosition, double? userAccuracy, bool isLoading, bool hasAutoCentered, bool userMovedMap, String? errorMessage, Map<int, SiteComplement?> siteComplements, Map<LatLng, MapFeature> labelCentroids
});




}
/// @nodoc
class __$MapStateCopyWithImpl<$Res>
    implements _$MapStateCopyWith<$Res> {
  __$MapStateCopyWithImpl(this._self, this._then);

  final _MapState _self;
  final $Res Function(_MapState) _then;

/// Create a copy of MapState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? features = null,Object? tileLayers = null,Object? selectedLayer = freezed,Object? userPosition = freezed,Object? userAccuracy = freezed,Object? isLoading = null,Object? hasAutoCentered = null,Object? userMovedMap = null,Object? errorMessage = freezed,Object? siteComplements = null,Object? labelCentroids = null,}) {
  return _then(_MapState(
features: null == features ? _self._features : features // ignore: cast_nullable_to_non_nullable
as List<MapFeature>,tileLayers: null == tileLayers ? _self._tileLayers : tileLayers // ignore: cast_nullable_to_non_nullable
as List<TileLayerConfig>,selectedLayer: freezed == selectedLayer ? _self.selectedLayer : selectedLayer // ignore: cast_nullable_to_non_nullable
as TileLayerConfig?,userPosition: freezed == userPosition ? _self.userPosition : userPosition // ignore: cast_nullable_to_non_nullable
as LatLng?,userAccuracy: freezed == userAccuracy ? _self.userAccuracy : userAccuracy // ignore: cast_nullable_to_non_nullable
as double?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasAutoCentered: null == hasAutoCentered ? _self.hasAutoCentered : hasAutoCentered // ignore: cast_nullable_to_non_nullable
as bool,userMovedMap: null == userMovedMap ? _self.userMovedMap : userMovedMap // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,siteComplements: null == siteComplements ? _self._siteComplements : siteComplements // ignore: cast_nullable_to_non_nullable
as Map<int, SiteComplement?>,labelCentroids: null == labelCentroids ? _self._labelCentroids : labelCentroids // ignore: cast_nullable_to_non_nullable
as Map<LatLng, MapFeature>,
  ));
}


}

// dart format on
