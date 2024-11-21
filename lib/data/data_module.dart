import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/global_api_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/database/global_database_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/global_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/global_database.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/repository/global_database_repository_impl.dart';
import 'package:gn_mobile_monitoring/domain/repository/global_database_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((_) => AppDatabase());

final globalApiProvider = Provider<GlobalApi>((_) => GlobalApiImpl());
final globalDatabaseProvider =
    Provider<GlobalDatabase>((_) => GlobalDatabaseImpl());
final globalDatabaseRepositoryProvider = Provider<GlobalDatabaseRepository>(
    (ref) => GlobalDatabaseRepositoryImpl(
        ref.watch(globalDatabaseProvider), ref.watch(globalApiProvider)));
