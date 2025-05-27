import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:gn_mobile_monitoring/core/helpers/format_datetime.dart';
import 'package:gn_mobile_monitoring/core/helpers/json_parser_helper.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/visites_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/sites_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/modules_database.dart';
import 'package:gn_mobile_monitoring/data/db/mapper/base_visit_mapper.dart';
import 'package:gn_mobile_monitoring/data/db/mapper/cor_visit_observer_mapper.dart';
import 'package:gn_mobile_monitoring/data/db/mapper/t_visit_complement_mapper.dart';
import 'package:gn_mobile_monitoring/data/entity/base_visit_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/cor_visit_observer_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/visit_complement_entity.dart';
import 'package:gn_mobile_monitoring/data/mapper/visit_complement_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/visit_complement.dart';
import 'package:gn_mobile_monitoring/domain/repository/visit_repository.dart';

class VisitRepositoryImpl implements VisitRepository {
  final VisitesDatabase _visitesDatabase;
  final SitesDatabase _sitesDatabase;
  final ModulesDatabase _modulesDatabase;

  VisitRepositoryImpl(this._visitesDatabase, this._sitesDatabase, this._modulesDatabase);

  @override
  Future<List<BaseVisitEntity>> getAllVisits() async {
    final visits = await _visitesDatabase.getAllVisits();
    // Convertir chaque visite en entité et récupérer les observateurs
    final visitEntities = <BaseVisitEntity>[];

    for (final visit in visits) {
      final baseEntity = visit.toEntity();
      final observers = await getVisitObservers(visit.idBaseVisit);
      final observerIds = observers.map((o) => o.idRole).toList();

      visitEntities.add(BaseVisitEntity(
        idBaseVisit: baseEntity.idBaseVisit,
        idBaseSite: baseEntity.idBaseSite,
        idDataset: baseEntity.idDataset,
        idModule: baseEntity.idModule,
        idDigitiser: baseEntity.idDigitiser,
        visitDateMin: baseEntity.visitDateMin,
        visitDateMax: baseEntity.visitDateMax,
        idNomenclatureTechCollectCampanule:
            baseEntity.idNomenclatureTechCollectCampanule,
        idNomenclatureGrpTyp: baseEntity.idNomenclatureGrpTyp,
        comments: baseEntity.comments,
        uuidBaseVisit: baseEntity.uuidBaseVisit,
        metaCreateDate: baseEntity.metaCreateDate,
        metaUpdateDate: baseEntity.metaUpdateDate,
        serverVisitId: baseEntity.serverVisitId, // 🔧 FIX: Inclure le serverVisitId
        observers: observerIds,
      ));
    }

    return visitEntities;
  }

  @override
  Future<List<BaseVisitEntity>> getVisitsByModuleCode(String moduleCode) async {
    try {
      // 1. Récupérer le module par son code
      final module = await _modulesDatabase.getModuleByCode(moduleCode);
      if (module == null) {
        debugPrint('Module $moduleCode non trouvé');
        return [];
      }
      
      // 2. Récupérer tous les sites du module
      final sites = await _sitesDatabase.getSitesByModuleId(module.id);
      
      if (sites.isEmpty) {
        return [];
      }
      
      // 3. Récupérer toutes les visites de ces sites
      final allVisitEntities = <BaseVisitEntity>[];
      
      for (final site in sites) {
        // Récupérer les visites de ce site spécifiquement pour ce module
        final visits = await _visitesDatabase.getVisitsBySiteIdAndModuleId(site.idBaseSite, module.id);
        
        // Convertir chaque visite en entité avec tous les détails
        for (final visit in visits) {
          final baseEntity = visit.toEntity();
          final observers = await getVisitObservers(visit.idBaseVisit);
          final observerIds = observers.map((o) => o.idRole).toList();

          allVisitEntities.add(BaseVisitEntity(
            idBaseVisit: baseEntity.idBaseVisit,
            idBaseSite: baseEntity.idBaseSite,
            idDataset: baseEntity.idDataset,
            idModule: baseEntity.idModule,
            idDigitiser: baseEntity.idDigitiser,
            visitDateMin: baseEntity.visitDateMin,
            visitDateMax: baseEntity.visitDateMax,
            idNomenclatureTechCollectCampanule:
                baseEntity.idNomenclatureTechCollectCampanule,
            idNomenclatureGrpTyp: baseEntity.idNomenclatureGrpTyp,
            comments: baseEntity.comments,
            uuidBaseVisit: baseEntity.uuidBaseVisit,
            metaCreateDate: baseEntity.metaCreateDate,
            metaUpdateDate: baseEntity.metaUpdateDate,
            serverVisitId: baseEntity.serverVisitId,
            observers: observerIds,
          ));
        }
      }
      
      return allVisitEntities;
    } catch (e) {
      debugPrint('Erreur lors de la récupération des visites du module $moduleCode: $e');
      return [];
    }
  }

  @override
  Future<List<BaseVisitEntity>> getVisitsBySiteIdAndModuleId(
      int siteId, int moduleId) async {
    final visits =
        await _visitesDatabase.getVisitsBySiteIdAndModuleId(siteId, moduleId);

    // Convertir chaque visite en entité avec tous les détails
    final visitEntities = <BaseVisitEntity>[];

    for (final visit in visits) {
      final baseEntity = visit.toEntity();

      // Récupérer les observateurs
      final observers = await getVisitObservers(visit.idBaseVisit);
      final observerIds = observers.map((o) => o.idRole).toList();

      // Récupérer les données complémentaires
      final complementDb =
          await _visitesDatabase.getVisitComplementById(visit.idBaseVisit);
      Map<String, dynamic>? dataMap;

      if (complementDb != null &&
          complementDb.data != null &&
          complementDb.data!.isNotEmpty) {
        // Utiliser le parseur JSON robuste qui gère les cas spéciaux
        dataMap = JsonParserHelper.parseRobust(complementDb.data);
        
        if (dataMap == null) {
          debugPrint('Échec de tous les parsings pour: ${complementDb.data}');
        }
      }

      visitEntities.add(BaseVisitEntity(
        idBaseVisit: baseEntity.idBaseVisit,
        idBaseSite: baseEntity.idBaseSite,
        idDataset: baseEntity.idDataset,
        idModule: baseEntity.idModule,
        idDigitiser: baseEntity.idDigitiser,
        visitDateMin: baseEntity.visitDateMin,
        visitDateMax: baseEntity.visitDateMax,
        idNomenclatureTechCollectCampanule:
            baseEntity.idNomenclatureTechCollectCampanule,
        idNomenclatureGrpTyp: baseEntity.idNomenclatureGrpTyp,
        comments: baseEntity.comments,
        uuidBaseVisit: baseEntity.uuidBaseVisit,
        metaCreateDate: baseEntity.metaCreateDate,
        metaUpdateDate: baseEntity.metaUpdateDate,
        serverVisitId: baseEntity.serverVisitId, // 🔧 FIX: Inclure le serverVisitId
        observers: observerIds,
        data: _processTimeFieldsInDataMap(dataMap),
      ));
    }

    return visitEntities;
  }

  @override
  Future<BaseVisitEntity> getVisitById(int id) async {
    final visit = await _visitesDatabase.getVisitById(id);
    final baseEntity = visit.toEntity();

    // Récupérer les observateurs
    final observers = await getVisitObservers(id);
    final observerIds = observers.map((o) => o.idRole).toList();

    return BaseVisitEntity(
      idBaseVisit: baseEntity.idBaseVisit,
      idBaseSite: baseEntity.idBaseSite,
      idDataset: baseEntity.idDataset,
      idModule: baseEntity.idModule,
      idDigitiser: baseEntity.idDigitiser,
      visitDateMin: baseEntity.visitDateMin,
      visitDateMax: baseEntity.visitDateMax,
      idNomenclatureTechCollectCampanule:
          baseEntity.idNomenclatureTechCollectCampanule,
      idNomenclatureGrpTyp: baseEntity.idNomenclatureGrpTyp,
      comments: baseEntity.comments,
      uuidBaseVisit: baseEntity.uuidBaseVisit,
      metaCreateDate: baseEntity.metaCreateDate,
      metaUpdateDate: baseEntity.metaUpdateDate,
      serverVisitId: baseEntity.serverVisitId, // 🔧 FIX: Inclure le serverVisitId
      observers: observerIds,
    );
  }

  @override
  Future<BaseVisitEntity> getVisitWithFullDetails(int id) async {
    // Récupérer la visite de base
    final visit = await _visitesDatabase.getVisitById(id);
    final baseEntity = visit.toEntity();

    // Récupérer les observateurs
    final observers = await getVisitObservers(id);
    final observerIds = observers.map((o) => o.idRole).toList();

    // Récupérer les données complémentaires
    final complementDb = await _visitesDatabase.getVisitComplementById(id);
    Map<String, dynamic>? dataMap;

    if (complementDb != null &&
        complementDb.data != null &&
        complementDb.data!.isNotEmpty) {
      // Utiliser le parseur JSON robuste qui gère les cas spéciaux
      dataMap = JsonParserHelper.parseRobust(complementDb.data);
      
      if (dataMap == null) {
        debugPrint('Échec de tous les parsings pour: ${complementDb.data}');
      } else {
        debugPrint('Parsing réussi pour les données de visite');
      }
    }

    // Construire l'entité complète avec les données collectées
    return BaseVisitEntity(
      idBaseVisit: baseEntity.idBaseVisit,
      idBaseSite: baseEntity.idBaseSite,
      idDataset: baseEntity.idDataset,
      idModule: baseEntity.idModule,
      idDigitiser: baseEntity.idDigitiser,
      visitDateMin: baseEntity.visitDateMin,
      visitDateMax: baseEntity.visitDateMax,
      idNomenclatureTechCollectCampanule:
          baseEntity.idNomenclatureTechCollectCampanule,
      idNomenclatureGrpTyp: baseEntity.idNomenclatureGrpTyp,
      comments: baseEntity.comments,
      uuidBaseVisit: baseEntity.uuidBaseVisit,
      metaCreateDate: baseEntity.metaCreateDate,
      metaUpdateDate: baseEntity.metaUpdateDate,
      serverVisitId: baseEntity.serverVisitId, // 🔧 FIX: Inclure le serverVisitId
      observers: observerIds,
      data: _processTimeFieldsInDataMap(dataMap),
    );
  }

  /// Traite les champs d'heure dans la carte de données
  Map<String, dynamic>? _processTimeFieldsInDataMap(
      Map<String, dynamic>? dataMap) {
    if (dataMap == null) return null;

    // Créer une nouvelle carte pour stocker les données traitées
    final processedMap = <String, dynamic>{};

    // Parcourir toutes les entrées
    dataMap.forEach((key, value) {
      // Si la clé contient "time" et la valeur est une chaîne, normaliser
      if (key.toLowerCase().contains('time') &&
          !key.toLowerCase().contains('date') &&
          value is String) {
        processedMap[key] = normalizeTimeFormat(value);
      } else {
        processedMap[key] = value;
      }
    });

    return processedMap;
  }

  /// Parse une chaîne de caractères contenant des paires clé-valeur au format "cle: valeur"
  Map<String, dynamic> _parseKeyValuePairs(String content) {
    final result = <String, dynamic>{};

    // Analyse avancée pour gérer les cas spéciaux comme les virgules dans les chaînes
    List<String> parts = [];

    // Utilisation d'une expression régulière pour identifier les paires clé-valeur
    // Cette regex recherche: un mot, suivi par ":", puis une valeur jusqu'à la prochaine virgule
    // qui n'est pas entre guillemets ou accolades
    final regexp = RegExp(r'(\w+)\s*:\s*([^,]+)(?:,|$)');
    final matches = regexp.allMatches(content);

    for (final match in matches) {
      if (match.groupCount >= 2) {
        final key = match.group(1)?.trim();
        final rawValue = match.group(2)?.trim();

        if (key != null && rawValue != null) {
          // Essayer de convertir la valeur en type approprié
          final value = _convertStringToTypedValue(rawValue, keyName: key);
          result[key] = value;
        }
      }
    }

    // Si l'extraction avec regex n'a pas fonctionné, tenter une approche plus simple
    if (result.isEmpty) {
      // Séparer par virgule, puis par deux-points
      parts = content.split(',');

      for (final part in parts) {
        final keyValue = part.split(':');
        if (keyValue.length >= 2) {
          final key = keyValue[0].trim();
          // Joindre le reste au cas où il y aurait des deux-points dans la valeur
          final rawValue = keyValue.sublist(1).join(':').trim();
          final value = _convertStringToTypedValue(rawValue, keyName: key);
          result[key] = value;
        }
      }
    }

    return result;
  }

  /// Tente de convertir une chaîne en valeur typée (int, double, bool, etc.)
  dynamic _convertStringToTypedValue(String rawValue, {String? keyName}) {
    // Suppression des guillemets si présents
    String cleanValue = rawValue.trim();
    if ((cleanValue.startsWith('"') && cleanValue.endsWith('"')) ||
        (cleanValue.startsWith("'") && cleanValue.endsWith("'"))) {
      cleanValue = cleanValue.substring(1, cleanValue.length - 1);
    }

    // Si le nom de clé contient "time" et n'est pas une date, c'est probablement une heure
    if (keyName != null &&
        keyName.toLowerCase().contains('time') &&
        !keyName.toLowerCase().contains('date')) {
      return normalizeTimeFormat(cleanValue);
    }

    // Tentative de conversion en nombre
    if (RegExp(r'^-?\d+$').hasMatch(cleanValue)) {
      return int.parse(cleanValue);
    }
    if (RegExp(r'^-?\d+\.\d+$').hasMatch(cleanValue)) {
      return double.parse(cleanValue);
    }

    // Tentative de conversion en booléen
    if (cleanValue.toLowerCase() == 'true') return true;
    if (cleanValue.toLowerCase() == 'false') return false;
    if (cleanValue.toLowerCase() == 'null') return null;

    // Sinon, retourner la chaîne
    return cleanValue;
  }

  /// Dernière tentative pour parser un dictionnaire, quelle que soit sa forme
  Map<String, dynamic> _forceParseDictionary(String data) {
    final result = <String, dynamic>{};

    try {
      // Retirer les caractères d'ouverture/fermeture et les espaces supplémentaires
      var cleanData = data.trim();
      if (cleanData.startsWith('{')) cleanData = cleanData.substring(1);
      if (cleanData.endsWith('}'))
        cleanData = cleanData.substring(0, cleanData.length - 1);

      // Diviser en fonction des paires clé-valeur que nous pouvons identifier
      final keyValuePattern = RegExp(r'(\w+)\s*:\s*([^,]+)(?=,\s*\w+\s*:|$)');
      final matches = keyValuePattern.allMatches(cleanData);

      for (final match in matches) {
        if (match.groupCount >= 2) {
          final key = match.group(1);
          final value = match.group(2);

          if (key != null && value != null) {
            result[key] = _convertStringToTypedValue(value, keyName: key);
          }
        }
      }

      // Si nous n'avons rien trouvé, essayer une approche plus simple
      if (result.isEmpty) {
        debugPrint('Tentative de parsing agressif');

        // Diviser par virgule
        final parts = cleanData.split(',');
        for (final part in parts) {
          if (part.contains(':')) {
            final keyValue = part.split(':');
            if (keyValue.length >= 2) {
              final key = keyValue[0].trim();
              final value = keyValue[1].trim();
              result[key] = _convertStringToTypedValue(value, keyName: key);
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Erreur dans le parsing agressif: $e');
    }

    return result;
  }

  /// Convertit une chaîne au format dict Python-like en JSON valide pour la sauvegarde
  String _convertToValidJson(String input) {
    // Si c'est déjà un JSON valide, le retourner tel quel
    try {
      jsonDecode(input);
      return input;
    } catch (_) {
      // Ce n'est pas du JSON valide, essayer de le convertir
    }

    // Remplacer la forme "key: value" par "\"key\": value"
    final pattern = RegExp(r'(\w+):\s*');
    return input.replaceAllMapped(pattern, (match) {
      return '"${match.group(1)}": ';
    });
  }

  @override
  Future<int> createVisit(BaseVisitEntity visit) async {
    // 1. Insérer la visite de base
    final visitId = await _visitesDatabase.insertVisit(visit.toCompanion());

    // 2. Si des observateurs sont fournis, les enregistrer
    if (visit.observers != null && visit.observers!.isNotEmpty) {
      final observers = visit.observers!
          .map((id) => CorVisitObserverEntity(
                idBaseVisit: visitId,
                idRole: id,
                uniqueIdCoreVisitObserver: '',
              ))
          .toList();

      await saveVisitObservers(visitId, observers);
    }

    // 3. Si des données complémentaires sont fournies, les enregistrer en utilisant le format JSON standard
    if (visit.data != null && visit.data!.isNotEmpty) {
      try {
        // Pré-traiter les données pour normaliser les heures
        final processedData = _processTimeFieldsInDataMap(visit.data);

        // Encoder les données en JSON standard (identique à la méthode utilisée pour Observation)
        final jsonData = jsonEncode(processedData);
        
        // Sauvegarder directement au format JSON
        final complement = VisitComplementEntity(
          idBaseVisit: visitId,
          data: jsonData,
        );
        await saveVisitComplement(complement);
      } catch (e) {
        debugPrint('Erreur lors de l\'encodage des données en JSON: $e');
        // En cas d'erreur, ne pas bloquer la création de la visite
      }
    }

    return visitId;
  }

  @override
  Future<bool> updateVisit(BaseVisitEntity visit) async {
    // 1. Mettre à jour la visite de base
    final success = await _visitesDatabase.updateVisit(visit.toCompanion());

    if (success) {
      // 2. Mettre à jour les observateurs
      if (visit.observers != null) {
        final observers = visit.observers!
            .map((id) => CorVisitObserverEntity(
                  idBaseVisit: visit.idBaseVisit,
                  idRole: id,
                  uniqueIdCoreVisitObserver: '',
                ))
            .toList();

        await saveVisitObservers(visit.idBaseVisit, observers);
      }

      // 3. Mettre à jour les données complémentaires en utilisant le format JSON standard
      if (visit.data != null) {
        if (visit.data!.isEmpty) {
          // Si les données sont vides, supprimer le complément
          await deleteVisitComplementData(visit.idBaseVisit);
        } else {
          try {
            // Pré-traiter les données pour normaliser les heures
            final processedData = _processTimeFieldsInDataMap(visit.data);

            // Encoder les données en JSON standard (identique à la méthode utilisée pour Observation)
            final jsonData = jsonEncode(processedData);
            
            // Créer et sauvegarder l'entité complément
            final complement = VisitComplementEntity(
              idBaseVisit: visit.idBaseVisit,
              data: jsonData,
            );
            await saveVisitComplement(complement);
          } catch (e) {
            debugPrint('Erreur lors de l\'encodage des données en JSON (update): $e');
            // En cas d'erreur, ne pas bloquer la mise à jour de la visite
          }
        }
      }
    }

    return success;
  }

  /// Convertit une Map en chaîne JSON simple
  /// Cette méthode est utilisée comme solution de secours si jsonEncode échoue
  String _mapToSimpleJsonString(Map<String, dynamic> data) {
    final buffer = StringBuffer('{');
    var first = true;

    data.forEach((key, value) {
      if (!first) {
        buffer.write(',');
      }
      first = false;

      // Échapper les guillemets dans la clé si nécessaire
      final escapedKey = key.replaceAll('"', '\\"');
      buffer.write('"$escapedKey":');

      // Convertir la valeur en fonction de son type
      if (value == null) {
        buffer.write('null');
      } else if (value is num || value is bool) {
        buffer.write(value.toString());
      } else if (value is String) {
        // Si c'est un champ d'heure, normaliser
        if (key.toLowerCase().contains('time') &&
            !key.toLowerCase().contains('date')) {
          final normalizedTime = normalizeTimeFormat(value);
          buffer.write('"$normalizedTime"');
        } else {
          // Échapper les guillemets dans la valeur si nécessaire
          final escapedValue = value.replaceAll('"', '\\"');
          buffer.write('"$escapedValue"');
        }
      } else if (value is List) {
        buffer.write('[');
        var firstItem = true;
        for (final item in value) {
          if (!firstItem) {
            buffer.write(',');
          }
          firstItem = false;

          if (item is String) {
            final escapedItem = item.replaceAll('"', '\\"');
            buffer.write('"$escapedItem"');
          } else {
            buffer.write(item.toString());
          }
        }
        buffer.write(']');
      } else {
        // Pour les autres types, utiliser toString()
        buffer.write('"${value.toString()}"');
      }
    });

    buffer.write('}');
    return buffer.toString();
  }

  @override
  Future<bool> deleteVisit(int id) async {
    try {
      await _visitesDatabase.deleteVisitWithComplement(id);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String?> getVisitComplementData(int visitId) async {
    final complement = await _visitesDatabase.getVisitComplementById(visitId);
    return complement?.data;
  }

  @override
  Future<VisitComplementEntity?> getVisitComplement(int visitId) async {
    final complement = await _visitesDatabase.getVisitComplementById(visitId);
    if (complement == null) {
      return null;
    }
    return TVisitComplementMapper.toEntity(complement);
  }

  @override
  Future<VisitComplement?> getVisitComplementDomain(int visitId) async {
    final entity = await getVisitComplement(visitId);
    if (entity == null) {
      return null;
    }
    return entity.toDomain();
  }

  /// Sauvegarde les données complémentaires d'une visite
  /// [visitId] - ID de la visite
  /// [data] - Chaîne de données au format JSON à sauvegarder
  @override
  Future<void> saveVisitComplementData(int visitId, String data) async {
    // Vérifier que les données sont au format JSON valide
    String validJsonData = data;
    try {
      // Vérifier si le format est valide en essayant de le décoder/encoder
      final decoded = jsonDecode(data);
      validJsonData = jsonEncode(decoded); // Garantit un format JSON standard
    } catch (e) {
      debugPrint('Erreur lors de la validation JSON: $e');
      // En cas d'erreur, utiliser les données telles quelles
    }

    // Créer et sauvegarder l'entité
    final entity = VisitComplementEntity(
      idBaseVisit: visitId,
      data: validJsonData,
    );

    await saveVisitComplement(entity);
  }

  @override
  Future<void> saveVisitComplement(VisitComplementEntity complement) async {
    final companionObj = TVisitComplementMapper.toCompanion(complement);

    try {
      await _visitesDatabase.insertVisitComplement(companionObj);
    } catch (_) {
      // If insert fails (due to unique constraint), try update
      await _visitesDatabase.updateVisitComplement(companionObj);
    }
  }

  @override
  Future<void> saveVisitComplementDomain(VisitComplement complement) async {
    // Convertir le modèle de domaine en entité
    final entity = complement.toEntity();
    await saveVisitComplement(entity);
  }

  /// Vérifie si une chaîne est un JSON valide
  bool _isValidJson(String jsonString) {
    try {
      jsonDecode(jsonString);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> deleteVisitComplementData(int visitId) async {
    await _visitesDatabase.deleteVisitComplement(visitId);
  }

  @override
  Future<List<CorVisitObserverEntity>> getVisitObservers(int visitId) async {
    final observers = await _visitesDatabase.getVisitObservers(visitId);
    if (observers == null || observers.isEmpty) {
      return [];
    }
    return observers
        .map((observer) => CorVisitObserverMapper.toEntity(observer))
        .toList();
  }

  @override
  Future<void> saveVisitObservers(
      int visitId, List<CorVisitObserverEntity> observers) async {
    final observerCompanions = observers
        .map((entity) => CorVisitObserverMapper.toCompanion(entity))
        .toList();
    await _visitesDatabase.replaceVisitObservers(visitId, observerCompanions);
  }

  @override
  Future<int> addVisitObserver(int visitId, int observerId) async {
    final entity = CorVisitObserverEntity(
      idBaseVisit: visitId,
      idRole: observerId,
      uniqueIdCoreVisitObserver:
          '', // L'ID sera généré automatiquement par la base de données
    );
    return _visitesDatabase
        .insertVisitObserver(CorVisitObserverMapper.toCompanion(entity));
  }

  @override
  Future<void> clearVisitObservers(int visitId) async {
    await _visitesDatabase.deleteVisitObservers(visitId);
  }

  @override
  Future<void> updateVisitServerId(int localVisitId, int serverId) async {
    await _visitesDatabase.updateVisitServerId(localVisitId, serverId);
  }
}