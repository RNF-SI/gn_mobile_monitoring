import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/authentication_api_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/global_api_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/modules_api_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/observation_details_api_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/observations_api_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/sites_api_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/taxon_api_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/visits_api_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/database/dataset_database_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/database/global_database_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/database/modules_database_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/database/nomenclatures_database_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/database/observation_details_database_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/database/observations_database_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/database/sites_database_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/database/taxon_database_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/database/visites_database_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/authentication_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/global_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/modules_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/observation_details_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/observations_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/sites_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/taxon_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/visits_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/datasets_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/global_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/nomenclatures_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/observation_details_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/observations_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/sites_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/taxon_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/visites_database.dart';
import 'package:gn_mobile_monitoring/data/repository/authentication_repository_impl.dart';
import 'package:gn_mobile_monitoring/data/repository/global_database_repository_impl.dart';
import 'package:gn_mobile_monitoring/data/repository/local_storage_repository_impl.dart';
import 'package:gn_mobile_monitoring/data/repository/modules_repository_impl.dart';
import 'package:gn_mobile_monitoring/data/repository/observation_details_repository_impl.dart';
import 'package:gn_mobile_monitoring/data/repository/observations_repository_impl.dart';
import 'package:gn_mobile_monitoring/data/repository/sites_repository_impl.dart';
import 'package:gn_mobile_monitoring/data/repository/taxon_repository_impl.dart';
import 'package:gn_mobile_monitoring/data/repository/visit_repository_impl.dart';
import 'package:gn_mobile_monitoring/domain/repository/authentication_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/global_database_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/local_storage_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/observation_details_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/observations_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/taxon_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/visit_repository.dart';

final globalApiProvider = Provider<GlobalApi>((_) => GlobalApiImpl());
final globalDatabaseProvider =
    Provider<GlobalDatabase>((_) => GlobalDatabaseImpl());
final globalDatabaseRepositoryProvider = Provider<GlobalDatabaseRepository>(
    (ref) => GlobalDatabaseRepositoryImpl(
        ref.watch(globalDatabaseProvider), ref.watch(globalApiProvider)));

final nomenclatureDatabaseProvider =
    Provider<NomenclaturesDatabase>((_) => NomenclaturesDatabaseImpl());

final datasetsDatabaseProvider =
    Provider<DatasetsDatabase>((_) => DatasetsDatabaseImpl());

final localStorageProvider =
    Provider<LocalStorageRepository>((ref) => LocalStorageRepositoryImpl());

final authenticationApiProvider =
    Provider<AuthenticationApi>((_) => AuthenticationApiImpl());
final authenticationRepositoryProvider = Provider<AuthenticationRepository>(
    (ref) =>
        AuthenticationRepositoryImpl(ref.watch(authenticationApiProvider)));

final modulesApiProvider = Provider<ModulesApi>((_) => ModulesApiImpl());
final moduleDatabaseProvider =
    Provider<ModuleDatabaseImpl>((_) => ModuleDatabaseImpl());

final sitesApiProvider = Provider<SitesApi>((_) => SitesApiImpl());
final siteDatabaseProvider =
    Provider<SitesDatabase>((_) => SitesDatabaseImpl());

final sitesRepositoryProvider =
    Provider<SitesRepository>((ref) => SitesRepositoryImpl(
          ref.watch(sitesApiProvider),
          ref.watch(siteDatabaseProvider),
          ref.watch(moduleDatabaseProvider),
        ));

final visitDatabaseProvider =
    Provider<VisitesDatabase>((_) => VisitesDatabaseImpl());

final visitRepositoryProvider =
    Provider<VisitRepository>((ref) => VisitRepositoryImpl(
          ref.watch(visitDatabaseProvider),
        ));

final observationsDatabaseProvider =
    Provider<ObservationsDatabase>((_) => ObservationsDatabaseImpl());

final observationsRepositoryProvider =
    Provider<ObservationsRepository>((ref) => ObservationsRepositoryImpl(
          ref.watch(observationsDatabaseProvider),
        ));

final observationDetailsDatabaseProvider = Provider<ObservationDetailsDatabase>(
    (_) => ObservationDetailsDatabaseImpl());

final observationDetailsRepositoryImplProvider =
    Provider<ObservationDetailsRepository>(
        (ref) => ObservationDetailsRepositoryImpl(
              ref.watch(observationDetailsDatabaseProvider),
            ));

final taxonDatabaseProvider =
    Provider<TaxonDatabase>((_) => TaxonDatabaseImpl());

final taxonApiProvider = Provider<TaxonApi>((_) => TaxonApiImpl());

final taxonRepositoryProvider =
    Provider<TaxonRepository>((ref) => TaxonRepositoryImpl(
          ref.watch(taxonDatabaseProvider),
          ref.watch(taxonApiProvider),
          ref.watch(moduleDatabaseProvider),
        ));

final visitsApiProvider = Provider<VisitsApi>((_) => VisitsApiImpl());

final observationsApiProvider = Provider<ObservationsApi>((_) => ObservationsApiImpl());

final observationDetailsApiProvider = Provider<ObservationDetailsApi>((_) => ObservationDetailsApiImpl());

final modulesRepositoryProvider =
    Provider<ModulesRepository>((ref) => ModulesRepositoryImpl(
          ref.watch(globalApiProvider),
          ref.watch(modulesApiProvider),
          ref.watch(taxonApiProvider),
          ref.watch(moduleDatabaseProvider),
          ref.watch(nomenclatureDatabaseProvider),
          ref.watch(datasetsDatabaseProvider),
          ref.watch(taxonDatabaseProvider),
          ref.watch(taxonRepositoryProvider),
        ));
