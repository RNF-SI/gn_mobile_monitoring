import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_conflict.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/conflict_card_widget.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/conflict_navigation_service.dart';
import 'package:mocktail/mocktail.dart';

// Mock pour ConflictNavigationService
class MockConflictNavigationService extends Mock {}

void main() {
  group('Conflict refresh after edit', () {
    testWidgets('should close dialog when navigation returns true', (WidgetTester tester) async {
      // Créer un conflit de test
      final conflict = SyncConflict(
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
      );

      // Variable pour vérifier si le dialogue a été fermé
      bool dialogClosed = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () async {
                      final result = await showDialog<bool>(
                        context: context,
                        builder: (context) => Dialog(
                          child: ConflictCardWidget(
                            conflict: conflict,
                            conflictType: ConflictType.deletedReference,
                          ),
                        ),
                      );
                      dialogClosed = result == true;
                    },
                    child: const Text('Open Dialog'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Ouvrir le dialogue
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Vérifier que le dialogue est ouvert
      expect(find.byType(ConflictCardWidget), findsOneWidget);

      // Vérifier que le dialogue n'est pas encore fermé
      expect(dialogClosed, false);

      // TODO: Ajouter le test de simulation du clic sur le bouton de navigation
      // et vérifier que le dialogue se ferme avec true
    });
  });
}