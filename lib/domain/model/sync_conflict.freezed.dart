// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_conflict.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SyncConflict {

 String get entityId; String get entityType; Map<String, dynamic> get localData; Map<String, dynamic> get remoteData; DateTime get localModifiedAt; DateTime get remoteModifiedAt; ConflictResolutionStrategy get resolutionStrategy; Map<String, dynamic>? get resolvedData; String? get resolutionComment; ConflictType get conflictType;// Pour les références supprimées, on stocke des informations sur l'entité référencée
 String? get referencedEntityType;// Type de l'entité supprimée (nomenclature, taxon, etc.)
 String? get referencedEntityId;// ID de l'entité supprimée
 String? get affectedField;// Champ affecté par la suppression
 String? get navigationPath;// Chemin de navigation pour résoudre le conflit
 bool get isResolved;// Indique si le conflit a été géré
 String? get resolutionType;// Comment le conflit a été résolu (ex: "modifié", "supprimé", etc.)
// Nouvelles propriétés pour la gestion améliorée des conflits
 SyncOperation? get operation;// Opération qui a causé le conflit
 String? get message;// Message détaillé du conflit
 ConflictSeverity? get severity;// Sévérité du conflit
 String? get localValue;// Valeur locale spécifique en conflit
 String? get remoteValue;// Valeur distante spécifique en conflit
 int? get referencesCount;
/// Create a copy of SyncConflict
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncConflictCopyWith<SyncConflict> get copyWith => _$SyncConflictCopyWithImpl<SyncConflict>(this as SyncConflict, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncConflict&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&const DeepCollectionEquality().equals(other.localData, localData)&&const DeepCollectionEquality().equals(other.remoteData, remoteData)&&(identical(other.localModifiedAt, localModifiedAt) || other.localModifiedAt == localModifiedAt)&&(identical(other.remoteModifiedAt, remoteModifiedAt) || other.remoteModifiedAt == remoteModifiedAt)&&(identical(other.resolutionStrategy, resolutionStrategy) || other.resolutionStrategy == resolutionStrategy)&&const DeepCollectionEquality().equals(other.resolvedData, resolvedData)&&(identical(other.resolutionComment, resolutionComment) || other.resolutionComment == resolutionComment)&&(identical(other.conflictType, conflictType) || other.conflictType == conflictType)&&(identical(other.referencedEntityType, referencedEntityType) || other.referencedEntityType == referencedEntityType)&&(identical(other.referencedEntityId, referencedEntityId) || other.referencedEntityId == referencedEntityId)&&(identical(other.affectedField, affectedField) || other.affectedField == affectedField)&&(identical(other.navigationPath, navigationPath) || other.navigationPath == navigationPath)&&(identical(other.isResolved, isResolved) || other.isResolved == isResolved)&&(identical(other.resolutionType, resolutionType) || other.resolutionType == resolutionType)&&(identical(other.operation, operation) || other.operation == operation)&&(identical(other.message, message) || other.message == message)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.localValue, localValue) || other.localValue == localValue)&&(identical(other.remoteValue, remoteValue) || other.remoteValue == remoteValue)&&(identical(other.referencesCount, referencesCount) || other.referencesCount == referencesCount));
}


@override
int get hashCode => Object.hashAll([runtimeType,entityId,entityType,const DeepCollectionEquality().hash(localData),const DeepCollectionEquality().hash(remoteData),localModifiedAt,remoteModifiedAt,resolutionStrategy,const DeepCollectionEquality().hash(resolvedData),resolutionComment,conflictType,referencedEntityType,referencedEntityId,affectedField,navigationPath,isResolved,resolutionType,operation,message,severity,localValue,remoteValue,referencesCount]);

@override
String toString() {
  return 'SyncConflict(entityId: $entityId, entityType: $entityType, localData: $localData, remoteData: $remoteData, localModifiedAt: $localModifiedAt, remoteModifiedAt: $remoteModifiedAt, resolutionStrategy: $resolutionStrategy, resolvedData: $resolvedData, resolutionComment: $resolutionComment, conflictType: $conflictType, referencedEntityType: $referencedEntityType, referencedEntityId: $referencedEntityId, affectedField: $affectedField, navigationPath: $navigationPath, isResolved: $isResolved, resolutionType: $resolutionType, operation: $operation, message: $message, severity: $severity, localValue: $localValue, remoteValue: $remoteValue, referencesCount: $referencesCount)';
}


}

/// @nodoc
abstract mixin class $SyncConflictCopyWith<$Res>  {
  factory $SyncConflictCopyWith(SyncConflict value, $Res Function(SyncConflict) _then) = _$SyncConflictCopyWithImpl;
@useResult
$Res call({
 String entityId, String entityType, Map<String, dynamic> localData, Map<String, dynamic> remoteData, DateTime localModifiedAt, DateTime remoteModifiedAt, ConflictResolutionStrategy resolutionStrategy, Map<String, dynamic>? resolvedData, String? resolutionComment, ConflictType conflictType, String? referencedEntityType, String? referencedEntityId, String? affectedField, String? navigationPath, bool isResolved, String? resolutionType, SyncOperation? operation, String? message, ConflictSeverity? severity, String? localValue, String? remoteValue, int? referencesCount
});




}
/// @nodoc
class _$SyncConflictCopyWithImpl<$Res>
    implements $SyncConflictCopyWith<$Res> {
  _$SyncConflictCopyWithImpl(this._self, this._then);

  final SyncConflict _self;
  final $Res Function(SyncConflict) _then;

/// Create a copy of SyncConflict
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entityId = null,Object? entityType = null,Object? localData = null,Object? remoteData = null,Object? localModifiedAt = null,Object? remoteModifiedAt = null,Object? resolutionStrategy = null,Object? resolvedData = freezed,Object? resolutionComment = freezed,Object? conflictType = null,Object? referencedEntityType = freezed,Object? referencedEntityId = freezed,Object? affectedField = freezed,Object? navigationPath = freezed,Object? isResolved = null,Object? resolutionType = freezed,Object? operation = freezed,Object? message = freezed,Object? severity = freezed,Object? localValue = freezed,Object? remoteValue = freezed,Object? referencesCount = freezed,}) {
  return _then(_self.copyWith(
entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,entityType: null == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String,localData: null == localData ? _self.localData : localData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,remoteData: null == remoteData ? _self.remoteData : remoteData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,localModifiedAt: null == localModifiedAt ? _self.localModifiedAt : localModifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime,remoteModifiedAt: null == remoteModifiedAt ? _self.remoteModifiedAt : remoteModifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime,resolutionStrategy: null == resolutionStrategy ? _self.resolutionStrategy : resolutionStrategy // ignore: cast_nullable_to_non_nullable
as ConflictResolutionStrategy,resolvedData: freezed == resolvedData ? _self.resolvedData : resolvedData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,resolutionComment: freezed == resolutionComment ? _self.resolutionComment : resolutionComment // ignore: cast_nullable_to_non_nullable
as String?,conflictType: null == conflictType ? _self.conflictType : conflictType // ignore: cast_nullable_to_non_nullable
as ConflictType,referencedEntityType: freezed == referencedEntityType ? _self.referencedEntityType : referencedEntityType // ignore: cast_nullable_to_non_nullable
as String?,referencedEntityId: freezed == referencedEntityId ? _self.referencedEntityId : referencedEntityId // ignore: cast_nullable_to_non_nullable
as String?,affectedField: freezed == affectedField ? _self.affectedField : affectedField // ignore: cast_nullable_to_non_nullable
as String?,navigationPath: freezed == navigationPath ? _self.navigationPath : navigationPath // ignore: cast_nullable_to_non_nullable
as String?,isResolved: null == isResolved ? _self.isResolved : isResolved // ignore: cast_nullable_to_non_nullable
as bool,resolutionType: freezed == resolutionType ? _self.resolutionType : resolutionType // ignore: cast_nullable_to_non_nullable
as String?,operation: freezed == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as SyncOperation?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,severity: freezed == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as ConflictSeverity?,localValue: freezed == localValue ? _self.localValue : localValue // ignore: cast_nullable_to_non_nullable
as String?,remoteValue: freezed == remoteValue ? _self.remoteValue : remoteValue // ignore: cast_nullable_to_non_nullable
as String?,referencesCount: freezed == referencesCount ? _self.referencesCount : referencesCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncConflict].
extension SyncConflictPatterns on SyncConflict {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncConflict value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncConflict() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncConflict value)  $default,){
final _that = this;
switch (_that) {
case _SyncConflict():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncConflict value)?  $default,){
final _that = this;
switch (_that) {
case _SyncConflict() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String entityId,  String entityType,  Map<String, dynamic> localData,  Map<String, dynamic> remoteData,  DateTime localModifiedAt,  DateTime remoteModifiedAt,  ConflictResolutionStrategy resolutionStrategy,  Map<String, dynamic>? resolvedData,  String? resolutionComment,  ConflictType conflictType,  String? referencedEntityType,  String? referencedEntityId,  String? affectedField,  String? navigationPath,  bool isResolved,  String? resolutionType,  SyncOperation? operation,  String? message,  ConflictSeverity? severity,  String? localValue,  String? remoteValue,  int? referencesCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncConflict() when $default != null:
return $default(_that.entityId,_that.entityType,_that.localData,_that.remoteData,_that.localModifiedAt,_that.remoteModifiedAt,_that.resolutionStrategy,_that.resolvedData,_that.resolutionComment,_that.conflictType,_that.referencedEntityType,_that.referencedEntityId,_that.affectedField,_that.navigationPath,_that.isResolved,_that.resolutionType,_that.operation,_that.message,_that.severity,_that.localValue,_that.remoteValue,_that.referencesCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String entityId,  String entityType,  Map<String, dynamic> localData,  Map<String, dynamic> remoteData,  DateTime localModifiedAt,  DateTime remoteModifiedAt,  ConflictResolutionStrategy resolutionStrategy,  Map<String, dynamic>? resolvedData,  String? resolutionComment,  ConflictType conflictType,  String? referencedEntityType,  String? referencedEntityId,  String? affectedField,  String? navigationPath,  bool isResolved,  String? resolutionType,  SyncOperation? operation,  String? message,  ConflictSeverity? severity,  String? localValue,  String? remoteValue,  int? referencesCount)  $default,) {final _that = this;
switch (_that) {
case _SyncConflict():
return $default(_that.entityId,_that.entityType,_that.localData,_that.remoteData,_that.localModifiedAt,_that.remoteModifiedAt,_that.resolutionStrategy,_that.resolvedData,_that.resolutionComment,_that.conflictType,_that.referencedEntityType,_that.referencedEntityId,_that.affectedField,_that.navigationPath,_that.isResolved,_that.resolutionType,_that.operation,_that.message,_that.severity,_that.localValue,_that.remoteValue,_that.referencesCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String entityId,  String entityType,  Map<String, dynamic> localData,  Map<String, dynamic> remoteData,  DateTime localModifiedAt,  DateTime remoteModifiedAt,  ConflictResolutionStrategy resolutionStrategy,  Map<String, dynamic>? resolvedData,  String? resolutionComment,  ConflictType conflictType,  String? referencedEntityType,  String? referencedEntityId,  String? affectedField,  String? navigationPath,  bool isResolved,  String? resolutionType,  SyncOperation? operation,  String? message,  ConflictSeverity? severity,  String? localValue,  String? remoteValue,  int? referencesCount)?  $default,) {final _that = this;
switch (_that) {
case _SyncConflict() when $default != null:
return $default(_that.entityId,_that.entityType,_that.localData,_that.remoteData,_that.localModifiedAt,_that.remoteModifiedAt,_that.resolutionStrategy,_that.resolvedData,_that.resolutionComment,_that.conflictType,_that.referencedEntityType,_that.referencedEntityId,_that.affectedField,_that.navigationPath,_that.isResolved,_that.resolutionType,_that.operation,_that.message,_that.severity,_that.localValue,_that.remoteValue,_that.referencesCount);case _:
  return null;

}
}

}

/// @nodoc


class _SyncConflict extends SyncConflict {
  const _SyncConflict({required this.entityId, required this.entityType, required final  Map<String, dynamic> localData, required final  Map<String, dynamic> remoteData, required this.localModifiedAt, required this.remoteModifiedAt, required this.resolutionStrategy, final  Map<String, dynamic>? resolvedData, this.resolutionComment, this.conflictType = ConflictType.dataConflict, this.referencedEntityType, this.referencedEntityId, this.affectedField, this.navigationPath, this.isResolved = false, this.resolutionType, this.operation, this.message, this.severity, this.localValue, this.remoteValue, this.referencesCount}): _localData = localData,_remoteData = remoteData,_resolvedData = resolvedData,super._();
  

@override final  String entityId;
@override final  String entityType;
 final  Map<String, dynamic> _localData;
@override Map<String, dynamic> get localData {
  if (_localData is EqualUnmodifiableMapView) return _localData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_localData);
}

 final  Map<String, dynamic> _remoteData;
@override Map<String, dynamic> get remoteData {
  if (_remoteData is EqualUnmodifiableMapView) return _remoteData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_remoteData);
}

@override final  DateTime localModifiedAt;
@override final  DateTime remoteModifiedAt;
@override final  ConflictResolutionStrategy resolutionStrategy;
 final  Map<String, dynamic>? _resolvedData;
@override Map<String, dynamic>? get resolvedData {
  final value = _resolvedData;
  if (value == null) return null;
  if (_resolvedData is EqualUnmodifiableMapView) return _resolvedData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? resolutionComment;
@override@JsonKey() final  ConflictType conflictType;
// Pour les références supprimées, on stocke des informations sur l'entité référencée
@override final  String? referencedEntityType;
// Type de l'entité supprimée (nomenclature, taxon, etc.)
@override final  String? referencedEntityId;
// ID de l'entité supprimée
@override final  String? affectedField;
// Champ affecté par la suppression
@override final  String? navigationPath;
// Chemin de navigation pour résoudre le conflit
@override@JsonKey() final  bool isResolved;
// Indique si le conflit a été géré
@override final  String? resolutionType;
// Comment le conflit a été résolu (ex: "modifié", "supprimé", etc.)
// Nouvelles propriétés pour la gestion améliorée des conflits
@override final  SyncOperation? operation;
// Opération qui a causé le conflit
@override final  String? message;
// Message détaillé du conflit
@override final  ConflictSeverity? severity;
// Sévérité du conflit
@override final  String? localValue;
// Valeur locale spécifique en conflit
@override final  String? remoteValue;
// Valeur distante spécifique en conflit
@override final  int? referencesCount;

/// Create a copy of SyncConflict
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncConflictCopyWith<_SyncConflict> get copyWith => __$SyncConflictCopyWithImpl<_SyncConflict>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncConflict&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&const DeepCollectionEquality().equals(other._localData, _localData)&&const DeepCollectionEquality().equals(other._remoteData, _remoteData)&&(identical(other.localModifiedAt, localModifiedAt) || other.localModifiedAt == localModifiedAt)&&(identical(other.remoteModifiedAt, remoteModifiedAt) || other.remoteModifiedAt == remoteModifiedAt)&&(identical(other.resolutionStrategy, resolutionStrategy) || other.resolutionStrategy == resolutionStrategy)&&const DeepCollectionEquality().equals(other._resolvedData, _resolvedData)&&(identical(other.resolutionComment, resolutionComment) || other.resolutionComment == resolutionComment)&&(identical(other.conflictType, conflictType) || other.conflictType == conflictType)&&(identical(other.referencedEntityType, referencedEntityType) || other.referencedEntityType == referencedEntityType)&&(identical(other.referencedEntityId, referencedEntityId) || other.referencedEntityId == referencedEntityId)&&(identical(other.affectedField, affectedField) || other.affectedField == affectedField)&&(identical(other.navigationPath, navigationPath) || other.navigationPath == navigationPath)&&(identical(other.isResolved, isResolved) || other.isResolved == isResolved)&&(identical(other.resolutionType, resolutionType) || other.resolutionType == resolutionType)&&(identical(other.operation, operation) || other.operation == operation)&&(identical(other.message, message) || other.message == message)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.localValue, localValue) || other.localValue == localValue)&&(identical(other.remoteValue, remoteValue) || other.remoteValue == remoteValue)&&(identical(other.referencesCount, referencesCount) || other.referencesCount == referencesCount));
}


@override
int get hashCode => Object.hashAll([runtimeType,entityId,entityType,const DeepCollectionEquality().hash(_localData),const DeepCollectionEquality().hash(_remoteData),localModifiedAt,remoteModifiedAt,resolutionStrategy,const DeepCollectionEquality().hash(_resolvedData),resolutionComment,conflictType,referencedEntityType,referencedEntityId,affectedField,navigationPath,isResolved,resolutionType,operation,message,severity,localValue,remoteValue,referencesCount]);

@override
String toString() {
  return 'SyncConflict(entityId: $entityId, entityType: $entityType, localData: $localData, remoteData: $remoteData, localModifiedAt: $localModifiedAt, remoteModifiedAt: $remoteModifiedAt, resolutionStrategy: $resolutionStrategy, resolvedData: $resolvedData, resolutionComment: $resolutionComment, conflictType: $conflictType, referencedEntityType: $referencedEntityType, referencedEntityId: $referencedEntityId, affectedField: $affectedField, navigationPath: $navigationPath, isResolved: $isResolved, resolutionType: $resolutionType, operation: $operation, message: $message, severity: $severity, localValue: $localValue, remoteValue: $remoteValue, referencesCount: $referencesCount)';
}


}

/// @nodoc
abstract mixin class _$SyncConflictCopyWith<$Res> implements $SyncConflictCopyWith<$Res> {
  factory _$SyncConflictCopyWith(_SyncConflict value, $Res Function(_SyncConflict) _then) = __$SyncConflictCopyWithImpl;
@override @useResult
$Res call({
 String entityId, String entityType, Map<String, dynamic> localData, Map<String, dynamic> remoteData, DateTime localModifiedAt, DateTime remoteModifiedAt, ConflictResolutionStrategy resolutionStrategy, Map<String, dynamic>? resolvedData, String? resolutionComment, ConflictType conflictType, String? referencedEntityType, String? referencedEntityId, String? affectedField, String? navigationPath, bool isResolved, String? resolutionType, SyncOperation? operation, String? message, ConflictSeverity? severity, String? localValue, String? remoteValue, int? referencesCount
});




}
/// @nodoc
class __$SyncConflictCopyWithImpl<$Res>
    implements _$SyncConflictCopyWith<$Res> {
  __$SyncConflictCopyWithImpl(this._self, this._then);

  final _SyncConflict _self;
  final $Res Function(_SyncConflict) _then;

/// Create a copy of SyncConflict
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entityId = null,Object? entityType = null,Object? localData = null,Object? remoteData = null,Object? localModifiedAt = null,Object? remoteModifiedAt = null,Object? resolutionStrategy = null,Object? resolvedData = freezed,Object? resolutionComment = freezed,Object? conflictType = null,Object? referencedEntityType = freezed,Object? referencedEntityId = freezed,Object? affectedField = freezed,Object? navigationPath = freezed,Object? isResolved = null,Object? resolutionType = freezed,Object? operation = freezed,Object? message = freezed,Object? severity = freezed,Object? localValue = freezed,Object? remoteValue = freezed,Object? referencesCount = freezed,}) {
  return _then(_SyncConflict(
entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,entityType: null == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String,localData: null == localData ? _self._localData : localData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,remoteData: null == remoteData ? _self._remoteData : remoteData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,localModifiedAt: null == localModifiedAt ? _self.localModifiedAt : localModifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime,remoteModifiedAt: null == remoteModifiedAt ? _self.remoteModifiedAt : remoteModifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime,resolutionStrategy: null == resolutionStrategy ? _self.resolutionStrategy : resolutionStrategy // ignore: cast_nullable_to_non_nullable
as ConflictResolutionStrategy,resolvedData: freezed == resolvedData ? _self._resolvedData : resolvedData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,resolutionComment: freezed == resolutionComment ? _self.resolutionComment : resolutionComment // ignore: cast_nullable_to_non_nullable
as String?,conflictType: null == conflictType ? _self.conflictType : conflictType // ignore: cast_nullable_to_non_nullable
as ConflictType,referencedEntityType: freezed == referencedEntityType ? _self.referencedEntityType : referencedEntityType // ignore: cast_nullable_to_non_nullable
as String?,referencedEntityId: freezed == referencedEntityId ? _self.referencedEntityId : referencedEntityId // ignore: cast_nullable_to_non_nullable
as String?,affectedField: freezed == affectedField ? _self.affectedField : affectedField // ignore: cast_nullable_to_non_nullable
as String?,navigationPath: freezed == navigationPath ? _self.navigationPath : navigationPath // ignore: cast_nullable_to_non_nullable
as String?,isResolved: null == isResolved ? _self.isResolved : isResolved // ignore: cast_nullable_to_non_nullable
as bool,resolutionType: freezed == resolutionType ? _self.resolutionType : resolutionType // ignore: cast_nullable_to_non_nullable
as String?,operation: freezed == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as SyncOperation?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,severity: freezed == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as ConflictSeverity?,localValue: freezed == localValue ? _self.localValue : localValue // ignore: cast_nullable_to_non_nullable
as String?,remoteValue: freezed == remoteValue ? _self.remoteValue : remoteValue // ignore: cast_nullable_to_non_nullable
as String?,referencesCount: freezed == referencesCount ? _self.referencesCount : referencesCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
