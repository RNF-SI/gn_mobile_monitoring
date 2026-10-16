import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/dataset.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/datasets_service.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/dynamic_form_builder.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/nomenclature_selector_widget.dart';
import 'package:mockito/mockito.dart';

import '../view/dynamic_form_builder_test.mocks.dart';

/// Affiche les vrais formulaires de plusieurs protocoles (configurations
/// renvoyées par `/monitorings/config/<module>`, dans
/// `test/fixtures/module_configs/`) sur des écrans étroits, police agrandie,
/// et vérifie qu'aucun champ ne déborde.
///
/// Les configurations viennent d'un GeoNature `develop` (10/2026). Pour
/// `nidif_gypa`, les détails d'observation ont été activés sur le serveur de
/// test pour couvrir ce formulaire : le protocole officiel ne les active pas.
const _modules = [
  'POPAmphibien',
  'POPReptile',
  'nidif_gypa',
  'stom',
  'suivi_terriers_blaireau_gmb',
  'ecrevisses_pattes_blanches',
];

const _screens = {
  'petit (320)': Size(320, 640),
  'Pixel 6a (412)': Size(412, 915),
};

class _UserId implements GetUserIdFromLocalStorageUseCase {
  @override
  Future<int> execute() async => 3;
}

Dataset _dataset(int id, String name) => Dataset(
      id: id,
      uniqueDatasetId: 'uuid-$id',
      idAcquisitionFramework: 1,
      datasetName: name,
      datasetShortname: 'JDD $id',
      datasetDesc: 'desc',
      idNomenclatureDataType: 1,
      marineDomain: false,
      terrestrialDomain: true,
      idNomenclatureCollectingMethod: 1,
      idNomenclatureDataOrigin: 1,
      idNomenclatureSourceStatus: 1,
      idNomenclatureResourceType: 1,
    );

void main() {
  for (final module in _modules) {
    final json = jsonDecode(
            File('test/fixtures/module_configs/$module.json').readAsStringSync())
        as Map<String, dynamic>;
    final config = ModuleConfiguration.fromJson(json);
    final objects = {
      'sites_group': config.sitesGroup,
      'site': config.site,
      'visit': config.visit,
      'observation': config.observation,
      'observation_detail': config.observationDetail,
    }..removeWhere((_, v) => v == null);

    for (final object in objects.entries) {
      for (final screen in _screens.entries) {
        testWidgets(
            '$module / ${object.key} : ${screen.key}, texte x1.3',
            (tester) async {
          tester.view.physicalSize = screen.value;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.reset);

          final datasetService = MockDatasetService();
          when(datasetService.getDatasetsForModule(any)).thenAnswer(
              (_) async => [
                    _dataset(1, 'Contact aléatoire tous règnes confondus'),
                  ]);

          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                datasetServiceProvider.overrideWithValue(datasetService),
                getUserIdFromLocalStorageUseCaseProvider
                    .overrideWithValue(_UserId()),
                nomenclaturesByTypeProvider.overrideWith(
                  (ref, type) async => [
                    Nomenclature(
                      id: 1,
                      idType: 1,
                      cdNomenclature: 'A',
                      labelFr: 'Libellé de nomenclature volontairement long '
                          'pour un écran étroit ($type)',
                    ),
                  ],
                ),
              ],
              child: MaterialApp(
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: const TextScaler.linear(1.3)),
                  child: child!,
                ),
                home: Scaffold(
                  body: SingleChildScrollView(
                    child: DynamicFormBuilder(
                      objectConfig: object.value!,
                      customConfig: config.custom,
                      objectType: object.key,
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 500));

          expect(tester.takeException(), isNull);
          expect(find.byType(DynamicFormBuilder), findsOneWidget);
        });
      }
    }
  }
}
