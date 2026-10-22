// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SyncResult {

 bool get success; int get itemsProcessed; int get itemsAdded; int get itemsUpdated; int get itemsSkipped; int get itemsFailed; DateTime get syncTime; int get itemsDeleted; int get itemsLocalPending; String? get errorMessage; List<SyncConflict>? get conflicts; Map<String, dynamic>? get data;
/// Create a copy of SyncResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncResultCopyWith<SyncResult> get copyWith => _$SyncResultCopyWithImpl<SyncResult>(this as SyncResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncResult&&(identical(other.success, success) || other.success == success)&&(identical(other.itemsProcessed, itemsProcessed) || other.itemsProcessed == itemsProcessed)&&(identical(other.itemsAdded, itemsAdded) || other.itemsAdded == itemsAdded)&&(identical(other.itemsUpdated, itemsUpdated) || other.itemsUpdated == itemsUpdated)&&(identical(other.itemsSkipped, itemsSkipped) || other.itemsSkipped == itemsSkipped)&&(identical(other.itemsFailed, itemsFailed) || other.itemsFailed == itemsFailed)&&(identical(other.syncTime, syncTime) || other.syncTime == syncTime)&&(identical(other.itemsDeleted, itemsDeleted) || other.itemsDeleted == itemsDeleted)&&(identical(other.itemsLocalPending, itemsLocalPending) || other.itemsLocalPending == itemsLocalPending)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other.conflicts, conflicts)&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,success,itemsProcessed,itemsAdded,itemsUpdated,itemsSkipped,itemsFailed,syncTime,itemsDeleted,itemsLocalPending,errorMessage,const DeepCollectionEquality().hash(conflicts),const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'SyncResult(success: $success, itemsProcessed: $itemsProcessed, itemsAdded: $itemsAdded, itemsUpdated: $itemsUpdated, itemsSkipped: $itemsSkipped, itemsFailed: $itemsFailed, syncTime: $syncTime, itemsDeleted: $itemsDeleted, itemsLocalPending: $itemsLocalPending, errorMessage: $errorMessage, conflicts: $conflicts, data: $data)';
}


}

/// @nodoc
abstract mixin class $SyncResultCopyWith<$Res>  {
  factory $SyncResultCopyWith(SyncResult value, $Res Function(SyncResult) _then) = _$SyncResultCopyWithImpl;
@useResult
$Res call({
 bool success, int itemsProcessed, int itemsAdded, int itemsUpdated, int itemsSkipped, int itemsFailed, DateTime syncTime, int itemsDeleted, int itemsLocalPending, String? errorMessage, List<SyncConflict>? conflicts, Map<String, dynamic>? data
});




}
/// @nodoc
class _$SyncResultCopyWithImpl<$Res>
    implements $SyncResultCopyWith<$Res> {
  _$SyncResultCopyWithImpl(this._self, this._then);

  final SyncResult _self;
  final $Res Function(SyncResult) _then;

/// Create a copy of SyncResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? itemsProcessed = null,Object? itemsAdded = null,Object? itemsUpdated = null,Object? itemsSkipped = null,Object? itemsFailed = null,Object? syncTime = null,Object? itemsDeleted = null,Object? itemsLocalPending = null,Object? errorMessage = freezed,Object? conflicts = freezed,Object? data = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,itemsProcessed: null == itemsProcessed ? _self.itemsProcessed : itemsProcessed // ignore: cast_nullable_to_non_nullable
as int,itemsAdded: null == itemsAdded ? _self.itemsAdded : itemsAdded // ignore: cast_nullable_to_non_nullable
as int,itemsUpdated: null == itemsUpdated ? _self.itemsUpdated : itemsUpdated // ignore: cast_nullable_to_non_nullable
as int,itemsSkipped: null == itemsSkipped ? _self.itemsSkipped : itemsSkipped // ignore: cast_nullable_to_non_nullable
as int,itemsFailed: null == itemsFailed ? _self.itemsFailed : itemsFailed // ignore: cast_nullable_to_non_nullable
as int,syncTime: null == syncTime ? _self.syncTime : syncTime // ignore: cast_nullable_to_non_nullable
as DateTime,itemsDeleted: null == itemsDeleted ? _self.itemsDeleted : itemsDeleted // ignore: cast_nullable_to_non_nullable
as int,itemsLocalPending: null == itemsLocalPending ? _self.itemsLocalPending : itemsLocalPending // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,conflicts: freezed == conflicts ? _self.conflicts : conflicts // ignore: cast_nullable_to_non_nullable
as List<SyncConflict>?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncResult].
extension SyncResultPatterns on SyncResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncResult value)  $default,){
final _that = this;
switch (_that) {
case _SyncResult():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncResult value)?  $default,){
final _that = this;
switch (_that) {
case _SyncResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  int itemsProcessed,  int itemsAdded,  int itemsUpdated,  int itemsSkipped,  int itemsFailed,  DateTime syncTime,  int itemsDeleted,  int itemsLocalPending,  String? errorMessage,  List<SyncConflict>? conflicts,  Map<String, dynamic>? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncResult() when $default != null:
return $default(_that.success,_that.itemsProcessed,_that.itemsAdded,_that.itemsUpdated,_that.itemsSkipped,_that.itemsFailed,_that.syncTime,_that.itemsDeleted,_that.itemsLocalPending,_that.errorMessage,_that.conflicts,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  int itemsProcessed,  int itemsAdded,  int itemsUpdated,  int itemsSkipped,  int itemsFailed,  DateTime syncTime,  int itemsDeleted,  int itemsLocalPending,  String? errorMessage,  List<SyncConflict>? conflicts,  Map<String, dynamic>? data)  $default,) {final _that = this;
switch (_that) {
case _SyncResult():
return $default(_that.success,_that.itemsProcessed,_that.itemsAdded,_that.itemsUpdated,_that.itemsSkipped,_that.itemsFailed,_that.syncTime,_that.itemsDeleted,_that.itemsLocalPending,_that.errorMessage,_that.conflicts,_that.data);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  int itemsProcessed,  int itemsAdded,  int itemsUpdated,  int itemsSkipped,  int itemsFailed,  DateTime syncTime,  int itemsDeleted,  int itemsLocalPending,  String? errorMessage,  List<SyncConflict>? conflicts,  Map<String, dynamic>? data)?  $default,) {final _that = this;
switch (_that) {
case _SyncResult() when $default != null:
return $default(_that.success,_that.itemsProcessed,_that.itemsAdded,_that.itemsUpdated,_that.itemsSkipped,_that.itemsFailed,_that.syncTime,_that.itemsDeleted,_that.itemsLocalPending,_that.errorMessage,_that.conflicts,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _SyncResult implements SyncResult {
  const _SyncResult({required this.success, required this.itemsProcessed, required this.itemsAdded, required this.itemsUpdated, required this.itemsSkipped, required this.itemsFailed, required this.syncTime, this.itemsDeleted = 0, this.itemsLocalPending = 0, this.errorMessage, final  List<SyncConflict>? conflicts, final  Map<String, dynamic>? data}): _conflicts = conflicts,_data = data;
  

@override final  bool success;
@override final  int itemsProcessed;
@override final  int itemsAdded;
@override final  int itemsUpdated;
@override final  int itemsSkipped;
@override final  int itemsFailed;
@override final  DateTime syncTime;
@override@JsonKey() final  int itemsDeleted;
@override@JsonKey() final  int itemsLocalPending;
@override final  String? errorMessage;
 final  List<SyncConflict>? _conflicts;
@override List<SyncConflict>? get conflicts {
  final value = _conflicts;
  if (value == null) return null;
  if (_conflicts is EqualUnmodifiableListView) return _conflicts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  Map<String, dynamic>? _data;
@override Map<String, dynamic>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of SyncResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncResultCopyWith<_SyncResult> get copyWith => __$SyncResultCopyWithImpl<_SyncResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncResult&&(identical(other.success, success) || other.success == success)&&(identical(other.itemsProcessed, itemsProcessed) || other.itemsProcessed == itemsProcessed)&&(identical(other.itemsAdded, itemsAdded) || other.itemsAdded == itemsAdded)&&(identical(other.itemsUpdated, itemsUpdated) || other.itemsUpdated == itemsUpdated)&&(identical(other.itemsSkipped, itemsSkipped) || other.itemsSkipped == itemsSkipped)&&(identical(other.itemsFailed, itemsFailed) || other.itemsFailed == itemsFailed)&&(identical(other.syncTime, syncTime) || other.syncTime == syncTime)&&(identical(other.itemsDeleted, itemsDeleted) || other.itemsDeleted == itemsDeleted)&&(identical(other.itemsLocalPending, itemsLocalPending) || other.itemsLocalPending == itemsLocalPending)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other._conflicts, _conflicts)&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,success,itemsProcessed,itemsAdded,itemsUpdated,itemsSkipped,itemsFailed,syncTime,itemsDeleted,itemsLocalPending,errorMessage,const DeepCollectionEquality().hash(_conflicts),const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'SyncResult(success: $success, itemsProcessed: $itemsProcessed, itemsAdded: $itemsAdded, itemsUpdated: $itemsUpdated, itemsSkipped: $itemsSkipped, itemsFailed: $itemsFailed, syncTime: $syncTime, itemsDeleted: $itemsDeleted, itemsLocalPending: $itemsLocalPending, errorMessage: $errorMessage, conflicts: $conflicts, data: $data)';
}


}

/// @nodoc
abstract mixin class _$SyncResultCopyWith<$Res> implements $SyncResultCopyWith<$Res> {
  factory _$SyncResultCopyWith(_SyncResult value, $Res Function(_SyncResult) _then) = __$SyncResultCopyWithImpl;
@override @useResult
$Res call({
 bool success, int itemsProcessed, int itemsAdded, int itemsUpdated, int itemsSkipped, int itemsFailed, DateTime syncTime, int itemsDeleted, int itemsLocalPending, String? errorMessage, List<SyncConflict>? conflicts, Map<String, dynamic>? data
});




}
/// @nodoc
class __$SyncResultCopyWithImpl<$Res>
    implements _$SyncResultCopyWith<$Res> {
  __$SyncResultCopyWithImpl(this._self, this._then);

  final _SyncResult _self;
  final $Res Function(_SyncResult) _then;

/// Create a copy of SyncResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? itemsProcessed = null,Object? itemsAdded = null,Object? itemsUpdated = null,Object? itemsSkipped = null,Object? itemsFailed = null,Object? syncTime = null,Object? itemsDeleted = null,Object? itemsLocalPending = null,Object? errorMessage = freezed,Object? conflicts = freezed,Object? data = freezed,}) {
  return _then(_SyncResult(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,itemsProcessed: null == itemsProcessed ? _self.itemsProcessed : itemsProcessed // ignore: cast_nullable_to_non_nullable
as int,itemsAdded: null == itemsAdded ? _self.itemsAdded : itemsAdded // ignore: cast_nullable_to_non_nullable
as int,itemsUpdated: null == itemsUpdated ? _self.itemsUpdated : itemsUpdated // ignore: cast_nullable_to_non_nullable
as int,itemsSkipped: null == itemsSkipped ? _self.itemsSkipped : itemsSkipped // ignore: cast_nullable_to_non_nullable
as int,itemsFailed: null == itemsFailed ? _self.itemsFailed : itemsFailed // ignore: cast_nullable_to_non_nullable
as int,syncTime: null == syncTime ? _self.syncTime : syncTime // ignore: cast_nullable_to_non_nullable
as DateTime,itemsDeleted: null == itemsDeleted ? _self.itemsDeleted : itemsDeleted // ignore: cast_nullable_to_non_nullable
as int,itemsLocalPending: null == itemsLocalPending ? _self.itemsLocalPending : itemsLocalPending // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,conflicts: freezed == conflicts ? _self._conflicts : conflicts // ignore: cast_nullable_to_non_nullable
as List<SyncConflict>?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
