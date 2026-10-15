// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'visit_observer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VisitObserver {

 int get idBaseVisit; int get idRole; String get uniqueId;
/// Create a copy of VisitObserver
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VisitObserverCopyWith<VisitObserver> get copyWith => _$VisitObserverCopyWithImpl<VisitObserver>(this as VisitObserver, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VisitObserver&&(identical(other.idBaseVisit, idBaseVisit) || other.idBaseVisit == idBaseVisit)&&(identical(other.idRole, idRole) || other.idRole == idRole)&&(identical(other.uniqueId, uniqueId) || other.uniqueId == uniqueId));
}


@override
int get hashCode => Object.hash(runtimeType,idBaseVisit,idRole,uniqueId);

@override
String toString() {
  return 'VisitObserver(idBaseVisit: $idBaseVisit, idRole: $idRole, uniqueId: $uniqueId)';
}


}

/// @nodoc
abstract mixin class $VisitObserverCopyWith<$Res>  {
  factory $VisitObserverCopyWith(VisitObserver value, $Res Function(VisitObserver) _then) = _$VisitObserverCopyWithImpl;
@useResult
$Res call({
 int idBaseVisit, int idRole, String uniqueId
});




}
/// @nodoc
class _$VisitObserverCopyWithImpl<$Res>
    implements $VisitObserverCopyWith<$Res> {
  _$VisitObserverCopyWithImpl(this._self, this._then);

  final VisitObserver _self;
  final $Res Function(VisitObserver) _then;

/// Create a copy of VisitObserver
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? idBaseVisit = null,Object? idRole = null,Object? uniqueId = null,}) {
  return _then(_self.copyWith(
idBaseVisit: null == idBaseVisit ? _self.idBaseVisit : idBaseVisit // ignore: cast_nullable_to_non_nullable
as int,idRole: null == idRole ? _self.idRole : idRole // ignore: cast_nullable_to_non_nullable
as int,uniqueId: null == uniqueId ? _self.uniqueId : uniqueId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VisitObserver].
extension VisitObserverPatterns on VisitObserver {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VisitObserver value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VisitObserver() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VisitObserver value)  $default,){
final _that = this;
switch (_that) {
case _VisitObserver():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VisitObserver value)?  $default,){
final _that = this;
switch (_that) {
case _VisitObserver() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int idBaseVisit,  int idRole,  String uniqueId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VisitObserver() when $default != null:
return $default(_that.idBaseVisit,_that.idRole,_that.uniqueId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int idBaseVisit,  int idRole,  String uniqueId)  $default,) {final _that = this;
switch (_that) {
case _VisitObserver():
return $default(_that.idBaseVisit,_that.idRole,_that.uniqueId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int idBaseVisit,  int idRole,  String uniqueId)?  $default,) {final _that = this;
switch (_that) {
case _VisitObserver() when $default != null:
return $default(_that.idBaseVisit,_that.idRole,_that.uniqueId);case _:
  return null;

}
}

}

/// @nodoc


class _VisitObserver implements VisitObserver {
  const _VisitObserver({required this.idBaseVisit, required this.idRole, required this.uniqueId});
  

@override final  int idBaseVisit;
@override final  int idRole;
@override final  String uniqueId;

/// Create a copy of VisitObserver
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VisitObserverCopyWith<_VisitObserver> get copyWith => __$VisitObserverCopyWithImpl<_VisitObserver>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VisitObserver&&(identical(other.idBaseVisit, idBaseVisit) || other.idBaseVisit == idBaseVisit)&&(identical(other.idRole, idRole) || other.idRole == idRole)&&(identical(other.uniqueId, uniqueId) || other.uniqueId == uniqueId));
}


@override
int get hashCode => Object.hash(runtimeType,idBaseVisit,idRole,uniqueId);

@override
String toString() {
  return 'VisitObserver(idBaseVisit: $idBaseVisit, idRole: $idRole, uniqueId: $uniqueId)';
}


}

/// @nodoc
abstract mixin class _$VisitObserverCopyWith<$Res> implements $VisitObserverCopyWith<$Res> {
  factory _$VisitObserverCopyWith(_VisitObserver value, $Res Function(_VisitObserver) _then) = __$VisitObserverCopyWithImpl;
@override @useResult
$Res call({
 int idBaseVisit, int idRole, String uniqueId
});




}
/// @nodoc
class __$VisitObserverCopyWithImpl<$Res>
    implements _$VisitObserverCopyWith<$Res> {
  __$VisitObserverCopyWithImpl(this._self, this._then);

  final _VisitObserver _self;
  final $Res Function(_VisitObserver) _then;

/// Create a copy of VisitObserver
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? idBaseVisit = null,Object? idRole = null,Object? uniqueId = null,}) {
  return _then(_VisitObserver(
idBaseVisit: null == idBaseVisit ? _self.idBaseVisit : idBaseVisit // ignore: cast_nullable_to_non_nullable
as int,idRole: null == idRole ? _self.idRole : idRole // ignore: cast_nullable_to_non_nullable
as int,uniqueId: null == uniqueId ? _self.uniqueId : uniqueId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
