import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_orphan_sites_by_module_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_orphan_sites_by_module_usecase_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_orphan_sites_by_module_use_case_test.mocks.dart';

@GenerateMocks([SitesRepository])
void main() {
  late GetOrphanSitesByModuleUseCase useCase;
  late MockSitesRepository mockRepo;

  const moduleId = 42;

  setUp(() {
    mockRepo = MockSitesRepository();
    useCase = GetOrphanSitesByModuleUseCaseImpl(mockRepo);
  });

  group('GetOrphanSitesByModuleUseCase', () {
    final sites = [
      BaseSite(idBaseSite: 1, baseSiteName: 'S1'),
    ];

    test('delegates to repository.getOrphanSitesByModuleId', () async {
      when(mockRepo.getOrphanSitesByModuleId(moduleId))
          .thenAnswer((_) async => sites);

      final result = await useCase.execute(moduleId);

      expect(result, equals(sites));
      verify(mockRepo.getOrphanSitesByModuleId(moduleId));
      verifyNoMoreInteractions(mockRepo);
    });

    test('propagates errors from repository', () async {
      final exc = Exception('db error');
      when(mockRepo.getOrphanSitesByModuleId(moduleId)).thenThrow(exc);

      expect(() => useCase.execute(moduleId), throwsA(exc));
    });
  });
}
