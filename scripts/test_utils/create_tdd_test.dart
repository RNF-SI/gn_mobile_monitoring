import 'dart:io';

/// Script pour générer un nouveau fichier de test suivant les principes TDD
/// Usage: dart test/templates/create_tdd_test.dart <type> <nom_classe>
/// Où <type> est: repository, usecase, viewmodel, widget
/// Et <nom_classe> est le nom de la classe à tester

void main(List<String> arguments) {
  if (arguments.length != 2) {
    print('Usage: dart test/templates/create_tdd_test.dart <type> <nom_classe>');
    print('Types supportés: repository, usecase, viewmodel, widget');
    exit(1);
  }

  final type = arguments[0].toLowerCase();
  final className = arguments[1];
  final snakeCaseName = camelToSnakeCase(className);

  // Déterminer le chemin du test en fonction du type
  String testPath;
  switch (type) {
    case 'repository':
      testPath = 'test/data/repository/${snakeCaseName}_test.dart';
      break;
    case 'usecase':
      testPath = 'test/domain/usecase/${snakeCaseName}_test.dart';
      break;
    case 'viewmodel':
      testPath = 'test/presentation/viewmodel/${snakeCaseName}_test.dart';
      break;
    case 'widget':
      testPath = 'test/presentation/view/${snakeCaseName}_test.dart';
      break;
    default:
      print('Type non supporté. Utilisez: repository, usecase, viewmodel, widget');
      exit(1);
  }

  // Générer le contenu du test
  final template = generateTemplate(type, className);

  // Vérifier si le dossier existe, sinon le créer
  final directory = Directory(testPath.substring(0, testPath.lastIndexOf('/')));
  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  }

  // Vérifier si le fichier existe déjà
  final file = File(testPath);
  if (file.existsSync()) {
    print('Attention: Le fichier $testPath existe déjà. Voulez-vous l\'écraser? (y/n)');
    final response = stdin.readLineSync() ?? '';
    if (response.toLowerCase() != 'y') {
      print('Opération annulée.');
      exit(0);
    }
  }

  // Écrire le template dans le fichier
  file.writeAsStringSync(template);
  print('Test créé avec succès: $testPath');
}

String camelToSnakeCase(String camelCase) {
  return camelCase
      .replaceAllMapped(
          RegExp(r'[A-Z]'), (match) => '_${match.group(0)!.toLowerCase()}')
      .replaceFirst(RegExp(r'^_'), '');
}

String generateTemplate(String type, String className) {
  switch (type) {
    case 'repository':
      return _generateRepositoryTestTemplate(className);
    case 'usecase':
      return _generateUseCaseTestTemplate(className);
    case 'viewmodel':
      return _generateViewModelTestTemplate(className);
    case 'widget':
      return _generateWidgetTestTemplate(className);
    default:
      return '';
  }
}

String _generateRepositoryTestTemplate(String className) {
  return '''
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// TODO: Importez les fichiers nécessaires

// Mock des dépendances
class MockDataSource extends Mock implements DataSource {}

void main() {
  late $className repository;
  late MockDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockDataSource();
    repository = $className(mockDataSource);
  });

  group('$className', () {
    test('should do something when condition is met', () async {
      // Arrange
      when(() => mockDataSource.someMethod(any()))
          .thenAnswer((_) async => expectedValue);

      // Act
      final result = await repository.methodUnderTest();

      // Assert
      expect(result, equals(expectedValue));
      verify(() => mockDataSource.someMethod(any())).called(1);
    });

    test('should handle errors correctly', () async {
      // Arrange
      when(() => mockDataSource.someMethod(any()))
          .thenThrow(Exception('Error'));

      // Act & Assert
      expect(
        () => repository.methodUnderTest(),
        throwsA(isA<SpecificException>()),
      );
    });
  });
}
''';
}

String _generateUseCaseTestTemplate(String className) {
  return '''
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// TODO: Importez les fichiers nécessaires

// Mock des dépendances
class MockRepository extends Mock implements Repository {}

void main() {
  late $className useCase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    useCase = $className(mockRepository);
  });

  group('$className', () {
    test('should call repository and return data', () async {
      // Arrange
      when(() => mockRepository.someMethod(any()))
          .thenAnswer((_) async => expectedValue);

      // Act
      final result = await useCase.execute(someParam);

      // Assert
      expect(result, equals(expectedValue));
      verify(() => mockRepository.someMethod(someParam)).called(1);
    });

    test('should handle errors from repository', () async {
      // Arrange
      when(() => mockRepository.someMethod(any()))
          .thenThrow(Exception('Error'));

      // Act & Assert
      expect(
        () => useCase.execute(someParam),
        throwsA(isA<Exception>()),
      );
    });
  });
}
''';
}

String _generateViewModelTestTemplate(String className) {
  return '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// TODO: Importez les fichiers nécessaires

// Mock des dépendances
class MockUseCase extends Mock implements UseCase {}

void main() {
  late ProviderContainer container;
  late MockUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockUseCase();
    container = ProviderContainer(
      overrides: [
        // TODO: Remplacez ces providers par les vôtres
        useCaseProvider.overrideWithValue(mockUseCase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('$className', () {
    test('should initialize with correct state', () {
      // Arrange & Act
      final viewModel = container.read(viewModelProvider.notifier);

      // Assert
      expect(
        container.read(viewModelProvider),
        equals(expectedInitialState),
      );
    });

    test('should update state correctly when method is called', () async {
      // Arrange
      when(() => mockUseCase.execute(any()))
          .thenAnswer((_) async => expectedValue);

      // Act
      final viewModel = container.read(viewModelProvider.notifier);
      await viewModel.someMethod();

      // Assert
      expect(
        container.read(viewModelProvider),
        equals(expectedNewState),
      );
    });

    test('should handle errors correctly', () async {
      // Arrange
      when(() => mockUseCase.execute(any()))
          .thenThrow(Exception('Error'));

      // Act
      final viewModel = container.read(viewModelProvider.notifier);
      await viewModel.someMethod();

      // Assert
      expect(
        container.read(viewModelProvider),
        equals(expectedErrorState),
      );
    });
  });
}
''';
}

String _generateWidgetTestTemplate(String className) {
  return '''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// TODO: Importez les fichiers nécessaires

// Mock des dépendances
class MockViewModel extends Mock implements ViewModel {}

void main() {
  late MockViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockViewModel();
  });

  testWidgets('$className should display loading state correctly',
      (WidgetTester tester) async {
    // Arrange
    final customState = const State<Data>.loading();

    final container = ProviderContainer(
      overrides: [
        // TODO: Remplacez par votre provider
        dataProvider.overrideWithValue(customState),
      ],
    );

    // Act
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            body: $className(),
          ),
        ),
      ),
    );

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('$className should display error state correctly',
      (WidgetTester tester) async {
    // Arrange
    final customState = State<Data>.error(
      Exception('Error message'),
    );

    final container = ProviderContainer(
      overrides: [
        // TODO: Remplacez par votre provider
        dataProvider.overrideWithValue(customState),
      ],
    );

    // Act
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            body: $className(),
          ),
        ),
      ),
    );

    // Assert
    expect(find.text('Erreur: Exception: Error message'), findsOneWidget);
  });

  testWidgets('$className should display data correctly when loaded',
      (WidgetTester tester) async {
    // Arrange
    final data = Data(...); // TODO: Créez vos données de test

    final customState = State<Data>.success(data);

    final container = ProviderContainer(
      overrides: [
        // TODO: Remplacez par votre provider
        dataProvider.overrideWithValue(customState),
      ],
    );

    // Act
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            body: $className(),
          ),
        ),
      ),
    );

    // Assert
    // TODO: Vérifiez que les données s'affichent correctement
    expect(find.text('Expected Text'), findsOneWidget);
  });
}
''';
}