import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/list_toolbar_widget.dart';

/// Un libellé de liste long (ex. « Groupes de blaireautières », protocole
/// suivi_terriers_blaireau_gmb) ne doit pas faire déborder la barre d'outils
/// sur un écran de téléphone : il est raccourci, et le tri reste visible.
void main() {
  final position = Position(
    latitude: 45.2,
    longitude: 5.7,
    timestamp: DateTime(2026),
    accuracy: 5,
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: 0,
    speedAccuracy: 0,
  );

  // Pas de 320 px : la police de test (chaque caractère aussi large que haut)
  // élargit le bouton de tri bien au-delà de son rendu réel.
  for (final width in [360.0, 412.0]) {
    testWidgets('libellé long sans débordement sur $width px', (tester) async {
      tester.view.physicalSize = Size(width, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ListToolbarWidget(
            label: 'Groupes de blaireautières',
            showSearch: false,
            searchQuery: '',
            searchController: TextEditingController(),
            onSearchChanged: (_) {},
            onToggleSearch: () {},
            onCloseSearch: () {},
            userPosition: position,
            onToggleSort: () {},
            addButton: IconButton(
                icon: const Icon(Icons.add), onPressed: () {}),
          ),
        ),
      ));

      expect(tester.takeException(), isNull,
          reason: 'la barre d\'outils ne doit pas déborder');
      expect(find.text('Alphabétique'), findsOneWidget,
          reason: 'le bouton de tri reste affiché');
      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  }
}
