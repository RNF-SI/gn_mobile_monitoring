// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'base_visit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BaseVisit {

 int get idBaseVisit; int? get idBaseSite; int get idDataset; int get idModule; int? get idDigitiser; String get visitDateMin; String? get visitDateMax; int? get idNomenclatureTechCollectCampanule; int? get idNomenclatureGrpTyp; String? get comments; String? get uuidBaseVisit; String? get metaCreateDate; String? get metaUpdateDate; List<int>? get observers;// Liste des ID des observateurs
 Map<String, dynamic>? get data;
/// Create a copy of BaseVisit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BaseVisitCopyWith<BaseVisit> get copyWith => _$BaseVisitCopyWithImpl<BaseVisit>(this as BaseVisit, _$identity);

  /// Serializes this BaseVisit to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BaseVisit&&(identical(other.idBaseVisit, idBaseVisit) || other.idBaseVisit == idBaseVisit)&&(identical(other.idBaseSite, idBaseSite) || other.idBaseSite == idBaseSite)&&(identical(other.idDataset, idDataset) || other.idDataset == idDataset)&&(identical(other.idModule, idModule) || other.idModule == idModule)&&(identical(other.idDigitiser, idDigitiser) || other.idDigitiser == idDigitiser)&&(identical(other.visitDateMin, visitDateMin) || other.visitDateMin == visitDateMin)&&(identical(other.visitDateMax, visitDateMax) || other.visitDateMax == visitDateMax)&&(identical(other.idNomenclatureTechCollectCampanule, idNomenclatureTechCollectCampanule) || other.idNomenclatureTechCollectCampanule == idNomenclatureTechCollectCampanule)&&(identical(other.idNomenclatureGrpTyp, idNomenclatureGrpTyp) || other.idNomenclatureGrpTyp == idNomenclatureGrpTyp)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.uuidBaseVisit, uuidBaseVisit) || other.uuidBaseVisit == uuidBaseVisit)&&(identical(other.metaCreateDate, metaCreateDate) || other.metaCreateDate == metaCreateDate)&&(identical(other.metaUpdateDate, metaUpdateDate) || other.metaUpdateDate == metaUpdateDate)&&const DeepCollectionEquality().equals(other.observers, observers)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idBaseVisit,idBaseSite,idDataset,idModule,idDigitiser,visitDateMin,visitDateMax,idNomenclatureTechCollectCampanule,idNomenclatureGrpTyp,comments,uuidBaseVisit,metaCreateDate,metaUpdateDate,const DeepCollectionEquality().hash(observers),const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'BaseVisit(idBaseVisit: $idBaseVisit, idBaseSite: $idBaseSite, idDataset: $idDataset, idModule: $idModule, idDigitiser: $idDigitiser, visitDateMin: $visitDateMin, visitDateMax: $visitDateMax, idNomenclatureTechCollectCampanule: $idNomenclatureTechCollectCampanule, idNomenclatureGrpTyp: $idNomenclatureGrpTyp, comments: $comments, uuidBaseVisit: $uuidBaseVisit, metaCreateDate: $metaCreateDate, metaUpdateDate: $metaUpdateDate, observers: $observers, data: $data)';
}


}

/// @nodoc
abstract mixin class $BaseVisitCopyWith<$Res>  {
  factory $BaseVisitCopyWith(BaseVisit value, $Res Function(BaseVisit) _then) = _$BaseVisitCopyWithImpl;
@useResult
$Res call({
 int idBaseVisit, int? idBaseSite, int idDataset, int idModule, int? idDigitiser, String visitDateMin, String? visitDateMax, int? idNomenclatureTechCollectCampanule, int? idNomenclatureGrpTyp, String? comments, String? uuidBaseVisit, String? metaCreateDate, String? metaUpdateDate, List<int>? observers, Map<String, dynamic>? data
});




}
/// @nodoc
class _$BaseVisitCopyWithImpl<$Res>
    implements $BaseVisitCopyWith<$Res> {
  _$BaseVisitCopyWithImpl(this._self, this._then);

  final BaseVisit _self;
  final $Res Function(BaseVisit) _then;

/// Create a copy of BaseVisit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idBaseVisit = null,Object? idBaseSite = freezed,Object? idDataset = null,Object? idModule = null,Object? idDigitiser = freezed,Object? visitDateMin = null,Object? visitDateMax = freezed,Object? idNomenclatureTechCollectCampanule = freezed,Object? idNomenclatureGrpTyp = freezed,Object? comments = freezed,Object? uuidBaseVisit = freezed,Object? metaCreateDate = freezed,Object? metaUpdateDate = freezed,Object? observers = freezed,Object? data = freezed,}) {
  return _then(_self.copyWith(
idBaseVisit: null == idBaseVisit ? _self.idBaseVisit : idBaseVisit // ignore: cast_nullable_to_non_nullable
as int,idBaseSite: freezed == idBaseSite ? _self.idBaseSite : idBaseSite // ignore: cast_nullable_to_non_nullable
as int?,idDataset: null == idDataset ? _self.idDataset : idDataset // ignore: cast_nullable_to_non_nullable
as int,idModule: null == idModule ? _self.idModule : idModule // ignore: cast_nullable_to_non_nullable
as int,idDigitiser: freezed == idDigitiser ? _self.idDigitiser : idDigitiser // ignore: cast_nullable_to_non_nullable
as int?,visitDateMin: null == visitDateMin ? _self.visitDateMin : visitDateMin // ignore: cast_nullable_to_non_nullable
as String,visitDateMax: freezed == visitDateMax ? _self.visitDateMax : visitDateMax // ignore: cast_nullable_to_non_nullable
as String?,idNomenclatureTechCollectCampanule: freezed == idNomenclatureTechCollectCampanule ? _self.idNomenclatureTechCollectCampanule : idNomenclatureTechCollectCampanule // ignore: cast_nullable_to_non_nullable
as int?,idNomenclatureGrpTyp: freezed == idNomenclatureGrpTyp ? _self.idNomenclatureGrpTyp : idNomenclatureGrpTyp // ignore: cast_nullable_to_non_nullable
as int?,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String?,uuidBaseVisit: freezed == uuidBaseVisit ? _self.uuidBaseVisit : uuidBaseVisit // ignore: cast_nullable_to_non_nullable
as String?,metaCreateDate: freezed == metaCreateDate ? _self.metaCreateDate : metaCreateDate // ignore: cast_nullable_to_non_nullable
as String?,metaUpdateDate: freezed == metaUpdateDate ? _self.metaUpdateDate : metaUpdateDate // ignore: cast_nullable_to_non_nullable
as String?,observers: freezed == observers ? _self.observers : observers // ignore: cast_nullable_to_non_nullable
as List<int>?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [BaseVisit].
extension BaseVisitPatterns on BaseVisit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BaseVisit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BaseVisit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BaseVisit value)  $default,){
final _that = this;
switch (_that) {
case _BaseVisit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BaseVisit value)?  $default,){
final _that = this;
switch (_that) {
case _BaseVisit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int idBaseVisit,  int? idBaseSite,  int idDataset,  int idModule,  int? idDigitiser,  String visitDateMin,  String? visitDateMax,  int? idNomenclatureTechCollectCampanule,  int? idNomenclatureGrpTyp,  String? comments,  String? uuidBaseVisit,  String? metaCreateDate,  String? metaUpdateDate,  List<int>? observers,  Map<String, dynamic>? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BaseVisit() when $default != null:
return $default(_that.idBaseVisit,_that.idBaseSite,_that.idDataset,_that.idModule,_that.idDigitiser,_that.visitDateMin,_that.visitDateMax,_that.idNomenclatureTechCollectCampanule,_that.idNomenclatureGrpTyp,_that.comments,_that.uuidBaseVisit,_that.metaCreateDate,_that.metaUpdateDate,_that.observers,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int idBaseVisit,  int? idBaseSite,  int idDataset,  int idModule,  int? idDigitiser,  String visitDateMin,  String? visitDateMax,  int? idNomenclatureTechCollectCampanule,  int? idNomenclatureGrpTyp,  String? comments,  String? uuidBaseVisit,  String? metaCreateDate,  String? metaUpdateDate,  List<int>? observers,  Map<String, dynamic>? data)  $default,) {final _that = this;
switch (_that) {
case _BaseVisit():
return $default(_that.idBaseVisit,_that.idBaseSite,_that.idDataset,_that.idModule,_that.idDigitiser,_that.visitDateMin,_that.visitDateMax,_that.idNomenclatureTechCollectCampanule,_that.idNomenclatureGrpTyp,_that.comments,_that.uuidBaseVisit,_that.metaCreateDate,_that.metaUpdateDate,_that.observers,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int idBaseVisit,  int? idBaseSite,  int idDataset,  int idModule,  int? idDigitiser,  String visitDateMin,  String? visitDateMax,  int? idNomenclatureTechCollectCampanule,  int? idNomenclatureGrpTyp,  String? comments,  String? uuidBaseVisit,  String? metaCreateDate,  String? metaUpdateDate,  List<int>? observers,  Map<String, dynamic>? data)?  $default,) {final _that = this;
switch (_that) {
case _BaseVisit() when $default != null:
return $default(_that.idBaseVisit,_that.idBaseSite,_that.idDataset,_that.idModule,_that.idDigitiser,_that.visitDateMin,_that.visitDateMax,_that.idNomenclatureTechCollectCampanule,_that.idNomenclatureGrpTyp,_that.comments,_that.uuidBaseVisit,_that.metaCreateDate,_that.metaUpdateDate,_that.observers,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BaseVisit implements BaseVisit {
  const _BaseVisit({required this.idBaseVisit, this.idBaseSite, required this.idDataset, required this.idModule, this.idDigitiser, required this.visitDateMin, this.visitDateMax, this.idNomenclatureTechCollectCampanule, this.idNomenclatureGrpTyp, this.comments, this.uuidBaseVisit, this.metaCreateDate, this.metaUpdateDate, final  List<int>? observers, final  Map<String, dynamic>? data}): _observers = observers,_data = data;
  factory _BaseVisit.fromJson(Map<String, dynamic> json) => _$BaseVisitFromJson(json);

@override final  int idBaseVisit;
@override final  int? idBaseSite;
@override final  int idDataset;
@override final  int idModule;
@override final  int? idDigitiser;
@override final  String visitDateMin;
@override final  String? visitDateMax;
@override final  int? idNomenclatureTechCollectCampanule;
@override final  int? idNomenclatureGrpTyp;
@override final  String? comments;
@override final  String? uuidBaseVisit;
@override final  String? metaCreateDate;
@override final  String? metaUpdateDate;
 final  List<int>? _observers;
@override List<int>? get observers {
  final value = _observers;
  if (value == null) return null;
  if (_observers is EqualUnmodifiableListView) return _observers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

// Liste des ID des observateurs
 final  Map<String, dynamic>? _data;
// Liste des ID des observateurs
@override Map<String, dynamic>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of BaseVisit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BaseVisitCopyWith<_BaseVisit> get copyWith => __$BaseVisitCopyWithImpl<_BaseVisit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BaseVisitToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BaseVisit&&(identical(other.idBaseVisit, idBaseVisit) || other.idBaseVisit == idBaseVisit)&&(identical(other.idBaseSite, idBaseSite) || other.idBaseSite == idBaseSite)&&(identical(other.idDataset, idDataset) || other.idDataset == idDataset)&&(identical(other.idModule, idModule) || other.idModule == idModule)&&(identical(other.idDigitiser, idDigitiser) || other.idDigitiser == idDigitiser)&&(identical(other.visitDateMin, visitDateMin) || other.visitDateMin == visitDateMin)&&(identical(other.visitDateMax, visitDateMax) || other.visitDateMax == visitDateMax)&&(identical(other.idNomenclatureTechCollectCampanule, idNomenclatureTechCollectCampanule) || other.idNomenclatureTechCollectCampanule == idNomenclatureTechCollectCampanule)&&(identical(other.idNomenclatureGrpTyp, idNomenclatureGrpTyp) || other.idNomenclatureGrpTyp == idNomenclatureGrpTyp)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.uuidBaseVisit, uuidBaseVisit) || other.uuidBaseVisit == uuidBaseVisit)&&(identical(other.metaCreateDate, metaCreateDate) || other.metaCreateDate == metaCreateDate)&&(identical(other.metaUpdateDate, metaUpdateDate) || other.metaUpdateDate == metaUpdateDate)&&const DeepCollectionEquality().equals(other._observers, _observers)&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,idBaseVisit,idBaseSite,idDataset,idModule,idDigitiser,visitDateMin,visitDateMax,idNomenclatureTechCollectCampanule,idNomenclatureGrpTyp,comments,uuidBaseVisit,metaCreateDate,metaUpdateDate,const DeepCollectionEquality().hash(_observers),const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'BaseVisit(idBaseVisit: $idBaseVisit, idBaseSite: $idBaseSite, idDataset: $idDataset, idModule: $idModule, idDigitiser: $idDigitiser, visitDateMin: $visitDateMin, visitDateMax: $visitDateMax, idNomenclatureTechCollectCampanule: $idNomenclatureTechCollectCampanule, idNomenclatureGrpTyp: $idNomenclatureGrpTyp, comments: $comments, uuidBaseVisit: $uuidBaseVisit, metaCreateDate: $metaCreateDate, metaUpdateDate: $metaUpdateDate, observers: $observers, data: $data)';
}


}

/// @nodoc
abstract mixin class _$BaseVisitCopyWith<$Res> implements $BaseVisitCopyWith<$Res> {
  factory _$BaseVisitCopyWith(_BaseVisit value, $Res Function(_BaseVisit) _then) = __$BaseVisitCopyWithImpl;
@override @useResult
$Res call({
 int idBaseVisit, int? idBaseSite, int idDataset, int idModule, int? idDigitiser, String visitDateMin, String? visitDateMax, int? idNomenclatureTechCollectCampanule, int? idNomenclatureGrpTyp, String? comments, String? uuidBaseVisit, String? metaCreateDate, String? metaUpdateDate, List<int>? observers, Map<String, dynamic>? data
});




}
/// @nodoc
class __$BaseVisitCopyWithImpl<$Res>
    implements _$BaseVisitCopyWith<$Res> {
  __$BaseVisitCopyWithImpl(this._self, this._then);

  final _BaseVisit _self;
  final $Res Function(_BaseVisit) _then;

/// Create a copy of BaseVisit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idBaseVisit = null,Object? idBaseSite = freezed,Object? idDataset = null,Object? idModule = null,Object? idDigitiser = freezed,Object? visitDateMin = null,Object? visitDateMax = freezed,Object? idNomenclatureTechCollectCampanule = freezed,Object? idNomenclatureGrpTyp = freezed,Object? comments = freezed,Object? uuidBaseVisit = freezed,Object? metaCreateDate = freezed,Object? metaUpdateDate = freezed,Object? observers = freezed,Object? data = freezed,}) {
  return _then(_BaseVisit(
idBaseVisit: null == idBaseVisit ? _self.idBaseVisit : idBaseVisit // ignore: cast_nullable_to_non_nullable
as int,idBaseSite: freezed == idBaseSite ? _self.idBaseSite : idBaseSite // ignore: cast_nullable_to_non_nullable
as int?,idDataset: null == idDataset ? _self.idDataset : idDataset // ignore: cast_nullable_to_non_nullable
as int,idModule: null == idModule ? _self.idModule : idModule // ignore: cast_nullable_to_non_nullable
as int,idDigitiser: freezed == idDigitiser ? _self.idDigitiser : idDigitiser // ignore: cast_nullable_to_non_nullable
as int?,visitDateMin: null == visitDateMin ? _self.visitDateMin : visitDateMin // ignore: cast_nullable_to_non_nullable
as String,visitDateMax: freezed == visitDateMax ? _self.visitDateMax : visitDateMax // ignore: cast_nullable_to_non_nullable
as String?,idNomenclatureTechCollectCampanule: freezed == idNomenclatureTechCollectCampanule ? _self.idNomenclatureTechCollectCampanule : idNomenclatureTechCollectCampanule // ignore: cast_nullable_to_non_nullable
as int?,idNomenclatureGrpTyp: freezed == idNomenclatureGrpTyp ? _self.idNomenclatureGrpTyp : idNomenclatureGrpTyp // ignore: cast_nullable_to_non_nullable
as int?,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String?,uuidBaseVisit: freezed == uuidBaseVisit ? _self.uuidBaseVisit : uuidBaseVisit // ignore: cast_nullable_to_non_nullable
as String?,metaCreateDate: freezed == metaCreateDate ? _self.metaCreateDate : metaCreateDate // ignore: cast_nullable_to_non_nullable
as String?,metaUpdateDate: freezed == metaUpdateDate ? _self.metaUpdateDate : metaUpdateDate // ignore: cast_nullable_to_non_nullable
as String?,observers: freezed == observers ? _self._observers : observers // ignore: cast_nullable_to_non_nullable
as List<int>?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
