import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/database/db.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/taxon_database.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_conflict.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon_list.dart';

class TaxonDatabaseImpl implements TaxonDatabase {
  Future<AppDatabase> get _database async => await DB.instance.database;

  @override
  Future<List<Taxon>> getAllTaxons() async {
    final db = await _database;
    return db.taxonDao.getAllTaxons();
  }

  @override
  Future<List<Taxon>> getTaxonsByListId(int idListe) async {
    final db = await _database;
    return db.taxonDao.getTaxonsByListId(idListe);
  }

  @override
  Future<Taxon?> getTaxonByCdNom(int cdNom) async {
    final db = await _database;
    return db.taxonDao.getTaxonByCdNom(cdNom);
  }

  @override
  Future<List<Taxon>> searchTaxons(String searchTerm) async {
    final db = await _database;
    return db.taxonDao.searchTaxons(searchTerm);
  }

  @override
  Future<List<Taxon>> searchTaxonsByListId(
      String searchTerm, int idListe) async {
    final db = await _database;
    return db.taxonDao.searchTaxonsByListId(searchTerm, idListe);
  }

  @override
  Future<void> saveTaxon(Taxon taxon) async {
    final db = await _database;
    return db.taxonDao.insertTaxon(taxon);
  }

  @override
  Future<void> saveTaxons(List<Taxon> taxons) async {
    final db = await _database;
    return db.taxonDao.insertTaxons(taxons);
  }

  @override
  Future<void> clearTaxons() async {
    final db = await _database;
    return db.taxonDao.clearTaxons();
  }

  @override
  Future<List<TaxonList>> getAllTaxonLists() async {
    final db = await _database;
    return db.taxonDao.getAllTaxonLists();
  }

  @override
  Future<TaxonList?> getTaxonListById(int idListe) async {
    final db = await _database;
    return db.taxonDao.getTaxonListById(idListe);
  }

  @override
  Future<void> saveTaxonLists(List<TaxonList> lists) async {
    final db = await _database;
    return db.taxonDao.insertTaxonLists(lists);
  }

  @override
  Future<void> clearTaxonLists() async {
    final db = await _database;
    return db.taxonDao.clearTaxonLists();
  }

  @override
  Future<void> saveTaxonsToList(int idListe, List<int> cdNoms) async {
    final db = await _database;
    return db.taxonDao.linkTaxonsToList(idListe, cdNoms);
  }

  @override
  Future<void> clearCorTaxonListe() async {
    final db = await _database;
    return db.taxonDao.clearCorTaxonListe();
  }

  @override
  Future<SyncResult> saveTaxonsWithSync(
      List<Map<String, dynamic>> taxons) async {
    final db = await _database;
    int added = 0;
    int updated = 0;
    int skipped = 0;
    int failed = 0;

    for (final taxonData in taxons) {
      try {
        // Extraire cd_nom comme identifiant unique
        final cdNom = taxonData['cd_nom'] as int?;
        if (cdNom == null) {
          skipped++;
          continue;
        }

        // Vérifier si le taxon existe déjà
        final existingTaxon = await db.taxonDao.getTaxonByCdNom(cdNom);

        // Convertir les données en objet Taxon
        final taxon = Taxon(
          cdNom: cdNom,
          cdRef: taxonData['cd_ref'],
          idStatut: taxonData['id_statut'],
          idHabitat: taxonData['id_habitat'],
          idRang: taxonData['id_rang'],
          regne: taxonData['regne'],
          phylum: taxonData['phylum'],
          classe: taxonData['classe'],
          ordre: taxonData['ordre'],
          famille: taxonData['famille'],
          sousFamille: taxonData['sous_famille'],
          tribu: taxonData['tribu'],
          cdTaxsup: taxonData['cd_taxsup'],
          cdSup: taxonData['cd_sup'],
          lbNom: taxonData['lb_nom'],
          lbAuteur: taxonData['lb_auteur'],
          nomComplet: taxonData['nom_complet'] ?? 'Sans nom',
          nomCompletHtml: taxonData['nom_complet_html'],
          nomVern: taxonData['nom_vern'],
          nomValide: taxonData['nom_valide'],
          nomVernEng: taxonData['nom_vern_eng'],
          group1Inpn: taxonData['group1_inpn'],
          group2Inpn: taxonData['group2_inpn'],
          group3Inpn: taxonData['group3_inpn'],
          url: taxonData['url'],
        );

        if (existingTaxon != null) {
          // Mise à jour
          updated++;
        } else {
          // Ajout
          added++;
        }

        // Dans les deux cas, on utilise la même méthode pour sauvegarder
        await db.taxonDao.insertTaxon(taxon);
      } catch (e) {
        failed++;
        print('Erreur lors de la sauvegarde du taxon: $e');
      }
    }

    return SyncResult.success(
      itemsProcessed: taxons.length,
      itemsAdded: added,
      itemsUpdated: updated,
      itemsSkipped: skipped,
      itemsFailed: failed,
    );
  }

  @override
  Future<List<Taxon>> getPendingTaxons() async {
    // Cette méthode est pertinente uniquement si les taxons peuvent être modifiés localement
    // et doivent être synchronisés avec le serveur
    // Pour cet exemple, on considère qu'il n'y a pas de taxons en attente de synchronisation
    // car ils sont généralement uniquement importés depuis le serveur
    return [];
  }

  @override
  Future<void> markTaxonSynced(int cdNom, DateTime syncDate) async {
    final db = await _database;

    // Mettre à jour le statut de synchronisation si nécessaire
    // Par exemple, si on ajoute un champ pour suivre la synchronisation:
    await db.customUpdate(
      'UPDATE t_taxrefs SET sync_date = ? WHERE cd_nom = ?',
      variables: [
        Variable(syncDate.toIso8601String()),
        Variable(cdNom),
      ],
    );
  }

  @override
  Future<List<SyncConflict>> checkTaxonReferencesInDatabaseObservations(
      int cdNom,
      {Set<int>? removedFromListIds}) async {
    final db = await _database;
    final conflicts = <SyncConflict>[];
    final taxon = await getTaxonByCdNom(cdNom);

    if (taxon == null) {
      debugPrint('Taxon with cd_nom $cdNom not found');
      return conflicts;
    }

    try {
      // Vérifier les références dans les observations (cd_nom)
      final observations =
          await db.observationDao.getObservationsByCdNom(cdNom);

      for (final observation in observations) {
        try {
          // Récupérer les données de contexte complètes
          final visit = observation.idBaseVisit != null
              ? await db.visitesDao.getVisitById(observation.idBaseVisit!)
              : null;
          final site = visit != null && visit.idBaseSite != null
              ? await db.sitesDao.getSiteById(visit.idBaseSite!)
              : null;
          final module = visit != null && visit.idModule != null
              ? await db.modulesDao.getModuleById(visit.idModule)
              : null;

          // Vérifier si le module existe et récupérer son ID de liste taxonomique
          int? moduleTaxonomyListId;
          if (module != null) {
            moduleTaxonomyListId =
                await db.modulesDao.getModuleTaxonomyListId(module.id);
          }

          // Déterminer s'il faut créer un conflit basé sur l'appartenance à la liste taxonomique
          bool shouldCreateConflict = false;

          // Si removedFromListIds est spécifié, vérifier si la liste taxonomique du module
          // est parmi les listes d'où le taxon a été supprimé
          if (removedFromListIds != null && moduleTaxonomyListId != null) {
            shouldCreateConflict =
                removedFromListIds.contains(moduleTaxonomyListId);
            if (shouldCreateConflict) {
              debugPrint(
                  'Taxon $cdNom supprimé de la liste $moduleTaxonomyListId utilisée par le module ${module!.id} - conflit détecté');
            }
          } else {
            // Si pas d'info sur les listes spécifiques ou pas d'ID de liste pour le module,
            // on crée un conflit par défaut (comportement précédent)
            shouldCreateConflict = true;
          }

          // Ne créer un conflit que si nécessaire
          if (shouldCreateConflict) {
            // Construire une route avec tous les éléments du contexte
            String navigationPath;
            if (visit != null && site != null && module != null) {
              // Chemin complet avec toutes les informations de contexte
              navigationPath =
                  '/module/${module.id}/site/${site.idBaseSite}/visit/${visit.idBaseVisit}/observation/${observation.idObservation}';
            } else {
              // Chemin de secours si une partie du contexte est manquante
              navigationPath = '/observations/${observation.idObservation}';
            }

            // Récupérer les données complémentaires de l'observation
            final complement = await db.observationDao
                .getObservationComplementById(observation.idObservation);

            // Données à inclure dans le conflit
            Map<String, dynamic> dataMap = {};
            if (complement != null && complement.data != null) {
              try {
                dataMap = jsonDecode(complement.data!);
              } catch (e) {
                debugPrint('Error parsing observation data: $e');
              }
            }

            // Ajouter les données de contexte pour affichage
            Map<String, dynamic> enhancedData = {
              ...dataMap,
              '_context': {
                'module': module?.moduleLabel ?? 'Inconnu',
                'module_id': module?.id ?? 0,
                'module_taxonomy_list_id': moduleTaxonomyListId,
                'site': site?.baseSiteName ?? 'Inconnu',
                'site_id': site?.idBaseSite ?? 0,
                'visit': visit?.idBaseVisit ?? 0,
                'observation': observation.idObservation,
                'taxon': {
                  'cd_nom': taxon.cdNom,
                  'nom_complet': taxon.nomComplet,
                  'nom_vern': taxon.nomVern ?? '',
                }
              }
            };

            // Créer un conflit pour cette observation
            conflicts.add(SyncConflict(
              entityId: observation.idObservation.toString(),
              entityType: 'observation',
              localData: enhancedData,
              remoteData: {},
              localModifiedAt: DateTime.now(),
              remoteModifiedAt: DateTime.now(),
              resolutionStrategy: ConflictResolutionStrategy.userDecision,
              conflictType: ConflictType.deletedReference,
              referencedEntityType: 'taxon',
              referencedEntityId: cdNom.toString(),
              affectedField: 'observation.cdNom',
              navigationPath: navigationPath,
            ));
          }
        } catch (e) {
          debugPrint(
              'Error creating conflict for observation ${observation.idObservation}: $e');
        }
      }

      // Vérifier les détails d'observation qui référencent ce taxon
      // Chercher dans les champs JSON pour les références au cd_nom
      final observationDetails =
          await db.observationDetailDao.getAllObservationDetails();

      for (final detail in observationDetails) {
        if (detail.data != null) {
          try {
            final Map<String, dynamic> dataMap = jsonDecode(detail.data!);

            // Vérifier si les données contiennent une référence au cd_nom
            // Ceci est une approche simplifiée. Dans une application réelle,
            // vous devriez avoir une logique plus précise pour identifier les références aux taxons
            bool containsTaxonReference = false;

            // Recherche ricursive de références au taxon dans les données JSON
            void searchForTaxonReference(dynamic data) {
              if (data is Map) {
                for (var entry in data.entries) {
                  if (entry.key == 'cd_nom' && entry.value == cdNom) {
                    containsTaxonReference = true;
                    return;
                  } else if (entry.value is Map || entry.value is List) {
                    searchForTaxonReference(entry.value);
                  }
                }
              } else if (data is List) {
                for (var item in data) {
                  searchForTaxonReference(item);
                }
              }
            }

            searchForTaxonReference(dataMap);

            if (containsTaxonReference) {
              // Récupérer les données de contexte
              final observation = detail.idObservation != null
                  ? await db.observationDao
                      .getObservationById(detail.idObservation!)
                  : null;
              final visit = observation?.idBaseVisit != null
                  ? await db.visitesDao.getVisitById(observation!.idBaseVisit!)
                  : null;
              final site = visit?.idBaseSite != null
                  ? await db.sitesDao.getSiteById(visit!.idBaseSite!)
                  : null;
              final module = visit != null && visit.idModule != null
                  ? await db.modulesDao.getModuleById(visit.idModule)
                  : null;

              // Construire une route avec tous les éléments du contexte
              String navigationPath;
              if (observation != null &&
                  visit != null &&
                  site != null &&
                  module != null) {
                navigationPath =
                    '/module/${module.id}/site/${site.idBaseSite}/visit/${visit.idBaseVisit}/observation/${observation.idObservation}/detail/${detail.idObservationDetail}';
              } else {
                navigationPath =
                    '/observation-details/${detail.idObservationDetail}';
              }

              // Ajouter les données de contexte pour affichage
              Map<String, dynamic> enhancedData = {
                ...dataMap,
                '_context': {
                  'module': module?.moduleLabel ?? 'Inconnu',
                  'module_id': module?.id ?? 0,
                  'site': site?.baseSiteName ?? 'Inconnu',
                  'site_id': site?.idBaseSite ?? 0,
                  'visit': visit?.idBaseVisit ?? 0,
                  'observation': observation?.idObservation ?? 0,
                  'detail': detail.idObservationDetail,
                  'taxon': {
                    'cd_nom': taxon.cdNom,
                    'nom_complet': taxon.nomComplet,
                    'nom_vern': taxon.nomVern ?? '',
                  }
                }
              };

              conflicts.add(SyncConflict(
                entityId: detail.idObservationDetail.toString(),
                entityType: 'observationDetail',
                localData: enhancedData,
                remoteData: {},
                localModifiedAt: DateTime.now(),
                remoteModifiedAt: DateTime.now(),
                resolutionStrategy: ConflictResolutionStrategy.userDecision,
                conflictType: ConflictType.deletedReference,
                referencedEntityType: 'taxon',
                referencedEntityId: cdNom.toString(),
                affectedField: 'observationDetail.data',
                navigationPath: navigationPath,
              ));
            }
          } catch (e) {
            debugPrint(
                'Error checking observation detail data for taxon references: $e');
          }
        }
      }
    } catch (e) {
      debugPrint('Error checking taxon references: $e');
    }

    // Log the number of conflicts found before returning
    if (conflicts.isNotEmpty) {
      debugPrint('Found ${conflicts.length} taxon reference conflicts');
      for (int i = 0; i < conflicts.length; i++) {
        final conflict = conflicts[i];
        debugPrint(
            'Conflict $i: EntityType=${conflict.entityType}, EntityId=${conflict.entityId}, Path=${conflict.navigationPath}');
      }
    } else {
      debugPrint('No taxon reference conflicts found for cd_nom $cdNom');
    }

    return conflicts;
  }

  @override
  Future<void> deleteTaxon(int cdNom) async {
    final db = await _database;
    await db.taxonDao.deleteTaxon(cdNom);
  }
}
