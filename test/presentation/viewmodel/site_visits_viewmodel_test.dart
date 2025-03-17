import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_visit_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_visit_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visits_by_site_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_visit_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_visits_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockGetVisitsBySiteIdUseCase extends Mock
    implements GetVisitsBySiteIdUseCase {}

class MockCreateVisitUseCase extends Mock implements CreateVisitUseCase {}

class MockUpdateVisitUseCase extends Mock implements UpdateVisitUseCase {}

class MockDeleteVisitUseCase extends Mock implements DeleteVisitUseCase {}

void main() {
  late MockGetVisitsBySiteIdUseCase mockGetVisitsBySiteIdUseCase;
  late MockCreateVisitUseCase mockCreateVisitUseCase;
  late MockUpdateVisitUseCase mockUpdateVisitUseCase;
  late MockDeleteVisitUseCase mockDeleteVisitUseCase;
  late SiteVisitsViewModel viewModel;
  const int testSiteId = 1;

  setUp(() {
    mockGetVisitsBySiteIdUseCase = MockGetVisitsBySiteIdUseCase();
    mockCreateVisitUseCase = MockCreateVisitUseCase();
    mockUpdateVisitUseCase = MockUpdateVisitUseCase();
    mockDeleteVisitUseCase = MockDeleteVisitUseCase();

    viewModel = SiteVisitsViewModel(
      mockGetVisitsBySiteIdUseCase,
      mockCreateVisitUseCase,
      mockUpdateVisitUseCase,
      mockDeleteVisitUseCase,
      testSiteId,
    );
  });

  group('SiteVisitsViewModel', () {
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

    test('initial state is loading', () {
      expect(viewModel.state, const AsyncValue<List<BaseVisit>>.loading());
    });

    test('loadVisits should update state with visits from use case', () async {
      // Arrange
      when(() => mockGetVisitsBySiteIdUseCase.execute(testSiteId))
          .thenAnswer((_) async => testVisits);

      // Act
      await viewModel.loadVisits();

      // Assert
      expect(viewModel.state, AsyncValue.data(testVisits));
      verify(() => mockGetVisitsBySiteIdUseCase.execute(testSiteId)).called(2); // Une fois dans le constructeur, une fois dans loadVisits
    });

    test('loadVisits should handle error', () async {
      // Arrange
      final exception = Exception('Test error');
      when(() => mockGetVisitsBySiteIdUseCase.execute(testSiteId))
          .thenThrow(exception);

      // Act
      await viewModel.loadVisits();

      // Assert
      expect(viewModel.state.hasError, true);
      verify(() => mockGetVisitsBySiteIdUseCase.execute(testSiteId)).called(2); // Une fois dans le constructeur, une fois dans loadVisits
    });

    test('saveVisit should call createVisitUseCase and reload visits', () async {
      // Arrange
      final newVisit = BaseVisit(
        idBaseVisit: 0, // ID temporaire
        idBaseSite: testSiteId,
        idDataset: 1,
        idModule: 1,
        visitDateMin: '2023-01-03',
        observers: [1, 2],
        data: {'field': 'value'},
      );

      when(() => mockCreateVisitUseCase.execute(newVisit))
          .thenAnswer((_) async => 3); // Nouvel ID attribué

      when(() => mockGetVisitsBySiteIdUseCase.execute(testSiteId))
          .thenAnswer((_) async => [...testVisits]);

      // Act
      final result = await viewModel.saveVisit(newVisit);

      // Assert
      expect(result, 3);
      verify(() => mockCreateVisitUseCase.execute(newVisit)).called(1);
      verify(() => mockGetVisitsBySiteIdUseCase.execute(testSiteId)).called(2); // Une fois dans le constructeur, une fois après la création
    });

    test('updateVisit should call updateVisitUseCase and reload visits', () async {
      // Arrange
      final updatedVisit = BaseVisit(
        idBaseVisit: 1, // ID existant
        idBaseSite: testSiteId,
        idDataset: 1,
        idModule: 1,
        visitDateMin: '2023-01-01',
        comments: 'Updated comment',
      );

      when(() => mockUpdateVisitUseCase.execute(updatedVisit))
          .thenAnswer((_) async => true);

      when(() => mockGetVisitsBySiteIdUseCase.execute(testSiteId))
          .thenAnswer((_) async => testVisits);

      // Act
      final result = await viewModel.updateVisit(updatedVisit);

      // Assert
      expect(result, true);
      verify(() => mockUpdateVisitUseCase.execute(updatedVisit)).called(1);
      verify(() => mockGetVisitsBySiteIdUseCase.execute(testSiteId)).called(2); // Une fois dans le constructeur, une fois après la mise à jour
    });

    test('deleteVisit should call deleteVisitUseCase and reload visits', () async {
      // Arrange
      const visitIdToDelete = 1;

      when(() => mockDeleteVisitUseCase.execute(visitIdToDelete))
          .thenAnswer((_) async => true);

      when(() => mockGetVisitsBySiteIdUseCase.execute(testSiteId))
          .thenAnswer((_) async => [testVisits[1]]); // Returned list without deleted visit

      // Act
      final result = await viewModel.deleteVisit(visitIdToDelete);

      // Assert
      expect(result, true);
      verify(() => mockDeleteVisitUseCase.execute(visitIdToDelete)).called(1);
      verify(() => mockGetVisitsBySiteIdUseCase.execute(testSiteId)).called(2); // Une fois dans le constructeur, une fois après la suppression
    });
  });
}