// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'observation_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ObservationDetail {

/// Identifiant unique du détail d'observation
 int? get idObservationDetail;/// Identifiant de l'observation parente
 int? get idObservation;/// Identifiant du module
 int? get idModule;/// UUID unique du détail d'observation
 String? get uuidObservationDetail;/// Données sous forme de Map
 Map<String, dynamic> get data;
/// Create a copy of ObservationDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ObservationDetailCopyWith<ObservationDetail> get copyWith => _$ObservationDetailCopyWithImpl<ObservationDetail>(this as ObservationDetail, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ObservationDetail&&(identical(other.idObservationDetail, idObservationDetail) || other.idObservationDetail == idObservationDetail)&&(identical(other.idObservation, idObservation) || other.idObservation == idObservation)&&(identical(other.idModule, idModule) || other.idModule == idModule)&&(identical(other.uuidObservationDetail, uuidObservationDetail) || other.uuidObservationDetail == uuidObservationDetail)&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,idObservationDetail,idObservation,idModule,uuidObservationDetail,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'ObservationDetail(idObservationDetail: $idObservationDetail, idObservation: $idObservation, idModule: $idModule, uuidObservationDetail: $uuidObservationDetail, data: $data)';
}


}

/// @nodoc
abstract mixin class $ObservationDetailCopyWith<$Res>  {
  factory $ObservationDetailCopyWith(ObservationDetail value, $Res Function(ObservationDetail) _then) = _$ObservationDetailCopyWithImpl;
@useResult
$Res call({
 int? idObservationDetail, int? idObservation, int? idModule, String? uuidObservationDetail, Map<String, dynamic> data
});




}
/// @nodoc
class _$ObservationDetailCopyWithImpl<$Res>
    implements $ObservationDetailCopyWith<$Res> {
  _$ObservationDetailCopyWithImpl(this._self, this._then);

  final ObservationDetail _self;
  final $Res Function(ObservationDetail) _then;

/// Create a copy of ObservationDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idObservationDetail = freezed,Object? idObservation = freezed,Object? idModule = freezed,Object? uuidObservationDetail = freezed,Object? data = null,}) {
  return _then(_self.copyWith(
idObservationDetail: freezed == idObservationDetail ? _self.idObservationDetail : idObservationDetail // ignore: cast_nullable_to_non_nullable
as int?,idObservation: freezed == idObservation ? _self.idObservation : idObservation // ignore: cast_nullable_to_non_nullable
as int?,idModule: freezed == idModule ? _self.idModule : idModule // ignore: cast_nullable_to_non_nullable
as int?,uuidObservationDetail: freezed == uuidObservationDetail ? _self.uuidObservationDetail : uuidObservationDetail // ignore: cast_nullable_to_non_nullable
as String?,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [ObservationDetail].
extension ObservationDetailPatterns on ObservationDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ObservationDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ObservationDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ObservationDetail value)  $default,){
final _that = this;
switch (_that) {
case _ObservationDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ObservationDetail value)?  $default,){
final _that = this;
switch (_that) {
case _ObservationDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? idObservationDetail,  int? idObservation,  int? idModule,  String? uuidObservationDetail,  Map<String, dynamic> data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ObservationDetail() when $default != null:
return $default(_that.idObservationDetail,_that.idObservation,_that.idModule,_that.uuidObservationDetail,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? idObservationDetail,  int? idObservation,  int? idModule,  String? uuidObservationDetail,  Map<String, dynamic> data)  $default,) {final _that = this;
switch (_that) {
case _ObservationDetail():
return $default(_that.idObservationDetail,_that.idObservation,_that.idModule,_that.uuidObservationDetail,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? idObservationDetail,  int? idObservation,  int? idModule,  String? uuidObservationDetail,  Map<String, dynamic> data)?  $default,) {final _that = this;
switch (_that) {
case _ObservationDetail() when $default != null:
return $default(_that.idObservationDetail,_that.idObservation,_that.idModule,_that.uuidObservationDetail,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _ObservationDetail implements ObservationDetail {
  const _ObservationDetail({this.idObservationDetail, this.idObservation, this.idModule, this.uuidObservationDetail, final  Map<String, dynamic> data = const {}}): _data = data;
  

/// Identifiant unique du détail d'observation
@override final  int? idObservationDetail;
/// Identifiant de l'observation parente
@override final  int? idObservation;
/// Identifiant du module
@override final  int? idModule;
/// UUID unique du détail d'observation
@override final  String? uuidObservationDetail;
/// Données sous forme de Map
 final  Map<String, dynamic> _data;
/// Données sous forme de Map
@override@JsonKey() Map<String, dynamic> get data {
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_data);
}


/// Create a copy of ObservationDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ObservationDetailCopyWith<_ObservationDetail> get copyWith => __$ObservationDetailCopyWithImpl<_ObservationDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ObservationDetail&&(identical(other.idObservationDetail, idObservationDetail) || other.idObservationDetail == idObservationDetail)&&(identical(other.idObservation, idObservation) || other.idObservation == idObservation)&&(identical(other.idModule, idModule) || other.idModule == idModule)&&(identical(other.uuidObservationDetail, uuidObservationDetail) || other.uuidObservationDetail == uuidObservationDetail)&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,idObservationDetail,idObservation,idModule,uuidObservationDetail,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'ObservationDetail(idObservationDetail: $idObservationDetail, idObservation: $idObservation, idModule: $idModule, uuidObservationDetail: $uuidObservationDetail, data: $data)';
}


}

/// @nodoc
abstract mixin class _$ObservationDetailCopyWith<$Res> implements $ObservationDetailCopyWith<$Res> {
  factory _$ObservationDetailCopyWith(_ObservationDetail value, $Res Function(_ObservationDetail) _then) = __$ObservationDetailCopyWithImpl;
@override @useResult
$Res call({
 int? idObservationDetail, int? idObservation, int? idModule, String? uuidObservationDetail, Map<String, dynamic> data
});




}
/// @nodoc
class __$ObservationDetailCopyWithImpl<$Res>
    implements _$ObservationDetailCopyWith<$Res> {
  __$ObservationDetailCopyWithImpl(this._self, this._then);

  final _ObservationDetail _self;
  final $Res Function(_ObservationDetail) _then;

/// Create a copy of ObservationDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idObservationDetail = freezed,Object? idObservation = freezed,Object? idModule = freezed,Object? uuidObservationDetail = freezed,Object? data = null,}) {
  return _then(_ObservationDetail(
idObservationDetail: freezed == idObservationDetail ? _self.idObservationDetail : idObservationDetail // ignore: cast_nullable_to_non_nullable
as int?,idObservation: freezed == idObservation ? _self.idObservation : idObservation // ignore: cast_nullable_to_non_nullable
as int?,idModule: freezed == idModule ? _self.idModule : idModule // ignore: cast_nullable_to_non_nullable
as int?,uuidObservationDetail: freezed == uuidObservationDetail ? _self.uuidObservationDetail : uuidObservationDetail // ignore: cast_nullable_to_non_nullable
as String?,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
