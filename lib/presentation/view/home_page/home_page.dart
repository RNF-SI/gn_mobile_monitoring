import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/menu_actions.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/module_list_widget.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF598979), // Brand color
        title: const Text("Mes Modules"),
        actions: [
          MenuActions(),
        ],
      ),
      body: const ModuleListWidget(),
    );
  }
}
