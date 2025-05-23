import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_visit_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_visit_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_name_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visit_complement_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visit_with_details_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visits_by_site_and_module_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/save_visit_complement_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_visit_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/datasets_service.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_visits_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockGetVisitsBySiteAndModuleUseCase extends Mock
    implements GetVisitsBySiteAndModuleUseCase {}

class MockGetVisitWithDetailsUseCase extends Mock
    implements GetVisitWithDetailsUseCase {}

class MockGetVisitComplementUseCase extends Mock
    implements GetVisitComplementUseCase {}

class MockSaveVisitComplementUseCase extends Mock
    implements SaveVisitComplementUseCase {}

class MockCreateVisitUseCase extends Mock implements CreateVisitUseCase {}

class MockUpdateVisitUseCase extends Mock implements UpdateVisitUseCase {}

class MockDeleteVisitUseCase extends Mock implements DeleteVisitUseCase {}

class MockGetUserIdFromLocalStorageUseCase extends Mock
    implements GetUserIdFromLocalStorageUseCase {}

class MockGetUserNameFromLocalStorageUseCase extends Mock
    implements GetUserNameFromLocalStorageUseCase {}

class MockDatasetService extends Mock implements DatasetService {}

// Fake class for BaseVisit to use as fallback
class FakeBaseVisit extends Fake implements BaseVisit {}

void main() {
  setUpAll(() {
    // Register fallback values for any() matcher
    registerFallbackValue(FakeBaseVisit());
    registerFallbackValue(const BaseVisit(
      idBaseVisit: 0,
      idDataset: 1,
      idModule: 1,
      visitDateMin: '2023-01-01',
    ));
  });
  late MockGetVisitsBySiteAndModuleUseCase mockGetVisitsBySiteAndModuleUseCase;
  late MockGetVisitWithDetailsUseCase mockGetVisitWithDetailsUseCase;
  late MockGetVisitComplementUseCase mockGetVisitComplementUseCase;
  late MockSaveVisitComplementUseCase mockSaveVisitComplementUseCase;
  late MockCreateVisitUseCase mockCreateVisitUseCase;
  late MockUpdateVisitUseCase mockUpdateVisitUseCase;
  late MockDeleteVisitUseCase mockDeleteVisitUseCase;
  late MockGetUserIdFromLocalStorageUseCase mockGetUserIdUseCase;
  late MockGetUserNameFromLocalStorageUseCase mockGetUserNameUseCase;
  late MockDatasetService mockDatasetService;
  late SiteVisitsViewModel viewModel;
  const int testSiteId = 1;
  const int testUserId = 42;
  const String testUserName = "Test User";

  setUp(() {
    mockGetVisitsBySiteAndModuleUseCase = MockGetVisitsBySiteAndModuleUseCase();
    mockGetVisitWithDetailsUseCase = MockGetVisitWithDetailsUseCase();
    mockGetVisitComplementUseCase = MockGetVisitComplementUseCase();
    mockSaveVisitComplementUseCase = MockSaveVisitComplementUseCase();
    mockCreateVisitUseCase = MockCreateVisitUseCase();
    mockUpdateVisitUseCase = MockUpdateVisitUseCase();
    mockDeleteVisitUseCase = MockDeleteVisitUseCase();
    mockGetUserIdUseCase = MockGetUserIdFromLocalStorageUseCase();
    mockGetUserNameUseCase = MockGetUserNameFromLocalStorageUseCase();
    mockDatasetService = MockDatasetService();

    // Configure les mocks pour les use cases d'utilisateur
    when(() => mockGetUserIdUseCase.execute())
        .thenAnswer((_) async => testUserId);
    when(() => mockGetUserNameUseCase.execute())
        .thenAnswer((_) async => testUserName);

    // Simuler un chargement initial des visites
    when(() => mockGetVisitsBySiteAndModuleUseCase.execute(testSiteId, 1))
        .thenAnswer((_) async => []);

    // Configure mock behavior
    when(() => mockDatasetService.getDatasetsForModule(any()))
        .thenAnswer((_) async => []);

    viewModel = SiteVisitsViewModel(
      mockGetVisitsBySiteAndModuleUseCase,
      mockGetVisitWithDetailsUseCase,
      mockGetVisitComplementUseCase,
      mockSaveVisitComplementUseCase,
      mockCreateVisitUseCase,
      mockUpdateVisitUseCase,
      mockDeleteVisitUseCase,
      mockGetUserIdUseCase,
      mockGetUserNameUseCase,
      mockDatasetService,
      testSiteId,
      1, // moduleId is required
    );

    // Réinitialiser les compteurs d'appel après l'initialisation
    reset(mockGetVisitsBySiteAndModuleUseCase);
    reset(mockCreateVisitUseCase);
    reset(mockUpdateVisitUseCase);
    reset(mockDeleteVisitUseCase);
  });

  group('SiteVisitsViewModel - Basic operations', () {
    final testVisits = [
      BaseVisit(
        idBaseVisit: 1,
        idBaseSite: testSiteId,
        idDataset: 1,
        idModule: 1,
        visitDateMin: '2023-01-01',
      ),
      BaseVisit(
        idBaseVisit: 2,
        idBaseSite: testSiteId,
        idDataset: 1,
        idModule: 1,
        visitDateMin: '2023-01-02',
      ),
    ];

    final testSite = BaseSite(
      idBaseSite: testSiteId,
      baseSiteName: 'Test Site',
      baseSiteCode: 'TEST',
      firstUseDate: DateTime.now(),
    );

    test(
        'initial state should be data after setUp due to mock returning empty list',
        () {
      // We've mocked the initial load to return an empty list, so we should start with a data state
      expect(viewModel.state, isA<AsyncData<List<BaseVisit>>>());
    });

    test('loadVisits should update state with visits from use case', () async {
      // Arrange
      when(() => mockGetVisitsBySiteAndModuleUseCase.execute(testSiteId, 1))
          .thenAnswer((_) async => testVisits);

      // Act
      await viewModel.loadVisits();

      // Assert
      expect(viewModel.state, AsyncValue.data(testVisits));
      verify(() => mockGetVisitsBySiteAndModuleUseCase.execute(testSiteId, 1))
          .called(1);
    });

    test('loadVisits should handle error', () async {
      // Arrange
      final exception = Exception('Test error');
      when(() => mockGetVisitsBySiteAndModuleUseCase.execute(testSiteId, 1))
          .thenThrow(exception);

      // Act
      await viewModel.loadVisits();

      // Assert
      expect(viewModel.state.hasError, true);
      verify(() => mockGetVisitsBySiteAndModuleUseCase.execute(testSiteId, 1))
          .called(1);
    });

    test('getCurrentUserId should return user ID from use case', () async {
      // Act
      final userId = await viewModel.getCurrentUserId();

      // Assert
      expect(userId, testUserId);
      verify(() => mockGetUserIdUseCase.execute()).called(1);
    });

    test('getCurrentUserName should return user name from use case', () async {
      // Act
      final userName = await viewModel.getCurrentUserName();

      // Assert
      expect(userName, testUserName);
      verify(() => mockGetUserNameUseCase.execute()).called(1);
    });

    test('deleteVisit should call deleteVisitUseCase and reload visits',
        () async {
      // Arrange
      const visitIdToDelete = 1;

      when(() => mockDeleteVisitUseCase.execute(visitIdToDelete))
          .thenAnswer((_) async => true);

      when(() => mockGetVisitsBySiteAndModuleUseCase.execute(testSiteId, 1))
          .thenAnswer((_) async =>
              [testVisits[1]]); // Returned list without deleted visit

      // Act
      final result = await viewModel.deleteVisit(visitIdToDelete);

      // Assert
      expect(result, true);
      verify(() => mockDeleteVisitUseCase.execute(visitIdToDelete)).called(1);
      verify(() => mockGetVisitsBySiteAndModuleUseCase.execute(testSiteId, 1))
          .called(1);
    });

    test('deleteVisit should return false and not reload when use case fails',
        () async {
      // Arrange
      const visitIdToDelete = 1;

      when(() => mockDeleteVisitUseCase.execute(visitIdToDelete))
          .thenAnswer((_) async => false);

      // Act
      final result = await viewModel.deleteVisit(visitIdToDelete);

      // Assert
      expect(result, false);
      verify(() => mockDeleteVisitUseCase.execute(visitIdToDelete)).called(1);
      verifyNever(
          () => mockGetVisitsBySiteAndModuleUseCase.execute(testSiteId, 1));
    });

    test('deleteVisit should handle exceptions', () async {
      // Arrange
      const visitIdToDelete = 1;

      when(() => mockDeleteVisitUseCase.execute(visitIdToDelete))
          .thenThrow(Exception('Test error'));

      // Act & Assert
      expect(() => viewModel.deleteVisit(visitIdToDelete), throwsException);
      verify(() => mockDeleteVisitUseCase.execute(visitIdToDelete)).called(1);
    });
  });

  group('SiteVisitsViewModel - Form Data Processing', () {
    final testSite = BaseSite(
      idBaseSite: testSiteId,
      baseSiteName: 'Test Site',
      baseSiteCode: 'TEST',
      firstUseDate: DateTime.now(),
    );

    test(
        'createVisitFromFormData should convert form data and add current user to observers',
        () async {
      // Arrange
      final formData = {
        'visit_date_min': '2023-03-15',
        'comments': 'Test comment',
        'observers': [10, 20],
        'field1': 'value1',
        'field2': 42,
      };

      // Configure the mock to return a new ID
      when(() => mockCreateVisitUseCase.execute(any()))
          .thenAnswer((_) async => 3);

      when(() => mockGetVisitsBySiteAndModuleUseCase.execute(testSiteId, 1))
          .thenAnswer((_) async => []);

      // Act
      final result =
          await viewModel.createVisitFromFormData(formData, testSite);

      // Assert
      expect(result, 3);

      // Verify the use cases were called
      verify(() => mockCreateVisitUseCase.execute(any())).called(1);
      verify(() => mockGetVisitsBySiteAndModuleUseCase.execute(testSiteId, 1))
          .called(1);
    });

    test('createVisitFromFormData should work with empty observers list',
        () async {
      // Arrange
      final formData = {
        'visit_date_min': '2023-03-15',
        'comments': 'Test comment',
        'field1': 'value1',
      };

      // Configure the mock to return a new ID
      when(() => mockCreateVisitUseCase.execute(any()))
          .thenAnswer((_) async => 3);

      when(() => mockGetVisitsBySiteAndModuleUseCase.execute(testSiteId, 1))
          .thenAnswer((_) async => []);

      // Act
      final result =
          await viewModel.createVisitFromFormData(formData, testSite);

      // Assert
      expect(result, 3);

      // Verify the use cases were called
      verify(() => mockCreateVisitUseCase.execute(any())).called(1);
      verify(() => mockGetVisitsBySiteAndModuleUseCase.execute(testSiteId, 1))
          .called(1);
    });

    test(
        'createVisitFromFormData should not add duplicate current user to observers',
        () async {
      // Arrange
      final formData = {
        'visit_date_min': '2023-03-15',
        'comments': 'Test comment',
        'observers': [42, 20], // Already includes current user ID (42)
        'field1': 'value1',
      };

      // Configure the mock to return a new ID
      when(() => mockCreateVisitUseCase.execute(any()))
          .thenAnswer((_) async => 3);

      when(() => mockGetVisitsBySiteAndModuleUseCase.execute(testSiteId, 1))
          .thenAnswer((_) async => []);

      // Act
      final result =
          await viewModel.createVisitFromFormData(formData, testSite);

      // Assert
      expect(result, 3);

      // Verify the use cases were called
      verify(() => mockCreateVisitUseCase.execute(any())).called(1);
      verify(() => mockGetVisitsBySiteAndModuleUseCase.execute(testSiteId, 1))
          .called(1);
    });

    test(
        'updateVisitFromFormData should convert form data and call updateVisitUseCase',
        () async {
      // Arrange
      const visitId = 5;
      final formData = {
        'visit_date_min': '2023-03-15',
        'comments': 'Updated comment',
        'observers': [10, 20],
        'field1': 'updated value',
        'field2': 99,
      };

      // Configure the mock to return true
      when(() => mockUpdateVisitUseCase.execute(any()))
          .thenAnswer((_) async => true);

      when(() => mockGetVisitsBySiteAndModuleUseCase.execute(testSiteId, 1))
          .thenAnswer((_) async => []);

      // Act
      final result =
          await viewModel.updateVisitFromFormData(formData, testSite, visitId);

      // Assert
      expect(result, true);

      // Verify the use cases were called
      verify(() => mockUpdateVisitUseCase.execute(any())).called(1);
      verify(() => mockGetVisitsBySiteAndModuleUseCase.execute(testSiteId, 1))
          .called(1);
    });

    test('updateVisitFromFormData should return false when update fails',
        () async {
      // Arrange
      const visitId = 5;
      final formData = {
        'visit_date_min': '2023-03-15',
        'comments': 'Updated comment',
        'observers': [10, 20],
        'field1': 'updated value',
        'field2': 99,
      };

      // Configurer le mock pour retourner false pour n'importe quelle visite
      when(() => mockUpdateVisitUseCase.execute(any()))
          .thenAnswer((_) async => false);

      when(() => mockGetVisitsBySiteAndModuleUseCase.execute(testSiteId, 1))
          .thenAnswer((_) async => []);

      // Act
      final result =
          await viewModel.updateVisitFromFormData(formData, testSite, visitId);

      // Assert
      expect(result, false);
      verify(() => mockUpdateVisitUseCase.execute(any())).called(1);
      verifyNever(
          () => mockGetVisitsBySiteAndModuleUseCase.execute(any(), any()));
    });

    test('updateVisitFromFormData should handle exceptions', () async {
      // Arrange
      const visitId = 5;
      final formData = {
        'visit_date_min': '2023-03-15',
      };

      when(() => mockUpdateVisitUseCase.execute(any()))
          .thenThrow(Exception('Test error'));

      when(() => mockGetVisitsBySiteAndModuleUseCase.execute(testSiteId, 1))
          .thenAnswer((_) async => []);

      // Act & Assert
      expect(
          () => viewModel.updateVisitFromFormData(formData, testSite, visitId),
          throwsException);
    });
  });

  group('SiteVisitsViewModel - Data Type Processing', () {
    final testSite = BaseSite(
      idBaseSite: testSiteId,
      baseSiteName: 'Test Site',
    );

    test('_formatDateValue should handle various date formats', () async {
      // Arrange
      final formData = {
        'visit_date_min': DateTime.parse('2023-03-15'),
        'visit_date_max': '2023-03-16T14:30:00',
        'date_field_empty': null,
      };

      // Configure the mock to return a new ID
      when(() => mockCreateVisitUseCase.execute(any()))
          .thenAnswer((_) async => 1);

      when(() => mockGetVisitsBySiteAndModuleUseCase.execute(testSiteId, 1))
          .thenAnswer((_) async => []);

      // Act
      await viewModel.createVisitFromFormData(formData, testSite);

      // Assert
      verify(() => mockCreateVisitUseCase.execute(any())).called(1);
      verify(() => mockGetVisitsBySiteAndModuleUseCase.execute(testSiteId, 1))
          .called(1);
    });

    test('_extractModuleSpecificData should convert numeric strings', () async {
      // Arrange
      final formData = {
        'visit_date_min': '2023-03-15',
        'int_value': '42',
        'float_value': '3.14',
      };

      // Configure the mock to return a new ID
      when(() => mockCreateVisitUseCase.execute(any()))
          .thenAnswer((_) async => 1);

      when(() => mockGetVisitsBySiteAndModuleUseCase.execute(testSiteId, 1))
          .thenAnswer((_) async => []);

      // Act
      await viewModel.createVisitFromFormData(formData, testSite);

      // Assert
      verify(() => mockCreateVisitUseCase.execute(any())).called(1);
      verify(() => mockGetVisitsBySiteAndModuleUseCase.execute(testSiteId, 1))
          .called(1);
    });

    test('_extractModuleSpecificData should ignore standard fields', () async {
      // Arrange
      final formData = {
        'visit_date_min': '2023-03-15',
        'visit_date_max': '2023-03-16',
        'comments': 'Test comment',
        'observers': [42],
        'custom_field': 'custom value',
      };

      // Configure the mock to return a new ID
      when(() => mockCreateVisitUseCase.execute(any()))
          .thenAnswer((_) async => 1);

      when(() => mockGetVisitsBySiteAndModuleUseCase.execute(testSiteId, 1))
          .thenAnswer((_) async => []);

      // Act
      await viewModel.createVisitFromFormData(formData, testSite);

      // Assert
      verify(() => mockCreateVisitUseCase.execute(any())).called(1);
      verify(() => mockGetVisitsBySiteAndModuleUseCase.execute(testSiteId, 1))
          .called(1);
    });
  });

  group('SiteVisitsViewModel - Error Handling', () {
    final testSite = BaseSite(
      idBaseSite: testSiteId,
      baseSiteName: 'Test Site',
    );

    test('createVisitFromFormData should log and rethrow errors', () async {
      // Arrange
      final formData = {'visit_date_min': '2023-03-15'};

      when(() => mockCreateVisitUseCase.execute(any()))
          .thenThrow(Exception('Database error'));

      // Act & Assert
      expect(
        () => viewModel.createVisitFromFormData(formData, testSite),
        throwsException,
      );
    });

    test('loadVisits does nothing when component is disposed', () async {
      // Arrange
      viewModel.dispose();

      // Act
      await viewModel.loadVisits();

      // Assert - no exception thrown, no mock called
      verifyNever(
          () => mockGetVisitsBySiteAndModuleUseCase.execute(any(), any()));
    });
  });
}
