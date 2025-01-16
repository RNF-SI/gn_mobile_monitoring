import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/menu_actions.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/module_list_widget.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/site_group_list_widget.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/site_list_widget.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF598979), // Brand color
          title: const Text("Mes Données"),
          actions: [
            MenuActions(),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list), text: "Modules"),
              Tab(icon: Icon(Icons.list), text: "Groupes de Sites"),
              Tab(icon: Icon(Icons.map), text: "Sites"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ModuleListWidget(),
            SiteGroupListWidget(),
            SiteListWidget(),
          ],
        ),
      ),
    );
  }
}
