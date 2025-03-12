import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/authentication_api_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/global_api_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/modules_api_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/sites_api_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/database/dataset_database_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/database/global_database_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/database/modules_database_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/database/nomenclatures_database_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/database/sites_database_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/database/visites_database_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/authentication_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/global_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/modules_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/sites_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/datasets_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/global_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/nomenclatures_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/sites_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/visites_database.dart';
import 'package:gn_mobile_monitoring/data/repository/authentication_repository_impl.dart';
import 'package:gn_mobile_monitoring/data/repository/global_database_repository_impl.dart';
import 'package:gn_mobile_monitoring/data/repository/local_storage_repository_impl.dart';
import 'package:gn_mobile_monitoring/data/repository/modules_repository_impl.dart';
import 'package:gn_mobile_monitoring/data/repository/sites_repository_impl.dart';
import 'package:gn_mobile_monitoring/data/repository/visit_repository_impl.dart';
import 'package:gn_mobile_monitoring/domain/repository/authentication_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/global_database_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/local_storage_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
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

final modulesRepositoryProvider =
    Provider<ModulesRepository>((ref) => ModulesRepositoryImpl(
          ref.watch(globalApiProvider),
          ref.watch(modulesApiProvider),
          ref.watch(moduleDatabaseProvider),
          ref.watch(nomenclatureDatabaseProvider),
          ref.watch(datasetsDatabaseProvider),
        ));

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
