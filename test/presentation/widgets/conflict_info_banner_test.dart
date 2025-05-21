import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_conflict.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/conflict_info_banner.dart';

void main() {
  group('ConflictInfoBanner', () {
    testWidgets('should display custom message for site deletion conflict', (WidgetTester tester) async {
      const customMessage = 'Site "Mon Site Test" supprimé du module TEST_MODULE mais a 3 visite(s)';
      
      final conflict = SyncConflict(
        conflictType: ConflictType.deletedReference,
        entityType: 'site',
        entityId: '123',
        localData: {},
        remoteData: {},
        localModifiedAt: DateTime.now(),
        remoteModifiedAt: DateTime.now(),
        resolutionStrategy: ConflictResolutionStrategy.userDecision,
        message: customMessage,
        severity: ConflictSeverity.high,
        referencedEntityType: 'visit',
        referencesCount: 3,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ConflictInfoBanner(conflict: conflict),
            ),
          ),
        ),
      );

      // Laisser le temps au FutureBuilder de se résoudre
      await tester.pumpAndSettle();

      // Vérifier que le message personnalisé est affiché
      expect(find.text(customMessage), findsOneWidget);
      
      // Vérifier que le titre est correct
      expect(find.text('Conflit à résoudre'), findsOneWidget);
      
      // Vérifier l'icône d'avertissement
      expect(find.byIcon(Icons.warning), findsOneWidget);
    });

    testWidgets('should display custom message for site group deletion conflict', (WidgetTester tester) async {
      const customMessage = 'Groupe de sites "Groupe Test" supprimé du module TEST_MODULE mais contient 2 site(s) avec 5 visite(s)';
      
      final conflict = SyncConflict(
        conflictType: ConflictType.deletedReference,
        entityType: 'siteGroup',
        entityId: '456',
        localData: {},
        remoteData: {},
        localModifiedAt: DateTime.now(),
        remoteModifiedAt: DateTime.now(),
        resolutionStrategy: ConflictResolutionStrategy.userDecision,
        message: customMessage,
        severity: ConflictSeverity.high,
        referencedEntityType: 'site',
        referencesCount: 7, // 2 sites + 5 visites
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ConflictInfoBanner(conflict: conflict),
            ),
          ),
        ),
      );

      // Laisser le temps au FutureBuilder de se résoudre
      await tester.pumpAndSettle();

      // Vérifier que le message personnalisé est affiché
      expect(find.text(customMessage), findsOneWidget);
    });

    testWidgets('should fallback to generic message when custom message is null', (WidgetTester tester) async {
      final conflict = SyncConflict(
        conflictType: ConflictType.deletedReference,
        entityType: 'unknown',
        entityId: '789',
        localData: {},
        remoteData: {},
        localModifiedAt: DateTime.now(),
        remoteModifiedAt: DateTime.now(),
        resolutionStrategy: ConflictResolutionStrategy.userDecision,
        message: null, // Pas de message personnalisé
        affectedField: 'test_field',
        referencedEntityType: 'test_entity',
        referencedEntityId: '123',
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ConflictInfoBanner(conflict: conflict),
            ),
          ),
        ),
      );

      // Laisser le temps au FutureBuilder de se résoudre
      await tester.pumpAndSettle();

      // Vérifier que le message générique est utilisé
      expect(find.textContaining('Référence supprimée: Le champ'), findsOneWidget);
      expect(find.textContaining('fait référence à un élément qui n\'existe plus'), findsOneWidget);
    });

    testWidgets('should fallback to generic message when custom message is empty', (WidgetTester tester) async {
      final conflict = SyncConflict(
        conflictType: ConflictType.deletedReference,
        entityType: 'unknown',
        entityId: '789',
        localData: {},
        remoteData: {},
        localModifiedAt: DateTime.now(),
        remoteModifiedAt: DateTime.now(),
        resolutionStrategy: ConflictResolutionStrategy.userDecision,
        message: '', // Message vide
        affectedField: 'test_field',
        referencedEntityType: 'test_entity',
        referencedEntityId: '123',
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ConflictInfoBanner(conflict: conflict),
            ),
          ),
        ),
      );

      // Laisser le temps au FutureBuilder de se résoudre
      await tester.pumpAndSettle();

      // Vérifier que le message générique est utilisé
      expect(find.textContaining('Référence supprimée: Le champ'), findsOneWidget);
      expect(find.textContaining('fait référence à un élément qui n\'existe plus'), findsOneWidget);
    });

    testWidgets('should display recommended action for deleted references', (WidgetTester tester) async {
      final conflict = SyncConflict(
        conflictType: ConflictType.deletedReference,
        entityType: 'test',
        entityId: '123',
        localData: {},
        remoteData: {},
        localModifiedAt: DateTime.now(),
        remoteModifiedAt: DateTime.now(),
        resolutionStrategy: ConflictResolutionStrategy.userDecision,
        affectedField: 'test_field',
        message: 'Custom conflict message',
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ConflictInfoBanner(conflict: conflict),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Vérifier que l'action recommandée est affichée
      expect(find.textContaining('Action recommandée'), findsOneWidget);
      expect(find.textContaining('Sélectionnez une nouvelle valeur valide'), findsOneWidget);
    });
  });
}