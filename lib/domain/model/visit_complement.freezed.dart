// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'visit_complement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VisitComplement {

 int get idBaseVisit; String? get data;
/// Create a copy of VisitComplement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisitComplementCopyWith<VisitComplement> get copyWith => _$VisitComplementCopyWithImpl<VisitComplement>(this as VisitComplement, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisitComplement&&(identical(other.idBaseVisit, idBaseVisit) || other.idBaseVisit == idBaseVisit)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,idBaseVisit,data);

@override
String toString() {
  return 'VisitComplement(idBaseVisit: $idBaseVisit, data: $data)';
}


}

/// @nodoc
abstract mixin class $VisitComplementCopyWith<$Res>  {
  factory $VisitComplementCopyWith(VisitComplement value, $Res Function(VisitComplement) _then) = _$VisitComplementCopyWithImpl;
@useResult
$Res call({
 int idBaseVisit, String? data
});




}
/// @nodoc
class _$VisitComplementCopyWithImpl<$Res>
    implements $VisitComplementCopyWith<$Res> {
  _$VisitComplementCopyWithImpl(this._self, this._then);

  final VisitComplement _self;
  final $Res Function(VisitComplement) _then;

/// Create a copy of VisitComplement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idBaseVisit = null,Object? data = freezed,}) {
  return _then(_self.copyWith(
idBaseVisit: null == idBaseVisit ? _self.idBaseVisit : idBaseVisit // ignore: cast_nullable_to_non_nullable
as int,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VisitComplement].
extension VisitComplementPatterns on VisitComplement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VisitComplement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VisitComplement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VisitComplement value)  $default,){
final _that = this;
switch (_that) {
case _VisitComplement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VisitComplement value)?  $default,){
final _that = this;
switch (_that) {
case _VisitComplement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int idBaseVisit,  String? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VisitComplement() when $default != null:
return $default(_that.idBaseVisit,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int idBaseVisit,  String? data)  $default,) {final _that = this;
switch (_that) {
case _VisitComplement():
return $default(_that.idBaseVisit,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int idBaseVisit,  String? data)?  $default,) {final _that = this;
switch (_that) {
case _VisitComplement() when $default != null:
return $default(_that.idBaseVisit,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _VisitComplement implements VisitComplement {
  const _VisitComplement({required this.idBaseVisit, this.data});
  

@override final  int idBaseVisit;
@override final  String? data;

/// Create a copy of VisitComplement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VisitComplementCopyWith<_VisitComplement> get copyWith => __$VisitComplementCopyWithImpl<_VisitComplement>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VisitComplement&&(identical(other.idBaseVisit, idBaseVisit) || other.idBaseVisit == idBaseVisit)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,idBaseVisit,data);

@override
String toString() {
  return 'VisitComplement(idBaseVisit: $idBaseVisit, data: $data)';
}


}

/// @nodoc
abstract mixin class _$VisitComplementCopyWith<$Res> implements $VisitComplementCopyWith<$Res> {
  factory _$VisitComplementCopyWith(_VisitComplement value, $Res Function(_VisitComplement) _then) = __$VisitComplementCopyWithImpl;
@override @useResult
$Res call({
 int idBaseVisit, String? data
});




}
/// @nodoc
class __$VisitComplementCopyWithImpl<$Res>
    implements _$VisitComplementCopyWith<$Res> {
  __$VisitComplementCopyWithImpl(this._self, this._then);

  final _VisitComplement _self;
  final $Res Function(_VisitComplement) _then;

/// Create a copy of VisitComplement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idBaseVisit = null,Object? data = freezed,}) {
  return _then(_VisitComplement(
idBaseVisit: null == idBaseVisit ? _self.idBaseVisit : idBaseVisit // ignore: cast_nullable_to_non_nullable
as int,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
