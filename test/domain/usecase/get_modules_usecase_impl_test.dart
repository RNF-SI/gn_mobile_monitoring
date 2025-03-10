import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_modules_usecase_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late GetModulesUseCaseImpl useCase;
  late MockModulesRepository mockRepository;

  setUp(() {
    mockRepository = MockModulesRepository();
    useCase = GetModulesUseCaseImpl(mockRepository);
  });

  test('should get modules from repository', () async {
    // Arrange
    final mockModules = [
      Module(
        id: 1,
        moduleCode: 'code1',
        moduleLabel: 'Module 1',
        moduleDesc: 'Description 1',
        modulePath: 'path/to/module1',
        activeFrontend: true,
        moduleTarget: 'target1',
        modulePicto: 'picto1',
        moduleDocUrl: 'doc/url1',
        moduleGroup: 'group1',
        downloaded: true,
      ),
      Module(
        id: 2,
        moduleCode: 'code2',
        moduleLabel: 'Module 2',
        moduleDesc: 'Description 2',
        modulePath: 'path/to/module2',
        activeFrontend: true,
        moduleTarget: 'target2',
        modulePicto: 'picto2',
        moduleDocUrl: 'doc/url2',
        moduleGroup: 'group2',
        downloaded: false,
      ),
    ];

    when(() => mockRepository.getModulesFromLocal())
        .thenAnswer((_) async => mockModules);

    // Act
    final result = await useCase.execute();

    // Assert
    expect(result, equals(mockModules));
    verify(() => mockRepository.getModulesFromLocal()).called(1);
  });

  test('should throw exception when repository fails', () async {
    // Arrange
    when(() => mockRepository.getModulesFromLocal())
        .thenThrow(Exception('Database error'));

    // Act & Assert
    expect(
      () => useCase.execute(),
      throwsA(isA<Exception>()),
    );
    verify(() => mockRepository.getModulesFromLocal()).called(1);
  });
}
