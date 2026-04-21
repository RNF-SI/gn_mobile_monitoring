import 'package:dio/dio.dart';

import '../helpers/fixture_loader.dart';
import 'mock_api_interceptor.dart';

/// Pre-configured sets of mock API handlers for common test scenarios.
class MockApiHandlers {
  /// Configure handlers for a successful authentication flow
  static Future<void> setupAuthSuccess(MockApiInterceptor interceptor) async {
    final loginResponse = await FixtureLoader.load('auth/login_success.json');

    interceptor.onPost('/auth/login', (options) async {
      return Response(
        requestOptions: options,
        statusCode: 200,
        data: loginResponse,
      );
    });
  }

  /// Configure handlers for a failed authentication
  static Future<void> setupAuthFailure(MockApiInterceptor interceptor) async {
    final loginError = await FixtureLoader.load('auth/login_failure.json');

    interceptor.onPost('/auth/login', (options) async {
      throw DioException(
        requestOptions: options,
        response: Response(
          requestOptions: options,
          statusCode: 401,
          data: loginError,
        ),
        type: DioExceptionType.badResponse,
      );
    });
  }

  /// Configure handlers for module listing
  static Future<void> setupModulesList(MockApiInterceptor interceptor) async {
    final modulesData = await FixtureLoader.load('modules/modules_list.json');

    interceptor.onGet('/monitorings/modules', (options) async {
      return Response(
        requestOptions: options,
        statusCode: 200,
        data: modulesData,
      );
    });
  }

  /// Configure handlers for module configuration download
  static Future<void> setupModuleConfig(MockApiInterceptor interceptor) async {
    final moduleConfig = await FixtureLoader.load('modules/module_config.json');

    interceptor.onGet(r'/monitorings/module/[^/]+/config', (options) async {
      return Response(
        requestOptions: options,
        statusCode: 200,
        data: moduleConfig,
      );
    });
  }

  /// Configure handlers for sites
  static Future<void> setupSites(MockApiInterceptor interceptor) async {
    final sitesData = await FixtureLoader.load('sites/sites_enriched.json');

    interceptor.onGet(r'/monitorings/sites', (options) async {
      return Response(
        requestOptions: options,
        statusCode: 200,
        data: sitesData,
      );
    });

    final createResponse =
        await FixtureLoader.load('sites/site_create_response.json');

    interceptor.onPost('/monitorings/sites', (options) async {
      return Response(
        requestOptions: options,
        statusCode: 201,
        data: createResponse,
      );
    });
  }

  /// Configure handlers for visits
  static Future<void> setupVisits(MockApiInterceptor interceptor) async {
    final createResponse =
        await FixtureLoader.load('visits/visit_create_response.json');

    interceptor.onPost(r'/monitorings/visits', (options) async {
      return Response(
        requestOptions: options,
        statusCode: 201,
        data: createResponse,
      );
    });
  }

  /// Configure handlers for observations
  static Future<void> setupObservations(
      MockApiInterceptor interceptor) async {
    final createResponse =
        await FixtureLoader.load('observations/observation_create_response.json');

    interceptor.onPost(r'/monitorings/observations', (options) async {
      return Response(
        requestOptions: options,
        statusCode: 201,
        data: createResponse,
      );
    });
  }

  /// Configure handlers for nomenclatures
  static Future<void> setupNomenclatures(
      MockApiInterceptor interceptor) async {
    final nomenclatures =
        await FixtureLoader.load('nomenclatures/nomenclatures.json');

    interceptor.onGet('/nomenclatures/nomenclatures', (options) async {
      return Response(
        requestOptions: options,
        statusCode: 200,
        data: nomenclatures,
      );
    });
  }

  /// Configure handlers for datasets
  /// Expose 2 routes GN : `/monitorings/object/<code>/module` pour la liste d'IDs
  /// puis `/monitorings/util/dataset/<id>` pour chaque dataset individuellement.
  static Future<void> setupDatasets(MockApiInterceptor interceptor) async {
    final datasets = await FixtureLoader.load('datasets/datasets.json') as List;

    interceptor.onGet(r'/monitorings/object/[^/]+/module', (options) async {
      return Response(
        requestOptions: options,
        statusCode: 200,
        data: {
          'properties': {
            'datasets': datasets.map((d) => d['id_dataset']).toList(),
          },
        },
      );
    });

    interceptor.onGet(r'/monitorings/util/dataset/\d+', (options) async {
      final id = int.tryParse(options.path.split('/').last);
      final dataset = datasets.firstWhere(
        (d) => d['id_dataset'] == id,
        orElse: () => null,
      );
      if (dataset == null) {
        return Response(
          requestOptions: options,
          statusCode: 404,
        );
      }
      return Response(
        requestOptions: options,
        statusCode: 200,
        data: dataset,
      );
    });
  }

  /// Configure handlers for taxons
  static Future<void> setupTaxons(MockApiInterceptor interceptor) async {
    final taxonList = await FixtureLoader.load('taxons/taxon_list.json');

    interceptor.onGet(r'/taxonomie/taxref', (options) async {
      return Response(
        requestOptions: options,
        statusCode: 200,
        data: taxonList,
      );
    });

    final taxonSearch = await FixtureLoader.load('taxons/taxon_search.json');

    interceptor.onGet(r'/taxonomie/taxref/search', (options) async {
      return Response(
        requestOptions: options,
        statusCode: 200,
        data: taxonSearch,
      );
    });
  }

  /// Configure handlers pour l'endpoint /gn_commons/modules avec une version monitoring
  static void setupGnCommonsModules(MockApiInterceptor interceptor,
      {String version = '1.2.0'}) {
    interceptor.onGet('/gn_commons/modules', (options) async {
      return Response(
        requestOptions: options,
        statusCode: 200,
        data: [
          {'module_code': 'GEONATURE', 'version': '2.14.0'},
          {'module_code': 'MONITORINGS', 'version': version},
        ],
      );
    });
  }

  /// Configure handlers pour simuler un vieux serveur sans /gn_commons/modules
  static void setupGnCommonsModulesNotFound(MockApiInterceptor interceptor) {
    interceptor.onGet('/gn_commons/modules', (options) async {
      throw DioException(
        requestOptions: options,
        response: Response(
          requestOptions: options,
          statusCode: 404,
        ),
        type: DioExceptionType.badResponse,
      );
    });
  }

  /// Setup all handlers for a complete user journey
  static Future<void> setupFullJourney(MockApiInterceptor interceptor) async {
    await setupAuthSuccess(interceptor);
    await setupModulesList(interceptor);
    await setupModuleConfig(interceptor);
    await setupNomenclatures(interceptor);
    await setupDatasets(interceptor);
    await setupSites(interceptor);
    await setupVisits(interceptor);
    await setupObservations(interceptor);
    await setupTaxons(interceptor);
    setupGnCommonsModules(interceptor);
  }
}
