import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/user.dart';
import 'package:gn_mobile_monitoring/domain/usecase/login_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_is_logged_in_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_user_name_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/state/state.dart'
    as loadingState;
import 'package:gn_mobile_monitoring/presentation/view/auth_checker.dart';

// Pour le Checker
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(authenticationViewModelProvider).authStateChange;
});

final authenticationViewModelProvider =
    Provider<AuthenticationViewModel>((ref) {
  return AuthenticationViewModel(
    ref.watch(loginUseCaseProvider),
    ref.watch(setIsLoggedInFromLocalStorageUseCaseProvider),
    ref.watch(setUserIdFromLocalStorageUseCaseProvider),
    ref.watch(setUserNameFromLocalStorageUseCaseProvider),
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

  AuthenticationViewModel(
    this._loginUseCase,
    this._setIsLoggedInFromLocalStorageUseCase,
    this._setUserIdFromLocalStorageUseCase,
    this._setUserNameFromLocalStorageUseCase,
  ) : super(const loadingState.State.init()) {
    controller.add(user);
  }

  Stream<User?> get authStateChange => controller.stream;

  Future<void> signInWithEmailAndPassword(
    final String identifiant,
    final String password,
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      state = const loadingState.State.loading();
      await _loginUseCase.execute(identifiant, password).then((user) async {
        controller.add(user);

        try {
          // Set logged in status using use case
          await _setIsLoggedInFromLocalStorageUseCase.execute(true);
          print("isLoggedIn set to: true"); // Added for debugging purposes

          // Save the user's ID and name using respective use cases
          await _setUserIdFromLocalStorageUseCase.execute(user.id);
          await _setUserNameFromLocalStorageUseCase.execute(identifiant);
          print(
              'Login state and user name saved'); // Added for debugging purposes

          // Refresh UI or state management solution
          ref.refresh(isLoggedInProvider);
          state = loadingState.State.success(user);
        } catch (e) {
          print('Error saving login state and user name: $e');
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

  // Method to handle user logout
  Future<void> signOut(ref, context) async {
    await _setIsLoggedInFromLocalStorageUseCase.execute(false);
  }
}
