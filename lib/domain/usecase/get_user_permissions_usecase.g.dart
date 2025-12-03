// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_user_permissions_usecase.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getUserPermissionsUseCaseHash() =>
    r'b456cea27b7b121eff04c14494ad205daadfb651';

/// Use case pour récupérer les permissions de l'utilisateur connecté
/// Simplifié pour l'application mobile avec un seul utilisateur
///
/// Copied from [GetUserPermissionsUseCase].
@ProviderFor(GetUserPermissionsUseCase)
final getUserPermissionsUseCaseProvider = AutoDisposeAsyncNotifierProvider<
    GetUserPermissionsUseCase, UserPermissions?>.internal(
  GetUserPermissionsUseCase.new,
  name: r'getUserPermissionsUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getUserPermissionsUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GetUserPermissionsUseCase
    = AutoDisposeAsyncNotifier<UserPermissions?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
