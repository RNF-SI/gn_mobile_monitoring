import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/data_module.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/module_item_card_widget.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/mocks.dart';

/// [unsyncedModuleIdsProvider] décide quels modules ont des saisies à
/// téléverser (badge des cartes, menu de téléversement, alerte de
/// désinstallation). Il doit retenir les visites non envoyées ET les sites ou
/// groupes créés localement sans visite (issue #204).
void main() {
  late MockVisitesDatabase visits;
  late MockSitesDatabase sites;

  setUp(() {
    visits = MockVisitesDatabase();
    sites = MockSitesDatabase();
  });

  Future<Set<int>> read() {
    final container = ProviderContainer(overrides: [
      visitDatabaseProvider.overrideWithValue(visits),
      siteDatabaseProvider.overrideWithValue(sites),
    ]);
    addTearDown(container.dispose);
    return container.read(unsyncedModuleIdsProvider.future);
  }

  test('union des modules avec visites et avec sites/groupes en attente',
      () async {
    when(() => visits.getModuleIdsWithUnsyncedVisits())
        .thenAnswer((_) async => {1, 2});
    when(() => sites.getModuleIdsWithUnsyncedSitesOrGroups())
        .thenAnswer((_) async => {2, 3});

    expect(await read(), {1, 2, 3});
  });

  test('module avec seulement un site ou un groupe local → retenu', () async {
    when(() => visits.getModuleIdsWithUnsyncedVisits())
        .thenAnswer((_) async => <int>{});
    when(() => sites.getModuleIdsWithUnsyncedSitesOrGroups())
        .thenAnswer((_) async => {7});

    expect(await read(), {7});
  });

  test('rien en attente → ensemble vide', () async {
    when(() => visits.getModuleIdsWithUnsyncedVisits())
        .thenAnswer((_) async => <int>{});
    when(() => sites.getModuleIdsWithUnsyncedSitesOrGroups())
        .thenAnswer((_) async => <int>{});

    expect(await read(), isEmpty);
  });
}
