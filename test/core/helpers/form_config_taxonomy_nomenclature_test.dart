import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';

void main() {
  group('FormConfigParser - Taxonomy Functions', () {
    test('isTaxonomyField should identify taxonomy fields correctly', () {
      // Arrange
      final taxonomyByTypeWidget = {'type_widget': 'taxonomy'};
      final taxonomyByTypeUtil = {'type_util': 'taxonomy'};
      final taxonomyByListIdNumber = {'id_list': 42};
      final taxonomyByListIdString = {'id_list': '42'};
      final taxonomyByVariable = {'id_list': '__MODULE.ID_LIST_TAXONOMY'};
      final taxonomyByCdNom = {'attribut_name': 'cd_nom'};
      final notTaxonomy = {'type_widget': 'text', 'type_util': 'text'};

      // Act & Assert
      expect(FormConfigParser.isTaxonomyField(taxonomyByTypeWidget), isTrue);
      expect(FormConfigParser.isTaxonomyField(taxonomyByTypeUtil), isTrue);
      expect(FormConfigParser.isTaxonomyField(taxonomyByListIdNumber), isTrue);
      expect(FormConfigParser.isTaxonomyField(taxonomyByListIdString), isTrue);
      expect(FormConfigParser.isTaxonomyField(taxonomyByVariable), isTrue);
      expect(FormConfigParser.isTaxonomyField(taxonomyByCdNom), isTrue);
      expect(FormConfigParser.isTaxonomyField(notTaxonomy), isFalse);
    });

    test('getTaxonListId should extract list ID from taxonomy fields', () {
      // Arrange
      final listIdAsInt = {'id_list': 42};
      final listIdAsString = {'id_list': '42'};
      final valueWithListId = {'value': {'id_list': 42}};
      final noListId = {'type_util': 'taxonomy'};
      final notTaxonomy = {'type_widget': 'text'};

      // Act
      final idFromInt = FormConfigParser.getTaxonListId(listIdAsInt);
      final idFromString = FormConfigParser.getTaxonListId(listIdAsString);
      final idFromValue = FormConfigParser.getTaxonListId(valueWithListId);
      final idFromNoListId = FormConfigParser.getTaxonListId(noListId);
      final idFromNotTaxonomy = FormConfigParser.getTaxonListId(notTaxonomy);

      // Assert
      expect(idFromInt, 42);
      expect(idFromString, 42);
      expect(idFromValue, isNull); // This should be 42 if we implement handling of value.id_list
      expect(idFromNoListId, isNull);
      expect(idFromNotTaxonomy, isNull);
    });

    test('getSelectedTaxonCdNom should extract cd_nom from taxonomy fields', () {
      // Arrange
      final cdNomAsValue = {'value': 12345};
      final cdNomInObject = {'value': {'cd_nom': 12345}};
      final noCdNom = {'type_util': 'taxonomy'};
      final notTaxonomy = {'type_widget': 'text'};

      // Act
      final fromDirectValue = FormConfigParser.getSelectedTaxonCdNom(cdNomAsValue);
      final fromObjectValue = FormConfigParser.getSelectedTaxonCdNom(cdNomInObject);
      final fromNoCdNom = FormConfigParser.getSelectedTaxonCdNom(noCdNom);
      final fromNotTaxonomy = FormConfigParser.getSelectedTaxonCdNom(notTaxonomy);

      // Assert
      expect(fromDirectValue, 12345);
      expect(fromObjectValue, 12345);
      expect(fromNoCdNom, isNull);
      expect(fromNotTaxonomy, isNull);
    });

    test('getTaxonomyDisplayFormat should return correct display format', () {
      // Arrange
      final withFormat = {'taxonomy_display_field_name': 'lb_nom'};
      final noFormat = {'type_util': 'taxonomy'};

      // Act
      final formatWithSpecified = FormConfigParser.getTaxonomyDisplayFormat(withFormat);
      final formatWithDefault = FormConfigParser.getTaxonomyDisplayFormat(noFormat);

      // Assert
      expect(formatWithSpecified, 'lb_nom');
      expect(formatWithDefault, 'nom_vern,lb_nom'); // Default format
    });
  });

  group('FormConfigParser - Nomenclature Functions', () {
    test('isNomenclatureField should identify nomenclature fields correctly', () {
      // Arrange
      final nomenclatureByTypeWidget = {'type_widget': 'nomenclature'};
      final nomenclatureByTypeUtil = {'type_util': 'nomenclature'};
      final nomenclatureByApi = {'api': 'nomenclatures/nomenclature/STADE_VIE'};
      final nomenclatureByCode = {'code_nomenclature_type': 'STADE_VIE'};
      final nomenclatureByAttributName = {'attribut_name': 'id_nomenclature_stade_vie'};
      final notNomenclature = {'type_widget': 'text', 'type_util': 'text'};

      // Act & Assert
      expect(FormConfigParser.isNomenclatureField(nomenclatureByTypeWidget), isTrue);
      expect(FormConfigParser.isNomenclatureField(nomenclatureByTypeUtil), isTrue);
      expect(FormConfigParser.isNomenclatureField(nomenclatureByApi), isTrue);
      expect(FormConfigParser.isNomenclatureField(nomenclatureByCode), isTrue);
      expect(FormConfigParser.isNomenclatureField(nomenclatureByAttributName), isTrue);
      expect(FormConfigParser.isNomenclatureField(notNomenclature), isFalse);
    });

    test('getNomenclatureTypeCode should extract type code from nomenclature fields', () {
      // Arrange
      final codeInField = {'code_nomenclature_type': 'STADE_VIE'};
      final codeInValue = {'value': {'code_nomenclature_type': 'TECHNIQUE_OBS'}};
      final codeInApi = {'api': 'nomenclatures/nomenclature/METH_OBS'};
      final codeInAttributName = {'attribut_name': 'id_nomenclature_meth_obs'};
      final noCode = {'type_widget': 'nomenclature'};

      // Act
      final fromField = FormConfigParser.getNomenclatureTypeCode(codeInField);
      final fromApi = FormConfigParser.getNomenclatureTypeCode(codeInApi);
      final fromAttributName = FormConfigParser.getNomenclatureTypeCode(codeInAttributName);
      final fromNoCode = FormConfigParser.getNomenclatureTypeCode(noCode);

      // Assert
      expect(fromField, 'STADE_VIE');
      expect(fromApi, 'METH_OBS');
      expect(fromAttributName, 'meth_obs');
      expect(fromNoCode, isNull);
    });

    test('getSelectedNomenclatureCode should extract cd_nomenclature from nomenclature fields', () {
      // Arrange
      final withValue = {
        'type_util': 'nomenclature',
        'value': {'cd_nomenclature': 'ADULT'}
      };
      final noValue = {'code_nomenclature_type': 'STADE_VIE'};
      final notNomenclature = {'type_widget': 'text'};

      // Act
      final fromWithValue = FormConfigParser.getSelectedNomenclatureCode(withValue);
      final fromNoValue = FormConfigParser.getSelectedNomenclatureCode(noValue);
      final fromNotNomenclature = FormConfigParser.getSelectedNomenclatureCode(notNomenclature);

      // Assert
      expect(fromWithValue, 'ADULT');
      expect(fromNoValue, isNull);
      expect(fromNotNomenclature, isNull);
    });

    test('extractMnemonique should extract correctly from API path', () {
      // Arrange
      final withMnemonique = {'api': 'nomenclatures/nomenclature/STADE_VIE'};
      final withComplexPath = {'api': '/geonature/api/nomenclatures/nomenclature/TECHNIQUE_OBS'};
      final withNoMnemonique = {'api': 'other/path'};
      final withNoApi = {'type_widget': 'nomenclature'};

      // Act
      final fromSimplePath = FormConfigParser.extractMnemonique(withMnemonique);
      final fromComplexPath = FormConfigParser.extractMnemonique(withComplexPath);
      final fromNoMnemonique = FormConfigParser.extractMnemonique(withNoMnemonique);
      final fromNoApi = FormConfigParser.extractMnemonique(withNoApi);

      // Assert
      expect(fromSimplePath, 'STADE_VIE');
      expect(fromComplexPath, 'TECHNIQUE_OBS');
      expect(fromNoMnemonique, 'path');
      expect(fromNoApi, isNull);
    });
  });

  group('FormConfigParser - Widget Type Determination', () {
    test('determineWidgetType should identify correct widget for taxonomy fields', () {
      // Arrange
      final taxonomyField = {'type_util': 'taxonomy'};
      
      // Act
      final widgetType = FormConfigParser.determineWidgetType(taxonomyField);
      
      // Assert
      expect(widgetType, 'TaxonSelector');
    });
    
    test('determineWidgetType should identify correct widget for nomenclature fields', () {
      // Arrange
      final nomenclatureField = {'type_util': 'nomenclature'};
      final nomenclatureApiField = {'api': 'nomenclatures/nomenclature/STADE_VIE'};
      final datalistNomenclatureField = {
        'type_widget': 'datalist',
        'api': 'nomenclatures/nomenclature/STADE_VIE'
      };
      
      // Act
      final widgetTypeByUtil = FormConfigParser.determineWidgetType(nomenclatureField);
      final widgetTypeByApi = FormConfigParser.determineWidgetType(nomenclatureApiField);
      final widgetTypeByDatalist = FormConfigParser.determineWidgetType(datalistNomenclatureField);
      
      // Assert
      expect(widgetTypeByUtil, 'NomenclatureSelector');
      expect(widgetTypeByApi, 'NomenclatureSelector');
      expect(widgetTypeByDatalist, 'NomenclatureSelector');
    });
  });

  group('FormConfigParser - Configuration Generation', () {
    test('generateUnifiedSchema should include taxonomy and nomenclature configs', () {
      // Arrange
      final objConfig = ObjectConfig(
        generic: {
          'taxon_field': GenericFieldConfig(
            attributLabel: 'Taxon',
            typeUtil: 'taxonomy',
            default_: {'cd_nom': 12345, 'nom_complet': 'Pinus sylvestris'},
          ),
          'nomenclature_field': GenericFieldConfig(
            attributLabel: 'Nomenclature',
            typeUtil: 'nomenclature',
            api: 'nomenclatures/nomenclature/STADE_VIE',
          ),
        },
      );
      
      final customConfig = CustomConfig(
        idListTaxonomy: 42,
        moduleCode: 'TEST',
      );
      
      // Act
      final unifiedSchema = FormConfigParser.generateUnifiedSchema(objConfig, customConfig);
      
      // Assert
      expect(unifiedSchema.containsKey('taxon_field'), isTrue);
      expect(unifiedSchema.containsKey('nomenclature_field'), isTrue);
      expect(unifiedSchema['taxon_field']?['widget_type'], 'TaxonSelector');
      expect(unifiedSchema['nomenclature_field']?['widget_type'], 'NomenclatureSelector');
      expect(unifiedSchema['taxon_field']?['type_util'], 'taxonomy');
    });
  });
}