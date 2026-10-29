// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'module_configuration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ModuleConfiguration {

/// `false` si le module n'est pas configuré sur le serveur (observateurs,
/// JDD, liste de taxons, affichage des taxons) : le module web bloque
/// alors l'accès à ses objets (gn_module_monitoring#752). Absent (`null`)
/// avant la refonte de monitoring.
 bool? get configured; CustomConfig? get custom; DataConfig? get data; Map<String, String?>? get defaultDisplayFieldNames; Map<String, String?>? get displayFieldNames; ModuleConfig? get module; ObjectConfig? get observation; ObjectConfig? get observationDetail;// Nouvelle propriété pour les détails d'observation
 ObjectConfig? get site; ObjectConfig? get sitesGroup; dynamic get synthese; TreeConfig? get tree; ObjectConfig? get visit;
/// Create a copy of ModuleConfiguration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModuleConfigurationCopyWith<ModuleConfiguration> get copyWith => _$ModuleConfigurationCopyWithImpl<ModuleConfiguration>(this as ModuleConfiguration, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModuleConfiguration&&(identical(other.configured, configured) || other.configured == configured)&&(identical(other.custom, custom) || other.custom == custom)&&(identical(other.data, data) || other.data == data)&&const DeepCollectionEquality().equals(other.defaultDisplayFieldNames, defaultDisplayFieldNames)&&const DeepCollectionEquality().equals(other.displayFieldNames, displayFieldNames)&&(identical(other.module, module) || other.module == module)&&(identical(other.observation, observation) || other.observation == observation)&&(identical(other.observationDetail, observationDetail) || other.observationDetail == observationDetail)&&(identical(other.site, site) || other.site == site)&&(identical(other.sitesGroup, sitesGroup) || other.sitesGroup == sitesGroup)&&const DeepCollectionEquality().equals(other.synthese, synthese)&&(identical(other.tree, tree) || other.tree == tree)&&(identical(other.visit, visit) || other.visit == visit));
}


@override
int get hashCode => Object.hash(runtimeType,configured,custom,data,const DeepCollectionEquality().hash(defaultDisplayFieldNames),const DeepCollectionEquality().hash(displayFieldNames),module,observation,observationDetail,site,sitesGroup,const DeepCollectionEquality().hash(synthese),tree,visit);

@override
String toString() {
  return 'ModuleConfiguration(configured: $configured, custom: $custom, data: $data, defaultDisplayFieldNames: $defaultDisplayFieldNames, displayFieldNames: $displayFieldNames, module: $module, observation: $observation, observationDetail: $observationDetail, site: $site, sitesGroup: $sitesGroup, synthese: $synthese, tree: $tree, visit: $visit)';
}


}

/// @nodoc
abstract mixin class $ModuleConfigurationCopyWith<$Res>  {
  factory $ModuleConfigurationCopyWith(ModuleConfiguration value, $Res Function(ModuleConfiguration) _then) = _$ModuleConfigurationCopyWithImpl;
@useResult
$Res call({
 bool? configured, CustomConfig? custom, DataConfig? data, Map<String, String?>? defaultDisplayFieldNames, Map<String, String?>? displayFieldNames, ModuleConfig? module, ObjectConfig? observation, ObjectConfig? observationDetail, ObjectConfig? site, ObjectConfig? sitesGroup, dynamic synthese, TreeConfig? tree, ObjectConfig? visit
});


$CustomConfigCopyWith<$Res>? get custom;$DataConfigCopyWith<$Res>? get data;$ModuleConfigCopyWith<$Res>? get module;$ObjectConfigCopyWith<$Res>? get observation;$ObjectConfigCopyWith<$Res>? get observationDetail;$ObjectConfigCopyWith<$Res>? get site;$ObjectConfigCopyWith<$Res>? get sitesGroup;$TreeConfigCopyWith<$Res>? get tree;$ObjectConfigCopyWith<$Res>? get visit;

}
/// @nodoc
class _$ModuleConfigurationCopyWithImpl<$Res>
    implements $ModuleConfigurationCopyWith<$Res> {
  _$ModuleConfigurationCopyWithImpl(this._self, this._then);

  final ModuleConfiguration _self;
  final $Res Function(ModuleConfiguration) _then;

/// Create a copy of ModuleConfiguration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? configured = freezed,Object? custom = freezed,Object? data = freezed,Object? defaultDisplayFieldNames = freezed,Object? displayFieldNames = freezed,Object? module = freezed,Object? observation = freezed,Object? observationDetail = freezed,Object? site = freezed,Object? sitesGroup = freezed,Object? synthese = freezed,Object? tree = freezed,Object? visit = freezed,}) {
  return _then(_self.copyWith(
configured: freezed == configured ? _self.configured : configured // ignore: cast_nullable_to_non_nullable
as bool?,custom: freezed == custom ? _self.custom : custom // ignore: cast_nullable_to_non_nullable
as CustomConfig?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as DataConfig?,defaultDisplayFieldNames: freezed == defaultDisplayFieldNames ? _self.defaultDisplayFieldNames : defaultDisplayFieldNames // ignore: cast_nullable_to_non_nullable
as Map<String, String?>?,displayFieldNames: freezed == displayFieldNames ? _self.displayFieldNames : displayFieldNames // ignore: cast_nullable_to_non_nullable
as Map<String, String?>?,module: freezed == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as ModuleConfig?,observation: freezed == observation ? _self.observation : observation // ignore: cast_nullable_to_non_nullable
as ObjectConfig?,observationDetail: freezed == observationDetail ? _self.observationDetail : observationDetail // ignore: cast_nullable_to_non_nullable
as ObjectConfig?,site: freezed == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as ObjectConfig?,sitesGroup: freezed == sitesGroup ? _self.sitesGroup : sitesGroup // ignore: cast_nullable_to_non_nullable
as ObjectConfig?,synthese: freezed == synthese ? _self.synthese : synthese // ignore: cast_nullable_to_non_nullable
as dynamic,tree: freezed == tree ? _self.tree : tree // ignore: cast_nullable_to_non_nullable
as TreeConfig?,visit: freezed == visit ? _self.visit : visit // ignore: cast_nullable_to_non_nullable
as ObjectConfig?,
  ));
}
/// Create a copy of ModuleConfiguration
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomConfigCopyWith<$Res>? get custom {
    if (_self.custom == null) {
    return null;
  }

  return $CustomConfigCopyWith<$Res>(_self.custom!, (value) {
    return _then(_self.copyWith(custom: value));
  });
}/// Create a copy of ModuleConfiguration
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DataConfigCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $DataConfigCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}/// Create a copy of ModuleConfiguration
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModuleConfigCopyWith<$Res>? get module {
    if (_self.module == null) {
    return null;
  }

  return $ModuleConfigCopyWith<$Res>(_self.module!, (value) {
    return _then(_self.copyWith(module: value));
  });
}/// Create a copy of ModuleConfiguration
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ObjectConfigCopyWith<$Res>? get observation {
    if (_self.observation == null) {
    return null;
  }

  return $ObjectConfigCopyWith<$Res>(_self.observation!, (value) {
    return _then(_self.copyWith(observation: value));
  });
}/// Create a copy of ModuleConfiguration
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ObjectConfigCopyWith<$Res>? get observationDetail {
    if (_self.observationDetail == null) {
    return null;
  }

  return $ObjectConfigCopyWith<$Res>(_self.observationDetail!, (value) {
    return _then(_self.copyWith(observationDetail: value));
  });
}/// Create a copy of ModuleConfiguration
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ObjectConfigCopyWith<$Res>? get site {
    if (_self.site == null) {
    return null;
  }

  return $ObjectConfigCopyWith<$Res>(_self.site!, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of ModuleConfiguration
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ObjectConfigCopyWith<$Res>? get sitesGroup {
    if (_self.sitesGroup == null) {
    return null;
  }

  return $ObjectConfigCopyWith<$Res>(_self.sitesGroup!, (value) {
    return _then(_self.copyWith(sitesGroup: value));
  });
}/// Create a copy of ModuleConfiguration
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TreeConfigCopyWith<$Res>? get tree {
    if (_self.tree == null) {
    return null;
  }

  return $TreeConfigCopyWith<$Res>(_self.tree!, (value) {
    return _then(_self.copyWith(tree: value));
  });
}/// Create a copy of ModuleConfiguration
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ObjectConfigCopyWith<$Res>? get visit {
    if (_self.visit == null) {
    return null;
  }

  return $ObjectConfigCopyWith<$Res>(_self.visit!, (value) {
    return _then(_self.copyWith(visit: value));
  });
}
}


/// Adds pattern-matching-related methods to [ModuleConfiguration].
extension ModuleConfigurationPatterns on ModuleConfiguration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModuleConfiguration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModuleConfiguration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModuleConfiguration value)  $default,){
final _that = this;
switch (_that) {
case _ModuleConfiguration():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModuleConfiguration value)?  $default,){
final _that = this;
switch (_that) {
case _ModuleConfiguration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? configured,  CustomConfig? custom,  DataConfig? data,  Map<String, String?>? defaultDisplayFieldNames,  Map<String, String?>? displayFieldNames,  ModuleConfig? module,  ObjectConfig? observation,  ObjectConfig? observationDetail,  ObjectConfig? site,  ObjectConfig? sitesGroup,  dynamic synthese,  TreeConfig? tree,  ObjectConfig? visit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModuleConfiguration() when $default != null:
return $default(_that.configured,_that.custom,_that.data,_that.defaultDisplayFieldNames,_that.displayFieldNames,_that.module,_that.observation,_that.observationDetail,_that.site,_that.sitesGroup,_that.synthese,_that.tree,_that.visit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? configured,  CustomConfig? custom,  DataConfig? data,  Map<String, String?>? defaultDisplayFieldNames,  Map<String, String?>? displayFieldNames,  ModuleConfig? module,  ObjectConfig? observation,  ObjectConfig? observationDetail,  ObjectConfig? site,  ObjectConfig? sitesGroup,  dynamic synthese,  TreeConfig? tree,  ObjectConfig? visit)  $default,) {final _that = this;
switch (_that) {
case _ModuleConfiguration():
return $default(_that.configured,_that.custom,_that.data,_that.defaultDisplayFieldNames,_that.displayFieldNames,_that.module,_that.observation,_that.observationDetail,_that.site,_that.sitesGroup,_that.synthese,_that.tree,_that.visit);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? configured,  CustomConfig? custom,  DataConfig? data,  Map<String, String?>? defaultDisplayFieldNames,  Map<String, String?>? displayFieldNames,  ModuleConfig? module,  ObjectConfig? observation,  ObjectConfig? observationDetail,  ObjectConfig? site,  ObjectConfig? sitesGroup,  dynamic synthese,  TreeConfig? tree,  ObjectConfig? visit)?  $default,) {final _that = this;
switch (_that) {
case _ModuleConfiguration() when $default != null:
return $default(_that.configured,_that.custom,_that.data,_that.defaultDisplayFieldNames,_that.displayFieldNames,_that.module,_that.observation,_that.observationDetail,_that.site,_that.sitesGroup,_that.synthese,_that.tree,_that.visit);case _:
  return null;

}
}

}

/// @nodoc


class _ModuleConfiguration implements ModuleConfiguration {
  const _ModuleConfiguration({this.configured, this.custom, this.data, final  Map<String, String?>? defaultDisplayFieldNames, final  Map<String, String?>? displayFieldNames, this.module, this.observation, this.observationDetail, this.site, this.sitesGroup, this.synthese, this.tree, this.visit}): _defaultDisplayFieldNames = defaultDisplayFieldNames,_displayFieldNames = displayFieldNames;
  

/// `false` si le module n'est pas configuré sur le serveur (observateurs,
/// JDD, liste de taxons, affichage des taxons) : le module web bloque
/// alors l'accès à ses objets (gn_module_monitoring#752). Absent (`null`)
/// avant la refonte de monitoring.
@override final  bool? configured;
@override final  CustomConfig? custom;
@override final  DataConfig? data;
 final  Map<String, String?>? _defaultDisplayFieldNames;
@override Map<String, String?>? get defaultDisplayFieldNames {
  final value = _defaultDisplayFieldNames;
  if (value == null) return null;
  if (_defaultDisplayFieldNames is EqualUnmodifiableMapView) return _defaultDisplayFieldNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, String?>? _displayFieldNames;
@override Map<String, String?>? get displayFieldNames {
  final value = _displayFieldNames;
  if (value == null) return null;
  if (_displayFieldNames is EqualUnmodifiableMapView) return _displayFieldNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  ModuleConfig? module;
@override final  ObjectConfig? observation;
@override final  ObjectConfig? observationDetail;
// Nouvelle propriété pour les détails d'observation
@override final  ObjectConfig? site;
@override final  ObjectConfig? sitesGroup;
@override final  dynamic synthese;
@override final  TreeConfig? tree;
@override final  ObjectConfig? visit;

/// Create a copy of ModuleConfiguration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModuleConfigurationCopyWith<_ModuleConfiguration> get copyWith => __$ModuleConfigurationCopyWithImpl<_ModuleConfiguration>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModuleConfiguration&&(identical(other.configured, configured) || other.configured == configured)&&(identical(other.custom, custom) || other.custom == custom)&&(identical(other.data, data) || other.data == data)&&const DeepCollectionEquality().equals(other._defaultDisplayFieldNames, _defaultDisplayFieldNames)&&const DeepCollectionEquality().equals(other._displayFieldNames, _displayFieldNames)&&(identical(other.module, module) || other.module == module)&&(identical(other.observation, observation) || other.observation == observation)&&(identical(other.observationDetail, observationDetail) || other.observationDetail == observationDetail)&&(identical(other.site, site) || other.site == site)&&(identical(other.sitesGroup, sitesGroup) || other.sitesGroup == sitesGroup)&&const DeepCollectionEquality().equals(other.synthese, synthese)&&(identical(other.tree, tree) || other.tree == tree)&&(identical(other.visit, visit) || other.visit == visit));
}


@override
int get hashCode => Object.hash(runtimeType,configured,custom,data,const DeepCollectionEquality().hash(_defaultDisplayFieldNames),const DeepCollectionEquality().hash(_displayFieldNames),module,observation,observationDetail,site,sitesGroup,const DeepCollectionEquality().hash(synthese),tree,visit);

@override
String toString() {
  return 'ModuleConfiguration(configured: $configured, custom: $custom, data: $data, defaultDisplayFieldNames: $defaultDisplayFieldNames, displayFieldNames: $displayFieldNames, module: $module, observation: $observation, observationDetail: $observationDetail, site: $site, sitesGroup: $sitesGroup, synthese: $synthese, tree: $tree, visit: $visit)';
}


}

/// @nodoc
abstract mixin class _$ModuleConfigurationCopyWith<$Res> implements $ModuleConfigurationCopyWith<$Res> {
  factory _$ModuleConfigurationCopyWith(_ModuleConfiguration value, $Res Function(_ModuleConfiguration) _then) = __$ModuleConfigurationCopyWithImpl;
@override @useResult
$Res call({
 bool? configured, CustomConfig? custom, DataConfig? data, Map<String, String?>? defaultDisplayFieldNames, Map<String, String?>? displayFieldNames, ModuleConfig? module, ObjectConfig? observation, ObjectConfig? observationDetail, ObjectConfig? site, ObjectConfig? sitesGroup, dynamic synthese, TreeConfig? tree, ObjectConfig? visit
});


@override $CustomConfigCopyWith<$Res>? get custom;@override $DataConfigCopyWith<$Res>? get data;@override $ModuleConfigCopyWith<$Res>? get module;@override $ObjectConfigCopyWith<$Res>? get observation;@override $ObjectConfigCopyWith<$Res>? get observationDetail;@override $ObjectConfigCopyWith<$Res>? get site;@override $ObjectConfigCopyWith<$Res>? get sitesGroup;@override $TreeConfigCopyWith<$Res>? get tree;@override $ObjectConfigCopyWith<$Res>? get visit;

}
/// @nodoc
class __$ModuleConfigurationCopyWithImpl<$Res>
    implements _$ModuleConfigurationCopyWith<$Res> {
  __$ModuleConfigurationCopyWithImpl(this._self, this._then);

  final _ModuleConfiguration _self;
  final $Res Function(_ModuleConfiguration) _then;

/// Create a copy of ModuleConfiguration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? configured = freezed,Object? custom = freezed,Object? data = freezed,Object? defaultDisplayFieldNames = freezed,Object? displayFieldNames = freezed,Object? module = freezed,Object? observation = freezed,Object? observationDetail = freezed,Object? site = freezed,Object? sitesGroup = freezed,Object? synthese = freezed,Object? tree = freezed,Object? visit = freezed,}) {
  return _then(_ModuleConfiguration(
configured: freezed == configured ? _self.configured : configured // ignore: cast_nullable_to_non_nullable
as bool?,custom: freezed == custom ? _self.custom : custom // ignore: cast_nullable_to_non_nullable
as CustomConfig?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as DataConfig?,defaultDisplayFieldNames: freezed == defaultDisplayFieldNames ? _self._defaultDisplayFieldNames : defaultDisplayFieldNames // ignore: cast_nullable_to_non_nullable
as Map<String, String?>?,displayFieldNames: freezed == displayFieldNames ? _self._displayFieldNames : displayFieldNames // ignore: cast_nullable_to_non_nullable
as Map<String, String?>?,module: freezed == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as ModuleConfig?,observation: freezed == observation ? _self.observation : observation // ignore: cast_nullable_to_non_nullable
as ObjectConfig?,observationDetail: freezed == observationDetail ? _self.observationDetail : observationDetail // ignore: cast_nullable_to_non_nullable
as ObjectConfig?,site: freezed == site ? _self.site : site // ignore: cast_nullable_to_non_nullable
as ObjectConfig?,sitesGroup: freezed == sitesGroup ? _self.sitesGroup : sitesGroup // ignore: cast_nullable_to_non_nullable
as ObjectConfig?,synthese: freezed == synthese ? _self.synthese : synthese // ignore: cast_nullable_to_non_nullable
as dynamic,tree: freezed == tree ? _self.tree : tree // ignore: cast_nullable_to_non_nullable
as TreeConfig?,visit: freezed == visit ? _self.visit : visit // ignore: cast_nullable_to_non_nullable
as ObjectConfig?,
  ));
}

/// Create a copy of ModuleConfiguration
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomConfigCopyWith<$Res>? get custom {
    if (_self.custom == null) {
    return null;
  }

  return $CustomConfigCopyWith<$Res>(_self.custom!, (value) {
    return _then(_self.copyWith(custom: value));
  });
}/// Create a copy of ModuleConfiguration
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DataConfigCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $DataConfigCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}/// Create a copy of ModuleConfiguration
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModuleConfigCopyWith<$Res>? get module {
    if (_self.module == null) {
    return null;
  }

  return $ModuleConfigCopyWith<$Res>(_self.module!, (value) {
    return _then(_self.copyWith(module: value));
  });
}/// Create a copy of ModuleConfiguration
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ObjectConfigCopyWith<$Res>? get observation {
    if (_self.observation == null) {
    return null;
  }

  return $ObjectConfigCopyWith<$Res>(_self.observation!, (value) {
    return _then(_self.copyWith(observation: value));
  });
}/// Create a copy of ModuleConfiguration
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ObjectConfigCopyWith<$Res>? get observationDetail {
    if (_self.observationDetail == null) {
    return null;
  }

  return $ObjectConfigCopyWith<$Res>(_self.observationDetail!, (value) {
    return _then(_self.copyWith(observationDetail: value));
  });
}/// Create a copy of ModuleConfiguration
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ObjectConfigCopyWith<$Res>? get site {
    if (_self.site == null) {
    return null;
  }

  return $ObjectConfigCopyWith<$Res>(_self.site!, (value) {
    return _then(_self.copyWith(site: value));
  });
}/// Create a copy of ModuleConfiguration
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ObjectConfigCopyWith<$Res>? get sitesGroup {
    if (_self.sitesGroup == null) {
    return null;
  }

  return $ObjectConfigCopyWith<$Res>(_self.sitesGroup!, (value) {
    return _then(_self.copyWith(sitesGroup: value));
  });
}/// Create a copy of ModuleConfiguration
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TreeConfigCopyWith<$Res>? get tree {
    if (_self.tree == null) {
    return null;
  }

  return $TreeConfigCopyWith<$Res>(_self.tree!, (value) {
    return _then(_self.copyWith(tree: value));
  });
}/// Create a copy of ModuleConfiguration
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ObjectConfigCopyWith<$Res>? get visit {
    if (_self.visit == null) {
    return null;
  }

  return $ObjectConfigCopyWith<$Res>(_self.visit!, (value) {
    return _then(_self.copyWith(visit: value));
  });
}
}

/// @nodoc
mixin _$CustomConfig {

@JsonKey(name: '__MODULE.B_DRAW_SITES_GROUP') bool? get drawSitesGroup;@JsonKey(name: '__MODULE.B_SYNTHESE') bool? get synthese;@JsonKey(name: '__MODULE.IDS_TYPE_SITE') List<TypeSite>? get typeSites;@JsonKey(name: '__MODULE.ID_LIST_OBSERVER') int? get idListObserver;@JsonKey(name: '__MODULE.ID_LIST_TAXONOMY') int? get idListTaxonomy;@JsonKey(name: '__MODULE.ID_MODULE') int? get idModule;@JsonKey(name: '__MODULE.MODULE_CODE') String? get moduleCode;@JsonKey(name: '__MODULE.TAXONOMY_DISPLAY_FIELD_NAME') String? get taxonomyDisplayFieldName;@JsonKey(name: '__MODULE.TYPES_SITE') List<TypeSite>? get typesSite;@JsonKey(name: '__MONITORINGS_PATH') String? get monitoringsPath;
/// Create a copy of CustomConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomConfigCopyWith<CustomConfig> get copyWith => _$CustomConfigCopyWithImpl<CustomConfig>(this as CustomConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomConfig&&(identical(other.drawSitesGroup, drawSitesGroup) || other.drawSitesGroup == drawSitesGroup)&&(identical(other.synthese, synthese) || other.synthese == synthese)&&const DeepCollectionEquality().equals(other.typeSites, typeSites)&&(identical(other.idListObserver, idListObserver) || other.idListObserver == idListObserver)&&(identical(other.idListTaxonomy, idListTaxonomy) || other.idListTaxonomy == idListTaxonomy)&&(identical(other.idModule, idModule) || other.idModule == idModule)&&(identical(other.moduleCode, moduleCode) || other.moduleCode == moduleCode)&&(identical(other.taxonomyDisplayFieldName, taxonomyDisplayFieldName) || other.taxonomyDisplayFieldName == taxonomyDisplayFieldName)&&const DeepCollectionEquality().equals(other.typesSite, typesSite)&&(identical(other.monitoringsPath, monitoringsPath) || other.monitoringsPath == monitoringsPath));
}


@override
int get hashCode => Object.hash(runtimeType,drawSitesGroup,synthese,const DeepCollectionEquality().hash(typeSites),idListObserver,idListTaxonomy,idModule,moduleCode,taxonomyDisplayFieldName,const DeepCollectionEquality().hash(typesSite),monitoringsPath);

@override
String toString() {
  return 'CustomConfig(drawSitesGroup: $drawSitesGroup, synthese: $synthese, typeSites: $typeSites, idListObserver: $idListObserver, idListTaxonomy: $idListTaxonomy, idModule: $idModule, moduleCode: $moduleCode, taxonomyDisplayFieldName: $taxonomyDisplayFieldName, typesSite: $typesSite, monitoringsPath: $monitoringsPath)';
}


}

/// @nodoc
abstract mixin class $CustomConfigCopyWith<$Res>  {
  factory $CustomConfigCopyWith(CustomConfig value, $Res Function(CustomConfig) _then) = _$CustomConfigCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '__MODULE.B_DRAW_SITES_GROUP') bool? drawSitesGroup,@JsonKey(name: '__MODULE.B_SYNTHESE') bool? synthese,@JsonKey(name: '__MODULE.IDS_TYPE_SITE') List<TypeSite>? typeSites,@JsonKey(name: '__MODULE.ID_LIST_OBSERVER') int? idListObserver,@JsonKey(name: '__MODULE.ID_LIST_TAXONOMY') int? idListTaxonomy,@JsonKey(name: '__MODULE.ID_MODULE') int? idModule,@JsonKey(name: '__MODULE.MODULE_CODE') String? moduleCode,@JsonKey(name: '__MODULE.TAXONOMY_DISPLAY_FIELD_NAME') String? taxonomyDisplayFieldName,@JsonKey(name: '__MODULE.TYPES_SITE') List<TypeSite>? typesSite,@JsonKey(name: '__MONITORINGS_PATH') String? monitoringsPath
});




}
/// @nodoc
class _$CustomConfigCopyWithImpl<$Res>
    implements $CustomConfigCopyWith<$Res> {
  _$CustomConfigCopyWithImpl(this._self, this._then);

  final CustomConfig _self;
  final $Res Function(CustomConfig) _then;

/// Create a copy of CustomConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? drawSitesGroup = freezed,Object? synthese = freezed,Object? typeSites = freezed,Object? idListObserver = freezed,Object? idListTaxonomy = freezed,Object? idModule = freezed,Object? moduleCode = freezed,Object? taxonomyDisplayFieldName = freezed,Object? typesSite = freezed,Object? monitoringsPath = freezed,}) {
  return _then(_self.copyWith(
drawSitesGroup: freezed == drawSitesGroup ? _self.drawSitesGroup : drawSitesGroup // ignore: cast_nullable_to_non_nullable
as bool?,synthese: freezed == synthese ? _self.synthese : synthese // ignore: cast_nullable_to_non_nullable
as bool?,typeSites: freezed == typeSites ? _self.typeSites : typeSites // ignore: cast_nullable_to_non_nullable
as List<TypeSite>?,idListObserver: freezed == idListObserver ? _self.idListObserver : idListObserver // ignore: cast_nullable_to_non_nullable
as int?,idListTaxonomy: freezed == idListTaxonomy ? _self.idListTaxonomy : idListTaxonomy // ignore: cast_nullable_to_non_nullable
as int?,idModule: freezed == idModule ? _self.idModule : idModule // ignore: cast_nullable_to_non_nullable
as int?,moduleCode: freezed == moduleCode ? _self.moduleCode : moduleCode // ignore: cast_nullable_to_non_nullable
as String?,taxonomyDisplayFieldName: freezed == taxonomyDisplayFieldName ? _self.taxonomyDisplayFieldName : taxonomyDisplayFieldName // ignore: cast_nullable_to_non_nullable
as String?,typesSite: freezed == typesSite ? _self.typesSite : typesSite // ignore: cast_nullable_to_non_nullable
as List<TypeSite>?,monitoringsPath: freezed == monitoringsPath ? _self.monitoringsPath : monitoringsPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomConfig].
extension CustomConfigPatterns on CustomConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomConfig value)  $default,){
final _that = this;
switch (_that) {
case _CustomConfig():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomConfig value)?  $default,){
final _that = this;
switch (_that) {
case _CustomConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '__MODULE.B_DRAW_SITES_GROUP')  bool? drawSitesGroup, @JsonKey(name: '__MODULE.B_SYNTHESE')  bool? synthese, @JsonKey(name: '__MODULE.IDS_TYPE_SITE')  List<TypeSite>? typeSites, @JsonKey(name: '__MODULE.ID_LIST_OBSERVER')  int? idListObserver, @JsonKey(name: '__MODULE.ID_LIST_TAXONOMY')  int? idListTaxonomy, @JsonKey(name: '__MODULE.ID_MODULE')  int? idModule, @JsonKey(name: '__MODULE.MODULE_CODE')  String? moduleCode, @JsonKey(name: '__MODULE.TAXONOMY_DISPLAY_FIELD_NAME')  String? taxonomyDisplayFieldName, @JsonKey(name: '__MODULE.TYPES_SITE')  List<TypeSite>? typesSite, @JsonKey(name: '__MONITORINGS_PATH')  String? monitoringsPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomConfig() when $default != null:
return $default(_that.drawSitesGroup,_that.synthese,_that.typeSites,_that.idListObserver,_that.idListTaxonomy,_that.idModule,_that.moduleCode,_that.taxonomyDisplayFieldName,_that.typesSite,_that.monitoringsPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '__MODULE.B_DRAW_SITES_GROUP')  bool? drawSitesGroup, @JsonKey(name: '__MODULE.B_SYNTHESE')  bool? synthese, @JsonKey(name: '__MODULE.IDS_TYPE_SITE')  List<TypeSite>? typeSites, @JsonKey(name: '__MODULE.ID_LIST_OBSERVER')  int? idListObserver, @JsonKey(name: '__MODULE.ID_LIST_TAXONOMY')  int? idListTaxonomy, @JsonKey(name: '__MODULE.ID_MODULE')  int? idModule, @JsonKey(name: '__MODULE.MODULE_CODE')  String? moduleCode, @JsonKey(name: '__MODULE.TAXONOMY_DISPLAY_FIELD_NAME')  String? taxonomyDisplayFieldName, @JsonKey(name: '__MODULE.TYPES_SITE')  List<TypeSite>? typesSite, @JsonKey(name: '__MONITORINGS_PATH')  String? monitoringsPath)  $default,) {final _that = this;
switch (_that) {
case _CustomConfig():
return $default(_that.drawSitesGroup,_that.synthese,_that.typeSites,_that.idListObserver,_that.idListTaxonomy,_that.idModule,_that.moduleCode,_that.taxonomyDisplayFieldName,_that.typesSite,_that.monitoringsPath);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '__MODULE.B_DRAW_SITES_GROUP')  bool? drawSitesGroup, @JsonKey(name: '__MODULE.B_SYNTHESE')  bool? synthese, @JsonKey(name: '__MODULE.IDS_TYPE_SITE')  List<TypeSite>? typeSites, @JsonKey(name: '__MODULE.ID_LIST_OBSERVER')  int? idListObserver, @JsonKey(name: '__MODULE.ID_LIST_TAXONOMY')  int? idListTaxonomy, @JsonKey(name: '__MODULE.ID_MODULE')  int? idModule, @JsonKey(name: '__MODULE.MODULE_CODE')  String? moduleCode, @JsonKey(name: '__MODULE.TAXONOMY_DISPLAY_FIELD_NAME')  String? taxonomyDisplayFieldName, @JsonKey(name: '__MODULE.TYPES_SITE')  List<TypeSite>? typesSite, @JsonKey(name: '__MONITORINGS_PATH')  String? monitoringsPath)?  $default,) {final _that = this;
switch (_that) {
case _CustomConfig() when $default != null:
return $default(_that.drawSitesGroup,_that.synthese,_that.typeSites,_that.idListObserver,_that.idListTaxonomy,_that.idModule,_that.moduleCode,_that.taxonomyDisplayFieldName,_that.typesSite,_that.monitoringsPath);case _:
  return null;

}
}

}

/// @nodoc


class _CustomConfig implements CustomConfig {
  const _CustomConfig({@JsonKey(name: '__MODULE.B_DRAW_SITES_GROUP') this.drawSitesGroup, @JsonKey(name: '__MODULE.B_SYNTHESE') this.synthese, @JsonKey(name: '__MODULE.IDS_TYPE_SITE') final  List<TypeSite>? typeSites, @JsonKey(name: '__MODULE.ID_LIST_OBSERVER') this.idListObserver, @JsonKey(name: '__MODULE.ID_LIST_TAXONOMY') this.idListTaxonomy, @JsonKey(name: '__MODULE.ID_MODULE') this.idModule, @JsonKey(name: '__MODULE.MODULE_CODE') this.moduleCode, @JsonKey(name: '__MODULE.TAXONOMY_DISPLAY_FIELD_NAME') this.taxonomyDisplayFieldName, @JsonKey(name: '__MODULE.TYPES_SITE') final  List<TypeSite>? typesSite, @JsonKey(name: '__MONITORINGS_PATH') this.monitoringsPath}): _typeSites = typeSites,_typesSite = typesSite;
  

@override@JsonKey(name: '__MODULE.B_DRAW_SITES_GROUP') final  bool? drawSitesGroup;
@override@JsonKey(name: '__MODULE.B_SYNTHESE') final  bool? synthese;
 final  List<TypeSite>? _typeSites;
@override@JsonKey(name: '__MODULE.IDS_TYPE_SITE') List<TypeSite>? get typeSites {
  final value = _typeSites;
  if (value == null) return null;
  if (_typeSites is EqualUnmodifiableListView) return _typeSites;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: '__MODULE.ID_LIST_OBSERVER') final  int? idListObserver;
@override@JsonKey(name: '__MODULE.ID_LIST_TAXONOMY') final  int? idListTaxonomy;
@override@JsonKey(name: '__MODULE.ID_MODULE') final  int? idModule;
@override@JsonKey(name: '__MODULE.MODULE_CODE') final  String? moduleCode;
@override@JsonKey(name: '__MODULE.TAXONOMY_DISPLAY_FIELD_NAME') final  String? taxonomyDisplayFieldName;
 final  List<TypeSite>? _typesSite;
@override@JsonKey(name: '__MODULE.TYPES_SITE') List<TypeSite>? get typesSite {
  final value = _typesSite;
  if (value == null) return null;
  if (_typesSite is EqualUnmodifiableListView) return _typesSite;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: '__MONITORINGS_PATH') final  String? monitoringsPath;

/// Create a copy of CustomConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomConfigCopyWith<_CustomConfig> get copyWith => __$CustomConfigCopyWithImpl<_CustomConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomConfig&&(identical(other.drawSitesGroup, drawSitesGroup) || other.drawSitesGroup == drawSitesGroup)&&(identical(other.synthese, synthese) || other.synthese == synthese)&&const DeepCollectionEquality().equals(other._typeSites, _typeSites)&&(identical(other.idListObserver, idListObserver) || other.idListObserver == idListObserver)&&(identical(other.idListTaxonomy, idListTaxonomy) || other.idListTaxonomy == idListTaxonomy)&&(identical(other.idModule, idModule) || other.idModule == idModule)&&(identical(other.moduleCode, moduleCode) || other.moduleCode == moduleCode)&&(identical(other.taxonomyDisplayFieldName, taxonomyDisplayFieldName) || other.taxonomyDisplayFieldName == taxonomyDisplayFieldName)&&const DeepCollectionEquality().equals(other._typesSite, _typesSite)&&(identical(other.monitoringsPath, monitoringsPath) || other.monitoringsPath == monitoringsPath));
}


@override
int get hashCode => Object.hash(runtimeType,drawSitesGroup,synthese,const DeepCollectionEquality().hash(_typeSites),idListObserver,idListTaxonomy,idModule,moduleCode,taxonomyDisplayFieldName,const DeepCollectionEquality().hash(_typesSite),monitoringsPath);

@override
String toString() {
  return 'CustomConfig(drawSitesGroup: $drawSitesGroup, synthese: $synthese, typeSites: $typeSites, idListObserver: $idListObserver, idListTaxonomy: $idListTaxonomy, idModule: $idModule, moduleCode: $moduleCode, taxonomyDisplayFieldName: $taxonomyDisplayFieldName, typesSite: $typesSite, monitoringsPath: $monitoringsPath)';
}


}

/// @nodoc
abstract mixin class _$CustomConfigCopyWith<$Res> implements $CustomConfigCopyWith<$Res> {
  factory _$CustomConfigCopyWith(_CustomConfig value, $Res Function(_CustomConfig) _then) = __$CustomConfigCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '__MODULE.B_DRAW_SITES_GROUP') bool? drawSitesGroup,@JsonKey(name: '__MODULE.B_SYNTHESE') bool? synthese,@JsonKey(name: '__MODULE.IDS_TYPE_SITE') List<TypeSite>? typeSites,@JsonKey(name: '__MODULE.ID_LIST_OBSERVER') int? idListObserver,@JsonKey(name: '__MODULE.ID_LIST_TAXONOMY') int? idListTaxonomy,@JsonKey(name: '__MODULE.ID_MODULE') int? idModule,@JsonKey(name: '__MODULE.MODULE_CODE') String? moduleCode,@JsonKey(name: '__MODULE.TAXONOMY_DISPLAY_FIELD_NAME') String? taxonomyDisplayFieldName,@JsonKey(name: '__MODULE.TYPES_SITE') List<TypeSite>? typesSite,@JsonKey(name: '__MONITORINGS_PATH') String? monitoringsPath
});




}
/// @nodoc
class __$CustomConfigCopyWithImpl<$Res>
    implements _$CustomConfigCopyWith<$Res> {
  __$CustomConfigCopyWithImpl(this._self, this._then);

  final _CustomConfig _self;
  final $Res Function(_CustomConfig) _then;

/// Create a copy of CustomConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? drawSitesGroup = freezed,Object? synthese = freezed,Object? typeSites = freezed,Object? idListObserver = freezed,Object? idListTaxonomy = freezed,Object? idModule = freezed,Object? moduleCode = freezed,Object? taxonomyDisplayFieldName = freezed,Object? typesSite = freezed,Object? monitoringsPath = freezed,}) {
  return _then(_CustomConfig(
drawSitesGroup: freezed == drawSitesGroup ? _self.drawSitesGroup : drawSitesGroup // ignore: cast_nullable_to_non_nullable
as bool?,synthese: freezed == synthese ? _self.synthese : synthese // ignore: cast_nullable_to_non_nullable
as bool?,typeSites: freezed == typeSites ? _self._typeSites : typeSites // ignore: cast_nullable_to_non_nullable
as List<TypeSite>?,idListObserver: freezed == idListObserver ? _self.idListObserver : idListObserver // ignore: cast_nullable_to_non_nullable
as int?,idListTaxonomy: freezed == idListTaxonomy ? _self.idListTaxonomy : idListTaxonomy // ignore: cast_nullable_to_non_nullable
as int?,idModule: freezed == idModule ? _self.idModule : idModule // ignore: cast_nullable_to_non_nullable
as int?,moduleCode: freezed == moduleCode ? _self.moduleCode : moduleCode // ignore: cast_nullable_to_non_nullable
as String?,taxonomyDisplayFieldName: freezed == taxonomyDisplayFieldName ? _self.taxonomyDisplayFieldName : taxonomyDisplayFieldName // ignore: cast_nullable_to_non_nullable
as String?,typesSite: freezed == typesSite ? _self._typesSite : typesSite // ignore: cast_nullable_to_non_nullable
as List<TypeSite>?,monitoringsPath: freezed == monitoringsPath ? _self.monitoringsPath : monitoringsPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$TypeSite {

 int? get idNomenclatureTypeSite; dynamic get config;
/// Create a copy of TypeSite
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TypeSiteCopyWith<TypeSite> get copyWith => _$TypeSiteCopyWithImpl<TypeSite>(this as TypeSite, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TypeSite&&(identical(other.idNomenclatureTypeSite, idNomenclatureTypeSite) || other.idNomenclatureTypeSite == idNomenclatureTypeSite)&&const DeepCollectionEquality().equals(other.config, config));
}


@override
int get hashCode => Object.hash(runtimeType,idNomenclatureTypeSite,const DeepCollectionEquality().hash(config));

@override
String toString() {
  return 'TypeSite(idNomenclatureTypeSite: $idNomenclatureTypeSite, config: $config)';
}


}

/// @nodoc
abstract mixin class $TypeSiteCopyWith<$Res>  {
  factory $TypeSiteCopyWith(TypeSite value, $Res Function(TypeSite) _then) = _$TypeSiteCopyWithImpl;
@useResult
$Res call({
 int? idNomenclatureTypeSite, dynamic config
});




}
/// @nodoc
class _$TypeSiteCopyWithImpl<$Res>
    implements $TypeSiteCopyWith<$Res> {
  _$TypeSiteCopyWithImpl(this._self, this._then);

  final TypeSite _self;
  final $Res Function(TypeSite) _then;

/// Create a copy of TypeSite
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idNomenclatureTypeSite = freezed,Object? config = freezed,}) {
  return _then(_self.copyWith(
idNomenclatureTypeSite: freezed == idNomenclatureTypeSite ? _self.idNomenclatureTypeSite : idNomenclatureTypeSite // ignore: cast_nullable_to_non_nullable
as int?,config: freezed == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}

}


/// Adds pattern-matching-related methods to [TypeSite].
extension TypeSitePatterns on TypeSite {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TypeSite value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TypeSite() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TypeSite value)  $default,){
final _that = this;
switch (_that) {
case _TypeSite():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TypeSite value)?  $default,){
final _that = this;
switch (_that) {
case _TypeSite() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? idNomenclatureTypeSite,  dynamic config)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TypeSite() when $default != null:
return $default(_that.idNomenclatureTypeSite,_that.config);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? idNomenclatureTypeSite,  dynamic config)  $default,) {final _that = this;
switch (_that) {
case _TypeSite():
return $default(_that.idNomenclatureTypeSite,_that.config);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? idNomenclatureTypeSite,  dynamic config)?  $default,) {final _that = this;
switch (_that) {
case _TypeSite() when $default != null:
return $default(_that.idNomenclatureTypeSite,_that.config);case _:
  return null;

}
}

}

/// @nodoc


class _TypeSite implements TypeSite {
  const _TypeSite({this.idNomenclatureTypeSite, this.config});
  

@override final  int? idNomenclatureTypeSite;
@override final  dynamic config;

/// Create a copy of TypeSite
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TypeSiteCopyWith<_TypeSite> get copyWith => __$TypeSiteCopyWithImpl<_TypeSite>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TypeSite&&(identical(other.idNomenclatureTypeSite, idNomenclatureTypeSite) || other.idNomenclatureTypeSite == idNomenclatureTypeSite)&&const DeepCollectionEquality().equals(other.config, config));
}


@override
int get hashCode => Object.hash(runtimeType,idNomenclatureTypeSite,const DeepCollectionEquality().hash(config));

@override
String toString() {
  return 'TypeSite(idNomenclatureTypeSite: $idNomenclatureTypeSite, config: $config)';
}


}

/// @nodoc
abstract mixin class _$TypeSiteCopyWith<$Res> implements $TypeSiteCopyWith<$Res> {
  factory _$TypeSiteCopyWith(_TypeSite value, $Res Function(_TypeSite) _then) = __$TypeSiteCopyWithImpl;
@override @useResult
$Res call({
 int? idNomenclatureTypeSite, dynamic config
});




}
/// @nodoc
class __$TypeSiteCopyWithImpl<$Res>
    implements _$TypeSiteCopyWith<$Res> {
  __$TypeSiteCopyWithImpl(this._self, this._then);

  final _TypeSite _self;
  final $Res Function(_TypeSite) _then;

/// Create a copy of TypeSite
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idNomenclatureTypeSite = freezed,Object? config = freezed,}) {
  return _then(_TypeSite(
idNomenclatureTypeSite: freezed == idNomenclatureTypeSite ? _self.idNomenclatureTypeSite : idNomenclatureTypeSite // ignore: cast_nullable_to_non_nullable
as int?,config: freezed == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}

/// @nodoc
mixin _$DataConfig {

 List<String>? get nomenclature; int? get user;
/// Create a copy of DataConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DataConfigCopyWith<DataConfig> get copyWith => _$DataConfigCopyWithImpl<DataConfig>(this as DataConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DataConfig&&const DeepCollectionEquality().equals(other.nomenclature, nomenclature)&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(nomenclature),user);

@override
String toString() {
  return 'DataConfig(nomenclature: $nomenclature, user: $user)';
}


}

/// @nodoc
abstract mixin class $DataConfigCopyWith<$Res>  {
  factory $DataConfigCopyWith(DataConfig value, $Res Function(DataConfig) _then) = _$DataConfigCopyWithImpl;
@useResult
$Res call({
 List<String>? nomenclature, int? user
});




}
/// @nodoc
class _$DataConfigCopyWithImpl<$Res>
    implements $DataConfigCopyWith<$Res> {
  _$DataConfigCopyWithImpl(this._self, this._then);

  final DataConfig _self;
  final $Res Function(DataConfig) _then;

/// Create a copy of DataConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nomenclature = freezed,Object? user = freezed,}) {
  return _then(_self.copyWith(
nomenclature: freezed == nomenclature ? _self.nomenclature : nomenclature // ignore: cast_nullable_to_non_nullable
as List<String>?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DataConfig].
extension DataConfigPatterns on DataConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DataConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DataConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DataConfig value)  $default,){
final _that = this;
switch (_that) {
case _DataConfig():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DataConfig value)?  $default,){
final _that = this;
switch (_that) {
case _DataConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String>? nomenclature,  int? user)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DataConfig() when $default != null:
return $default(_that.nomenclature,_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String>? nomenclature,  int? user)  $default,) {final _that = this;
switch (_that) {
case _DataConfig():
return $default(_that.nomenclature,_that.user);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String>? nomenclature,  int? user)?  $default,) {final _that = this;
switch (_that) {
case _DataConfig() when $default != null:
return $default(_that.nomenclature,_that.user);case _:
  return null;

}
}

}

/// @nodoc


class _DataConfig implements DataConfig {
  const _DataConfig({final  List<String>? nomenclature, this.user}): _nomenclature = nomenclature;
  

 final  List<String>? _nomenclature;
@override List<String>? get nomenclature {
  final value = _nomenclature;
  if (value == null) return null;
  if (_nomenclature is EqualUnmodifiableListView) return _nomenclature;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? user;

/// Create a copy of DataConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DataConfigCopyWith<_DataConfig> get copyWith => __$DataConfigCopyWithImpl<_DataConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DataConfig&&const DeepCollectionEquality().equals(other._nomenclature, _nomenclature)&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_nomenclature),user);

@override
String toString() {
  return 'DataConfig(nomenclature: $nomenclature, user: $user)';
}


}

/// @nodoc
abstract mixin class _$DataConfigCopyWith<$Res> implements $DataConfigCopyWith<$Res> {
  factory _$DataConfigCopyWith(_DataConfig value, $Res Function(_DataConfig) _then) = __$DataConfigCopyWithImpl;
@override @useResult
$Res call({
 List<String>? nomenclature, int? user
});




}
/// @nodoc
class __$DataConfigCopyWithImpl<$Res>
    implements _$DataConfigCopyWith<$Res> {
  __$DataConfigCopyWithImpl(this._self, this._then);

  final _DataConfig _self;
  final $Res Function(_DataConfig) _then;

/// Create a copy of DataConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nomenclature = freezed,Object? user = freezed,}) {
  return _then(_DataConfig(
nomenclature: freezed == nomenclature ? _self._nomenclature : nomenclature // ignore: cast_nullable_to_non_nullable
as List<String>?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$ModuleConfig {

@JsonKey(name: 'b_draw_sites_group') bool? get drawSitesGroup;@JsonKey(name: 'b_synthese') bool? get synthese; List<String>? get childrenTypes; String? get color; CruvedConfig? get cruved; String? get descriptionFieldName; List<String>? get displayForm; List<String>? get displayList; List<String>? get displayProperties; List<ExportConfig>? get exportCsv; List<ExportConfig>? get exportPdf; Map<String, dynamic>? get filters; Map<String, GenericFieldConfig>? get generic; String? get genre; String? get idFieldName; int? get idListObserver; int? get idListTaxonomy; int? get idModule; int? get idTableLocation; String? get label; String? get moduleCode; String? get moduleDesc; String? get moduleLabel; List<String>? get parentTypes; List<String>? get propertiesKeys; bool? get rootObject; Map<String, dynamic>? get specific; String? get taxonomyDisplayFieldName; Map<String, TypeSiteConfig>? get typesSite; String? get uuidFieldName;
/// Create a copy of ModuleConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModuleConfigCopyWith<ModuleConfig> get copyWith => _$ModuleConfigCopyWithImpl<ModuleConfig>(this as ModuleConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModuleConfig&&(identical(other.drawSitesGroup, drawSitesGroup) || other.drawSitesGroup == drawSitesGroup)&&(identical(other.synthese, synthese) || other.synthese == synthese)&&const DeepCollectionEquality().equals(other.childrenTypes, childrenTypes)&&(identical(other.color, color) || other.color == color)&&(identical(other.cruved, cruved) || other.cruved == cruved)&&(identical(other.descriptionFieldName, descriptionFieldName) || other.descriptionFieldName == descriptionFieldName)&&const DeepCollectionEquality().equals(other.displayForm, displayForm)&&const DeepCollectionEquality().equals(other.displayList, displayList)&&const DeepCollectionEquality().equals(other.displayProperties, displayProperties)&&const DeepCollectionEquality().equals(other.exportCsv, exportCsv)&&const DeepCollectionEquality().equals(other.exportPdf, exportPdf)&&const DeepCollectionEquality().equals(other.filters, filters)&&const DeepCollectionEquality().equals(other.generic, generic)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.idFieldName, idFieldName) || other.idFieldName == idFieldName)&&(identical(other.idListObserver, idListObserver) || other.idListObserver == idListObserver)&&(identical(other.idListTaxonomy, idListTaxonomy) || other.idListTaxonomy == idListTaxonomy)&&(identical(other.idModule, idModule) || other.idModule == idModule)&&(identical(other.idTableLocation, idTableLocation) || other.idTableLocation == idTableLocation)&&(identical(other.label, label) || other.label == label)&&(identical(other.moduleCode, moduleCode) || other.moduleCode == moduleCode)&&(identical(other.moduleDesc, moduleDesc) || other.moduleDesc == moduleDesc)&&(identical(other.moduleLabel, moduleLabel) || other.moduleLabel == moduleLabel)&&const DeepCollectionEquality().equals(other.parentTypes, parentTypes)&&const DeepCollectionEquality().equals(other.propertiesKeys, propertiesKeys)&&(identical(other.rootObject, rootObject) || other.rootObject == rootObject)&&const DeepCollectionEquality().equals(other.specific, specific)&&(identical(other.taxonomyDisplayFieldName, taxonomyDisplayFieldName) || other.taxonomyDisplayFieldName == taxonomyDisplayFieldName)&&const DeepCollectionEquality().equals(other.typesSite, typesSite)&&(identical(other.uuidFieldName, uuidFieldName) || other.uuidFieldName == uuidFieldName));
}


@override
int get hashCode => Object.hashAll([runtimeType,drawSitesGroup,synthese,const DeepCollectionEquality().hash(childrenTypes),color,cruved,descriptionFieldName,const DeepCollectionEquality().hash(displayForm),const DeepCollectionEquality().hash(displayList),const DeepCollectionEquality().hash(displayProperties),const DeepCollectionEquality().hash(exportCsv),const DeepCollectionEquality().hash(exportPdf),const DeepCollectionEquality().hash(filters),const DeepCollectionEquality().hash(generic),genre,idFieldName,idListObserver,idListTaxonomy,idModule,idTableLocation,label,moduleCode,moduleDesc,moduleLabel,const DeepCollectionEquality().hash(parentTypes),const DeepCollectionEquality().hash(propertiesKeys),rootObject,const DeepCollectionEquality().hash(specific),taxonomyDisplayFieldName,const DeepCollectionEquality().hash(typesSite),uuidFieldName]);

@override
String toString() {
  return 'ModuleConfig(drawSitesGroup: $drawSitesGroup, synthese: $synthese, childrenTypes: $childrenTypes, color: $color, cruved: $cruved, descriptionFieldName: $descriptionFieldName, displayForm: $displayForm, displayList: $displayList, displayProperties: $displayProperties, exportCsv: $exportCsv, exportPdf: $exportPdf, filters: $filters, generic: $generic, genre: $genre, idFieldName: $idFieldName, idListObserver: $idListObserver, idListTaxonomy: $idListTaxonomy, idModule: $idModule, idTableLocation: $idTableLocation, label: $label, moduleCode: $moduleCode, moduleDesc: $moduleDesc, moduleLabel: $moduleLabel, parentTypes: $parentTypes, propertiesKeys: $propertiesKeys, rootObject: $rootObject, specific: $specific, taxonomyDisplayFieldName: $taxonomyDisplayFieldName, typesSite: $typesSite, uuidFieldName: $uuidFieldName)';
}


}

/// @nodoc
abstract mixin class $ModuleConfigCopyWith<$Res>  {
  factory $ModuleConfigCopyWith(ModuleConfig value, $Res Function(ModuleConfig) _then) = _$ModuleConfigCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'b_draw_sites_group') bool? drawSitesGroup,@JsonKey(name: 'b_synthese') bool? synthese, List<String>? childrenTypes, String? color, CruvedConfig? cruved, String? descriptionFieldName, List<String>? displayForm, List<String>? displayList, List<String>? displayProperties, List<ExportConfig>? exportCsv, List<ExportConfig>? exportPdf, Map<String, dynamic>? filters, Map<String, GenericFieldConfig>? generic, String? genre, String? idFieldName, int? idListObserver, int? idListTaxonomy, int? idModule, int? idTableLocation, String? label, String? moduleCode, String? moduleDesc, String? moduleLabel, List<String>? parentTypes, List<String>? propertiesKeys, bool? rootObject, Map<String, dynamic>? specific, String? taxonomyDisplayFieldName, Map<String, TypeSiteConfig>? typesSite, String? uuidFieldName
});


$CruvedConfigCopyWith<$Res>? get cruved;

}
/// @nodoc
class _$ModuleConfigCopyWithImpl<$Res>
    implements $ModuleConfigCopyWith<$Res> {
  _$ModuleConfigCopyWithImpl(this._self, this._then);

  final ModuleConfig _self;
  final $Res Function(ModuleConfig) _then;

/// Create a copy of ModuleConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? drawSitesGroup = freezed,Object? synthese = freezed,Object? childrenTypes = freezed,Object? color = freezed,Object? cruved = freezed,Object? descriptionFieldName = freezed,Object? displayForm = freezed,Object? displayList = freezed,Object? displayProperties = freezed,Object? exportCsv = freezed,Object? exportPdf = freezed,Object? filters = freezed,Object? generic = freezed,Object? genre = freezed,Object? idFieldName = freezed,Object? idListObserver = freezed,Object? idListTaxonomy = freezed,Object? idModule = freezed,Object? idTableLocation = freezed,Object? label = freezed,Object? moduleCode = freezed,Object? moduleDesc = freezed,Object? moduleLabel = freezed,Object? parentTypes = freezed,Object? propertiesKeys = freezed,Object? rootObject = freezed,Object? specific = freezed,Object? taxonomyDisplayFieldName = freezed,Object? typesSite = freezed,Object? uuidFieldName = freezed,}) {
  return _then(_self.copyWith(
drawSitesGroup: freezed == drawSitesGroup ? _self.drawSitesGroup : drawSitesGroup // ignore: cast_nullable_to_non_nullable
as bool?,synthese: freezed == synthese ? _self.synthese : synthese // ignore: cast_nullable_to_non_nullable
as bool?,childrenTypes: freezed == childrenTypes ? _self.childrenTypes : childrenTypes // ignore: cast_nullable_to_non_nullable
as List<String>?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,cruved: freezed == cruved ? _self.cruved : cruved // ignore: cast_nullable_to_non_nullable
as CruvedConfig?,descriptionFieldName: freezed == descriptionFieldName ? _self.descriptionFieldName : descriptionFieldName // ignore: cast_nullable_to_non_nullable
as String?,displayForm: freezed == displayForm ? _self.displayForm : displayForm // ignore: cast_nullable_to_non_nullable
as List<String>?,displayList: freezed == displayList ? _self.displayList : displayList // ignore: cast_nullable_to_non_nullable
as List<String>?,displayProperties: freezed == displayProperties ? _self.displayProperties : displayProperties // ignore: cast_nullable_to_non_nullable
as List<String>?,exportCsv: freezed == exportCsv ? _self.exportCsv : exportCsv // ignore: cast_nullable_to_non_nullable
as List<ExportConfig>?,exportPdf: freezed == exportPdf ? _self.exportPdf : exportPdf // ignore: cast_nullable_to_non_nullable
as List<ExportConfig>?,filters: freezed == filters ? _self.filters : filters // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,generic: freezed == generic ? _self.generic : generic // ignore: cast_nullable_to_non_nullable
as Map<String, GenericFieldConfig>?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,idFieldName: freezed == idFieldName ? _self.idFieldName : idFieldName // ignore: cast_nullable_to_non_nullable
as String?,idListObserver: freezed == idListObserver ? _self.idListObserver : idListObserver // ignore: cast_nullable_to_non_nullable
as int?,idListTaxonomy: freezed == idListTaxonomy ? _self.idListTaxonomy : idListTaxonomy // ignore: cast_nullable_to_non_nullable
as int?,idModule: freezed == idModule ? _self.idModule : idModule // ignore: cast_nullable_to_non_nullable
as int?,idTableLocation: freezed == idTableLocation ? _self.idTableLocation : idTableLocation // ignore: cast_nullable_to_non_nullable
as int?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,moduleCode: freezed == moduleCode ? _self.moduleCode : moduleCode // ignore: cast_nullable_to_non_nullable
as String?,moduleDesc: freezed == moduleDesc ? _self.moduleDesc : moduleDesc // ignore: cast_nullable_to_non_nullable
as String?,moduleLabel: freezed == moduleLabel ? _self.moduleLabel : moduleLabel // ignore: cast_nullable_to_non_nullable
as String?,parentTypes: freezed == parentTypes ? _self.parentTypes : parentTypes // ignore: cast_nullable_to_non_nullable
as List<String>?,propertiesKeys: freezed == propertiesKeys ? _self.propertiesKeys : propertiesKeys // ignore: cast_nullable_to_non_nullable
as List<String>?,rootObject: freezed == rootObject ? _self.rootObject : rootObject // ignore: cast_nullable_to_non_nullable
as bool?,specific: freezed == specific ? _self.specific : specific // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,taxonomyDisplayFieldName: freezed == taxonomyDisplayFieldName ? _self.taxonomyDisplayFieldName : taxonomyDisplayFieldName // ignore: cast_nullable_to_non_nullable
as String?,typesSite: freezed == typesSite ? _self.typesSite : typesSite // ignore: cast_nullable_to_non_nullable
as Map<String, TypeSiteConfig>?,uuidFieldName: freezed == uuidFieldName ? _self.uuidFieldName : uuidFieldName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ModuleConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CruvedConfigCopyWith<$Res>? get cruved {
    if (_self.cruved == null) {
    return null;
  }

  return $CruvedConfigCopyWith<$Res>(_self.cruved!, (value) {
    return _then(_self.copyWith(cruved: value));
  });
}
}


/// Adds pattern-matching-related methods to [ModuleConfig].
extension ModuleConfigPatterns on ModuleConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModuleConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModuleConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModuleConfig value)  $default,){
final _that = this;
switch (_that) {
case _ModuleConfig():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModuleConfig value)?  $default,){
final _that = this;
switch (_that) {
case _ModuleConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'b_draw_sites_group')  bool? drawSitesGroup, @JsonKey(name: 'b_synthese')  bool? synthese,  List<String>? childrenTypes,  String? color,  CruvedConfig? cruved,  String? descriptionFieldName,  List<String>? displayForm,  List<String>? displayList,  List<String>? displayProperties,  List<ExportConfig>? exportCsv,  List<ExportConfig>? exportPdf,  Map<String, dynamic>? filters,  Map<String, GenericFieldConfig>? generic,  String? genre,  String? idFieldName,  int? idListObserver,  int? idListTaxonomy,  int? idModule,  int? idTableLocation,  String? label,  String? moduleCode,  String? moduleDesc,  String? moduleLabel,  List<String>? parentTypes,  List<String>? propertiesKeys,  bool? rootObject,  Map<String, dynamic>? specific,  String? taxonomyDisplayFieldName,  Map<String, TypeSiteConfig>? typesSite,  String? uuidFieldName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModuleConfig() when $default != null:
return $default(_that.drawSitesGroup,_that.synthese,_that.childrenTypes,_that.color,_that.cruved,_that.descriptionFieldName,_that.displayForm,_that.displayList,_that.displayProperties,_that.exportCsv,_that.exportPdf,_that.filters,_that.generic,_that.genre,_that.idFieldName,_that.idListObserver,_that.idListTaxonomy,_that.idModule,_that.idTableLocation,_that.label,_that.moduleCode,_that.moduleDesc,_that.moduleLabel,_that.parentTypes,_that.propertiesKeys,_that.rootObject,_that.specific,_that.taxonomyDisplayFieldName,_that.typesSite,_that.uuidFieldName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'b_draw_sites_group')  bool? drawSitesGroup, @JsonKey(name: 'b_synthese')  bool? synthese,  List<String>? childrenTypes,  String? color,  CruvedConfig? cruved,  String? descriptionFieldName,  List<String>? displayForm,  List<String>? displayList,  List<String>? displayProperties,  List<ExportConfig>? exportCsv,  List<ExportConfig>? exportPdf,  Map<String, dynamic>? filters,  Map<String, GenericFieldConfig>? generic,  String? genre,  String? idFieldName,  int? idListObserver,  int? idListTaxonomy,  int? idModule,  int? idTableLocation,  String? label,  String? moduleCode,  String? moduleDesc,  String? moduleLabel,  List<String>? parentTypes,  List<String>? propertiesKeys,  bool? rootObject,  Map<String, dynamic>? specific,  String? taxonomyDisplayFieldName,  Map<String, TypeSiteConfig>? typesSite,  String? uuidFieldName)  $default,) {final _that = this;
switch (_that) {
case _ModuleConfig():
return $default(_that.drawSitesGroup,_that.synthese,_that.childrenTypes,_that.color,_that.cruved,_that.descriptionFieldName,_that.displayForm,_that.displayList,_that.displayProperties,_that.exportCsv,_that.exportPdf,_that.filters,_that.generic,_that.genre,_that.idFieldName,_that.idListObserver,_that.idListTaxonomy,_that.idModule,_that.idTableLocation,_that.label,_that.moduleCode,_that.moduleDesc,_that.moduleLabel,_that.parentTypes,_that.propertiesKeys,_that.rootObject,_that.specific,_that.taxonomyDisplayFieldName,_that.typesSite,_that.uuidFieldName);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'b_draw_sites_group')  bool? drawSitesGroup, @JsonKey(name: 'b_synthese')  bool? synthese,  List<String>? childrenTypes,  String? color,  CruvedConfig? cruved,  String? descriptionFieldName,  List<String>? displayForm,  List<String>? displayList,  List<String>? displayProperties,  List<ExportConfig>? exportCsv,  List<ExportConfig>? exportPdf,  Map<String, dynamic>? filters,  Map<String, GenericFieldConfig>? generic,  String? genre,  String? idFieldName,  int? idListObserver,  int? idListTaxonomy,  int? idModule,  int? idTableLocation,  String? label,  String? moduleCode,  String? moduleDesc,  String? moduleLabel,  List<String>? parentTypes,  List<String>? propertiesKeys,  bool? rootObject,  Map<String, dynamic>? specific,  String? taxonomyDisplayFieldName,  Map<String, TypeSiteConfig>? typesSite,  String? uuidFieldName)?  $default,) {final _that = this;
switch (_that) {
case _ModuleConfig() when $default != null:
return $default(_that.drawSitesGroup,_that.synthese,_that.childrenTypes,_that.color,_that.cruved,_that.descriptionFieldName,_that.displayForm,_that.displayList,_that.displayProperties,_that.exportCsv,_that.exportPdf,_that.filters,_that.generic,_that.genre,_that.idFieldName,_that.idListObserver,_that.idListTaxonomy,_that.idModule,_that.idTableLocation,_that.label,_that.moduleCode,_that.moduleDesc,_that.moduleLabel,_that.parentTypes,_that.propertiesKeys,_that.rootObject,_that.specific,_that.taxonomyDisplayFieldName,_that.typesSite,_that.uuidFieldName);case _:
  return null;

}
}

}

/// @nodoc


class _ModuleConfig implements ModuleConfig {
  const _ModuleConfig({@JsonKey(name: 'b_draw_sites_group') this.drawSitesGroup, @JsonKey(name: 'b_synthese') this.synthese, final  List<String>? childrenTypes, this.color, this.cruved, this.descriptionFieldName, final  List<String>? displayForm, final  List<String>? displayList, final  List<String>? displayProperties, final  List<ExportConfig>? exportCsv, final  List<ExportConfig>? exportPdf, final  Map<String, dynamic>? filters, final  Map<String, GenericFieldConfig>? generic, this.genre, this.idFieldName, this.idListObserver, this.idListTaxonomy, this.idModule, this.idTableLocation, this.label, this.moduleCode, this.moduleDesc, this.moduleLabel, final  List<String>? parentTypes, final  List<String>? propertiesKeys, this.rootObject, final  Map<String, dynamic>? specific, this.taxonomyDisplayFieldName, final  Map<String, TypeSiteConfig>? typesSite, this.uuidFieldName}): _childrenTypes = childrenTypes,_displayForm = displayForm,_displayList = displayList,_displayProperties = displayProperties,_exportCsv = exportCsv,_exportPdf = exportPdf,_filters = filters,_generic = generic,_parentTypes = parentTypes,_propertiesKeys = propertiesKeys,_specific = specific,_typesSite = typesSite;
  

@override@JsonKey(name: 'b_draw_sites_group') final  bool? drawSitesGroup;
@override@JsonKey(name: 'b_synthese') final  bool? synthese;
 final  List<String>? _childrenTypes;
@override List<String>? get childrenTypes {
  final value = _childrenTypes;
  if (value == null) return null;
  if (_childrenTypes is EqualUnmodifiableListView) return _childrenTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? color;
@override final  CruvedConfig? cruved;
@override final  String? descriptionFieldName;
 final  List<String>? _displayForm;
@override List<String>? get displayForm {
  final value = _displayForm;
  if (value == null) return null;
  if (_displayForm is EqualUnmodifiableListView) return _displayForm;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _displayList;
@override List<String>? get displayList {
  final value = _displayList;
  if (value == null) return null;
  if (_displayList is EqualUnmodifiableListView) return _displayList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _displayProperties;
@override List<String>? get displayProperties {
  final value = _displayProperties;
  if (value == null) return null;
  if (_displayProperties is EqualUnmodifiableListView) return _displayProperties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<ExportConfig>? _exportCsv;
@override List<ExportConfig>? get exportCsv {
  final value = _exportCsv;
  if (value == null) return null;
  if (_exportCsv is EqualUnmodifiableListView) return _exportCsv;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<ExportConfig>? _exportPdf;
@override List<ExportConfig>? get exportPdf {
  final value = _exportPdf;
  if (value == null) return null;
  if (_exportPdf is EqualUnmodifiableListView) return _exportPdf;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  Map<String, dynamic>? _filters;
@override Map<String, dynamic>? get filters {
  final value = _filters;
  if (value == null) return null;
  if (_filters is EqualUnmodifiableMapView) return _filters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, GenericFieldConfig>? _generic;
@override Map<String, GenericFieldConfig>? get generic {
  final value = _generic;
  if (value == null) return null;
  if (_generic is EqualUnmodifiableMapView) return _generic;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? genre;
@override final  String? idFieldName;
@override final  int? idListObserver;
@override final  int? idListTaxonomy;
@override final  int? idModule;
@override final  int? idTableLocation;
@override final  String? label;
@override final  String? moduleCode;
@override final  String? moduleDesc;
@override final  String? moduleLabel;
 final  List<String>? _parentTypes;
@override List<String>? get parentTypes {
  final value = _parentTypes;
  if (value == null) return null;
  if (_parentTypes is EqualUnmodifiableListView) return _parentTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _propertiesKeys;
@override List<String>? get propertiesKeys {
  final value = _propertiesKeys;
  if (value == null) return null;
  if (_propertiesKeys is EqualUnmodifiableListView) return _propertiesKeys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  bool? rootObject;
 final  Map<String, dynamic>? _specific;
@override Map<String, dynamic>? get specific {
  final value = _specific;
  if (value == null) return null;
  if (_specific is EqualUnmodifiableMapView) return _specific;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? taxonomyDisplayFieldName;
 final  Map<String, TypeSiteConfig>? _typesSite;
@override Map<String, TypeSiteConfig>? get typesSite {
  final value = _typesSite;
  if (value == null) return null;
  if (_typesSite is EqualUnmodifiableMapView) return _typesSite;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? uuidFieldName;

/// Create a copy of ModuleConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModuleConfigCopyWith<_ModuleConfig> get copyWith => __$ModuleConfigCopyWithImpl<_ModuleConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModuleConfig&&(identical(other.drawSitesGroup, drawSitesGroup) || other.drawSitesGroup == drawSitesGroup)&&(identical(other.synthese, synthese) || other.synthese == synthese)&&const DeepCollectionEquality().equals(other._childrenTypes, _childrenTypes)&&(identical(other.color, color) || other.color == color)&&(identical(other.cruved, cruved) || other.cruved == cruved)&&(identical(other.descriptionFieldName, descriptionFieldName) || other.descriptionFieldName == descriptionFieldName)&&const DeepCollectionEquality().equals(other._displayForm, _displayForm)&&const DeepCollectionEquality().equals(other._displayList, _displayList)&&const DeepCollectionEquality().equals(other._displayProperties, _displayProperties)&&const DeepCollectionEquality().equals(other._exportCsv, _exportCsv)&&const DeepCollectionEquality().equals(other._exportPdf, _exportPdf)&&const DeepCollectionEquality().equals(other._filters, _filters)&&const DeepCollectionEquality().equals(other._generic, _generic)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.idFieldName, idFieldName) || other.idFieldName == idFieldName)&&(identical(other.idListObserver, idListObserver) || other.idListObserver == idListObserver)&&(identical(other.idListTaxonomy, idListTaxonomy) || other.idListTaxonomy == idListTaxonomy)&&(identical(other.idModule, idModule) || other.idModule == idModule)&&(identical(other.idTableLocation, idTableLocation) || other.idTableLocation == idTableLocation)&&(identical(other.label, label) || other.label == label)&&(identical(other.moduleCode, moduleCode) || other.moduleCode == moduleCode)&&(identical(other.moduleDesc, moduleDesc) || other.moduleDesc == moduleDesc)&&(identical(other.moduleLabel, moduleLabel) || other.moduleLabel == moduleLabel)&&const DeepCollectionEquality().equals(other._parentTypes, _parentTypes)&&const DeepCollectionEquality().equals(other._propertiesKeys, _propertiesKeys)&&(identical(other.rootObject, rootObject) || other.rootObject == rootObject)&&const DeepCollectionEquality().equals(other._specific, _specific)&&(identical(other.taxonomyDisplayFieldName, taxonomyDisplayFieldName) || other.taxonomyDisplayFieldName == taxonomyDisplayFieldName)&&const DeepCollectionEquality().equals(other._typesSite, _typesSite)&&(identical(other.uuidFieldName, uuidFieldName) || other.uuidFieldName == uuidFieldName));
}


@override
int get hashCode => Object.hashAll([runtimeType,drawSitesGroup,synthese,const DeepCollectionEquality().hash(_childrenTypes),color,cruved,descriptionFieldName,const DeepCollectionEquality().hash(_displayForm),const DeepCollectionEquality().hash(_displayList),const DeepCollectionEquality().hash(_displayProperties),const DeepCollectionEquality().hash(_exportCsv),const DeepCollectionEquality().hash(_exportPdf),const DeepCollectionEquality().hash(_filters),const DeepCollectionEquality().hash(_generic),genre,idFieldName,idListObserver,idListTaxonomy,idModule,idTableLocation,label,moduleCode,moduleDesc,moduleLabel,const DeepCollectionEquality().hash(_parentTypes),const DeepCollectionEquality().hash(_propertiesKeys),rootObject,const DeepCollectionEquality().hash(_specific),taxonomyDisplayFieldName,const DeepCollectionEquality().hash(_typesSite),uuidFieldName]);

@override
String toString() {
  return 'ModuleConfig(drawSitesGroup: $drawSitesGroup, synthese: $synthese, childrenTypes: $childrenTypes, color: $color, cruved: $cruved, descriptionFieldName: $descriptionFieldName, displayForm: $displayForm, displayList: $displayList, displayProperties: $displayProperties, exportCsv: $exportCsv, exportPdf: $exportPdf, filters: $filters, generic: $generic, genre: $genre, idFieldName: $idFieldName, idListObserver: $idListObserver, idListTaxonomy: $idListTaxonomy, idModule: $idModule, idTableLocation: $idTableLocation, label: $label, moduleCode: $moduleCode, moduleDesc: $moduleDesc, moduleLabel: $moduleLabel, parentTypes: $parentTypes, propertiesKeys: $propertiesKeys, rootObject: $rootObject, specific: $specific, taxonomyDisplayFieldName: $taxonomyDisplayFieldName, typesSite: $typesSite, uuidFieldName: $uuidFieldName)';
}


}

/// @nodoc
abstract mixin class _$ModuleConfigCopyWith<$Res> implements $ModuleConfigCopyWith<$Res> {
  factory _$ModuleConfigCopyWith(_ModuleConfig value, $Res Function(_ModuleConfig) _then) = __$ModuleConfigCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'b_draw_sites_group') bool? drawSitesGroup,@JsonKey(name: 'b_synthese') bool? synthese, List<String>? childrenTypes, String? color, CruvedConfig? cruved, String? descriptionFieldName, List<String>? displayForm, List<String>? displayList, List<String>? displayProperties, List<ExportConfig>? exportCsv, List<ExportConfig>? exportPdf, Map<String, dynamic>? filters, Map<String, GenericFieldConfig>? generic, String? genre, String? idFieldName, int? idListObserver, int? idListTaxonomy, int? idModule, int? idTableLocation, String? label, String? moduleCode, String? moduleDesc, String? moduleLabel, List<String>? parentTypes, List<String>? propertiesKeys, bool? rootObject, Map<String, dynamic>? specific, String? taxonomyDisplayFieldName, Map<String, TypeSiteConfig>? typesSite, String? uuidFieldName
});


@override $CruvedConfigCopyWith<$Res>? get cruved;

}
/// @nodoc
class __$ModuleConfigCopyWithImpl<$Res>
    implements _$ModuleConfigCopyWith<$Res> {
  __$ModuleConfigCopyWithImpl(this._self, this._then);

  final _ModuleConfig _self;
  final $Res Function(_ModuleConfig) _then;

/// Create a copy of ModuleConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? drawSitesGroup = freezed,Object? synthese = freezed,Object? childrenTypes = freezed,Object? color = freezed,Object? cruved = freezed,Object? descriptionFieldName = freezed,Object? displayForm = freezed,Object? displayList = freezed,Object? displayProperties = freezed,Object? exportCsv = freezed,Object? exportPdf = freezed,Object? filters = freezed,Object? generic = freezed,Object? genre = freezed,Object? idFieldName = freezed,Object? idListObserver = freezed,Object? idListTaxonomy = freezed,Object? idModule = freezed,Object? idTableLocation = freezed,Object? label = freezed,Object? moduleCode = freezed,Object? moduleDesc = freezed,Object? moduleLabel = freezed,Object? parentTypes = freezed,Object? propertiesKeys = freezed,Object? rootObject = freezed,Object? specific = freezed,Object? taxonomyDisplayFieldName = freezed,Object? typesSite = freezed,Object? uuidFieldName = freezed,}) {
  return _then(_ModuleConfig(
drawSitesGroup: freezed == drawSitesGroup ? _self.drawSitesGroup : drawSitesGroup // ignore: cast_nullable_to_non_nullable
as bool?,synthese: freezed == synthese ? _self.synthese : synthese // ignore: cast_nullable_to_non_nullable
as bool?,childrenTypes: freezed == childrenTypes ? _self._childrenTypes : childrenTypes // ignore: cast_nullable_to_non_nullable
as List<String>?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,cruved: freezed == cruved ? _self.cruved : cruved // ignore: cast_nullable_to_non_nullable
as CruvedConfig?,descriptionFieldName: freezed == descriptionFieldName ? _self.descriptionFieldName : descriptionFieldName // ignore: cast_nullable_to_non_nullable
as String?,displayForm: freezed == displayForm ? _self._displayForm : displayForm // ignore: cast_nullable_to_non_nullable
as List<String>?,displayList: freezed == displayList ? _self._displayList : displayList // ignore: cast_nullable_to_non_nullable
as List<String>?,displayProperties: freezed == displayProperties ? _self._displayProperties : displayProperties // ignore: cast_nullable_to_non_nullable
as List<String>?,exportCsv: freezed == exportCsv ? _self._exportCsv : exportCsv // ignore: cast_nullable_to_non_nullable
as List<ExportConfig>?,exportPdf: freezed == exportPdf ? _self._exportPdf : exportPdf // ignore: cast_nullable_to_non_nullable
as List<ExportConfig>?,filters: freezed == filters ? _self._filters : filters // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,generic: freezed == generic ? _self._generic : generic // ignore: cast_nullable_to_non_nullable
as Map<String, GenericFieldConfig>?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,idFieldName: freezed == idFieldName ? _self.idFieldName : idFieldName // ignore: cast_nullable_to_non_nullable
as String?,idListObserver: freezed == idListObserver ? _self.idListObserver : idListObserver // ignore: cast_nullable_to_non_nullable
as int?,idListTaxonomy: freezed == idListTaxonomy ? _self.idListTaxonomy : idListTaxonomy // ignore: cast_nullable_to_non_nullable
as int?,idModule: freezed == idModule ? _self.idModule : idModule // ignore: cast_nullable_to_non_nullable
as int?,idTableLocation: freezed == idTableLocation ? _self.idTableLocation : idTableLocation // ignore: cast_nullable_to_non_nullable
as int?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,moduleCode: freezed == moduleCode ? _self.moduleCode : moduleCode // ignore: cast_nullable_to_non_nullable
as String?,moduleDesc: freezed == moduleDesc ? _self.moduleDesc : moduleDesc // ignore: cast_nullable_to_non_nullable
as String?,moduleLabel: freezed == moduleLabel ? _self.moduleLabel : moduleLabel // ignore: cast_nullable_to_non_nullable
as String?,parentTypes: freezed == parentTypes ? _self._parentTypes : parentTypes // ignore: cast_nullable_to_non_nullable
as List<String>?,propertiesKeys: freezed == propertiesKeys ? _self._propertiesKeys : propertiesKeys // ignore: cast_nullable_to_non_nullable
as List<String>?,rootObject: freezed == rootObject ? _self.rootObject : rootObject // ignore: cast_nullable_to_non_nullable
as bool?,specific: freezed == specific ? _self._specific : specific // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,taxonomyDisplayFieldName: freezed == taxonomyDisplayFieldName ? _self.taxonomyDisplayFieldName : taxonomyDisplayFieldName // ignore: cast_nullable_to_non_nullable
as String?,typesSite: freezed == typesSite ? _self._typesSite : typesSite // ignore: cast_nullable_to_non_nullable
as Map<String, TypeSiteConfig>?,uuidFieldName: freezed == uuidFieldName ? _self.uuidFieldName : uuidFieldName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ModuleConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CruvedConfigCopyWith<$Res>? get cruved {
    if (_self.cruved == null) {
    return null;
  }

  return $CruvedConfigCopyWith<$Res>(_self.cruved!, (value) {
    return _then(_self.copyWith(cruved: value));
  });
}
}

/// @nodoc
mixin _$CruvedConfig {

 int? get C; int? get R; int? get U; int? get V; int? get E; int? get D;
/// Create a copy of CruvedConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CruvedConfigCopyWith<CruvedConfig> get copyWith => _$CruvedConfigCopyWithImpl<CruvedConfig>(this as CruvedConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CruvedConfig&&(identical(other.C, C) || other.C == C)&&(identical(other.R, R) || other.R == R)&&(identical(other.U, U) || other.U == U)&&(identical(other.V, V) || other.V == V)&&(identical(other.E, E) || other.E == E)&&(identical(other.D, D) || other.D == D));
}


@override
int get hashCode => Object.hash(runtimeType,C,R,U,V,E,D);

@override
String toString() {
  return 'CruvedConfig(C: $C, R: $R, U: $U, V: $V, E: $E, D: $D)';
}


}

/// @nodoc
abstract mixin class $CruvedConfigCopyWith<$Res>  {
  factory $CruvedConfigCopyWith(CruvedConfig value, $Res Function(CruvedConfig) _then) = _$CruvedConfigCopyWithImpl;
@useResult
$Res call({
 int? C, int? R, int? U, int? V, int? E, int? D
});




}
/// @nodoc
class _$CruvedConfigCopyWithImpl<$Res>
    implements $CruvedConfigCopyWith<$Res> {
  _$CruvedConfigCopyWithImpl(this._self, this._then);

  final CruvedConfig _self;
  final $Res Function(CruvedConfig) _then;

/// Create a copy of CruvedConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? C = freezed,Object? R = freezed,Object? U = freezed,Object? V = freezed,Object? E = freezed,Object? D = freezed,}) {
  return _then(_self.copyWith(
C: freezed == C ? _self.C : C // ignore: cast_nullable_to_non_nullable
as int?,R: freezed == R ? _self.R : R // ignore: cast_nullable_to_non_nullable
as int?,U: freezed == U ? _self.U : U // ignore: cast_nullable_to_non_nullable
as int?,V: freezed == V ? _self.V : V // ignore: cast_nullable_to_non_nullable
as int?,E: freezed == E ? _self.E : E // ignore: cast_nullable_to_non_nullable
as int?,D: freezed == D ? _self.D : D // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [CruvedConfig].
extension CruvedConfigPatterns on CruvedConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CruvedConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CruvedConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CruvedConfig value)  $default,){
final _that = this;
switch (_that) {
case _CruvedConfig():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CruvedConfig value)?  $default,){
final _that = this;
switch (_that) {
case _CruvedConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? C,  int? R,  int? U,  int? V,  int? E,  int? D)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CruvedConfig() when $default != null:
return $default(_that.C,_that.R,_that.U,_that.V,_that.E,_that.D);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? C,  int? R,  int? U,  int? V,  int? E,  int? D)  $default,) {final _that = this;
switch (_that) {
case _CruvedConfig():
return $default(_that.C,_that.R,_that.U,_that.V,_that.E,_that.D);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? C,  int? R,  int? U,  int? V,  int? E,  int? D)?  $default,) {final _that = this;
switch (_that) {
case _CruvedConfig() when $default != null:
return $default(_that.C,_that.R,_that.U,_that.V,_that.E,_that.D);case _:
  return null;

}
}

}

/// @nodoc


class _CruvedConfig implements CruvedConfig {
  const _CruvedConfig({this.C, this.R, this.U, this.V, this.E, this.D});
  

@override final  int? C;
@override final  int? R;
@override final  int? U;
@override final  int? V;
@override final  int? E;
@override final  int? D;

/// Create a copy of CruvedConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CruvedConfigCopyWith<_CruvedConfig> get copyWith => __$CruvedConfigCopyWithImpl<_CruvedConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CruvedConfig&&(identical(other.C, C) || other.C == C)&&(identical(other.R, R) || other.R == R)&&(identical(other.U, U) || other.U == U)&&(identical(other.V, V) || other.V == V)&&(identical(other.E, E) || other.E == E)&&(identical(other.D, D) || other.D == D));
}


@override
int get hashCode => Object.hash(runtimeType,C,R,U,V,E,D);

@override
String toString() {
  return 'CruvedConfig(C: $C, R: $R, U: $U, V: $V, E: $E, D: $D)';
}


}

/// @nodoc
abstract mixin class _$CruvedConfigCopyWith<$Res> implements $CruvedConfigCopyWith<$Res> {
  factory _$CruvedConfigCopyWith(_CruvedConfig value, $Res Function(_CruvedConfig) _then) = __$CruvedConfigCopyWithImpl;
@override @useResult
$Res call({
 int? C, int? R, int? U, int? V, int? E, int? D
});




}
/// @nodoc
class __$CruvedConfigCopyWithImpl<$Res>
    implements _$CruvedConfigCopyWith<$Res> {
  __$CruvedConfigCopyWithImpl(this._self, this._then);

  final _CruvedConfig _self;
  final $Res Function(_CruvedConfig) _then;

/// Create a copy of CruvedConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? C = freezed,Object? R = freezed,Object? U = freezed,Object? V = freezed,Object? E = freezed,Object? D = freezed,}) {
  return _then(_CruvedConfig(
C: freezed == C ? _self.C : C // ignore: cast_nullable_to_non_nullable
as int?,R: freezed == R ? _self.R : R // ignore: cast_nullable_to_non_nullable
as int?,U: freezed == U ? _self.U : U // ignore: cast_nullable_to_non_nullable
as int?,V: freezed == V ? _self.V : V // ignore: cast_nullable_to_non_nullable
as int?,E: freezed == E ? _self.E : E // ignore: cast_nullable_to_non_nullable
as int?,D: freezed == D ? _self.D : D // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$ExportConfig {

 String? get label; String? get method; String? get type; String? get template;
/// Create a copy of ExportConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExportConfigCopyWith<ExportConfig> get copyWith => _$ExportConfigCopyWithImpl<ExportConfig>(this as ExportConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportConfig&&(identical(other.label, label) || other.label == label)&&(identical(other.method, method) || other.method == method)&&(identical(other.type, type) || other.type == type)&&(identical(other.template, template) || other.template == template));
}


@override
int get hashCode => Object.hash(runtimeType,label,method,type,template);

@override
String toString() {
  return 'ExportConfig(label: $label, method: $method, type: $type, template: $template)';
}


}

/// @nodoc
abstract mixin class $ExportConfigCopyWith<$Res>  {
  factory $ExportConfigCopyWith(ExportConfig value, $Res Function(ExportConfig) _then) = _$ExportConfigCopyWithImpl;
@useResult
$Res call({
 String? label, String? method, String? type, String? template
});




}
/// @nodoc
class _$ExportConfigCopyWithImpl<$Res>
    implements $ExportConfigCopyWith<$Res> {
  _$ExportConfigCopyWithImpl(this._self, this._then);

  final ExportConfig _self;
  final $Res Function(ExportConfig) _then;

/// Create a copy of ExportConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = freezed,Object? method = freezed,Object? type = freezed,Object? template = freezed,}) {
  return _then(_self.copyWith(
label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,template: freezed == template ? _self.template : template // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExportConfig].
extension ExportConfigPatterns on ExportConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExportConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExportConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExportConfig value)  $default,){
final _that = this;
switch (_that) {
case _ExportConfig():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExportConfig value)?  $default,){
final _that = this;
switch (_that) {
case _ExportConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? label,  String? method,  String? type,  String? template)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExportConfig() when $default != null:
return $default(_that.label,_that.method,_that.type,_that.template);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? label,  String? method,  String? type,  String? template)  $default,) {final _that = this;
switch (_that) {
case _ExportConfig():
return $default(_that.label,_that.method,_that.type,_that.template);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? label,  String? method,  String? type,  String? template)?  $default,) {final _that = this;
switch (_that) {
case _ExportConfig() when $default != null:
return $default(_that.label,_that.method,_that.type,_that.template);case _:
  return null;

}
}

}

/// @nodoc


class _ExportConfig implements ExportConfig {
  const _ExportConfig({this.label, this.method, this.type, this.template});
  

@override final  String? label;
@override final  String? method;
@override final  String? type;
@override final  String? template;

/// Create a copy of ExportConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExportConfigCopyWith<_ExportConfig> get copyWith => __$ExportConfigCopyWithImpl<_ExportConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportConfig&&(identical(other.label, label) || other.label == label)&&(identical(other.method, method) || other.method == method)&&(identical(other.type, type) || other.type == type)&&(identical(other.template, template) || other.template == template));
}


@override
int get hashCode => Object.hash(runtimeType,label,method,type,template);

@override
String toString() {
  return 'ExportConfig(label: $label, method: $method, type: $type, template: $template)';
}


}

/// @nodoc
abstract mixin class _$ExportConfigCopyWith<$Res> implements $ExportConfigCopyWith<$Res> {
  factory _$ExportConfigCopyWith(_ExportConfig value, $Res Function(_ExportConfig) _then) = __$ExportConfigCopyWithImpl;
@override @useResult
$Res call({
 String? label, String? method, String? type, String? template
});




}
/// @nodoc
class __$ExportConfigCopyWithImpl<$Res>
    implements _$ExportConfigCopyWith<$Res> {
  __$ExportConfigCopyWithImpl(this._self, this._then);

  final _ExportConfig _self;
  final $Res Function(_ExportConfig) _then;

/// Create a copy of ExportConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = freezed,Object? method = freezed,Object? type = freezed,Object? template = freezed,}) {
  return _then(_ExportConfig(
label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,template: freezed == template ? _self.template : template // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$GenericFieldConfig {

@JsonKey(name: 'attribut_label') String? get attributLabel; String? get definition; dynamic get hidden;// Booléen ou expression `({value}) => …` évaluée par le formulaire,
// comme `hidden` (#206).
 dynamic get required; String? get typeWidget; String? get typeUtil; bool? get multiSelect; String? get api; String? get application; String? get keyLabel; String? get keyValue; bool? get multiple; dynamic get values; dynamic get value; dynamic get default_; String? get designStyle; String? get dataPath;@JsonKey(name: 'id_list') dynamic get idList;/// Configuration des règles de changement automatique
/// Format: {"rules": [{"when": "...", "set": {...}}, ...]}
 dynamic get change;
/// Create a copy of GenericFieldConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenericFieldConfigCopyWith<GenericFieldConfig> get copyWith => _$GenericFieldConfigCopyWithImpl<GenericFieldConfig>(this as GenericFieldConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenericFieldConfig&&(identical(other.attributLabel, attributLabel) || other.attributLabel == attributLabel)&&(identical(other.definition, definition) || other.definition == definition)&&const DeepCollectionEquality().equals(other.hidden, hidden)&&const DeepCollectionEquality().equals(other.required, required)&&(identical(other.typeWidget, typeWidget) || other.typeWidget == typeWidget)&&(identical(other.typeUtil, typeUtil) || other.typeUtil == typeUtil)&&(identical(other.multiSelect, multiSelect) || other.multiSelect == multiSelect)&&(identical(other.api, api) || other.api == api)&&(identical(other.application, application) || other.application == application)&&(identical(other.keyLabel, keyLabel) || other.keyLabel == keyLabel)&&(identical(other.keyValue, keyValue) || other.keyValue == keyValue)&&(identical(other.multiple, multiple) || other.multiple == multiple)&&const DeepCollectionEquality().equals(other.values, values)&&const DeepCollectionEquality().equals(other.value, value)&&const DeepCollectionEquality().equals(other.default_, default_)&&(identical(other.designStyle, designStyle) || other.designStyle == designStyle)&&(identical(other.dataPath, dataPath) || other.dataPath == dataPath)&&const DeepCollectionEquality().equals(other.idList, idList)&&const DeepCollectionEquality().equals(other.change, change));
}


@override
int get hashCode => Object.hashAll([runtimeType,attributLabel,definition,const DeepCollectionEquality().hash(hidden),const DeepCollectionEquality().hash(required),typeWidget,typeUtil,multiSelect,api,application,keyLabel,keyValue,multiple,const DeepCollectionEquality().hash(values),const DeepCollectionEquality().hash(value),const DeepCollectionEquality().hash(default_),designStyle,dataPath,const DeepCollectionEquality().hash(idList),const DeepCollectionEquality().hash(change)]);

@override
String toString() {
  return 'GenericFieldConfig(attributLabel: $attributLabel, definition: $definition, hidden: $hidden, required: $required, typeWidget: $typeWidget, typeUtil: $typeUtil, multiSelect: $multiSelect, api: $api, application: $application, keyLabel: $keyLabel, keyValue: $keyValue, multiple: $multiple, values: $values, value: $value, default_: $default_, designStyle: $designStyle, dataPath: $dataPath, idList: $idList, change: $change)';
}


}

/// @nodoc
abstract mixin class $GenericFieldConfigCopyWith<$Res>  {
  factory $GenericFieldConfigCopyWith(GenericFieldConfig value, $Res Function(GenericFieldConfig) _then) = _$GenericFieldConfigCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'attribut_label') String? attributLabel, String? definition, dynamic hidden, dynamic required, String? typeWidget, String? typeUtil, bool? multiSelect, String? api, String? application, String? keyLabel, String? keyValue, bool? multiple, dynamic values, dynamic value, dynamic default_, String? designStyle, String? dataPath,@JsonKey(name: 'id_list') dynamic idList, dynamic change
});




}
/// @nodoc
class _$GenericFieldConfigCopyWithImpl<$Res>
    implements $GenericFieldConfigCopyWith<$Res> {
  _$GenericFieldConfigCopyWithImpl(this._self, this._then);

  final GenericFieldConfig _self;
  final $Res Function(GenericFieldConfig) _then;

/// Create a copy of GenericFieldConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? attributLabel = freezed,Object? definition = freezed,Object? hidden = freezed,Object? required = freezed,Object? typeWidget = freezed,Object? typeUtil = freezed,Object? multiSelect = freezed,Object? api = freezed,Object? application = freezed,Object? keyLabel = freezed,Object? keyValue = freezed,Object? multiple = freezed,Object? values = freezed,Object? value = freezed,Object? default_ = freezed,Object? designStyle = freezed,Object? dataPath = freezed,Object? idList = freezed,Object? change = freezed,}) {
  return _then(_self.copyWith(
attributLabel: freezed == attributLabel ? _self.attributLabel : attributLabel // ignore: cast_nullable_to_non_nullable
as String?,definition: freezed == definition ? _self.definition : definition // ignore: cast_nullable_to_non_nullable
as String?,hidden: freezed == hidden ? _self.hidden : hidden // ignore: cast_nullable_to_non_nullable
as dynamic,required: freezed == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as dynamic,typeWidget: freezed == typeWidget ? _self.typeWidget : typeWidget // ignore: cast_nullable_to_non_nullable
as String?,typeUtil: freezed == typeUtil ? _self.typeUtil : typeUtil // ignore: cast_nullable_to_non_nullable
as String?,multiSelect: freezed == multiSelect ? _self.multiSelect : multiSelect // ignore: cast_nullable_to_non_nullable
as bool?,api: freezed == api ? _self.api : api // ignore: cast_nullable_to_non_nullable
as String?,application: freezed == application ? _self.application : application // ignore: cast_nullable_to_non_nullable
as String?,keyLabel: freezed == keyLabel ? _self.keyLabel : keyLabel // ignore: cast_nullable_to_non_nullable
as String?,keyValue: freezed == keyValue ? _self.keyValue : keyValue // ignore: cast_nullable_to_non_nullable
as String?,multiple: freezed == multiple ? _self.multiple : multiple // ignore: cast_nullable_to_non_nullable
as bool?,values: freezed == values ? _self.values : values // ignore: cast_nullable_to_non_nullable
as dynamic,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as dynamic,default_: freezed == default_ ? _self.default_ : default_ // ignore: cast_nullable_to_non_nullable
as dynamic,designStyle: freezed == designStyle ? _self.designStyle : designStyle // ignore: cast_nullable_to_non_nullable
as String?,dataPath: freezed == dataPath ? _self.dataPath : dataPath // ignore: cast_nullable_to_non_nullable
as String?,idList: freezed == idList ? _self.idList : idList // ignore: cast_nullable_to_non_nullable
as dynamic,change: freezed == change ? _self.change : change // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}

}


/// Adds pattern-matching-related methods to [GenericFieldConfig].
extension GenericFieldConfigPatterns on GenericFieldConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GenericFieldConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GenericFieldConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GenericFieldConfig value)  $default,){
final _that = this;
switch (_that) {
case _GenericFieldConfig():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GenericFieldConfig value)?  $default,){
final _that = this;
switch (_that) {
case _GenericFieldConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'attribut_label')  String? attributLabel,  String? definition,  dynamic hidden,  dynamic required,  String? typeWidget,  String? typeUtil,  bool? multiSelect,  String? api,  String? application,  String? keyLabel,  String? keyValue,  bool? multiple,  dynamic values,  dynamic value,  dynamic default_,  String? designStyle,  String? dataPath, @JsonKey(name: 'id_list')  dynamic idList,  dynamic change)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GenericFieldConfig() when $default != null:
return $default(_that.attributLabel,_that.definition,_that.hidden,_that.required,_that.typeWidget,_that.typeUtil,_that.multiSelect,_that.api,_that.application,_that.keyLabel,_that.keyValue,_that.multiple,_that.values,_that.value,_that.default_,_that.designStyle,_that.dataPath,_that.idList,_that.change);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'attribut_label')  String? attributLabel,  String? definition,  dynamic hidden,  dynamic required,  String? typeWidget,  String? typeUtil,  bool? multiSelect,  String? api,  String? application,  String? keyLabel,  String? keyValue,  bool? multiple,  dynamic values,  dynamic value,  dynamic default_,  String? designStyle,  String? dataPath, @JsonKey(name: 'id_list')  dynamic idList,  dynamic change)  $default,) {final _that = this;
switch (_that) {
case _GenericFieldConfig():
return $default(_that.attributLabel,_that.definition,_that.hidden,_that.required,_that.typeWidget,_that.typeUtil,_that.multiSelect,_that.api,_that.application,_that.keyLabel,_that.keyValue,_that.multiple,_that.values,_that.value,_that.default_,_that.designStyle,_that.dataPath,_that.idList,_that.change);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'attribut_label')  String? attributLabel,  String? definition,  dynamic hidden,  dynamic required,  String? typeWidget,  String? typeUtil,  bool? multiSelect,  String? api,  String? application,  String? keyLabel,  String? keyValue,  bool? multiple,  dynamic values,  dynamic value,  dynamic default_,  String? designStyle,  String? dataPath, @JsonKey(name: 'id_list')  dynamic idList,  dynamic change)?  $default,) {final _that = this;
switch (_that) {
case _GenericFieldConfig() when $default != null:
return $default(_that.attributLabel,_that.definition,_that.hidden,_that.required,_that.typeWidget,_that.typeUtil,_that.multiSelect,_that.api,_that.application,_that.keyLabel,_that.keyValue,_that.multiple,_that.values,_that.value,_that.default_,_that.designStyle,_that.dataPath,_that.idList,_that.change);case _:
  return null;

}
}

}

/// @nodoc


class _GenericFieldConfig implements GenericFieldConfig {
  const _GenericFieldConfig({@JsonKey(name: 'attribut_label') this.attributLabel, this.definition, this.hidden, this.required, this.typeWidget, this.typeUtil, this.multiSelect, this.api, this.application, this.keyLabel, this.keyValue, this.multiple, this.values, this.value, this.default_, this.designStyle, this.dataPath, @JsonKey(name: 'id_list') this.idList, this.change});
  

@override@JsonKey(name: 'attribut_label') final  String? attributLabel;
@override final  String? definition;
@override final  dynamic hidden;
// Booléen ou expression `({value}) => …` évaluée par le formulaire,
// comme `hidden` (#206).
@override final  dynamic required;
@override final  String? typeWidget;
@override final  String? typeUtil;
@override final  bool? multiSelect;
@override final  String? api;
@override final  String? application;
@override final  String? keyLabel;
@override final  String? keyValue;
@override final  bool? multiple;
@override final  dynamic values;
@override final  dynamic value;
@override final  dynamic default_;
@override final  String? designStyle;
@override final  String? dataPath;
@override@JsonKey(name: 'id_list') final  dynamic idList;
/// Configuration des règles de changement automatique
/// Format: {"rules": [{"when": "...", "set": {...}}, ...]}
@override final  dynamic change;

/// Create a copy of GenericFieldConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenericFieldConfigCopyWith<_GenericFieldConfig> get copyWith => __$GenericFieldConfigCopyWithImpl<_GenericFieldConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenericFieldConfig&&(identical(other.attributLabel, attributLabel) || other.attributLabel == attributLabel)&&(identical(other.definition, definition) || other.definition == definition)&&const DeepCollectionEquality().equals(other.hidden, hidden)&&const DeepCollectionEquality().equals(other.required, required)&&(identical(other.typeWidget, typeWidget) || other.typeWidget == typeWidget)&&(identical(other.typeUtil, typeUtil) || other.typeUtil == typeUtil)&&(identical(other.multiSelect, multiSelect) || other.multiSelect == multiSelect)&&(identical(other.api, api) || other.api == api)&&(identical(other.application, application) || other.application == application)&&(identical(other.keyLabel, keyLabel) || other.keyLabel == keyLabel)&&(identical(other.keyValue, keyValue) || other.keyValue == keyValue)&&(identical(other.multiple, multiple) || other.multiple == multiple)&&const DeepCollectionEquality().equals(other.values, values)&&const DeepCollectionEquality().equals(other.value, value)&&const DeepCollectionEquality().equals(other.default_, default_)&&(identical(other.designStyle, designStyle) || other.designStyle == designStyle)&&(identical(other.dataPath, dataPath) || other.dataPath == dataPath)&&const DeepCollectionEquality().equals(other.idList, idList)&&const DeepCollectionEquality().equals(other.change, change));
}


@override
int get hashCode => Object.hashAll([runtimeType,attributLabel,definition,const DeepCollectionEquality().hash(hidden),const DeepCollectionEquality().hash(required),typeWidget,typeUtil,multiSelect,api,application,keyLabel,keyValue,multiple,const DeepCollectionEquality().hash(values),const DeepCollectionEquality().hash(value),const DeepCollectionEquality().hash(default_),designStyle,dataPath,const DeepCollectionEquality().hash(idList),const DeepCollectionEquality().hash(change)]);

@override
String toString() {
  return 'GenericFieldConfig(attributLabel: $attributLabel, definition: $definition, hidden: $hidden, required: $required, typeWidget: $typeWidget, typeUtil: $typeUtil, multiSelect: $multiSelect, api: $api, application: $application, keyLabel: $keyLabel, keyValue: $keyValue, multiple: $multiple, values: $values, value: $value, default_: $default_, designStyle: $designStyle, dataPath: $dataPath, idList: $idList, change: $change)';
}


}

/// @nodoc
abstract mixin class _$GenericFieldConfigCopyWith<$Res> implements $GenericFieldConfigCopyWith<$Res> {
  factory _$GenericFieldConfigCopyWith(_GenericFieldConfig value, $Res Function(_GenericFieldConfig) _then) = __$GenericFieldConfigCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'attribut_label') String? attributLabel, String? definition, dynamic hidden, dynamic required, String? typeWidget, String? typeUtil, bool? multiSelect, String? api, String? application, String? keyLabel, String? keyValue, bool? multiple, dynamic values, dynamic value, dynamic default_, String? designStyle, String? dataPath,@JsonKey(name: 'id_list') dynamic idList, dynamic change
});




}
/// @nodoc
class __$GenericFieldConfigCopyWithImpl<$Res>
    implements _$GenericFieldConfigCopyWith<$Res> {
  __$GenericFieldConfigCopyWithImpl(this._self, this._then);

  final _GenericFieldConfig _self;
  final $Res Function(_GenericFieldConfig) _then;

/// Create a copy of GenericFieldConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? attributLabel = freezed,Object? definition = freezed,Object? hidden = freezed,Object? required = freezed,Object? typeWidget = freezed,Object? typeUtil = freezed,Object? multiSelect = freezed,Object? api = freezed,Object? application = freezed,Object? keyLabel = freezed,Object? keyValue = freezed,Object? multiple = freezed,Object? values = freezed,Object? value = freezed,Object? default_ = freezed,Object? designStyle = freezed,Object? dataPath = freezed,Object? idList = freezed,Object? change = freezed,}) {
  return _then(_GenericFieldConfig(
attributLabel: freezed == attributLabel ? _self.attributLabel : attributLabel // ignore: cast_nullable_to_non_nullable
as String?,definition: freezed == definition ? _self.definition : definition // ignore: cast_nullable_to_non_nullable
as String?,hidden: freezed == hidden ? _self.hidden : hidden // ignore: cast_nullable_to_non_nullable
as dynamic,required: freezed == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as dynamic,typeWidget: freezed == typeWidget ? _self.typeWidget : typeWidget // ignore: cast_nullable_to_non_nullable
as String?,typeUtil: freezed == typeUtil ? _self.typeUtil : typeUtil // ignore: cast_nullable_to_non_nullable
as String?,multiSelect: freezed == multiSelect ? _self.multiSelect : multiSelect // ignore: cast_nullable_to_non_nullable
as bool?,api: freezed == api ? _self.api : api // ignore: cast_nullable_to_non_nullable
as String?,application: freezed == application ? _self.application : application // ignore: cast_nullable_to_non_nullable
as String?,keyLabel: freezed == keyLabel ? _self.keyLabel : keyLabel // ignore: cast_nullable_to_non_nullable
as String?,keyValue: freezed == keyValue ? _self.keyValue : keyValue // ignore: cast_nullable_to_non_nullable
as String?,multiple: freezed == multiple ? _self.multiple : multiple // ignore: cast_nullable_to_non_nullable
as bool?,values: freezed == values ? _self.values : values // ignore: cast_nullable_to_non_nullable
as dynamic,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as dynamic,default_: freezed == default_ ? _self.default_ : default_ // ignore: cast_nullable_to_non_nullable
as dynamic,designStyle: freezed == designStyle ? _self.designStyle : designStyle // ignore: cast_nullable_to_non_nullable
as String?,dataPath: freezed == dataPath ? _self.dataPath : dataPath // ignore: cast_nullable_to_non_nullable
as String?,idList: freezed == idList ? _self.idList : idList // ignore: cast_nullable_to_non_nullable
as dynamic,change: freezed == change ? _self.change : change // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}

/// @nodoc
mixin _$TypeSiteConfig {

 List<dynamic>? get displayProperties; String? get name;
/// Create a copy of TypeSiteConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TypeSiteConfigCopyWith<TypeSiteConfig> get copyWith => _$TypeSiteConfigCopyWithImpl<TypeSiteConfig>(this as TypeSiteConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TypeSiteConfig&&const DeepCollectionEquality().equals(other.displayProperties, displayProperties)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(displayProperties),name);

@override
String toString() {
  return 'TypeSiteConfig(displayProperties: $displayProperties, name: $name)';
}


}

/// @nodoc
abstract mixin class $TypeSiteConfigCopyWith<$Res>  {
  factory $TypeSiteConfigCopyWith(TypeSiteConfig value, $Res Function(TypeSiteConfig) _then) = _$TypeSiteConfigCopyWithImpl;
@useResult
$Res call({
 List<dynamic>? displayProperties, String? name
});




}
/// @nodoc
class _$TypeSiteConfigCopyWithImpl<$Res>
    implements $TypeSiteConfigCopyWith<$Res> {
  _$TypeSiteConfigCopyWithImpl(this._self, this._then);

  final TypeSiteConfig _self;
  final $Res Function(TypeSiteConfig) _then;

/// Create a copy of TypeSiteConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? displayProperties = freezed,Object? name = freezed,}) {
  return _then(_self.copyWith(
displayProperties: freezed == displayProperties ? _self.displayProperties : displayProperties // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TypeSiteConfig].
extension TypeSiteConfigPatterns on TypeSiteConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TypeSiteConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TypeSiteConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TypeSiteConfig value)  $default,){
final _that = this;
switch (_that) {
case _TypeSiteConfig():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TypeSiteConfig value)?  $default,){
final _that = this;
switch (_that) {
case _TypeSiteConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<dynamic>? displayProperties,  String? name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TypeSiteConfig() when $default != null:
return $default(_that.displayProperties,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<dynamic>? displayProperties,  String? name)  $default,) {final _that = this;
switch (_that) {
case _TypeSiteConfig():
return $default(_that.displayProperties,_that.name);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<dynamic>? displayProperties,  String? name)?  $default,) {final _that = this;
switch (_that) {
case _TypeSiteConfig() when $default != null:
return $default(_that.displayProperties,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _TypeSiteConfig implements TypeSiteConfig {
  const _TypeSiteConfig({final  List<dynamic>? displayProperties, this.name}): _displayProperties = displayProperties;
  

 final  List<dynamic>? _displayProperties;
@override List<dynamic>? get displayProperties {
  final value = _displayProperties;
  if (value == null) return null;
  if (_displayProperties is EqualUnmodifiableListView) return _displayProperties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? name;

/// Create a copy of TypeSiteConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TypeSiteConfigCopyWith<_TypeSiteConfig> get copyWith => __$TypeSiteConfigCopyWithImpl<_TypeSiteConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TypeSiteConfig&&const DeepCollectionEquality().equals(other._displayProperties, _displayProperties)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_displayProperties),name);

@override
String toString() {
  return 'TypeSiteConfig(displayProperties: $displayProperties, name: $name)';
}


}

/// @nodoc
abstract mixin class _$TypeSiteConfigCopyWith<$Res> implements $TypeSiteConfigCopyWith<$Res> {
  factory _$TypeSiteConfigCopyWith(_TypeSiteConfig value, $Res Function(_TypeSiteConfig) _then) = __$TypeSiteConfigCopyWithImpl;
@override @useResult
$Res call({
 List<dynamic>? displayProperties, String? name
});




}
/// @nodoc
class __$TypeSiteConfigCopyWithImpl<$Res>
    implements _$TypeSiteConfigCopyWith<$Res> {
  __$TypeSiteConfigCopyWithImpl(this._self, this._then);

  final _TypeSiteConfig _self;
  final $Res Function(_TypeSiteConfig) _then;

/// Create a copy of TypeSiteConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? displayProperties = freezed,Object? name = freezed,}) {
  return _then(_TypeSiteConfig(
displayProperties: freezed == displayProperties ? _self._displayProperties : displayProperties // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ObjectConfig {

 bool? get chained;/// Configuration des règles de changement automatique (format JS)
/// Format: ["({objForm, meta}) => {", "if (...) { patchValue({...}) }", ...]
 List<dynamic>? get change; List<String>? get childrenTypes; String? get descriptionFieldName; List<String>? get displayForm; List<String>? get displayList; List<String>? get displayProperties; List<ExportConfig>? get exportPdf; Map<String, dynamic>? get filters; Map<String, GenericFieldConfig>? get generic; String? get genre; String? get geomFieldName; List<String>? get geometryType; String? get idFieldName; int? get idTableLocation;@JsonKey(name: 'is_editable_on_field') bool? get isEditableOnField;/// Champs dont la valeur est reprise d'une saisie à la suivante en mode
/// enchaînement (`keep`, comme `resetObjForm` du module web)
 List<String>? get keep; String? get label; String? get labelList; String? get mapLabelFieldName; List<String>? get parentTypes; List<String>? get propertiesKeys; List<SortConfig>? get sorts; Map<String, dynamic>? get specific; Map<String, TypeSiteConfig>? get typesSite; String? get uuidFieldName;
/// Create a copy of ObjectConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ObjectConfigCopyWith<ObjectConfig> get copyWith => _$ObjectConfigCopyWithImpl<ObjectConfig>(this as ObjectConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ObjectConfig&&(identical(other.chained, chained) || other.chained == chained)&&const DeepCollectionEquality().equals(other.change, change)&&const DeepCollectionEquality().equals(other.childrenTypes, childrenTypes)&&(identical(other.descriptionFieldName, descriptionFieldName) || other.descriptionFieldName == descriptionFieldName)&&const DeepCollectionEquality().equals(other.displayForm, displayForm)&&const DeepCollectionEquality().equals(other.displayList, displayList)&&const DeepCollectionEquality().equals(other.displayProperties, displayProperties)&&const DeepCollectionEquality().equals(other.exportPdf, exportPdf)&&const DeepCollectionEquality().equals(other.filters, filters)&&const DeepCollectionEquality().equals(other.generic, generic)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.geomFieldName, geomFieldName) || other.geomFieldName == geomFieldName)&&const DeepCollectionEquality().equals(other.geometryType, geometryType)&&(identical(other.idFieldName, idFieldName) || other.idFieldName == idFieldName)&&(identical(other.idTableLocation, idTableLocation) || other.idTableLocation == idTableLocation)&&(identical(other.isEditableOnField, isEditableOnField) || other.isEditableOnField == isEditableOnField)&&const DeepCollectionEquality().equals(other.keep, keep)&&(identical(other.label, label) || other.label == label)&&(identical(other.labelList, labelList) || other.labelList == labelList)&&(identical(other.mapLabelFieldName, mapLabelFieldName) || other.mapLabelFieldName == mapLabelFieldName)&&const DeepCollectionEquality().equals(other.parentTypes, parentTypes)&&const DeepCollectionEquality().equals(other.propertiesKeys, propertiesKeys)&&const DeepCollectionEquality().equals(other.sorts, sorts)&&const DeepCollectionEquality().equals(other.specific, specific)&&const DeepCollectionEquality().equals(other.typesSite, typesSite)&&(identical(other.uuidFieldName, uuidFieldName) || other.uuidFieldName == uuidFieldName));
}


@override
int get hashCode => Object.hashAll([runtimeType,chained,const DeepCollectionEquality().hash(change),const DeepCollectionEquality().hash(childrenTypes),descriptionFieldName,const DeepCollectionEquality().hash(displayForm),const DeepCollectionEquality().hash(displayList),const DeepCollectionEquality().hash(displayProperties),const DeepCollectionEquality().hash(exportPdf),const DeepCollectionEquality().hash(filters),const DeepCollectionEquality().hash(generic),genre,geomFieldName,const DeepCollectionEquality().hash(geometryType),idFieldName,idTableLocation,isEditableOnField,const DeepCollectionEquality().hash(keep),label,labelList,mapLabelFieldName,const DeepCollectionEquality().hash(parentTypes),const DeepCollectionEquality().hash(propertiesKeys),const DeepCollectionEquality().hash(sorts),const DeepCollectionEquality().hash(specific),const DeepCollectionEquality().hash(typesSite),uuidFieldName]);

@override
String toString() {
  return 'ObjectConfig(chained: $chained, change: $change, childrenTypes: $childrenTypes, descriptionFieldName: $descriptionFieldName, displayForm: $displayForm, displayList: $displayList, displayProperties: $displayProperties, exportPdf: $exportPdf, filters: $filters, generic: $generic, genre: $genre, geomFieldName: $geomFieldName, geometryType: $geometryType, idFieldName: $idFieldName, idTableLocation: $idTableLocation, isEditableOnField: $isEditableOnField, keep: $keep, label: $label, labelList: $labelList, mapLabelFieldName: $mapLabelFieldName, parentTypes: $parentTypes, propertiesKeys: $propertiesKeys, sorts: $sorts, specific: $specific, typesSite: $typesSite, uuidFieldName: $uuidFieldName)';
}


}

/// @nodoc
abstract mixin class $ObjectConfigCopyWith<$Res>  {
  factory $ObjectConfigCopyWith(ObjectConfig value, $Res Function(ObjectConfig) _then) = _$ObjectConfigCopyWithImpl;
@useResult
$Res call({
 bool? chained, List<dynamic>? change, List<String>? childrenTypes, String? descriptionFieldName, List<String>? displayForm, List<String>? displayList, List<String>? displayProperties, List<ExportConfig>? exportPdf, Map<String, dynamic>? filters, Map<String, GenericFieldConfig>? generic, String? genre, String? geomFieldName, List<String>? geometryType, String? idFieldName, int? idTableLocation,@JsonKey(name: 'is_editable_on_field') bool? isEditableOnField, List<String>? keep, String? label, String? labelList, String? mapLabelFieldName, List<String>? parentTypes, List<String>? propertiesKeys, List<SortConfig>? sorts, Map<String, dynamic>? specific, Map<String, TypeSiteConfig>? typesSite, String? uuidFieldName
});




}
/// @nodoc
class _$ObjectConfigCopyWithImpl<$Res>
    implements $ObjectConfigCopyWith<$Res> {
  _$ObjectConfigCopyWithImpl(this._self, this._then);

  final ObjectConfig _self;
  final $Res Function(ObjectConfig) _then;

/// Create a copy of ObjectConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chained = freezed,Object? change = freezed,Object? childrenTypes = freezed,Object? descriptionFieldName = freezed,Object? displayForm = freezed,Object? displayList = freezed,Object? displayProperties = freezed,Object? exportPdf = freezed,Object? filters = freezed,Object? generic = freezed,Object? genre = freezed,Object? geomFieldName = freezed,Object? geometryType = freezed,Object? idFieldName = freezed,Object? idTableLocation = freezed,Object? isEditableOnField = freezed,Object? keep = freezed,Object? label = freezed,Object? labelList = freezed,Object? mapLabelFieldName = freezed,Object? parentTypes = freezed,Object? propertiesKeys = freezed,Object? sorts = freezed,Object? specific = freezed,Object? typesSite = freezed,Object? uuidFieldName = freezed,}) {
  return _then(_self.copyWith(
chained: freezed == chained ? _self.chained : chained // ignore: cast_nullable_to_non_nullable
as bool?,change: freezed == change ? _self.change : change // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,childrenTypes: freezed == childrenTypes ? _self.childrenTypes : childrenTypes // ignore: cast_nullable_to_non_nullable
as List<String>?,descriptionFieldName: freezed == descriptionFieldName ? _self.descriptionFieldName : descriptionFieldName // ignore: cast_nullable_to_non_nullable
as String?,displayForm: freezed == displayForm ? _self.displayForm : displayForm // ignore: cast_nullable_to_non_nullable
as List<String>?,displayList: freezed == displayList ? _self.displayList : displayList // ignore: cast_nullable_to_non_nullable
as List<String>?,displayProperties: freezed == displayProperties ? _self.displayProperties : displayProperties // ignore: cast_nullable_to_non_nullable
as List<String>?,exportPdf: freezed == exportPdf ? _self.exportPdf : exportPdf // ignore: cast_nullable_to_non_nullable
as List<ExportConfig>?,filters: freezed == filters ? _self.filters : filters // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,generic: freezed == generic ? _self.generic : generic // ignore: cast_nullable_to_non_nullable
as Map<String, GenericFieldConfig>?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,geomFieldName: freezed == geomFieldName ? _self.geomFieldName : geomFieldName // ignore: cast_nullable_to_non_nullable
as String?,geometryType: freezed == geometryType ? _self.geometryType : geometryType // ignore: cast_nullable_to_non_nullable
as List<String>?,idFieldName: freezed == idFieldName ? _self.idFieldName : idFieldName // ignore: cast_nullable_to_non_nullable
as String?,idTableLocation: freezed == idTableLocation ? _self.idTableLocation : idTableLocation // ignore: cast_nullable_to_non_nullable
as int?,isEditableOnField: freezed == isEditableOnField ? _self.isEditableOnField : isEditableOnField // ignore: cast_nullable_to_non_nullable
as bool?,keep: freezed == keep ? _self.keep : keep // ignore: cast_nullable_to_non_nullable
as List<String>?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,labelList: freezed == labelList ? _self.labelList : labelList // ignore: cast_nullable_to_non_nullable
as String?,mapLabelFieldName: freezed == mapLabelFieldName ? _self.mapLabelFieldName : mapLabelFieldName // ignore: cast_nullable_to_non_nullable
as String?,parentTypes: freezed == parentTypes ? _self.parentTypes : parentTypes // ignore: cast_nullable_to_non_nullable
as List<String>?,propertiesKeys: freezed == propertiesKeys ? _self.propertiesKeys : propertiesKeys // ignore: cast_nullable_to_non_nullable
as List<String>?,sorts: freezed == sorts ? _self.sorts : sorts // ignore: cast_nullable_to_non_nullable
as List<SortConfig>?,specific: freezed == specific ? _self.specific : specific // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,typesSite: freezed == typesSite ? _self.typesSite : typesSite // ignore: cast_nullable_to_non_nullable
as Map<String, TypeSiteConfig>?,uuidFieldName: freezed == uuidFieldName ? _self.uuidFieldName : uuidFieldName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ObjectConfig].
extension ObjectConfigPatterns on ObjectConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ObjectConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ObjectConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ObjectConfig value)  $default,){
final _that = this;
switch (_that) {
case _ObjectConfig():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ObjectConfig value)?  $default,){
final _that = this;
switch (_that) {
case _ObjectConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? chained,  List<dynamic>? change,  List<String>? childrenTypes,  String? descriptionFieldName,  List<String>? displayForm,  List<String>? displayList,  List<String>? displayProperties,  List<ExportConfig>? exportPdf,  Map<String, dynamic>? filters,  Map<String, GenericFieldConfig>? generic,  String? genre,  String? geomFieldName,  List<String>? geometryType,  String? idFieldName,  int? idTableLocation, @JsonKey(name: 'is_editable_on_field')  bool? isEditableOnField,  List<String>? keep,  String? label,  String? labelList,  String? mapLabelFieldName,  List<String>? parentTypes,  List<String>? propertiesKeys,  List<SortConfig>? sorts,  Map<String, dynamic>? specific,  Map<String, TypeSiteConfig>? typesSite,  String? uuidFieldName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ObjectConfig() when $default != null:
return $default(_that.chained,_that.change,_that.childrenTypes,_that.descriptionFieldName,_that.displayForm,_that.displayList,_that.displayProperties,_that.exportPdf,_that.filters,_that.generic,_that.genre,_that.geomFieldName,_that.geometryType,_that.idFieldName,_that.idTableLocation,_that.isEditableOnField,_that.keep,_that.label,_that.labelList,_that.mapLabelFieldName,_that.parentTypes,_that.propertiesKeys,_that.sorts,_that.specific,_that.typesSite,_that.uuidFieldName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? chained,  List<dynamic>? change,  List<String>? childrenTypes,  String? descriptionFieldName,  List<String>? displayForm,  List<String>? displayList,  List<String>? displayProperties,  List<ExportConfig>? exportPdf,  Map<String, dynamic>? filters,  Map<String, GenericFieldConfig>? generic,  String? genre,  String? geomFieldName,  List<String>? geometryType,  String? idFieldName,  int? idTableLocation, @JsonKey(name: 'is_editable_on_field')  bool? isEditableOnField,  List<String>? keep,  String? label,  String? labelList,  String? mapLabelFieldName,  List<String>? parentTypes,  List<String>? propertiesKeys,  List<SortConfig>? sorts,  Map<String, dynamic>? specific,  Map<String, TypeSiteConfig>? typesSite,  String? uuidFieldName)  $default,) {final _that = this;
switch (_that) {
case _ObjectConfig():
return $default(_that.chained,_that.change,_that.childrenTypes,_that.descriptionFieldName,_that.displayForm,_that.displayList,_that.displayProperties,_that.exportPdf,_that.filters,_that.generic,_that.genre,_that.geomFieldName,_that.geometryType,_that.idFieldName,_that.idTableLocation,_that.isEditableOnField,_that.keep,_that.label,_that.labelList,_that.mapLabelFieldName,_that.parentTypes,_that.propertiesKeys,_that.sorts,_that.specific,_that.typesSite,_that.uuidFieldName);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? chained,  List<dynamic>? change,  List<String>? childrenTypes,  String? descriptionFieldName,  List<String>? displayForm,  List<String>? displayList,  List<String>? displayProperties,  List<ExportConfig>? exportPdf,  Map<String, dynamic>? filters,  Map<String, GenericFieldConfig>? generic,  String? genre,  String? geomFieldName,  List<String>? geometryType,  String? idFieldName,  int? idTableLocation, @JsonKey(name: 'is_editable_on_field')  bool? isEditableOnField,  List<String>? keep,  String? label,  String? labelList,  String? mapLabelFieldName,  List<String>? parentTypes,  List<String>? propertiesKeys,  List<SortConfig>? sorts,  Map<String, dynamic>? specific,  Map<String, TypeSiteConfig>? typesSite,  String? uuidFieldName)?  $default,) {final _that = this;
switch (_that) {
case _ObjectConfig() when $default != null:
return $default(_that.chained,_that.change,_that.childrenTypes,_that.descriptionFieldName,_that.displayForm,_that.displayList,_that.displayProperties,_that.exportPdf,_that.filters,_that.generic,_that.genre,_that.geomFieldName,_that.geometryType,_that.idFieldName,_that.idTableLocation,_that.isEditableOnField,_that.keep,_that.label,_that.labelList,_that.mapLabelFieldName,_that.parentTypes,_that.propertiesKeys,_that.sorts,_that.specific,_that.typesSite,_that.uuidFieldName);case _:
  return null;

}
}

}

/// @nodoc


class _ObjectConfig implements ObjectConfig {
  const _ObjectConfig({this.chained, final  List<dynamic>? change, final  List<String>? childrenTypes, this.descriptionFieldName, final  List<String>? displayForm, final  List<String>? displayList, final  List<String>? displayProperties, final  List<ExportConfig>? exportPdf, final  Map<String, dynamic>? filters, final  Map<String, GenericFieldConfig>? generic, this.genre, this.geomFieldName, final  List<String>? geometryType, this.idFieldName, this.idTableLocation, @JsonKey(name: 'is_editable_on_field') this.isEditableOnField, final  List<String>? keep, this.label, this.labelList, this.mapLabelFieldName, final  List<String>? parentTypes, final  List<String>? propertiesKeys, final  List<SortConfig>? sorts, final  Map<String, dynamic>? specific, final  Map<String, TypeSiteConfig>? typesSite, this.uuidFieldName}): _change = change,_childrenTypes = childrenTypes,_displayForm = displayForm,_displayList = displayList,_displayProperties = displayProperties,_exportPdf = exportPdf,_filters = filters,_generic = generic,_geometryType = geometryType,_keep = keep,_parentTypes = parentTypes,_propertiesKeys = propertiesKeys,_sorts = sorts,_specific = specific,_typesSite = typesSite;
  

@override final  bool? chained;
/// Configuration des règles de changement automatique (format JS)
/// Format: ["({objForm, meta}) => {", "if (...) { patchValue({...}) }", ...]
 final  List<dynamic>? _change;
/// Configuration des règles de changement automatique (format JS)
/// Format: ["({objForm, meta}) => {", "if (...) { patchValue({...}) }", ...]
@override List<dynamic>? get change {
  final value = _change;
  if (value == null) return null;
  if (_change is EqualUnmodifiableListView) return _change;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _childrenTypes;
@override List<String>? get childrenTypes {
  final value = _childrenTypes;
  if (value == null) return null;
  if (_childrenTypes is EqualUnmodifiableListView) return _childrenTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? descriptionFieldName;
 final  List<String>? _displayForm;
@override List<String>? get displayForm {
  final value = _displayForm;
  if (value == null) return null;
  if (_displayForm is EqualUnmodifiableListView) return _displayForm;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _displayList;
@override List<String>? get displayList {
  final value = _displayList;
  if (value == null) return null;
  if (_displayList is EqualUnmodifiableListView) return _displayList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _displayProperties;
@override List<String>? get displayProperties {
  final value = _displayProperties;
  if (value == null) return null;
  if (_displayProperties is EqualUnmodifiableListView) return _displayProperties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<ExportConfig>? _exportPdf;
@override List<ExportConfig>? get exportPdf {
  final value = _exportPdf;
  if (value == null) return null;
  if (_exportPdf is EqualUnmodifiableListView) return _exportPdf;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  Map<String, dynamic>? _filters;
@override Map<String, dynamic>? get filters {
  final value = _filters;
  if (value == null) return null;
  if (_filters is EqualUnmodifiableMapView) return _filters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, GenericFieldConfig>? _generic;
@override Map<String, GenericFieldConfig>? get generic {
  final value = _generic;
  if (value == null) return null;
  if (_generic is EqualUnmodifiableMapView) return _generic;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? genre;
@override final  String? geomFieldName;
 final  List<String>? _geometryType;
@override List<String>? get geometryType {
  final value = _geometryType;
  if (value == null) return null;
  if (_geometryType is EqualUnmodifiableListView) return _geometryType;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? idFieldName;
@override final  int? idTableLocation;
@override@JsonKey(name: 'is_editable_on_field') final  bool? isEditableOnField;
/// Champs dont la valeur est reprise d'une saisie à la suivante en mode
/// enchaînement (`keep`, comme `resetObjForm` du module web)
 final  List<String>? _keep;
/// Champs dont la valeur est reprise d'une saisie à la suivante en mode
/// enchaînement (`keep`, comme `resetObjForm` du module web)
@override List<String>? get keep {
  final value = _keep;
  if (value == null) return null;
  if (_keep is EqualUnmodifiableListView) return _keep;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? label;
@override final  String? labelList;
@override final  String? mapLabelFieldName;
 final  List<String>? _parentTypes;
@override List<String>? get parentTypes {
  final value = _parentTypes;
  if (value == null) return null;
  if (_parentTypes is EqualUnmodifiableListView) return _parentTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _propertiesKeys;
@override List<String>? get propertiesKeys {
  final value = _propertiesKeys;
  if (value == null) return null;
  if (_propertiesKeys is EqualUnmodifiableListView) return _propertiesKeys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<SortConfig>? _sorts;
@override List<SortConfig>? get sorts {
  final value = _sorts;
  if (value == null) return null;
  if (_sorts is EqualUnmodifiableListView) return _sorts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  Map<String, dynamic>? _specific;
@override Map<String, dynamic>? get specific {
  final value = _specific;
  if (value == null) return null;
  if (_specific is EqualUnmodifiableMapView) return _specific;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, TypeSiteConfig>? _typesSite;
@override Map<String, TypeSiteConfig>? get typesSite {
  final value = _typesSite;
  if (value == null) return null;
  if (_typesSite is EqualUnmodifiableMapView) return _typesSite;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? uuidFieldName;

/// Create a copy of ObjectConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ObjectConfigCopyWith<_ObjectConfig> get copyWith => __$ObjectConfigCopyWithImpl<_ObjectConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ObjectConfig&&(identical(other.chained, chained) || other.chained == chained)&&const DeepCollectionEquality().equals(other._change, _change)&&const DeepCollectionEquality().equals(other._childrenTypes, _childrenTypes)&&(identical(other.descriptionFieldName, descriptionFieldName) || other.descriptionFieldName == descriptionFieldName)&&const DeepCollectionEquality().equals(other._displayForm, _displayForm)&&const DeepCollectionEquality().equals(other._displayList, _displayList)&&const DeepCollectionEquality().equals(other._displayProperties, _displayProperties)&&const DeepCollectionEquality().equals(other._exportPdf, _exportPdf)&&const DeepCollectionEquality().equals(other._filters, _filters)&&const DeepCollectionEquality().equals(other._generic, _generic)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.geomFieldName, geomFieldName) || other.geomFieldName == geomFieldName)&&const DeepCollectionEquality().equals(other._geometryType, _geometryType)&&(identical(other.idFieldName, idFieldName) || other.idFieldName == idFieldName)&&(identical(other.idTableLocation, idTableLocation) || other.idTableLocation == idTableLocation)&&(identical(other.isEditableOnField, isEditableOnField) || other.isEditableOnField == isEditableOnField)&&const DeepCollectionEquality().equals(other._keep, _keep)&&(identical(other.label, label) || other.label == label)&&(identical(other.labelList, labelList) || other.labelList == labelList)&&(identical(other.mapLabelFieldName, mapLabelFieldName) || other.mapLabelFieldName == mapLabelFieldName)&&const DeepCollectionEquality().equals(other._parentTypes, _parentTypes)&&const DeepCollectionEquality().equals(other._propertiesKeys, _propertiesKeys)&&const DeepCollectionEquality().equals(other._sorts, _sorts)&&const DeepCollectionEquality().equals(other._specific, _specific)&&const DeepCollectionEquality().equals(other._typesSite, _typesSite)&&(identical(other.uuidFieldName, uuidFieldName) || other.uuidFieldName == uuidFieldName));
}


@override
int get hashCode => Object.hashAll([runtimeType,chained,const DeepCollectionEquality().hash(_change),const DeepCollectionEquality().hash(_childrenTypes),descriptionFieldName,const DeepCollectionEquality().hash(_displayForm),const DeepCollectionEquality().hash(_displayList),const DeepCollectionEquality().hash(_displayProperties),const DeepCollectionEquality().hash(_exportPdf),const DeepCollectionEquality().hash(_filters),const DeepCollectionEquality().hash(_generic),genre,geomFieldName,const DeepCollectionEquality().hash(_geometryType),idFieldName,idTableLocation,isEditableOnField,const DeepCollectionEquality().hash(_keep),label,labelList,mapLabelFieldName,const DeepCollectionEquality().hash(_parentTypes),const DeepCollectionEquality().hash(_propertiesKeys),const DeepCollectionEquality().hash(_sorts),const DeepCollectionEquality().hash(_specific),const DeepCollectionEquality().hash(_typesSite),uuidFieldName]);

@override
String toString() {
  return 'ObjectConfig(chained: $chained, change: $change, childrenTypes: $childrenTypes, descriptionFieldName: $descriptionFieldName, displayForm: $displayForm, displayList: $displayList, displayProperties: $displayProperties, exportPdf: $exportPdf, filters: $filters, generic: $generic, genre: $genre, geomFieldName: $geomFieldName, geometryType: $geometryType, idFieldName: $idFieldName, idTableLocation: $idTableLocation, isEditableOnField: $isEditableOnField, keep: $keep, label: $label, labelList: $labelList, mapLabelFieldName: $mapLabelFieldName, parentTypes: $parentTypes, propertiesKeys: $propertiesKeys, sorts: $sorts, specific: $specific, typesSite: $typesSite, uuidFieldName: $uuidFieldName)';
}


}

/// @nodoc
abstract mixin class _$ObjectConfigCopyWith<$Res> implements $ObjectConfigCopyWith<$Res> {
  factory _$ObjectConfigCopyWith(_ObjectConfig value, $Res Function(_ObjectConfig) _then) = __$ObjectConfigCopyWithImpl;
@override @useResult
$Res call({
 bool? chained, List<dynamic>? change, List<String>? childrenTypes, String? descriptionFieldName, List<String>? displayForm, List<String>? displayList, List<String>? displayProperties, List<ExportConfig>? exportPdf, Map<String, dynamic>? filters, Map<String, GenericFieldConfig>? generic, String? genre, String? geomFieldName, List<String>? geometryType, String? idFieldName, int? idTableLocation,@JsonKey(name: 'is_editable_on_field') bool? isEditableOnField, List<String>? keep, String? label, String? labelList, String? mapLabelFieldName, List<String>? parentTypes, List<String>? propertiesKeys, List<SortConfig>? sorts, Map<String, dynamic>? specific, Map<String, TypeSiteConfig>? typesSite, String? uuidFieldName
});




}
/// @nodoc
class __$ObjectConfigCopyWithImpl<$Res>
    implements _$ObjectConfigCopyWith<$Res> {
  __$ObjectConfigCopyWithImpl(this._self, this._then);

  final _ObjectConfig _self;
  final $Res Function(_ObjectConfig) _then;

/// Create a copy of ObjectConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chained = freezed,Object? change = freezed,Object? childrenTypes = freezed,Object? descriptionFieldName = freezed,Object? displayForm = freezed,Object? displayList = freezed,Object? displayProperties = freezed,Object? exportPdf = freezed,Object? filters = freezed,Object? generic = freezed,Object? genre = freezed,Object? geomFieldName = freezed,Object? geometryType = freezed,Object? idFieldName = freezed,Object? idTableLocation = freezed,Object? isEditableOnField = freezed,Object? keep = freezed,Object? label = freezed,Object? labelList = freezed,Object? mapLabelFieldName = freezed,Object? parentTypes = freezed,Object? propertiesKeys = freezed,Object? sorts = freezed,Object? specific = freezed,Object? typesSite = freezed,Object? uuidFieldName = freezed,}) {
  return _then(_ObjectConfig(
chained: freezed == chained ? _self.chained : chained // ignore: cast_nullable_to_non_nullable
as bool?,change: freezed == change ? _self._change : change // ignore: cast_nullable_to_non_nullable
as List<dynamic>?,childrenTypes: freezed == childrenTypes ? _self._childrenTypes : childrenTypes // ignore: cast_nullable_to_non_nullable
as List<String>?,descriptionFieldName: freezed == descriptionFieldName ? _self.descriptionFieldName : descriptionFieldName // ignore: cast_nullable_to_non_nullable
as String?,displayForm: freezed == displayForm ? _self._displayForm : displayForm // ignore: cast_nullable_to_non_nullable
as List<String>?,displayList: freezed == displayList ? _self._displayList : displayList // ignore: cast_nullable_to_non_nullable
as List<String>?,displayProperties: freezed == displayProperties ? _self._displayProperties : displayProperties // ignore: cast_nullable_to_non_nullable
as List<String>?,exportPdf: freezed == exportPdf ? _self._exportPdf : exportPdf // ignore: cast_nullable_to_non_nullable
as List<ExportConfig>?,filters: freezed == filters ? _self._filters : filters // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,generic: freezed == generic ? _self._generic : generic // ignore: cast_nullable_to_non_nullable
as Map<String, GenericFieldConfig>?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,geomFieldName: freezed == geomFieldName ? _self.geomFieldName : geomFieldName // ignore: cast_nullable_to_non_nullable
as String?,geometryType: freezed == geometryType ? _self._geometryType : geometryType // ignore: cast_nullable_to_non_nullable
as List<String>?,idFieldName: freezed == idFieldName ? _self.idFieldName : idFieldName // ignore: cast_nullable_to_non_nullable
as String?,idTableLocation: freezed == idTableLocation ? _self.idTableLocation : idTableLocation // ignore: cast_nullable_to_non_nullable
as int?,isEditableOnField: freezed == isEditableOnField ? _self.isEditableOnField : isEditableOnField // ignore: cast_nullable_to_non_nullable
as bool?,keep: freezed == keep ? _self._keep : keep // ignore: cast_nullable_to_non_nullable
as List<String>?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,labelList: freezed == labelList ? _self.labelList : labelList // ignore: cast_nullable_to_non_nullable
as String?,mapLabelFieldName: freezed == mapLabelFieldName ? _self.mapLabelFieldName : mapLabelFieldName // ignore: cast_nullable_to_non_nullable
as String?,parentTypes: freezed == parentTypes ? _self._parentTypes : parentTypes // ignore: cast_nullable_to_non_nullable
as List<String>?,propertiesKeys: freezed == propertiesKeys ? _self._propertiesKeys : propertiesKeys // ignore: cast_nullable_to_non_nullable
as List<String>?,sorts: freezed == sorts ? _self._sorts : sorts // ignore: cast_nullable_to_non_nullable
as List<SortConfig>?,specific: freezed == specific ? _self._specific : specific // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,typesSite: freezed == typesSite ? _self._typesSite : typesSite // ignore: cast_nullable_to_non_nullable
as Map<String, TypeSiteConfig>?,uuidFieldName: freezed == uuidFieldName ? _self.uuidFieldName : uuidFieldName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$SortConfig {

 String? get dir; String? get prop;
/// Create a copy of SortConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SortConfigCopyWith<SortConfig> get copyWith => _$SortConfigCopyWithImpl<SortConfig>(this as SortConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SortConfig&&(identical(other.dir, dir) || other.dir == dir)&&(identical(other.prop, prop) || other.prop == prop));
}


@override
int get hashCode => Object.hash(runtimeType,dir,prop);

@override
String toString() {
  return 'SortConfig(dir: $dir, prop: $prop)';
}


}

/// @nodoc
abstract mixin class $SortConfigCopyWith<$Res>  {
  factory $SortConfigCopyWith(SortConfig value, $Res Function(SortConfig) _then) = _$SortConfigCopyWithImpl;
@useResult
$Res call({
 String? dir, String? prop
});




}
/// @nodoc
class _$SortConfigCopyWithImpl<$Res>
    implements $SortConfigCopyWith<$Res> {
  _$SortConfigCopyWithImpl(this._self, this._then);

  final SortConfig _self;
  final $Res Function(SortConfig) _then;

/// Create a copy of SortConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dir = freezed,Object? prop = freezed,}) {
  return _then(_self.copyWith(
dir: freezed == dir ? _self.dir : dir // ignore: cast_nullable_to_non_nullable
as String?,prop: freezed == prop ? _self.prop : prop // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SortConfig].
extension SortConfigPatterns on SortConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SortConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SortConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SortConfig value)  $default,){
final _that = this;
switch (_that) {
case _SortConfig():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SortConfig value)?  $default,){
final _that = this;
switch (_that) {
case _SortConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? dir,  String? prop)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SortConfig() when $default != null:
return $default(_that.dir,_that.prop);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? dir,  String? prop)  $default,) {final _that = this;
switch (_that) {
case _SortConfig():
return $default(_that.dir,_that.prop);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? dir,  String? prop)?  $default,) {final _that = this;
switch (_that) {
case _SortConfig() when $default != null:
return $default(_that.dir,_that.prop);case _:
  return null;

}
}

}

/// @nodoc


class _SortConfig implements SortConfig {
  const _SortConfig({this.dir, this.prop});
  

@override final  String? dir;
@override final  String? prop;

/// Create a copy of SortConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SortConfigCopyWith<_SortConfig> get copyWith => __$SortConfigCopyWithImpl<_SortConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SortConfig&&(identical(other.dir, dir) || other.dir == dir)&&(identical(other.prop, prop) || other.prop == prop));
}


@override
int get hashCode => Object.hash(runtimeType,dir,prop);

@override
String toString() {
  return 'SortConfig(dir: $dir, prop: $prop)';
}


}

/// @nodoc
abstract mixin class _$SortConfigCopyWith<$Res> implements $SortConfigCopyWith<$Res> {
  factory _$SortConfigCopyWith(_SortConfig value, $Res Function(_SortConfig) _then) = __$SortConfigCopyWithImpl;
@override @useResult
$Res call({
 String? dir, String? prop
});




}
/// @nodoc
class __$SortConfigCopyWithImpl<$Res>
    implements _$SortConfigCopyWith<$Res> {
  __$SortConfigCopyWithImpl(this._self, this._then);

  final _SortConfig _self;
  final $Res Function(_SortConfig) _then;

/// Create a copy of SortConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dir = freezed,Object? prop = freezed,}) {
  return _then(_SortConfig(
dir: freezed == dir ? _self.dir : dir // ignore: cast_nullable_to_non_nullable
as String?,prop: freezed == prop ? _self.prop : prop // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$TreeConfig {

 Map<String, dynamic>? get module;
/// Create a copy of TreeConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TreeConfigCopyWith<TreeConfig> get copyWith => _$TreeConfigCopyWithImpl<TreeConfig>(this as TreeConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TreeConfig&&const DeepCollectionEquality().equals(other.module, module));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(module));

@override
String toString() {
  return 'TreeConfig(module: $module)';
}


}

/// @nodoc
abstract mixin class $TreeConfigCopyWith<$Res>  {
  factory $TreeConfigCopyWith(TreeConfig value, $Res Function(TreeConfig) _then) = _$TreeConfigCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic>? module
});




}
/// @nodoc
class _$TreeConfigCopyWithImpl<$Res>
    implements $TreeConfigCopyWith<$Res> {
  _$TreeConfigCopyWithImpl(this._self, this._then);

  final TreeConfig _self;
  final $Res Function(TreeConfig) _then;

/// Create a copy of TreeConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? module = freezed,}) {
  return _then(_self.copyWith(
module: freezed == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [TreeConfig].
extension TreeConfigPatterns on TreeConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TreeConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TreeConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TreeConfig value)  $default,){
final _that = this;
switch (_that) {
case _TreeConfig():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TreeConfig value)?  $default,){
final _that = this;
switch (_that) {
case _TreeConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, dynamic>? module)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TreeConfig() when $default != null:
return $default(_that.module);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, dynamic>? module)  $default,) {final _that = this;
switch (_that) {
case _TreeConfig():
return $default(_that.module);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, dynamic>? module)?  $default,) {final _that = this;
switch (_that) {
case _TreeConfig() when $default != null:
return $default(_that.module);case _:
  return null;

}
}

}

/// @nodoc


class _TreeConfig implements TreeConfig {
  const _TreeConfig({final  Map<String, dynamic>? module}): _module = module;
  

 final  Map<String, dynamic>? _module;
@override Map<String, dynamic>? get module {
  final value = _module;
  if (value == null) return null;
  if (_module is EqualUnmodifiableMapView) return _module;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of TreeConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TreeConfigCopyWith<_TreeConfig> get copyWith => __$TreeConfigCopyWithImpl<_TreeConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TreeConfig&&const DeepCollectionEquality().equals(other._module, _module));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_module));

@override
String toString() {
  return 'TreeConfig(module: $module)';
}


}

/// @nodoc
abstract mixin class _$TreeConfigCopyWith<$Res> implements $TreeConfigCopyWith<$Res> {
  factory _$TreeConfigCopyWith(_TreeConfig value, $Res Function(_TreeConfig) _then) = __$TreeConfigCopyWithImpl;
@override @useResult
$Res call({
 Map<String, dynamic>? module
});




}
/// @nodoc
class __$TreeConfigCopyWithImpl<$Res>
    implements _$TreeConfigCopyWith<$Res> {
  __$TreeConfigCopyWithImpl(this._self, this._then);

  final _TreeConfig _self;
  final $Res Function(_TreeConfig) _then;

/// Create a copy of TreeConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? module = freezed,}) {
  return _then(_TreeConfig(
module: freezed == module ? _self._module : module // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
