import 'package:gn_mobile_monitoring/data/entity/cor_visit_observer_entity.dart';
import 'package:gn_mobile_monitoring/data/mapper/visite_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/repository/visit_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_visit_use_case.dart';

class UpdateVisitUseCaseImpl implements UpdateVisitUseCase {
  final VisitRepository _visitRepository;

  const UpdateVisitUseCaseImpl(this._visitRepository);

  @override
  Future<bool> execute(BaseVisit visit) async {
    // Convertir le modèle de domaine en entité
    final visitEntity = visit.toEntity();
    
    // Mettre à jour la visite dans la base de données
    final success = await _visitRepository.updateVisit(visitEntity);
    
    // Si la mise à jour a réussi, mettre à jour les données associées
    if (success) {
      // Si la visite a des données complémentaires, les sauvegarder
      if (visit.data != null && visit.data!.isNotEmpty) {
        await _visitRepository.saveVisitComplementData(
          visit.idBaseVisit,
          visit.data.toString(),
        );
      }
      
      // Si la visite a des observateurs, mettre à jour la liste
      if (visit.observers != null) {
        // Supprimer les observateurs existants
        await _visitRepository.clearVisitObservers(visit.idBaseVisit);
        
        // Ajouter les nouveaux observateurs si la liste n'est pas vide
        if (visit.observers!.isNotEmpty) {
          final observers = visit.observers!.map((observerId) => 
            CorVisitObserverEntity(
              idBaseVisit: visit.idBaseVisit,
              idRole: observerId,
              uniqueIdCoreVisitObserver: '',
            )
          ).toList();
          
          await _visitRepository.saveVisitObservers(visit.idBaseVisit, observers);
        }
      }
    }
    
    return success;
  }
}