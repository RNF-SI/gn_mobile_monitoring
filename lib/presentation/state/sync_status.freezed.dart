// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SyncStatus implements DiagnosticableTreeMixin {

 SyncState get state; SyncStep? get currentStep; List<SyncStep> get completedSteps; List<SyncStep> get failedSteps; int get itemsProcessed; int get itemsTotal; double get progress; String? get errorMessage; DateTime? get lastSync; List<SyncConflict>? get conflicts; DateTime get lastUpdated;// Type de synchronisation en cours
 SyncType? get currentSyncType;// Résultats des dernières synchronisations  
// (utilisation de domain.SyncResult temporairement désactivée)
// SyncResult? lastDownstreamSync,
// SyncResult? lastUpstreamSync,
// Détails supplémentaires pour la progression
 String? get currentEntityName;// Nom du module, site, etc. en cours de traitement
 int? get currentEntityTotal;// Nombre total d'éléments à traiter pour l'entité courante
 int? get currentEntityProcessed;// Nombre d'éléments traités pour l'entité courante
 int? get itemsAdded;// Nombre d'éléments ajoutés dans l'étape actuelle
 int? get itemsUpdated;// Nombre d'éléments mis à jour dans l'étape actuelle
 int? get itemsSkipped;// Nombre d'éléments ignorés dans l'étape actuelle
 int? get itemsDeleted;// Nombre d'éléments supprimés dans l'étape actuelle
 String? get additionalInfo;// Informations supplémentaires sur la progression
 String? get nextFullSyncInfo;
/// Create a copy of SyncStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncStatusCopyWith<SyncStatus> get copyWith => _$SyncStatusCopyWithImpl<SyncStatus>(this as SyncStatus, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SyncStatus'))
    ..add(DiagnosticsProperty('state', state))..add(DiagnosticsProperty('currentStep', currentStep))..add(DiagnosticsProperty('completedSteps', completedSteps))..add(DiagnosticsProperty('failedSteps', failedSteps))..add(DiagnosticsProperty('itemsProcessed', itemsProcessed))..add(DiagnosticsProperty('itemsTotal', itemsTotal))..add(DiagnosticsProperty('progress', progress))..add(DiagnosticsProperty('errorMessage', errorMessage))..add(DiagnosticsProperty('lastSync', lastSync))..add(DiagnosticsProperty('conflicts', conflicts))..add(DiagnosticsProperty('lastUpdated', lastUpdated))..add(DiagnosticsProperty('currentSyncType', currentSyncType))..add(DiagnosticsProperty('currentEntityName', currentEntityName))..add(DiagnosticsProperty('currentEntityTotal', currentEntityTotal))..add(DiagnosticsProperty('currentEntityProcessed', currentEntityProcessed))..add(DiagnosticsProperty('itemsAdded', itemsAdded))..add(DiagnosticsProperty('itemsUpdated', itemsUpdated))..add(DiagnosticsProperty('itemsSkipped', itemsSkipped))..add(DiagnosticsProperty('itemsDeleted', itemsDeleted))..add(DiagnosticsProperty('additionalInfo', additionalInfo))..add(DiagnosticsProperty('nextFullSyncInfo', nextFullSyncInfo));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncStatus&&(identical(other.state, state) || other.state == state)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&const DeepCollectionEquality().equals(other.completedSteps, completedSteps)&&const DeepCollectionEquality().equals(other.failedSteps, failedSteps)&&(identical(other.itemsProcessed, itemsProcessed) || other.itemsProcessed == itemsProcessed)&&(identical(other.itemsTotal, itemsTotal) || other.itemsTotal == itemsTotal)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.lastSync, lastSync) || other.lastSync == lastSync)&&const DeepCollectionEquality().equals(other.conflicts, conflicts)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.currentSyncType, currentSyncType) || other.currentSyncType == currentSyncType)&&(identical(other.currentEntityName, currentEntityName) || other.currentEntityName == currentEntityName)&&(identical(other.currentEntityTotal, currentEntityTotal) || other.currentEntityTotal == currentEntityTotal)&&(identical(other.currentEntityProcessed, currentEntityProcessed) || other.currentEntityProcessed == currentEntityProcessed)&&(identical(other.itemsAdded, itemsAdded) || other.itemsAdded == itemsAdded)&&(identical(other.itemsUpdated, itemsUpdated) || other.itemsUpdated == itemsUpdated)&&(identical(other.itemsSkipped, itemsSkipped) || other.itemsSkipped == itemsSkipped)&&(identical(other.itemsDeleted, itemsDeleted) || other.itemsDeleted == itemsDeleted)&&(identical(other.additionalInfo, additionalInfo) || other.additionalInfo == additionalInfo)&&(identical(other.nextFullSyncInfo, nextFullSyncInfo) || other.nextFullSyncInfo == nextFullSyncInfo));
}


@override
int get hashCode => Object.hashAll([runtimeType,state,currentStep,const DeepCollectionEquality().hash(completedSteps),const DeepCollectionEquality().hash(failedSteps),itemsProcessed,itemsTotal,progress,errorMessage,lastSync,const DeepCollectionEquality().hash(conflicts),lastUpdated,currentSyncType,currentEntityName,currentEntityTotal,currentEntityProcessed,itemsAdded,itemsUpdated,itemsSkipped,itemsDeleted,additionalInfo,nextFullSyncInfo]);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SyncStatus(state: $state, currentStep: $currentStep, completedSteps: $completedSteps, failedSteps: $failedSteps, itemsProcessed: $itemsProcessed, itemsTotal: $itemsTotal, progress: $progress, errorMessage: $errorMessage, lastSync: $lastSync, conflicts: $conflicts, lastUpdated: $lastUpdated, currentSyncType: $currentSyncType, currentEntityName: $currentEntityName, currentEntityTotal: $currentEntityTotal, currentEntityProcessed: $currentEntityProcessed, itemsAdded: $itemsAdded, itemsUpdated: $itemsUpdated, itemsSkipped: $itemsSkipped, itemsDeleted: $itemsDeleted, additionalInfo: $additionalInfo, nextFullSyncInfo: $nextFullSyncInfo)';
}


}

/// @nodoc
abstract mixin class $SyncStatusCopyWith<$Res>  {
  factory $SyncStatusCopyWith(SyncStatus value, $Res Function(SyncStatus) _then) = _$SyncStatusCopyWithImpl;
@useResult
$Res call({
 SyncState state, SyncStep? currentStep, List<SyncStep> completedSteps, List<SyncStep> failedSteps, int itemsProcessed, int itemsTotal, double progress, String? errorMessage, DateTime? lastSync, List<SyncConflict>? conflicts, DateTime lastUpdated, SyncType? currentSyncType, String? currentEntityName, int? currentEntityTotal, int? currentEntityProcessed, int? itemsAdded, int? itemsUpdated, int? itemsSkipped, int? itemsDeleted, String? additionalInfo, String? nextFullSyncInfo
});




}
/// @nodoc
class _$SyncStatusCopyWithImpl<$Res>
    implements $SyncStatusCopyWith<$Res> {
  _$SyncStatusCopyWithImpl(this._self, this._then);

  final SyncStatus _self;
  final $Res Function(SyncStatus) _then;

/// Create a copy of SyncStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? state = null,Object? currentStep = freezed,Object? completedSteps = null,Object? failedSteps = null,Object? itemsProcessed = null,Object? itemsTotal = null,Object? progress = null,Object? errorMessage = freezed,Object? lastSync = freezed,Object? conflicts = freezed,Object? lastUpdated = null,Object? currentSyncType = freezed,Object? currentEntityName = freezed,Object? currentEntityTotal = freezed,Object? currentEntityProcessed = freezed,Object? itemsAdded = freezed,Object? itemsUpdated = freezed,Object? itemsSkipped = freezed,Object? itemsDeleted = freezed,Object? additionalInfo = freezed,Object? nextFullSyncInfo = freezed,}) {
  return _then(_self.copyWith(
state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as SyncState,currentStep: freezed == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as SyncStep?,completedSteps: null == completedSteps ? _self.completedSteps : completedSteps // ignore: cast_nullable_to_non_nullable
as List<SyncStep>,failedSteps: null == failedSteps ? _self.failedSteps : failedSteps // ignore: cast_nullable_to_non_nullable
as List<SyncStep>,itemsProcessed: null == itemsProcessed ? _self.itemsProcessed : itemsProcessed // ignore: cast_nullable_to_non_nullable
as int,itemsTotal: null == itemsTotal ? _self.itemsTotal : itemsTotal // ignore: cast_nullable_to_non_nullable
as int,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,lastSync: freezed == lastSync ? _self.lastSync : lastSync // ignore: cast_nullable_to_non_nullable
as DateTime?,conflicts: freezed == conflicts ? _self.conflicts : conflicts // ignore: cast_nullable_to_non_nullable
as List<SyncConflict>?,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,currentSyncType: freezed == currentSyncType ? _self.currentSyncType : currentSyncType // ignore: cast_nullable_to_non_nullable
as SyncType?,currentEntityName: freezed == currentEntityName ? _self.currentEntityName : currentEntityName // ignore: cast_nullable_to_non_nullable
as String?,currentEntityTotal: freezed == currentEntityTotal ? _self.currentEntityTotal : currentEntityTotal // ignore: cast_nullable_to_non_nullable
as int?,currentEntityProcessed: freezed == currentEntityProcessed ? _self.currentEntityProcessed : currentEntityProcessed // ignore: cast_nullable_to_non_nullable
as int?,itemsAdded: freezed == itemsAdded ? _self.itemsAdded : itemsAdded // ignore: cast_nullable_to_non_nullable
as int?,itemsUpdated: freezed == itemsUpdated ? _self.itemsUpdated : itemsUpdated // ignore: cast_nullable_to_non_nullable
as int?,itemsSkipped: freezed == itemsSkipped ? _self.itemsSkipped : itemsSkipped // ignore: cast_nullable_to_non_nullable
as int?,itemsDeleted: freezed == itemsDeleted ? _self.itemsDeleted : itemsDeleted // ignore: cast_nullable_to_non_nullable
as int?,additionalInfo: freezed == additionalInfo ? _self.additionalInfo : additionalInfo // ignore: cast_nullable_to_non_nullable
as String?,nextFullSyncInfo: freezed == nextFullSyncInfo ? _self.nextFullSyncInfo : nextFullSyncInfo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncStatus].
extension SyncStatusPatterns on SyncStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncStatus value)  $default,){
final _that = this;
switch (_that) {
case _SyncStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncStatus value)?  $default,){
final _that = this;
switch (_that) {
case _SyncStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SyncState state,  SyncStep? currentStep,  List<SyncStep> completedSteps,  List<SyncStep> failedSteps,  int itemsProcessed,  int itemsTotal,  double progress,  String? errorMessage,  DateTime? lastSync,  List<SyncConflict>? conflicts,  DateTime lastUpdated,  SyncType? currentSyncType,  String? currentEntityName,  int? currentEntityTotal,  int? currentEntityProcessed,  int? itemsAdded,  int? itemsUpdated,  int? itemsSkipped,  int? itemsDeleted,  String? additionalInfo,  String? nextFullSyncInfo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncStatus() when $default != null:
return $default(_that.state,_that.currentStep,_that.completedSteps,_that.failedSteps,_that.itemsProcessed,_that.itemsTotal,_that.progress,_that.errorMessage,_that.lastSync,_that.conflicts,_that.lastUpdated,_that.currentSyncType,_that.currentEntityName,_that.currentEntityTotal,_that.currentEntityProcessed,_that.itemsAdded,_that.itemsUpdated,_that.itemsSkipped,_that.itemsDeleted,_that.additionalInfo,_that.nextFullSyncInfo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SyncState state,  SyncStep? currentStep,  List<SyncStep> completedSteps,  List<SyncStep> failedSteps,  int itemsProcessed,  int itemsTotal,  double progress,  String? errorMessage,  DateTime? lastSync,  List<SyncConflict>? conflicts,  DateTime lastUpdated,  SyncType? currentSyncType,  String? currentEntityName,  int? currentEntityTotal,  int? currentEntityProcessed,  int? itemsAdded,  int? itemsUpdated,  int? itemsSkipped,  int? itemsDeleted,  String? additionalInfo,  String? nextFullSyncInfo)  $default,) {final _that = this;
switch (_that) {
case _SyncStatus():
return $default(_that.state,_that.currentStep,_that.completedSteps,_that.failedSteps,_that.itemsProcessed,_that.itemsTotal,_that.progress,_that.errorMessage,_that.lastSync,_that.conflicts,_that.lastUpdated,_that.currentSyncType,_that.currentEntityName,_that.currentEntityTotal,_that.currentEntityProcessed,_that.itemsAdded,_that.itemsUpdated,_that.itemsSkipped,_that.itemsDeleted,_that.additionalInfo,_that.nextFullSyncInfo);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SyncState state,  SyncStep? currentStep,  List<SyncStep> completedSteps,  List<SyncStep> failedSteps,  int itemsProcessed,  int itemsTotal,  double progress,  String? errorMessage,  DateTime? lastSync,  List<SyncConflict>? conflicts,  DateTime lastUpdated,  SyncType? currentSyncType,  String? currentEntityName,  int? currentEntityTotal,  int? currentEntityProcessed,  int? itemsAdded,  int? itemsUpdated,  int? itemsSkipped,  int? itemsDeleted,  String? additionalInfo,  String? nextFullSyncInfo)?  $default,) {final _that = this;
switch (_that) {
case _SyncStatus() when $default != null:
return $default(_that.state,_that.currentStep,_that.completedSteps,_that.failedSteps,_that.itemsProcessed,_that.itemsTotal,_that.progress,_that.errorMessage,_that.lastSync,_that.conflicts,_that.lastUpdated,_that.currentSyncType,_that.currentEntityName,_that.currentEntityTotal,_that.currentEntityProcessed,_that.itemsAdded,_that.itemsUpdated,_that.itemsSkipped,_that.itemsDeleted,_that.additionalInfo,_that.nextFullSyncInfo);case _:
  return null;

}
}

}

/// @nodoc


class _SyncStatus extends SyncStatus with DiagnosticableTreeMixin {
  const _SyncStatus({required this.state, required this.currentStep, required final  List<SyncStep> completedSteps, required final  List<SyncStep> failedSteps, required this.itemsProcessed, required this.itemsTotal, required this.progress, this.errorMessage, this.lastSync, final  List<SyncConflict>? conflicts, required this.lastUpdated, this.currentSyncType, this.currentEntityName, this.currentEntityTotal, this.currentEntityProcessed, this.itemsAdded, this.itemsUpdated, this.itemsSkipped, this.itemsDeleted, this.additionalInfo, this.nextFullSyncInfo}): _completedSteps = completedSteps,_failedSteps = failedSteps,_conflicts = conflicts,super._();
  

@override final  SyncState state;
@override final  SyncStep? currentStep;
 final  List<SyncStep> _completedSteps;
@override List<SyncStep> get completedSteps {
  if (_completedSteps is EqualUnmodifiableListView) return _completedSteps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_completedSteps);
}

 final  List<SyncStep> _failedSteps;
@override List<SyncStep> get failedSteps {
  if (_failedSteps is EqualUnmodifiableListView) return _failedSteps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_failedSteps);
}

@override final  int itemsProcessed;
@override final  int itemsTotal;
@override final  double progress;
@override final  String? errorMessage;
@override final  DateTime? lastSync;
 final  List<SyncConflict>? _conflicts;
@override List<SyncConflict>? get conflicts {
  final value = _conflicts;
  if (value == null) return null;
  if (_conflicts is EqualUnmodifiableListView) return _conflicts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  DateTime lastUpdated;
// Type de synchronisation en cours
@override final  SyncType? currentSyncType;
// Résultats des dernières synchronisations  
// (utilisation de domain.SyncResult temporairement désactivée)
// SyncResult? lastDownstreamSync,
// SyncResult? lastUpstreamSync,
// Détails supplémentaires pour la progression
@override final  String? currentEntityName;
// Nom du module, site, etc. en cours de traitement
@override final  int? currentEntityTotal;
// Nombre total d'éléments à traiter pour l'entité courante
@override final  int? currentEntityProcessed;
// Nombre d'éléments traités pour l'entité courante
@override final  int? itemsAdded;
// Nombre d'éléments ajoutés dans l'étape actuelle
@override final  int? itemsUpdated;
// Nombre d'éléments mis à jour dans l'étape actuelle
@override final  int? itemsSkipped;
// Nombre d'éléments ignorés dans l'étape actuelle
@override final  int? itemsDeleted;
// Nombre d'éléments supprimés dans l'étape actuelle
@override final  String? additionalInfo;
// Informations supplémentaires sur la progression
@override final  String? nextFullSyncInfo;

/// Create a copy of SyncStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncStatusCopyWith<_SyncStatus> get copyWith => __$SyncStatusCopyWithImpl<_SyncStatus>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SyncStatus'))
    ..add(DiagnosticsProperty('state', state))..add(DiagnosticsProperty('currentStep', currentStep))..add(DiagnosticsProperty('completedSteps', completedSteps))..add(DiagnosticsProperty('failedSteps', failedSteps))..add(DiagnosticsProperty('itemsProcessed', itemsProcessed))..add(DiagnosticsProperty('itemsTotal', itemsTotal))..add(DiagnosticsProperty('progress', progress))..add(DiagnosticsProperty('errorMessage', errorMessage))..add(DiagnosticsProperty('lastSync', lastSync))..add(DiagnosticsProperty('conflicts', conflicts))..add(DiagnosticsProperty('lastUpdated', lastUpdated))..add(DiagnosticsProperty('currentSyncType', currentSyncType))..add(DiagnosticsProperty('currentEntityName', currentEntityName))..add(DiagnosticsProperty('currentEntityTotal', currentEntityTotal))..add(DiagnosticsProperty('currentEntityProcessed', currentEntityProcessed))..add(DiagnosticsProperty('itemsAdded', itemsAdded))..add(DiagnosticsProperty('itemsUpdated', itemsUpdated))..add(DiagnosticsProperty('itemsSkipped', itemsSkipped))..add(DiagnosticsProperty('itemsDeleted', itemsDeleted))..add(DiagnosticsProperty('additionalInfo', additionalInfo))..add(DiagnosticsProperty('nextFullSyncInfo', nextFullSyncInfo));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncStatus&&(identical(other.state, state) || other.state == state)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&const DeepCollectionEquality().equals(other._completedSteps, _completedSteps)&&const DeepCollectionEquality().equals(other._failedSteps, _failedSteps)&&(identical(other.itemsProcessed, itemsProcessed) || other.itemsProcessed == itemsProcessed)&&(identical(other.itemsTotal, itemsTotal) || other.itemsTotal == itemsTotal)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.lastSync, lastSync) || other.lastSync == lastSync)&&const DeepCollectionEquality().equals(other._conflicts, _conflicts)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.currentSyncType, currentSyncType) || other.currentSyncType == currentSyncType)&&(identical(other.currentEntityName, currentEntityName) || other.currentEntityName == currentEntityName)&&(identical(other.currentEntityTotal, currentEntityTotal) || other.currentEntityTotal == currentEntityTotal)&&(identical(other.currentEntityProcessed, currentEntityProcessed) || other.currentEntityProcessed == currentEntityProcessed)&&(identical(other.itemsAdded, itemsAdded) || other.itemsAdded == itemsAdded)&&(identical(other.itemsUpdated, itemsUpdated) || other.itemsUpdated == itemsUpdated)&&(identical(other.itemsSkipped, itemsSkipped) || other.itemsSkipped == itemsSkipped)&&(identical(other.itemsDeleted, itemsDeleted) || other.itemsDeleted == itemsDeleted)&&(identical(other.additionalInfo, additionalInfo) || other.additionalInfo == additionalInfo)&&(identical(other.nextFullSyncInfo, nextFullSyncInfo) || other.nextFullSyncInfo == nextFullSyncInfo));
}


@override
int get hashCode => Object.hashAll([runtimeType,state,currentStep,const DeepCollectionEquality().hash(_completedSteps),const DeepCollectionEquality().hash(_failedSteps),itemsProcessed,itemsTotal,progress,errorMessage,lastSync,const DeepCollectionEquality().hash(_conflicts),lastUpdated,currentSyncType,currentEntityName,currentEntityTotal,currentEntityProcessed,itemsAdded,itemsUpdated,itemsSkipped,itemsDeleted,additionalInfo,nextFullSyncInfo]);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SyncStatus(state: $state, currentStep: $currentStep, completedSteps: $completedSteps, failedSteps: $failedSteps, itemsProcessed: $itemsProcessed, itemsTotal: $itemsTotal, progress: $progress, errorMessage: $errorMessage, lastSync: $lastSync, conflicts: $conflicts, lastUpdated: $lastUpdated, currentSyncType: $currentSyncType, currentEntityName: $currentEntityName, currentEntityTotal: $currentEntityTotal, currentEntityProcessed: $currentEntityProcessed, itemsAdded: $itemsAdded, itemsUpdated: $itemsUpdated, itemsSkipped: $itemsSkipped, itemsDeleted: $itemsDeleted, additionalInfo: $additionalInfo, nextFullSyncInfo: $nextFullSyncInfo)';
}


}

/// @nodoc
abstract mixin class _$SyncStatusCopyWith<$Res> implements $SyncStatusCopyWith<$Res> {
  factory _$SyncStatusCopyWith(_SyncStatus value, $Res Function(_SyncStatus) _then) = __$SyncStatusCopyWithImpl;
@override @useResult
$Res call({
 SyncState state, SyncStep? currentStep, List<SyncStep> completedSteps, List<SyncStep> failedSteps, int itemsProcessed, int itemsTotal, double progress, String? errorMessage, DateTime? lastSync, List<SyncConflict>? conflicts, DateTime lastUpdated, SyncType? currentSyncType, String? currentEntityName, int? currentEntityTotal, int? currentEntityProcessed, int? itemsAdded, int? itemsUpdated, int? itemsSkipped, int? itemsDeleted, String? additionalInfo, String? nextFullSyncInfo
});




}
/// @nodoc
class __$SyncStatusCopyWithImpl<$Res>
    implements _$SyncStatusCopyWith<$Res> {
  __$SyncStatusCopyWithImpl(this._self, this._then);

  final _SyncStatus _self;
  final $Res Function(_SyncStatus) _then;

/// Create a copy of SyncStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? state = null,Object? currentStep = freezed,Object? completedSteps = null,Object? failedSteps = null,Object? itemsProcessed = null,Object? itemsTotal = null,Object? progress = null,Object? errorMessage = freezed,Object? lastSync = freezed,Object? conflicts = freezed,Object? lastUpdated = null,Object? currentSyncType = freezed,Object? currentEntityName = freezed,Object? currentEntityTotal = freezed,Object? currentEntityProcessed = freezed,Object? itemsAdded = freezed,Object? itemsUpdated = freezed,Object? itemsSkipped = freezed,Object? itemsDeleted = freezed,Object? additionalInfo = freezed,Object? nextFullSyncInfo = freezed,}) {
  return _then(_SyncStatus(
state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as SyncState,currentStep: freezed == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as SyncStep?,completedSteps: null == completedSteps ? _self._completedSteps : completedSteps // ignore: cast_nullable_to_non_nullable
as List<SyncStep>,failedSteps: null == failedSteps ? _self._failedSteps : failedSteps // ignore: cast_nullable_to_non_nullable
as List<SyncStep>,itemsProcessed: null == itemsProcessed ? _self.itemsProcessed : itemsProcessed // ignore: cast_nullable_to_non_nullable
as int,itemsTotal: null == itemsTotal ? _self.itemsTotal : itemsTotal // ignore: cast_nullable_to_non_nullable
as int,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,lastSync: freezed == lastSync ? _self.lastSync : lastSync // ignore: cast_nullable_to_non_nullable
as DateTime?,conflicts: freezed == conflicts ? _self._conflicts : conflicts // ignore: cast_nullable_to_non_nullable
as List<SyncConflict>?,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,currentSyncType: freezed == currentSyncType ? _self.currentSyncType : currentSyncType // ignore: cast_nullable_to_non_nullable
as SyncType?,currentEntityName: freezed == currentEntityName ? _self.currentEntityName : currentEntityName // ignore: cast_nullable_to_non_nullable
as String?,currentEntityTotal: freezed == currentEntityTotal ? _self.currentEntityTotal : currentEntityTotal // ignore: cast_nullable_to_non_nullable
as int?,currentEntityProcessed: freezed == currentEntityProcessed ? _self.currentEntityProcessed : currentEntityProcessed // ignore: cast_nullable_to_non_nullable
as int?,itemsAdded: freezed == itemsAdded ? _self.itemsAdded : itemsAdded // ignore: cast_nullable_to_non_nullable
as int?,itemsUpdated: freezed == itemsUpdated ? _self.itemsUpdated : itemsUpdated // ignore: cast_nullable_to_non_nullable
as int?,itemsSkipped: freezed == itemsSkipped ? _self.itemsSkipped : itemsSkipped // ignore: cast_nullable_to_non_nullable
as int?,itemsDeleted: freezed == itemsDeleted ? _self.itemsDeleted : itemsDeleted // ignore: cast_nullable_to_non_nullable
as int?,additionalInfo: freezed == additionalInfo ? _self.additionalInfo : additionalInfo // ignore: cast_nullable_to_non_nullable
as String?,nextFullSyncInfo: freezed == nextFullSyncInfo ? _self.nextFullSyncInfo : nextFullSyncInfo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
