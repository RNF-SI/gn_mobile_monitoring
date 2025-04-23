// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SyncResult {
  bool get success => throw _privateConstructorUsedError;
  int get itemsProcessed => throw _privateConstructorUsedError;
  int get itemsAdded => throw _privateConstructorUsedError;
  int get itemsUpdated => throw _privateConstructorUsedError;
  int get itemsSkipped => throw _privateConstructorUsedError;
  int get itemsFailed => throw _privateConstructorUsedError;
  DateTime get syncTime => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  List<SyncConflict>? get conflicts => throw _privateConstructorUsedError;

  /// Create a copy of SyncResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncResultCopyWith<SyncResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncResultCopyWith<$Res> {
  factory $SyncResultCopyWith(
          SyncResult value, $Res Function(SyncResult) then) =
      _$SyncResultCopyWithImpl<$Res, SyncResult>;
  @useResult
  $Res call(
      {bool success,
      int itemsProcessed,
      int itemsAdded,
      int itemsUpdated,
      int itemsSkipped,
      int itemsFailed,
      DateTime syncTime,
      String? errorMessage,
      List<SyncConflict>? conflicts});
}

/// @nodoc
class _$SyncResultCopyWithImpl<$Res, $Val extends SyncResult>
    implements $SyncResultCopyWith<$Res> {
  _$SyncResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? itemsProcessed = null,
    Object? itemsAdded = null,
    Object? itemsUpdated = null,
    Object? itemsSkipped = null,
    Object? itemsFailed = null,
    Object? syncTime = null,
    Object? errorMessage = freezed,
    Object? conflicts = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      itemsProcessed: null == itemsProcessed
          ? _value.itemsProcessed
          : itemsProcessed // ignore: cast_nullable_to_non_nullable
              as int,
      itemsAdded: null == itemsAdded
          ? _value.itemsAdded
          : itemsAdded // ignore: cast_nullable_to_non_nullable
              as int,
      itemsUpdated: null == itemsUpdated
          ? _value.itemsUpdated
          : itemsUpdated // ignore: cast_nullable_to_non_nullable
              as int,
      itemsSkipped: null == itemsSkipped
          ? _value.itemsSkipped
          : itemsSkipped // ignore: cast_nullable_to_non_nullable
              as int,
      itemsFailed: null == itemsFailed
          ? _value.itemsFailed
          : itemsFailed // ignore: cast_nullable_to_non_nullable
              as int,
      syncTime: null == syncTime
          ? _value.syncTime
          : syncTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      conflicts: freezed == conflicts
          ? _value.conflicts
          : conflicts // ignore: cast_nullable_to_non_nullable
              as List<SyncConflict>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SyncResultImplCopyWith<$Res>
    implements $SyncResultCopyWith<$Res> {
  factory _$$SyncResultImplCopyWith(
          _$SyncResultImpl value, $Res Function(_$SyncResultImpl) then) =
      __$$SyncResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      int itemsProcessed,
      int itemsAdded,
      int itemsUpdated,
      int itemsSkipped,
      int itemsFailed,
      DateTime syncTime,
      String? errorMessage,
      List<SyncConflict>? conflicts});
}

/// @nodoc
class __$$SyncResultImplCopyWithImpl<$Res>
    extends _$SyncResultCopyWithImpl<$Res, _$SyncResultImpl>
    implements _$$SyncResultImplCopyWith<$Res> {
  __$$SyncResultImplCopyWithImpl(
      _$SyncResultImpl _value, $Res Function(_$SyncResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? itemsProcessed = null,
    Object? itemsAdded = null,
    Object? itemsUpdated = null,
    Object? itemsSkipped = null,
    Object? itemsFailed = null,
    Object? syncTime = null,
    Object? errorMessage = freezed,
    Object? conflicts = freezed,
  }) {
    return _then(_$SyncResultImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      itemsProcessed: null == itemsProcessed
          ? _value.itemsProcessed
          : itemsProcessed // ignore: cast_nullable_to_non_nullable
              as int,
      itemsAdded: null == itemsAdded
          ? _value.itemsAdded
          : itemsAdded // ignore: cast_nullable_to_non_nullable
              as int,
      itemsUpdated: null == itemsUpdated
          ? _value.itemsUpdated
          : itemsUpdated // ignore: cast_nullable_to_non_nullable
              as int,
      itemsSkipped: null == itemsSkipped
          ? _value.itemsSkipped
          : itemsSkipped // ignore: cast_nullable_to_non_nullable
              as int,
      itemsFailed: null == itemsFailed
          ? _value.itemsFailed
          : itemsFailed // ignore: cast_nullable_to_non_nullable
              as int,
      syncTime: null == syncTime
          ? _value.syncTime
          : syncTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      conflicts: freezed == conflicts
          ? _value._conflicts
          : conflicts // ignore: cast_nullable_to_non_nullable
              as List<SyncConflict>?,
    ));
  }
}

/// @nodoc

class _$SyncResultImpl implements _SyncResult {
  const _$SyncResultImpl(
      {required this.success,
      required this.itemsProcessed,
      required this.itemsAdded,
      required this.itemsUpdated,
      required this.itemsSkipped,
      required this.itemsFailed,
      required this.syncTime,
      this.errorMessage,
      final List<SyncConflict>? conflicts})
      : _conflicts = conflicts;

  @override
  final bool success;
  @override
  final int itemsProcessed;
  @override
  final int itemsAdded;
  @override
  final int itemsUpdated;
  @override
  final int itemsSkipped;
  @override
  final int itemsFailed;
  @override
  final DateTime syncTime;
  @override
  final String? errorMessage;
  final List<SyncConflict>? _conflicts;
  @override
  List<SyncConflict>? get conflicts {
    final value = _conflicts;
    if (value == null) return null;
    if (_conflicts is EqualUnmodifiableListView) return _conflicts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'SyncResult(success: $success, itemsProcessed: $itemsProcessed, itemsAdded: $itemsAdded, itemsUpdated: $itemsUpdated, itemsSkipped: $itemsSkipped, itemsFailed: $itemsFailed, syncTime: $syncTime, errorMessage: $errorMessage, conflicts: $conflicts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncResultImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.itemsProcessed, itemsProcessed) ||
                other.itemsProcessed == itemsProcessed) &&
            (identical(other.itemsAdded, itemsAdded) ||
                other.itemsAdded == itemsAdded) &&
            (identical(other.itemsUpdated, itemsUpdated) ||
                other.itemsUpdated == itemsUpdated) &&
            (identical(other.itemsSkipped, itemsSkipped) ||
                other.itemsSkipped == itemsSkipped) &&
            (identical(other.itemsFailed, itemsFailed) ||
                other.itemsFailed == itemsFailed) &&
            (identical(other.syncTime, syncTime) ||
                other.syncTime == syncTime) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality()
                .equals(other._conflicts, _conflicts));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      success,
      itemsProcessed,
      itemsAdded,
      itemsUpdated,
      itemsSkipped,
      itemsFailed,
      syncTime,
      errorMessage,
      const DeepCollectionEquality().hash(_conflicts));

  /// Create a copy of SyncResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncResultImplCopyWith<_$SyncResultImpl> get copyWith =>
      __$$SyncResultImplCopyWithImpl<_$SyncResultImpl>(this, _$identity);
}

abstract class _SyncResult implements SyncResult {
  const factory _SyncResult(
      {required final bool success,
      required final int itemsProcessed,
      required final int itemsAdded,
      required final int itemsUpdated,
      required final int itemsSkipped,
      required final int itemsFailed,
      required final DateTime syncTime,
      final String? errorMessage,
      final List<SyncConflict>? conflicts}) = _$SyncResultImpl;

  @override
  bool get success;
  @override
  int get itemsProcessed;
  @override
  int get itemsAdded;
  @override
  int get itemsUpdated;
  @override
  int get itemsSkipped;
  @override
  int get itemsFailed;
  @override
  DateTime get syncTime;
  @override
  String? get errorMessage;
  @override
  List<SyncConflict>? get conflicts;

  /// Create a copy of SyncResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncResultImplCopyWith<_$SyncResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
