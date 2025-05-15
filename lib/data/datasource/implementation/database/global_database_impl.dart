import 'dart:io';

import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/database/db.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/global_database.dart';
import 'package:gn_mobile_monitoring/data/db/dao/app_metadata_dao.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class GlobalDatabaseImpl implements GlobalDatabase {
  AppMetadataDao? _appMetadataDao;
  final Future<void> _initializationDone;

  // Constructeur qui initialise l'objet et retourne une Future
  // qui sera résolue lorsque l'initialisation est terminée
  GlobalDatabaseImpl() : _initializationDone = _init();

  // Méthode statique d'initialisation
  static Future<void> _init() async {
    // Pas besoin de faire quoi que ce soit ici, l'initialisation
    // réelle sera faite dans _getAppMetadataDao
  }

  // Méthode privée qui récupère le DAO, en l'initialisant si nécessaire
  Future<AppMetadataDao> _getAppMetadataDao() async {
    // Si le DAO n'est pas encore initialisé, on l'initialise
    if (_appMetadataDao == null) {
      final database = await DB.instance.database;
      _appMetadataDao = database.appMetadataDao;
    }
    return _appMetadataDao!;
  }

  @override
  Future<void> initDatabase() async {
    await DB.instance.database; // Initialize
    await _getAppMetadataDao();
  }

  @override
  Future<void> deleteDatabase() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dbFolder.path, 'app.sqlite');
    final file = File(dbPath);

    // Reset database instance
    await DB.instance.resetDatabase();

    if (await file.exists()) {
      await file.delete();
    }
    
    // Reset the local DAO
    _appMetadataDao = null;
  }

  @override
  Future<void> resetDatabase() async {
    await DB.instance.resetDatabase();
    _appMetadataDao = null;
    await _getAppMetadataDao();
  }
  
  @override
  Future<DateTime?> getLastSyncDate(String entityType) async {
    // Attend que l'initialisation soit terminée avant de continuer
    await _initializationDone;
    
    final dao = await _getAppMetadataDao();
    final value = await dao.getValue('last_sync_$entityType');
    
    if (value != null) {
      return DateTime.parse(value);
    }
    return null;
  }
  
  @override
  Future<void> updateLastSyncDate(String entityType, DateTime syncDate) async {
    // Attend que l'initialisation soit terminée avant de continuer
    await _initializationDone;
    
    final dao = await _getAppMetadataDao();
    await dao.setValue(
      'last_sync_$entityType', 
      syncDate.toIso8601String()
    );
  }
  
  @override
  Future<int> getPendingItemsCount() async {
    // Attend que l'initialisation soit terminée avant de continuer
    await _initializationDone;
    
    final db = await DB.instance.database;
    
    // Compte les observations qui n'ont pas encore été synchronisées
    final result = await db.customSelect(
      'SELECT COUNT(*) as count FROM t_observations WHERE sync_status = ?',
      variables: [Variable('pending')],
    ).getSingleOrNull();
    
    return result?.read<int>('count') ?? 0;
  }
  
  @override
  Future<SyncResult> saveConfiguration(Map<String, dynamic> configData) async {
    // Attend que l'initialisation soit terminée avant de continuer
    await _initializationDone;
    
    int success = 0;
    
    try {
      final dao = await _getAppMetadataDao();
      
      // Enregistrer chaque clé de configuration dans la table app_metadata
      for (final entry in configData.entries) {
        final key = 'config_${entry.key}';
        final value = entry.value.toString();
        
        await dao.setValue(key, value);
        success++;
      }
      
      return SyncResult.success(
        itemsProcessed: configData.length,
        itemsAdded: 0,
        itemsUpdated: success,
        itemsSkipped: 0,
      );
    } catch (e) {
      return SyncResult.failure(
        errorMessage: 'Erreur lors de l\'enregistrement de la configuration: $e',
      );
    }
  }
}
