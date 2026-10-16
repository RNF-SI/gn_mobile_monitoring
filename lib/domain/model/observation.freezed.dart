// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'observation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Observation {

 int get idObservation; int? get idBaseVisit; int? get idDigitiser; int? get cdNom; String? get comments; String? get uuidObservation; int? get serverObservationId; String? get metaCreateDate; String? get metaUpdateDate; Map<String, dynamic>? get data;
/// Create a copy of Observation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ObservationCopyWith<Observation> get copyWith => _$ObservationCopyWithImpl<Observation>(this as Observation, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Observation&&(identical(other.idObservation, idObservation) || other.idObservation == idObservation)&&(identical(other.idBaseVisit, idBaseVisit) || other.idBaseVisit == idBaseVisit)&&(identical(other.idDigitiser, idDigitiser) || other.idDigitiser == idDigitiser)&&(identical(other.cdNom, cdNom) || other.cdNom == cdNom)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.uuidObservation, uuidObservation) || other.uuidObservation == uuidObservation)&&(identical(other.serverObservationId, serverObservationId) || other.serverObservationId == serverObservationId)&&(identical(other.metaCreateDate, metaCreateDate) || other.metaCreateDate == metaCreateDate)&&(identical(other.metaUpdateDate, metaUpdateDate) || other.metaUpdateDate == metaUpdateDate)&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,idObservation,idBaseVisit,idDigitiser,cdNom,comments,uuidObservation,serverObservationId,metaCreateDate,metaUpdateDate,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'Observation(idObservation: $idObservation, idBaseVisit: $idBaseVisit, idDigitiser: $idDigitiser, cdNom: $cdNom, comments: $comments, uuidObservation: $uuidObservation, serverObservationId: $serverObservationId, metaCreateDate: $metaCreateDate, metaUpdateDate: $metaUpdateDate, data: $data)';
}


}

/// @nodoc
abstract mixin class $ObservationCopyWith<$Res>  {
  factory $ObservationCopyWith(Observation value, $Res Function(Observation) _then) = _$ObservationCopyWithImpl;
@useResult
$Res call({
 int idObservation, int? idBaseVisit, int? idDigitiser, int? cdNom, String? comments, String? uuidObservation, int? serverObservationId, String? metaCreateDate, String? metaUpdateDate, Map<String, dynamic>? data
});




}
/// @nodoc
class _$ObservationCopyWithImpl<$Res>
    implements $ObservationCopyWith<$Res> {
  _$ObservationCopyWithImpl(this._self, this._then);

  final Observation _self;
  final $Res Function(Observation) _then;

/// Create a copy of Observation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idObservation = null,Object? idBaseVisit = freezed,Object? idDigitiser = freezed,Object? cdNom = freezed,Object? comments = freezed,Object? uuidObservation = freezed,Object? serverObservationId = freezed,Object? metaCreateDate = freezed,Object? metaUpdateDate = freezed,Object? data = freezed,}) {
  return _then(_self.copyWith(
idObservation: null == idObservation ? _self.idObservation : idObservation // ignore: cast_nullable_to_non_nullable
as int,idBaseVisit: freezed == idBaseVisit ? _self.idBaseVisit : idBaseVisit // ignore: cast_nullable_to_non_nullable
as int?,idDigitiser: freezed == idDigitiser ? _self.idDigitiser : idDigitiser // ignore: cast_nullable_to_non_nullable
as int?,cdNom: freezed == cdNom ? _self.cdNom : cdNom // ignore: cast_nullable_to_non_nullable
as int?,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String?,uuidObservation: freezed == uuidObservation ? _self.uuidObservation : uuidObservation // ignore: cast_nullable_to_non_nullable
as String?,serverObservationId: freezed == serverObservationId ? _self.serverObservationId : serverObservationId // ignore: cast_nullable_to_non_nullable
as int?,metaCreateDate: freezed == metaCreateDate ? _self.metaCreateDate : metaCreateDate // ignore: cast_nullable_to_non_nullable
as String?,metaUpdateDate: freezed == metaUpdateDate ? _self.metaUpdateDate : metaUpdateDate // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [Observation].
extension ObservationPatterns on Observation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Observation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Observation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Observation value)  $default,){
final _that = this;
switch (_that) {
case _Observation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Observation value)?  $default,){
final _that = this;
switch (_that) {
case _Observation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int idObservation,  int? idBaseVisit,  int? idDigitiser,  int? cdNom,  String? comments,  String? uuidObservation,  int? serverObservationId,  String? metaCreateDate,  String? metaUpdateDate,  Map<String, dynamic>? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Observation() when $default != null:
return $default(_that.idObservation,_that.idBaseVisit,_that.idDigitiser,_that.cdNom,_that.comments,_that.uuidObservation,_that.serverObservationId,_that.metaCreateDate,_that.metaUpdateDate,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int idObservation,  int? idBaseVisit,  int? idDigitiser,  int? cdNom,  String? comments,  String? uuidObservation,  int? serverObservationId,  String? metaCreateDate,  String? metaUpdateDate,  Map<String, dynamic>? data)  $default,) {final _that = this;
switch (_that) {
case _Observation():
return $default(_that.idObservation,_that.idBaseVisit,_that.idDigitiser,_that.cdNom,_that.comments,_that.uuidObservation,_that.serverObservationId,_that.metaCreateDate,_that.metaUpdateDate,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int idObservation,  int? idBaseVisit,  int? idDigitiser,  int? cdNom,  String? comments,  String? uuidObservation,  int? serverObservationId,  String? metaCreateDate,  String? metaUpdateDate,  Map<String, dynamic>? data)?  $default,) {final _that = this;
switch (_that) {
case _Observation() when $default != null:
return $default(_that.idObservation,_that.idBaseVisit,_that.idDigitiser,_that.cdNom,_that.comments,_that.uuidObservation,_that.serverObservationId,_that.metaCreateDate,_that.metaUpdateDate,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _Observation implements Observation {
  const _Observation({required this.idObservation, this.idBaseVisit, this.idDigitiser, this.cdNom, this.comments, this.uuidObservation, this.serverObservationId, this.metaCreateDate, this.metaUpdateDate, final  Map<String, dynamic>? data}): _data = data;
  

@override final  int idObservation;
@override final  int? idBaseVisit;
@override final  int? idDigitiser;
@override final  int? cdNom;
@override final  String? comments;
@override final  String? uuidObservation;
@override final  int? serverObservationId;
@override final  String? metaCreateDate;
@override final  String? metaUpdateDate;
 final  Map<String, dynamic>? _data;
@override Map<String, dynamic>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of Observation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ObservationCopyWith<_Observation> get copyWith => __$ObservationCopyWithImpl<_Observation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Observation&&(identical(other.idObservation, idObservation) || other.idObservation == idObservation)&&(identical(other.idBaseVisit, idBaseVisit) || other.idBaseVisit == idBaseVisit)&&(identical(other.idDigitiser, idDigitiser) || other.idDigitiser == idDigitiser)&&(identical(other.cdNom, cdNom) || other.cdNom == cdNom)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.uuidObservation, uuidObservation) || other.uuidObservation == uuidObservation)&&(identical(other.serverObservationId, serverObservationId) || other.serverObservationId == serverObservationId)&&(identical(other.metaCreateDate, metaCreateDate) || other.metaCreateDate == metaCreateDate)&&(identical(other.metaUpdateDate, metaUpdateDate) || other.metaUpdateDate == metaUpdateDate)&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,idObservation,idBaseVisit,idDigitiser,cdNom,comments,uuidObservation,serverObservationId,metaCreateDate,metaUpdateDate,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'Observation(idObservation: $idObservation, idBaseVisit: $idBaseVisit, idDigitiser: $idDigitiser, cdNom: $cdNom, comments: $comments, uuidObservation: $uuidObservation, serverObservationId: $serverObservationId, metaCreateDate: $metaCreateDate, metaUpdateDate: $metaUpdateDate, data: $data)';
}


}

/// @nodoc
abstract mixin class _$ObservationCopyWith<$Res> implements $ObservationCopyWith<$Res> {
  factory _$ObservationCopyWith(_Observation value, $Res Function(_Observation) _then) = __$ObservationCopyWithImpl;
@override @useResult
$Res call({
 int idObservation, int? idBaseVisit, int? idDigitiser, int? cdNom, String? comments, String? uuidObservation, int? serverObservationId, String? metaCreateDate, String? metaUpdateDate, Map<String, dynamic>? data
});




}
/// @nodoc
class __$ObservationCopyWithImpl<$Res>
    implements _$ObservationCopyWith<$Res> {
  __$ObservationCopyWithImpl(this._self, this._then);

  final _Observation _self;
  final $Res Function(_Observation) _then;

/// Create a copy of Observation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idObservation = null,Object? idBaseVisit = freezed,Object? idDigitiser = freezed,Object? cdNom = freezed,Object? comments = freezed,Object? uuidObservation = freezed,Object? serverObservationId = freezed,Object? metaCreateDate = freezed,Object? metaUpdateDate = freezed,Object? data = freezed,}) {
  return _then(_Observation(
idObservation: null == idObservation ? _self.idObservation : idObservation // ignore: cast_nullable_to_non_nullable
as int,idBaseVisit: freezed == idBaseVisit ? _self.idBaseVisit : idBaseVisit // ignore: cast_nullable_to_non_nullable
as int?,idDigitiser: freezed == idDigitiser ? _self.idDigitiser : idDigitiser // ignore: cast_nullable_to_non_nullable
as int?,cdNom: freezed == cdNom ? _self.cdNom : cdNom // ignore: cast_nullable_to_non_nullable
as int?,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String?,uuidObservation: freezed == uuidObservation ? _self.uuidObservation : uuidObservation // ignore: cast_nullable_to_non_nullable
as String?,serverObservationId: freezed == serverObservationId ? _self.serverObservationId : serverObservationId // ignore: cast_nullable_to_non_nullable
as int?,metaCreateDate: freezed == metaCreateDate ? _self.metaCreateDate : metaCreateDate // ignore: cast_nullable_to_non_nullable
as String?,metaUpdateDate: freezed == metaUpdateDate ? _self.metaUpdateDate : metaUpdateDate // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
