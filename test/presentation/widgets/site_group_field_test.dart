import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/dynamic_form_builder.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/site_form_wrapper.dart';

/// Régression 09/2026 : petite_chouette_montagne déclare des sites sous un
/// groupe et directement sous le module. Depuis l'onglet Sites, le champ
/// obligatoire « Groupe de site » était une liste vide : impossible
/// d'enregistrer le site.
void main() {
  // petite_chouette_montagne/site.json (extrait)
  ObjectConfig siteConfig() => ObjectConfig(
        label: 'Site',
        specific: {
          'id_sites_group': {
            'type_widget': 'datalist',
            'attribut_label': 'Groupe de site',
            'type_util': 'sites_group',
            'keyValue': 'id_sites_group',
            'keyLabel': 'sites_group_name',
            'api':
                '__MONITORINGS_PATH/list/__MODULE.MODULE_CODE/sites_group?id_module=__MODULE.ID_MODULE',
            'required': true,
            'hidden': false,
          },
        },
      );

  const groups = [
    SiteGroup(idSitesGroup: 12, sitesGroupName: 'Zone Nord'),
    SiteGroup(idSitesGroup: 13, sitesGroupName: 'Zone Sud'),
  ];

  Future<DynamicFormBuilderState> pumpForm(
      WidgetTester tester, ObjectConfig config,
      {Map<String, dynamic>? initialValues}) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DynamicFormBuilder(
                objectConfig: config,
                objectType: 'site',
                initialValues: initialValues,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return tester.state(find.byType(DynamicFormBuilder));
  }

  test('options injectées depuis les groupes du module (specific)', () {
    final config =
        siteConfigWithSitesGroupOptions(siteConfig(), groups.toList());
    expect(config.specific!['id_sites_group']['values'], [
      {'value': '12', 'label': 'Zone Nord'},
      {'value': '13', 'label': 'Zone Sud'},
    ]);
    expect(config.specific!['id_sites_group']['required'], isTrue);
  });

  test('options injectées dans un champ generic', () {
    final config = siteConfigWithSitesGroupOptions(
      ObjectConfig(label: 'Site', generic: {
        'id_sites_group': GenericFieldConfig(
            attributLabel: 'Groupe', typeWidget: 'datalist'),
      }),
      groups.toList(),
    );
    expect(config.generic!['id_sites_group']!.values, hasLength(2));
  });

  testWidgets('témoin : sans options, formulaire bloqué', (tester) async {
    final form = await pumpForm(tester, siteConfig());
    await tester.tap(find.byType(TextField).first);
    await tester.pumpAndSettle();
    expect(find.text('Zone Nord'), findsNothing);
    expect(form.validate(), isFalse,
        reason: 'Champ obligatoire sans valeur possible');
  });

  testWidgets('le groupe se choisit dans la liste', (tester) async {
    final form = await pumpForm(tester,
        siteConfigWithSitesGroupOptions(siteConfig(), groups.toList()));

    await tester.tap(find.byType(TextField).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Zone Sud').last);
    await tester.pumpAndSettle();

    expect(form.getFormValues()['id_sites_group'], '13');
    expect(form.validate(), isTrue);
  });

  testWidgets('groupe de navigation pré-rempli : libellé affiché',
      (tester) async {
    await pumpForm(tester,
        siteConfigWithSitesGroupOptions(siteConfig(), groups.toList()),
        initialValues: {'id_sites_group': 12});

    expect(find.text('Zone Nord'), findsOneWidget);
  });
}
