import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_site_group_with_relations_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_site_group_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_site_groups_by_id_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_site_group_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/form_data_processor.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_group_form_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockCreateSiteGroupWithRelationsUseCase extends Mock
    implements CreateSiteGroupWithRelationsUseCase {}

class MockUpdateSiteGroupUseCase extends Mock
    implements UpdateSiteGroupUseCase {}

class MockDeleteSiteGroupUseCase extends Mock
    implements DeleteSiteGroupUseCase {}

class MockGetUserIdFromLocalStorageUseCase extends Mock
    implements GetUserIdFromLocalStorageUseCase {}

class MockGetSiteGroupsByIdUseCase extends Mock
    implements GetSiteGroupsByIdUseCase {}

class MockFormDataProcessor extends Mock implements FormDataProcessor {}

void main() {
  late SiteGroupFormViewModel viewModel;
  late MockCreateSiteGroupWithRelationsUseCase
      mockCreateSiteGroupWithRelationsUseCase;
  late MockUpdateSiteGroupUseCase mockUpdateSiteGroupUseCase;
  late MockDeleteSiteGroupUseCase mockDeleteSiteGroupUseCase;
  late MockGetUserIdFromLocalStorageUseCase mockGetUserIdUseCase;
  late MockGetSiteGroupsByIdUseCase mockGetSiteGroupsByIdUseCase;
  late MockFormDataProcessor mockFormDataProcessor;

  const testModuleId = 1;
  const testSiteGroupId = 0; // 0 = pas de chargement auto au constructeur

  setUpAll(() {
    registerFallbackValue(const SiteGroup(idSitesGroup: 0));
  });

  setUp(() {
    mockCreateSiteGroupWithRelationsUseCase =
        MockCreateSiteGroupWithRelationsUseCase();
    mockUpdateSiteGroupUseCase = MockUpdateSiteGroupUseCase();
    mockDeleteSiteGroupUseCase = MockDeleteSiteGroupUseCase();
    mockGetUserIdUseCase = MockGetUserIdFromLocalStorageUseCase();
    mockGetSiteGroupsByIdUseCase = MockGetSiteGroupsByIdUseCase();
    mockFormDataProcessor = MockFormDataProcessor();

    viewModel = SiteGroupFormViewModel(
      mockCreateSiteGroupWithRelationsUseCase,
      mockUpdateSiteGroupUseCase,
      mockDeleteSiteGroupUseCase,
      mockGetUserIdUseCase,
      mockGetSiteGroupsByIdUseCase,
      mockFormDataProcessor,
      testModuleId,
      testSiteGroupId,
    );
  });

  group('createSiteGroupFromFormData', () {
    test('crée un groupe de sites avec succès', () async {
      // Arrange
      final formData = {
        'sites_group_name': 'Mon Groupe',
        'sites_group_code': 'MG001',
        'sites_group_description': 'Description du groupe',
      };
      when(() => mockFormDataProcessor.processFormData(any()))
          .thenAnswer((_) async => formData);
      when(() => mockGetUserIdUseCase.execute()).thenAnswer((_) async => 42);
      when(() => mockCreateSiteGroupWithRelationsUseCase.execute(
            siteGroup: any(named: 'siteGroup'),
            moduleId: any(named: 'moduleId'),
          )).thenAnswer((_) async => 99);

      // Act
      final result = await viewModel.createSiteGroupFromFormData(formData);

      // Assert
      expect(result, 99);
      final captured =
          verify(() => mockCreateSiteGroupWithRelationsUseCase.execute(
                siteGroup: captureAny(named: 'siteGroup'),
                moduleId: any(named: 'moduleId'),
              )).captured;
      final createdGroup = captured.first as SiteGroup;
      expect(createdGroup.sitesGroupName, 'Mon Groupe');
      expect(createdGroup.sitesGroupCode, 'MG001');
      expect(createdGroup.isLocal, true);
      expect(createdGroup.idDigitiser, 42);
    });

    test('utilise le moduleId fourni au lieu du moduleId par défaut',
        () async {
      // Arrange
      final formData = {'sites_group_name': 'Group'};
      when(() => mockFormDataProcessor.processFormData(any()))
          .thenAnswer((_) async => formData);
      when(() => mockGetUserIdUseCase.execute()).thenAnswer((_) async => 1);
      when(() => mockCreateSiteGroupWithRelationsUseCase.execute(
            siteGroup: any(named: 'siteGroup'),
            moduleId: any(named: 'moduleId'),
          )).thenAnswer((_) async => 1);

      // Act
      await viewModel.createSiteGroupFromFormData(formData, moduleId: 77);

      // Assert
      verify(() => mockCreateSiteGroupWithRelationsUseCase.execute(
            siteGroup: any(named: 'siteGroup'),
            moduleId: 77,
          )).called(1);
    });

    test('inclut les champs dynamiques dans data', () async {
      // Arrange
      final formData = {
        'sites_group_name': 'Group',
        'custom_dynamic_field': 'dynamic_value',
        'another_field': 123,
      };
      when(() => mockFormDataProcessor.processFormData(any()))
          .thenAnswer((_) async => formData);
      when(() => mockGetUserIdUseCase.execute()).thenAnswer((_) async => 1);
      when(() => mockCreateSiteGroupWithRelationsUseCase.execute(
            siteGroup: any(named: 'siteGroup'),
            moduleId: any(named: 'moduleId'),
          )).thenAnswer((_) async => 1);

      // Act
      await viewModel.createSiteGroupFromFormData(formData);

      // Assert
      final captured =
          verify(() => mockCreateSiteGroupWithRelationsUseCase.execute(
                siteGroup: captureAny(named: 'siteGroup'),
                moduleId: any(named: 'moduleId'),
              )).captured;
      final createdGroup = captured.first as SiteGroup;
      final data = jsonDecode(createdGroup.data!) as Map<String, dynamic>;
      expect(data['custom_dynamic_field'], 'dynamic_value');
      expect(data['another_field'], 123);
      // Les champs de base ne doivent pas être dans data
      expect(data.containsKey('sites_group_name'), false);
    });

    test('propage les exceptions', () async {
      // Arrange
      when(() => mockFormDataProcessor.processFormData(any()))
          .thenThrow(Exception('Processing error'));

      // Act & Assert
      expect(
        () => viewModel.createSiteGroupFromFormData({'field': 'value'}),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('updateSiteGroupFromFormData', () {
    test('met à jour un groupe de sites avec succès', () async {
      // Arrange
      const existingGroup = SiteGroup(
        idSitesGroup: 10,
        sitesGroupName: 'Old Name',
        isLocal: true,
      );
      final formData = {
        'sites_group_name': 'New Name',
        'sites_group_code': 'NG001',
        'comments': 'Updated comments',
        'custom_field': 'custom_value',
      };
      when(() => mockFormDataProcessor.processFormData(any()))
          .thenAnswer((_) async => formData);
      when(() => mockGetUserIdUseCase.execute()).thenAnswer((_) async => 1);
      when(() => mockUpdateSiteGroupUseCase.execute(any()))
          .thenAnswer((_) async => true);

      // Act
      final result = await viewModel.updateSiteGroupFromFormData(
        formData,
        existingGroup,
      );

      // Assert
      expect(result, true);
      final captured = verify(
              () => mockUpdateSiteGroupUseCase.execute(captureAny()))
          .captured;
      final updatedGroup = captured.first as SiteGroup;
      expect(updatedGroup.sitesGroupName, 'New Name');
      expect(updatedGroup.sitesGroupCode, 'NG001');
      expect(updatedGroup.comments, 'Updated comments');
      // Les champs dynamiques doivent être dans data
      final data = jsonDecode(updatedGroup.data!) as Map<String, dynamic>;
      expect(data['custom_field'], 'custom_value');
    });

    test('gère altitude_min et altitude_max en tant que String', () async {
      // Arrange
      const existingGroup = SiteGroup(idSitesGroup: 10, isLocal: true);
      final formData = {
        'sites_group_name': 'Group',
        'altitude_min': '150',
        'altitude_max': '300',
      };
      when(() => mockFormDataProcessor.processFormData(any()))
          .thenAnswer((_) async => formData);
      when(() => mockGetUserIdUseCase.execute()).thenAnswer((_) async => 1);
      when(() => mockUpdateSiteGroupUseCase.execute(any()))
          .thenAnswer((_) async => true);

      // Act
      final result = await viewModel.updateSiteGroupFromFormData(
        formData,
        existingGroup,
      );

      // Assert
      expect(result, true);
      final captured = verify(
              () => mockUpdateSiteGroupUseCase.execute(captureAny()))
          .captured;
      final updatedGroup = captured.first as SiteGroup;
      expect(updatedGroup.altitudeMin, 150);
      expect(updatedGroup.altitudeMax, 300);
    });

    test('retourne false en cas d\'erreur', () async {
      // Arrange
      const existingGroup = SiteGroup(idSitesGroup: 10, isLocal: true);
      when(() => mockFormDataProcessor.processFormData(any()))
          .thenThrow(Exception('Processing error'));

      // Act
      final result = await viewModel.updateSiteGroupFromFormData(
        {'sites_group_name': 'Name'},
        existingGroup,
      );

      // Assert
      expect(result, false);
    });

    test('retourne false quand le use case échoue', () async {
      // Arrange
      const existingGroup = SiteGroup(idSitesGroup: 10, isLocal: true);
      when(() => mockFormDataProcessor.processFormData(any()))
          .thenAnswer((_) async => {'sites_group_name': 'Name'});
      when(() => mockGetUserIdUseCase.execute()).thenAnswer((_) async => 1);
      when(() => mockUpdateSiteGroupUseCase.execute(any()))
          .thenAnswer((_) async => false);

      // Act
      final result = await viewModel.updateSiteGroupFromFormData(
        {'sites_group_name': 'Name'},
        existingGroup,
      );

      // Assert
      expect(result, false);
    });
  });

  group('deleteSiteGroup', () {
    test('délègue au use case et retourne true', () async {
      // Arrange
      when(() => mockDeleteSiteGroupUseCase.execute(42))
          .thenAnswer((_) async => true);

      // Act
      final result = await viewModel.deleteSiteGroup(42);

      // Assert
      expect(result, true);
      verify(() => mockDeleteSiteGroupUseCase.execute(42)).called(1);
    });

    test('retourne false en cas d\'exception', () async {
      // Arrange
      when(() => mockDeleteSiteGroupUseCase.execute(42))
          .thenThrow(Exception('Delete error'));

      // Act
      final result = await viewModel.deleteSiteGroup(42);

      // Assert
      expect(result, false);
    });
  });

  group('getSiteGroupById', () {
    test('retourne le groupe quand trouvé', () async {
      // Arrange
      const group =
          SiteGroup(idSitesGroup: 1, sitesGroupName: 'Found Group');
      when(() => mockGetSiteGroupsByIdUseCase.execute(1))
          .thenAnswer((_) async => group);

      // Act
      final result = await viewModel.getSiteGroupById(1);

      // Assert
      expect(result, isNotNull);
      expect(result!.sitesGroupName, 'Found Group');
    });

    test('retourne null quand non trouvé', () async {
      // Arrange
      when(() => mockGetSiteGroupsByIdUseCase.execute(999))
          .thenAnswer((_) async => null);

      // Act
      final result = await viewModel.getSiteGroupById(999);

      // Assert
      expect(result, isNull);
    });

    test('retourne null en cas d\'exception', () async {
      // Arrange
      when(() => mockGetSiteGroupsByIdUseCase.execute(1))
          .thenThrow(Exception('Error'));

      // Act
      final result = await viewModel.getSiteGroupById(1);

      // Assert
      expect(result, isNull);
    });
  });

  group('_extractDynamicFields (testé via createSiteGroupFromFormData)', () {
    test('exclut tous les champs de base de SiteGroup', () async {
      // Arrange
      final formData = {
        'sites_group_name': 'Name',
        'sites_group_code': 'Code',
        'sites_group_description': 'Desc',
        'comments': 'Comment',
        'altitude_min': 100,
        'altitude_max': 200,
        'id_digitiser': 1,
        'id_sites_group': 10,
        'meta_create_date': '2024-01-01',
        'meta_update_date': '2024-01-01',
        'geom': '{}',
        'uuid_sites_group': 'uuid',
        'dynamic_field': 'should_be_in_data',
      };
      when(() => mockFormDataProcessor.processFormData(any()))
          .thenAnswer((_) async => formData);
      when(() => mockGetUserIdUseCase.execute()).thenAnswer((_) async => 1);
      when(() => mockCreateSiteGroupWithRelationsUseCase.execute(
            siteGroup: any(named: 'siteGroup'),
            moduleId: any(named: 'moduleId'),
          )).thenAnswer((_) async => 1);

      // Act
      await viewModel.createSiteGroupFromFormData(formData);

      // Assert
      final captured =
          verify(() => mockCreateSiteGroupWithRelationsUseCase.execute(
                siteGroup: captureAny(named: 'siteGroup'),
                moduleId: any(named: 'moduleId'),
              )).captured;
      final createdGroup = captured.first as SiteGroup;
      final data = jsonDecode(createdGroup.data!) as Map<String, dynamic>;
      // Seul le champ dynamique doit être présent dans data
      expect(data.length, 1);
      expect(data['dynamic_field'], 'should_be_in_data');
    });

    test('retourne null pour data quand aucun champ dynamique', () async {
      // Arrange
      final formData = {
        'sites_group_name': 'Name',
        'sites_group_code': 'Code',
      };
      when(() => mockFormDataProcessor.processFormData(any()))
          .thenAnswer((_) async => formData);
      when(() => mockGetUserIdUseCase.execute()).thenAnswer((_) async => 1);
      when(() => mockCreateSiteGroupWithRelationsUseCase.execute(
            siteGroup: any(named: 'siteGroup'),
            moduleId: any(named: 'moduleId'),
          )).thenAnswer((_) async => 1);

      // Act
      await viewModel.createSiteGroupFromFormData(formData);

      // Assert
      final captured =
          verify(() => mockCreateSiteGroupWithRelationsUseCase.execute(
                siteGroup: captureAny(named: 'siteGroup'),
                moduleId: any(named: 'moduleId'),
              )).captured;
      final createdGroup = captured.first as SiteGroup;
      expect(createdGroup.data, isNull);
    });

    test('exclut les valeurs null des champs dynamiques', () async {
      // Arrange
      final formData = {
        'sites_group_name': 'Name',
        'dynamic_field': 'value',
        'null_field': null,
      };
      when(() => mockFormDataProcessor.processFormData(any()))
          .thenAnswer((_) async => formData);
      when(() => mockGetUserIdUseCase.execute()).thenAnswer((_) async => 1);
      when(() => mockCreateSiteGroupWithRelationsUseCase.execute(
            siteGroup: any(named: 'siteGroup'),
            moduleId: any(named: 'moduleId'),
          )).thenAnswer((_) async => 1);

      // Act
      await viewModel.createSiteGroupFromFormData(formData);

      // Assert
      final captured =
          verify(() => mockCreateSiteGroupWithRelationsUseCase.execute(
                siteGroup: captureAny(named: 'siteGroup'),
                moduleId: any(named: 'moduleId'),
              )).captured;
      final createdGroup = captured.first as SiteGroup;
      final data = jsonDecode(createdGroup.data!) as Map<String, dynamic>;
      expect(data.containsKey('null_field'), false);
      expect(data['dynamic_field'], 'value');
    });
  });

  group('_parseIntOrNull (testé indirectement)', () {
    test('gère int correctement', () async {
      // Arrange
      const existingGroup = SiteGroup(idSitesGroup: 10, isLocal: true);
      final formData = {
        'sites_group_name': 'Group',
        'altitude_min': 100,
      };
      when(() => mockFormDataProcessor.processFormData(any()))
          .thenAnswer((_) async => formData);
      when(() => mockGetUserIdUseCase.execute()).thenAnswer((_) async => 1);
      when(() => mockUpdateSiteGroupUseCase.execute(any()))
          .thenAnswer((_) async => true);

      // Act
      await viewModel.updateSiteGroupFromFormData(formData, existingGroup);

      // Assert
      final captured = verify(
              () => mockUpdateSiteGroupUseCase.execute(captureAny()))
          .captured;
      final updatedGroup = captured.first as SiteGroup;
      expect(updatedGroup.altitudeMin, 100);
    });

    test('gère null correctement', () async {
      // Arrange
      const existingGroup = SiteGroup(
        idSitesGroup: 10,
        isLocal: true,
        altitudeMin: 500,
      );
      final formData = {
        'sites_group_name': 'Group',
        'altitude_min': null,
      };
      when(() => mockFormDataProcessor.processFormData(any()))
          .thenAnswer((_) async => formData);
      when(() => mockGetUserIdUseCase.execute()).thenAnswer((_) async => 1);
      when(() => mockUpdateSiteGroupUseCase.execute(any()))
          .thenAnswer((_) async => true);

      // Act
      await viewModel.updateSiteGroupFromFormData(formData, existingGroup);

      // Assert
      final captured = verify(
              () => mockUpdateSiteGroupUseCase.execute(captureAny()))
          .captured;
      final updatedGroup = captured.first as SiteGroup;
      expect(updatedGroup.altitudeMin, isNull);
    });

    test('gère double/num correctement', () async {
      // Arrange
      const existingGroup = SiteGroup(idSitesGroup: 10, isLocal: true);
      final formData = {
        'sites_group_name': 'Group',
        'altitude_min': 150.7,
      };
      when(() => mockFormDataProcessor.processFormData(any()))
          .thenAnswer((_) async => formData);
      when(() => mockGetUserIdUseCase.execute()).thenAnswer((_) async => 1);
      when(() => mockUpdateSiteGroupUseCase.execute(any()))
          .thenAnswer((_) async => true);

      // Act
      await viewModel.updateSiteGroupFromFormData(formData, existingGroup);

      // Assert
      final captured = verify(
              () => mockUpdateSiteGroupUseCase.execute(captureAny()))
          .captured;
      final updatedGroup = captured.first as SiteGroup;
      expect(updatedGroup.altitudeMin, 150);
    });
  });
}
