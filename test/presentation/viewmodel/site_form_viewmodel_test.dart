import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_site_with_relations_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_site_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_site_by_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_location_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_site_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/form_data_processor.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/nomenclature_service.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_form_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/taxon_service.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/sites_database.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockCreateSiteWithRelationsUseCase extends Mock
    implements CreateSiteWithRelationsUseCase {}

class MockUpdateSiteUseCase extends Mock implements UpdateSiteUseCase {}

class MockDeleteSiteUseCase extends Mock implements DeleteSiteUseCase {}

class MockGetUserIdFromLocalStorageUseCase extends Mock
    implements GetUserIdFromLocalStorageUseCase {}

class MockGetSiteByIdUseCase extends Mock implements GetSiteByIdUseCase {}

class MockGetUserLocationUseCase extends Mock
    implements GetUserLocationUseCase {}

class MockFormDataProcessor extends Mock implements FormDataProcessor {}

class MockSitesDatabase extends Mock implements SitesDatabase {}

class MockNomenclatureService extends Mock implements NomenclatureService {}

class MockTaxonService extends Mock implements TaxonService {}

class MockRef extends Mock implements Ref {}

void main() {
  late SiteFormViewModel viewModel;
  late MockCreateSiteWithRelationsUseCase mockCreateSiteWithRelationsUseCase;
  late MockUpdateSiteUseCase mockUpdateSiteUseCase;
  late MockDeleteSiteUseCase mockDeleteSiteUseCase;
  late MockGetUserIdFromLocalStorageUseCase mockGetUserIdUseCase;
  late MockGetSiteByIdUseCase mockGetSiteByIdUseCase;
  late MockGetUserLocationUseCase mockGetUserLocationUseCase;
  late MockFormDataProcessor mockFormDataProcessor;
  late MockSitesDatabase mockSitesDatabase;

  const testModuleId = 1;
  const testSiteGroupId = 0; // 0 = pas de chargement auto au constructeur

  setUpAll(() {
    registerFallbackValue(const BaseSite(idBaseSite: 0));
    registerFallbackValue(const SiteComplement(idBaseSite: 0));
    registerFallbackValue(<SiteComplement>[]);
  });

  setUp(() {
    mockCreateSiteWithRelationsUseCase = MockCreateSiteWithRelationsUseCase();
    mockUpdateSiteUseCase = MockUpdateSiteUseCase();
    mockDeleteSiteUseCase = MockDeleteSiteUseCase();
    mockGetUserIdUseCase = MockGetUserIdFromLocalStorageUseCase();
    mockGetSiteByIdUseCase = MockGetSiteByIdUseCase();
    mockGetUserLocationUseCase = MockGetUserLocationUseCase();
    mockFormDataProcessor = MockFormDataProcessor();
    mockSitesDatabase = MockSitesDatabase();

    viewModel = SiteFormViewModel(
      mockCreateSiteWithRelationsUseCase,
      mockUpdateSiteUseCase,
      mockDeleteSiteUseCase,
      mockGetUserIdUseCase,
      mockGetSiteByIdUseCase,
      mockGetUserLocationUseCase,
      mockFormDataProcessor,
      mockSitesDatabase,
      testModuleId,
      testSiteGroupId,
    );
  });

  group('createSiteFromFormData', () {
    test('crée un site avec géométrie fournie (geomOverride)', () async {
      // Arrange
      final formData = {
        'base_site_name': 'Mon Site',
        'base_site_code': 'MS001',
      };
      final processedData = Map<String, dynamic>.from(formData);
      const geomOverride =
          '{"type":"Point","coordinates":[2.35,48.85]}';

      when(() => mockFormDataProcessor.processFormData(any()))
          .thenAnswer((_) async => processedData);
      when(() => mockGetUserIdUseCase.execute()).thenAnswer((_) async => 42);
      when(() => mockCreateSiteWithRelationsUseCase.execute(
            site: any(named: 'site'),
            moduleId: any(named: 'moduleId'),
            complement: any(named: 'complement'),
          )).thenAnswer((_) async => 99);

      // Act
      final result = await viewModel.createSiteFromFormData(
        formData,
        geomOverride: geomOverride,
      );

      // Assert
      expect(result, 99);
      final captured = verify(() => mockCreateSiteWithRelationsUseCase.execute(
            site: captureAny(named: 'site'),
            moduleId: any(named: 'moduleId'),
            complement: any(named: 'complement'),
          )).captured;
      final createdSite = captured.first as BaseSite;
      expect(createdSite.baseSiteName, 'Mon Site');
      expect(createdSite.geom, geomOverride);
      expect(createdSite.isLocal, true);
    });

    test('crée un site avec position GPS quand geomOverride est null',
        () async {
      // Arrange
      final formData = {'base_site_name': 'GPS Site'};
      when(() => mockFormDataProcessor.processFormData(any()))
          .thenAnswer((_) async => formData);
      when(() => mockGetUserIdUseCase.execute()).thenAnswer((_) async => 1);
      when(() => mockGetUserLocationUseCase.execute())
          .thenAnswer((_) async => null);
      when(() => mockCreateSiteWithRelationsUseCase.execute(
            site: any(named: 'site'),
            moduleId: any(named: 'moduleId'),
            complement: any(named: 'complement'),
          )).thenAnswer((_) async => 10);

      // Act
      final result = await viewModel.createSiteFromFormData(formData);

      // Assert
      expect(result, 10);
      verify(() => mockGetUserLocationUseCase.execute()).called(1);
    });

    test('inclut le complement avec id_sites_group quand siteGroupId > 0',
        () async {
      // Arrange - recréer le viewModel avec un siteGroupId > 0
      final vm = SiteFormViewModel(
        mockCreateSiteWithRelationsUseCase,
        mockUpdateSiteUseCase,
        mockDeleteSiteUseCase,
        mockGetUserIdUseCase,
        mockGetSiteByIdUseCase,
        mockGetUserLocationUseCase,
        mockFormDataProcessor,
        mockSitesDatabase,
        testModuleId,
        5, // siteGroupId > 0
      );

      final formData = {
        'base_site_name': 'Site In Group',
        'custom_field': 'custom_value',
      };
      when(() => mockFormDataProcessor.processFormData(any()))
          .thenAnswer((_) async => formData);
      when(() => mockGetUserIdUseCase.execute()).thenAnswer((_) async => 1);
      when(() => mockGetUserLocationUseCase.execute())
          .thenAnswer((_) async => null);
      when(() => mockCreateSiteWithRelationsUseCase.execute(
            site: any(named: 'site'),
            moduleId: any(named: 'moduleId'),
            complement: any(named: 'complement'),
          )).thenAnswer((_) async => 20);

      // Act
      final result = await vm.createSiteFromFormData(formData);

      // Assert
      expect(result, 20);
      final captured = verify(() => mockCreateSiteWithRelationsUseCase.execute(
            site: any(named: 'site'),
            moduleId: any(named: 'moduleId'),
            complement: captureAny(named: 'complement'),
          )).captured;
      final complement = captured.first as SiteComplement;
      expect(complement.idSitesGroup, 5);
    });

    test('propage les exceptions', () async {
      // Arrange
      when(() => mockFormDataProcessor.processFormData(any()))
          .thenThrow(Exception('Processing error'));

      // Act & Assert
      expect(
        () => viewModel.createSiteFromFormData({'field': 'value'}),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('updateSiteFromFormData', () {
    test('retourne false si le site n\'est pas local', () async {
      // Arrange
      const existingSite = BaseSite(
        idBaseSite: 1,
        isLocal: false, // pas créé localement
      );

      // Act
      final result = await viewModel.updateSiteFromFormData(
        {'base_site_name': 'Updated'},
        existingSite,
      );

      // Assert
      expect(result, false);
      verifyNever(() => mockFormDataProcessor.processFormData(any()));
    });

    test('retourne false si le site a déjà un serverSiteId', () async {
      // Arrange
      const existingSite = BaseSite(
        idBaseSite: 1,
        isLocal: true,
        serverSiteId: 42, // déjà synchronisé
      );

      // Act
      final result = await viewModel.updateSiteFromFormData(
        {'base_site_name': 'Updated'},
        existingSite,
      );

      // Assert
      expect(result, false);
    });

    test('met à jour un site local non synchronisé avec succès', () async {
      // Arrange
      const existingSite = BaseSite(
        idBaseSite: 10,
        baseSiteName: 'Old Name',
        isLocal: true,
        serverSiteId: null,
      );
      final formData = {
        'base_site_name': 'New Name',
        'base_site_code': 'NC001',
        'custom_field': 'custom_value',
      };
      when(() => mockFormDataProcessor.processFormData(any()))
          .thenAnswer((_) async => formData);
      when(() => mockGetUserIdUseCase.execute()).thenAnswer((_) async => 1);
      when(() => mockUpdateSiteUseCase.execute(any()))
          .thenAnswer((_) async => true);
      when(() => mockSitesDatabase.insertSiteComplements(any()))
          .thenAnswer((_) async {});

      // Act
      final result =
          await viewModel.updateSiteFromFormData(formData, existingSite);

      // Assert
      expect(result, true);
      final captured =
          verify(() => mockUpdateSiteUseCase.execute(captureAny())).captured;
      final updatedSite = captured.first as BaseSite;
      expect(updatedSite.baseSiteName, 'New Name');
      expect(updatedSite.baseSiteCode, 'NC001');
      expect(updatedSite.idBaseSite, 10);
    });

    test('met à jour les compléments après mise à jour réussie', () async {
      // Arrange
      const existingSite = BaseSite(
        idBaseSite: 10,
        isLocal: true,
        serverSiteId: null,
      );
      final formData = {
        'base_site_name': 'Name',
        'custom_nomenclature': 42,
      };
      when(() => mockFormDataProcessor.processFormData(any()))
          .thenAnswer((_) async => formData);
      when(() => mockGetUserIdUseCase.execute()).thenAnswer((_) async => 1);
      when(() => mockUpdateSiteUseCase.execute(any()))
          .thenAnswer((_) async => true);
      when(() => mockSitesDatabase.insertSiteComplements(any()))
          .thenAnswer((_) async {});

      // Act
      await viewModel.updateSiteFromFormData(formData, existingSite);

      // Assert
      verify(() => mockSitesDatabase.insertSiteComplements(any())).called(1);
    });

    test('retourne false quand le update échoue', () async {
      // Arrange
      const existingSite = BaseSite(
        idBaseSite: 10,
        isLocal: true,
        serverSiteId: null,
      );
      when(() => mockFormDataProcessor.processFormData(any()))
          .thenAnswer((_) async => {'base_site_name': 'Name'});
      when(() => mockGetUserIdUseCase.execute()).thenAnswer((_) async => 1);
      when(() => mockUpdateSiteUseCase.execute(any()))
          .thenAnswer((_) async => false);

      // Act
      final result = await viewModel.updateSiteFromFormData(
        {'base_site_name': 'Name'},
        existingSite,
      );

      // Assert
      expect(result, false);
      verifyNever(() => mockSitesDatabase.insertSiteComplements(any()));
    });

    test('utilise geomOverride quand fourni', () async {
      // Arrange
      const existingSite = BaseSite(
        idBaseSite: 10,
        isLocal: true,
        geom: '{"type":"Point","coordinates":[0,0]}',
      );
      const newGeom = '{"type":"Point","coordinates":[3.0,45.0]}';
      when(() => mockFormDataProcessor.processFormData(any()))
          .thenAnswer((_) async => {'base_site_name': 'Name'});
      when(() => mockGetUserIdUseCase.execute()).thenAnswer((_) async => 1);
      when(() => mockUpdateSiteUseCase.execute(any()))
          .thenAnswer((_) async => true);
      when(() => mockSitesDatabase.insertSiteComplements(any()))
          .thenAnswer((_) async {});

      // Act
      await viewModel.updateSiteFromFormData(
        {'base_site_name': 'Name'},
        existingSite,
        geomOverride: newGeom,
      );

      // Assert
      final captured =
          verify(() => mockUpdateSiteUseCase.execute(captureAny())).captured;
      final updatedSite = captured.first as BaseSite;
      expect(updatedSite.geom, newGeom);
    });
  });

  group('deleteSite', () {
    test('délègue au use case et retourne true', () async {
      // Arrange
      when(() => mockDeleteSiteUseCase.execute(42))
          .thenAnswer((_) async => true);

      // Act
      final result = await viewModel.deleteSite(42);

      // Assert
      expect(result, true);
      verify(() => mockDeleteSiteUseCase.execute(42)).called(1);
    });

    test('retourne false en cas d\'exception', () async {
      // Arrange
      when(() => mockDeleteSiteUseCase.execute(42))
          .thenThrow(Exception('Delete error'));

      // Act
      final result = await viewModel.deleteSite(42);

      // Assert
      expect(result, false);
    });
  });

  group('getSiteById', () {
    test('retourne le site quand trouvé', () async {
      // Arrange
      const site = BaseSite(idBaseSite: 1, baseSiteName: 'Found Site');
      when(() => mockGetSiteByIdUseCase.execute(1))
          .thenAnswer((_) async => site);

      // Act
      final result = await viewModel.getSiteById(1);

      // Assert
      expect(result, isNotNull);
      expect(result!.baseSiteName, 'Found Site');
    });

    test('retourne null quand non trouvé', () async {
      // Arrange
      when(() => mockGetSiteByIdUseCase.execute(999))
          .thenAnswer((_) async => null);

      // Act
      final result = await viewModel.getSiteById(999);

      // Assert
      expect(result, isNull);
    });

    test('retourne null en cas d\'exception', () async {
      // Arrange
      when(() => mockGetSiteByIdUseCase.execute(1))
          .thenThrow(Exception('Error'));

      // Act
      final result = await viewModel.getSiteById(1);

      // Assert
      expect(result, isNull);
    });
  });

  group('_prepareComplementData (testé via createSiteFromFormData)', () {
    test('convertit types_site de List<String> en List<int>', () async {
      // Arrange
      final formData = {
        'base_site_name': 'Site Test',
        'types_site': ['1', '2', '3'],
      };
      when(() => mockFormDataProcessor.processFormData(any()))
          .thenAnswer((_) async => formData);
      when(() => mockGetUserIdUseCase.execute()).thenAnswer((_) async => 1);
      when(() => mockGetUserLocationUseCase.execute())
          .thenAnswer((_) async => null);
      when(() => mockCreateSiteWithRelationsUseCase.execute(
            site: any(named: 'site'),
            moduleId: any(named: 'moduleId'),
            complement: any(named: 'complement'),
          )).thenAnswer((_) async => 1);

      // Act
      await viewModel.createSiteFromFormData(formData);

      // Assert
      final captured = verify(() => mockCreateSiteWithRelationsUseCase.execute(
            site: any(named: 'site'),
            moduleId: any(named: 'moduleId'),
            complement: captureAny(named: 'complement'),
          )).captured;
      final complement = captured.first as SiteComplement;
      final data = jsonDecode(complement.data!) as Map<String, dynamic>;
      expect(data['types_site'], equals([1, 2, 3]));
    });

    test('sépare les champs de base des champs de complément', () async {
      // Arrange
      final formData = {
        'base_site_name': 'Site Test',
        'base_site_code': 'ST001',
        'custom_field': 'custom_value',
        'id_nomenclature_type_site': 5,
      };
      when(() => mockFormDataProcessor.processFormData(any()))
          .thenAnswer((_) async => formData);
      when(() => mockGetUserIdUseCase.execute()).thenAnswer((_) async => 1);
      when(() => mockGetUserLocationUseCase.execute())
          .thenAnswer((_) async => null);
      when(() => mockCreateSiteWithRelationsUseCase.execute(
            site: any(named: 'site'),
            moduleId: any(named: 'moduleId'),
            complement: any(named: 'complement'),
          )).thenAnswer((_) async => 1);

      // Act
      await viewModel.createSiteFromFormData(formData);

      // Assert
      final captured = verify(() => mockCreateSiteWithRelationsUseCase.execute(
            site: any(named: 'site'),
            moduleId: any(named: 'moduleId'),
            complement: captureAny(named: 'complement'),
          )).captured;
      final complement = captured.first as SiteComplement;
      final data = jsonDecode(complement.data!) as Map<String, dynamic>;
      // Les champs de base ne doivent PAS être dans le complément
      expect(data.containsKey('base_site_name'), false);
      expect(data.containsKey('base_site_code'), false);
      // Les champs custom DOIVENT être dans le complément
      expect(data['custom_field'], 'custom_value');
      expect(data['id_nomenclature_type_site'], 5);
    });
  });
}
