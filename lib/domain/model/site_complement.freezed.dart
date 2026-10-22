// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'site_complement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SiteComplement {

 int get idBaseSite; int? get idSitesGroup; String? get data;
/// Create a copy of SiteComplement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SiteComplementCopyWith<SiteComplement> get copyWith => _$SiteComplementCopyWithImpl<SiteComplement>(this as SiteComplement, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SiteComplement&&(identical(other.idBaseSite, idBaseSite) || other.idBaseSite == idBaseSite)&&(identical(other.idSitesGroup, idSitesGroup) || other.idSitesGroup == idSitesGroup)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,idBaseSite,idSitesGroup,data);

@override
String toString() {
  return 'SiteComplement(idBaseSite: $idBaseSite, idSitesGroup: $idSitesGroup, data: $data)';
}


}

/// @nodoc
abstract mixin class $SiteComplementCopyWith<$Res>  {
  factory $SiteComplementCopyWith(SiteComplement value, $Res Function(SiteComplement) _then) = _$SiteComplementCopyWithImpl;
@useResult
$Res call({
 int idBaseSite, int? idSitesGroup, String? data
});




}
/// @nodoc
class _$SiteComplementCopyWithImpl<$Res>
    implements $SiteComplementCopyWith<$Res> {
  _$SiteComplementCopyWithImpl(this._self, this._then);

  final SiteComplement _self;
  final $Res Function(SiteComplement) _then;

/// Create a copy of SiteComplement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idBaseSite = null,Object? idSitesGroup = freezed,Object? data = freezed,}) {
  return _then(_self.copyWith(
idBaseSite: null == idBaseSite ? _self.idBaseSite : idBaseSite // ignore: cast_nullable_to_non_nullable
as int,idSitesGroup: freezed == idSitesGroup ? _self.idSitesGroup : idSitesGroup // ignore: cast_nullable_to_non_nullable
as int?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SiteComplement].
extension SiteComplementPatterns on SiteComplement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SiteComplement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SiteComplement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SiteComplement value)  $default,){
final _that = this;
switch (_that) {
case _SiteComplement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SiteComplement value)?  $default,){
final _that = this;
switch (_that) {
case _SiteComplement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int idBaseSite,  int? idSitesGroup,  String? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SiteComplement() when $default != null:
return $default(_that.idBaseSite,_that.idSitesGroup,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int idBaseSite,  int? idSitesGroup,  String? data)  $default,) {final _that = this;
switch (_that) {
case _SiteComplement():
return $default(_that.idBaseSite,_that.idSitesGroup,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int idBaseSite,  int? idSitesGroup,  String? data)?  $default,) {final _that = this;
switch (_that) {
case _SiteComplement() when $default != null:
return $default(_that.idBaseSite,_that.idSitesGroup,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _SiteComplement implements SiteComplement {
  const _SiteComplement({required this.idBaseSite, this.idSitesGroup, this.data});
  

@override final  int idBaseSite;
@override final  int? idSitesGroup;
@override final  String? data;

/// Create a copy of SiteComplement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SiteComplementCopyWith<_SiteComplement> get copyWith => __$SiteComplementCopyWithImpl<_SiteComplement>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SiteComplement&&(identical(other.idBaseSite, idBaseSite) || other.idBaseSite == idBaseSite)&&(identical(other.idSitesGroup, idSitesGroup) || other.idSitesGroup == idSitesGroup)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,idBaseSite,idSitesGroup,data);

@override
String toString() {
  return 'SiteComplement(idBaseSite: $idBaseSite, idSitesGroup: $idSitesGroup, data: $data)';
}


}

/// @nodoc
abstract mixin class _$SiteComplementCopyWith<$Res> implements $SiteComplementCopyWith<$Res> {
  factory _$SiteComplementCopyWith(_SiteComplement value, $Res Function(_SiteComplement) _then) = __$SiteComplementCopyWithImpl;
@override @useResult
$Res call({
 int idBaseSite, int? idSitesGroup, String? data
});




}
/// @nodoc
class __$SiteComplementCopyWithImpl<$Res>
    implements _$SiteComplementCopyWith<$Res> {
  __$SiteComplementCopyWithImpl(this._self, this._then);

  final _SiteComplement _self;
  final $Res Function(_SiteComplement) _then;

/// Create a copy of SiteComplement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idBaseSite = null,Object? idSitesGroup = freezed,Object? data = freezed,}) {
  return _then(_SiteComplement(
idBaseSite: null == idBaseSite ? _self.idBaseSite : idBaseSite // ignore: cast_nullable_to_non_nullable
as int,idSitesGroup: freezed == idSitesGroup ? _self.idSitesGroup : idSitesGroup // ignore: cast_nullable_to_non_nullable
as int?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
