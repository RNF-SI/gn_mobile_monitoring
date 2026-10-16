// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$State<T> {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is State<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'State<$T>()';
}


}

/// @nodoc
class $StateCopyWith<T,$Res>  {
$StateCopyWith(State<T> _, $Res Function(State<T>) __);
}


/// Adds pattern-matching-related methods to [State].
extension StatePatterns<T> on State<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _init<T> value)?  init,TResult Function( _loading<T> value)?  loading,TResult Function( _success<T> value)?  success,TResult Function( _error<T> value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _init() when init != null:
return init(_that);case _loading() when loading != null:
return loading(_that);case _success() when success != null:
return success(_that);case _error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _init<T> value)  init,required TResult Function( _loading<T> value)  loading,required TResult Function( _success<T> value)  success,required TResult Function( _error<T> value)  error,}){
final _that = this;
switch (_that) {
case _init():
return init(_that);case _loading():
return loading(_that);case _success():
return success(_that);case _error():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _init<T> value)?  init,TResult? Function( _loading<T> value)?  loading,TResult? Function( _success<T> value)?  success,TResult? Function( _error<T> value)?  error,}){
final _that = this;
switch (_that) {
case _init() when init != null:
return init(_that);case _loading() when loading != null:
return loading(_that);case _success() when success != null:
return success(_that);case _error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  init,TResult Function()?  loading,TResult Function( T data)?  success,TResult Function( Exception exception)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _init() when init != null:
return init();case _loading() when loading != null:
return loading();case _success() when success != null:
return success(_that.data);case _error() when error != null:
return error(_that.exception);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  init,required TResult Function()  loading,required TResult Function( T data)  success,required TResult Function( Exception exception)  error,}) {final _that = this;
switch (_that) {
case _init():
return init();case _loading():
return loading();case _success():
return success(_that.data);case _error():
return error(_that.exception);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  init,TResult? Function()?  loading,TResult? Function( T data)?  success,TResult? Function( Exception exception)?  error,}) {final _that = this;
switch (_that) {
case _init() when init != null:
return init();case _loading() when loading != null:
return loading();case _success() when success != null:
return success(_that.data);case _error() when error != null:
return error(_that.exception);case _:
  return null;

}
}

}

/// @nodoc


class _init<T> extends State<T> {
  const _init(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _init<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'State<$T>.init()';
}


}




/// @nodoc


class _loading<T> extends State<T> {
  const _loading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _loading<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'State<$T>.loading()';
}


}




/// @nodoc


class _success<T> extends State<T> {
  const _success(this.data): super._();
  

 final  T data;

/// Create a copy of State
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$successCopyWith<T, _success<T>> get copyWith => __$successCopyWithImpl<T, _success<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _success<T>&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'State<$T>.success(data: $data)';
}


}

/// @nodoc
abstract mixin class _$successCopyWith<T,$Res> implements $StateCopyWith<T, $Res> {
  factory _$successCopyWith(_success<T> value, $Res Function(_success<T>) _then) = __$successCopyWithImpl;
@useResult
$Res call({
 T data
});




}
/// @nodoc
class __$successCopyWithImpl<T,$Res>
    implements _$successCopyWith<T, $Res> {
  __$successCopyWithImpl(this._self, this._then);

  final _success<T> _self;
  final $Res Function(_success<T>) _then;

/// Create a copy of State
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = freezed,}) {
  return _then(_success<T>(
freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T,
  ));
}


}

/// @nodoc


class _error<T> extends State<T> {
  const _error(this.exception): super._();
  

 final  Exception exception;

/// Create a copy of State
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$errorCopyWith<T, _error<T>> get copyWith => __$errorCopyWithImpl<T, _error<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _error<T>&&(identical(other.exception, exception) || other.exception == exception));
}


@override
int get hashCode => Object.hash(runtimeType,exception);

@override
String toString() {
  return 'State<$T>.error(exception: $exception)';
}


}

/// @nodoc
abstract mixin class _$errorCopyWith<T,$Res> implements $StateCopyWith<T, $Res> {
  factory _$errorCopyWith(_error<T> value, $Res Function(_error<T>) _then) = __$errorCopyWithImpl;
@useResult
$Res call({
 Exception exception
});




}
/// @nodoc
class __$errorCopyWithImpl<T,$Res>
    implements _$errorCopyWith<T, $Res> {
  __$errorCopyWithImpl(this._self, this._then);

  final _error<T> _self;
  final $Res Function(_error<T>) _then;

/// Create a copy of State
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? exception = null,}) {
  return _then(_error<T>(
null == exception ? _self.exception : exception // ignore: cast_nullable_to_non_nullable
as Exception,
  ));
}


}

// dart format on
