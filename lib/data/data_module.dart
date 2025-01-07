import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/authentication_api_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/global_api_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/modules_api_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/database/global_database_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/database/modules_database_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/authentication_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/global_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/modules_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/global_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/modules_database.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/repository/authentication_repository_impl.dart';
import 'package:gn_mobile_monitoring/data/repository/global_database_repository_impl.dart';
import 'package:gn_mobile_monitoring/data/repository/local_storage_repository_impl.dart';
import 'package:gn_mobile_monitoring/data/repository/modules_repository_impl.dart';
import 'package:gn_mobile_monitoring/domain/repository/authentication_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/global_database_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/local_storage_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((_) => AppDatabase());

final globalApiProvider = Provider<GlobalApi>((_) => GlobalApiImpl());
final globalDatabaseProvider =
    Provider<GlobalDatabase>((_) => GlobalDatabaseImpl());
final globalDatabaseRepositoryProvider = Provider<GlobalDatabaseRepository>(
    (ref) => GlobalDatabaseRepositoryImpl(
        ref.watch(globalDatabaseProvider), ref.watch(globalApiProvider)));

final localStorageProvider =
    Provider<LocalStorageRepository>((ref) => LocalStorageRepositoryImpl());

final authenticationApiProvider =
    Provider<AuthenticationApi>((_) => AuthenticationApiImpl());
final authenticationRepositoryProvider = Provider<AuthenticationRepository>(
    (ref) =>
        AuthenticationRepositoryImpl(ref.watch(authenticationApiProvider)));

final modulesDatabaseProvider =
    Provider<ModulesDatabase>((_) => ModulesDatabaseImpl());
final modulesApiProvider = Provider<ModulesApi>((_) => ModulesApiImpl());

final modulesRepositoryProvider = Provider<ModulesRepository>((ref) =>
    ModulesRepositoryImpl(
        ref.watch(modulesApiProvider), ref.watch(modulesDatabaseProvider)));
