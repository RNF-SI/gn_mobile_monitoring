// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MapState {
  /// Liste des features à afficher sur la carte
  List<MapFeature> get features => throw _privateConstructorUsedError;

  /// Liste des couches de tuiles disponibles
  List<TileLayerConfig> get tileLayers => throw _privateConstructorUsedError;

  /// Couche de tuiles sélectionnée
  TileLayerConfig? get selectedLayer => throw _privateConstructorUsedError;

  /// Position GPS de l'utilisateur
  LatLng? get userPosition => throw _privateConstructorUsedError;

  /// Précision GPS en mètres
  double? get userAccuracy => throw _privateConstructorUsedError;

  /// Indique si les données sont en cours de chargement
  bool get isLoading => throw _privateConstructorUsedError;

  /// Indique si le recentrage automatique a déjà été effectué
  bool get hasAutoCentered => throw _privateConstructorUsedError;

  /// Indique si l'utilisateur a bougé la carte manuellement
  bool get userMovedMap => throw _privateConstructorUsedError;

  /// Message d'erreur éventuel
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Compléments de sites chargés (cache)
  Map<int, SiteComplement?> get siteComplements =>
      throw _privateConstructorUsedError;

  /// Centroids des labels pour les géométries (polygones/lignes)
  Map<LatLng, MapFeature> get labelCentroids =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MapStateCopyWith<MapState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapStateCopyWith<$Res> {
  factory $MapStateCopyWith(MapState value, $Res Function(MapState) then) =
      _$MapStateCopyWithImpl<$Res, MapState>;
  @useResult
  $Res call(
      {List<MapFeature> features,
      List<TileLayerConfig> tileLayers,
      TileLayerConfig? selectedLayer,
      LatLng? userPosition,
      double? userAccuracy,
      bool isLoading,
      bool hasAutoCentered,
      bool userMovedMap,
      String? errorMessage,
      Map<int, SiteComplement?> siteComplements,
      Map<LatLng, MapFeature> labelCentroids});
}

/// @nodoc
class _$MapStateCopyWithImpl<$Res, $Val extends MapState>
    implements $MapStateCopyWith<$Res> {
  _$MapStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? features = null,
    Object? tileLayers = null,
    Object? selectedLayer = freezed,
    Object? userPosition = freezed,
    Object? userAccuracy = freezed,
    Object? isLoading = null,
    Object? hasAutoCentered = null,
    Object? userMovedMap = null,
    Object? errorMessage = freezed,
    Object? siteComplements = null,
    Object? labelCentroids = null,
  }) {
    return _then(_value.copyWith(
      features: null == features
          ? _value.features
          : features // ignore: cast_nullable_to_non_nullable
              as List<MapFeature>,
      tileLayers: null == tileLayers
          ? _value.tileLayers
          : tileLayers // ignore: cast_nullable_to_non_nullable
              as List<TileLayerConfig>,
      selectedLayer: freezed == selectedLayer
          ? _value.selectedLayer
          : selectedLayer // ignore: cast_nullable_to_non_nullable
              as TileLayerConfig?,
      userPosition: freezed == userPosition
          ? _value.userPosition
          : userPosition // ignore: cast_nullable_to_non_nullable
              as LatLng?,
      userAccuracy: freezed == userAccuracy
          ? _value.userAccuracy
          : userAccuracy // ignore: cast_nullable_to_non_nullable
              as double?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      hasAutoCentered: null == hasAutoCentered
          ? _value.hasAutoCentered
          : hasAutoCentered // ignore: cast_nullable_to_non_nullable
              as bool,
      userMovedMap: null == userMovedMap
          ? _value.userMovedMap
          : userMovedMap // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      siteComplements: null == siteComplements
          ? _value.siteComplements
          : siteComplements // ignore: cast_nullable_to_non_nullable
              as Map<int, SiteComplement?>,
      labelCentroids: null == labelCentroids
          ? _value.labelCentroids
          : labelCentroids // ignore: cast_nullable_to_non_nullable
              as Map<LatLng, MapFeature>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MapStateImplCopyWith<$Res>
    implements $MapStateCopyWith<$Res> {
  factory _$$MapStateImplCopyWith(
          _$MapStateImpl value, $Res Function(_$MapStateImpl) then) =
      __$$MapStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<MapFeature> features,
      List<TileLayerConfig> tileLayers,
      TileLayerConfig? selectedLayer,
      LatLng? userPosition,
      double? userAccuracy,
      bool isLoading,
      bool hasAutoCentered,
      bool userMovedMap,
      String? errorMessage,
      Map<int, SiteComplement?> siteComplements,
      Map<LatLng, MapFeature> labelCentroids});
}

/// @nodoc
class __$$MapStateImplCopyWithImpl<$Res>
    extends _$MapStateCopyWithImpl<$Res, _$MapStateImpl>
    implements _$$MapStateImplCopyWith<$Res> {
  __$$MapStateImplCopyWithImpl(
      _$MapStateImpl _value, $Res Function(_$MapStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? features = null,
    Object? tileLayers = null,
    Object? selectedLayer = freezed,
    Object? userPosition = freezed,
    Object? userAccuracy = freezed,
    Object? isLoading = null,
    Object? hasAutoCentered = null,
    Object? userMovedMap = null,
    Object? errorMessage = freezed,
    Object? siteComplements = null,
    Object? labelCentroids = null,
  }) {
    return _then(_$MapStateImpl(
      features: null == features
          ? _value._features
          : features // ignore: cast_nullable_to_non_nullable
              as List<MapFeature>,
      tileLayers: null == tileLayers
          ? _value._tileLayers
          : tileLayers // ignore: cast_nullable_to_non_nullable
              as List<TileLayerConfig>,
      selectedLayer: freezed == selectedLayer
          ? _value.selectedLayer
          : selectedLayer // ignore: cast_nullable_to_non_nullable
              as TileLayerConfig?,
      userPosition: freezed == userPosition
          ? _value.userPosition
          : userPosition // ignore: cast_nullable_to_non_nullable
              as LatLng?,
      userAccuracy: freezed == userAccuracy
          ? _value.userAccuracy
          : userAccuracy // ignore: cast_nullable_to_non_nullable
              as double?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      hasAutoCentered: null == hasAutoCentered
          ? _value.hasAutoCentered
          : hasAutoCentered // ignore: cast_nullable_to_non_nullable
              as bool,
      userMovedMap: null == userMovedMap
          ? _value.userMovedMap
          : userMovedMap // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      siteComplements: null == siteComplements
          ? _value._siteComplements
          : siteComplements // ignore: cast_nullable_to_non_nullable
              as Map<int, SiteComplement?>,
      labelCentroids: null == labelCentroids
          ? _value._labelCentroids
          : labelCentroids // ignore: cast_nullable_to_non_nullable
              as Map<LatLng, MapFeature>,
    ));
  }
}

/// @nodoc

class _$MapStateImpl extends _MapState {
  const _$MapStateImpl(
      {final List<MapFeature> features = const [],
      final List<TileLayerConfig> tileLayers = const [],
      this.selectedLayer,
      this.userPosition,
      this.userAccuracy,
      this.isLoading = false,
      this.hasAutoCentered = false,
      this.userMovedMap = false,
      this.errorMessage,
      final Map<int, SiteComplement?> siteComplements = const {},
      final Map<LatLng, MapFeature> labelCentroids = const {}})
      : _features = features,
        _tileLayers = tileLayers,
        _siteComplements = siteComplements,
        _labelCentroids = labelCentroids,
        super._();

  /// Liste des features à afficher sur la carte
  final List<MapFeature> _features;

  /// Liste des features à afficher sur la carte
  @override
  @JsonKey()
  List<MapFeature> get features {
    if (_features is EqualUnmodifiableListView) return _features;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_features);
  }

  /// Liste des couches de tuiles disponibles
  final List<TileLayerConfig> _tileLayers;

  /// Liste des couches de tuiles disponibles
  @override
  @JsonKey()
  List<TileLayerConfig> get tileLayers {
    if (_tileLayers is EqualUnmodifiableListView) return _tileLayers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tileLayers);
  }

  /// Couche de tuiles sélectionnée
  @override
  final TileLayerConfig? selectedLayer;

  /// Position GPS de l'utilisateur
  @override
  final LatLng? userPosition;

  /// Précision GPS en mètres
  @override
  final double? userAccuracy;

  /// Indique si les données sont en cours de chargement
  @override
  @JsonKey()
  final bool isLoading;

  /// Indique si le recentrage automatique a déjà été effectué
  @override
  @JsonKey()
  final bool hasAutoCentered;

  /// Indique si l'utilisateur a bougé la carte manuellement
  @override
  @JsonKey()
  final bool userMovedMap;

  /// Message d'erreur éventuel
  @override
  final String? errorMessage;

  /// Compléments de sites chargés (cache)
  final Map<int, SiteComplement?> _siteComplements;

  /// Compléments de sites chargés (cache)
  @override
  @JsonKey()
  Map<int, SiteComplement?> get siteComplements {
    if (_siteComplements is EqualUnmodifiableMapView) return _siteComplements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_siteComplements);
  }

  /// Centroids des labels pour les géométries (polygones/lignes)
  final Map<LatLng, MapFeature> _labelCentroids;

  /// Centroids des labels pour les géométries (polygones/lignes)
  @override
  @JsonKey()
  Map<LatLng, MapFeature> get labelCentroids {
    if (_labelCentroids is EqualUnmodifiableMapView) return _labelCentroids;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_labelCentroids);
  }

  @override
  String toString() {
    return 'MapState(features: $features, tileLayers: $tileLayers, selectedLayer: $selectedLayer, userPosition: $userPosition, userAccuracy: $userAccuracy, isLoading: $isLoading, hasAutoCentered: $hasAutoCentered, userMovedMap: $userMovedMap, errorMessage: $errorMessage, siteComplements: $siteComplements, labelCentroids: $labelCentroids)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MapStateImpl &&
            const DeepCollectionEquality().equals(other._features, _features) &&
            const DeepCollectionEquality()
                .equals(other._tileLayers, _tileLayers) &&
            (identical(other.selectedLayer, selectedLayer) ||
                other.selectedLayer == selectedLayer) &&
            (identical(other.userPosition, userPosition) ||
                other.userPosition == userPosition) &&
            (identical(other.userAccuracy, userAccuracy) ||
                other.userAccuracy == userAccuracy) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.hasAutoCentered, hasAutoCentered) ||
                other.hasAutoCentered == hasAutoCentered) &&
            (identical(other.userMovedMap, userMovedMap) ||
                other.userMovedMap == userMovedMap) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality()
                .equals(other._siteComplements, _siteComplements) &&
            const DeepCollectionEquality()
                .equals(other._labelCentroids, _labelCentroids));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_features),
      const DeepCollectionEquality().hash(_tileLayers),
      selectedLayer,
      userPosition,
      userAccuracy,
      isLoading,
      hasAutoCentered,
      userMovedMap,
      errorMessage,
      const DeepCollectionEquality().hash(_siteComplements),
      const DeepCollectionEquality().hash(_labelCentroids));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MapStateImplCopyWith<_$MapStateImpl> get copyWith =>
      __$$MapStateImplCopyWithImpl<_$MapStateImpl>(this, _$identity);
}

abstract class _MapState extends MapState {
  const factory _MapState(
      {final List<MapFeature> features,
      final List<TileLayerConfig> tileLayers,
      final TileLayerConfig? selectedLayer,
      final LatLng? userPosition,
      final double? userAccuracy,
      final bool isLoading,
      final bool hasAutoCentered,
      final bool userMovedMap,
      final String? errorMessage,
      final Map<int, SiteComplement?> siteComplements,
      final Map<LatLng, MapFeature> labelCentroids}) = _$MapStateImpl;
  const _MapState._() : super._();

  @override

  /// Liste des features à afficher sur la carte
  List<MapFeature> get features;
  @override

  /// Liste des couches de tuiles disponibles
  List<TileLayerConfig> get tileLayers;
  @override

  /// Couche de tuiles sélectionnée
  TileLayerConfig? get selectedLayer;
  @override

  /// Position GPS de l'utilisateur
  LatLng? get userPosition;
  @override

  /// Précision GPS en mètres
  double? get userAccuracy;
  @override

  /// Indique si les données sont en cours de chargement
  bool get isLoading;
  @override

  /// Indique si le recentrage automatique a déjà été effectué
  bool get hasAutoCentered;
  @override

  /// Indique si l'utilisateur a bougé la carte manuellement
  bool get userMovedMap;
  @override

  /// Message d'erreur éventuel
  String? get errorMessage;
  @override

  /// Compléments de sites chargés (cache)
  Map<int, SiteComplement?> get siteComplements;
  @override

  /// Centroids des labels pour les géométries (polygones/lignes)
  Map<LatLng, MapFeature> get labelCentroids;
  @override
  @JsonKey(ignore: true)
  _$$MapStateImplCopyWith<_$MapStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
