import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/presentation/view/error_screen.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/home_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/loading_screen.dart';
import 'package:gn_mobile_monitoring/presentation/view/login_page.dart';

final isLoggedInProvider = FutureProvider<bool>((ref) async {
  final usecase = ref.read(getIsLoggedInFromLocalStorageUseCaseProvider);
  return await usecase.execute();
});

class AuthChecker extends ConsumerWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isLoggedInProvider);

    return isLoggedIn.when(
      data: (isLoggedInValue) {
        if (isLoggedInValue) {
          return const HomePage();
        } else {
          return LoginPage();
        }
      },
      loading: () => const LoadingScreen(),
      error: (e, trace) => ErrorScreen(e.toString()),
    );
  }
}
