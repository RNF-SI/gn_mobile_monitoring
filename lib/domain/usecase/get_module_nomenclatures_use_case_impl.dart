import 'dart:convert';

import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_module_nomenclatures_use_case.dart';

class GetModuleNomenclaturesUseCaseImpl implements GetModuleNomenclaturesUseCase {
  final ModulesRepository _repository;

  GetModuleNomenclaturesUseCaseImpl(this._repository);

  @override
  Future<List<Nomenclature>> execute(int moduleId) async {
    try {
      // 1. Récupérer le module avec sa configuration
      final module = await _repository.getModuleWithConfig(moduleId);
      
      // Vérifier si le moduleCode est disponible
      if (module.moduleCode == null) {
        throw Exception('Module code not available for module with ID: $moduleId');
      }
      
      // 2. Récupérer la configuration complète du module
      final config = await _repository.getModuleConfiguration(module.moduleCode!);
      
      // 3. Extraire les types de nomenclatures nécessaires depuis la configuration
      final nomenclatureTypes = _extractNomenclatureTypes(config);
      
      if (nomenclatureTypes.isEmpty) {
        return [];
      }
      
      // 4. Récupérer le mapping des types de nomenclatures
      final typeMapping = await _repository.getNomenclatureTypeMapping();
      
      // 5. Convertir les codes de type en IDs
      final typeIds = nomenclatureTypes
          .where((type) => typeMapping.containsKey(type))
          .map((type) => typeMapping[type]!)
          .toSet();
      
      if (typeIds.isEmpty) {
        return [];
      }
      
      // 6. Récupérer toutes les nomenclatures
      final allNomenclatures = await _repository.getNomenclatures();
      
      // 7. Filtrer les nomenclatures par les types nécessaires
      return allNomenclatures
          .where((nomenclature) => typeIds.contains(nomenclature.idType))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Extrait les types de nomenclature depuis la configuration du module
  Set<String> _extractNomenclatureTypes(ModuleConfiguration config) {
    final Set<String> types = {};
    
    // 1. Extraire depuis data.nomenclature
    if (config.data?.nomenclature != null) {
      types.addAll(config.data!.nomenclature!);
    }
    
    // 2. Extraire depuis les champs génériques des objets
    // Pour chaque type d'objet (module, site, visit, etc.)
    _extractFromGeneric(types, config.module?.generic);
    _extractFromGeneric(types, config.site?.generic);
    _extractFromGeneric(types, config.visit?.generic);
    _extractFromGeneric(types, config.observation?.generic);
    _extractFromGeneric(types, config.observationDetail?.generic);
    _extractFromGeneric(types, config.sitesGroup?.generic);
    
    return types;
  }
  
  /// Extrait les types de nomenclature depuis les champs génériques
  void _extractFromGeneric(Set<String> types, Map<String, GenericFieldConfig>? genericFields) {
    if (genericFields == null) return;
    
    for (final field in genericFields.values) {
      // Si c'est un champ de type nomenclature avec une API spécifiée
      if (field.typeUtil == 'nomenclature' && field.api != null) {
        // Extraire le code de type de nomenclature depuis l'API
        // Format typique: 'nomenclatures/nomenclature/TYPE_XXX'
        final apiParts = field.api!.split('/');
        if (apiParts.length >= 3) {
          final typeCode = apiParts.last;
          types.add(typeCode);
        }
      }
    }
  }
}