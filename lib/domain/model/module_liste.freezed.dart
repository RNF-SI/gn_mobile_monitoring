// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'module_liste.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ModuleListe {

 List<Module> get values;
/// Create a copy of ModuleListe
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModuleListeCopyWith<ModuleListe> get copyWith => _$ModuleListeCopyWithImpl<ModuleListe>(this as ModuleListe, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModuleListe&&const DeepCollectionEquality().equals(other.values, values));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(values));

@override
String toString() {
  return 'ModuleListe(values: $values)';
}


}

/// @nodoc
abstract mixin class $ModuleListeCopyWith<$Res>  {
  factory $ModuleListeCopyWith(ModuleListe value, $Res Function(ModuleListe) _then) = _$ModuleListeCopyWithImpl;
@useResult
$Res call({
 List<Module> values
});




}
/// @nodoc
class _$ModuleListeCopyWithImpl<$Res>
    implements $ModuleListeCopyWith<$Res> {
  _$ModuleListeCopyWithImpl(this._self, this._then);

  final ModuleListe _self;
  final $Res Function(ModuleListe) _then;

/// Create a copy of ModuleListe
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? values = null,}) {
  return _then(_self.copyWith(
values: null == values ? _self.values : values // ignore: cast_nullable_to_non_nullable
as List<Module>,
  ));
}

}


/// Adds pattern-matching-related methods to [ModuleListe].
extension ModuleListePatterns on ModuleListe {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModuleListe value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModuleListe() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModuleListe value)  $default,){
final _that = this;
switch (_that) {
case _ModuleListe():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModuleListe value)?  $default,){
final _that = this;
switch (_that) {
case _ModuleListe() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Module> values)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModuleListe() when $default != null:
return $default(_that.values);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Module> values)  $default,) {final _that = this;
switch (_that) {
case _ModuleListe():
return $default(_that.values);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Module> values)?  $default,) {final _that = this;
switch (_that) {
case _ModuleListe() when $default != null:
return $default(_that.values);case _:
  return null;

}
}

}

/// @nodoc


class _ModuleListe extends ModuleListe {
  const _ModuleListe({required final  List<Module> values}): _values = values,super._();
  

 final  List<Module> _values;
@override List<Module> get values {
  if (_values is EqualUnmodifiableListView) return _values;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_values);
}


/// Create a copy of ModuleListe
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModuleListeCopyWith<_ModuleListe> get copyWith => __$ModuleListeCopyWithImpl<_ModuleListe>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModuleListe&&const DeepCollectionEquality().equals(other._values, _values));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_values));

@override
String toString() {
  return 'ModuleListe(values: $values)';
}


}

/// @nodoc
abstract mixin class _$ModuleListeCopyWith<$Res> implements $ModuleListeCopyWith<$Res> {
  factory _$ModuleListeCopyWith(_ModuleListe value, $Res Function(_ModuleListe) _then) = __$ModuleListeCopyWithImpl;
@override @useResult
$Res call({
 List<Module> values
});




}
/// @nodoc
class __$ModuleListeCopyWithImpl<$Res>
    implements _$ModuleListeCopyWith<$Res> {
  __$ModuleListeCopyWithImpl(this._self, this._then);

  final _ModuleListe _self;
  final $Res Function(_ModuleListe) _then;

/// Create a copy of ModuleListe
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? values = null,}) {
  return _then(_ModuleListe(
values: null == values ? _self._values : values // ignore: cast_nullable_to_non_nullable
as List<Module>,
  ));
}


}

// dart format on
