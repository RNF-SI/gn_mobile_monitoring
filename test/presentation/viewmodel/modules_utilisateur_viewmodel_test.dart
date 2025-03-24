import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info_list.dart';
import 'package:gn_mobile_monitoring/presentation/state/module_download_status.dart';
import 'package:gn_mobile_monitoring/presentation/state/state.dart'
    as custom_async_state;
import 'package:gn_mobile_monitoring/presentation/viewmodel/modules_utilisateur_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late ProviderContainer container;
  late MockGetModulesUseCase mockGetModulesUseCase;
  late MockDownloadModuleDataUseCase mockDownloadModuleDataUseCase;
  late MockBuildContext mockContext;

  setUp(() {
    mockGetModulesUseCase = MockGetModulesUseCase();
    mockDownloadModuleDataUseCase = MockDownloadModuleDataUseCase();
    mockContext = MockBuildContext();

    container = ProviderContainer(
      overrides: [
        // Override the providers with mocks
        getModulesUseCaseProvider.overrideWithValue(mockGetModulesUseCase),
        downloadModuleDataUseCaseProvider
            .overrideWithValue(mockDownloadModuleDataUseCase),
      ],
    );

    // Register fallback values for callback functions
    registerFallbackValue((double progress) {});
  });

  tearDown(() {
    container.dispose();
  });

  test(
      'UserModulesViewModel should initialize with init state and trigger loading',
      () {
    // Arrange
    when(() => mockGetModulesUseCase.execute())
        .thenAnswer((_) async => []); // Retourne une liste vide de modules

    // Act - Créez un nouveau ViewModel (cela va déclencher loadModules)
    final userModulesViewModel = UserModulesViewModel(
      mockGetModulesUseCase,
      mockDownloadModuleDataUseCase,
      const AsyncValue<ModuleInfoList>.data(ModuleInfoList(values: [])),
    );

    // Verifiez que loadModules a été appelé
    verify(() => mockGetModulesUseCase.execute()).called(1);
  });

  test('loadModules should update state to success when modules are loaded',
      () async {
    // Arrange
    final mockModules = [
      const Module(
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
      const Module(
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

    when(() => mockGetModulesUseCase.execute())
        .thenAnswer((_) async => mockModules);

    // Act
    final userModulesViewModel =
        container.read(userModuleListeViewModelStateNotifierProvider.notifier);
    await userModulesViewModel.loadModules();

    // Assert
    final state = container.read(userModuleListeViewModelStateNotifierProvider);
    expect(state, isA<custom_async_state.State<ModuleInfoList>>());

    final moduleInfoList = state.data!;
    expect(moduleInfoList.values.length, equals(2));

    // Premier module (téléchargé)
    expect(moduleInfoList.values[0].module.id, equals(1));
    expect(moduleInfoList.values[0].downloadStatus,
        equals(ModuleDownloadStatus.moduleDownloaded));

    // Deuxième module (non téléchargé)
    expect(moduleInfoList.values[1].module.id, equals(2));
    expect(moduleInfoList.values[1].downloadStatus,
        equals(ModuleDownloadStatus.moduleNotDownloaded));
  });

  test('loadModules should handle errors gracefully', () async {
    // Arrange
    when(() => mockGetModulesUseCase.execute())
        .thenThrow(Exception('Failed to load modules'));

    // Act
    final userModulesViewModel =
        container.read(userModuleListeViewModelStateNotifierProvider.notifier);
    await userModulesViewModel.loadModules();

    // Assert
    final state = container.read(userModuleListeViewModelStateNotifierProvider);
    expect(state, isA<custom_async_state.State<ModuleInfoList>>());
    expect(state.data, isNull);
    expect(state.toString(), contains('Failed to load modules'));
  });

  test(
      'startDownloadModule should update module state during and after download',
      () async {
    // Arrange
    final mockModule = const Module(
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
      downloaded: false,
    );

    final moduleInfo = ModuleInfo(
      module: mockModule,
      downloadStatus: ModuleDownloadStatus.moduleNotDownloaded,
    );

    final moduleInfoList = ModuleInfoList(values: [moduleInfo]);

    // Set initial state
    final userModulesViewModel =
        container.read(userModuleListeViewModelStateNotifierProvider.notifier);

    // Mock initial state with our module
    when(() => mockGetModulesUseCase.execute())
        .thenAnswer((_) async => [mockModule]);
    await userModulesViewModel.loadModules();

    // Mock download usecase
    when(() => mockDownloadModuleDataUseCase.execute(any(), any()))
        .thenAnswer((invocation) async {
      final progressCallback =
          invocation.positionalArguments[1] as Function(double);
      // Simulate progress updates
      progressCallback(0.3);
      progressCallback(0.7);
      progressCallback(1.0);
    });

    // Act
    await userModulesViewModel.startDownloadModule(moduleInfo, mockContext);

    // Assert
    final state = container.read(userModuleListeViewModelStateNotifierProvider);
    expect(state, isA<custom_async_state.State<ModuleInfoList>>());

    final updatedModuleInfo = state.data!.values[0];
    expect(updatedModuleInfo.downloadStatus,
        equals(ModuleDownloadStatus.moduleDownloaded));
    expect(updatedModuleInfo.downloadProgress, equals(1.0));
  });

  test('startDownloadModule should handle download errors gracefully',
      () async {
    // Arrange
    final mockModule = const Module(
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
      downloaded: false,
    );

    final moduleInfo = ModuleInfo(
      module: mockModule,
      downloadStatus: ModuleDownloadStatus.moduleNotDownloaded,
    );

    // Set initial state
    final userModulesViewModel =
        container.read(userModuleListeViewModelStateNotifierProvider.notifier);

    // Mock initial state with our module
    when(() => mockGetModulesUseCase.execute())
        .thenAnswer((_) async => [mockModule]);
    await userModulesViewModel.loadModules();

    // Mock download usecase to throw error
    when(() => mockDownloadModuleDataUseCase.execute(any(), any()))
        .thenThrow(Exception('Download failed'));

    // Act
    await userModulesViewModel.startDownloadModule(moduleInfo, mockContext);

    // Assert
    final state = container.read(userModuleListeViewModelStateNotifierProvider);
    expect(state, isA<custom_async_state.State<ModuleInfoList>>());
    expect(state.data, isNull);
    expect(state.toString(), contains('Download failed'));
  });

  test('stopDownloadModule should update module state correctly', () async {
    // Arrange
    final mockModule = const Module(
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
      downloaded: false,
    );

    final moduleInfo = ModuleInfo(
      module: mockModule,
      downloadStatus: ModuleDownloadStatus.moduleDownloading,
      downloadProgress: 0.5,
    );

    // Set initial state
    final userModulesViewModel =
        container.read(userModuleListeViewModelStateNotifierProvider.notifier);

    // Mock initial state with our module
    when(() => mockGetModulesUseCase.execute())
        .thenAnswer((_) async => [mockModule]);
    await userModulesViewModel.loadModules();

    // Act
    await userModulesViewModel.stopDownloadModule(moduleInfo);

    // Assert
    final state = container.read(userModuleListeViewModelStateNotifierProvider);
    expect(state, isA<custom_async_state.State<ModuleInfoList>>());

    final updatedModuleInfo = state.data!.values[0];
    expect(updatedModuleInfo.downloadStatus,
        equals(ModuleDownloadStatus.moduleNotDownloaded));
  });
}
