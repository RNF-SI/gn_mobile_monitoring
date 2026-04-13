import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_conflict.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/conflict_dialog_widget.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ConflictRefreshDemo(),
    );
  }
}

class ConflictRefreshDemo extends StatefulWidget {
  const ConflictRefreshDemo({super.key});

  @override
  State<ConflictRefreshDemo> createState() => _ConflictRefreshDemoState();
}

class _ConflictRefreshDemoState extends State<ConflictRefreshDemo> {
  List<SyncConflict> conflicts = [
    SyncConflict(
      entityType: 'observation',
      entityId: '123',
      conflictType: ConflictType.deletedReference,
      affectedField: 'taxon_ref',
      localData: {},
      remoteData: {},
      localModifiedAt: DateTime.now(),
      remoteModifiedAt: DateTime.now(),
      resolutionStrategy: ConflictResolutionStrategy.userDecision,
      navigationPath: '/module/1/site/2/visit/3/observation/123',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conflict Refresh Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Conflits: ${conflicts.length}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final result = await showDialog<bool>(
                  context: context,
                  builder: (context) => ConflictDialogWidget(
                    conflicts: conflicts,
                  ),
                );
                
                if (result == true) {
                  setState(() {
                    // Simuler le rafraîchissement des conflits après édition
                    conflicts = [];
                  });
                  
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Conflits rafraîchis après édition'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Afficher les conflits'),
            ),
          ],
        ),
      ),
    );
  }
}