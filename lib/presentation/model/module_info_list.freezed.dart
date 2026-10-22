// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'module_info_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ModuleInfoList {

 List<ModuleInfo> get values;
/// Create a copy of ModuleInfoList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModuleInfoListCopyWith<ModuleInfoList> get copyWith => _$ModuleInfoListCopyWithImpl<ModuleInfoList>(this as ModuleInfoList, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModuleInfoList&&const DeepCollectionEquality().equals(other.values, values));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(values));

@override
String toString() {
  return 'ModuleInfoList(values: $values)';
}


}

/// @nodoc
abstract mixin class $ModuleInfoListCopyWith<$Res>  {
  factory $ModuleInfoListCopyWith(ModuleInfoList value, $Res Function(ModuleInfoList) _then) = _$ModuleInfoListCopyWithImpl;
@useResult
$Res call({
 List<ModuleInfo> values
});




}
/// @nodoc
class _$ModuleInfoListCopyWithImpl<$Res>
    implements $ModuleInfoListCopyWith<$Res> {
  _$ModuleInfoListCopyWithImpl(this._self, this._then);

  final ModuleInfoList _self;
  final $Res Function(ModuleInfoList) _then;

/// Create a copy of ModuleInfoList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? values = null,}) {
  return _then(_self.copyWith(
values: null == values ? _self.values : values // ignore: cast_nullable_to_non_nullable
as List<ModuleInfo>,
  ));
}

}


/// Adds pattern-matching-related methods to [ModuleInfoList].
extension ModuleInfoListPatterns on ModuleInfoList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModuleInfoList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModuleInfoList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModuleInfoList value)  $default,){
final _that = this;
switch (_that) {
case _ModuleInfoList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModuleInfoList value)?  $default,){
final _that = this;
switch (_that) {
case _ModuleInfoList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ModuleInfo> values)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModuleInfoList() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ModuleInfo> values)  $default,) {final _that = this;
switch (_that) {
case _ModuleInfoList():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ModuleInfo> values)?  $default,) {final _that = this;
switch (_that) {
case _ModuleInfoList() when $default != null:
return $default(_that.values);case _:
  return null;

}
}

}

/// @nodoc


class _ModuleInfoList extends ModuleInfoList {
  const _ModuleInfoList({required final  List<ModuleInfo> values}): _values = values,super._();
  

 final  List<ModuleInfo> _values;
@override List<ModuleInfo> get values {
  if (_values is EqualUnmodifiableListView) return _values;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_values);
}


/// Create a copy of ModuleInfoList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModuleInfoListCopyWith<_ModuleInfoList> get copyWith => __$ModuleInfoListCopyWithImpl<_ModuleInfoList>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModuleInfoList&&const DeepCollectionEquality().equals(other._values, _values));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_values));

@override
String toString() {
  return 'ModuleInfoList(values: $values)';
}


}

/// @nodoc
abstract mixin class _$ModuleInfoListCopyWith<$Res> implements $ModuleInfoListCopyWith<$Res> {
  factory _$ModuleInfoListCopyWith(_ModuleInfoList value, $Res Function(_ModuleInfoList) _then) = __$ModuleInfoListCopyWithImpl;
@override @useResult
$Res call({
 List<ModuleInfo> values
});




}
/// @nodoc
class __$ModuleInfoListCopyWithImpl<$Res>
    implements _$ModuleInfoListCopyWith<$Res> {
  __$ModuleInfoListCopyWithImpl(this._self, this._then);

  final _ModuleInfoList _self;
  final $Res Function(_ModuleInfoList) _then;

/// Create a copy of ModuleInfoList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? values = null,}) {
  return _then(_ModuleInfoList(
values: null == values ? _self._values : values // ignore: cast_nullable_to_non_nullable
as List<ModuleInfo>,
  ));
}


}

// dart format on
