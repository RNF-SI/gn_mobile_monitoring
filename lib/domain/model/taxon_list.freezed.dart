// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'taxon_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaxonList {

 int get idListe; String? get codeListe; String get nomListe; String? get descListe; String? get regne; String? get group2Inpn;
/// Create a copy of TaxonList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaxonListCopyWith<TaxonList> get copyWith => _$TaxonListCopyWithImpl<TaxonList>(this as TaxonList, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaxonList&&(identical(other.idListe, idListe) || other.idListe == idListe)&&(identical(other.codeListe, codeListe) || other.codeListe == codeListe)&&(identical(other.nomListe, nomListe) || other.nomListe == nomListe)&&(identical(other.descListe, descListe) || other.descListe == descListe)&&(identical(other.regne, regne) || other.regne == regne)&&(identical(other.group2Inpn, group2Inpn) || other.group2Inpn == group2Inpn));
}


@override
int get hashCode => Object.hash(runtimeType,idListe,codeListe,nomListe,descListe,regne,group2Inpn);

@override
String toString() {
  return 'TaxonList(idListe: $idListe, codeListe: $codeListe, nomListe: $nomListe, descListe: $descListe, regne: $regne, group2Inpn: $group2Inpn)';
}


}

/// @nodoc
abstract mixin class $TaxonListCopyWith<$Res>  {
  factory $TaxonListCopyWith(TaxonList value, $Res Function(TaxonList) _then) = _$TaxonListCopyWithImpl;
@useResult
$Res call({
 int idListe, String? codeListe, String nomListe, String? descListe, String? regne, String? group2Inpn
});




}
/// @nodoc
class _$TaxonListCopyWithImpl<$Res>
    implements $TaxonListCopyWith<$Res> {
  _$TaxonListCopyWithImpl(this._self, this._then);

  final TaxonList _self;
  final $Res Function(TaxonList) _then;

/// Create a copy of TaxonList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idListe = null,Object? codeListe = freezed,Object? nomListe = null,Object? descListe = freezed,Object? regne = freezed,Object? group2Inpn = freezed,}) {
  return _then(_self.copyWith(
idListe: null == idListe ? _self.idListe : idListe // ignore: cast_nullable_to_non_nullable
as int,codeListe: freezed == codeListe ? _self.codeListe : codeListe // ignore: cast_nullable_to_non_nullable
as String?,nomListe: null == nomListe ? _self.nomListe : nomListe // ignore: cast_nullable_to_non_nullable
as String,descListe: freezed == descListe ? _self.descListe : descListe // ignore: cast_nullable_to_non_nullable
as String?,regne: freezed == regne ? _self.regne : regne // ignore: cast_nullable_to_non_nullable
as String?,group2Inpn: freezed == group2Inpn ? _self.group2Inpn : group2Inpn // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TaxonList].
extension TaxonListPatterns on TaxonList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaxonList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaxonList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaxonList value)  $default,){
final _that = this;
switch (_that) {
case _TaxonList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaxonList value)?  $default,){
final _that = this;
switch (_that) {
case _TaxonList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int idListe,  String? codeListe,  String nomListe,  String? descListe,  String? regne,  String? group2Inpn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaxonList() when $default != null:
return $default(_that.idListe,_that.codeListe,_that.nomListe,_that.descListe,_that.regne,_that.group2Inpn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int idListe,  String? codeListe,  String nomListe,  String? descListe,  String? regne,  String? group2Inpn)  $default,) {final _that = this;
switch (_that) {
case _TaxonList():
return $default(_that.idListe,_that.codeListe,_that.nomListe,_that.descListe,_that.regne,_that.group2Inpn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int idListe,  String? codeListe,  String nomListe,  String? descListe,  String? regne,  String? group2Inpn)?  $default,) {final _that = this;
switch (_that) {
case _TaxonList() when $default != null:
return $default(_that.idListe,_that.codeListe,_that.nomListe,_that.descListe,_that.regne,_that.group2Inpn);case _:
  return null;

}
}

}

/// @nodoc


class _TaxonList implements TaxonList {
  const _TaxonList({required this.idListe, this.codeListe, required this.nomListe, this.descListe, this.regne, this.group2Inpn});
  

@override final  int idListe;
@override final  String? codeListe;
@override final  String nomListe;
@override final  String? descListe;
@override final  String? regne;
@override final  String? group2Inpn;

/// Create a copy of TaxonList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaxonListCopyWith<_TaxonList> get copyWith => __$TaxonListCopyWithImpl<_TaxonList>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaxonList&&(identical(other.idListe, idListe) || other.idListe == idListe)&&(identical(other.codeListe, codeListe) || other.codeListe == codeListe)&&(identical(other.nomListe, nomListe) || other.nomListe == nomListe)&&(identical(other.descListe, descListe) || other.descListe == descListe)&&(identical(other.regne, regne) || other.regne == regne)&&(identical(other.group2Inpn, group2Inpn) || other.group2Inpn == group2Inpn));
}


@override
int get hashCode => Object.hash(runtimeType,idListe,codeListe,nomListe,descListe,regne,group2Inpn);

@override
String toString() {
  return 'TaxonList(idListe: $idListe, codeListe: $codeListe, nomListe: $nomListe, descListe: $descListe, regne: $regne, group2Inpn: $group2Inpn)';
}


}

/// @nodoc
abstract mixin class _$TaxonListCopyWith<$Res> implements $TaxonListCopyWith<$Res> {
  factory _$TaxonListCopyWith(_TaxonList value, $Res Function(_TaxonList) _then) = __$TaxonListCopyWithImpl;
@override @useResult
$Res call({
 int idListe, String? codeListe, String nomListe, String? descListe, String? regne, String? group2Inpn
});




}
/// @nodoc
class __$TaxonListCopyWithImpl<$Res>
    implements _$TaxonListCopyWith<$Res> {
  __$TaxonListCopyWithImpl(this._self, this._then);

  final _TaxonList _self;
  final $Res Function(_TaxonList) _then;

/// Create a copy of TaxonList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idListe = null,Object? codeListe = freezed,Object? nomListe = null,Object? descListe = freezed,Object? regne = freezed,Object? group2Inpn = freezed,}) {
  return _then(_TaxonList(
idListe: null == idListe ? _self.idListe : idListe // ignore: cast_nullable_to_non_nullable
as int,codeListe: freezed == codeListe ? _self.codeListe : codeListe // ignore: cast_nullable_to_non_nullable
as String?,nomListe: null == nomListe ? _self.nomListe : nomListe // ignore: cast_nullable_to_non_nullable
as String,descListe: freezed == descListe ? _self.descListe : descListe // ignore: cast_nullable_to_non_nullable
as String?,regne: freezed == regne ? _self.regne : regne // ignore: cast_nullable_to_non_nullable
as String?,group2Inpn: freezed == group2Inpn ? _self.group2Inpn : group2Inpn // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
