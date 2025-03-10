import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/user.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_token_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_user_name_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_modules_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_site_groups_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_sites_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_modules_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_modules_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_site_groups_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_sites_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/login_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_is_logged_in_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_token_from_local_storage_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_user_name_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/state/login_status.dart';
import 'package:gn_mobile_monitoring/presentation/state/state.dart'
    as loadingState;
import 'package:gn_mobile_monitoring/presentation/view/auth_checker.dart';
import 'package:go_router/go_router.dart';

// Pour le Checker
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(authenticationViewModelProvider).authStateChange;
});

// Pour suivre le statut de connexion
final loginStatusProvider = StateProvider<LoginStatusInfo>((ref) {
  return LoginStatusInfo.initial;
});

final authenticationViewModelProvider =
    Provider<AuthenticationViewModel>((ref) {
  return AuthenticationViewModel(
    ref.watch(loginUseCaseProvider),
    ref.watch(setIsLoggedInFromLocalStorageUseCaseProvider),
    ref.watch(setUserIdFromLocalStorageUseCaseProvider),
    ref.watch(setUserNameFromLocalStorageUseCaseProvider),
    ref.watch(setTokenFromLocalStorageUseCaseProvider),
    ref.watch(clearUserIdFromLocalStorageUseCaseProvider),
    ref.watch(clearUserNameFromLocalStorageUseCaseProvider),
    ref.watch(clearTokenFromLocalStorageUseCaseProvider),
    ref.watch(fetchModulesUseCaseProvider),
    ref.watch(fetchSitesUseCaseProvider),
    ref.watch(fetchSiteGroupsUseCaseProvider),
    ref,
  );
});

class AuthenticationViewModel extends StateNotifier<loadingState.State<User>> {
  final _email = '';
  final _password = '';

  User? user;

  StreamController<User?> controller = StreamController<User?>();

  final LoginUseCase _loginUseCase;
  final SetUserIdFromLocalStorageUseCase _setUserIdFromLocalStorageUseCase;
  final SetUserNameFromLocalStorageUseCase _setUserNameFromLocalStorageUseCase;
  final SetIsLoggedInFromLocalStorageUseCase
      _setIsLoggedInFromLocalStorageUseCase;
  final SetTokenFromLocalStorageUseCase _setTokenFromLocalStorageUseCase;
  final ClearUserIdFromLocalStorageUseCase _clearUserIdFromLocalStorageUseCase;
  final ClearUserNameFromLocalStorageUseCase
      _clearUserNameFromLocalStorageUseCase;
  final ClearTokenFromLocalStorageUseCase _clearTokenFromLocalStorageUseCase;
  final FetchModulesUseCase _fetchModulesUseCase;
  final FetchSitesUseCase _fetchSitesUseCase;
  final FetchSiteGroupsUseCase _fetchSiteGroupsUseCase;
  final Ref _ref;

  AuthenticationViewModel(
    this._loginUseCase,
    this._setIsLoggedInFromLocalStorageUseCase,
    this._setUserIdFromLocalStorageUseCase,
    this._setUserNameFromLocalStorageUseCase,
    this._setTokenFromLocalStorageUseCase,
    this._clearUserIdFromLocalStorageUseCase,
    this._clearUserNameFromLocalStorageUseCase,
    this._clearTokenFromLocalStorageUseCase,
    this._fetchModulesUseCase,
    this._fetchSitesUseCase,
    this._fetchSiteGroupsUseCase,
    this._ref,
  ) : super(const loadingState.State.init()) {
    controller.add(user);
  }
  
  // For convenience, access to incremental sync use cases through ref
  IncrementalSyncModulesUseCase get _incrementalSyncModulesUseCase => 
      _ref.read(incrementalSyncModulesUseCaseProvider);
  
  IncrementalSyncSitesUseCase get _incrementalSyncSitesUseCase => 
      _ref.read(incrementalSyncSitesUseCaseProvider);
  
  IncrementalSyncSiteGroupsUseCase get _incrementalSyncSiteGroupsUseCase => 
      _ref.read(incrementalSyncSiteGroupsUseCaseProvider);
      
  GetModulesUseCase get _getModulesUseCase =>
      _ref.read(getModulesUseCaseProvider);

  Stream<User?> get authStateChange => controller.stream;

  void _updateLoginStatus(LoginStatusInfo status) {
    _ref.read(loginStatusProvider.notifier).state = status;
  }

  Future<void> signInWithEmailAndPassword(
    final String identifiant,
    final String password,
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      state = const loadingState.State.loading();
      _updateLoginStatus(LoginStatusInfo.authenticating);

      await _loginUseCase.execute(identifiant, password).then((user) async {
        controller.add(user);

        try {
          // Save user login state
          _updateLoginStatus(LoginStatusInfo.savingUserData);
          await _setIsLoggedInFromLocalStorageUseCase.execute(true);
          await _setUserIdFromLocalStorageUseCase.execute(user.id);
          await _setUserNameFromLocalStorageUseCase.execute(identifiant);
          await _setTokenFromLocalStorageUseCase.execute(user.token);

          // Check if database already has data to determine if we need full sync or incremental
          final existingModules = await _getModulesUseCase.execute();
          final hasDatabaseData = existingModules.isNotEmpty;
          
          try {
            if (hasDatabaseData) {
              print("Database already contains data. Performing incremental sync...");
              
              // Perform incremental sync of modules
              _updateLoginStatus(LoginStatusInfo.incrementalSyncModules);
              await _incrementalSyncModulesUseCase.execute(user.token);
              
              // Then incremental sync sites
              _updateLoginStatus(LoginStatusInfo.incrementalSyncSites);
              await _incrementalSyncSitesUseCase.execute(user.token);
              
              // Then incremental sync site groups
              _updateLoginStatus(LoginStatusInfo.incrementalSyncSiteGroups);
              await _incrementalSyncSiteGroupsUseCase.execute(user.token);
            } else {
              print("Empty database. Performing full initial sync...");
              
              // First fetch and sync modules
              _updateLoginStatus(LoginStatusInfo.fetchingModules);
              await _fetchModulesUseCase.execute(user.token);
              
              // Then fetch sites
              _updateLoginStatus(LoginStatusInfo.fetchingSites);
              await _fetchSitesUseCase.execute(user.token);
              
              // Then fetch site groups
              _updateLoginStatus(LoginStatusInfo.fetchingSiteGroups);
              await _fetchSiteGroupsUseCase.execute(user.token);
            }
          } catch (e) {
            print('Error during data sync: $e');
            // We still continue to the home page even if some data fetching failed
          }

          // Set status to complete
          _updateLoginStatus(LoginStatusInfo.complete);

          // Refresh state
          ref.refresh(isLoggedInProvider);
          GoRouter.of(context).go('/');
          state = loadingState.State.success(user);
        } catch (e) {
          print('Error during post-login actions: $e');
          _updateLoginStatus(LoginStatusInfo.error(e.toString()));
        }
      });
    } on DioException catch (e) {
      var errorObj = {};
      String errorText;
      if (e.response != null) {
        errorObj['data'] = e.response!.data;
        errorObj['headers'] = e.response!.headers;
        errorObj['requestOptions'] = e.response!.requestOptions;
        errorText =
            "${e.error} : Le serveur a été atteint, mais ce dernier a renvoyé une exception";
      } else {
        errorObj['message'] = e.message;
        errorObj['requestOptions'] = e.requestOptions;
        errorText =
            "${e.error}: La requète n'a pas pu être mise en place ou envoyée";
      }

      _updateLoginStatus(LoginStatusInfo.error(errorText));

      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(errorText),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: errorObj.length,
              itemBuilder: (BuildContext context, int index) {
                String key = errorObj.keys.elementAt(index);
                return Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(key),
                      subtitle: Text("${errorObj[key]}"),
                    ),
                    const Divider(
                      height: 2.0,
                    ),
                  ],
                );
              },
            ),
          ),
          // content: Text(e.toString()),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text("OK"))
          ],
        ),
      );
    } on Exception catch (e) {
      state = loadingState.State.error(e);
      _updateLoginStatus(LoginStatusInfo.error(e.toString()));

      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error Occured'),
          content: Text(e.toString()),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text("OK"))
          ],
        ),
      );
      // state = State.error(e);
    }
  }


  Future<void> signOut(WidgetRef ref, BuildContext context) async {
    try {
      // Clear user data
      controller.add(null);

      // Update login state
      await _setIsLoggedInFromLocalStorageUseCase.execute(false);
      await _clearUserNameFromLocalStorageUseCase.execute();
      await _clearUserIdFromLocalStorageUseCase.execute();
      await _clearTokenFromLocalStorageUseCase.execute();

      // Clear any cached user information
      ref.refresh(authStateProvider);

      // Navigate to the login page
      GoRouter.of(context).go('/login');

      // Reset the state
      state = const loadingState.State.init();
    } catch (e) {
      print('Error during logout: $e');
    }
  }
}
