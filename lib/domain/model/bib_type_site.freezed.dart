// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bib_type_site.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BibTypeSite {

 int get idNomenclatureTypeSite; Map<String, dynamic>? get config;
/// Create a copy of BibTypeSite
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BibTypeSiteCopyWith<BibTypeSite> get copyWith => _$BibTypeSiteCopyWithImpl<BibTypeSite>(this as BibTypeSite, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BibTypeSite&&(identical(other.idNomenclatureTypeSite, idNomenclatureTypeSite) || other.idNomenclatureTypeSite == idNomenclatureTypeSite)&&const DeepCollectionEquality().equals(other.config, config));
}


@override
int get hashCode => Object.hash(runtimeType,idNomenclatureTypeSite,const DeepCollectionEquality().hash(config));

@override
String toString() {
  return 'BibTypeSite(idNomenclatureTypeSite: $idNomenclatureTypeSite, config: $config)';
}


}

/// @nodoc
abstract mixin class $BibTypeSiteCopyWith<$Res>  {
  factory $BibTypeSiteCopyWith(BibTypeSite value, $Res Function(BibTypeSite) _then) = _$BibTypeSiteCopyWithImpl;
@useResult
$Res call({
 int idNomenclatureTypeSite, Map<String, dynamic>? config
});




}
/// @nodoc
class _$BibTypeSiteCopyWithImpl<$Res>
    implements $BibTypeSiteCopyWith<$Res> {
  _$BibTypeSiteCopyWithImpl(this._self, this._then);

  final BibTypeSite _self;
  final $Res Function(BibTypeSite) _then;

/// Create a copy of BibTypeSite
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idNomenclatureTypeSite = null,Object? config = freezed,}) {
  return _then(_self.copyWith(
idNomenclatureTypeSite: null == idNomenclatureTypeSite ? _self.idNomenclatureTypeSite : idNomenclatureTypeSite // ignore: cast_nullable_to_non_nullable
as int,config: freezed == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [BibTypeSite].
extension BibTypeSitePatterns on BibTypeSite {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BibTypeSite value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BibTypeSite() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BibTypeSite value)  $default,){
final _that = this;
switch (_that) {
case _BibTypeSite():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BibTypeSite value)?  $default,){
final _that = this;
switch (_that) {
case _BibTypeSite() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int idNomenclatureTypeSite,  Map<String, dynamic>? config)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BibTypeSite() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int idNomenclatureTypeSite,  Map<String, dynamic>? config)  $default,) {final _that = this;
switch (_that) {
case _BibTypeSite():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int idNomenclatureTypeSite,  Map<String, dynamic>? config)?  $default,) {final _that = this;
switch (_that) {
case _BibTypeSite() when $default != null:
return $default(_that.idNomenclatureTypeSite,_that.config);case _:
  return null;

}
}

}

/// @nodoc


class _BibTypeSite implements BibTypeSite {
  const _BibTypeSite({required this.idNomenclatureTypeSite, final  Map<String, dynamic>? config}): _config = config;
  

@override final  int idNomenclatureTypeSite;
 final  Map<String, dynamic>? _config;
@override Map<String, dynamic>? get config {
  final value = _config;
  if (value == null) return null;
  if (_config is EqualUnmodifiableMapView) return _config;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of BibTypeSite
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BibTypeSiteCopyWith<_BibTypeSite> get copyWith => __$BibTypeSiteCopyWithImpl<_BibTypeSite>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BibTypeSite&&(identical(other.idNomenclatureTypeSite, idNomenclatureTypeSite) || other.idNomenclatureTypeSite == idNomenclatureTypeSite)&&const DeepCollectionEquality().equals(other._config, _config));
}


@override
int get hashCode => Object.hash(runtimeType,idNomenclatureTypeSite,const DeepCollectionEquality().hash(_config));

@override
String toString() {
  return 'BibTypeSite(idNomenclatureTypeSite: $idNomenclatureTypeSite, config: $config)';
}


}

/// @nodoc
abstract mixin class _$BibTypeSiteCopyWith<$Res> implements $BibTypeSiteCopyWith<$Res> {
  factory _$BibTypeSiteCopyWith(_BibTypeSite value, $Res Function(_BibTypeSite) _then) = __$BibTypeSiteCopyWithImpl;
@override @useResult
$Res call({
 int idNomenclatureTypeSite, Map<String, dynamic>? config
});




}
/// @nodoc
class __$BibTypeSiteCopyWithImpl<$Res>
    implements _$BibTypeSiteCopyWith<$Res> {
  __$BibTypeSiteCopyWithImpl(this._self, this._then);

  final _BibTypeSite _self;
  final $Res Function(_BibTypeSite) _then;

/// Create a copy of BibTypeSite
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idNomenclatureTypeSite = null,Object? config = freezed,}) {
  return _then(_BibTypeSite(
idNomenclatureTypeSite: null == idNomenclatureTypeSite ? _self.idNomenclatureTypeSite : idNomenclatureTypeSite // ignore: cast_nullable_to_non_nullable
as int,config: freezed == config ? _self._config : config // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
