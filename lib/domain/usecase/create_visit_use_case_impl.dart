import 'package:gn_mobile_monitoring/data/entity/cor_visit_observer_entity.dart';
import 'package:gn_mobile_monitoring/data/mapper/visite_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/repository/visit_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_visit_use_case.dart';

class CreateVisitUseCaseImpl implements CreateVisitUseCase {
  final VisitRepository _visitRepository;

  const CreateVisitUseCaseImpl(this._visitRepository);

  @override
  Future<int> execute(BaseVisit visit) async {
    // Convertir le modèle de domaine en entité
    final visitEntity = visit.toEntity();
    
    // Créer la visite dans la base de données
    final visitId = await _visitRepository.createVisit(visitEntity);
    
    // Si la visite a des données complémentaires, les sauvegarder
    if (visit.data != null && visit.data!.isNotEmpty) {
      await _visitRepository.saveVisitComplementData(
        visitId,
        visit.data.toString(),
      );
    }
    
    // Si la visite a des observateurs, les sauvegarder
    if (visit.observers != null && visit.observers!.isNotEmpty) {
      final observers = visit.observers!.map((observerId) => 
        CorVisitObserverEntity(
          idBaseVisit: visitId,
          idRole: observerId,
          uniqueIdCoreVisitObserver: '',
        )
      ).toList();
      
      await _visitRepository.saveVisitObservers(visitId, observers);
    }
    
    return visitId;
  }
}