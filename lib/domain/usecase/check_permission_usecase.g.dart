// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_permission_usecase.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$checkPermissionUseCaseHash() =>
    r'26f9291c5eabb71a5e6e054eda34399f89849a90';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$CheckPermissionUseCase
    extends BuildlessAutoDisposeAsyncNotifier<bool> {
  late final int idModule;
  late final String objectCode;
  late final String actionCode;

  FutureOr<bool> build(
    int idModule,
    String objectCode,
    String actionCode,
  );
}

/// See also [CheckPermissionUseCase].
@ProviderFor(CheckPermissionUseCase)
const checkPermissionUseCaseProvider = CheckPermissionUseCaseFamily();

/// See also [CheckPermissionUseCase].
class CheckPermissionUseCaseFamily extends Family<AsyncValue<bool>> {
  /// See also [CheckPermissionUseCase].
  const CheckPermissionUseCaseFamily();

  /// See also [CheckPermissionUseCase].
  CheckPermissionUseCaseProvider call(
    int idModule,
    String objectCode,
    String actionCode,
  ) {
    return CheckPermissionUseCaseProvider(
      idModule,
      objectCode,
      actionCode,
    );
  }

  @override
  CheckPermissionUseCaseProvider getProviderOverride(
    covariant CheckPermissionUseCaseProvider provider,
  ) {
    return call(
      provider.idModule,
      provider.objectCode,
      provider.actionCode,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'checkPermissionUseCaseProvider';
}

/// See also [CheckPermissionUseCase].
class CheckPermissionUseCaseProvider
    extends AutoDisposeAsyncNotifierProviderImpl<CheckPermissionUseCase, bool> {
  /// See also [CheckPermissionUseCase].
  CheckPermissionUseCaseProvider(
    int idModule,
    String objectCode,
    String actionCode,
  ) : this._internal(
          () => CheckPermissionUseCase()
            ..idModule = idModule
            ..objectCode = objectCode
            ..actionCode = actionCode,
          from: checkPermissionUseCaseProvider,
          name: r'checkPermissionUseCaseProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$checkPermissionUseCaseHash,
          dependencies: CheckPermissionUseCaseFamily._dependencies,
          allTransitiveDependencies:
              CheckPermissionUseCaseFamily._allTransitiveDependencies,
          idModule: idModule,
          objectCode: objectCode,
          actionCode: actionCode,
        );

  CheckPermissionUseCaseProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.idModule,
    required this.objectCode,
    required this.actionCode,
  }) : super.internal();

  final int idModule;
  final String objectCode;
  final String actionCode;

  @override
  FutureOr<bool> runNotifierBuild(
    covariant CheckPermissionUseCase notifier,
  ) {
    return notifier.build(
      idModule,
      objectCode,
      actionCode,
    );
  }

  @override
  Override overrideWith(CheckPermissionUseCase Function() create) {
    return ProviderOverride(
      origin: this,
      override: CheckPermissionUseCaseProvider._internal(
        () => create()
          ..idModule = idModule
          ..objectCode = objectCode
          ..actionCode = actionCode,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        idModule: idModule,
        objectCode: objectCode,
        actionCode: actionCode,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<CheckPermissionUseCase, bool>
      createElement() {
    return _CheckPermissionUseCaseProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CheckPermissionUseCaseProvider &&
        other.idModule == idModule &&
        other.objectCode == objectCode &&
        other.actionCode == actionCode;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, idModule.hashCode);
    hash = _SystemHash.combine(hash, objectCode.hashCode);
    hash = _SystemHash.combine(hash, actionCode.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CheckPermissionUseCaseRef on AutoDisposeAsyncNotifierProviderRef<bool> {
  /// The parameter `idModule` of this provider.
  int get idModule;

  /// The parameter `objectCode` of this provider.
  String get objectCode;

  /// The parameter `actionCode` of this provider.
  String get actionCode;
}

class _CheckPermissionUseCaseProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<CheckPermissionUseCase,
        bool> with CheckPermissionUseCaseRef {
  _CheckPermissionUseCaseProviderElement(super.provider);

  @override
  int get idModule => (origin as CheckPermissionUseCaseProvider).idModule;
  @override
  String get objectCode =>
      (origin as CheckPermissionUseCaseProvider).objectCode;
  @override
  String get actionCode =>
      (origin as CheckPermissionUseCaseProvider).actionCode;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
