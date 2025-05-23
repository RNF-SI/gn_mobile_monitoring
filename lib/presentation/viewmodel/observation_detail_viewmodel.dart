import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_observation_detail_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_observation_detail_by_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_observation_details_by_observation_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/save_observation_detail_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/form_data_processor.dart';

/// Provider pour accéder aux détails d'observation pour une observation spécifique
final observationDetailsProvider = StateNotifierProvider.family<
    ObservationDetailViewModel,
    AsyncValue<List<ObservationDetail>>,
    int>((ref, observationId) {
  final getObservationDetailsByObservationIdUseCase =
      ref.watch(getObservationDetailsByObservationIdUseCaseProvider);
  final getObservationDetailByIdUseCase =
      ref.watch(getObservationDetailByIdUseCaseProvider);
  final saveObservationDetailUseCase =
      ref.watch(saveObservationDetailUseCaseProvider);
  final deleteObservationDetailUseCase =
      ref.watch(deleteObservationDetailUseCaseProvider);
  final formDataProcessor =
      ref.watch(formDataProcessorProvider);

  return ObservationDetailViewModel(
    getObservationDetailsByObservationIdUseCase,
    getObservationDetailByIdUseCase,
    saveObservationDetailUseCase,
    deleteObservationDetailUseCase,
    formDataProcessor,
    observationId,
  );
});

final observationDetailViewModelProvider =
    Provider<ObservationDetailViewModel>((ref) {
  return ref.read(observationDetailsProvider(0).notifier);
});

class ObservationDetailViewModel
    extends StateNotifier<AsyncValue<List<ObservationDetail>>> {
  final GetObservationDetailsByObservationIdUseCase
      _getObservationDetailsByObservationIdUseCase;
  final GetObservationDetailByIdUseCase _getObservationDetailByIdUseCase;
  final SaveObservationDetailUseCase _saveObservationDetailUseCase;
  final DeleteObservationDetailUseCase _deleteObservationDetailUseCase;
  final FormDataProcessor _formDataProcessor;

  final int _observationId;
  bool _mounted = true;

  ObservationDetailViewModel(
    this._getObservationDetailsByObservationIdUseCase,
    this._getObservationDetailByIdUseCase,
    this._saveObservationDetailUseCase,
    this._deleteObservationDetailUseCase,
    this._formDataProcessor,
    this._observationId,
  ) : super(const AsyncValue.loading()) {
    if (_observationId > 0) {
      loadObservationDetails();
    }
  }

  /// Charge tous les détails pour l'observation courante
  Future<void> loadObservationDetails() async {
    if (!_mounted) return;

    try {
      state = const AsyncValue.loading();
      final details = await _getObservationDetailsByObservationIdUseCase
          .execute(_observationId);
          
      // Traiter les données pour l'affichage
      final processedDetails = await Future.wait(
        details.map((detail) async {
          final processedData = await _formDataProcessor.processFormDataForDisplay(detail.data);
          return detail.copyWith(data: processedData);
        })
      );
      
      if (_mounted) {
        state = AsyncValue.data(processedDetails);
      }
    } catch (e, stack) {
      if (_mounted) {
        state = AsyncValue.error(e, stack);
      }
    }
  }

  /// Récupère tous les détails d'une observation par son ID
  Future<List<ObservationDetail>> getObservationDetailsByObservationId(
      int observationId) async {
    try {
      final details = await _getObservationDetailsByObservationIdUseCase
          .execute(observationId);
          
      // Traiter les données pour l'affichage
      final processedDetails = await Future.wait(
        details.map((detail) async {
          final processedData = await _formDataProcessor.processFormDataForDisplay(detail.data);
          return detail.copyWith(data: processedData);
        })
      );
      
      return processedDetails;
    } catch (e) {
      debugPrint(
          'Erreur lors de la récupération des détails d\'observation: $e');
      return [];
    }
  }

  /// Récupère un détail d'observation par son ID
  Future<ObservationDetail?> getObservationDetailById(int detailId) async {
    try {
      final detail = await _getObservationDetailByIdUseCase.execute(detailId);
      
      if (detail != null) {
        // Convertir les IDs de nomenclature en objets pour l'affichage
        final processedData = await _formDataProcessor.processFormDataForDisplay(detail.data);
        
        // Créer un nouvel objet avec les données traitées
        return detail.copyWith(data: processedData);
      }
      
      return detail;
    } catch (e) {
      debugPrint('Erreur lors de la récupération du détail d\'observation: $e');
      return null;
    }
  }

  /// Sauvegarde un détail d'observation
  Future<int> saveObservationDetail(ObservationDetail detail) async {
    try {
      debugPrint('Sauvegarde d\'un détail d\'observation: ID=${detail.idObservationDetail}, ID Observation=${detail.idObservation}');
      debugPrint('Données avant traitement: ${detail.data.length} entrées, clés: ${detail.data.keys.join(', ')}');
      
      // Traiter les données pour convertir les nomenclatures en ID
      final processedData = await _formDataProcessor.processFormData(detail.data);
      
      debugPrint('Données après traitement: ${processedData.length} entrées, clés: ${processedData.keys.join(', ')}');
      
      // Vérifier si les données contiennent des valeurs non-sérialisables
      _validateJsonData(processedData);
      
      // Créer un nouvel objet avec les données traitées
      final processedDetail = detail.copyWith(data: processedData);
      
      // Sauvegarder le détail d'observation avec les données traitées
      final result = await _saveObservationDetailUseCase.execute(processedDetail);
      
      debugPrint('Détail d\'observation sauvegardé avec ID: $result');
      
      // Recharger les détails après la sauvegarde
      await loadObservationDetails();
      return result;
    } catch (e, stackTrace) {
      debugPrint('Erreur lors de la sauvegarde du détail d\'observation: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }
  
  /// Valide que les données peuvent être sérialisées en JSON
  void _validateJsonData(Map<String, dynamic> data) {
    try {
      // Tenter de sérialiser les données
      final jsonString = jsonEncode(data);
      debugPrint('Validation JSON réussie: ${jsonString.length} caractères');
    } catch (e) {
      debugPrint('ERREUR: Les données ne peuvent pas être sérialisées en JSON: $e');
      
      // Identifier les champs problématiques
      for (final entry in data.entries) {
        try {
          final json = jsonEncode({entry.key: entry.value});
        } catch (entryError) {
          debugPrint('Champ problématique: ${entry.key}, valeur: ${entry.value}, type: ${entry.value.runtimeType}');
          
          // Si la valeur est un objet complexe, tenter de l'analyser en profondeur
          if (entry.value is Map) {
            _analyzeMapForJsonIssues(entry.key, entry.value as Map);
          } else if (entry.value is List) {
            _analyzeListForJsonIssues(entry.key, entry.value as List);
          }
        }
      }
    }
  }
  
  /// Analyse un Map pour trouver des problèmes de sérialisation JSON
  void _analyzeMapForJsonIssues(String path, Map map) {
    for (final key in map.keys) {
      final value = map[key];
      final currentPath = '$path.$key';
      
      try {
        jsonEncode({key.toString(): value});
      } catch (e) {
        debugPrint('Problème à: $currentPath, valeur: $value, type: ${value.runtimeType}');
        
        if (value is Map) {
          _analyzeMapForJsonIssues(currentPath, value);
        } else if (value is List) {
          _analyzeListForJsonIssues(currentPath, value);
        }
      }
    }
  }
  
  /// Analyse une Liste pour trouver des problèmes de sérialisation JSON
  void _analyzeListForJsonIssues(String path, List list) {
    for (int i = 0; i < list.length; i++) {
      final value = list[i];
      final currentPath = '$path[$i]';
      
      try {
        jsonEncode([value]);
      } catch (e) {
        debugPrint('Problème à: $currentPath, valeur: $value, type: ${value.runtimeType}');
        
        if (value is Map) {
          _analyzeMapForJsonIssues(currentPath, value);
        } else if (value is List) {
          _analyzeListForJsonIssues(currentPath, value);
        }
      }
    }
  }

  /// Supprime un détail d'observation
  Future<bool> deleteObservationDetail(int detailId) async {
    try {
      final success = await _deleteObservationDetailUseCase.execute(detailId);
      if (success) {
        // Recharger les détails après la suppression
        await loadObservationDetails();
      }
      return success;
    } catch (e) {
      debugPrint('Erreur lors de la suppression du détail d\'observation: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}
