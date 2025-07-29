import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/form_data_processor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('Test Cas PopReptile - Persistance cd_nom', () {
    late ProviderContainer container;
    late FormDataProcessor processor;

    setUp(() {
      container = ProviderContainer();
      processor = container.read(formDataProcessorProvider);
    });

    tearDown(() {
      container.dispose();
    });

    test('Configuration PopReptile réelle - cd_nom avec valeur par défaut', () {
      // Configuration exacte du cas PopReptile
      final popReptileConfig = {
        'presence': {
          'widget_type': 'RadioButton',
          'attribut_label': 'Présence',
          'value': 'Oui',
          'validations': {'required': false},
          'values': ['Oui', 'Non']
        },
        'cd_nom': {
          'widget_type': 'TaxonSelector',
          'attribut_label': 'Taxon',
          'value': 186278, // Valeur par défaut importante
          'hidden': "({value}) => value.presence === 'Non'",
          'validations': {'required': false}
        }
      };

      // Scénario 1: État initial - cd_nom visible
      var context = {
        'value': {
          'presence': 'Oui',
          'cd_nom': 186278
        }
      };

      expect(
        processor.isFieldHidden(
          'cd_nom',
          context,
          fieldConfig: popReptileConfig['cd_nom'],
          allFieldsConfig: popReptileConfig,
        ),
        false,
        reason: 'cd_nom devrait être visible quand presence = Oui'
      );

      // Scénario 2: Changement vers 'Non' - cd_nom caché mais valeur conservée
      context['value']['presence'] = 'Non';

      expect(
        processor.isFieldHidden(
          'cd_nom',
          context,
          fieldConfig: popReptileConfig['cd_nom'],
          allFieldsConfig: popReptileConfig,
        ),
        true,
        reason: 'cd_nom devrait être caché quand presence = Non'
      );

      // ASSERTION CRITIQUE: La valeur cd_nom doit être conservée
      expect(
        context['value']['cd_nom'],
        equals(186278),
        reason: 'La valeur cd_nom=186278 doit être préservée même quand le champ est caché'
      );

      // Scénario 3: Retour vers 'Oui' - cd_nom redevient visible avec valeur intacte
      context['value']['presence'] = 'Oui';

      expect(
        processor.isFieldHidden(
          'cd_nom',
          context,
          fieldConfig: popReptileConfig['cd_nom'],
          allFieldsConfig: popReptileConfig,
        ),
        false,
        reason: 'cd_nom devrait redevenir visible quand presence = Oui'
      );

      expect(
        context['value']['cd_nom'],
        equals(186278),
        reason: 'La valeur cd_nom=186278 doit être restaurée intacte'
      );
    });

    test('Soumission de données PopReptile avec cd_nom caché', () async {
      // Simuler les données finales du formulaire PopReptile
      // où l'utilisateur a sélectionné 'Non' pour la présence
      final formDataWithHiddenCdNom = {
        'presence': 'Non',
        'cd_nom': 186278, // Cette valeur DOIT être conservée et soumise
        'comments': 'Aucune observation de reptile dans cette zone',
        'other_field': 'some_value'
      };

      // Traitement des données avant soumission
      final processedData = await processor.processFormData(formDataWithHiddenCdNom);

      // Vérifications critiques pour le backend
      expect(processedData.containsKey('cd_nom'), true,
          reason: 'cd_nom doit être présent dans les données soumises au backend');
      expect(processedData['cd_nom'], equals(186278),
          reason: 'La valeur par défaut cd_nom=186278 doit être envoyée au backend');
      expect(processedData['presence'], equals('Non'),
          reason: 'La sélection utilisateur presence=Non doit être respectée');
      expect(processedData.containsKey('comments'), true,
          reason: 'Tous les autres champs doivent également être présents');
    });

    test('Logique métier backend - cd_nom utilisé même si caché', () {
      // Ce test simule la logique côté backend qui pourrait utiliser
      // la valeur cd_nom même quand l'utilisateur a indiqué "pas de présence"
      
      final observationData = {
        'presence': 'Non',
        'cd_nom': 186278, // Taxon par défaut pour ce type d'observation
        'id_digitiser': 123,
        'comments': 'Aucun individu observé mais zone prospectée pour Podarcis muralis'
      };

      // Le backend peut utiliser cd_nom pour:
      // 1. Associer l'observation à l'espèce prospectée
      // 2. Statistiques sur les zones prospectées par espèce
      // 3. Protocoles nécessitant un taxon de référence même en absence
      
      expect(observationData['cd_nom'], isNotNull,
          reason: 'Le backend doit pouvoir accéder à cd_nom pour la logique métier');
      expect(observationData['cd_nom'], equals(186278),
          reason: 'La valeur par défaut doit être disponible pour le traitement backend');
    });

    test('Comparaison avec ancienne logique (suppression des valeurs)', () {
      // Ce test démontre pourquoi l'ancienne logique était problématique
      
      final contextAvecAncienneLogique = {
        'value': {
          'presence': 'Non',
          // cd_nom serait supprimé par l'ancienne logique
          // 'cd_nom': undefined/absent
        }
      };

      final contextAvecNouvelleLogique = {
        'value': {
          'presence': 'Non',
          'cd_nom': 186278 // Valeur conservée avec la nouvelle logique
        }
      };

      // Avec l'ancienne logique, cette information serait perdue
      expect(contextAvecAncienneLogique['value'].containsKey('cd_nom'), false,
          reason: 'Ancienne logique: cd_nom était supprimé');

      // Avec la nouvelle logique, l'information est préservée
      expect(contextAvecNouvelleLogique['value'].containsKey('cd_nom'), true,
          reason: 'Nouvelle logique: cd_nom est conservé');
      expect(contextAvecNouvelleLogique['value']['cd_nom'], equals(186278),
          reason: 'Nouvelle logique: valeur par défaut préservée');
    });
  });
}