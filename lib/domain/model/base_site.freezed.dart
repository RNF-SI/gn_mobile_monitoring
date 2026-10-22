// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'base_site.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BaseSite {

 int get idBaseSite; String? get baseSiteName; String? get baseSiteDescription; String? get baseSiteCode; DateTime? get firstUseDate; String? get geom;// GeoJSON representation
 String? get uuidBaseSite; int? get altitudeMin; int? get altitudeMax; int? get idInventor; int? get idDigitiser; DateTime? get metaCreateDate; DateTime? get metaUpdateDate; Map<String, dynamic>? get data; bool? get isLocal;// true si créé localement, false si récupéré depuis l'API
 int? get serverSiteId;
/// Create a copy of BaseSite
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BaseSiteCopyWith<BaseSite> get copyWith => _$BaseSiteCopyWithImpl<BaseSite>(this as BaseSite, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BaseSite&&(identical(other.idBaseSite, idBaseSite) || other.idBaseSite == idBaseSite)&&(identical(other.baseSiteName, baseSiteName) || other.baseSiteName == baseSiteName)&&(identical(other.baseSiteDescription, baseSiteDescription) || other.baseSiteDescription == baseSiteDescription)&&(identical(other.baseSiteCode, baseSiteCode) || other.baseSiteCode == baseSiteCode)&&(identical(other.firstUseDate, firstUseDate) || other.firstUseDate == firstUseDate)&&(identical(other.geom, geom) || other.geom == geom)&&(identical(other.uuidBaseSite, uuidBaseSite) || other.uuidBaseSite == uuidBaseSite)&&(identical(other.altitudeMin, altitudeMin) || other.altitudeMin == altitudeMin)&&(identical(other.altitudeMax, altitudeMax) || other.altitudeMax == altitudeMax)&&(identical(other.idInventor, idInventor) || other.idInventor == idInventor)&&(identical(other.idDigitiser, idDigitiser) || other.idDigitiser == idDigitiser)&&(identical(other.metaCreateDate, metaCreateDate) || other.metaCreateDate == metaCreateDate)&&(identical(other.metaUpdateDate, metaUpdateDate) || other.metaUpdateDate == metaUpdateDate)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.isLocal, isLocal) || other.isLocal == isLocal)&&(identical(other.serverSiteId, serverSiteId) || other.serverSiteId == serverSiteId));
}


@override
int get hashCode => Object.hash(runtimeType,idBaseSite,baseSiteName,baseSiteDescription,baseSiteCode,firstUseDate,geom,uuidBaseSite,altitudeMin,altitudeMax,idInventor,idDigitiser,metaCreateDate,metaUpdateDate,const DeepCollectionEquality().hash(data),isLocal,serverSiteId);

@override
String toString() {
  return 'BaseSite(idBaseSite: $idBaseSite, baseSiteName: $baseSiteName, baseSiteDescription: $baseSiteDescription, baseSiteCode: $baseSiteCode, firstUseDate: $firstUseDate, geom: $geom, uuidBaseSite: $uuidBaseSite, altitudeMin: $altitudeMin, altitudeMax: $altitudeMax, idInventor: $idInventor, idDigitiser: $idDigitiser, metaCreateDate: $metaCreateDate, metaUpdateDate: $metaUpdateDate, data: $data, isLocal: $isLocal, serverSiteId: $serverSiteId)';
}


}

/// @nodoc
abstract mixin class $BaseSiteCopyWith<$Res>  {
  factory $BaseSiteCopyWith(BaseSite value, $Res Function(BaseSite) _then) = _$BaseSiteCopyWithImpl;
@useResult
$Res call({
 int idBaseSite, String? baseSiteName, String? baseSiteDescription, String? baseSiteCode, DateTime? firstUseDate, String? geom, String? uuidBaseSite, int? altitudeMin, int? altitudeMax, int? idInventor, int? idDigitiser, DateTime? metaCreateDate, DateTime? metaUpdateDate, Map<String, dynamic>? data, bool? isLocal, int? serverSiteId
});




}
/// @nodoc
class _$BaseSiteCopyWithImpl<$Res>
    implements $BaseSiteCopyWith<$Res> {
  _$BaseSiteCopyWithImpl(this._self, this._then);

  final BaseSite _self;
  final $Res Function(BaseSite) _then;

/// Create a copy of BaseSite
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idBaseSite = null,Object? baseSiteName = freezed,Object? baseSiteDescription = freezed,Object? baseSiteCode = freezed,Object? firstUseDate = freezed,Object? geom = freezed,Object? uuidBaseSite = freezed,Object? altitudeMin = freezed,Object? altitudeMax = freezed,Object? idInventor = freezed,Object? idDigitiser = freezed,Object? metaCreateDate = freezed,Object? metaUpdateDate = freezed,Object? data = freezed,Object? isLocal = freezed,Object? serverSiteId = freezed,}) {
  return _then(_self.copyWith(
idBaseSite: null == idBaseSite ? _self.idBaseSite : idBaseSite // ignore: cast_nullable_to_non_nullable
as int,baseSiteName: freezed == baseSiteName ? _self.baseSiteName : baseSiteName // ignore: cast_nullable_to_non_nullable
as String?,baseSiteDescription: freezed == baseSiteDescription ? _self.baseSiteDescription : baseSiteDescription // ignore: cast_nullable_to_non_nullable
as String?,baseSiteCode: freezed == baseSiteCode ? _self.baseSiteCode : baseSiteCode // ignore: cast_nullable_to_non_nullable
as String?,firstUseDate: freezed == firstUseDate ? _self.firstUseDate : firstUseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,geom: freezed == geom ? _self.geom : geom // ignore: cast_nullable_to_non_nullable
as String?,uuidBaseSite: freezed == uuidBaseSite ? _self.uuidBaseSite : uuidBaseSite // ignore: cast_nullable_to_non_nullable
as String?,altitudeMin: freezed == altitudeMin ? _self.altitudeMin : altitudeMin // ignore: cast_nullable_to_non_nullable
as int?,altitudeMax: freezed == altitudeMax ? _self.altitudeMax : altitudeMax // ignore: cast_nullable_to_non_nullable
as int?,idInventor: freezed == idInventor ? _self.idInventor : idInventor // ignore: cast_nullable_to_non_nullable
as int?,idDigitiser: freezed == idDigitiser ? _self.idDigitiser : idDigitiser // ignore: cast_nullable_to_non_nullable
as int?,metaCreateDate: freezed == metaCreateDate ? _self.metaCreateDate : metaCreateDate // ignore: cast_nullable_to_non_nullable
as DateTime?,metaUpdateDate: freezed == metaUpdateDate ? _self.metaUpdateDate : metaUpdateDate // ignore: cast_nullable_to_non_nullable
as DateTime?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,isLocal: freezed == isLocal ? _self.isLocal : isLocal // ignore: cast_nullable_to_non_nullable
as bool?,serverSiteId: freezed == serverSiteId ? _self.serverSiteId : serverSiteId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [BaseSite].
extension BaseSitePatterns on BaseSite {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BaseSite value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BaseSite() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BaseSite value)  $default,){
final _that = this;
switch (_that) {
case _BaseSite():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BaseSite value)?  $default,){
final _that = this;
switch (_that) {
case _BaseSite() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int idBaseSite,  String? baseSiteName,  String? baseSiteDescription,  String? baseSiteCode,  DateTime? firstUseDate,  String? geom,  String? uuidBaseSite,  int? altitudeMin,  int? altitudeMax,  int? idInventor,  int? idDigitiser,  DateTime? metaCreateDate,  DateTime? metaUpdateDate,  Map<String, dynamic>? data,  bool? isLocal,  int? serverSiteId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BaseSite() when $default != null:
return $default(_that.idBaseSite,_that.baseSiteName,_that.baseSiteDescription,_that.baseSiteCode,_that.firstUseDate,_that.geom,_that.uuidBaseSite,_that.altitudeMin,_that.altitudeMax,_that.idInventor,_that.idDigitiser,_that.metaCreateDate,_that.metaUpdateDate,_that.data,_that.isLocal,_that.serverSiteId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int idBaseSite,  String? baseSiteName,  String? baseSiteDescription,  String? baseSiteCode,  DateTime? firstUseDate,  String? geom,  String? uuidBaseSite,  int? altitudeMin,  int? altitudeMax,  int? idInventor,  int? idDigitiser,  DateTime? metaCreateDate,  DateTime? metaUpdateDate,  Map<String, dynamic>? data,  bool? isLocal,  int? serverSiteId)  $default,) {final _that = this;
switch (_that) {
case _BaseSite():
return $default(_that.idBaseSite,_that.baseSiteName,_that.baseSiteDescription,_that.baseSiteCode,_that.firstUseDate,_that.geom,_that.uuidBaseSite,_that.altitudeMin,_that.altitudeMax,_that.idInventor,_that.idDigitiser,_that.metaCreateDate,_that.metaUpdateDate,_that.data,_that.isLocal,_that.serverSiteId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int idBaseSite,  String? baseSiteName,  String? baseSiteDescription,  String? baseSiteCode,  DateTime? firstUseDate,  String? geom,  String? uuidBaseSite,  int? altitudeMin,  int? altitudeMax,  int? idInventor,  int? idDigitiser,  DateTime? metaCreateDate,  DateTime? metaUpdateDate,  Map<String, dynamic>? data,  bool? isLocal,  int? serverSiteId)?  $default,) {final _that = this;
switch (_that) {
case _BaseSite() when $default != null:
return $default(_that.idBaseSite,_that.baseSiteName,_that.baseSiteDescription,_that.baseSiteCode,_that.firstUseDate,_that.geom,_that.uuidBaseSite,_that.altitudeMin,_that.altitudeMax,_that.idInventor,_that.idDigitiser,_that.metaCreateDate,_that.metaUpdateDate,_that.data,_that.isLocal,_that.serverSiteId);case _:
  return null;

}
}

}

/// @nodoc


class _BaseSite implements BaseSite {
  const _BaseSite({required this.idBaseSite, this.baseSiteName, this.baseSiteDescription, this.baseSiteCode, this.firstUseDate, this.geom, this.uuidBaseSite, this.altitudeMin, this.altitudeMax, this.idInventor, this.idDigitiser, this.metaCreateDate, this.metaUpdateDate, final  Map<String, dynamic>? data, this.isLocal, this.serverSiteId}): _data = data;
  

@override final  int idBaseSite;
@override final  String? baseSiteName;
@override final  String? baseSiteDescription;
@override final  String? baseSiteCode;
@override final  DateTime? firstUseDate;
@override final  String? geom;
// GeoJSON representation
@override final  String? uuidBaseSite;
@override final  int? altitudeMin;
@override final  int? altitudeMax;
@override final  int? idInventor;
@override final  int? idDigitiser;
@override final  DateTime? metaCreateDate;
@override final  DateTime? metaUpdateDate;
 final  Map<String, dynamic>? _data;
@override Map<String, dynamic>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  bool? isLocal;
// true si créé localement, false si récupéré depuis l'API
@override final  int? serverSiteId;

/// Create a copy of BaseSite
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BaseSiteCopyWith<_BaseSite> get copyWith => __$BaseSiteCopyWithImpl<_BaseSite>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BaseSite&&(identical(other.idBaseSite, idBaseSite) || other.idBaseSite == idBaseSite)&&(identical(other.baseSiteName, baseSiteName) || other.baseSiteName == baseSiteName)&&(identical(other.baseSiteDescription, baseSiteDescription) || other.baseSiteDescription == baseSiteDescription)&&(identical(other.baseSiteCode, baseSiteCode) || other.baseSiteCode == baseSiteCode)&&(identical(other.firstUseDate, firstUseDate) || other.firstUseDate == firstUseDate)&&(identical(other.geom, geom) || other.geom == geom)&&(identical(other.uuidBaseSite, uuidBaseSite) || other.uuidBaseSite == uuidBaseSite)&&(identical(other.altitudeMin, altitudeMin) || other.altitudeMin == altitudeMin)&&(identical(other.altitudeMax, altitudeMax) || other.altitudeMax == altitudeMax)&&(identical(other.idInventor, idInventor) || other.idInventor == idInventor)&&(identical(other.idDigitiser, idDigitiser) || other.idDigitiser == idDigitiser)&&(identical(other.metaCreateDate, metaCreateDate) || other.metaCreateDate == metaCreateDate)&&(identical(other.metaUpdateDate, metaUpdateDate) || other.metaUpdateDate == metaUpdateDate)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.isLocal, isLocal) || other.isLocal == isLocal)&&(identical(other.serverSiteId, serverSiteId) || other.serverSiteId == serverSiteId));
}


@override
int get hashCode => Object.hash(runtimeType,idBaseSite,baseSiteName,baseSiteDescription,baseSiteCode,firstUseDate,geom,uuidBaseSite,altitudeMin,altitudeMax,idInventor,idDigitiser,metaCreateDate,metaUpdateDate,const DeepCollectionEquality().hash(_data),isLocal,serverSiteId);

@override
String toString() {
  return 'BaseSite(idBaseSite: $idBaseSite, baseSiteName: $baseSiteName, baseSiteDescription: $baseSiteDescription, baseSiteCode: $baseSiteCode, firstUseDate: $firstUseDate, geom: $geom, uuidBaseSite: $uuidBaseSite, altitudeMin: $altitudeMin, altitudeMax: $altitudeMax, idInventor: $idInventor, idDigitiser: $idDigitiser, metaCreateDate: $metaCreateDate, metaUpdateDate: $metaUpdateDate, data: $data, isLocal: $isLocal, serverSiteId: $serverSiteId)';
}


}

/// @nodoc
abstract mixin class _$BaseSiteCopyWith<$Res> implements $BaseSiteCopyWith<$Res> {
  factory _$BaseSiteCopyWith(_BaseSite value, $Res Function(_BaseSite) _then) = __$BaseSiteCopyWithImpl;
@override @useResult
$Res call({
 int idBaseSite, String? baseSiteName, String? baseSiteDescription, String? baseSiteCode, DateTime? firstUseDate, String? geom, String? uuidBaseSite, int? altitudeMin, int? altitudeMax, int? idInventor, int? idDigitiser, DateTime? metaCreateDate, DateTime? metaUpdateDate, Map<String, dynamic>? data, bool? isLocal, int? serverSiteId
});




}
/// @nodoc
class __$BaseSiteCopyWithImpl<$Res>
    implements _$BaseSiteCopyWith<$Res> {
  __$BaseSiteCopyWithImpl(this._self, this._then);

  final _BaseSite _self;
  final $Res Function(_BaseSite) _then;

/// Create a copy of BaseSite
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idBaseSite = null,Object? baseSiteName = freezed,Object? baseSiteDescription = freezed,Object? baseSiteCode = freezed,Object? firstUseDate = freezed,Object? geom = freezed,Object? uuidBaseSite = freezed,Object? altitudeMin = freezed,Object? altitudeMax = freezed,Object? idInventor = freezed,Object? idDigitiser = freezed,Object? metaCreateDate = freezed,Object? metaUpdateDate = freezed,Object? data = freezed,Object? isLocal = freezed,Object? serverSiteId = freezed,}) {
  return _then(_BaseSite(
idBaseSite: null == idBaseSite ? _self.idBaseSite : idBaseSite // ignore: cast_nullable_to_non_nullable
as int,baseSiteName: freezed == baseSiteName ? _self.baseSiteName : baseSiteName // ignore: cast_nullable_to_non_nullable
as String?,baseSiteDescription: freezed == baseSiteDescription ? _self.baseSiteDescription : baseSiteDescription // ignore: cast_nullable_to_non_nullable
as String?,baseSiteCode: freezed == baseSiteCode ? _self.baseSiteCode : baseSiteCode // ignore: cast_nullable_to_non_nullable
as String?,firstUseDate: freezed == firstUseDate ? _self.firstUseDate : firstUseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,geom: freezed == geom ? _self.geom : geom // ignore: cast_nullable_to_non_nullable
as String?,uuidBaseSite: freezed == uuidBaseSite ? _self.uuidBaseSite : uuidBaseSite // ignore: cast_nullable_to_non_nullable
as String?,altitudeMin: freezed == altitudeMin ? _self.altitudeMin : altitudeMin // ignore: cast_nullable_to_non_nullable
as int?,altitudeMax: freezed == altitudeMax ? _self.altitudeMax : altitudeMax // ignore: cast_nullable_to_non_nullable
as int?,idInventor: freezed == idInventor ? _self.idInventor : idInventor // ignore: cast_nullable_to_non_nullable
as int?,idDigitiser: freezed == idDigitiser ? _self.idDigitiser : idDigitiser // ignore: cast_nullable_to_non_nullable
as int?,metaCreateDate: freezed == metaCreateDate ? _self.metaCreateDate : metaCreateDate // ignore: cast_nullable_to_non_nullable
as DateTime?,metaUpdateDate: freezed == metaUpdateDate ? _self.metaUpdateDate : metaUpdateDate // ignore: cast_nullable_to_non_nullable
as DateTime?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,isLocal: freezed == isLocal ? _self.isLocal : isLocal // ignore: cast_nullable_to_non_nullable
as bool?,serverSiteId: freezed == serverSiteId ? _self.serverSiteId : serverSiteId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
