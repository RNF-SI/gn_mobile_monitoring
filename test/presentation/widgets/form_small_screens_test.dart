import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/dataset.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/datasets_service.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/dynamic_form_builder.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/nomenclature_selector_widget.dart';
import 'package:mockito/mockito.dart';

import '../view/dynamic_form_builder_test.mocks.dart';

/// Formats de téléphones courants (largeur × hauteur en pixels logiques).
/// Le Pixel 6a (412 px) faisait déborder le choix du jeu de données de 5 px.
const _screens = {
  'petit (320)': Size(320, 640),
  'compact (360)': Size(360, 760),
  'Pixel 6a (412)': Size(412, 915),
  'tablette (800)': Size(800, 1280),
};

/// Tailles de police réglées par l'utilisateur dans Android.
const _textScales = [1.0, 1.3];

const _longLabel =
    'Contact aléatoire tous règnes confondus, protocole de suivi temporaire';

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
  final objectConfig = ObjectConfig(
    label: 'Visite',
    generic: {
      'id_dataset': GenericFieldConfig(
        attributLabel: 'Jeu de données',
        typeWidget: 'dataset',
        required: true,
      ),
      'visit_date_min': GenericFieldConfig(
        attributLabel: 'Date de la visite',
        typeWidget: 'date',
        required: true,
      ),
      'comments': GenericFieldConfig(
        attributLabel: 'Commentaires',
        typeWidget: 'textarea',
      ),
    },
    specific: {
      'expertise': {
        'attribut_label': "Niveau d'expertise de l'observateur principal",
        'type_widget': 'select',
        'required': true,
        'values': [
          {'label': _longLabel, 'value': 'long'},
          {'label': 'Débutant', 'value': 'Débutant'},
        ],
      },
      'accessibility': {
        'attribut_label': 'Site accessible pour la prospection ?',
        'type_widget': 'radio',
        'values': ['Oui', 'Non', _longLabel],
      },
      'Heure_debut': {
        'attribut_label': 'Heure de début de la prospection',
        'type_widget': 'time',
      },
      'num_passage': {
        'attribut_label': 'Numéro du passage dans la saison',
        'type_widget': 'number',
        'required': true,
      },
      'meteo_ok': {
        'attribut_label': 'Conditions météorologiques favorables à la détection',
        'type_widget': 'checkbox',
      },
    },
  );

  final customConfig = CustomConfig(
    moduleCode: 'POPAmphibien',
    idModule: 1,
    monitoringsPath: '/api/monitorings',
  );

  for (final screen in _screens.entries) {
    for (final scale in _textScales) {
      testWidgets(
          'formulaire sans débordement : ${screen.key}, texte x$scale',
          (tester) async {
        tester.view.physicalSize = screen.value;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        final datasetService = MockDatasetService();
        when(datasetService.getDatasetsForModule(any)).thenAnswer(
            (_) async => [_dataset(1, _longLabel), _dataset(2, 'JDD court')]);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              datasetServiceProvider.overrideWithValue(datasetService),
            ],
            child: MaterialApp(
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: TextScaler.linear(scale)),
                child: child!,
              ),
              home: Scaffold(
                body: SingleChildScrollView(
                  child: DynamicFormBuilder(
                    objectConfig: objectConfig,
                    customConfig: customConfig,
                    initialValues: const {
                      'id_dataset': 1,
                      'expertise': 'long',
                    },
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Un débordement (RenderFlex overflowed…) est remonté comme exception
        // par le framework de test : aucun ne doit apparaître.
        expect(tester.takeException(), isNull);
        expect(find.byType(DropdownButtonFormField<int>), findsOneWidget);
      });

      testWidgets(
          'nomenclature sans débordement : ${screen.key}, texte x$scale',
          (tester) async {
        tester.view.physicalSize = screen.value;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              nomenclaturesByTypeProvider('TYP_MILIEU').overrideWith(
                (ref) async => const [
                  Nomenclature(
                    id: 1,
                    idType: 1,
                    cdNomenclature: 'LONG',
                    labelFr: _longLabel,
                  ),
                  Nomenclature(
                    id: 2,
                    idType: 1,
                    cdNomenclature: 'MARE',
                    labelFr: 'Mare',
                  ),
                ],
              ),
            ],
            child: MaterialApp(
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: TextScaler.linear(scale)),
                child: child!,
              ),
              home: Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(16),
                  child: NomenclatureSelectorWidget(
                    label: 'Milieu aquatique',
                    fieldConfig: const {
                      'code_nomenclature_type': 'TYP_MILIEU',
                    },
                    value: const {'cd_nomenclature': 'LONG'},
                    onChanged: (_) {},
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text(_longLabel), findsOneWidget);
      });
    }
  }
}
